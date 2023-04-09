import 'package:flutter/material.dart';
import 'package:mml_admin/models/client_tag_filter.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/group.dart';

/// View model for the clients tag filter.
class ClientTagFilterViewModel extends ChangeNotifier {
  /// The active [ClientTagFilters].
  final ClientTagFilter tagFilter;

  /// Initializes the view model.
  ClientTagFilterViewModel(this.tagFilter);

  /// Clears the filter value of the [identifier].
  void clear(String identifier) async{
    tagFilter.clear(identifier);
    notifyListeners();
  }

  /// Updates the tag filter [identifier] with the [selectedValues].
  Future updateFilter(String identifier, dynamic selectedValues) async{
    tagFilter[identifier] = selectedValues;
    notifyListeners();
  }

  /// Loads data by [identifier] function.
  Future<ModelList> load(
    String identifier, {
    String? filter,
    int? offset,
    int? take,
  }) async {
    switch (identifier) {
      case ClientTagFilters.groups:
        return GroupService.getInstance().getGroups(filter, offset, take);
    }

    throw UnimplementedError();
  }
}
