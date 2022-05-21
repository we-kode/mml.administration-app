import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/change_password.dart';
import 'package:provider/provider.dart';

/// Screen to force the user to change his password on first login.
class ChangePasswordScreen extends StatelessWidget {
  /// Initializes the instance.
  const ChangePasswordScreen({Key? key}) : super(key: key);

  /// Create the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ChangePasswordViewModel>(
        create: (context) => ChangePasswordViewModel(),
        builder: (context, _) {
          var vm = Provider.of<ChangePasswordViewModel>(context, listen: false);

          return FutureBuilder(
            future: vm.init(context),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // TODO: Implement password change, if isConfirmed is false!
              return Container();
            },
          );
        },
      ),
    );
  }
}
