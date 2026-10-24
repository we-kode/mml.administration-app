import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/components/list_subfilter_view.dart';
import 'package:mml_admin/components/select_chip.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/subfilter.dart';
import 'package:mml_admin/view_models/sync/overview.dart';

/// Chips to switch between the sections of the sync screen. Exactly one
/// section is selected.
class SyncSectionChips extends StatelessWidget {
  /// The selected section.
  final ValueNotifier<SyncSection> section;

  /// Initializes the chips.
  const SyncSectionChips({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chip(SyncSection.invitations, locales.invitations, Symbols.key),
        horizontalSpacer,
        _chip(SyncSection.peers, locales.peers, Symbols.hub),
        horizontalSpacer,
        _chip(SyncSection.rules, locales.rules, Symbols.rule),
        horizontalSpacer,
        _chip(SyncSection.audit, locales.audit, Symbols.history),
      ],
    );
  }

  Widget _chip(SyncSection value, String label, IconData icon) {
    return SelectChip(
      label: label,
      icon: icon,
      selected: section.value == value,
      onPressed: () => section.value = value,
    );
  }
}

/// Subfilter of a list of the sync screen, which only shows the section
/// chips.
class SyncSectionSubfilterView extends ListSubfilterView {
  /// The chips to switch between the sections.
  final SyncSectionChips chips;

  /// Initializes the view with the section [chips].
  SyncSectionSubfilterView({super.key, required this.chips})
    : super(filter: _SectionFilter());

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.centerLeft, child: chips);
  }
}

class _SectionFilter extends Subfilter {}
