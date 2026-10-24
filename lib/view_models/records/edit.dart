import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/extensions/federation_error.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/federation/record_sync.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/sync.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the edit record screen.
class RecordEditViewModel extends ChangeNotifier {
  /// [Recordservice] used to load data for the record editing screen.
  final RecordService _service = RecordService.getInstance();

  /// [GroupService] used to load data for the groups of the client editing
  /// screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// The record to be edited
  late Record record;

  /// Flag that indicates whether the record is successful loaded.
  bool loadedSuccessfully = false;

  /// The running instance.
  late String instance;

  /// The synchronization details of the record.
  RecordSyncInfo sync = RecordSyncInfo();

  /// Returns whether the record is editable or not.
  bool get isEditable => instance == record.ownerInstance;

  /// Initialize the edit record view model.
  Future<bool> init(BuildContext context, String? recordId) async {
    _context = context;
    locales = AppLocalizations.of(context)!;
    try {
      instance = await SyncService.getInstance().get();
      record = await _service.getRecord(recordId!);
      try {
        sync = await FederationService.getInstance().getRecordSync(recordId);
      } catch (e) {
        // The record can be edited without the synchronization details.
      }
      loadedSuccessfully = true;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();

        messenger.showMessage(messenger.notFound);
      }

      if (context.mounted) Navigator.pop(context, true);
      return false;
    }
  }

  /// Validates the given [title] and returns an error message or null if
  /// the [title] is valid.
  String? validateTitle(String? title) {
    return (record.title ?? '').isNotEmpty ? null : locales.invalidTitle;
  }

  /// Updates the record or aborts, if the user cancels the operation.
  void saveRecord() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    if (!loadedSuccessfully || !formKey.currentState!.validate()) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    formKey.currentState!.save();

    var shouldClose = false;

    try {
      await _service.updateRecord(record);
      shouldClose = true;
    } on DioException catch (e) {
      var statusCode = e.response?.statusCode;

      if (statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(messenger.notFound);
        shouldClose = true;
      }
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();

      if (shouldClose) {
        nav.pop(true);
      }
    }
  }

  /// Loads all groups from the server.
  Future<ModelList> getGroups() async {
    return await _groupService.getMediaGroups(null, 0, -1);
  }

  /// Synchronizes the record with partner instances and shows the result.
  Future<void> synchronize() async {
    showProgressIndicator();
    try {
      var result = await FederationService.getInstance().synchronize(
        recordIds: [record.recordId!],
      );
      MessengerService.getInstance().showMessage(
        locales.syncResult(result.queued, result.skipped),
      );
    } on FederationException catch (e) {
      MessengerService.getInstance().showMessage(e.message(locales));
    } catch (_) {
      // Other errors are shown by the api service.
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }

  /// Locks the record, so it can not be deleted.
  void lock() {
    record.locked = !(record.locked ?? false);
    notifyListeners();
  }
}
