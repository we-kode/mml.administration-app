import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/users/overview.dart';
import 'package:mml_admin/views/users/edit.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/user.dart';
import 'package:provider/provider.dart';

/// Overview screen of the administration users of the music lib.
class UsersOverviewScreen extends StatelessWidget {
  /// Initializes the instance.
  const UsersOverviewScreen({Key? key}) : super(key: key);

  /// Builds the overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersOverviewViewModel>(
      create: (context) => UsersOverviewViewModel(),
      builder: (context, _) {
        var vm = Provider.of<UsersOverviewViewModel>(context, listen: false);

        return AsyncListView(
          deleteItems: <ModelBase>(List<ModelBase> items) => vm.deleteUsers(
            context,
            items,
          ),
          addItem: () async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const UsersEditDialog(userId: null);
              },
            );
          },
          editItem: (ModelBase user, Subfilter? subfilter) async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return UsersEditDialog(
                  userId: (user as User).id,
                );
              },
            );
          },
          loadData: vm.loadUsers,
        );
      },
    );
  }
}
