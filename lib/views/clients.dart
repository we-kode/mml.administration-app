import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Overview screen of the app clients of the music lib.
class ClientsScreen extends StatelessWidget {
  /// Initializes the instance.
  const ClientsScreen({Key? key}) : super(key: key);

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Clients lists here"),
    );
  }
}
