import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/delete_dialog.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/audit_entry.dart';
import 'package:mml_admin/models/federation/audit_filter.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/router.dart';

/// View model of the federation audit log table. The entries are loaded page
/// by page; the selection is kept while paging, filtering and sorting.
class AuditViewModel extends ChangeNotifier {
  /// [FederationService] used to manage the audit log.
  final FederationService _service;

  /// The column filters and the sort order of the audit log.
  final AuditFilter filter = AuditFilter();

  /// Indicates whether new entries are available on the server, which are
  /// not loaded yet.
  final ValueNotifier<bool> newEntries = ValueNotifier(false);

  /// Notifier which changes when new entries are available on the server.
  final ValueListenable<int> _version;

  List<AuditEntry> _rows = [];
  final Set<String> _selected = {};
  List<String> _instances = [];
  int _rowsPerPage = 25;
  int _firstRow = 0;
  int _totalCount = 0;
  bool _loading = false;
  int _generation = 0;
  bool _disposed = false;

  /// Initializes the view model, which marks [newEntries] when the [version]
  /// changes. A custom [service] can be passed for tests.
  AuditViewModel(this._version, {FederationService? service})
    : _service = service ?? FederationService.getInstance() {
    _version.addListener(_markNewEntries);
    filter.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _disposed = true;
    _version.removeListener(_markNewEntries);
    filter.removeListener(_onFilterChanged);
    filter.dispose();
    newEntries.dispose();
    super.dispose();
  }

  /// The entries of the shown page.
  List<AuditEntry> get rows => _rows;

  /// The count of all entries matching the filter.
  int get totalCount => _totalCount;

  /// The count of rows shown on one page.
  int get rowsPerPage => _rowsPerPage;

  /// The index of the first entry of the shown page.
  int get firstRow => _firstRow;

  /// Whether a page is loading.
  bool get loading => _loading;

  /// The ids of the selected entries.
  Set<String> get selected => Set.unmodifiable(_selected);

  /// The names of the partner instances occurring in the audit log.
  List<String> get instances => _instances;

  /// Whether all entries of the shown page are selected: true if all, null if
  /// some and false if none.
  bool? get pageSelection {
    var count = _rows.where((e) => _selected.contains(e.entryId)).length;
    return count == 0
        ? false
        : count == _rows.length
        ? true
        : null;
  }

  /// Loads the first page and the instances of the audit log.
  Future<void> init() async {
    await Future.wait([_load(), _loadInstances()]);
  }

  /// Shows the page starting at the entry with the [firstRow] index.
  void goTo(int firstRow) {
    _firstRow = firstRow < 0 ? 0 : firstRow - firstRow % _rowsPerPage;
    _load();
  }

  /// Changes the count of rows shown on one page and returns to the first
  /// page.
  void changeRowsPerPage(int? rowsPerPage) {
    if (rowsPerPage == null || rowsPerPage == _rowsPerPage) {
      return;
    }
    _rowsPerPage = rowsPerPage;
    _firstRow = 0;
    _load();
  }

  /// Reloads the shown page and the instances of the audit log.
  void reload() {
    newEntries.value = false;
    _load();
    _loadInstances();
  }

  /// Whether the entry with the [entryId] is selected.
  bool isSelected(String entryId) => _selected.contains(entryId);

  /// Selects or deselects the entry with the [entryId].
  void select(String entryId, bool selected) {
    selected ? _selected.add(entryId) : _selected.remove(entryId);
    notifyListeners();
  }

  /// Selects or deselects all entries of the shown page.
  void selectPage(bool selected) {
    var ids = _rows.map((e) => e.entryId);
    selected ? _selected.addAll(ids) : _selected.removeAll(ids);
    notifyListeners();
  }

  /// Deselects all entries.
  void clearSelection() {
    _selected.clear();
    notifyListeners();
  }

  /// Removes the selected entries after the admin confirmed it.
  Future<void> deleteSelected(BuildContext context) async {
    var locales = AppLocalizations.of(context)!;
    var confirmed = await showDeleteDialog(
      context,
      message: locales.auditDeleteCount(_selected.length),
    );
    if (!confirmed) {
      return;
    }

    if (await _run(() => _service.deleteAudit(_selected.toList()))) {
      _selected.clear();
      reload();
    }
  }

  void _markNewEntries() {
    newEntries.value = true;
  }

  void _onFilterChanged() {
    _firstRow = 0;
    reload();
  }

  Future<void> _load() async {
    var generation = ++_generation;
    _loading = true;
    notifyListeners();
    try {
      var page = await _service.getAudit(filter, _firstRow, _rowsPerPage);
      if (_disposed || generation != _generation) {
        return;
      }
      if (page.items.isEmpty && _firstRow > 0) {
        var count = page.totalCount;
        _firstRow = count == 0 ? 0 : (count - 1) - (count - 1) % _rowsPerPage;
        await _load();
        return;
      }
      _rows = page.items;
      _totalCount = page.totalCount;
    } catch (_) {
      // Errors are shown by the api service.
    } finally {
      if (!_disposed && generation == _generation) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> _loadInstances() async {
    try {
      var instances = await _service.getAuditInstances();
      if (!_disposed) {
        _instances = instances;
        notifyListeners();
      }
    } catch (_) {
      // Errors are shown by the api service.
    }
  }

  Future<bool> _run(Future<void> Function() action) async {
    showProgressIndicator();
    try {
      await action();
      return true;
    } catch (_) {
      // Do not reload list on error!
      return false;
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();
    }
  }
}
