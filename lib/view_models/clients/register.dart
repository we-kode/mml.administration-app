import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/client.dart';

class ClientsRegisterViewModel extends ChangeNotifier {
  var isClientConfirmed = false;

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// Key of the user edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Client client;

  /// Initialize the edit client view model.
  Future<bool> init(BuildContext context) async {
    _context = context;
    locales = AppLocalizations.of(context)!;
    // TODO try to connect to socket.
    return true;
  }

  /// Updates the client or aborts, if the user cancels the operation.
  void registerClient() async {
    print("Client registered");
  }

  /// Validates the given [displayName] and returns an error message or null if
  /// the [displayName] is valid.
  String? validateDisplayName(String? displayName) {
    return (client.displayName ?? '').isNotEmpty
        ? null
        : locales.invalidDisplayName;
  }
}
