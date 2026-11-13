import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mml_admin/models/federation/audit_entries.dart';
import 'package:mml_admin/models/federation/audit_entry.dart';
import 'package:mml_admin/models/federation/audit_filter.dart';
import 'package:mml_admin/models/federation/invitation.dart';
import 'package:mml_admin/models/federation/owner_instance.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/federation/record_sync_info.dart';
import 'package:mml_admin/models/federation/rule.dart';
import 'package:mml_admin/models/federation/sync_result.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/models/record_folder.dart';
import 'package:mml_admin/services/api.dart';

/// Error codes returned by the federation endpoints of the server.
abstract class FederationErrors {
  /// The federation is disabled on the server.
  static const String disabled = 'FEDERATION_DISABLED';

  /// The url of the partner is invalid.
  static const String invalidUrl = 'INVALID_URL';

  /// The partner is not reachable.
  static const String remoteUnreachable = 'REMOTE_UNREACHABLE';

  /// The partner rejected the request.
  static const String remoteRejected = 'REMOTE_REJECTED';

  /// The partner returned invalid information.
  static const String invalidDiscovery = 'INVALID_DISCOVERY';

  /// The instance name of the partner is already used.
  static const String instanceConflict = 'INSTANCE_CONFLICT';

  /// The partner is not in the expected registration state.
  static const String invalidState = 'INVALID_STATE';

  /// The invitation code is invalid.
  static const String invalidInvitation = 'INVALID_INVITATION';

  /// A value of a rule is invalid.
  static const String invalidRule = 'INVALID_RULE';

  /// The partner or rule does not exist.
  static const String notFound = 'NOT_FOUND';

  /// A selected partner does not exist or is not linked.
  static const String invalidPeer = 'INVALID_PEER';

  /// The partner at the new address does not publish a known key.
  static const String unknownKeys = 'UNKNOWN_KEYS';
}

/// Retention of the federation audit log.
abstract class AuditRetention {
  /// Key of the setting on the server.
  static const String settingKey = 'FederationAuditRetentionDays';

  /// Retention in days used if no value is stored.
  static const int defaultDays = 90;

  /// Selectable retentions in days. 0 keeps the entries until they are
  /// deleted manually.
  static const List<int> allowedDays = [7, 30, 90, 180, 365, 0];

  /// Returns the retention in days of the stored [value].
  static int parse(String? value) {
    var days = int.tryParse(value ?? '');
    return days != null && allowedDays.contains(days) ? days : defaultDays;
  }
}

/// Exception thrown when a federation endpoint returns an error.
class FederationException implements Exception {
  /// The error code, see [FederationErrors], or null if the server returned
  /// no code.
  final String? code;

  /// The http status code of the response.
  final int? statusCode;

  /// Initializes the exception.
  const FederationException(this.code, this.statusCode);

  /// Creates the exception from the [response] of the server.
  factory FederationException.fromResponse(Response? response) {
    var data = response?.data;
    return FederationException(
      data is Map ? data['code'] as String? : null,
      response?.statusCode,
    );
  }

  @override
  String toString() => 'FederationException($code, $statusCode)';
}

/// Service that handles the federation with partner instances on the server.
class FederationService {
  /// Instance of the federation service.
  static final FederationService _instance = FederationService._();

  /// Instance of the [ApiService] to access the server with.
  final ApiService _apiService = ApiService.getInstance();

  /// Private constructor of the service.
  FederationService._();

  /// Returns the singleton instance of the [FederationService].
  static FederationService getInstance() {
    return _instance;
  }

  /// Returns a list of partners with the amount of [take] that match the given
  /// [filter] starting from the [offset].
  Future<ModelList> getPeers(String? filter, int? offset, int? take) async {
    var response = await _request(
      'peers',
      'GET',
      queryParameters: {"filter": filter, "skip": offset, "take": take},
    );

    return ModelList(
      List<Peer>.from(
        response.data['items'].map((item) => Peer.fromJson(item)),
      ),
      offset ?? 0,
      response.data["totalCount"],
    );
  }

