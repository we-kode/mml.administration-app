import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/record_validation.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class SettingsUploadValidationViewModel extends ChangeNotifier {
  /// Global key of the upload settings form.
  ///
  /// Is used to call validate and save on the form.
  final uploadValidationSettingsKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// The model of this view model.
  late RecordValidation model;

  /// [RecordService] used to load data of the record settings.
  final RecordService _recordService = RecordService.getInstance();

  /// Initialize the registration client view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      _context = context;
      locales = AppLocalizations.of(_context)!;
      try {
        model = await _recordService.getValidationSettings();
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
      }
      return true;
    });
  }

  /// Updates the view model state
  void update(String key, bool value) {
    model[key] = value;
    notifyListeners();
  }

  /// Updates the registered client or aborts, if the user cancels the operation.
  void save() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    var shouldClose = false;

    try {
      await _recordService.saveValidationSettings(model);
      shouldClose = true;
    } catch (e) {
      // Catch all errors and do nothing, since handled by api service!
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
    showProgressIndicator();
    RouterService.getInstance().navigatorKey.currentState!.pop();
    nav.pop(false);
  }
}
