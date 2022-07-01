import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/client_registration.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/registration.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/user.dart';
import 'package:signalr_pure/signalr_pure.dart';

/// View model for the register client dialog.
class ClientsRegisterViewModel extends ChangeNotifier {
  /// [ClientService] used to load data for the client registration dialog.
  final ClientService _service = ClientService.getInstance();

  /// [GroupService] used to load data for the groups of the client register
  /// screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Socket connection to the server.
  late RegistrationService _socket;

  /// [RegistrationState] of the current process.
  RegistrationState _state = RegistrationState.scan;

  /// The new [Client].
  ///
  /// If the client is not registered yet the value will be null.
  Client? client;

  /// [ClientRegistration] Information needed by the user to register a new client.
  ClientRegistration? registration;

  /// Initialize the registration client view model.
  Future<bool> init(BuildContext context) async {
    _context = context;
    locales = AppLocalizations.of(context)!;
    _socket = RegistrationService(
      onUpdate: (tokenInfo) => updateCode(tokenInfo),
      onRegistered: (clientId) => registerClient(clientId),
    );

    final messenger = MessengerService.getInstance();

    try {
      await _socket.connect();
    } on HttpException catch (e) {
      if (e.statusCode != HttpStatus.unauthorized) {
        messenger.showMessage(messenger.unexpectedError(e.message));
        Navigator.of(_context).pop(false);
      }

      await UserService.getInstance().refreshToken();
      try {
        await _socket.connect();
      } catch (_) {
        _closeOnError();
      }
    } catch (_) {
      _closeOnError();
    }

    return true;
  }

// on errors close Dialog
  void _closeOnError() {
    final messenger = MessengerService.getInstance();
    messenger
        .showMessage(messenger.unexpectedError(locales.retrieveTokenFailed));
    Navigator.of(_context).pop(false);
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

  /// Loads all groups from the server with the given [filter].
  Future<List<Group>> getGroups(String filter) async {
    return List.from(await _groupService.getGroups(filter, 0, -1));
  }

  /// Closes the view if user aborts registration view.
  void abort() async {
    var nav = Navigator.of(_context);
    showProgressIndicator();
    await _socket.close();
    RouterService.getInstance().navigatorKey.currentState!.pop();
    nav.pop(false);
  }

  /// Validates the given [displayName] and returns an error message or null if
  /// the [displayName] is valid.
  String? validateDisplayName(String? displayName) {
    return (client?.displayName ?? '').isNotEmpty
        ? null
        : locales.invalidDisplayName;
  }

  /// Validates the given [deviceIdentifier] and returns an error message or null if
  /// the [deviceIdentifier] is valid.
  String? validateDeviceIdentifier(String? deviceIdentifier) {
    return (client?.deviceIdentifier ?? '').isNotEmpty ? null : locales.invalidDeviceName;
  }

  /// Updates the [ClientRegistration] information if the token was updated.
  void updateCode(ClientRegistration tokenInfo) {
    registration = tokenInfo;
    notifyListeners();
  }

  /// Inititales the just registered [Client] to update its information.
  void registerClient(String clientId) async {
    try {
      client = await _service.getClient(clientId);
      _state = RegistrationState.success;
      notifyListeners();
    } catch (e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(messenger.notFound);
      }
      _state = RegistrationState.error;
      notifyListeners();
    }
  }

  /// Stops the playing animation.
  Future stopAnimation() async {
    _state = RegistrationState.register;
    notifyListeners();
  }

  /// Function called when error animation stops.
  Future stopErrorAnimation() async {
    Navigator.pop(_context, true);
  }

  /// Returns the current [state] of the registration process.
  RegistrationState get state {
    return _state;
  }
}

/// State of the registration process.
enum RegistrationState {
  scan,
  register,
  error,
  success,
}
