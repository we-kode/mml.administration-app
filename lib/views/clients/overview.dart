import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/components/async_select_list_dialog.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/clients/overview.dart';
import 'package:mml_admin/views/clients/client_tag_filter.dart';
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
    return ChangeNotifierProvider<ClientsViewModel>(
      create: (context) => ClientsViewModel(),
      builder: (context, _) {
        var vm = Provider.of<ClientsViewModel>(context, listen: false);

        return FutureBuilder(
          future: vm.init(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Consumer<ClientsViewModel>(
              builder: (context, vm, child) {
                return AsyncListView(
                  subfilter: ClientTagFilterView(
                    clients: vm.clientCount,
                    tagFilter: vm.tagFilter,
                  ),
                  deleteItems: <ModelBase>(List<ModelBase> items) =>
                      vm.deleteClients(
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
                        return ClientEditDialog(
                            clientId: (client as Client).clientId);
                      },
                    );
                  },
                  loadData: vm.loadClients,
                  availableTags: vm.groups,
                  onChangedAvailableTags: (item, changedTags) =>
                      vm.groupsChanged(item, changedTags),
                  assignItems: <ModelBase>(List<ModelBase> clients) async {
                    var result = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AsyncSelectListDialog(
                          loadData: ({filter, offset, take}) => vm.loadGroups(),
                          threeState: true,
                          loadInitial: () => vm.loadAssignedGroups(
                            clients
                                .map((e) => (e as Client).clientId!)
                                .toList(),
                          ),
                          initialSelected: const [],
                        );
                      },
                    );

                    if (result == null) {
                      return false;
                    }

                    await vm.assignGroups(
                      clients,
                      List<String>.from(result[0]),
                      List<String>.from(result[1]),
                    );
                    return true;
                  },
                  enableFastActionSwitch: true,
                );
              },
            );
          },
        );
      },
    );
  }
}
