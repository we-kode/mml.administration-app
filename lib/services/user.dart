import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/services/api.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:mml_admin/view_models/login.dart';

class UserService {
  static final UserService _instance = UserService._();
  late ApiService _apiService;

  UserService._() {
    _apiService = ApiService.getInstance();
  }

  static UserService getInstance() {
    return _instance;
  }

  Future<List<User>> getUsers(/* user filter*/) async {
    throw UnimplementedError();
  }

  Future<User> getUser(int id) async {
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

  Future login(String username, String password) async {
    var clientId = await SecureStorageService.getInstance().get(SecureStorageService.clientIdStorageKey);

    Response<Map> response = await _apiService.request(
      '/identity/connect/token',
      data: {
        'grant_type': 'password',
        'client_id': clientId,
        'scope': 'offline_access',
        'username': username,
        'password': password
      },
      options: Options(
        method: 'POST',
        contentType: Headers.formUrlEncodedContentType,
      )
    );

    if (response.statusCode == HttpStatus.ok) {
      await SecureStorageService.getInstance().set(SecureStorageService.accessTokenStorageKey, response.data?['access_token']);
      await SecureStorageService.getInstance().set(SecureStorageService.refreshTokenStorageKey, response.data?['refresh_token']);
    }
  }

  Future logout() async {
    try {
      await _apiService.request(
        '/identity/connect/logout',
        data: {},
        options: Options(
          method: 'POST',
          contentType: Headers.formUrlEncodedContentType,
        )
      );
    } finally {
      await SecureStorageService.getInstance().delete(SecureStorageService.accessTokenStorageKey);
      await SecureStorageService.getInstance().delete(SecureStorageService.refreshTokenStorageKey);

      RouterService.getInstance().navigatorKey.currentState!.pushNamed(LoginViewModel.route);
    }
  }

  Future<User?> getUserInfo() async {
    if (await SecureStorageService.getInstance().has(SecureStorageService.accessTokenStorageKey)) {
      var response = await _apiService.request(
        '/identity/connect/userinfo',
        options: Options(method: 'GET')
      );

      return User.fromJson(jsonDecode(response.data));
    }

    return null;
  }
}
