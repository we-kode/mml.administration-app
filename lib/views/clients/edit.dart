import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/clients/edit.dart';
import 'package:provider/provider.dart';

class EditClientScreen extends StatelessWidget {
  /// Initializes the instance.
  const EditClientScreen({Key? key}) : super(key: key);

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return Provider<EditClientViewModel>(
      create: (context) => EditClientViewModel(),
      builder: (context, _) {
        var vm = Provider.of<EditClientViewModel>(context, listen: false);

        return Column(
          children: [
            const Text('Test'),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("TESTTTT"),
            ),
          ],
        );
      },
    );
  }
}
