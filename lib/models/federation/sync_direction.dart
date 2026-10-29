import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Directions a rule is applied to.
abstract class SyncDirection {
  /// Own records sent to the partner.
  static const int outgoing = 1;

  /// Records received from the partner.
  static const int incoming = 2;

  /// Returns the icon of the [direction], which is used for records, rules
  /// and audit log entries.
  static IconData icon(int direction) {
    return direction == outgoing
        ? Symbols.sync_arrow_up
        : Symbols.sync_arrow_down;
  }
}
