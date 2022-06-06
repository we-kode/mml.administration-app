import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// View model for the app clients overview screen.
class ClientsViewModel {
  /// Route for the app clients overview screen.
  static String route = '/clients';

  /// [ClientService] used to load data for the client overview screen.
  final ClientService _service = ClientService.getInstance();

  /// Locales of the application.
  late AppLocalizations locales;

  /// Initialize the clients view model.
  Future<bool> init(BuildContext context) async {
    return Future<bool>.microtask(() async {
      locales = AppLocalizations.of(context)!;
      return true;
    });
  }

  /// Loads the clients with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> loadClients({
    String? filter,
    int? offset,
    int? take,
  }) async {
    return await _service.getClients(filter, offset, take);
  }

  /// Deletes the clients with the passed [clientIds] or or aborts, if the user
  /// cancels the operation.
  Future<bool> deleteClients<String>(List<String> clientIds) async {
    await _service.deleteClients(clientIds);
    return true;
  }

  /// Shows a dialog for register a new client and creates the client or aborts,
  /// if the user cancels the operation.
  Future<bool> registerClient() async {
    // TODO: Implement
    return true;
  }
}
