import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/user.dart';

/// View model for the main screen.
class MainViewModel extends ChangeNotifier {
  /// Route of the main screen.
  static String route = '/';

  late BuildContext _context;

  /// Locales of the app.
  late AppLocalizations locales;

  int _selectedIndex = 0;

  /// Initializes the view model.
  Future<bool> init(BuildContext context) async {
    _context = context;
    locales = AppLocalizations.of(_context)!;

    return Future<bool>.microtask(() async {
      return true;
    });
  }

  /// Sets the actual screens [index] as selected.
  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// Returns index of the actual selected page.
  int get selectedIndex {
    return _selectedIndex;
  }

  /// Logouts the user.
  void logout() async {
    showProgressIndicator(
      RouterService.getInstance().navigatorKey.currentContext!,
    );
    await UserService.getInstance().logout();
  }

  /// Loads the selected page of the navigation.
  void loadPage() {
    NavigatorState? state;
    _context.visitChildElements((element) {
      element.visitChildElements((element) {
        element.visitChildElements((element) {
          element.visitChildElements((element) {
            if (element.widget is Navigator) {
              state = (element as StatefulElement).state as NavigatorState;
            }
          });
        });
      });
    });
    var routeService = RouterService.getInstance();
    var route = routeService.nestedRoutes.keys.elementAt(_selectedIndex);
    state?.pushReplacementNamed(route);
  }
}
