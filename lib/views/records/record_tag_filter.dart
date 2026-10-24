import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/async_select_list_dialog.dart';
import 'package:mml_admin/components/date_range_dialog.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/components/list_subfilter_view.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/view_models/records/record_tag_filter.dart';
import 'package:provider/provider.dart';

/// Tag filters for the records view.
class RecordTagFilter extends ListSubfilterView {
  /// Initializes the [RecordTagFilter].
  RecordTagFilter({
    super.key,
    DateTime? startDate,
    DateTime? endDate,
    bool isFolderView = false,
  }) : super(
         filter: ID3TagFilter(
           startDate: startDate,
           endDate: endDate,
           isFolderView: isFolderView,
         ),
       );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordTagFilterViewModel>(
      create: (context) => RecordTagFilterViewModel(filter as ID3TagFilter),
      builder: (context, _) {
        var locales = AppLocalizations.of(context)!;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Row(
              children: [
                _createTagFilter(
                  ID3TagFilters.folderView,
                  locales.folder,
                  Symbols.folder,
                ),
                Consumer<RecordTagFilterViewModel>(
                  builder: (context, vm, child) {
                    var isFolderView = (filter as ID3TagFilter).isGrouped;
                    return !isFolderView ? horizontalSpacer : Container();
                  },
                ),
                _createTagFilter(
                  ID3TagFilters.date,
                  locales.date,
                  Symbols.calendar_month,
                ),
                horizontalSpacer,
                _createTagFilter(
                  ID3TagFilters.artists,
                  locales.artist,
                  Symbols.person,
                ),
                horizontalSpacer,
                _createTagFilter(
                  ID3TagFilters.genres,
                  locales.genre,
                  Symbols.genres,
                ),
                horizontalSpacer,
                _createTagFilter(
                  ID3TagFilters.albums,
                  locales.album,
                  Symbols.library_music,
                ),
                horizontalSpacer,
                _createTagFilter(
                  ID3TagFilters.languages,
                  locales.language,
                  Symbols.translate,
                ),
                horizontalSpacer,
                _createTagFilter(
                  ID3TagFilters.groups,
                  locales.groups,
                  Symbols.vibration,
                ),
                horizontalSpacer,
                _createTagFilter(
                  ID3TagFilters.unassigned,
                  locales.unassigned,
                  Symbols.label_off,
                ),
                horizontalSpacer,
                _createTagFilter(
                  ID3TagFilters.instances,
                  locales.recordsOfInstance,
                  Symbols.hub,
                ),
                horizontalSpacer,
                _createTagFilter(
                  ID3TagFilters.syncStates,
                  locales.syncState,
                  Symbols.sync,
                ),
                horizontalSpacer,
              ],
            ),
          ),
        );
      },
    );
  }

  /// Creates a single tag filter for given [identifier].
  ///
  /// [icon] can be set.
  Widget _createTagFilter(String identifier, String label, IconData icon) {
    return Consumer<RecordTagFilterViewModel>(
      builder: (context, vm, child) {
        var isFolderView =
            identifier == ID3TagFilters.date &&
            (filter as ID3TagFilter).isGrouped;
        final isActive = vm.tagFilter.isNotEmpty(identifier);
        final brightness = Theme.of(context).brightness;
        final isDarkMode = brightness == Brightness.dark;
        var activeColor = isDarkMode ? Colors.black54 : Colors.white;
        return isFolderView
            ? Container()
            : InputChip(
                side: BorderSide.none,
                label: Text(label),
                labelStyle: isActive ? TextStyle(color: activeColor) : null,
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
                onPressed: () => identifier == ID3TagFilters.date
                    ? _handleDateFilter(context, vm)
                    : identifier == ID3TagFilters.folderView
                    ? _handleFolderFilter(context, vm)
                    : identifier == ID3TagFilters.unassigned
                    ? vm.updateFilter(identifier, !vm.tagFilter.unassigned)
                    : _handleFilter(identifier, context, vm),
                onDeleted: vm.tagFilter.isNotEmpty(identifier)
                    ? () => {vm.clear(identifier)}
                    : null,
              );
      },
    );
  }

  /// Updates the folder view tag.
  Future _handleFolderFilter(
    BuildContext context,
    RecordTagFilterViewModel vm,
  ) async {
    var isFolderView = !(filter as ID3TagFilter).isGrouped;
    await vm.updateFilter(ID3TagFilters.folderView, isFolderView);
  }

  /// Shows a date range dialog to handle the date filter.
  Future _handleDateFilter(
    BuildContext context,
    RecordTagFilterViewModel vm,
  ) async {
    var tagFilter = vm.tagFilter;
    var dates = await showDateRangeDialog(
      context,
      initial: tagFilter.startDate != null && tagFilter.endDate != null
          ? DateTimeRange(start: tagFilter.startDate!, end: tagFilter.endDate!)
          : null,
    );
    if (dates == null) {
      return;
    }

    vm.updateFilter(ID3TagFilters.date, dates);
  }

  /// Creates an [AsyncSelectListDialog] to handle list filters.
  Future _handleFilter(
    String identifier,
    BuildContext context,
    RecordTagFilterViewModel vm,
  ) async {
    var selectedValues = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AsyncSelectListDialog(
          loadData: ({filter, offset, take}) => vm.load(
            identifier,
            AppLocalizations.of(context)!,
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
  }
}
