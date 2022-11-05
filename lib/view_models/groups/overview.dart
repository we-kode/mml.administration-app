import 'package:flutter/material.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the client groups overview screen.
class GroupsOverviewViewModel extends ChangeNotifier {
  /// Route for the client groups overview screen.
  static String route = '/groups';

  /// [GroupService] used to load data for the groups overview screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Loads the groups with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> loadGroups({String? filter, int? offset, int? take, dynamic subfilter}) async {
    return await _groupService.getGroups(filter, offset, take);
  }

  /// Deletes the groups with the passed [groups] or or aborts, if the user
  /// cancels the operation.
  Future<bool> deleteGroups<ModelBase>(
    BuildContext context,
    List<ModelBase> groups,
  ) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      try {
        showProgressIndicator();
        await _groupService.deleteGroups(groups.map<String>((ModelBase e) => (e as Group).getIdentifier()).toList());
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
