import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/client_registration.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/registration.dart';

/// View model for the register client dialog.
class ClientsRegisterViewModel extends ChangeNotifier {
  /// [ClientService] used to load data for the client registration dialog.
  final ClientService _service = ClientService.getInstance();

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Socket connection to the server.
  late RegistrationService _socket;

  /// The new [Client].
  ///
  /// If the client is not registered yet the value will be null.
  Client? client;

  /// Flag indicates, if registered client is confirmed by user.
  var isClientConfirmed = false;

  /// Flag indicates that a client registration took place and the check animation should be played.
  var playAnimation = false;

  /// [ClientRegistration] Information needed by the user to register a new client.
  ClientRegistration? registration;

  /// Initialize the registration client view model.
  Future<bool> init(BuildContext context) async {
    _context = context;
    locales = AppLocalizations.of(context)!;
    _socket = RegistrationService(
      onUpdate: (tokenInfo) => updateCode(tokenInfo),
      onRegistered: <String>(clientId) => registerClient(clientId),
    );

    try {
      await _socket.connect();
    } catch (e) {
      // on errors close Dialog
      final messenger = MessengerService.getInstance();
      messenger.showMessage(messenger.unexpectedError(locales.retrieveTokenFailed));
      Navigator.of(_context).pop(false);
    }

    return true;
  }

  /// Updates the registered client or aborts, if the user cancels the operation.
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

  /// Closes the view if user aborts registration view.
  void abort() async {
    var nav = Navigator.of(_context);
    await _socket.close();
    nav.pop(false);
  }

  /// Validates the given [displayName] and returns an error message or null if
  /// the [displayName] is valid.
  String? validateDisplayName(String? displayName) {
    return (client?.displayName ?? '').isNotEmpty
        ? null
        : locales.invalidDisplayName;
  }

  /// Updates the [ClientRegistration] information if the token was updated.
  void updateCode(ClientRegistration tokenInfo) {
    registration = tokenInfo;
    notifyListeners();
  }

  /// Inititales the just registered [Client] to update its information.
  void registerClient<String>(String clientId) {
    client = Client(clientId: clientId.toString());
    playAnimation = true;
    notifyListeners();
  }

  /// Stops the playing animation.
  Future stopAnimation() async {
    isClientConfirmed = true;
    playAnimation = false;
    notifyListeners();
  }
}
