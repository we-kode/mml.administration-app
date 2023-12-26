import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/livestream.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/livestreams.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';

class LivestreamEditDialogViewModel extends ChangeNotifier {
  /// [LivestreamService] used to load data for the livestream edit and create dialog.
  final LivestreamService _service = LivestreamService.getInstance();

  /// [GroupService] used to load data for the groups of the client editing
  /// screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Key of the Livestream edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// The Livestream to be created or edited.
  late Livestream stream;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Flag that indicates whether the Livestream is successful loaded.
  bool loadedSuccessfully = false;

  /// Name of the Livestream name field in the errors response.
  final String nameField = 'DisplayName';

   /// Name of the groups field in the errors response.
  final String groupsField = 'Groups';

  /// Map of errors from the server.
  Map<String, List<String>> errors = {};

  /// Initializes the ViewModel and loads the Livestream with the given [id] or
  /// creates an new Livestream model if the id is not passed.
  Future<bool> init(BuildContext context, String? id) async {
    locales = AppLocalizations.of(context)!;
    _context = context;

    if (id == null) {
      return Future.microtask(() {
        stream = Livestream();
        loadedSuccessfully = true;
        notifyListeners();
        return true;
      });
    }

    try {
      stream = await _service.getLivestream(id);
      loadedSuccessfully = true;
      notifyListeners();
    } catch (e) {
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();

        messenger.showMessage(messenger.notFound);
      }

      if (context.mounted) Navigator.pop(context, true);
      return false;
    }

    return true;
  }

  /// Validates the display name.
  String? validateDisplayName(String? name) {
    var error = (name ?? '').isNotEmpty ? null : locales.invalidDisplayName;

    return _addBackendErrors(nameField, error);
  }

  /// Saves the livestream settings.
  void save() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    if (!loadedSuccessfully || !formKey.currentState!.validate()) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    formKey.currentState!.save();

    var shouldClose = false;

    try {
      await _service.update(stream);
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

  /// Returns the backend errors for the group field or null if there are no
  /// validation errors.
  String? validateGroups(List<Group>? groups) {
    String? error;
    return _addBackendErrors(groupsField, error);
  }

  /// Loads all groups from the server
  Future<ModelList> getGroups() async {
    return await _groupService.getGroups(null, 0, -1);
  }

  /// Clears the errors from the backend for the field with the passed
  /// [fieldName].
  clearBackendErrors(String fieldName) {
    errors.remove(fieldName);
  }

  /// Adds an backend error to the error map.
  String? _addBackendErrors(String fieldName, String? error) {
    if (errors.containsKey(fieldName) && errors[fieldName]!.isNotEmpty) {
      error = (error != null ? '$error\n' : '');
      error += errors[fieldName]!.join("\n");
    }

    return error;
  }
}
