import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/expandable_fab.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/components/list_subfilter_view.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/navigation_state.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/services/router.dart';
import 'package:shimmer/shimmer.dart';

/// Function to load data with the passed [filter], starting from [offset] and
/// loading an amount of [take] data. Also a [subfilter] can be added to filter the list more specific.
typedef LoadDataFunction = Future<ModelList> Function({
  String? filter,
  int? offset,
  int? take,
  Subfilter? subfilter,
});

/// Function that deletes the items with the passed [itemIdentifiers].
///
/// This function should return a [Future], that either resolves with true
/// after successful deletion or false on cancel.
/// The list will reload the data starting from beginning, if true will be
/// returned.
typedef DeleteFunction = Future<bool> Function<T>(List<T> itemIdentifiers);

/// Function to be called when the back button is pressed. And the list should navigate up in folder structure.
typedef MoveUpFunction = Function(
  Subfilter? subFilter,
);

/// Function that updates the passed [item].
///
/// This function should return a [Future], that either resolves with true
/// after successful update or false on cancel.
/// The list will reload the data starting from beginning, if true will be
/// returned.
typedef EditFunction = Future<bool> Function(
    ModelBase item, Subfilter? subFilter);

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

  /// Subaction buttons which can be used to add multiple sub actions to the main add button
  final List<ActionButton>? subactions;

  /// A subfilter widget which can be used to add subfilters like chips for more filter posibilities.
  final ListSubfilterView? subfilter;

  /// Navigation state if a hierarchical view is used.
  final NavigationState? navState;

  /// Function to be called when the back button is pressed. And the list should navigate up in folder structure.
  final MoveUpFunction? moveUp;

  /// Initializes the list view.
  const AsyncListView({
    Key? key,
    required this.loadData,
    required this.deleteItems,
    required this.editItem,
    this.addItem,
    this.showAddButton = true,
    this.subactions,
    this.subfilter,
    this.navState,
    this.moveUp,
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

  /// The actual item group if list items should be grouped.
  String? _actualGroup;

  @override
  void initState() {
    _reloadData();
    if (widget.subfilter != null) {
      widget.subfilter!.filter.addListener(() {
        _reloadData();
      });
    }
    if (widget.navState != null) {
      widget.navState!.addListener(_handleNavState);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.subfilter?.filter.removeListener(() {});
    widget.navState?.removeListener(_handleNavState);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (event) => {
        if (event.isKeyPressed(LogicalKeyboardKey.f5)) {_reloadData()}
      },
      child: Scaffold(
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
        floatingActionButton: _createActionButton(),
      ),
    );
  }

  /// Called when hierarchical view in list is used and the back button is pressed or some changes in navigation took place.
  void _handleNavState() {
    if (!widget.navState!.returnClicked) {
      return;
    }

    if (widget.navState!.returnClicked) {
      widget.navState!.returnReleased();
      widget.moveUp != null ? widget.moveUp!(widget.subfilter?.filter) : null;
    }
  }

  /// Stores the identifer of the item at the [index] or removes it, when
  /// the identifier was in the list of selected items.
  void _onItemChecked(int index) {
    if (_selectedItems.any(
        (item) => item.getIdentifier() == _items![index]?.getIdentifier())) {
      _selectedItems.remove(_items![index]);
    } else if (_items![index] != null) {
      _selectedItems.add(_items![index]!);
    }

    setState(() {
      _selectedItems = _selectedItems;
    });
  }

  /// Reloads the data starting from inital offset with inital count.
  void _reloadData() {
    if (!mounted) {
      return;
    }

    _offset = _initialOffset;
    _take = _initialTake;

    _loadData(subfilter: widget.subfilter?.filter);
  }

  /// Loads the data for the [_offset] and [_take] with the [_filter].
  ///
  /// Shows a loading indicator instead of the list during load, if
  /// [showLoadingOverlay] is true.
  /// Otherwhise the data will be loaded lazy in the background.
  void _loadData({
    bool showLoadingOverlay = true,
    Subfilter? subfilter,
  }) {
    if (showLoadingOverlay) {
      setState(() {
        _isLoadingData = true;
      });
    }

    var dataFuture = widget.loadData(
      filter: _filter,
      offset: _offset,
      take: _take,
      subfilter: subfilter,
    );

    dataFuture.then((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingData = false;
        _items = value;
      });
    }).onError((e, _) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingData = false;
        _items = ModelList([], _initialOffset, 0);
      });
    });
  }

  /// Show a floating action button or an expanding fab.
  ///
  /// When no sub action buttons given, only the add action button is shown, when [widget.showAddButton] is true.
  /// When a list of sub action buttons is provided, an expandable action button will be shown.
  Widget _createActionButton() {
    return Visibility(
      visible: widget.showAddButton,
      child: widget.subactions != null && widget.subactions!.isNotEmpty
          ? ExpandableFab(
              distance: 96.0,
              children: widget.subactions!,
            )
          : FloatingActionButton(
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
    );
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
              child: Column(
                children: [
                  Row(
                    children: [
                      if (widget.navState != null)
                        IconButton(
                          onPressed: widget.navState!.path != null
                              ? () => widget.navState!.returnPressed()
                              : null,
                          icon: const Icon(Icons.arrow_back),
                        ),
                      IconButton(
                        onPressed: () => _reloadData(),
                        icon: const Icon(Icons.refresh),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            (widget.navState != null ? 0.855 : 0.88),
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
                      )
                    ],
                  ),
                  // add subfilter if one is provided.
                  verticalSpacer,
                  if (widget.subfilter != null) widget.subfilter!,
                  if (widget.navState?.path != null)
                    Chip(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      label: Text(
                        widget.navState!.path!,
                      ),
                    ),
                ],
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
                          if (!mounted) {
                            return;
                          }

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
                          if (!mounted) {
                            return;
                          }

                          RouterService.getInstance()
                              .navigatorKey
                              .currentState!
                              .pop();
                        });
                      },
                      icon: const Icon(Icons.delete),
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
              _loadData(
                showLoadingOverlay: false,
                subfilter: widget.subfilter?.filter,
              );
            });
          } else if (beginNotReached && loadPreviuousIndexReached) {
            _offset = _offset - _offsetDelta;
            _take = _initialTake + _offsetDelta;

            Future.microtask(() {
              _loadData(
                showLoadingOverlay: false,
                subfilter: widget.subfilter?.filter,
              );
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
            onPressed: () => _loadData(subfilter: widget.subfilter?.filter),
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.reload),
          ),
        ],
      ),
    );
  }

  /// Creates a tile widget for one list item at the given [index] or a group widget.
  Widget _createListTile(int index) {
    var item = _items![index];

    if (item == null) {
      return _createLoadingTile();
    }

    var leadingTile = !_isInMultiSelectMode
        ? item.getPrefixIcon(context) != null
            ? item.getPrefixIcon(context)!
            : null
        : Checkbox(
            onChanged: (_) {
              _onItemChecked(index);
            },
            value: _selectedItems
                .any((elem) => elem.getIdentifier() == item.getIdentifier()),
          );

    var itemGroup = item.getGroup(context) ?? '';
    if (itemGroup.isEmpty || (widget.subfilter?.filter.isGrouped ?? false)) {
      return _listTile(leadingTile, item, index);
    }

    // Grouping if first element or
    // group is a new one and the predecessor has another group
    if (index == 0 ||
        (itemGroup != _actualGroup &&
            _items![index - 1]?.getGroup(context) != itemGroup) ||
        _items![index - 1]?.getGroup(context) != itemGroup) {
      _actualGroup = itemGroup;
      return Column(
        children: [
          Chip(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            label: Text(
              item.getGroup(context)!,
            ),
          ),
          _listTile(leadingTile, item, index),
        ],
      );
    }

    return _listTile(leadingTile, item, index);
  }

  /// Creates a tile widget for one list [item] at the given [index].
  ListTile _listTile(Widget? leadingTile, ModelBase item, int index) {
    final trailingSubStyle = Theme.of(context).textTheme.bodyMedium;
    return ListTile(
      leading: leadingTile,
      minVerticalPadding: 10,
      visualDensity: const VisualDensity(vertical: 0),
      title: Wrap(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              item.getDisplayDescription(),
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          _createTitleSuffix(item),
        ],
      ),
      subtitle: (item.getTags() != null || item.getSubtitle(context) != null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.getSubtitle(context) != null)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      item.getSubtitle(context)!,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                _getGroupTags(item) ?? const SizedBox.shrink(),
              ],
            )
          : null,
      trailing: (item.getMetadata(context) != null ||
              item.getSubMetadata(context) != null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 3,
                ),
                item.getMetadata(context) != null
                    ? Text(
                        item.getMetadata(context)!,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 5,
                ),
                item.getSubMetadata(context) != null
                    ? Text(
                        item.getSubMetadata(context)!,
                        style: trailingSubStyle!.copyWith(
                          color: Theme.of(context).textTheme.bodySmall!.color,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            )
          : null,
      onTap: () {
        if (!item.isDeletable && _isInMultiSelectMode) {
          return;
        }

        if (_isInMultiSelectMode) {
          _onItemChecked(index);
        } else {
          widget.editItem(item, widget.subfilter?.filter).then((value) {
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

  /// Creates Tags in the list if some tags exists.
  Row? _getGroupTags(ModelBase item) {
    return item.getTags() != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: item
                .getTags()!
                .map(
                  (tag) => Padding(
                    padding: const EdgeInsets.all(5),
                    child: Chip(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      backgroundColor: tag.color,
                      label: Text(tag.name),
                    ),
                  ),
                )
                .toList(),
          )
        : null;
  }

  /// Cretaes a suffix widget of the title if suffix exists.
  Widget _createTitleSuffix(ModelBase? item) {
    if (item!.getDisplayDescriptionSuffix(context) != null) {
      return Text(
        " (${item.getDisplayDescriptionSuffix(context)})",
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return const Text('');
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
