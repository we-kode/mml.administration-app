import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/router.dart';

class MainViewModel extends ChangeNotifier {
  static String route = '/';
  

  late BuildContext _context;
  late AppLocalizations locales;

  int _selectedIndex = 0;

  Future<bool> init(BuildContext context) async {
    _context = context;

    return Future<bool>.microtask(() async {
      locales = AppLocalizations.of(_context)!;
      return true;
    });
  }

  void set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  int get selectedIndex {
    return _selectedIndex;
  }

  void logout() {
    // TODO implelemnt logout flow
    print('user logged out!');
  }

  void load() {
    var routeService = RouterService.getInstance();
    var route = routeService
        .getNestedRoutes()
        .keys
        .elementAt(_selectedIndex);
    routeService.nestedNavigatorKey.currentState!.pushNamed(route);
  }
}
