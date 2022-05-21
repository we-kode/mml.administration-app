import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Overview screen of the uploaded records to the music lib.
class RecordsScreen extends StatelessWidget {
  /// Initializes the instance.
  const RecordsScreen({Key? key}) : super(key: key);

  /// Builds the records overview screen.
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Records lists here"),
    );
  }
}
