import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/services/user.dart';

/// View model for the users overview screen.
class UsersViewModel extends ChangeNotifier {
  /// Route for the users overview screen.
  static String route = '/users';

  ///
  final UserService _userService = UserService.getInstance();

  /// Loads the user with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> loadUsers({String? filter, int? offset, int? take}) async {
    return await _userService.getUsers(filter, offset, take);
  }

  /// Deletes the users with the passed [userIds] or or aborts, if the user
  /// cancels the operation.
  Future<bool> deleteUsers<int>(List<int> userIds) async {
    // TODO: Implement
    return Future.delayed(const Duration(seconds: 2), () => true);
  }

  /// Shows a dialog for creating an new user and creates the user or aborts,
  /// if the user cancels the operation.
  Future<bool> addUser() async {
    // TODO: Implement
    print("Add user");
    return true;
  }

  /// Shows a dialog for editing an existing user and updates the user or
  /// aborts, if the user cancels the operation.
  Future<bool> editUser(ModelBase user) async {
    // TODO: Implement
    print(user);
    return true;
  }
}
