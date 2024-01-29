import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/components/async_select_list_dialog.dart';
import 'package:mml_admin/models/livestream.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/livestreams/overview.dart';
import 'package:mml_admin/views/livestreams/edit.dart';
import 'package:provider/provider.dart';

class LiveStreamsScreen extends StatelessWidget {
  /// Initializes the instance.
  const LiveStreamsScreen({Key? key}) : super(key: key);

  /// Builds the livestream overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LiveStreamsViewModel>(
      create: (context) => LiveStreamsViewModel(),
      builder: (context, _) {
        var vm = Provider.of<LiveStreamsViewModel>(context, listen: false);

        return FutureBuilder(
          future: vm.init(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return AsyncListView(
              deleteItems: <ModelBase>(List<ModelBase> items) => vm.delete(
                context,
                items,
              ),
              addItem: () async {
                return await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const LivestreamEditDialog(
                      id: null,
                    );
                  },
                );
              },
              editItem: (ModelBase stream, Subfilter? subfilter) async {
                return await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return LivestreamEditDialog(
                      id: (stream as Livestream).recordId,
                    );
                  },
                );
              },
              loadData: vm.load,
              availableTags: vm.groups,
              onChangedAvailableTags: (item, changedTags) =>
                  vm.groupsChanged(item, changedTags),
              assignItems: <ModelBase>(List<ModelBase> items) async {
                var selectedGroups = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AsyncSelectListDialog(
                      loadData: ({filter, offset, take}) => vm.loadGroups(),
                      initialSelected: const [],
                    );
                  },
                );
                if (selectedGroups == null) {
                  return false;
                }

                await vm.assignGroups(
                  items,
                  List<String>.from(selectedGroups),
                );
                return true;
              },
            );
          },
        );
      },
    );
  }
}
