import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Info icon showing the [message] when hovered or tapped.
class InfoTooltip extends StatelessWidget {
  /// The shown information.
  final String message;

  /// Initializes the icon.
  const InfoTooltip({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      constraints: const BoxConstraints(maxWidth: 420),
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Icon(
          Symbols.info,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
