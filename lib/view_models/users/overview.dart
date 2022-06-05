import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/user.dart';

/// View model for the users overview screen.
class UsersOverviewViewModel extends ChangeNotifier {
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
    try {
      await _userService.deleteUsers(userIds);
    } catch (e) {
      // Do not reload list on error!
      return false;
    }

    return true;
  }
}
