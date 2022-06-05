import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/view_models/users/overview.dart';
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
          deleteItems: vm.deleteUsers,
          addItem: vm.addUser,
          editItem: vm.editUser,
          loadData: vm.loadUsers,
        );
      },
    );
  }
}
