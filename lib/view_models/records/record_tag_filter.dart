import 'package:flutter/material.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/record_sync_state.dart';
import 'package:mml_admin/models/federation/sync_state_option.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/secure_storage.dart';

/// View model for the records tag filter.
class RecordTagFilterViewModel extends ChangeNotifier {
  /// The active [ID3TagFilter].
  final ID3TagFilter tagFilter;

  /// [RecordService] used to load data for the tag filter.
  final RecordService _service = RecordService.getInstance();

  /// [SecureStorageService] used to load and save settings.
  final SecureStorageService _storage = SecureStorageService.getInstance();

  /// Initializes the view model.
  RecordTagFilterViewModel(this.tagFilter);

  /// Clears the filter value of the [identifier].
  void clear(String identifier) async {
    tagFilter.clear(identifier);
    if (identifier == ID3TagFilters.folderView) {
      await _storage.set(
        SecureStorageService.folderViewStorageKey,
        false.toString(),
      );
    }
    notifyListeners();
  }

  /// Updates the tag filter [identifier] with the [selectedValues].
  Future updateFilter(String identifier, dynamic selectedValues) async {
    tagFilter[identifier] = selectedValues;
    if (identifier == ID3TagFilters.folderView) {
      await _storage.set(
        SecureStorageService.folderViewStorageKey,
        (selectedValues as bool).toString(),
      );
    }
    notifyListeners();
  }

  /// Loads data by [identifier] function. The [locales] are used for the
  /// names of the synchronization states.
  Future<ModelList> load(
    String identifier,
    AppLocalizations locales, {
    String? filter,
    int? offset,
    int? take,
  }) async {
    switch (identifier) {
      case ID3TagFilters.artists:
        return _service.getArtists(filter, offset, take);
      case ID3TagFilters.genres:
        return _service.getGenres(filter, offset, take);
      case ID3TagFilters.albums:
        return _service.getAlbums(filter, offset, take);
      case ID3TagFilters.languages:
        return _service.getLanguages(filter, offset, take);
      case ID3TagFilters.groups:
        return GroupService.getInstance().getGroups(filter, offset, take);
      case ID3TagFilters.instances:
        return FederationService.getInstance().getInstances(filter);
      case ID3TagFilters.syncStates:
        var states = RecordSyncState.all
            .map((state) => SyncStateOption(state, locales))
            .toList();
        return ModelList(states, 0, states.length);
    }

    throw UnimplementedError();
  }
}
