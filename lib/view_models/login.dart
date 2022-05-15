import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/extensions/is_valid_guid.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/user.dart';

class LoginViewModel extends ChangeNotifier {
  late String? _persistedAppKey;
  late String? _persistedClientId;
  late String? _persistedServerName;
  late BuildContext _context;

  String? username;
  String? password;
  String? appKey;
  String? clientId;
  String? serverName;

  late AppLocalizations locales;
  final formKey = GlobalKey<FormState>();

  static String route = '/login';

  Future<bool> init(BuildContext context) async {
    _context = context;

    return Future<bool>.microtask(() async {
      if (await UserService.getInstance().isAuthenticated()) {
        return true;
      }

      locales = AppLocalizations.of(_context)!;

      _persistedAppKey = await SecureStorageService.getInstance().get(SecureStorageService.appKeyStorageKey);
      _persistedClientId = await SecureStorageService.getInstance().get(SecureStorageService.clientIdStorageKey);
      _persistedServerName = await SecureStorageService.getInstance().get(SecureStorageService.serverNameStorageKey);

      return false;
    });
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      showProgressIndicator(_context);

      formKey.currentState!.save();

      if (appKey != null && appKey!.isNotEmpty) {
        await SecureStorageService.getInstance().set(SecureStorageService.appKeyStorageKey, appKey);
      }

      if (clientId != null && clientId!.isNotEmpty) {
        await SecureStorageService.getInstance().set(SecureStorageService.clientIdStorageKey, clientId);
      }

      if (serverName != null && serverName!.isNotEmpty) {
        await SecureStorageService.getInstance().set(SecureStorageService.serverNameStorageKey, serverName);
      }

      try {
        await UserService.getInstance().login(username!, password!);

        // Navigator.pushNamed(_context, ClientsOverviewViewModel.route);
      } finally {
        Navigator.pop(_context);
      }
    }
  }

  String? validateUsername(String? username) {
    return username != null && username.isNotEmpty ? null : locales.invalidUsername;
  }

  String? validatePassword(String? password) {
    return password != null && password.isNotEmpty ? null : locales.invalidPassword;
  }

  String? validateAppKey(String? appKey) {
    if ((appKey == null || appKey.isEmpty) && (_persistedAppKey != null && _persistedAppKey!.isNotEmpty)) {
      appKey = _persistedAppKey;
    }

    return appKey != null && appKey.isValidGuid() ? null : locales.invalidAppKey;
  }

  String? validateClientId(String? clientId) {
    if ((clientId == null || clientId.isEmpty) && (_persistedClientId != null && _persistedClientId!.isNotEmpty)) {
      clientId = _persistedClientId;
    }

    return clientId != null && clientId.isValidGuid() ? null : locales.invalidClientId;
  }

  String? validateServerName(String? serverName) {
    if ((serverName == null || serverName.isEmpty) && (_persistedServerName != null && _persistedServerName!.isNotEmpty)) {
      serverName = _persistedServerName;
    }

    return serverName != null && serverName.isNotEmpty ? null : locales.invalidServerName;
  }

  String get appKeyLabel {
    return _persistedAppKey != null && _persistedAppKey!.isNotEmpty && (appKey == null || appKey!.isEmpty) ? locales.appKeyUnchanged : locales.appKey;
  }

  String get clientIdLabel {
    return _persistedClientId != null && _persistedClientId!.isNotEmpty && (clientId == null || clientId!.isEmpty) ? locales.clientIdUnchanged : locales.clientId;
  }

  String get serverNameLabel {
    return _persistedServerName != null && _persistedServerName!.isNotEmpty && (serverName == null || serverName!.isEmpty) ? locales.serverNameUnchanged : locales.serverName;
  }
}
