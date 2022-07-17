import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_select_list_dialog.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/view_models/records/record_tag_filter.dart';
import 'package:provider/provider.dart';

typedef FilterChangedFunction = Future<bool> Function(ID3TagFilter filter);

class RecordTagFilter extends StatelessWidget {
  final FilterChangedFunction onFilterChanged;

  const RecordTagFilter({
    required this.onFilterChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordTagFilterViewModel>(
      create: (context) => RecordTagFilterViewModel(),
      builder: (context, _) {
        var locales = AppLocalizations.of(context)!;

        return Row(
          children: [
            _createTagFilter(
              ID3TagFilters.date,
              locales.date,
              const Icon(Icons.calendar_month),
              Colors.blueGrey,
            ),
            horizontalSpacer,
            _createTagFilter(
              ID3TagFilters.artists,
              locales.artist,
              const Icon(Icons.person),
              Colors.teal,
            ),
            horizontalSpacer,
            _createTagFilter(
              ID3TagFilters.genres,
              locales.genre,
              const Icon(Icons.discount),
              Colors.red,
            ),
            horizontalSpacer,
            _createTagFilter(
              ID3TagFilters.albums,
              locales.album,
              const Icon(Icons.library_music),
              Colors.amber,
            ),
            horizontalSpacer,
          ],
        );
      },
    );
  }

  /// Creates a single tag filter for given [identifier].
  ///
  /// [icon] and the [activeBGColor] can be set.
  Widget _createTagFilter(
    String identifier,
    String label,
    Icon icon,
    Color activeBGColor,
  ) {
    return Consumer<RecordTagFilterViewModel>(
      builder: (context, vm, child) {
        return InputChip(
          label: Text(label),
          avatar: icon,
          backgroundColor:
              vm.tagFilter.isNotEmpty(identifier) ? activeBGColor : null,
          onPressed: () => identifier == ID3TagFilters.date
              ? _handleDateFilter(context, vm)
              : _handleFilter(identifier, context, vm),
          onDeleted: vm.tagFilter.isNotEmpty(identifier)
              ? () => {
                    vm.clear(identifier),
                    onFilterChanged(vm.tagFilter),
                  }
              : null,
        );
      },
    );
  }

  /// Creates a [showDateRangePicker] to handle the date filter.
  Future _handleDateFilter(
    BuildContext context,
    RecordTagFilterViewModel vm,
  ) async {
    var dateUpdated = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.input,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (dateUpdated == null) {
      return;
    }

    vm.updateFilter(ID3TagFilters.date, dateUpdated);
    onFilterChanged(vm.tagFilter);
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
          loadData: ({offset, take}) => vm.load(
            identifier,
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
    onFilterChanged(vm.tagFilter);
  }
}
