import 'package:flutter/material.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/view_models/main.dart';
import 'package:mml_admin/view_models/records.dart';
import 'package:provider/provider.dart';

/// Main View with navigation
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

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
                            destinations: [
                              _navItem(Icons.music_note_outlined,
                                  vm.locales.records),
                              _navItem(Icons.phone_android_rounded,
                                  vm.locales.devices),
                              _navItem(Icons.person, vm.locales.adminUsers),
                              _navItem(Icons.settings, vm.locales.settings),
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
                      key: RouterService.getInstance().nestedNavigatorKey,
                      initialRoute: RecordsViewModel.route,
                      onGenerateRoute: (settings) {
                        return RouterService.getInstance()
                            .getNestedRoutes()[settings.name];
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

  NavigationRailDestination _navItem(IconData icon, String label) {
    return NavigationRailDestination(
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
