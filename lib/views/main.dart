import 'package:flutter/material.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/view_models/main.dart';
import 'package:mml_admin/view_models/records/overview.dart';
import 'package:provider/provider.dart';

/// Main view with nested navigation element.
class MainScreen extends StatelessWidget {
  /// Initializes the instance.
  const MainScreen({Key? key}) : super(key: key);

  /// Builds the main screen with the navigator instance.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                Icons.music_note_outlined,
                                vm.locales.records,
                              ),
                              _navItem(
                                Icons.sensors,
                                vm.locales.livestreams,
                              ),
                              _navItem(
                                Icons.phone_android_rounded,
                                vm.locales.devices,
                              ),
                              _navItem(
                                Icons.vibration,
                                vm.locales.groups,
                              ),
                              _navItem(
                                Icons.person,
                                vm.locales.adminUsers,
                              ),
                              _navItem(
                                Icons.settings,
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
                          icon: const Icon(Icons.logout),
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
