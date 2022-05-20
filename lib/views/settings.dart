import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Screen to modify own app settings.
class SettingsScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsScreen({Key? key}) : super(key: key);

  /// Builds the settings screen.
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Settings here"),
    );
  }
}
