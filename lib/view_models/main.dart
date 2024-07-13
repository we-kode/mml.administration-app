import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/user.dart';

/// View model for the main screen.
class MainViewModel extends ChangeNotifier {
  /// Route of the main screen.
  static String route = '/';

  /// The repository url to which the app belongs to.
  static String repository = '';

  /// The name of the released file without version, platform and extension.
  static String fileName = '';

  /// The uri where the changelog can be found;
  static String changeLogUri =
      'https://api.github.com/repos/we-kode/mml.administration-app/releases/tags/';

  /// The uri of the binary.
  static String binaryUri = 'https://github.com/$repository/releases/download/';

  /// The uri of the latest version endoint.
  static String latestVersionUri =
      'https://api.github.com/repos/$repository/releases/latest';

  late BuildContext _context;

  /// Locales of the app.
  late AppLocalizations locales;

  /// Index of the currently selected route.
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
    showProgressIndicator();
    await UserService.getInstance().logout();
  }

  /// Loads the selected page of the navigation.
  void loadPage() {
    // Get the nested navigator state to change the nested route.
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

  /// Returns the extension of the file depending on the operating system.
  static String get extension {
    if (Platform.isWindows) {
      return '.msix';
    } else if (Platform.isMacOS) {
      return '.dmg';
    }

    return '.zip';
  }
}
