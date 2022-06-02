import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/view_models/clients.dart';
import 'package:provider/provider.dart';

/// Overview screen of the app clients of the music lib.
class ClientsScreen extends StatelessWidget {
  /// Initializes the instance.
  const ClientsScreen({Key? key}) : super(key: key);

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return Provider<ClientsViewModel>(
      create: (context) => ClientsViewModel(),
      builder: (context, _) {
        var vm = Provider.of<ClientsViewModel>(context, listen: false);

        return AsyncListView(
          deleteItems: <String>(List<String> clientIds) async {
            var shouldDelete = await showDeleteDialog(context);
            if (shouldDelete) {
              vm.deleteClients(clientIds);
            }
            return shouldDelete;
          },
          addItem: vm.registerClient,
          editItem: (ModelBase client) async {
            var shouldDelete = await showDeleteDialog(context);
            if (shouldDelete) {
              vm.editClient(client);
            }
            return shouldDelete;
          },
          loadData: vm.loadClients,
        );
      },
    );
  }
}
