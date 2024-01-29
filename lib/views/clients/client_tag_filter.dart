import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_select_list_dialog.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/components/list_subfilter_view.dart';
import 'package:mml_admin/models/client_tag_filter.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/clients/client_tag_filter.dart';
import 'package:provider/provider.dart';

/// Tag filters for the clients view.
class ClientTagFilterView extends ListSubfilterView {
  final int clients;
  final ClientTagFilter tagFilter;

  /// Initializes the [ClientTagFilterView].
  const ClientTagFilterView({
    Key? key,
    required this.clients,
    required this.tagFilter,
  }) : super(key: key, filter: tagFilter);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClientTagFilterViewModel>(
      create: (context) => ClientTagFilterViewModel(filter as ClientTagFilter),
      builder: (context, _) {
        var locales = AppLocalizations.of(context)!;

        return Row(
          children: [
            _createTagFilter(
              '$clients',
              Icons.phone_android_rounded,
              context,
            ),
            horizontalSpacer,
            _createActiveTagFilter(
              ClientTagFilters.groups,
              locales.groups,
              Icons.vibration,
            ),
            horizontalSpacer,
            _createActiveTagFilter(
              ClientTagFilters.onlyNew,
              locales.onlyNew,
              Icons.qr_code_2,
            ),
            horizontalSpacer,
          ],
        );
      },
    );
  }

  /// Creates a single tag filter for given [identifier].
  ///
  /// [icon] can be set.
  Widget _createTagFilter(
    String label,
    IconData icon,
    BuildContext context,
  ) {
    return Chip(
      side: BorderSide.none,
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      label: Text(label),
      avatar: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  // Creates a single tag filter for given [identifier], which can be activated and deactivated.
  //
  // [icon] can be set.
  Widget _createActiveTagFilter(
    String identifier,
    String label,
    IconData icon,
  ) {
    return Consumer<ClientTagFilterViewModel>(
      builder: (context, vm, child) {
        final isActive = vm.tagFilter.isNotEmpty(identifier);
        final brightness = Theme.of(context).brightness;
        final isDarkMode = brightness == Brightness.dark;
        var activeColor = isDarkMode ? Colors.black54 : Colors.white;
        return InputChip(
          label: Text(label),
          labelStyle: isActive ? TextStyle(color: activeColor) : null,
          side: BorderSide.none,
          backgroundColor: isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.outlineVariant,
          avatar: Icon(
            icon,
            color: isActive
                ? activeColor
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          deleteIconColor: isActive ? activeColor : null,
          onPressed: () => _handleFilter(identifier, context, vm),
          onDeleted: vm.tagFilter.isNotEmpty(identifier)
              ? () => {
                    vm.clear(identifier),
                  }
              : null,
        );
      },
    );
  }

  /// Creates an [AsyncSelectListDialog] to handle list filters.
  Future _handleFilter(
    String identifier,
    BuildContext context,
    ClientTagFilterViewModel vm,
  ) async {
    if (identifier == ClientTagFilters.groups) {
      var selectedValues = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AsyncSelectListDialog(
            loadData: ({filter, offset, take}) => vm.load(
              identifier,
              filter: filter,
              offset: offset,
              take: take,
            ),
            initialSelected: vm.tagFilter[identifier],
          );
        },
      );
      if (selectedValues == null) {
        return;
      }

      vm.updateFilter(identifier, selectedValues);
    } else {
      var value = !vm.tagFilter.onlyNew;
      vm.updateFilter(identifier, value);
    }
  }
}