  /// Requests the registration at the partner with the [baseUrl] by the
  /// [invitationCode] created by the admin of the partner.
  Future<Peer> requestRegistration(
    String baseUrl,
    String invitationCode,
  ) async {
    var response = await _request(
      'peers',
      'POST',
      data: {'baseUrl': baseUrl, 'invitationCode': invitationCode},
    );
    return Peer.fromJson(response.data);
  }

  /// Approves the registration request of the partner with the [peerId].
  Future<void> approve(String peerId) async {
    await _request('peers/$peerId/approve', 'POST');
  }

  /// Rejects the registration request of the partner with the [peerId].
  Future<void> reject(String peerId) async {
    await _request('peers/$peerId/reject', 'POST');
  }

  /// Removes the registration of the partner with the [peerId].
  ///
  /// Removes the records of both instances if [deleteRecords] is set. Removes
  /// the registration even if the partner cannot be informed if [force] is
  /// set.
  Future<void> unlink(
    String peerId, {
    required bool deleteRecords,
    bool force = false,
  }) async {
    await _request(
      'peers/$peerId/unlink',
      'POST',
      data: {'deleteRecords': deleteRecords, 'force': force},
    );
  }

  /// Returns the open invitations.
  Future<ModelList> getInvitations() async {
    var response = await _request('invitations', 'GET');
    var items = List<Invitation>.from(
      response.data['items'].map((item) => Invitation.fromJson(item)),
    );
    return ModelList(items, 0, items.length);
  }

  /// Creates a new invitation, which stays valid for [validityHours]. The
  /// returned invitation contains the code.
  Future<Invitation> createInvitation(int validityHours) async {
    var response = await _request(
      'invitations',
      'POST',
      data: {'validityHours': validityHours},
    );
    return Invitation.fromJson(response.data);
  }

  /// Revokes the invitations with the given [invitationIds].
  Future<void> deleteInvitations(List<String> invitationIds) async {
    for (var invitationId in invitationIds) {
      await _request('invitations/$invitationId', 'DELETE');
    }
  }

  /// Returns all rules or, if [peerId] is set, the rules which apply to the
  /// partner with the [peerId].
  Future<List<Rule>> getRules({String? peerId}) async {
    var response = await _request(
      'rules',
      'GET',
      queryParameters: {'peerId': peerId},
    );
    return List<Rule>.from(
      response.data['items'].map((item) => Rule.fromJson(item)),
    );
  }

  /// Creates the [rule] or updates it, if the rule exists already.
  Future<void> saveRule(Rule rule) async {
    await _request(
      rule.ruleId == null ? 'rules' : 'rules/${rule.ruleId}',
      'POST',
      data: rule.toRequest(),
    );
  }

  /// Removes the rules with the given [ruleIds].
  Future<void> deleteRules(List<String> ruleIds) async {
    await _request('rules/deleteList', 'POST', data: ruleIds);
  }

  /// Sends the own records with the [recordIds] and the records within the
  /// [folders] to the partners with the [peerIds] or to every linked partner,
  /// if [peerIds] is null, with a matching outgoing rule. Records with the
  /// [recordIds] are sent even if their synchronization was revoked.
  Future<SyncResult> synchronize({
    List<String> recordIds = const [],
    List<RecordFolder> folders = const [],
    List<String>? peerIds,
  }) async {
    var response = await _request(
      '/media/sync',
      'POST',
      data: {'recordIds': recordIds, 'folders': folders, 'peerIds': ?peerIds},
    );
    return SyncResult.fromJson(response.data);
  }

