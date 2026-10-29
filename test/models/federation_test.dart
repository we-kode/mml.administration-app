import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/extensions/federation_error.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/album.dart';
import 'package:mml_admin/models/artist.dart';
import 'package:mml_admin/models/federation/audit_action.dart';
import 'package:mml_admin/models/federation/audit_entry.dart';
import 'package:mml_admin/models/federation/audit_record.dart';
import 'package:mml_admin/models/federation/audit_status.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/federation/peer_state.dart';
import 'package:mml_admin/models/federation/record_link.dart';
import 'package:mml_admin/models/federation/record_sync_info.dart';
import 'package:mml_admin/models/federation/record_sync_problem.dart';
import 'package:mml_admin/models/federation/record_sync_state.dart';
import 'package:mml_admin/models/federation/record_sync_transfer.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/models/federation/sync_result.dart';
import 'package:mml_admin/models/federation/transfer_progress.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/services/federation.dart';

void main() {
  final locales = lookupAppLocalizations(const Locale('en'));

  group('Peer', () {
    test('reads the server model', () {
      final peer = Peer.fromJson({
        'peerId': 'b8c4f1c2-0000-0000-0000-000000000001',
        'instance': 'beta',
        'baseUrl': 'https://beta.example.org',
        'state': PeerState.pendingApproval,
        'jwksUpdatedAt': '2026-10-20T10:00:00Z',
        'createdAt': '2026-10-20T09:00:00Z',
        'updatedAt': '2026-10-20T09:00:00Z',
      });

      expect(peer.getIdentifier(), 'b8c4f1c2-0000-0000-0000-000000000001');
      expect(peer.getDisplayDescription(), 'beta');
      expect(peer.isPendingApproval, isTrue);
      expect(peer.hasRules, isFalse);
      expect(peer.stateName(locales), locales.peerStatePendingApproval);
    });

    test('allows rules for linked partners only', () {
      Peer peer(int state) =>
          Peer(peerId: '1', instance: 'a', baseUrl: 'https://a', state: state);

      expect(peer(PeerState.linked).hasRules, isTrue);
      expect(peer(PeerState.responsePending).hasRules, isTrue);
      expect(peer(PeerState.requested).hasRules, isFalse);
    });
  });

  group('Rule', () {
    test('sends group ids only for incoming rules', () {
      final groups = [Group(id: 'g1', name: 'Kids')];
      final incoming = Rule(
        direction: SyncDirection.incoming,
        albums: [Album(albumId: 'a1', albumName: 'Live')],
        peers: [
          Peer(
            peerId: 'p1',
            instance: 'beta',
            baseUrl: 'https://beta',
            state: PeerState.linked,
          ),
        ],
        groups: groups,
      );
      final outgoing = Rule(direction: SyncDirection.outgoing, groups: groups);

      expect(incoming.toRequest(), {
        'direction': SyncDirection.incoming,
        'peers': ['p1'],
        'artists': <String>[],
        'albums': ['a1'],
        'genres': <String>[],
        'groups': ['g1'],
      });
      expect(outgoing.toRequest()['groups'], ['g1']);
      expect(outgoing.describe(locales), '${locales.groups}: Kids');
      expect(incoming.isGlobal, isFalse);
      expect(incoming.describePeers(locales), 'beta');
      expect(outgoing.isGlobal, isTrue);
      expect(outgoing.describePeers(locales), locales.ruleAllInstances);
    });

    test('copies a rule without sharing its values', () {
      final rule = Rule.fromJson({
        'ruleId': 'r1',
        'peerId': 'p1',
        'direction': SyncDirection.outgoing,
        'artists': [
          {'artistId': 'ar1', 'name': 'A'},
        ],
        'albums': [],
        'genres': [
          {'genreId': 'g1', 'name': 'Rock'},
          {'genreId': 'g2', 'name': 'Pop'},
        ],
        'groups': [],
        'createdAt': '2026-10-20T09:00:00Z',
      });
      final copy = Rule.fromJson(rule.toJson());

      copy.artists.add(Artist(artistId: 'ar2', name: 'B'));

      expect(copy.ruleId, 'r1');
      expect(rule.artists.map((a) => a.artistId), ['ar1']);
      expect(rule.toRequest()['genres'], ['g1', 'g2']);
      expect(rule.describe(locales), 'Artist: A · Genre: Rock, Pop');
      expect(Rule(direction: 1).describe(locales), locales.ruleMatchesAll);
    });
  });

  test('AuditEntry reads the server model', () {
    final entry = AuditEntry.fromJson({
      'entryId': 'e1',
      'timestamp': '2026-10-20T10:00:00Z',
      'action': AuditAction.recordReceived,
      'status': AuditStatus.skipped,
      'source': 'beta',
      'target': 'alpha',
      'direction': SyncDirection.incoming,
      'instance': 'beta',
      'transactionId': null,
      'recordIds': ['r1', 'r2'],
      'message': 'Duplicate',
    });

    expect(entry.instance, 'beta');
    expect(entry.directionName(locales), locales.auditIncoming);
    expect(entry.actionName(locales), locales.auditRecordReceived);
    expect(entry.statusName(locales), locales.auditSkipped);
    expect(entry.recordIds, hasLength(2));
  });

  test('AuditEntry names pending operations without notifying', () {
    final entry = AuditEntry(
      entryId: 'e1',
      timestamp: DateTime.utc(2026),
      action: AuditAction.recordPushed,
      status: AuditStatus.pending,
      source: 'alpha',
      target: 'beta',
      direction: SyncDirection.outgoing,
    );

    expect(entry.statusName(locales), locales.auditPending);
    expect(entry.isNotable, isFalse);
  });

  test('AuditEntry names removed records', () {
    final entry = AuditEntry.fromJson({
      'entryId': 'e1',
      'timestamp': '2026-10-20T10:00:00Z',
      'action': AuditAction.recordDeleted,
      'status': AuditStatus.success,
      'source': 'beta',
      'target': 'alpha',
      'recordIds': ['r1', 'r2'],
      'records': [
        {'recordId': 'r2', 'title': 'Song'},
      ],
    });

    expect(entry.recordTitles('removed'), ['removed', 'Song']);
  });

  test('AuditEntry notifies about changes of partners and failures', () {
    AuditEntry entry(int action, int status, int direction) => AuditEntry(
      entryId: 'e1',
      timestamp: DateTime.utc(2026),
      action: action,
      status: status,
      source: 'a',
      target: 'b',
      direction: direction,
    );

    expect(
      entry(
        AuditAction.recordDeleted,
        AuditStatus.success,
        SyncDirection.incoming,
      ).isNotable,
      isTrue,
    );
    expect(
      entry(
        AuditAction.recordPushed,
        AuditStatus.failed,
        SyncDirection.outgoing,
      ).isNotable,
      isTrue,
    );
    expect(
      entry(
        AuditAction.recordPushed,
        AuditStatus.success,
        SyncDirection.outgoing,
      ).isNotable,
      isFalse,
    );
    expect(
      entry(
        AuditAction.keysChanged,
        AuditStatus.success,
        SyncDirection.incoming,
      ).isNotable,
      isFalse,
    );
  });

  test('SyncResult reads the server model', () {
    final result = SyncResult.fromJson({'queued': 3, 'skipped': 1});

    expect(result.queued, 3);
    expect(result.skipped, 1);
  });

  group('FederationException', () {
    test('reads the error code of the response', () {
      final exception = FederationException.fromResponse(
        Response(
          requestOptions: RequestOptions(),
          statusCode: 502,
          data: {'code': FederationErrors.remoteUnreachable, 'detail': '…'},
        ),
      );

      expect(exception.code, FederationErrors.remoteUnreachable);
      expect(exception.statusCode, 502);
      expect(exception.message(locales), locales.federationRemoteUnreachable);
    });

    test('handles responses without code', () {
      final exception = FederationException.fromResponse(
        Response(requestOptions: RequestOptions(), statusCode: 500, data: ''),
      );

      expect(exception.code, isNull);
      expect(exception.message(locales), locales.unexpectedError('500'));
    });
  });

  group('ID3TagFilter', () {
    test('sends the federation filters', () {
      final filter = ID3TagFilter();
      filter[ID3TagFilters.unassigned] = true;
      filter[ID3TagFilters.instances] = ['beta'];

      final json = filter.toJson();

      expect(json['unassigned'], isTrue);
      expect(json['instances'], ['beta']);
      expect(filter.isNotEmpty(ID3TagFilters.unassigned), isTrue);
      expect(filter.isNotEmpty(ID3TagFilters.instances), isTrue);
    });

    test('clears the federation filters', () {
      final filter = ID3TagFilter(instances: ['beta'], unassigned: true);

      filter.clear(ID3TagFilters.unassigned);
      filter.clear(ID3TagFilters.instances);

      expect(filter.unassigned, isFalse);
      expect(filter.instances, isEmpty);
    });
  });

  test('AuditRetention accepts the selectable values only', () {
    expect(AuditRetention.parse('30'), 30);
    expect(AuditRetention.parse('0'), 0);
    expect(AuditRetention.parse('45'), AuditRetention.defaultDays);
    expect(AuditRetention.parse(''), AuditRetention.defaultDays);
    expect(AuditRetention.parse(null), AuditRetention.defaultDays);
  });

  test('Record reads the synchronization state of the list', () {
    final record = Record.fromJson({
      'recordId': 'r1',
      'ownerInstance': 'beta',
      'duration': 0,
      'groups': [],
      'syncState': RecordSyncState.received,
    });

    expect(record.syncState, RecordSyncState.received);
    expect(record.toJson().containsKey('syncState'), isFalse);
  });

  test('RecordSyncInfo reads the server model', () {
    final info = RecordSyncInfo.fromJson({
      'links': [
        {
          'linkId': 'l1',
          'peerId': 'p1',
          'instance': 'beta',
          'direction': SyncDirection.outgoing,
          'syncedAt': '2026-10-22T10:00:00Z',
        },
      ],
      'problems': [
        {'instance': 'gamma', 'type': 3, 'error': '413', 'failed': true},
      ],
    });

    expect(info.links.single.instance, 'beta');
    expect(info.problems.single.instance, 'gamma');
    expect(info.problems.single.failed, isTrue);
  });

  test('RecordSyncInfo reads transfers and exclusions', () {
    final info = RecordSyncInfo.fromJson({
      'transfers': [
        {
          'instance': 'beta',
          'transferred': 50,
          'size': 200,
          'nextAttemptAt': '2026-10-22T10:00:00Z',
        },
        {'instance': 'gamma', 'nextAttemptAt': '2026-10-22T10:00:00Z'},
      ],
      'exclusions': [
        {
          'peerId': 'p1',
          'instance': 'delta',
          'createdAt': '2026-10-22T10:00:00Z',
        },
      ],
    });

    final waiting = info.transfers.last;
    expect(transferFraction(info.transfers.first.transferred, 200), 0.25);
    expect(transferFraction(waiting.transferred, waiting.size), isNull);
    expect(waiting.withProgress(10, 40).size, 40);
    expect(info.exclusions.single.instance, 'delta');
  });

  test('TransferProgress reads the event of the server', () {
    final progress = TransferProgress.fromJson({
      'entryId': 'e1',
      'recordId': 'r1',
      'instance': 'beta',
      'direction': SyncDirection.outgoing,
      'transferred': 300,
      'size': 200,
    });

    expect(progress.recordId, 'r1');
    expect(progress.fraction, 1);
  });

  test('AuditEntry keeps its values when the progress changes', () {
    final entry = AuditEntry(
      entryId: 'e1',
      timestamp: DateTime.utc(2026, 10, 22),
      action: AuditAction.recordRevoked,
      status: AuditStatus.pending,
      source: 'alpha',
      target: 'beta',
      records: [AuditRecord(recordId: 'r1', title: 'Title')],
      recordIds: ['r1'],
    );

    final updated = entry.withProgress(5, 10);

    expect((updated.transferred, updated.size), (5, 10));
    expect(updated.recordTitles('-'), ['Title']);
    expect(updated.actionName(locales), locales.auditRecordRevoked);
  });

  test('RecordSyncInfo evaluates the state of an own record', () {
    final sent = RecordLink(
      direction: SyncDirection.outgoing,
      syncedAt: DateTime.utc(2026, 10, 22),
    );
    final transfer = RecordSyncTransfer(
      instance: 'beta',
      nextAttemptAt: DateTime.utc(2026, 10, 22),
    );

    expect(RecordSyncInfo().ownState, RecordSyncState.none);
    expect(RecordSyncInfo(links: [sent]).ownState, RecordSyncState.sent);
    expect(
      RecordSyncInfo(links: [sent], transfers: [transfer]).ownState,
      RecordSyncState.pending,
    );
    expect(
      RecordSyncInfo(
        transfers: [transfer],
        problems: [RecordSyncProblem(instance: 'gamma')],
      ).ownState,
      RecordSyncState.problem,
    );
  });
}
