import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/info_tooltip.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/view_models/sync/peer.dart';
import 'package:provider/provider.dart';

/// Dialog showing a partner with its registration state and the rules which
/// apply to it.
class PeerDialog extends StatelessWidget {
  /// The shown partner.
  final Peer peer;

  /// Initializes the dialog.
  const PeerDialog({super.key, required this.peer});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PeerViewModel>(
      create: (context) => PeerViewModel(peer),
      builder: (context, _) {
        var vm = Provider.of<PeerViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Row(
            children: [
              Flexible(child: Text(peer.instance)),
              if (_stateInfo(locales) != null)
                InfoTooltip(message: _stateInfo(locales)!),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: FutureBuilder(
              future: vm.init(context),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [CircularProgressIndicator()],
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._createInfo(context, locales),
                      verticalSpacer,
                      _createRules(
                        context,
                        vm.outgoingRules,
                        locales.outgoingRules,
                        '${locales.outgoingRulesInfo}\n\n${locales.peerRulesInfo}',
                      ),
                      verticalSpacer,
                      _createRules(
                        context,
                        vm.incomingRules,
                        locales.incomingRules,
                        '${locales.incomingRulesInfo}\n\n${locales.peerRulesInfo}',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: _createActions(context, vm, locales),
        );
      },
    );
  }

  List<Widget> _createInfo(BuildContext context, AppLocalizations locales) {
    var format = DateFormat.yMd().add_Hm();
    return [
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Symbols.link),
        title: Text(peer.baseUrl),
        subtitle: Text(peer.stateName(locales)),
      ),
      if (peer.jwksUpdatedAt != null)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Symbols.key),
          title: Text(
            locales.peerKeysUpdatedAt(
              format.format(peer.jwksUpdatedAt!.toLocal()),
            ),
          ),
        ),
    ];
  }

  String? _stateInfo(AppLocalizations locales) {
    return switch (peer.state) {
      PeerState.pendingApproval => locales.peerPendingApprovalInfo,
      PeerState.requested => locales.peerRequestedInfo,
      _ => null,
    };
  }

  Widget _createRules(
    BuildContext context,
    List<Rule> rules,
    String title,
    String info,
  ) {
    var locales = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            InfoTooltip(message: info),
          ],
        ),
        if (rules.isEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(locales.peerNoRules),
          ),
        ...rules.map(
          (rule) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(SyncDirection.icon(rule.direction)),
            title: Text(rule.describe(locales)),
            subtitle: Text(
              rule.direction == SyncDirection.incoming
                  ? '${rule.describePeers(locales)} → ${rule.groups.isEmpty ? locales.unassigned : rule.groups.map((g) => g.name).join(', ')}'
                  : rule.describePeers(locales),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _createActions(
    BuildContext context,
    PeerViewModel vm,
    AppLocalizations locales,
  ) {
    return [
      if (peer.isPendingApproval) ...[
        TextButton(onPressed: vm.reject, child: Text(locales.reject)),
        TextButton(onPressed: vm.approve, child: Text(locales.approve)),
      ] else
        TextButton(onPressed: vm.unlink, child: Text(locales.unlink)),
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(locales.close),
      ),
    ];
  }
}
