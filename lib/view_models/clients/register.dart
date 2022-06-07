import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/clientRegistration.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/secure_storage.dart';

class ClientsRegisterViewModel extends ChangeNotifier {
  /// [SecureStorageService] used to load data from the secure storage.
  final SecureStorageService _storage = SecureStorageService.getInstance();

  /// [ClientService] used to load data for the client editing screen.
  final ClientService _service = ClientService.getInstance();

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  Client? client = null;

  var isClientConfirmed = false;

  ClientRegistration? registration = null;

  /// Initialize the edit client view model.
  Future<bool> init(BuildContext context) async {
    _context = context;
    locales = AppLocalizations.of(context)!;
    // TODO try to connect to socket. and retrieve tokenfrom connection
    registration =
        ClientRegistration(token: 'token', url: 'url', appKey: 'appKey');

    // on error show error in message

    return true;
  }

  /// Updates the client or aborts, if the user cancels the operation.
  void saveClient() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    if (client == null || !formKey.currentState!.validate()) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    formKey.currentState!.save();

    var shouldClose = false;

    try {
      await _service.updateClient(client!);
      shouldClose = true;
    } on DioError catch (e) {
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

  /// Validates the given [displayName] and returns an error message or null if
  /// the [displayName] is valid.
  String? validateDisplayName(String? displayName) {
    return client != null && (client!.displayName ?? '').isNotEmpty
        ? null
        : locales.invalidDisplayName;
  }
}
