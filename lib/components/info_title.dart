import 'package:material_ui/material_ui.dart';

/// A title followed by an info icon, which shows the [info] on hover or tap.
class InfoTitle extends StatelessWidget {
  /// The title text.
  final String title;

  /// The explanation shown by the info icon.
  final String info;

  /// Style of the title.
  final TextStyle? style;

  /// Initializes the instance.
  const InfoTitle({
    super.key,
    required this.title,
    required this.info,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: Text(title, style: style)),
        const SizedBox(width: 8),
        Tooltip(
          message: info,
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 10),
          constraints: const BoxConstraints(maxWidth: 320),
          child: Icon(
            Icons.info_outline,
            size: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
