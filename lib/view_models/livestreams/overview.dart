import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/livestream.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/livestreams.dart';
import 'package:mml_admin/services/router.dart';

class LiveStreamsViewModel extends ChangeNotifier {
  /// Route for the records overview screen.
  static String route = '/livestreams';

  /// [LivestreamService] used to load data for the livestream overview.
  final LivestreamService _service = LivestreamService.getInstance();

  /// [GroupService] used to load data for the groups of the client editing
  /// screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Available groups.
  late ModelList groups;

  /// Initializes the view model.
  Future<bool> init(BuildContext context) {
    return Future.microtask(() async {
      groups = await _groupService.getMediaGroups(null, 0, -1);
      return true;
    });
  }

  Future<ModelList> load({
    String? filter,
    int? offset,
    int? take,
    Subfilter? subfilter,
  }) async {
    return _service.get(
      filter,
      offset,
      take,
    );
  }

  /// Deletes [items].
  Future<bool> delete<ModelBase>(
    BuildContext context,
    List<ModelBase> items,
  ) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete && items.isNotEmpty) {
      try {
        showProgressIndicator();
        await _service.delete(items
            .map<String>((ModelBase e) => (e as Livestream).getIdentifier())
            .toList());
        RouterService.getInstance().navigatorKey.currentState!.pop();
      } catch (e) {
        RouterService.getInstance().navigatorKey.currentState!.pop();
        // Do not reload list on error!
        return false;
      }
    }

    return shouldDelete;
  }

  /// Updates the groups of the [item].
  void groupsChanged(ModelBase item, List<ModelBase> changedGroups) async {
    (item as Livestream).groups = changedGroups
        .map(
          (e) => e as Group,
        )
        .toList();
    _service.update(item);
  }

  /// Assigns groups to records.
  Future assignGroups<ModelBase>(
    List<ModelBase> clients,
    List<String> selectedGroups,
  ) async {
    await _service.assign(
      clients.map((e) => (e as Livestream).recordId!).toList(),
      selectedGroups,
    );
  }

  /// Load available groups.
  Future<ModelList> loadGroups() async {
    return groups;
  }
}
