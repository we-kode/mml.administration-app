import 'package:flutter/material.dart';

/// Subfilter model, which can be extended by specific filters.
abstract class Subfilter extends ChangeNotifier {
  /// True, if the view should be grouped.
  bool isGrouped = false;

  /// Replaces the filter values with the values of the [other] filter. Filters
  /// that are not used for groups ignore it.
  void replaceWith(covariant Subfilter other) {}
}
