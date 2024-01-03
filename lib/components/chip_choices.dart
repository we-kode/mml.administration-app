import 'package:flutter/material.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';

/// Function called, when selection of items changed.
typedef OnSelectionChanged = void Function(List<ModelBase> selectedItems);

/// Function to load data.
typedef LoadDataFunction = Future<ModelList> Function();

/// Creates a list of [ChoiceChips] with
/// all logic handled.
class ChipChoices extends StatefulWidget {
  /// Function to load data. Will be ignored, if [selectedItems] are provided.
  final LoadDataFunction? loadData;

  /// Function called when selected items changed.
  final OnSelectionChanged onSelectionChanged;

  /// Initial selected ietms.
  final List<ModelBase> initialSelectedItems;

  /// List of selecabel items. Must be provided, if load function is null.
  final ModelList? selectableItems;

  /// Constructor.
  const ChipChoices({
    Key? key,
    required this.initialSelectedItems,
    required this.onSelectionChanged,
    this.loadData,
    this.selectableItems,
  }) : super(key: key);

  @override
  State<ChipChoices> createState() => _ChipChoicesState();
}

class _ChipChoicesState extends State<ChipChoices> {
  /// Identifiers of the selected items in the list.
  List<ModelBase> _selectedValues = [];

  /// List of lazy loaded items.
  ModelList _items = ModelList(List.empty(growable: true), 0, 0);

  /// Determines whether [item] is selected.
  bool _isActive(ModelBase item) {
    return _selectedValues
        .any((element) => element.getIdentifier() == item.getIdentifier());
  }

  /// Text color of the active item.
  var activeColor = Colors.black54;

  @override
  void initState() {
    _selectedValues = widget.initialSelectedItems.toList();
    _reloadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    activeColor = isDarkMode ? Colors.black54 : Colors.white;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          _items.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: ChoiceChip(
              showCheckmark: true,
              side: BorderSide(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              label: Text(_items[index]!.getDisplayDescription()),
              labelStyle: _isActive(_items[index]!)
                  ? TextStyle(color: Theme.of(context).colorScheme.secondary)
                  : null,
              selected: _isActive(_items[index]!),
              selectedColor: Theme.of(context).colorScheme.background,
              onSelected: (val) {
                final item = _items[index]!;
                if (_isActive(item)) {
                  _selectedValues.remove(item);
                } else {
                  _selectedValues.add(item);
                }

                widget.onSelectionChanged(_selectedValues);

                // update UI
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Reloads the data.
  void _reloadData() {
    if (!mounted) {
      return;
    }

    if (widget.selectableItems != null) {
      _items = widget.selectableItems!;
    } else if (widget.loadData != null) {
      _loadData();
    }
  }

  /// Loads the data..
  void _loadData() {
    var dataFuture = widget.loadData!();

    dataFuture.then((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        _items = value;
      });
    }).onError((e, _) {
      if (!mounted) {
        return;
      }

      setState(() {
        _items = ModelList([], 0, 0);
      });
    });
  }
}
