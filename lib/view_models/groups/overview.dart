import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/services/router.dart';

///
class GroupsOverviewViewModel extends ChangeNotifier {
  ///
  static String route = '/groups';

  ///
  final GroupService _groupService = GroupService.getInstance();

  /// Loads the groups with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> loadGroups({String? filter, int? offset, int? take}) async {
    return await _groupService.getGroups(filter, offset, take);
  }

  /// Deletes the groups with the passed [groupIds] or or aborts, if the user
  /// cancels the operation.
  Future<bool> deleteGroups<String>(
    BuildContext context,
    List<String> groupIds,
  ) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      try {
        showProgressIndicator();
        await _groupService.deleteGroups(groupIds);
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
