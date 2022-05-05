import 'package:flutter/material.dart';
import 'package:mml_admin/extensions/is_valid_guid.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class LoginViewModel extends ChangeNotifier {
  late String username;
  late String password;
  late String? appKey;
  late String? clientId;
  late String? serverName;
  late String? _persistedAppKey;
  late String? _persistedClientId;
  late String? _persistedServerName;
  late AppLocalizations locales;
  final formKey = GlobalKey<FormState>();

  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      // TODO: check if token given and try get user data or a refresh token and redirect on success
      // else

      locales = AppLocalizations.of(context)!;
      _persistedAppKey = await SecureStorageService.getInstance().get('appKey');
      _persistedClientId = await SecureStorageService.getInstance().get('clientId');
      _persistedServerName = await SecureStorageService.getInstance().get('serverName');

      return true;
    });
  }

  void login() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    }

    // UserService.getInstance().
  }

  String? validateUsername(String? username) {
    return username != null && username.isNotEmpty ? null : locales.invalidUsername;
  }

  String? validatePassword(String? password) {
    return password != null && password.isNotEmpty ? null : locales.invalidPassword;
  }

  String? validateAppKey(String? appKey) {
    if ((appKey == null || appKey.isEmpty) && (_persistedAppKey != null && _persistedAppKey!.isNotEmpty)) {
      serverName = _persistedServerName;
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
