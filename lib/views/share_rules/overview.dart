import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/share_rule.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/share_rules/overview.dart';
import 'package:mml_admin/views/share_rules/edit.dart';
import 'package:provider/provider.dart';

/// Overview screen of the rules, which allow the clients of groups to share
/// records.
class ShareRulesScreen extends StatelessWidget {
  /// Initializes the instance.
  const ShareRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShareRulesViewModel>(
      create: (context) => ShareRulesViewModel(),
      builder: (context, _) {
        var vm = Provider.of<ShareRulesViewModel>(context, listen: false);

        return FutureBuilder(
          future: vm.loaded,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!vm.isSupported) {
              return Center(
                child: Text(AppLocalizations.of(context)!.shareNotSupported),
              );
            }

            return AsyncListView(
              deleteItems: <T>(List<T> items) => vm.delete(context, items),
              addItem: () async =>
                  await showDialog<bool>(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const ShareRuleEditDialog(id: null),
                  ) ??
                  false,
              editItem: (ModelBase item, Subfilter? subfilter) async =>
                  await showDialog<bool>(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) =>
                        ShareRuleEditDialog(id: (item as ShareRule).id),
                  ) ??
                  false,
              loadData: vm.load,
              availableTags: vm.groups,
              onChangedAvailableTags: vm.groupsChanged,
              enableFastActionSwitch: true,
            );
          },
        );
      },
    );
  }
}
