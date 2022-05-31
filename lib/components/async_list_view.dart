import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/router.dart';
import 'package:shimmer/shimmer.dart';

/// Function to load data with the passed [filter], starting from [offset] and
/// loading an amount of [take] data.
typedef LoadDataFunction = Future<ModelList> Function({
  String? filter,
  int? offset,
  int? take,
});

/// Function that deletes the items with the passed [itemIdentifiers].
///
/// This function should return a [Future], that either resolves with true
/// after successful deletion or false on cancel.
/// The list will reload the data starting from beginning, if true will be
/// returned.
typedef DeleteFunction = Future<bool> Function<T>(List<T> itemIdentifiers);

/// Function that updates the passed [item].
///
/// This function should return a [Future], that either resolves with true
/// after successful update or false on cancel.
/// The list will reload the data starting from beginning, if true will be
/// returned.
typedef EditFunction = Future<bool> Function(ModelBase item);

/// Function that creates an new item.
///
/// This function should return a [Future], that either resolves with true
/// after successful creation or false on cancel.
/// The list will reload the data starting from beginning, if true will be
/// returned.
typedef AddFunction = Future<bool> Function();

/// List that supports async loading of data, when necessary in chunks.
class AsyncListView extends StatefulWidget {
  /// Function to load data with the passed [filter], starting from [offset] and
  /// loading an amount of [take] data.
  final LoadDataFunction loadData;

  /// Function that deletes the items with the passed [itemIdentifiers].
  ///
  /// This function should return a [Future], that either resolves with true
  /// after successful deletion or false on cancel.
  /// The list will reload the data starting from beginning, if true will be
  /// returned.
  final DeleteFunction deleteItems;

  /// Indicates, whether the add button should be shown or not.
  final bool showAddButton;

  /// Function that creates an new item.
  ///
  /// This function should return a [Future], that either resolves with true
  /// after successful creation or false on cancel.
  /// The list will reload the data starting from beginning, if true will be
  /// returned.
  final AddFunction? addItem;

  /// Function that updates the passed [item].
  ///
  /// This function should return a [Future], that either resolves with true
  /// after successful update or false on cancel.
  /// The list will reload the data starting from beginning, if true will be
  /// returned.
  final EditFunction editItem;

  /// Initializes the list view.
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

/// State of the list view.
class _AsyncListViewState extends State<AsyncListView> {
  /// Initial offset to start loading data from.
  final int _initialOffset = 0;

  /// Intial amount of data that should be loaded.
  final int _initialTake = 100;

  /// Delta the [_offset] should be increased or decreased while scrolling and
  /// lazy loading next/previuous data.
  final int _offsetDelta = 50;

  /// Indicates, whether the list is currently in multi select mode.
  bool _isInMultiSelectMode = false;

  /// Identifiers of the selected items in the list.
  List<dynamic> _selectedItems = [];

  /// List of lazy loaded items.
  ModelList? _items;

  /// Filter to send to the sever.
  String? _filter;

  /// Offset to start loading data from.
  int _offset = 0;

  /// Amount of data that should be loaded starting from [_offset].
  int _take = 100;

  /// Indicates, whether data is loading and an loading indicator should be
  /// shown.
  bool _isLoadingData = true;

  @override
  void initState() {
    _reloadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // List header with filter and action buttons.
          _createListHeaderWidget(),

          // List, loading indicator or no data widget.
          Expanded(
            child: _isLoadingData
                ? _createLoadingWidget()
                : (_items!.totalCount > 0
                    ? _createListViewWidget()
                    : _createNoDataWidget()),
          ),
        ],
      ),

