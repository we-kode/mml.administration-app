import 'dart:io';

import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/announcement.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/services/announcements.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/router.dart';

/// View model of the announcements overview screen.
class AnnouncementsViewModel extends ChangeNotifier {
  /// Route of the announcements overview screen.
  static String route = '/announcements';

  /// [AnnouncementService] used to load the announcements.
  final AnnouncementService _service;

  /// Whether the server supports announcements.
  bool isSupported = true;

  /// Available groups, which can be assigned in the list.
  ModelList groups = ModelList([], 0, 0);

  /// Initializes the view model.
  AnnouncementsViewModel({AnnouncementService? service})
    : _service = service ?? AnnouncementService.getInstance();

  /// Checks whether the server supports announcements. Servers without
  /// announcements answer with not found.
  Future<bool> init() async {
    try {
      await _service.get(null, 0, 1);
      groups = await GroupService.getInstance().getMediaGroups(null, 0, -1);
    } on DioException catch (e) {
      isSupported = e.response?.statusCode != HttpStatus.notFound;
    }
    return true;
  }

  /// Loads a chunk of announcements.
  Future<ModelList> load({
    String? filter,
    int? offset,
    int? take,
    Subfilter? subfilter,
  }) {
    return _service.get(filter, offset, take);
  }

  /// Updates the groups of the announcement [item].
  Future<void> groupsChanged(ModelBase item, List<ModelBase> changed) async {
    (item as Announcement).groups = changed.map((e) => e as Group).toList();
    await _service.update(item);
  }

  /// Deletes [items] after the user confirmed it.
  Future<bool> delete<T>(BuildContext context, List<T> items) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete && items.isNotEmpty) {
      try {
        showProgressIndicator();
        await _service.delete(
          items.map((e) => (e as Announcement).notificationId!).toList(),
        );
      } catch (e) {
        // Do not reload list on error!
        return false;
      } finally {
        RouterService.getInstance().navigatorKey.currentState!.pop();
      }
    }

    return shouldDelete;
  }
}
