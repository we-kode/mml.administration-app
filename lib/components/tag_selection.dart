import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/async_select_list_dialog.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/model_base.dart';

/// Shows selected items as chips and lets the admin select further items
/// in an [AsyncSelectListDialog].
class TagSelection<T extends ModelBase> extends StatefulWidget {
  /// Label of the selection.
  final String label;

  /// Hint shown below the selection.
  final String? helperText;

  /// The selected items, which are changed by the selection.
  final List<T> values;

  /// Function to load the selectable items.
  final LoadDataFunction loadData;

  /// Initializes the selection.
  const TagSelection({
    super.key,
    required this.label,
    required this.values,
    required this.loadData,
    this.helperText,
  });

  @override
  State<TagSelection<T>> createState() => _TagSelectionState<T>();
}

class _TagSelectionState<T extends ModelBase> extends State<TagSelection<T>> {
  /// Items known by their identifier, so selected identifiers can be shown
  /// by name.
  final Map<dynamic, T> _known = {};

  Future<void> _select() async {
    for (var value in widget.values) {
      _known[value.getIdentifier()] = value;
    }

    var selected = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AsyncSelectListDialog(
        loadData: ({filter, offset, take}) async {
          var items = await widget.loadData(
            filter: filter,
            offset: offset,
            take: take,
          );
          for (var item in items.whereType<T>()) {
            _known[item.getIdentifier()] = item;
          }
          return items;
        },
        initialSelected: widget.values.map((v) => v.getIdentifier()).toList(),
      ),
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      widget.values
        ..clear()
        ..addAll(List.from(selected).map((id) => _known[id]).whereType<T>());
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(widget.label, style: theme.textTheme.bodySmall),
            ),
            IconButton(
              icon: const Icon(Symbols.add),
              tooltip: AppLocalizations.of(context)!.add,
              onPressed: _select,
            ),
          ],
        ),
        if (widget.values.isNotEmpty)
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: widget.values
                .map(
                  (value) => InputChip(
                    label: Text(value.getDisplayDescription()),
                    onDeleted: () =>
                        setState(() => widget.values.remove(value)),
                  ),
                )
                .toList(),
          ),
        if (widget.helperText != null)
          Text(widget.helperText!, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
