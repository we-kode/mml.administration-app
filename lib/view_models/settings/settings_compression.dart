import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/settings.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class SettingsCompressionViewModel extends ChangeNotifier {
  /// [RecordService] used to load data of the record settings.
  final RecordService _recordService = RecordService.getInstance();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Global key of the upload settings form.
  ///
  /// Is used to call validate and save on the form.
  final uploadSettingsKey = GlobalKey<FormState>();

  /// Uplaod [Settings].
  late Settings settings = Settings();

  /// Map of errors from the server.
  Map<String, List<String>> errors = {};

  /// Name of compression rate field in the errors response.
  final String compressionField = 'CompressionRate';

  /// Initialize the registration client view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      _context = context;
      locales = AppLocalizations.of(_context)!;
      try {
        settings = await _recordService.getSettings();
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
      }
      return true;
    });
  }

  String? validateCompressionRate(String? compressionRate) {
    var compression = int.tryParse(compressionRate ?? '0');
    var error = compression == null || compression > 0
        ? null
        : locales.invalidCompressionRate;

    return _addBackendErrors(compressionField, error);
  }

  /// Clears the errors from the backend for the field with the passed
  /// [fieldName].
  clearBackendErrors(String fieldName) {
    errors.remove(fieldName);
  }

  Future save() async {
    var nav = Navigator.of(_context);
    showProgressIndicator();

    if (!uploadSettingsKey.currentState!.validate()) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    uploadSettingsKey.currentState!.save();

    try {
      await _recordService.saveSettings(settings);
    } on DioException catch (e) {
      var statusCode = e.response?.statusCode;
      if (statusCode == HttpStatus.badRequest) {
        errors = ((e.response!.data as Map)['errors'] as Map).map((key, value) {
          return MapEntry(key.toString(), List<String>.from(value));
        });

        uploadSettingsKey.currentState!.validate();
      }
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }

    nav.pop(false);
  }

  /// Adds errors from backend for passed [fieldName] to the [error] string
  /// divided by new lines and returns the extended error string.
  String? _addBackendErrors(String fieldName, String? error) {
    if (errors.containsKey(fieldName) && errors[fieldName]!.isNotEmpty) {
      error = (error != null ? '$error\n' : '');
      error += errors[fieldName]!.join("\n");
    }

    return error;
  }

  /// Closes the view.
  void abort() async {
    var nav = Navigator.of(_context);
    showProgressIndicator();
    RouterService.getInstance().navigatorKey.currentState!.pop();
    nav.pop(false);
  }
}
