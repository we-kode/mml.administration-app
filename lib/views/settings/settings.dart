import 'package:flutter/material.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/view_models/settings/settings.dart';
import 'package:mml_admin/views/settings/settings_compression.dart';
import 'package:mml_admin/views/settings/settings_connection.dart';
import 'package:mml_admin/views/settings/settings_genre_bitrate.dart';
import 'package:provider/provider.dart';

/// Screen to modify own app settings.
class SettingsScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsScreen({Key? key}) : super(key: key);

  /// Builds the settings screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SettingsViewModel>(
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

              return ListView(
                children: [
                  ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(
                      vm.locales.settings,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    trailing: ElevatedButton.icon(
                      onPressed: () {
                        vm.changePassword();
                      },
                      icon: const Icon(Icons.lock),
                      label: Text(vm.locales.changePassword),
                    ),
                    title: Text(
                      '${vm.locales.actualUser}: ${vm.user!.name!}',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.qr_code_2),
                    title: Text(
                      vm.locales.actualConnectionSettings,
                    ),
                    onTap: () => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingsConnectionScreen();
                      },
                    ),
                  ),
                  const Divider(),
                  verticalSpacer,
                  ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(
                      vm.locales.uploadSettings,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.data_thresholding),
                    title: Text('${vm.locales.defaults} ${vm.locales.bitrate}'),
                    onTap: () => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingsCompressionScreen();
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.data_thresholding_outlined),
                    title: Text('${vm.locales.genre} ${vm.locales.bitrates}'),
                    onTap: () => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingsGenreBitrate();
                      },
                    ),
                  ),
                  const Divider(),
                  verticalSpacer,
                  ListTile(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -4),
                    title: Text(
                      vm.locales.info,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.new_releases),
                    title: Text(vm.version),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
