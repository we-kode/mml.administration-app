import 'package:flutter/material.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/extensions/federation_error.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/record.dart';
import 'package:mml_admin/services/router.dart';

/// View model of the dialog to create or change a rule.
class RuleEditViewModel extends ChangeNotifier {
  /// [FederationService] used to save the rule.
  final FederationService _service = FederationService.getInstance();

  /// [RecordService] used to load the selectable artists, albums and genres.
  final RecordService _recordService = RecordService.getInstance();

  /// The edited rule.
  final Rule rule;

  /// Initializes the view model to edit the [rule].
  RuleEditViewModel(this.rule);

  /// Indicates whether the rule assigns groups to received records.
  bool get isIncoming => rule.direction == SyncDirection.incoming;

  /// Loads all groups of the media service.
  Future<ModelList> getGroups() {
    return GroupService.getInstance().getMediaGroups(null, 0, -1);
  }

  /// Loads the partners with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> loadPeers({String? filter, int? offset, int? take}) {
    return _service.getPeers(filter, offset, take);
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

  /// Loads the genres with the passed [filter] starting at [offset] and
  /// loading [take] data.
  Future<ModelList> loadGenres({String? filter, int? offset, int? take}) {
    return _recordService.getGenres(filter, offset, take);
  }

  /// Indicates whether the rule is new, so its direction can be chosen.
  bool get isNew => rule.ruleId == null;

  /// Changes the [direction] of the rule, see [SyncDirection].
  void directionChanged(int direction) {
    rule.direction = direction;
    notifyListeners();
  }

  /// Changes the groups received records are assigned to.
  void groupsChanged(List<Group> groups) {
    rule.groups = groups;
  }

  /// Saves the rule and closes the dialog.
  Future<void> save(BuildContext context) async {
    var nav = Navigator.of(context);
    var locales = AppLocalizations.of(context)!;
    showProgressIndicator();
    try {
      await _service.saveRule(rule);
      RouterService.getInstance().navigatorKey.currentState!.pop();
      nav.pop(true);
    } on FederationException catch (e) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      MessengerService.getInstance().showMessage(e.message(locales));
    } catch (_) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }
}
