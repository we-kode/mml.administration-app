import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/router.dart';

/// A rule shown in the list of rules.
class RuleListItem extends ModelBase {
  /// The shown rule.
  final Rule rule;

  /// Locales used to describe the rule.
  final AppLocalizations locales;

  /// Initializes the item.
  RuleListItem(this.rule, this.locales);

  @override
  String getDisplayDescription() {
    return rule.describe(locales);
  }

  @override
  dynamic getIdentifier() {
    return rule.ruleId;
  }

  @override
  String? getSubtitle(BuildContext context) {
    var peers = rule.describePeers(locales);
    if (rule.direction == SyncDirection.outgoing) {
      return peers;
    }

    var groups = rule.groups.isEmpty
        ? locales.unassigned
        : rule.groups.map((g) => g.name).join(', ');
    return '$peers → $groups';
  }

  @override
  String? getMetadata(BuildContext context) {
    return rule.direction == SyncDirection.outgoing
        ? locales.outgoingRule
        : locales.incomingRule;
  }

  @override
  Icon? getPrefixIcon(BuildContext context) {
    return Icon(SyncDirection.icon(rule.direction));
  }
}

/// View model of the list of synchronization rules.
class RulesViewModel extends ChangeNotifier {
  /// [FederationService] used to manage the rules.
  final FederationService _service = FederationService.getInstance();

  /// Loads the rules whose description contains the passed [filter].
  Future<ModelList> load(
    BuildContext context, {
    String? filter,
    int? offset,
    int? take,
    dynamic subfilter,
  }) async {
    var locales = AppLocalizations.of(context)!;
    var search = filter?.trim().toLowerCase() ?? '';
    var items = (await _service.getRules())
        .map((rule) => RuleListItem(rule, locales))
        .where(
          (item) =>
              search.isEmpty ||
              item.getDisplayDescription().toLowerCase().contains(search) ||
              item.rule.describePeers(locales).toLowerCase().contains(search),
        )
        .toList();
    return ModelList(items, 0, items.length);
  }

  /// Removes the given [items] after the admin confirmed it.
  Future<bool> delete<T>(BuildContext context, List<T> items) async {
    var shouldDelete = await showDeleteDialog(context);
    if (!shouldDelete) {
      return false;
    }

    showProgressIndicator();
    try {
      await _service.deleteRules(
        items.whereType<RuleListItem>().map((e) => e.rule.ruleId!).toList(),
      );
      return true;
    } catch (_) {
      // Do not reload list on error!
      return false;
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }
}
