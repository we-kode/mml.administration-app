import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/models/federation/audit_action.dart';
import 'package:mml_admin/models/federation/audit_entries.dart';
import 'package:mml_admin/models/federation/audit_entry.dart';
import 'package:mml_admin/models/federation/audit_filter.dart';
import 'package:mml_admin/models/federation/audit_sort_field.dart';
import 'package:mml_admin/models/federation/audit_status.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/models/federation/transfer_progress.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/federation_events.dart';
import 'package:mml_admin/view_models/sync/audit.dart';

/// Serves [count] audit entries and records the requested pages.
class FakeAuditService implements FederationService {
  int count;
  final List<int> offsets = [];
  final List<Map<String, dynamic>> queries = [];

  FakeAuditService(this.count);

  static AuditEntry entry(int index) => AuditEntry(
    entryId: 'e$index',
    timestamp: DateTime.utc(2026, 10, 22),
    action: AuditAction.recordPushed,
    status: AuditStatus.success,
    source: 'local',
    target: 'alpha',
    direction: SyncDirection.outgoing,
    instance: 'alpha',
  );

  @override
  Future<AuditEntries> getAudit(
    AuditFilter filter,
    int offset,
    int take,
  ) async {
    offsets.add(offset);
    queries.add(filter.toQuery());
    var end = offset + take > count ? count : offset + take;
    return AuditEntries([for (var i = offset; i < end; i++) entry(i)], count);
  }

  @override
  Future<List<String>> getAuditInstances() async => ['alpha'];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'announces new entries without reloading and resets on reload',
    () async {
      final version = ValueNotifier(0);
      final service = FakeAuditService(3);
      final vm = AuditViewModel(version, service: service);
      await vm.init();

      version.value++;
      expect(vm.newEntries.value, isTrue);
      expect(service.offsets, [0]);

      vm.reload();
      expect(vm.newEntries.value, isFalse);
    },
  );

  test('pages through the entries', () async {
    final service = FakeAuditService(60);
    final vm = AuditViewModel(ValueNotifier(0), service: service);
    await vm.init();

    expect(vm.totalCount, 60);
    expect(vm.rows, hasLength(25));

    vm.goTo(59);
    await pumpEventQueue();
    expect(vm.firstRow, 50);
    expect(vm.rows.map((e) => e.entryId), contains('e59'));

    vm.changeRowsPerPage(50);
    await pumpEventQueue();
    expect(vm.firstRow, 0);
    expect(vm.rows, hasLength(50));
  });

  test('returns to the last page when the shown page became empty', () async {
    final service = FakeAuditService(60);
    final vm = AuditViewModel(ValueNotifier(0), service: service);
    await vm.init();
    vm.goTo(50);
    await pumpEventQueue();

    service.count = 30;
    vm.reload();
    await pumpEventQueue();

    expect(vm.firstRow, 25);
    expect(vm.rows, hasLength(5));
  });

  test('keeps the selection while paging and filtering', () async {
    final service = FakeAuditService(60);
    final vm = AuditViewModel(ValueNotifier(0), service: service);
    await vm.init();

    vm.selectPage(true);
    expect(vm.selected, hasLength(25));
    expect(vm.pageSelection, isTrue);

    vm.goTo(25);
    await pumpEventQueue();
    expect(vm.pageSelection, isFalse);
    vm.select('e30', true);
    expect(vm.pageSelection, isNull);

    vm.filter.statuses = [AuditStatus.failed];
    await pumpEventQueue();

    expect(vm.selected, hasLength(26));
    expect(vm.firstRow, 0);
    expect(service.offsets.last, 0);

    vm.clearSelection();
    expect(vm.selected, isEmpty);
  });

  test('cycles the sort order of several columns', () {
    final filter = AuditFilter();

    filter.cycleSort(AuditSortField.status);
    filter.cycleSort(AuditSortField.timestamp);
    filter.cycleSort(AuditSortField.timestamp);
    expect(filter.toQuery()['sort'], ['status', '-timestamp']);
    expect(filter.sortOf(AuditSortField.timestamp), (
      priority: 2,
      descending: true,
    ));

    filter.cycleSort(AuditSortField.status);
    filter.cycleSort(AuditSortField.status);
    expect(filter.toQuery()['sort'], ['-timestamp']);
    expect(filter.sortOf(AuditSortField.status), isNull);

    filter.cycleSort(AuditSortField.timestamp);
    expect(filter.toQuery().containsKey('sort'), isFalse);
  });

  test('builds the query of the column filters', () {
    final filter = AuditFilter()
      ..statuses = [AuditStatus.failed]
      ..actions = [AuditAction.recordPushed]
      ..instances = ['alpha']
      ..directions = [SyncDirection.incoming]
      ..message = '  refused '
      ..dates = DateTimeRange(
        start: DateTime(2026, 10, 1),
        end: DateTime(2026, 10, 2),
      );

    final query = filter.toQuery();
    expect(query['status'], [AuditStatus.failed]);
    expect(query['action'], [AuditAction.recordPushed]);
    expect(query['instance'], ['alpha']);
    expect(query['direction'], SyncDirection.incoming);
    expect(query['message'], 'refused');
    expect(query['from'], DateTime(2026, 10, 1).toUtc().toIso8601String());
    expect(query['to'], DateTime(2026, 10, 3).toUtc().toIso8601String());
    expect(filter.isActive, isTrue);

    filter.directions = [SyncDirection.incoming, SyncDirection.outgoing];
    expect(filter.toQuery().containsKey('direction'), isFalse);

    filter.reset();
    expect(filter.isActive, isFalse);
    expect(filter.message, 'refused');
  });

  test('updates shown entries with progress and results in place', () async {
    final events = StreamController<FederationEvent>();
    final vm = AuditViewModel(
      ValueNotifier(0),
      service: FakeAuditService(3),
      events: events.stream,
    );
    await vm.init();
    final rows = vm.rows;

    events.add(
      const FederationEvent(
        FederationEventType.progress,
        progress: TransferProgress(
          entryId: 'e1',
          instance: 'alpha',
          direction: SyncDirection.outgoing,
          transferred: 5,
          size: 10,
        ),
      ),
    );
    await pumpEventQueue();
    expect((vm.rows[1].transferred, vm.rows[1].size), (5, 10));
    expect(vm.rows[0], same(rows[0]));

    events.add(
      FederationEvent(
        FederationEventType.auditAdded,
        entry: AuditEntry(
          entryId: 'e1',
          timestamp: DateTime.utc(2026, 10, 22),
          action: AuditAction.recordPushed,
          status: AuditStatus.failed,
          source: 'local',
          target: 'alpha',
        ),
      ),
    );
    await pumpEventQueue();
    expect(vm.rows[1].status, AuditStatus.failed);
    expect(vm.rows[1].transferred, isNull);
    expect(vm.rows, hasLength(3));

    vm.dispose();
    await events.close();
  });
}
