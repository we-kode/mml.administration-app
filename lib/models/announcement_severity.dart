import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

/// Severities of an announcement shown to the clients.
abstract class AnnouncementSeverity {
  /// General information.
  static const int info = 1;

  /// Announcement of a maintenance.
  static const int maintenance = 2;

  /// Important message.
  static const int important = 3;

  /// All severities.
  static const List<int> values = [info, maintenance, important];

  /// Returns the icon of the [severity].
  static IconData icon(int severity) {
    return switch (severity) {
      maintenance => Symbols.construction,
      important => Symbols.priority_high,
      _ => Symbols.info,
    };
  }

  /// Returns the localized name of the [severity].
  static String text(int severity, AppLocalizations locales) {
    return switch (severity) {
      maintenance => locales.severityMaintenance,
      important => locales.severityImportant,
      _ => locales.severityInfo,
    };
  }
}
