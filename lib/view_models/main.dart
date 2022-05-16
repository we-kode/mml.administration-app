import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/services/router.dart';

/// View model for the main screen
class MainViewModel extends ChangeNotifier {
  /// Route of the main screen
  static String route = '/';

  late BuildContext _context;

  /// locales of the app
  late AppLocalizations locales;

  int _selectedIndex = 0;

  /// Inits the view model
  Future<bool> init(BuildContext context) async {
    _context = context;

    return Future<bool>.microtask(() async {
      locales = AppLocalizations.of(_context)!;
      return true;
    });
  }

  /// sets the actual screens [index] as selected
  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// Returns index of the actual selected page
  int get selectedIndex {
    return _selectedIndex;
  }

  /// Logouts the user
  void logout() {
    // TODO implelemnt logout flow
    print('user logged out!');
  }

  /// Loads the selected page of the navigation
  void loadPage() {
    var routeService = RouterService.getInstance();
    var route = routeService.getNestedRoutes().keys.elementAt(_selectedIndex);
    routeService.nestedNavigatorKey.currentState!.pushNamed(route);
  }
}
