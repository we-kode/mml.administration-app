import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/record_folder.dart';
import 'package:mml_admin/models/share_options.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/share.dart';
import 'package:mml_admin/views/records/share_dialog.dart';
import 'package:mml_admin/views/records/share_result_dialog.dart';

/// Creates a share link for the records with the [recordIds] and within the
/// [folders] and shows it. Asks the admin for the link options, unless the
/// admin chose to use the defaults.
Future<void> shareRecords(
  BuildContext context, {
  List<String> recordIds = const [],
  List<RecordFolder> folders = const [],
}) async {
  var service = ShareService.getInstance();
  var options = await service.loadDefaults();

  if (!await service.useDefaults()) {
    if (!context.mounted) {
      return;
    }

    var result = await showDialog<(ShareOptions, bool)>(
      barrierDismissible: false,
      context: context,
      builder: (context) => ShareDialog(options: options),
    );
    if (result == null) {
      return;
    }

    options = result.$1;
    if (result.$2) {
      await service.saveDefaults(options, true);
    }
  }

  showProgressIndicator();
  try {
    var response = await service.create(
      recordIds: recordIds,
      folders: folders,
      options: options,
    );
    RouterService.getInstance().navigatorKey.currentState!.pop();
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => ShareResultDialog(response: response),
      );
    }
  } on DioException catch (e) {
    RouterService.getInstance().navigatorKey.currentState!.pop();
    if (e.response?.statusCode == HttpStatus.badRequest && context.mounted) {
      MessengerService.getInstance().showMessage(
        AppLocalizations.of(
          context,
        )!.shareTooMany(ShareOptions.maxRecordsPerLink),
      );
    }
  } catch (_) {
    // Errors are shown by the api service.
    RouterService.getInstance().navigatorKey.currentState!.pop();
  }
}
