import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the sync screen.
class SyncOverviewViewModel extends ChangeNotifier {
  /// Route for the settings screen.
  static String route = '/sync';

   /// Deletes the groups with the passed [groups] or or aborts, if the user
  /// cancels the operation.
  Future<bool> delete<ModelBase>(
    BuildContext context,
    List<ModelBase> groups,
  ) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      try {
        showProgressIndicator();
        // TODO: Call delete function of sync service
        RouterService.getInstance().navigatorKey.currentState!.pop();
      } catch (e) {
        RouterService.getInstance().navigatorKey.currentState!.pop();
        // Do not reload list on error!
        return false;
      }
    }

    return shouldDelete;
  }

  /// Loads the peers with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> load({String? filter, int? offset, int? take, dynamic subfilter}) async {
    //TODO: Call load function of sync service
    return ModelList([], 0, 0);
  }
}
