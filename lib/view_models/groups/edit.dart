import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/group.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the group edit and create dialog.
class GroupEditDialogViewModel extends ChangeNotifier {
  /// [GroupService] used to load data for the group edit and create dialog.
  final GroupService _groupService = GroupService.getInstance();

  /// Key of the group edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// The group to be created or edited.
  late Group group;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Flag that indicates whether the group is successful loaded.
  bool groupLoadedSuccessfully = false;

  /// Name of the group name field in the errors response.
  final String nameField = 'Name';

  /// Name of the is default flag field in the errors response.
  final String isDefaultField = 'IsDefault';

  /// Map of errors from the server.
  Map<String, List<String>> errors = {};


  /// Initializes the ViewModel and loads the group with the given [groupId] or
  /// creates an new group model if the id is not passed.
  Future<bool> init(BuildContext context, String? groupId) async {
    locales = AppLocalizations.of(context)!;
    _context = context;

    if (groupId == null) {
      return Future.microtask(() {
        group = Group();
        groupLoadedSuccessfully = true;
        notifyListeners();
        return true;
      });
    }

    try {
      group = await _groupService.getGroup(groupId);
      groupLoadedSuccessfully = true;
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

  /// Validates the given [groupName] and returns an error message or null if
  /// the [groupName] is valid.
  String? validateGroupName(String? groupName) {
    var error = (groupName ?? '').isNotEmpty ? null : locales.invalidGroupName;

    return _addBackendErrors(nameField, error);
  }

  /// Validates the given [isDefault] flag and returns an error message or null
  /// if the [isDefault] flag is valid.
  String? validateIsDefault(bool? isDefault) {
    var error = isDefault == null ? locales.invalidGroupIsDefault : null;

    return _addBackendErrors(isDefaultField, error);
  }

  /// Clears the errors from the backend for the field with the passed
  /// [fieldName].
  clearBackendErrors(String fieldName) {
    errors.remove(fieldName);
  }

  /// Saves (creates or updates) the group and closes the group dialog on
  /// success.
  void saveGroup() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    if (!groupLoadedSuccessfully || !formKey.currentState!.validate()) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    formKey.currentState!.save();

    var shouldClose = false;

    try {
      await (group.id != null
          ? _groupService.updateGroup(group)
          : _groupService.createGroup(group));
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
