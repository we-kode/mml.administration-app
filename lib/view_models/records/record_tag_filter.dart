import 'package:flutter/material.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/record.dart';

class RecordTagFilterViewModel extends ChangeNotifier {
  /// The active [ID3TagFilter].
  final tagFilter = ID3TagFilter();

  /// [RecordService] used to load data for the tag filter.
  final RecordService _service = RecordService.getInstance();

  /// Clears the filter value of the [identifier].
  void clear(String identifier) {
    tagFilter.clear(identifier);
    notifyListeners();
  }

  /// Updates the tag filter [identifier] with the [selectedValues].
  void updateFilter(String identifier, dynamic selectedValues) {
    tagFilter[identifier] = selectedValues;
    notifyListeners();
  }

  /// Loads data by [identifier] function.
  Future<ModelList> load(
    String identifier, {
    int? offset,
    int? take,
  }) async {
    switch (identifier) {
      case ID3TagFilters.artists:
        return _service.getArtists(offset, take);
      case ID3TagFilters.genres:
        return _service.getGenres(offset, take);
      case ID3TagFilters.albums:
        return _service.getAlbums(offset, take);
    }

    throw UnimplementedError();
  }
}
