import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/user.dart';

/// View model for the users overview screen.
class UsersViewModel extends ChangeNotifier {
  /// Route for the users overview screen.
  static String route = '/users';

  Future<ModelList> loadUsers({String? filter, int? offset, int? take}) async {
    return Future.delayed(Duration(seconds: 2), () => ModelList(List<User>.generate(take ?? 100, (i) => User(id: (offset ?? 0) + i, name: "User ${(offset ?? 0) + i}")), offset ?? 0, 1000));
  }

  Future<void> deleteUsers<int>(List<int> userIds) async {
    return Future.delayed(Duration(seconds: 2));
  }

  Future<void> addUser() async {
    print("Add user");
  }

  Future<void> editUser(ModelBase user) async {
    print(user);
  }
}
