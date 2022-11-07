import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/groups/overview.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/views/groups/edit.dart';
import 'package:provider/provider.dart';

/// Overview screen of the client groups.
class GroupsOverviewScreen extends StatelessWidget {
  /// Initializes the instance.
  const GroupsOverviewScreen({Key? key}) : super(key: key);

  /// Builds the overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupsOverviewViewModel>(
      create: (context) => GroupsOverviewViewModel(),
      builder: (context, _) {
        var vm = Provider.of<GroupsOverviewViewModel>(context, listen: false);

        return AsyncListView(
          deleteItems: <ModelBase>(List<ModelBase> items) => vm.deleteGroups(
            context,
            items,
          ),
          addItem: () async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const GroupEditDialog(groupId: null);
              },
            );
          },
          editItem: (ModelBase group, Subfilter? subfilter) async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return GroupEditDialog(
                  groupId: (group as Group).id,
                );
              },
            );
          },
          loadData: vm.loadGroups,
        );
      },
    );
  }
}
