///
abstract class ModelBase {
  ///
  late bool isDeletable;

  ///
  ModelBase({this.isDeletable = true});

  ///
  String getDisplayDescription();

  dynamic getIdentifier();
}
