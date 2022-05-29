import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/router.dart';
import 'package:shimmer/shimmer.dart';

typedef LoadDataFunction = Future<ModelList> Function({
  String? filter,
  int? offset,
  int? take,
});
typedef DeleteFunction = Future<void> Function(List<ModelBase>);
typedef EditFunction = Future<void> Function(ModelBase);
typedef AddFunction = Future<void> Function();

class AsyncListView extends StatefulWidget {
  final LoadDataFunction loadData;
  final DeleteFunction deleteItems;
  final bool showAddButton;
  final AddFunction? addItem;
  final EditFunction editItem;

  const AsyncListView({
    Key? key,
    required this.loadData,
    required this.deleteItems,
    required this.editItem,
    this.showAddButton = true,
    this.addItem,
  }) : super(key: key);

  @override
  State<AsyncListView> createState() => _AsyncListViewState();
}

class _AsyncListViewState extends State<AsyncListView> {
  bool _isInMultiSelectMode = false;
  List<ModelBase> _selectedItems = [];
  final ScrollController _controller = ScrollController();
  ModelList? _items;
  String? _filter;
  bool _isLoadingData = true;

  //controller.addListener(() {
  //});

  @override
  void initState() {
    _loadData();
    super.initState();
  }

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
                      setState(() {
                        _filter = filterText;
                      });

                      _loadData();
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
                            showProgressIndicator();
                            widget.deleteItems(_selectedItems).then((value) {
                              RouterService.getInstance()
                                  .navigatorKey
                                  .currentState!
                                  .pop();
                              setState(() {
                                _isInMultiSelectMode = false;
                                _selectedItems = [];
                              });

                              _loadData();
                            }).onError((error, stackTrace) {
                              RouterService.getInstance()
                                  .navigatorKey
                                  .currentState!
                                  .pop();
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
            child: _isLoadingData
                ? _createLoadingWidget()
                : (_items!.totalCount > 0
                    ? _createListViewWidget()
                    : _createNoDataWidget()),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: widget.showAddButton,
        child: FloatingActionButton(
          onPressed: () {
            if (widget.addItem == null) {
              return;
            }

            widget.addItem!().then((value) {
              _loadData();
            });
          },
          tooltip: locales.add,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _onItemChecked(int index) {
    if (_selectedItems.contains(_items![index])) {
      _selectedItems.remove(_items![index]);
    } else {
      _selectedItems.add(_items![index]);
    }

    setState(() {
      _selectedItems = _selectedItems;
    });
  }

  void _loadData() {
    setState(() {
      _isLoadingData = true;
    });

    // TODO call load with indexes!
    widget.loadData(filter: _filter).then((value) {
      setState(() {
        _isLoadingData = false;
        _items = value;
      });
    }).onError((e, _) {
      setState(() {
        _isLoadingData = false;
        _items = ModelList([], 0);
      });
    });
  }

  Widget _createListViewWidget() {
    return ScrollConfiguration(
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
          // TODO Load more data/show loading list tile if actually not loaded

          return index < _items!.length
              ? _createListTile(index)
              : _createLoadingTile(context);
        },
        itemCount: _items?.totalCount ?? 0,
      ),
    );
  }

  Widget _createLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _createNoDataWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No data available!"),
          horizontalSpacer,
          TextButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: Text("Reload"),
          ),
        ],
      ),
    );
  }

  Widget _createListTile(int index) {
    var item = _items![index];

    return ListTile(
      leading: _isInMultiSelectMode
          ? Visibility(
              visible: item.isDeletable,
              child: Checkbox(
                onChanged: (_) {
                  _onItemChecked(index);
                },
                value: _selectedItems.contains(item),
              ),
            )
          : null,
      minVerticalPadding: 0,
      title: Text(item.getDisplayDescription()),
      onTap: () {
        if (!item.isDeletable && _isInMultiSelectMode) {
          return;
        }

        if (_isInMultiSelectMode) {
          _onItemChecked(index);
        } else {
          widget.editItem(item).then((value) {
            _loadData();
          });
        }
      },
      onLongPress: () {
        if (!item.isDeletable) {
          return;
        }

        if (!_isInMultiSelectMode) {
          setState(() {
            _isInMultiSelectMode = true;
          });
        }

        _onItemChecked(index);
      },
    );
  }

  Widget _createLoadingTile(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surfaceVariant,
      highlightColor: Theme.of(context).colorScheme.surface,
      child: ListTile(
        title: Stack(
          children: [
            Container(
              width: 200,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
