import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/clients/overview.dart';
import 'package:mml_admin/views/clients/edit.dart';
import 'package:mml_admin/views/clients/register.dart';
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
          deleteItems: <ModelBase>(List<ModelBase> items) => vm.deleteClients(
            items,
            context,
          ),
          addItem: () async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const ClientRegisterDialog();
              },
            );
          },
          editItem: (ModelBase client, Subfilter? subfilter) async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return ClientEditDialog(clientId: (client as Client).clientId);
              },
            );
          },
          loadData: vm.loadClients,
        );
      },
    );
  }
}
