import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/record_sync_info.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/federation_events.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/sync.dart';
import 'package:mml_admin/view_models/sync/overview.dart';

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

  StreamSubscription<FederationEvent>? _events;

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
        _events ??= FederationEventService.getInstance().events.listen(
          _updateProgress,
        );
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

  /// Synchronizes the record with the partner instances the admin selects,
  /// even if its synchronization was revoked, and shows the result.
  Future<void> synchronize() async {
    await synchronizeRecords(_context, recordIds: [record.recordId!]);
    await _reloadSync();
  }

  /// The partner instances the record is sent to or is being sent to.
  Set<String> get sentTo => {
    for (var link in sync.links)
      if (link.direction == SyncDirection.outgoing) link.instance ?? '',
    for (var transfer in sync.transfers) transfer.instance,
  };

  /// Revokes the synchronization of the record with the partner instances the
  /// admin selects of [sentTo] and shows the result.
  Future<void> revokeSync() async {
    await revokeRecords(
      _context,
      recordIds: [record.recordId!],
      instances: sentTo,
    );
    await _reloadSync();
  }

  @override
  void dispose() {
    _events?.cancel();
    super.dispose();
  }

  Future<void> _reloadSync() async {
    try {
      sync = await FederationService.getInstance().getRecordSync(
        record.recordId!,
      );
      notifyListeners();
    } catch (_) {
      // The shown details are kept.
    }
  }

  void _updateProgress(FederationEvent event) {
    var progress = event.progress;
    if (progress == null || progress.recordId != record.recordId) {
      return;
    }

    sync = RecordSyncInfo(
      links: sync.links,
      problems: sync.problems,
      exclusions: sync.exclusions,
      transfers: [
        for (var transfer in sync.transfers)
          transfer.instance == progress.instance
              ? transfer.withProgress(progress.transferred, progress.size)
              : transfer,
      ],
    );
    notifyListeners();
  }

  /// Locks the record, so it can not be deleted.
  void lock() {
    record.locked = !(record.locked ?? false);
    notifyListeners();
  }
}
