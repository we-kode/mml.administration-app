import 'package:mml_admin/models/model_base.dart';

/// A selectable value with a display name, e.g. for selection dialogs.
class SelectOption extends ModelBase {
  /// The selected value.
  final dynamic value;

  /// The display name of the value.
  final String label;

  /// Initializes the option.
  SelectOption(this.value, this.label);

  @override
  String getDisplayDescription() {
    return label;
  }

  @override
  dynamic getIdentifier() {
    return value;
  }
}