  /// Revokes the synchronization of the own records with the [recordIds] and
  /// within the [folders] with the partners with the [peerIds] or with every
  /// linked partner, if [peerIds] is null. The records are removed on the
  /// partners and not sent again until they are synchronized manually.
  Future<SyncResult> revoke({
    List<String> recordIds = const [],
    List<RecordFolder> folders = const [],
    List<String>? peerIds,
  }) async {
    var response = await _request(
      '/media/sync/revoke',
      'POST',
      data: {'recordIds': recordIds, 'folders': folders, 'peerIds': ?peerIds},
    );
    return SyncResult.fromJson(response.data);
  }

  /// Changes the address of the partner with the [peerId] to the [baseUrl].
  Future<Peer> changeAddress(String peerId, String baseUrl) async {
    var response = await _request(
      'peers/$peerId/address',
      'POST',
      data: {'baseUrl': baseUrl},
    );
    return Peer.fromJson(response.data);
  }

  /// Returns the partners the record with the [recordId] was sent to or
  /// received from and the failed operations of the record.
  Future<RecordSyncInfo> getRecordSync(String recordId) async {
    var response = await _request('/media/sync/records/$recordId', 'GET');
    return RecordSyncInfo.fromJson(response.data);
  }

  /// Returns the names of all instances owning records which match the
  /// [filter].
  Future<ModelList> getInstances(String? filter) async {
    var response = await _request('instances', 'GET');
    var items = List<String>.from(response.data)
        .where(
          (name) =>
              filter == null ||
              name.toLowerCase().contains(filter.toLowerCase()),
        )
        .map((name) => OwnerInstance(name))
        .toList();
    return ModelList(items, 0, items.length);
  }

  /// Returns the audit log entries matching the [filter] in its sort order
  /// with the amount of [take] starting from the [offset].
  Future<AuditEntries> getAudit(
    AuditFilter filter,
    int offset,
    int take,
  ) async {
    var response = await _request(
      'audit',
      'GET',
      queryParameters: {...filter.toQuery(), "skip": offset, "take": take},
    );

    return AuditEntries(
      List<AuditEntry>.from(
        response.data['items'].map((item) => AuditEntry.fromJson(item)),
      ),
      response.data["totalCount"],
    );
  }

  /// Returns the names of all partner instances occurring in the audit log.
  Future<List<String>> getAuditInstances() async {
    var response = await _request('audit/instances', 'GET');
    return List<String>.from(response.data);
  }

  /// Removes the audit log entries with the given [entryIds].
  Future<void> deleteAudit(List<String> entryIds) async {
    await _request('audit/deleteList', 'POST', data: entryIds);
  }

  /// Returns the days the audit log entries are kept. 0 keeps the entries
  /// until they are deleted manually.
  Future<int> getAuditRetention() async {
    var response = await _apiService.request(
      '/media/settings/${AuditRetention.settingKey}',
      options: Options(method: 'GET'),
    );
    return AuditRetention.parse(response.data?.toString());
  }

  /// Sets the [days] the audit log entries are kept.
  Future<void> setAuditRetention(int days) async {
    await _apiService.request(
      '/media/settings/${AuditRetention.settingKey}',
      data: {'value': days.toString()},
      options: Options(method: 'POST', contentType: Headers.jsonContentType),
    );
  }

  /// Sends a request to the federation endpoint [path] and converts errors to
  /// a [FederationException]. A [path] starting with `/` is used as it is,
  /// other paths are relative to the federation endpoint.
  ///
  /// A bad gateway response is accepted by the http client, so the generic
  /// error message of the [ApiService] is not shown for unreachable partners.
  Future<Response> _request(
    String path,
    String method, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;
    try {
      response = await _apiService.request(
        path.startsWith('/') ? path : '/media/federation/$path',
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          contentType: Headers.jsonContentType,
          validateStatus: (status) =>
              status != null &&
              (status < HttpStatus.badRequest ||
                  status == HttpStatus.badGateway),
        ),
      );
    } on DioException catch (e) {
      if (e.response == null) {
        rethrow;
      }
      throw FederationException.fromResponse(e.response);
    }

    if (response.statusCode == HttpStatus.badGateway) {
      throw FederationException.fromResponse(response);
    }

    return response;
  }
}
