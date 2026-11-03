import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/share_options.dart';
import 'package:mml_admin/models/share_settings.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/share.dart';

/// View model for the dialog, that edits the settings of share links.
class SettingsShareViewModel extends ChangeNotifier {
  /// [ShareService] used to load and save the settings.
  final ShareService _service = ShareService.getInstance();

  /// Options of the share links the admin creates.
  ShareOptions options = ShareOptions();

  /// Whether the admin creates share links with [options] without asking.
  bool useDefaults = false;

  /// Server settings that control the share links of clients.
  ShareSettings serverSettings = ShareSettings();

  /// Loads the local and the server settings.
  Future<bool> init() async {
    options = await _service.loadDefaults();
    useDefaults = await _service.useDefaults();
    try {
      serverSettings = await _service.getSettings();
    } catch (_) {
      // Errors are shown by the api service.
    }

    return true;
  }

  /// Changes whether the admin creates share links without asking.
  void useDefaultsChanged(bool value) {
    useDefaults = value;
    notifyListeners();
  }

  /// Changes whether clients choose the options of their share links.
  void userSettingsAllowedChanged(bool value) {
    serverSettings.userSettingsAllowed = value;
    notifyListeners();
  }

  /// Saves the settings and closes the dialog.
  Future<void> save(BuildContext context) async {
    var nav = Navigator.of(context);

    showProgressIndicator();
    try {
      await _service.saveDefaults(options, useDefaults);
      await _service.saveSettings(serverSettings);
      nav.pop();
    } catch (_) {
      // Errors are shown by the api service.
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }
}
