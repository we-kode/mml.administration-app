import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the app clients overview screen.
class ClientsViewModel {
  /// Route for the app clients overview screen.
  static String route = '/clients';

  /// [ClientService] used to load data for the client overview screen.
  final ClientService _service = ClientService.getInstance();

  /// Loads the clients with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> loadClients({
    String? filter,
    int? offset,
    int? take,
    dynamic subfilter,
  }) async {
    return await _service.getClients(filter, offset, take);
  }

  /// Deletes the clients with the passed [clients] or or aborts, if the user
  /// cancels the operation.
  Future<bool> deleteClients<ModelBase>(
    List<ModelBase> clients,
    BuildContext context,
  ) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete) {
      try {
        showProgressIndicator();
        await _service.deleteClients(clients.map<String>((ModelBase e) => (e as Client).getIdentifier()).toList());
        RouterService.getInstance().navigatorKey.currentState!.pop();
      } catch (e) {
        RouterService.getInstance().navigatorKey.currentState!.pop();
        // Do not reload list on error!
        return false;
      }
    }

    return shouldDelete;
  }
}
