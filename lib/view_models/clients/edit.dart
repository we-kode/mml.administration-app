import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the edit client screen.
class ClientsEditViewModel extends ChangeNotifier {
  /// [ClientService] used to load data for the client editing screen.
  final ClientService _service = ClientService.getInstance();

  /// [GroupService] used to load data for the groups of the client editing
  /// screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Name of display name field in the errors response.
  final String displayNameField = 'DisplayName';

  /// Name of device name field in the errors response.
  final String deviceNameField = 'Device';

  /// Name of the groups field in the errors response.
  final String groupsField = 'Groups';

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// The client to be edited
  late Client client;

  /// Flag that indicates whether the client is successful loaded.
  bool clientLoadedSuccessfully = false;

  /// Map of errors from the server.
  Map<String, List<String>> errors = {};

  /// Initialize the edit client view model.
  Future<bool> init(BuildContext context, String? clientId) async {
    _context = context;
    locales = AppLocalizations.of(context)!;
    try {
      client = await _service.getClient(clientId!);
      clientLoadedSuccessfully = true;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();

        messenger.showMessage(messenger.notFound);
      }

      if (context.mounted) Navigator.pop(context, true);
      return false;
    }
  }

  /// Validates the given [displayName] and returns an error message or null if
  /// the [displayName] is valid.
  String? validateDisplayName(String? displayName) {
    var error = (client.displayName ?? '').isNotEmpty
        ? null
        : locales.invalidDisplayName;
    return _addBackendErrors(displayNameField, error);
  }

  /// Validates the given [deviceIdentifier] and returns an error message or
  /// null if the [deviceIdentifier] is valid.
  String? validateDeviceIdentifier(String? deviceIdentifier) {
    var error = (client.deviceIdentifier ?? '').isNotEmpty
        ? null
        : locales.invalidDeviceName;
    return _addBackendErrors(deviceNameField, error);
  }

  /// Returns the backend errors for the group field or null if there are no
  /// validation errors.
  String? validateGroups(List<Group>? groups) {
    String? error;
    return _addBackendErrors(groupsField, error);
  }

  /// Clears the errors from the backend for the field with the passed
  /// [fieldName].
  clearBackendErrors(String fieldName) {
    errors.remove(fieldName);
  }

  /// Updates the client or aborts, if the user cancels the operation.
  void saveClient() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    if (!clientLoadedSuccessfully || !formKey.currentState!.validate()) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    formKey.currentState!.save();

    var shouldClose = false;

    try {
      await _service.updateClient(client);
      shouldClose = true;
    } on DioException catch (e) {
      var statusCode = e.response?.statusCode;

      if (statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(messenger.notFound);
        shouldClose = true;
      } else if (statusCode == HttpStatus.badRequest) {
        errors = ((e.response!.data as Map)['errors'] as Map).map((key, value) {
          return MapEntry(key.toString(), List<String>.from(value));
        });

        formKey.currentState!.validate();
      }
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();

      if (shouldClose) {
        nav.pop(true);
      }
    }
  }

  /// Loads all groups from the server.
  Future<ModelList> getGroups() async {
    return await _groupService.getGroups(null, 0, -1);
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
