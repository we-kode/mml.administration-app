import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/sync/overview.dart';
import 'package:provider/provider.dart';

class SyncOverviewScreen extends StatelessWidget {
  /// Initializes the instance.
  const SyncOverviewScreen({super.key});

  /// Builds the live stream overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SyncOverviewViewModel>(
      create: (context) => SyncOverviewViewModel(),
      builder: (context, _) {
        var vm = Provider.of<SyncOverviewViewModel>(context, listen: false);

        return AsyncListView(
          deleteItems: <T>(List<T> items) => vm.delete(context, items),
          addItem: () async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                // TODO: Create sync add dialog
                return const Text("create");
              },
            );
          },
          editItem: (ModelBase peer, Subfilter? subfilter) async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                // TODO: Create sync edit dialog
                return const Text("edit");
              },
            );
          },
          loadData: vm.load,
        );
      },
    );
  }
}
