import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/sync/overview.dart';
import 'package:mml_admin/views/sync/audit.dart';
import 'package:mml_admin/views/sync/invitations.dart';
import 'package:mml_admin/views/sync/peer.dart';
import 'package:mml_admin/views/sync/register.dart';
import 'package:mml_admin/views/sync/rules.dart';
import 'package:mml_admin/views/sync/section_chips.dart';
import 'package:provider/provider.dart';

/// Screen to manage partner instances, invitations and the audit log of the
/// synchronization.
class SyncOverviewScreen extends StatelessWidget {
  /// Initializes the instance.
  const SyncOverviewScreen({super.key});

  /// Builds the sync screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SyncOverviewViewModel>(
      create: (context) => SyncOverviewViewModel(),
      builder: (context, _) {
        var vm = Provider.of<SyncOverviewViewModel>(context, listen: false);
        return ValueListenableBuilder<SyncSection>(
          valueListenable: vm.section,
          builder: (context, section, _) {
            var chips = SyncSectionChips(section: vm.section);
            switch (section) {
              case SyncSection.invitations:
                return InvitationsView(
                  key: const ValueKey(SyncSection.invitations),
                  sectionChips: chips,
                );
              case SyncSection.peers:
                return ValueListenableBuilder<int>(
                  valueListenable: vm.peersVersion,
                  builder: (context, version, _) =>
                      _createPeers(context, vm, version, chips),
                );
              case SyncSection.rules:
                return RulesView(
                  key: const ValueKey(SyncSection.rules),
                  sectionChips: chips,
                );
              case SyncSection.audit:
                return AuditView(
                  key: const ValueKey(SyncSection.audit),
                  version: vm.auditVersion,
                  sectionChips: chips,
                );
            }
          },
        );
      },
    );
  }

  Widget _createPeers(
    BuildContext context,
    SyncOverviewViewModel vm,
    int version,
    SyncSectionChips chips,
  ) {
    return AsyncListView(
      key: ValueKey(version),
      subfilter: SyncSectionSubfilterView(chips: chips),
      deleteItems: <T>(List<T> items) => vm.unlink(context, items),
      addItem: () async {
        return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => const PeerRegisterDialog(),
            ) ??
            false;
      },
      editItem: (ModelBase peer, Subfilter? subfilter) async {
        return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => PeerDialog(peer: peer as Peer),
            ) ??
            false;
      },
      loadData: vm.load,
    );
  }
}
