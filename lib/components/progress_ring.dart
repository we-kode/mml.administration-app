import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

/// Shows the progress of a transfer as a ring with the percentage in its
/// center.
class ProgressRing extends StatelessWidget {
  /// Progress between 0 and 1.
  final double value;

  /// Diameter of the ring.
  final double size;

  /// Initializes the ring.
  const ProgressRing({super.key, required this.value, this.size = 36});

  @override
  Widget build(BuildContext context) {
    var percent = (value * 100).floor();
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: size / 12,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size / 6),
            child: FittedBox(
              child: Text(
                AppLocalizations.of(context)!.transferPercent(percent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
