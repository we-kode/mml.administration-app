import 'package:flutter/material.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/view_models/clients/edit.dart';
import 'package:provider/provider.dart';

class EditClientScreen extends StatelessWidget {
  /// Initializes the instance.
  EditClientScreen({Key? key, required this.client}) : super(key: key);

  late EditClientViewModel vm;

  final Client client;

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditClientViewModel>(
      create: (context) => EditClientViewModel(),
      builder: (context, _) {
        vm = Provider.of<EditClientViewModel>(context, listen: false);
        vm.client = client;

        return FutureBuilder(
          future: vm.init(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              child: TextFormField(
                initialValue: vm.client.displayName,
                decoration: InputDecoration(
                  labelText: vm.locales.displayName,
                ),
                onSaved: (String? displayName) {
                  vm.client.displayName = displayName!;
                },
                onChanged: (String? displayName) {
                  vm.client.displayName = displayName;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: vm.validateDisplayName,
              ),
            );
          },
        );
      },
    );
  }

  void save() async{
    await vm.editClient();
  }
}
