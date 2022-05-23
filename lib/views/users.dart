import 'package:flutter/material.dart';

/// Overview screen of the administration users of the music lib.
class UsersScreen extends StatelessWidget {
  /// Initializes the instance.
  const UsersScreen({Key? key}) : super(key: key);

  /// Builds the overview screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Filter", // TODO: Translation
                      icon: Icon(Icons.filter_list_alt),
                    ),
                  ),
                ),
                Visibility(
                  visible: false, // TODO: Selection State
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {}, // TODO: Delete action
                      child: const Text("Löschen"), // TODO: Translation
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                );
              },
              itemBuilder: (context, index) {
                return ListTile(
                  minVerticalPadding: 0,
                  title: Text("$index"), // TODO: Display
                  onTap: () {}, // TODO: Edit action
                  onLongPress: () {}, // TODO: Multiselect for deletion
                );
              },
              itemCount: 50,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // TODO: Add action
        child: const Icon(Icons.add),
        tooltip: "Hinzufügen", // TODO: Translation
        // TODO: Visibility mode
      ),
    );
  }
}
