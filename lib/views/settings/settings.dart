import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/view_models/settings/settings.dart';
import 'package:mml_admin/views/settings/settings_compression.dart';
import 'package:mml_admin/views/settings/settings_connection.dart';
import 'package:mml_admin/views/settings/settings_genre_bitrate.dart';
import 'package:mml_admin/views/settings/settings_upload_validation.dart';
import 'package:provider/provider.dart';

/// Screen to modify own app settings.
class SettingsScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsScreen({super.key});

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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Symbols.person),
                    trailing: ElevatedButton.icon(
                      onPressed: () {
                        vm.changePassword();
                      },
                      icon: const Icon(Symbols.lock),
                      label: Text(vm.locales.changePassword),
                    ),
                    title: Text(
                      '${vm.locales.actualUser}: ${vm.user!.name!}',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Symbols.qr_code_2),
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Symbols.data_thresholding, fill: 1),
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
                    leading: const Icon(Symbols.data_thresholding),
                    title: Text('${vm.locales.genre} ${vm.locales.bitrates}'),
                    onTap: () => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingsGenreBitrate();
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Symbols.rule),
                    title: Text(vm.locales.uploadValidation),
                    onTap: () => showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return const SettingsUploadValidationScreen();
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Symbols.new_releases),
                    title: Text(SettingsViewModel.version),
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
