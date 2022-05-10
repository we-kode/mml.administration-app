import 'package:dio/dio.dart';
import 'package:mml_admin/constants/http_status_codes.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/secure_storage.dart';

class UserService {
  static final UserService _instance = UserService._();
  late ApiService _apiService;

  UserService._() {
    _apiService = ApiService.getInstance();
  }

  static UserService getInstance() {
    return _instance;
  }

  Future<List<UserModel>> getUsers(/* user filter*/) async {
    throw UnimplementedError();
  }

  Future<UserModel> getUser(int id) async {
    throw UnimplementedError();
  }

  Future<bool> deleteUser(int id) async {
    throw UnimplementedError();
  }

  Future<bool> createUser() async {
    throw UnimplementedError();
  }

  Future<bool> updateUser(int? id) async {
    throw UnimplementedError();
  }

  Future<bool> login(String username, String password) async {
    var clientId = await SecureStorageService.getInstance().get(SecureStorageService.clientIdStorageKey);

    Response<Map> response = await _apiService.request(
      '/identity/connect/token',
      data: FormData.fromMap({
        'grant_type': 'password',
        'client_id': clientId,
        'scope': 'offline_access',
        'username': username,
        'password': password
      }),
      options: Options(method: 'POST')
    );

    if (response.statusCode == HttpStatusCodes.ok) {
      SecureStorageService.getInstance().set(SecureStorageService.accessTokenStorageKey, response.data?['access_token']);
      SecureStorageService.getInstance().set(SecureStorageService.refreshTokenStorageKey, response.data?['refresh_token']);

      return true;
    }

    return false;
  }

  Future<bool> isAuthenticated() async {
    if (await SecureStorageService.getInstance().has(SecureStorageService.accessTokenStorageKey)) {
      var response = await _apiService.request(
        '/identity/connect/userinfo',
        options: Options(method: 'GET')
      );

      return response.statusCode == HttpStatusCodes.ok;
    }

    return false;
  }
}
