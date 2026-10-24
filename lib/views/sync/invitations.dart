import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/invitation.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/sync/invitations.dart';
import 'package:mml_admin/views/sync/section_chips.dart';
import 'package:provider/provider.dart';

/// List of the open invitations for partners.
class InvitationsView extends StatelessWidget {
  /// The chips to switch between the sections of the sync screen.
  final SyncSectionChips sectionChips;

  /// Initializes the view.
  const InvitationsView({super.key, required this.sectionChips});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InvitationsViewModel>(
      create: (context) => InvitationsViewModel(),
      builder: (context, _) {
        var vm = Provider.of<InvitationsViewModel>(context, listen: false);

        return AsyncListView(
          subfilter: SyncSectionSubfilterView(chips: sectionChips),
          loadData: vm.load,
          deleteItems: <T>(List<T> items) => vm.delete(context, items),
          addItem: () async {
            return await showDialog<bool>(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => InvitationDialog(vm: vm),
                ) ??
                false;
          },
          editItem: (ModelBase item, Subfilter? subfilter) async => false,
        );
      },
    );
  }
}

/// Dialog creating a new invitation after the admin confirmed it and showing
/// its code. Returns true if an invitation was created.
class InvitationDialog extends StatefulWidget {
  /// The view model creating the invitation.
  final InvitationsViewModel vm;

  /// Initializes the dialog.
  const InvitationDialog({super.key, required this.vm});

  @override
  State<InvitationDialog> createState() => _InvitationDialogState();
}

class _InvitationDialogState extends State<InvitationDialog> {
  Invitation? _invitation;
  int _validityHours = invitationValidities.first;

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var invitation = _invitation;

    if (invitation == null) {
      return AlertDialog(
        title: Text(locales.invitationNew),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(locales.invitationNewInfo),
              verticalSpacer,
              DropdownMenu<int>(
                expandedInsets: EdgeInsets.zero,
                label: Text(locales.invitationValidity),
                initialSelection: _validityHours,
                dropdownMenuEntries: [
                  for (var hours in invitationValidities)
                    DropdownMenuEntry(
                      value: hours,
                      label: hours < 48
                          ? locales.durationHours(hours)
                          : locales.durationDays(hours ~/ 24),
                    ),
                ],
                onSelected: (hours) =>
                    setState(() => _validityHours = hours ?? _validityHours),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(locales.cancel),
          ),
          TextButton(onPressed: _create, child: Text(locales.create)),
        ],
      );
    }

    return AlertDialog(
      title: Text(locales.invitationCreated),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              locales.invitationInfo(
                DateFormat.yMd().add_Hm().format(
                  invitation.expiresAt.toLocal(),
                ),
              ),
            ),
            verticalSpacer,
            _copyableValue(
              context,
              locales.invitationAddress,
              invitation.baseUrl ?? '',
            ),
            _copyableValue(
              context,
              locales.invitationCode,
              invitation.code ?? '',
              monospace: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(locales.close),
        ),
      ],
    );
  }

  Future<void> _create() async {
    var invitation = await widget.vm.create(context, _validityHours);
    if (invitation != null && mounted) {
      setState(() => _invitation = invitation);
    }
  }

  Widget _copyableValue(
    BuildContext context,
    String label,
    String value, {
    bool monospace = false,
  }) {
    var theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: theme.textTheme.bodySmall),
      subtitle: SelectableText(
        value,
        style: monospace
            ? theme.textTheme.headlineSmall?.copyWith(fontFamily: 'monospace')
            : theme.textTheme.titleMedium,
      ),
      trailing: IconButton(
        icon: const Icon(Symbols.content_copy),
        tooltip: AppLocalizations.of(context)!.copy,
        onPressed: () => Clipboard.setData(ClipboardData(text: value)),
      ),
    );
  }
}
