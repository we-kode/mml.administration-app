import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the records overview screen.
class RecordsViewModel extends ChangeNotifier {
  /// Route for the records overview screen.
  static String route = '/records';

  /// [RecordService] used to load data for the records uplaod dialog.
  final RecordService _service = RecordService.getInstance();

  /// Loads the records with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> load({
    String? filter,
    int? offset,
    int? take,
    Subfilter? subfilter,
  }) async {
    return _service.getRecords(
      filter,
      offset,
      take,
      subfilter as ID3TagFilter?,
    );
  }

  /// Deletes the records with the passed [recordIds] or or aborts, if the user
  /// cancels the operation.
  Future<bool> delete<String>(
    List<String> recordIds,
    BuildContext context,
  ) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      try {
        showProgressIndicator();
        await _service.delete(recordIds);
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