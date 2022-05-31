import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/view_models/users.dart';
import 'package:provider/provider.dart';

/// Overview screen of the administration users of the music lib.
class UsersScreen extends StatelessWidget {
  /// Initializes the instance.
  const UsersScreen({Key? key}) : super(key: key);

  /// Builds the overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersViewModel>(
      create: (context) => UsersViewModel(),
      builder: (context, _) {
        var vm = Provider.of<UsersViewModel>(context, listen: false);

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
