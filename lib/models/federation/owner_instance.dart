import 'package:mml_admin/models/model_base.dart';

/// An instance owning records.
class OwnerInstance extends ModelBase {
  /// The instance name.
  final String name;

  /// Initializes the model.
  OwnerInstance(this.name);

  @override
  String getDisplayDescription() {
    return name;
  }

  @override
  dynamic getIdentifier() {
    return name;
  }
}
