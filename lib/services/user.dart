import 'package:mml_admin/models/user.dart';

class UserService {
  static final UserService _instance = UserService();

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

  Future<bool> login(String username, String password, String clientId, String serverName) async {
    throw UnimplementedError();
  }
}
