import 'package:flutter/material.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/view_models/settings.dart';
import 'package:provider/provider.dart';

/// Screen to modify own app settings.
class SettingsScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsScreen({Key? key}) : super(key: key);

  /// Builds the settings screen.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ChangeNotifierProvider<SettingsViewModel>(
        create: (context) => SettingsViewModel(),
        builder: (context, _) {
          var vm = Provider.of<SettingsViewModel>(context, listen: false);
          return FutureBuilder(
            future: vm.init(context),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person),
                        Text(' ${vm.locales.actualUser}: ${vm.user!.name!}'),
                      ],
                    ),
                    spacer,
                    ElevatedButton.icon(
                      onPressed: () {
                        vm.changePassword();
                      },
                      icon: const Icon(Icons.lock),
                      label: Text(vm.locales.changePassword),
                    ),
                    spacer,
                    const Divider()
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
