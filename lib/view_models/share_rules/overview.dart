import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/share_rule.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/router.dart';
import 'package:mml_admin/services/share.dart';

/// View model of the overview of the rules, which allow clients to share
/// records.
class ShareRulesViewModel extends ChangeNotifier {
  /// Route of the share rules overview screen.
  static String route = '/shareRules';

  /// [ShareService] used to load and save the rules.
  final ShareService _service = ShareService.getInstance();

  /// Whether the server supports share rules.
  bool isSupported = true;

  /// Available groups, which can be assigned in the list.
  ModelList groups = ModelList([], 0, 0);

  /// Loads the groups once, which can be assigned to the rules.
  late final Future<bool> loaded = _load();

  Future<bool> _load() async {
    isSupported = await _service.isSupported();
    if (!isSupported) {
      return true;
    }

    try {
      groups = await GroupService.getInstance().getMediaGroups(null, 0, -1);
    } catch (_) {
      // Errors are shown by the api service.
    }

    return true;
  }

  /// Loads a chunk of rules.
  Future<ModelList> load({
    String? filter,
    int? offset,
    int? take,
    Subfilter? subfilter,
  }) {
    return _service.getRules(filter, offset, take);
  }

  /// Updates the groups of the rule [item].
  Future<void> groupsChanged(ModelBase item, List<ModelBase> changed) async {
    (item as ShareRule).groups = changed.map((e) => e as Group).toList();
    await _service.saveRule(item);
  }

  /// Deletes [items] after the user confirmed it.
  Future<bool> delete<T>(BuildContext context, List<T> items) async {
    var shouldDelete = await showDeleteDialog(context);

    if (shouldDelete && items.isNotEmpty) {
      try {
        showProgressIndicator();
        await _service.deleteRules(
          items.map((e) => (e as ShareRule).id!).toList(),
        );
      } catch (e) {
        // Do not reload list on error!
        return false;
      } finally {
        RouterService.getInstance().navigatorKey.currentState!.pop();
      }
    }

    return shouldDelete;
  }
}
