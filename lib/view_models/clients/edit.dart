import 'package:flutter/material.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// View model for the edit client screen.
class EditClientViewModel extends ChangeNotifier {
  final ClientService _service = ClientService.getInstance();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// The clientto be edited
  late Client client;

  /// Initialize the edit client view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      _context = context;
      locales = AppLocalizations.of(context)!;
      return true;
    });
  }

  /// Validates the given [displayName] and returns an error message or null if
  /// the [displayName] is valid.
  String? validateDisplayName(String? displayName) {
    if ((client.displayName ?? '').isEmpty) {
      return locales.invalidDisplayName;
    }

    return null;
  }

  /// Shows a dialog for editing an existing client and updates the client or
  /// aborts, if the user cancels the operation.
  Future<void> editClient() async {
    if (client.getDisplayDescription().isEmpty) {
      return;
    }

    var nav = Navigator.of(_context);
    try {
      await _service.updateClient(client);
      nav.pop();
    } catch (e) {
      // Will be handled by api service
    }
  }
}
