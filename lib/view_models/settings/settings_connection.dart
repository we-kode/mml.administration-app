import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/connection_settings.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/router.dart';

class SettingsConnectionViewModel extends ChangeNotifier {
  /// Current build context.
  late BuildContext _context;

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Actual connection settings for client apps.
  late ConnectionSettings? connectionSettings;

  /// Initialize the registration client view model.
  Future<bool> init(BuildContext context) async {
     return Future<bool>.microtask(() async {
      _context = context;
      try {
        connectionSettings =
            await ClientService.getInstance().getConnectionSettings();
      } catch (e) {
        // Catch all errors and do nothing, since handled by api service!
      }
      return true;
    });
  }


  /// Closes the view.
  void abort() async {
    var nav = Navigator.of(_context);
    showProgressIndicator();
    RouterService.getInstance().navigatorKey.currentState!.pop();
    nav.pop(false);
  }
}