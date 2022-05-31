/// Base model with abstract methods that should be implemented by all models.
abstract class ModelBase {
  /// Indicates whether the model object is deletable.
  late bool isDeletable;

  /// Creates a new instance of the model.
  ///
  /// Shouldn't be used directly but be invoked by constructor of implementing
  /// model classes. Also the boolean [isDeletable] must be set here.
  ModelBase({this.isDeletable = true});

  /// Returns a display description of the model object, that
  /// can be used in widgets, e.g. lists.
  String getDisplayDescription();

  /// Returns the unique identifier of the model object.
  dynamic getIdentifier();
}