      // Floating button.
      floatingActionButton: Visibility(
        visible: widget.showAddButton,
        child: FloatingActionButton(
          onPressed: () {
            if (widget.addItem == null) {
              return;
            }

            widget.addItem!().then((value) {
              if (value) {
                _reloadData();
              }
            });
          },
          tooltip: AppLocalizations.of(context)!.add,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Stores the identifer of the item at the [index] or removes it, when
  /// the identifier was in the list of selected items.
  void _onItemChecked(int index) {
    if (_selectedItems.contains(_items![index]?.getIdentifier())) {
      _selectedItems.remove(_items![index]?.getIdentifier());
    } else if (_items![index] != null) {
      _selectedItems.add(_items![index]!.getIdentifier());
    }

    setState(() {
      _selectedItems = _selectedItems;
    });
  }

  /// Reloads the data starting from inital offset with inital count.
  void _reloadData() {
    _offset = _initialOffset;
    _take = _initialTake;

    _loadData();
  }

  /// Loads the data for the [_offset] and [_take] with the [_filter].
  ///
  /// Shows a loading indicator instead of the list during load, if
  /// [showLoadingOverlay] is true.
  /// Otherwhise the data will be loaded lazy in the background.
  void _loadData({bool showLoadingOverlay = true}) {
    if (showLoadingOverlay) {
      setState(() {
        _isLoadingData = true;
      });
    }

    var dataFuture = widget.loadData(
      filter: _filter,
      offset: _offset,
      take: _take,
    );

    dataFuture.then((value) {
      setState(() {
        _isLoadingData = false;
        _items = value;
      });
    }).onError((e, _) {
      setState(() {
        _isLoadingData = false;
        _items = ModelList([], _initialOffset, 0);
      });
    });
  }

  /// Creates the list header widget with filter and remove action buttons.
  Widget _createListHeaderWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Filter input.
          Visibility(
            visible: !_isInMultiSelectMode,
            child: Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.filter,
                  icon: const Icon(Icons.filter_list_alt),
                ),
                onChanged: (String filterText) {
                  setState(() {
                    _filter = filterText;
                  });

                  _reloadData();
                },
              ),
            ),
          ),

          // Remove action buttons. Only visible in multi select mode.
          Visibility(
            visible: _isInMultiSelectMode,
            child: Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                      tooltip: AppLocalizations.of(context)!.cancel,
                    ),
                    horizontalSpacer,
                    Text("${_selectedItems.length}"),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        showProgressIndicator();
                        widget.deleteItems(_selectedItems).then((value) {
                          RouterService.getInstance()
                              .navigatorKey
                              .currentState!
                              .pop();

                          if (!value) {
                            return;
                          }

                          setState(() {
                            _isInMultiSelectMode = false;
                            _selectedItems = [];
                          });

                          _reloadData();
                        }).onError((error, stackTrace) {
                          RouterService.getInstance()
                              .navigatorKey
                              .currentState!
                              .pop();
                        });
                      },
                      icon: const Icon(Icons.remove),
                      tooltip: AppLocalizations.of(context)!.remove,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates the list view widget.
  Widget _createListViewWidget() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
      ),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
          );
        },
        itemBuilder: (context, index) {
          var endNotReached = (_offset + _take) <= _items!.totalCount;
          var loadNextIndexReached =
              index == (_offset + _take - (_offsetDelta / 2).ceil());
          var loadPreviuousIndexReached = index == _offset;
          var beginNotReached = index > 0;

          if (endNotReached && loadNextIndexReached) {
            _offset = _offset + _offsetDelta;
            _take = _initialTake + _offsetDelta;

            Future.microtask(() {
              _loadData(showLoadingOverlay: false);
            });
          } else if (beginNotReached && loadPreviuousIndexReached) {
            _offset = _offset - _offsetDelta;
            _take = _initialTake + _offsetDelta;

            Future.microtask(() {
              _loadData(showLoadingOverlay: false);
            });
          }

          var itemLoaded = index < (_offset + _take) && (index - _offset) >= 0;

          return itemLoaded ? _createListTile(index) : _createLoadingTile();
        },
        itemCount: _items?.totalCount ?? 0,
      ),
    );
  }

  /// Creates a loading indicator widget.
  Widget _createLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Creates a widget that will be shown, if no data were loaded or an error
  /// occured during loading of data.
  Widget _createNoDataWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.noData),
          horizontalSpacer,
          TextButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.reload),
          ),
        ],
      ),
    );
  }

  /// Creates a tile widget for one list item at the given [index].
  Widget _createListTile(int index) {
    var item = _items![index];

    if (item == null) {
      return _createLoadingTile();
    }

    var ledingTile = !_isInMultiSelectMode
        ? null
        : Visibility(
            visible: item.isDeletable,
            child: Checkbox(
              onChanged: (_) {
                _onItemChecked(index);
              },
              value: _selectedItems.contains(item.getIdentifier()),
            ),
          );

    return ListTile(
      leading: ledingTile,
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
            if (value) {
              _reloadData();
            }
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

  /// Creates a list tile widget for a not loded list item.
  Widget _createLoadingTile() {
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
}
