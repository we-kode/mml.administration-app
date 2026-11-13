import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/share_rule.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/share.dart';

/// View model of the dialog to create or edit a share rule.
class ShareRuleEditViewModel extends ChangeNotifier {
  /// [ShareService] used to load and save the rule.
  final ShareService _service = ShareService.getInstance();

  /// [RecordService] used to load the selectable albums, artists and genres.
  final RecordService _recordService = RecordService.getInstance();

  /// Id of the rule to edit or null to create a new one.
  final String? id;

  /// The rule to be created or edited.
  late ShareRule rule;

  /// Loads the rule once, so rebuilds of the dialog keep the changes.
  late final Future<bool> loaded = _load();

  /// Initializes the view model for the rule with the [id].
  ShareRuleEditViewModel(this.id);

  Future<bool> _load() async {
    final id = this.id;
    try {
      rule = id == null ? ShareRule() : await _service.getRule(id);
    } catch (_) {
      return false;
    }

    return true;
  }

  /// Loads the groups with the passed [filter] starting at [offset] and loading
  /// [take] data.
  Future<ModelList> loadGroups({String? filter, int? offset, int? take}) {
    return GroupService.getInstance().getMediaGroups(filter, offset, take);
  }

  /// Loads the genres with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> loadGenres({String? filter, int? offset, int? take}) {
    return _recordService.getGenres(filter, offset, take);
  }

  /// Loads the albums with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> loadAlbums({String? filter, int? offset, int? take}) {
    return _recordService.getAlbums(filter, offset, take);
  }

  /// Loads the artists with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> loadArtists({String? filter, int? offset, int? take}) {
    return _recordService.getArtists(filter, offset, take);
  }

  /// Sets whether the rule matches all records.
  void setAllRecords(bool value) {
    rule.allRecords = value;
    notifyListeners();
  }

  /// Saves the rule and closes the dialog, if it has a group and a criterion.
  Future<void> save(BuildContext context) async {
    var locales = AppLocalizations.of(context)!;
    var nav = Navigator.of(context);

    if (rule.groups.isEmpty || !rule.hasCriteria) {
      MessengerService.getInstance().showMessage(
        rule.groups.isEmpty ? locales.shareRuleNoGroup : locales.shareRuleEmpty,
      );
      return;
    }

    if (rule.allRecords) {
      rule.genres.clear();
      rule.albums.clear();
      rule.artists.clear();
    }

    showProgressIndicator();
    var saved = false;
    try {
      await _service.saveRule(rule);
      saved = true;
    } catch (_) {
      // Errors are shown by the api service.
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();

      if (saved) {
        nav.pop(true);
      }
    }
  }
}
