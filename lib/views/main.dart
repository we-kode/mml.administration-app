import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/main.dart';
import 'package:mml_admin/views/clients.dart';
import 'package:mml_admin/views/records.dart';
import 'package:mml_admin/views/settings.dart';
import 'package:mml_admin/views/users.dart';
import 'package:provider/provider.dart';

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
                              vm.selectedIndex = index;
                            },
                            labelType: NavigationRailLabelType.all,
                            destinations: [
                              NavigationRailDestination(
                                icon: const Icon(Icons.music_note_outlined),
                                label: Text(vm.locales.records),
                              ),
                              NavigationRailDestination(
                                icon: const Icon(Icons.phone_android_rounded),
                                label: Text(vm.locales.devices),
                              ),
                              NavigationRailDestination(
                                icon: const Icon(Icons.person),
                                label: Text(vm.locales.adminUsers),
                              ),
                              NavigationRailDestination(
                                icon: const Icon(Icons.settings),
                                label: Text(vm.locales.settings),
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
                    child: Consumer<MainViewModel>(
                      builder: (context, vm, _) {
                        return page(vm.selectedIndex);
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

  Widget page(int index) {
    switch (index) {
      case 0:
        return RecordsScreen();
      case 1:
        return ClientsScreen();
      case 2:
        return UsersScreen();
      case 3:
        return SettingsScreen();
      default:
        return RecordsScreen();
    }
  }
}
