import 'package:flutter/material.dart';

/// Chip in the style of the list filters, which shows whether it is selected.
class SelectChip extends StatelessWidget {
  /// Label of the chip.
  final String label;

  /// Icon shown in front of the label.
  final IconData icon;

  /// Indicates whether the chip is selected.
  final bool selected;

  /// Called when the chip is pressed.
  final VoidCallback onPressed;

  /// Initializes the chip.
  const SelectChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var activeColor = theme.brightness == Brightness.dark
        ? Colors.black54
        : Colors.white;

    return InputChip(
      side: BorderSide.none,
      label: Text(label),
      labelStyle: selected ? TextStyle(color: activeColor) : null,
      backgroundColor: selected
          ? theme.colorScheme.secondary
          : theme.colorScheme.outlineVariant,
      avatar: Icon(
        icon,
        color: selected ? activeColor : theme.colorScheme.onSurfaceVariant,
      ),
      onPressed: onPressed,
    );
  }
}
