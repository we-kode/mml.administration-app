import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/user.dart';

/// View model for the users overview screen.
class UsersViewModel extends ChangeNotifier {
  /// Route for the users overview screen.
  static String route = '/users';

  Future<ModelList> loadUsers({String? filter, int? offset, int? take}) async {
    return Future.delayed(Duration(seconds: 10), () => ModelList([User(name: "Test")], 1));
  }

  Future<void> deleteUsers(List<ModelBase> users) async {
    print(users);
  }

  Future<void> addUser() async {
    print("Add user");
  }

  Future<void> editUser(ModelBase user) async {
    print(user);
  }
}
