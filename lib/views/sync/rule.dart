import 'package:flutter/material.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/components/tag_selection.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/album.dart';
import 'package:mml_admin/models/artist.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/models/genre.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/sync/rule.dart';
import 'package:provider/provider.dart';

/// Dialog to create or change a rule.
class RuleEditDialog extends StatelessWidget {
  /// The edited rule.
  final Rule rule;

  /// Initializes the dialog.
  const RuleEditDialog({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RuleEditViewModel>(
      create: (context) => RuleEditViewModel(rule),
      builder: (context, _) {
        var vm = Provider.of<RuleEditViewModel>(context);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(
            vm.isIncoming ? locales.incomingRule : locales.outgoingRule,
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (vm.isNew) ...[
                    SegmentedButton<int>(
                      segments: [
                        ButtonSegment(
                          value: SyncDirection.outgoing,
                          icon: Icon(
                            SyncDirection.icon(SyncDirection.outgoing),
                          ),
                          label: Text(locales.outgoingRule),
                        ),
                        ButtonSegment(
                          value: SyncDirection.incoming,
                          icon: Icon(
                            SyncDirection.icon(SyncDirection.incoming),
                          ),
                          label: Text(locales.incomingRule),
                        ),
                      ],
                      selected: {vm.rule.direction},
                      onSelectionChanged: (selected) =>
                          vm.directionChanged(selected.first),
                    ),
                    verticalSpacer,
                  ],
                  Text(
                    vm.isIncoming
                        ? locales.incomingRulesInfo
                        : locales.outgoingRulesInfo,
                  ),
                  verticalSpacer,
                  Text(locales.ruleInfo),
                  verticalSpacer,
                  TagSelection<Peer>(
                    label: locales.peers,
                    values: vm.rule.peers,
                    loadData: vm.loadPeers,
                    helperText: locales.ruleEmptyAllInstances,
                  ),
                  verticalSpacer,
                  TagSelection<Album>(
                    label: locales.album,
                    values: vm.rule.albums,
                    loadData: vm.loadAlbums,
                    helperText: locales.ruleEmptyMatchesAll,
                  ),
                  verticalSpacer,
                  TagSelection<Artist>(
                    label: locales.artist,
                    values: vm.rule.artists,
                    loadData: vm.loadArtists,
                    helperText: locales.ruleEmptyMatchesAll,
                  ),
                  verticalSpacer,
                  TagSelection<Genre>(
                    label: locales.genre,
                    values: vm.rule.genres,
                    loadData: vm.loadGenres,
                    helperText: locales.ruleEmptyMatchesAll,
                  ),
                  verticalSpacer,
                  Text(
                    vm.isIncoming
                        ? locales.ruleGroups
                        : locales.ruleSourceGroups,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  verticalSpacer,
                  ChipChoices(
                    key: ValueKey(vm.rule.direction),
                    loadData: vm.getGroups,
                    initialSelectedItems: vm.rule.groups,
                    onSelectionChanged: (items) =>
                        vm.groupsChanged(items.map((e) => e as Group).toList()),
                  ),
                  if (!vm.isIncoming)
                    Text(
                      locales.ruleEmptyMatchesAll,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(locales.cancel),
            ),
            TextButton(
              onPressed: () => vm.save(context),
              child: Text(locales.save),
            ),
          ],
        );
      },
    );
  }
}
