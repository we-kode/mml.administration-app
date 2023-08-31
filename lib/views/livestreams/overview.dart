import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
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
        );
      },
    );
  }
}
