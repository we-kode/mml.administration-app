import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';

class AsyncListView extends StatefulWidget {
  //Function<> loadData;, required loadData

  const AsyncListView({Key? key}) : super(key: key);

  @override
  _AsyncListViewState createState() => _AsyncListViewState();
}

class _AsyncListViewState extends State<AsyncListView> {
  bool _isInMultiSelectMode = false;
  List<int> _selectedItems = [];
  ScrollController _controller = ScrollController();

  //controller.addListener(() {
  //});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: locales.filter,
                      icon: const Icon(Icons.filter_list_alt),
                    ),
                    onChanged: (String filterText) {
                      // TODO: Filter action
                    },
                  ),
                ),
                Visibility(
                  visible: _isInMultiSelectMode,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isInMultiSelectMode = false;
                              _selectedItems = [];
                            });
                          },
                          icon: const Icon(Icons.close),
                          tooltip: locales.cancel,
                        ),
                        horizontalSpacer,
                        Text("${_selectedItems.length}"),
                        horizontalSpacer,
                        IconButton(
                          onPressed: () {
                            // TODO: Delete action
                            setState(() {
                              _isInMultiSelectMode = false;
                              _selectedItems = [];
                            });
                          },
                          icon: const Icon(Icons.remove),
                          tooltip: locales.remove,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // TODO: Show Message for empty list and add infinite scroll/lazy loading
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: ListView.separated(
                controller: _controller,
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                  );
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: _isInMultiSelectMode
                        ? Checkbox(
                            onChanged: (_) {
                              onItemChecked(index);
                            },
                            value: _selectedItems.contains(index),
                          )
                        : null,
                    minVerticalPadding: 0,
                    title: Text("$index"), // TODO: Display
                    onTap: () {
                      if (_isInMultiSelectMode) {
                        onItemChecked(index);
                      }
                      // TODO: Edit action
                    },
                    onLongPress: () {
                      if (!_isInMultiSelectMode) {
                        setState(() {
                          _isInMultiSelectMode = true;
                        });
                      }

                      onItemChecked(index);
                    },
                  );
                },
                itemCount: 20000,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // TODO: Add action
        tooltip: locales.add,
        child: const Icon(Icons.add),
        // TODO: Visibility mode
      ),
    );
  }

  // TODO: Work with real items and guids
  void onItemChecked(int index) {
    if (_selectedItems.contains(index)) {
      _selectedItems.remove(index);
    } else {
      _selectedItems.add(index);
    }
    setState(() {
      _selectedItems = _selectedItems;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
