import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/navigation_state.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/models/record_folder.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/secure_storage.dart';

/// View model for the records overview screen.
class RecordsViewModel extends ChangeNotifier {
  /// Route for the records overview screen.
  static String route = '/records';

  /// [RecordService] used to load data for the records uplaod dialog.
  final RecordService _service = RecordService.getInstance();

  /// Indicates if the folder view is active or not.
  bool isFolderView = false;

  /// The navigation state of the actual view.
  final navigationState = NavigationState();

  /// [GroupService] used to load data for the groups of the client editing
  /// screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Available groups.
  late ModelList groups;

  /// Initializes the view model.
  Future<bool> init(BuildContext context) {
    return Future.microtask(() async {
      isFolderView = (await SecureStorageService.getInstance().get(
            SecureStorageService.folderViewStorageKey,
          ))
              ?.toLowerCase() ==
          'true';
      groups = await _groupService.getMediaGroups(null, 0, -1);
      return true;
    });
  }

  /// Loads the records with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> load({
    String? filter,
    int? offset,
    int? take,
    Subfilter? subfilter,
  }) async {
    if (subfilter is ID3TagFilter &&
        subfilter.isGrouped &&
        (subfilter.startDate == null ||
            subfilter.startDate != subfilter.endDate)) {
      return _service.getRecordsFolder(filter, offset, take, subfilter);
    }

    return _service.getRecords(
      filter,
      offset,
      take,
      subfilter as ID3TagFilter?,
    );
  }

  /// Deletes the records with the passed [recordIds] or or aborts, if the user
  /// cancels the operation.
  Future<bool> delete<ModelBase>(
    List<ModelBase> items,
    BuildContext context,
  ) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete && items.isNotEmpty) {
      try {
        showProgressIndicator();
        if (items.first is Record) {
          await _service.delete(items
              .map<String>((ModelBase e) => (e as Record).getIdentifier())
              .toList());
        } else {
          await _service.deleteFolder(items
              .map<RecordFolder>((ModelBase e) => (e as RecordFolder))
              .toList());
        }
        RouterService.getInstance().navigatorKey.currentState!.pop();
      } catch (e) {
        RouterService.getInstance().navigatorKey.currentState!.pop();
        // Do not reload list on error!
        return false;
      }
    }

    return shouldDelete;
  }

  /// Loads the next folder which is before actual date range filtered by [subFilter].
  moveFolderUp(ID3TagFilter subFilter) {
    if (subFilter.startDate == null) {
      return;
    }
    if (subFilter.startDate == subFilter.endDate) {
      subFilter[ID3TagFilters.date] = DateTimeRange(
        start: DateTime(
          subFilter.startDate!.year,
          subFilter.startDate!.month,
          1,
        ),
        end: DateTime(
          subFilter.endDate!.year,
          subFilter.endDate!.month,
          DateUtils.getDaysInMonth(
              subFilter.endDate!.year, subFilter.endDate!.month),
        ),
      );
    } else if (subFilter.startDate!.month == subFilter.endDate!.month) {
      subFilter[ID3TagFilters.date] = DateTimeRange(
        start: DateTime(
          subFilter.startDate!.year,
          1,
          1,
        ),
        end: DateTime(
          subFilter.endDate!.year,
          12,
          31,
        ),
      );
    } else {
      subFilter.clear(ID3TagFilters.date);
    }
  }

  /// Updates the groups of the [item].
  void groupsChanged(ModelBase item, List<ModelBase> changedGroups) async {
    (item as Record).groups = changedGroups
        .map(
          (e) => e as Group,
        )
        .toList();
    _service.updateRecord(item);
  }

  /// Assigns groups to records.
  Future assignGroups<ModelBase>(
    List<ModelBase> items,
    List<String> initialGroups,
    List<String> selectedGroups,
  ) async {
    var isRecords = items.any((element) => element is Record);
    if (isRecords) {
      await _service.assign(
        items.map((e) => (e as Record).recordId!).toList(),
        initialGroups,
        selectedGroups,
      );
      return;
    }

    await _service.assignFolders(
      items.map((e) => (e as RecordFolder)).toList(),
      initialGroups,
      selectedGroups,
    );
  }

  /// Load available groups.
  Future<ModelList> loadGroups() async {
    return groups;
  }

  /// Changes the lock state of selected [items].
  Future lockRecords(List items) async {
    var isRecords = items.any((element) => element is Record);
    if (isRecords) {
      await _service.lock(
        items.map((e) => (e as Record).recordId!).toList(),
      );
      return;
    }

    await _service.lockFolders(
      items.map((e) => (e as RecordFolder)).toList(),
    );
  }

  /// Loads the assigned groups.
  Future<List<String>> loadAssignedGroups(List items) async {
    var isRecords = items.any((element) => element is Record);
    var groups = List.empty(growable: true);
    if (isRecords) {
      groups = await _service.assignedGroups(
         items.map((e) => (e as Record).recordId!).toList(),
      );
    } else {
      groups = await _service.assignedFolderGroups(
         items.map((e) => (e as RecordFolder)).toList(),
      );
    }

    return groups.map((e) => (e as Group).id!).toList();
  }
}
