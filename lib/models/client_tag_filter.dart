import 'package:json_annotation/json_annotation.dart';
import 'package:mml_admin/models/subfilter.dart';

part 'client_tag_filter.g.dart';

/// Client tag filter.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class ClientTagFilter extends Subfilter {
  /// Ids of groups tags.
  List<String> groups = [];

  /// Shows only new clients
  bool onlyNew = false;

  /// Initializes the model.
  ClientTagFilter({
    List<String>? groups,
    this.onlyNew = false,
  }) {
    this.groups = groups ?? [];
  }

  /// Converts a json object/map to the model.
  factory ClientTagFilter.fromJson(Map<String, dynamic> json) =>
      _$ClientTagFilterFromJson(json);

  /// Converts the current model to a json object/map.
  Map<String, dynamic> toJson() => _$ClientTagFilterToJson(this);

  /// Assigns the new filter [value] to the [ClientTagFilters] identifier.
  void operator []=(String identifier, dynamic value) {
    switch (identifier) {
       case ClientTagFilters.groups:
        groups = value as List<String>;
        break;
       case ClientTagFilters.onlyNew:
        onlyNew = value as bool;
        break;
    }
    notifyListeners();
  }

  /// Returns the saved values of the [ClientTagFilters] identifier.
  dynamic operator [](String identifier) {
    switch (identifier) {
       case ClientTagFilters.groups:
        return groups;
      case ClientTagFilters.onlyNew:
        return onlyNew;
    }
  }

  /// Clears the filter value of the [identifier].
  void clear(String identifier) {
    switch (identifier) {
      case ClientTagFilters.groups:
        groups.clear();
        break;
      case ClientTagFilters.onlyNew:
        onlyNew = false;
        break;
    }
    notifyListeners();
  }

  /// Checks if the value of the [identifier] is not empty.
  bool isNotEmpty(String identifier) {
    switch (identifier) {
       case ClientTagFilters.groups:
        return groups.isNotEmpty;
      case ClientTagFilters.onlyNew:
        return onlyNew;
      default:
        return true;
    }
  }
}

/// Holds the tags identifiers on which clients can be fitlered.
abstract class ClientTagFilters {
  /// Languages tag identifier.
  static const String groups = "groups";
  /// Only new tag identifier,
  static const String onlyNew = "onlyNew";
}
