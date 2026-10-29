import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/components/async_select_list_dialog.dart';
import 'package:mml_admin/components/date_range_dialog.dart';
import 'package:mml_admin/components/horizontal_spacer.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/audit_action.dart';
import 'package:mml_admin/models/federation/audit_entry.dart';
import 'package:mml_admin/models/federation/audit_sort_field.dart';
import 'package:mml_admin/models/federation/audit_status.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/models/federation/transfer_progress.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/select_option.dart';
import 'package:mml_admin/view_models/sync/audit.dart';
import 'package:mml_admin/views/sync/section_chips.dart';
import 'package:provider/provider.dart';

/// Table of the federation audit log.
class AuditView extends StatelessWidget {
  /// Notifier which changes when new entries are available on the server.
  final ValueListenable<int> version;

  /// The chips to switch between the sections of the sync screen.
  final SyncSectionChips sectionChips;

  /// Initializes the view.
  const AuditView({
    super.key,
    required this.version,
    required this.sectionChips,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuditViewModel>(
      create: (context) => AuditViewModel(version)..init(),
      builder: (context, _) => Scaffold(
        body: Consumer<AuditViewModel>(
          builder: (context, vm, _) => Column(
            children: [
              _createHeader(context, vm),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: AuditTable(vm: vm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createHeader(BuildContext context, AuditViewModel vm) {
    var locales = AppLocalizations.of(context)!;
    var materialLocales = MaterialLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: vm.reload,
                icon: const Icon(Symbols.refresh),
                tooltip: locales.reload,
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: locales.filter,
                    icon: const Icon(Symbols.filter_list_alt),
                  ),
                  onChanged: (text) => vm.filter.message = text,
                ),
              ),
            ],
          ),
          verticalSpacer,
          Row(
            children: [
              sectionChips,
              horizontalSpacer,
              ValueListenableBuilder<bool>(
                valueListenable: vm.newEntries,
                builder: (context, available, _) => available
                    ? ActionChip(
                        side: BorderSide.none,
                        avatar: const Icon(Symbols.refresh),
                        label: Text(locales.auditNewEntries),
                        onPressed: vm.reload,
                      )
                    : const SizedBox.shrink(),
              ),
              const Spacer(),
              if (vm.filter.isActive)
                TextButton.icon(
                  icon: const Icon(Symbols.filter_alt_off),
                  label: Text(locales.auditFilterReset),
                  onPressed: vm.filter.reset,
                ),
              if (vm.selected.isNotEmpty) ...[
                horizontalSpacer,
                Text(materialLocales.selectedRowCountTitle(vm.selected.length)),
                horizontalSpacer,
                TextButton.icon(
                  icon: const Icon(Symbols.deselect),
                  label: Text(locales.auditSelectionClear),
                  onPressed: vm.clearSelection,
                ),
                TextButton.icon(
                  icon: const Icon(Symbols.delete),
                  label: Text(locales.auditDeleteSelected),
                  onPressed: () => vm.deleteSelected(context),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Paged table of the audit log with a fixed header and footer, sortable,
/// filterable and resizable columns and a selection of entries. Only the rows
/// scroll; the table scrolls horizontally if the columns are wider than the
/// available space.
class AuditTable extends StatefulWidget {
  /// The view model providing the entries.
  final AuditViewModel vm;

  /// Initializes the table.
  const AuditTable({super.key, required this.vm});

  @override
  State<AuditTable> createState() => _AuditTableState();
}

class _AuditTableState extends State<AuditTable> {
  static const double _rowHeight = 48;
  static const double _checkboxWidth = 48;
  static const double _minColumnWidth = 120;

  final ScrollController _horizontal = ScrollController();

  /// The widths of the columns changed by the admin, by column index.
  final Map<int, double> _widths = {};

  AuditViewModel get vm => widget.vm;

  @override
  void dispose() {
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;
    var colors = Theme.of(context).colorScheme;
    var columns = _columns(context, locales);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  var widths = _columnWidths(columns, constraints.maxWidth);
                  var tableWidth = widths.fold(_checkboxWidth, (a, b) => a + b);
                  return Scrollbar(
                    controller: _horizontal,
                    child: SingleChildScrollView(
                      controller: _horizontal,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: tableWidth,
                        child: _createTable(context, columns, widths),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1, color: colors.outlineVariant),
            _createFooter(context),
          ],
        ),
      ),
    );
  }

  /// Returns the widths of the [columns]. The last column fills the space left.
  List<double> _columnWidths(List<_AuditColumn> columns, double available) {
    var widths = [
      for (var i = 0; i < columns.length; i++) _widths[i] ?? columns[i].width,
    ];
    var used = widths.fold(_checkboxWidth, (a, b) => a + b) - widths.last;
    if (available - used > widths.last) {
      widths[widths.length - 1] = available - used;
    }
    return widths;
  }

  Widget _createTable(
    BuildContext context,
    List<_AuditColumn> columns,
    List<double> widths,
  ) {
    var locales = AppLocalizations.of(context)!;
    var colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 56,
          color: colors.surfaceContainerHigh,
          child: Row(
            children: [
              SizedBox(
                width: _checkboxWidth,
                child: Checkbox(
                  tristate: true,
                  value: vm.pageSelection,
                  onChanged: vm.rows.isEmpty
                      ? null
                      : (_) => vm.selectPage(vm.pageSelection != true),
                ),
              ),
              for (var i = 0; i < columns.length; i++)
                SizedBox(
                  width: widths[i],
                  child: Row(
                    children: [
                      Expanded(
                        child: _pad(_createHeaderCell(context, columns[i])),
                      ),
                      _createResizeHandle(context, i, widths[i]),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 2,
          child: vm.loading ? const LinearProgressIndicator() : null,
        ),
        Expanded(
          child: vm.rows.isEmpty
              ? Center(child: vm.loading ? null : Text(locales.noData))
              : ListView.builder(
                  itemCount: vm.rows.length,
                  itemExtent: _rowHeight,
                  itemBuilder: (context, index) =>
                      _createRow(context, columns, widths, vm.rows[index]),
                ),
        ),
      ],
    );
  }

  Widget _createResizeHandle(BuildContext context, int index, double width) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (details) => setState(() {
          var next = (_widths[index] ?? width) + details.delta.dx;
          _widths[index] = next < _minColumnWidth ? _minColumnWidth : next;
        }),
        onDoubleTap: () => setState(() => _widths.remove(index)),
        child: VerticalDivider(
          width: 9,
          indent: 12,
          endIndent: 12,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }

  static Widget _pad(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }

  List<_AuditColumn> _columns(BuildContext context, AppLocalizations locales) {
    var filter = vm.filter;
    return [
      _AuditColumn(
        label: locales.date,
        width: 190,
        sortField: AuditSortField.timestamp,
        filterActive: filter.dates != null,
        onFilter: () async {
          var dates = await showDateRangeDialog(context, initial: filter.dates);
          if (dates != null) {
            filter.dates = dates;
          }
        },
        onClearFilter: () => filter.dates = null,
        content: (entry) =>
            Text(DateFormat.yMd().add_Hms().format(entry.timestamp.toLocal())),
      ),
      _AuditColumn(
        label: locales.auditResult,
        width: 150,
        sortField: AuditSortField.status,
        filterActive: filter.statuses.isNotEmpty,
        onFilter: () async {
          var values = await _selectValues(context, filter.statuses, [
            for (var status in AuditStatus.values)
              SelectOption(status, AuditEntry.statusText(status, locales)),
          ]);
          if (values != null) {
            filter.statuses = values.cast<int>();
          }
        },
        onClearFilter: () => filter.statuses = [],
        content: (entry) {
          var icon = Tooltip(
            message: entry.statusName(locales),
            child: statusIcon(context, entry.status),
          );
          var fraction = transferFraction(entry.transferred, entry.size);
          if (fraction == null) {
            return icon;
          }

          return Row(
            children: [
              icon,
              horizontalSpacer,
              Expanded(child: LinearProgressIndicator(value: fraction)),
              horizontalSpacer,
              Text(locales.transferPercent((fraction * 100).floor())),
            ],
          );
        },
      ),
      _AuditColumn(
        label: locales.auditDirection,
        width: 150,
        sortField: AuditSortField.direction,
        filterActive: filter.directions.isNotEmpty,
        onFilter: () async {
          var values = await _selectValues(context, filter.directions, [
            for (var direction in [
              SyncDirection.incoming,
              SyncDirection.outgoing,
            ])
              SelectOption(
                direction,
                AuditEntry.directionText(direction, locales),
              ),
          ]);
          if (values != null) {
            filter.directions = values.cast<int>();
          }
        },
        onClearFilter: () => filter.directions = [],
        content: (entry) => Tooltip(
          message: entry.directionName(locales),
          child: directionIcon(context, entry.direction),
        ),
      ),
      _AuditColumn(
        label: locales.auditAction,
        width: 240,
        sortField: AuditSortField.action,
        filterActive: filter.actions.isNotEmpty,
        onFilter: () async {
          var values = await _selectValues(context, filter.actions, [
            for (var action in AuditAction.values)
              SelectOption(action, AuditEntry.actionText(action, locales)),
          ]);
          if (values != null) {
            filter.actions = values.cast<int>();
          }
        },
        onClearFilter: () => filter.actions = [],
        content: (entry) => _text(entry.actionName(locales)),
      ),
      _AuditColumn(
        label: locales.instance,
        width: 180,
        sortField: AuditSortField.instance,
        filterActive: filter.instances.isNotEmpty,
        onFilter: () async {
          var values = await _selectValues(context, filter.instances, [
            for (var instance in vm.instances) SelectOption(instance, instance),
          ]);
          if (values != null) {
            filter.instances = values.cast<String>();
          }
        },
        onClearFilter: () => filter.instances = [],
        content: (entry) => _text(entry.instance),
      ),
      _AuditColumn(
        label: locales.records,
        width: 120,
        numeric: true,
        content: (entry) =>
            Text(entry.recordIds.isEmpty ? '' : '${entry.recordIds.length}'),
      ),
      _AuditColumn(
        label: locales.auditMessage,
        width: 320,
        content: (entry) => Tooltip(
          message: entry.message ?? '',
          child: _text(entry.message ?? ''),
        ),
      ),
    ];
  }

  Widget _createHeaderCell(BuildContext context, _AuditColumn column) {
    var theme = Theme.of(context);
    var sort = column.sortField == null
        ? null
        : vm.filter.sortOf(column.sortField!);
    var label = Row(
      mainAxisAlignment: column.numeric
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            column.label,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
        ),
        if (sort != null) ...[
          Icon(
            sort.descending ? Symbols.arrow_downward : Symbols.arrow_upward,
            size: 16,
          ),
          if (vm.filter.sort.length > 1)
            Text('${sort.priority}', style: theme.textTheme.labelSmall),
        ],
      ],
    );

    return Row(
      children: [
        Flexible(
          child: column.sortField == null
              ? label
              : InkWell(
                  onTap: () => vm.filter.cycleSort(column.sortField!),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: label,
                  ),
                ),
        ),
        if (column.onFilter != null)
          _iconButton(
            icon: Icon(
              Symbols.filter_alt,
              fill: column.filterActive ? 1 : 0,
              color: column.filterActive ? theme.colorScheme.primary : null,
            ),
            tooltip: AppLocalizations.of(context)!.filter,
            onPressed: column.onFilter!,
          ),
        if (column.filterActive)
          _iconButton(
            icon: const Icon(Symbols.close),
            tooltip: AppLocalizations.of(context)!.auditFilterRemove,
            onPressed: column.onClearFilter!,
          ),
      ],
    );
  }

  Widget _createRow(
    BuildContext context,
    List<_AuditColumn> columns,
    List<double> widths,
    AuditEntry entry,
  ) {
    var colors = Theme.of(context).colorScheme;
    var selected = vm.isSelected(entry.entryId);

    return Material(
      color: selected ? colors.secondaryContainer : Colors.transparent,
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => AuditEntryDialog(entry: entry),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.outlineVariant)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: _checkboxWidth,
                child: Checkbox(
                  value: selected,
                  onChanged: (value) =>
                      vm.select(entry.entryId, value ?? false),
                ),
              ),
              for (var i = 0; i < columns.length; i++)
                SizedBox(
                  width: widths[i],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 17),
                    child: Align(
                      alignment: columns[i].numeric
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: columns[i].content(entry),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createFooter(BuildContext context) {
    var locales = MaterialLocalizations.of(context);
    var first = vm.firstRow;
    var last = first + vm.rowsPerPage;
    var total = vm.totalCount;
    var isLastPage = last >= total;

    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(locales.rowsPerPageTitle),
          horizontalSpacer,
          DropdownButton<int>(
            value: vm.rowsPerPage,
            underline: const SizedBox.shrink(),
            items: [
              for (var count in const [25, 50, 100])
                DropdownMenuItem(value: count, child: Text('$count')),
            ],
            onChanged: vm.changeRowsPerPage,
          ),
          const SizedBox(width: 32),
          Text(
            total == 0
                ? '0'
                : locales.pageRowsInfoTitle(
                    first + 1,
                    isLastPage ? total : last,
                    total,
                    false,
                  ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Symbols.first_page),
            tooltip: locales.firstPageTooltip,
            onPressed: first > 0 ? () => vm.goTo(0) : null,
          ),
          IconButton(
            icon: const Icon(Symbols.chevron_left),
            tooltip: locales.previousPageTooltip,
            onPressed: first > 0 ? () => vm.goTo(first - vm.rowsPerPage) : null,
          ),
          IconButton(
            icon: const Icon(Symbols.chevron_right),
            tooltip: locales.nextPageTooltip,
            onPressed: isLastPage ? null : () => vm.goTo(last),
          ),
          IconButton(
            icon: const Icon(Symbols.last_page),
            tooltip: locales.lastPageTooltip,
            onPressed: isLastPage ? null : () => vm.goTo(total - 1),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Future<List<dynamic>?> _selectValues(
    BuildContext context,
    Set<dynamic> selected,
    List<SelectOption> options,
  ) {
    return showDialog<List<dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AsyncSelectListDialog(
        loadData: ({filter, offset, take}) async {
          var text = filter?.toLowerCase() ?? '';
          var items = options
              .where((option) => option.label.toLowerCase().contains(text))
              .toList();
          return ModelList(items, 0, items.length);
        },
        initialSelected: selected.toList(),
      ),
    );
  }

  static Widget _text(String text) {
    return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  static Widget _iconButton({
    required Widget icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: icon,
      tooltip: tooltip,
      iconSize: 18,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 28, height: 28),
      onPressed: onPressed,
    );
  }
}

/// Returns the colored icon of the [status], see [AuditStatus].
Icon statusIcon(BuildContext context, int status) {
  switch (status) {
    case AuditStatus.success:
      return Icon(Symbols.check_circle, color: Colors.green.shade600);
    case AuditStatus.failed:
      return Icon(Symbols.error, color: Theme.of(context).colorScheme.error);
    case AuditStatus.pending:
      return Icon(
        Symbols.schedule,
        color: Theme.of(context).colorScheme.primary,
      );
    default:
      return Icon(
        Symbols.skip_next,
        color: Theme.of(context).colorScheme.outline,
      );
  }
}

/// Returns the colored icon of the [direction], see [SyncDirection].
Icon directionIcon(BuildContext context, int direction) {
  var colors = Theme.of(context).colorScheme;
  return Icon(
    SyncDirection.icon(direction),
    color: direction == SyncDirection.outgoing
        ? colors.primary
        : colors.secondary,
  );
}

class _AuditColumn {
  final String label;
  final double width;
  final bool numeric;
  final String? sortField;
  final bool filterActive;
  final VoidCallback? onFilter;
  final VoidCallback? onClearFilter;
  final Widget Function(AuditEntry entry) content;

  const _AuditColumn({
    required this.label,
    required this.content,
    required this.width,
    this.numeric = false,
    this.sortField,
    this.filterActive = false,
    this.onFilter,
    this.onClearFilter,
  });
}

/// Dialog showing all details of an audit log entry.
class AuditEntryDialog extends StatelessWidget {
  /// The shown entry.
  final AuditEntry entry;

  /// Initializes the dialog.
  const AuditEntryDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    var locales = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(entry.actionName(locales)),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: SelectionArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _row(
                  context,
                  locales.date,
                  DateFormat.yMd().add_Hms().format(entry.timestamp.toLocal()),
                ),
                _row(context, locales.auditResult, entry.statusName(locales)),
                _row(
                  context,
                  locales.auditDirection,
                  entry.directionName(locales),
                ),
                _row(context, locales.auditSource, entry.source),
                _row(context, locales.auditTarget, entry.target),
                if (entry.transactionId != null)
                  _row(context, locales.auditTransaction, entry.transactionId!),
                if (entry.message?.isNotEmpty ?? false)
                  _row(context, locales.auditMessage, entry.message!),
                if (entry.recordIds.isNotEmpty)
                  _row(
                    context,
                    locales.records,
                    entry.recordTitles(locales.auditRecordRemoved).join('\n'),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(locales.close),
        ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: Theme.of(context).textTheme.bodySmall),
      subtitle: Text(value),
    );
  }
}
