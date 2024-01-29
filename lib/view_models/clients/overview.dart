import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/client_tag_filter.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the app clients overview screen.
class ClientsViewModel extends ChangeNotifier {
  /// Route for the app clients overview screen.
  static String route = '/clients';

  /// [ClientService] used to load data for the client overview screen.
  final ClientService _service = ClientService.getInstance();

  /// Count of clients matching filters.
  int clientCount = 0;

  /// filters set for clients.
  ClientTagFilter tagFilter = ClientTagFilter();

  /// [GroupService] used to load data for the groups of the client editing
  /// screen.
  final GroupService _groupService = GroupService.getInstance();

  /// Available groups.
  late ModelList groups;

  /// Initializes the view model.
  Future<bool> init(BuildContext context) {
    return Future.microtask(() async {
      groups = await _groupService.getMediaGroups(null, 0, -1);
      return true;
    });
  }

  /// Loads the clients with the passing [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> loadClients({
    String? filter,
    int? offset,
    int? take,
    Subfilter? subfilter,
  }) async {
    final clients = await _service.getClients(
      filter,
      offset,
      take,
      subfilter as ClientTagFilter?,
    );
    clientCount = clients.totalCount;
    tagFilter = subfilter!;
    notifyListeners();
    return clients;
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
        await _service.deleteClients(clients
            .map<String>((ModelBase e) => (e as Client).getIdentifier())
            .toList());
        RouterService.getInstance().navigatorKey.currentState!.pop();
      } catch (e) {
        RouterService.getInstance().navigatorKey.currentState!.pop();
        // Do not reload list on error!
        return false;
      }
    }

    return shouldDelete;
  }

  /// Updates the groups of the [item].
  void groupsChanged(ModelBase item, List<ModelBase> changedGroups) async {
    (item as Client).groups = changedGroups
        .map(
          (e) => e as Group,
        )
        .toList();
    _service.updateClient(item);
  }

  /// Assigns groups to clients.
  Future assignGroups<ModelBase>(
    List<ModelBase> clients,
    List<String> selectedGroups,
  ) async {
    await _service.assignClients(
      clients.map((e) => (e as Client).clientId!).toList(),
      selectedGroups,
    );
  }

  /// Load available groups.
  Future<ModelList> loadGroups() async {
    return groups;
  }
}
