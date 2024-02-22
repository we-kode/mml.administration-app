import 'package:flutter/material.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:shimmer/shimmer.dart';

/// Function to load data with the passed [filter] starting from [offset] and
/// loading an amount of [take] data.
typedef LoadDataFunction = Future<ModelList> Function({
  String? filter,
  int? offset,
  int? take,
});

/// Function to load initial data.
typedef LoadInitialDataFunction = Future<List<String>> Function();

/// A dialog inlcuding a selection list.
///
/// The list supports async loading of data, when necessary in chunks.
class AsyncSelectListDialog extends StatefulWidget {
  /// Function to load data with the passed [filter], starting from [offset] and
  /// loading an amount of [take] data.
  final LoadDataFunction loadData;

  /// List of inital selected values.
  final List<dynamic> initialSelected;

  /// Inidcates whether the checkboxes are in three state mode. If used, the loadInitial function must be provided.
  final bool threeState;

  /// Loads inital data. If set the initialSelected field will be ignored.
  final LoadInitialDataFunction? loadInitial;

  /// Initializes the list view.
  const AsyncSelectListDialog({
    Key? key,
    required this.loadData,
    required this.initialSelected,
    this.threeState = false,
    this.loadInitial,
  }) : super(key: key);

  @override
  State<AsyncSelectListDialog> createState() => _AsyncSelectListDialogState();
}

class _AsyncSelectListDialogState extends State<AsyncSelectListDialog> {
  /// Initial offset to start loading data from.
  final int _initialOffset = 0;

  /// Intial amount of data that should be loaded.
  final int _initialTake = 100;

  /// Delta the [_offset] should be increased or decreased while scrolling and
  /// lazy loading next/previuous data.
  final int _offsetDelta = 50;

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

  /// Identifiers of the selected items in the list.
  List<dynamic> _selectedValues = [];

  /// Identifiers of the initial selected items in the list.
  List<dynamic> _initialSelectedValues = [];

  @override
  void initState() {
    if (widget.threeState && widget.loadInitial == null) {
      throw Exception("If threeState is set provide ladInitialFunction");
    }

    if (widget.threeState) {
      var dataFuture = widget.loadInitial!();

      dataFuture.then((value) {
        if (!mounted) {
          return;
        }

        setState(() {
          _initialSelectedValues = value;
        });
      });
    } else {
      _selectedValues = widget.initialSelected.toList();
    }

    _reloadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
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
      ),
      actions: _createActions(context),
    );
  }

  /// Stores the identifer of the item at the [index] or removes it, when
  /// the identifier was in the list of selected items.
  void _onItemChecked(int index) {
    if (_selectedValues.contains(_items![index]?.getIdentifier())) {
      _selectedValues.remove(_items![index]?.getIdentifier());

      if (widget.threeState) {
        _initialSelectedValues.remove(_items![index]?.getIdentifier());
      }
    } else if (_items![index] != null) {
      _selectedValues.add(_items![index]!.getIdentifier());
    }

    setState(() {
      _selectedValues = _selectedValues;
    });
  }

  /// Reloads the data starting from inital offset with inital count.
  void _reloadData() {
    if (!mounted) {
      return;
    }

    _offset = _initialOffset;
    _take = _initialTake;

    _loadData();
  }

  /// Loads the data for the [_offset] and [_take].
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.noData,
            softWrap: true,
          ),
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

  /// Creates the list header widget with filter and remove action buttons.
  Widget _createListHeaderWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Filter input.
        Expanded(
          child: Column(
            children: [
              TextField(
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
            ],
          ),
        ),
      ],
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

  /// Creates a tile widget for one list item at the given [index].
  Widget _createListTile(int index) {
    var item = _items![index];

    if (item == null) {
      return _createLoadingTile();
    }

    final isOnlyInitial = widget.threeState &&
        _initialSelectedValues.contains(item.getIdentifier()) &&
        !_selectedValues.contains(item.getIdentifier());
    var leadingTile = Checkbox(
      onChanged: (_) {
        _onItemChecked(index);
      },
      value: _selectedValues.contains(item.getIdentifier()) || isOnlyInitial,
      activeColor: isOnlyInitial ? Colors.grey : null,
    );

    return ListTile(
      leading: leadingTile,
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: 0),
      title: Row(
        children: [
          Text(item.getDisplayDescription()),
        ],
      ),
      onTap: () {
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

  /// Creates a list of action widgets that should be shown at the bottom of the dialog.
  List<Widget> _createActions(
    BuildContext context,
  ) {
    var locales = AppLocalizations.of(context)!;
    var result = widget.threeState
        ? [_initialSelectedValues, _selectedValues]
        : _selectedValues;
    return [
      TextButton(
        onPressed: () => Navigator.pop(context, null),
        child: Text(locales.cancel),
      ),
      TextButton(
        onPressed: () => Navigator.pop(
          context,
          result,
        ),
        child: Text(locales.save),
      )
    ];
  }
}
