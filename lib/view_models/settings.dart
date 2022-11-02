import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/connection_settings.dart';
import 'package:mml_admin/models/settings.dart';
import 'package:mml_admin/models/user.dart';
import 'package:mml_admin/route_arguments/change_password.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/user.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/change_password.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// View model for the settings screen.
class SettingsViewModel extends ChangeNotifier {
  /// Route for the settings screen.
  static String route = '/settings';

  /// [UserService] used to load data of the current user.
  final UserService _userService = UserService.getInstance();

  /// [RecordService] used to load data of the record settings.
  final RecordService _recordService = RecordService.getInstance();

  /// Actual connection settings for client apps.
  late ConnectionSettings? connectionSettings;

  /// Current user
  late User? user;

  /// Global key of the upload settings form.
  ///
  /// Is used to call validate and save on the form.
  final uploadSettingsKey = GlobalKey<FormState>();

  /// Uplaod [Settings].
  late Settings settings = Settings();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Map of errors from the server.
  Map<String, List<String>> errors = {};

  /// Name of compression rate field in the errors response.
  final String compressionField = 'CompressionRate';

  /// version of the running app.
  late String version;

  /// Initialize the settings view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      _context = context;
      locales = AppLocalizations.of(_context)!;
      var pkgInfo = await PackageInfo.fromPlatform();
      version = pkgInfo.version;
      try {
        user = await _userService.getUserInfo();
        connectionSettings =
            await ClientService.getInstance().getConnectionSettings();
        settings = await _recordService.getSettings();
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
      }
      return true;
    });
  }

  /// Redirects the logged in [user] to the [ChangePasswordScreen].
  Future changePassword() async {
    await RouterService.getInstance().navigatorKey.currentState!.pushNamed(
          ChangePasswordViewModel.route,
          arguments: ChangePasswordArguments(user!, isManualTriggered: true),
        );
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

  Future saveSettings() async {
    showProgressIndicator();

    if (!uploadSettingsKey.currentState!.validate()) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    uploadSettingsKey.currentState!.save();

    try {
      await _recordService.saveSettings(settings);
    } on DioError catch (e) {
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
}
