import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/sync/rules.dart';
import 'package:mml_admin/views/sync/rule.dart';
import 'package:mml_admin/views/sync/section_chips.dart';
import 'package:provider/provider.dart';

/// List of the synchronization rules for all partners.
class RulesView extends StatelessWidget {
  /// The chips to switch between the sections of the sync screen.
  final SyncSectionChips sectionChips;

  /// Initializes the view.
  const RulesView({super.key, required this.sectionChips});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RulesViewModel>(
      create: (context) => RulesViewModel(),
      builder: (context, _) {
        var vm = Provider.of<RulesViewModel>(context, listen: false);

        return AsyncListView(
          subfilter: SyncSectionSubfilterView(chips: sectionChips),
          loadData: ({filter, offset, take, subfilter}) =>
              vm.load(context, filter: filter, offset: offset, take: take),
          deleteItems: <T>(List<T> items) => vm.delete(context, items),
          addItem: () =>
              _edit(context, Rule(direction: SyncDirection.outgoing)),
          editItem: (ModelBase item, Subfilter? subfilter) => _edit(
            context,
            Rule.fromJson((item as RuleListItem).rule.toJson()),
          ),
        );
      },
    );
  }

  Future<bool> _edit(BuildContext context, Rule rule) async {
    return await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (context) => RuleEditDialog(rule: rule),
        ) ??
        false;
  }
}
