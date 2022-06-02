import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/clients.dart';

/// View model for the app clients overview screen.
class ClientsViewModel {
  /// Route for the app clients overview screen.
  static String route = '/clients';

  final ClientService _service = ClientService.getInstance();

  /// Loads the clients with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> loadClients(
      {String? filter, int? offset, int? take}) async {
    return _service.getClients(filter, offset, take);
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

  /// Shows a dialog for editing an existing client and updates the client or
  /// aborts, if the user cancels the operation.
  Future<bool> editClient(ModelBase client) async {
    await _service.updateClient(client as Client);
    return true;
  }
}
