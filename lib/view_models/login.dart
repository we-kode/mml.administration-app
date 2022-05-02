import 'package:flutter/material.dart';
import 'package:mml_admin/services/secure_storage.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class LoginViewModel extends ChangeNotifier {
  late String username;
  late String password;
  late String? clientId;
  late String? serverName;
  late String? _persistedServerName;
  late String? _persistedClientId;
  late AppLocalizations locales;
  final formKey = GlobalKey<FormState>();

  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      // TODO: check if token given and try get user data or a refresh token and redirect on success
      // else

      locales = AppLocalizations.of(context)!;
      _persistedServerName = await SecureStorageService.getInstance().get('serverName');
      _persistedClientId = await SecureStorageService.getInstance().get('clientId');

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
    return username != null && username.isNotEmpty ? null : "A username must be specified!";
  }

  String? validatePassword(String? password) {
    return password != null && password.isNotEmpty ? null : "A password must be specified!";
  }

  String? validateClientId(String? clientId) {
    if ((clientId == null || clientId.isEmpty) && (_persistedClientId != null && _persistedClientId!.isNotEmpty)) {
      serverName = _persistedServerName;
    }

    return clientId != null && clientId.isNotEmpty ? null : "A client id must be specified!";
  }

  String? validateServerName(String? serverName) {
    if ((serverName == null || serverName.isEmpty) && (_persistedServerName != null && _persistedServerName!.isNotEmpty)) {
      serverName = _persistedServerName;
    }

    // TODO: Validate format
    return serverName != null && serverName.isNotEmpty ? null : locales.invalidServerName;
  }

  String get clientIdLabel {
    return _persistedClientId != null && _persistedClientId!.isNotEmpty && (clientId == null || clientId!.isEmpty) ? locales.clientIdUnchanged : locales.clientId;
  }

  String get serverNameLabel {
    return _persistedServerName != null && _persistedServerName!.isNotEmpty && (serverName == null || serverName!.isEmpty) ? locales.serverNameUncahnged : locales.serverName;
  }
}
