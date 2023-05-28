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
  /// Function to load data.
  final LoadDataFunction loadData;

  /// Function called when selected items changed.
  final OnSelectionChanged onSelectionChanged;

  /// Initial selected ietms.
  final List<ModelBase> initialSelectedItems;

  /// Constructor.
  const ChipChoices({
    Key? key,
    required this.loadData,
    required this.initialSelectedItems,
    required this.onSelectionChanged,
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
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      runSpacing: 0.0,
      spacing: 0.0,
      children: List.generate(
        _items.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ChoiceChip(
            label: Text(_items[index]!.getDisplayDescription()),
            labelStyle: _isActive(_items[index]!)
                ? TextStyle(color: activeColor)
                : null,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            selected: _isActive(_items[index]!),
            selectedColor: _isActive(_items[index]!)
                ? Theme.of(context).colorScheme.secondary
                : null,
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
    );
  }

  /// Reloads the data.
  void _reloadData() {
    if (!mounted) {
      return;
    }

    _loadData();
  }

  /// Loads the data..
  void _loadData() {
    var dataFuture = widget.loadData();

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
