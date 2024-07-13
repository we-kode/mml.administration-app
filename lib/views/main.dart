import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/floating_extended_chip_update.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/view_models/main.dart';
import 'package:mml_admin/view_models/records/overview.dart';
import 'package:mml_admin/view_models/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:updat/updat_window_manager.dart';
import 'package:http/http.dart' as http;

/// Main view with nested navigation element.
class MainScreen extends StatelessWidget {
  /// Initializes the instance.
  const MainScreen({super.key});

  /// Builds the main screen with the navigator instance.
  @override
  Widget build(BuildContext context) {
    return UpdatWindowManager(
      getLatestVersion: () async {
        if (MainViewModel.repository.isEmpty) {
          return SettingsViewModel.version;
        }

        final data = await http.get(
          Uri.parse(
            MainViewModel.latestVersionUri,
          ),
        );

        return jsonDecode(data.body)["tag_name"];
      },
      getBinaryUrl: (version) async {
        if (version?.isEmpty ?? true) {
          return '';
        }

        var file =
            "${MainViewModel.fileName}-$version${MainViewModel.extension}";
        return "${MainViewModel.binaryUri}$version/$file";
      },
      appName: AppLocalizations.of(context)!.appTitle,
      getChangelog: (latestVersion, __) async {
        var version = latestVersion.split('-').first;
        final data = await http.get(
          Uri.parse(
            "${MainViewModel.changeLogUri}$version",
          ),
        );
        return jsonDecode(data.body)["body"];
      },
      updateChipBuilder: floatingExtendedChipUpdate,
      currentVersion: SettingsViewModel.version,
      child: Scaffold(
        body: ChangeNotifierProvider<MainViewModel>(
          create: (context) => MainViewModel(),
          builder: (context, _) {
            var vm = Provider.of<MainViewModel>(context, listen: false);

            return FutureBuilder(
              future: vm.init(context),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Row(
                  children: [
                    Stack(
                      children: [
                        Consumer<MainViewModel>(
                          builder: (context, vm, _) {
                            var theme = Theme.of(context);
                            return NavigationRail(
                              selectedIndex: vm.selectedIndex,
                              onDestinationSelected: (int index) {
                                if (index == vm.selectedIndex) {
                                  return;
                                }
                                vm.selectedIndex = index;
                                vm.loadPage();
                              },
                              labelType: NavigationRailLabelType.all,
                              selectedLabelTextStyle: TextStyle(
                                color: theme.colorScheme.secondary,
                              ),
                              destinations: [
                                _navItem(
                                  Symbols.music_note,
                                  vm.locales.records,
                                ),
                                _navItem(
                                  Symbols.sensors,
                                  vm.locales.livestreams,
                                ),
                                _navItem(
                                  Symbols.phone_android_rounded,
                                  vm.locales.devices,
                                ),
                                _navItem(
                                  Symbols.vibration,
                                  vm.locales.groups,
                                ),
                                _navItem(
                                  Symbols.person,
                                  vm.locales.adminUsers,
                                ),
                                _navItem(
                                  Symbols.settings,
                                  vm.locales.settings,
                                ),
                              ],
                            );
                          },
                        ),
                        Positioned(
                          bottom: 10,
                          right: 0,
                          left: 0,
                          child: IconButton(
                            icon: const Icon(Symbols.logout),
                            onPressed: vm.logout,
                            tooltip: vm.locales.logout,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Navigator(
                        initialRoute: RecordsViewModel.route,
                        onGenerateRoute: (settings) {
                          return RouterService.getInstance()
                              .nestedRoutes[settings.name];
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Returns a new navigation rail destination with the given
  /// [label] and [icon].
  NavigationRailDestination _navItem(IconData icon, String label) {
    return NavigationRailDestination(
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
