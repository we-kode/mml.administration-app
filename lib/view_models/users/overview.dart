import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/services/user.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the users overview screen.
class UsersOverviewViewModel extends ChangeNotifier {
  /// Route for the users overview screen.
  static String route = '/users';

  /// [UserService] that handles the requests to the server.
  final UserService _userService = UserService.getInstance();

  /// Loads the user with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> loadUsers({String? filter, int? offset, int? take, dynamic subfilter}) async {
    return await _userService.getUsers(filter, offset, take);
  }

  /// Deletes the users with the passed [users] or or aborts, if the user
  /// cancels the operation.
  Future<bool> deleteUsers<ModelBase>(BuildContext context, List<ModelBase> users) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      try {
        showProgressIndicator();
        await _userService.deleteUsers(users.map<int>((ModelBase e) => (e as User).getIdentifier()).toList());
        RouterService.getInstance().navigatorKey.currentState!.pop();
      } catch (e) {
        RouterService.getInstance().navigatorKey.currentState!.pop();
        // Do not reload list on error!
        return false;
      }
    }

    return shouldDelete;
  }
}
