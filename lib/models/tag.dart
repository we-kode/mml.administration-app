import 'dart:ui';

/// Tag model that is used to display chips for example in the list view.
class Tag {
  /// Name that should be displayed.
  String name;

  /// Custom background color for the chip.
  Color? color;

  /// Initializes the tag model.
  Tag({required this.name, this.color});
}
