import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/view_models/clients/overview.dart';
import 'package:mml_admin/views/clients/edit.dart';
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

        return FutureBuilder(
          future: vm.init(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return AsyncListView(
              deleteItems: <String>(List<String> clientIds) async {
                var shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  vm.deleteClients(clientIds);
                }
                return shouldDelete;
              },
              addItem: vm.registerClient,
              editItem: (ModelBase c) async {
               var edited = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    var editScreen = EditClientScreen(client: c as Client);
                    return AlertDialog(
                      title: Text(vm.locales.editClient),
                      content: editScreen,
                      actions: [
                        TextButton(
                          child: Text(vm.locales.cancel),
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                        TextButton(
                          child: Text(vm.locales.ok),
                          onPressed: () {
                            editScreen.save();
                          },
                        ),
                      ],
                    );
                  },
                );
                return edited;
              },
              loadData: vm.loadClients,
            );
          },
        );
      },
    );
  }
}
