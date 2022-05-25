import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';

/// Overview screen of the administration users of the music lib.
class UsersScreen extends StatelessWidget {
  /// Initializes the instance.
  const UsersScreen({Key? key}) : super(key: key);

  /// Builds the overview screen.
  @override
  Widget build(BuildContext context) {
    return AsyncListView();
  }
}
