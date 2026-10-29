// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'admin_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Media Lib Administration';

  @override
  String get serverName => 'Servername (domain:port)';

  @override
  String get serverNameUnchanged => 'Servername (domain:port) (unchanged)';

  @override
  String get invalidServerName => 'A valid server name must be specified!';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get passwordUnchanged => 'Password (unchanged)';

  @override
  String get clientId => 'Client-ID';

  @override
  String get clientIdUnchanged => 'Client-ID (unchanged)';

  @override
  String get appKey => 'App-Key';

  @override
  String get appKeyUnchanged => 'App-Key (unchanged)';

  @override
  String get invalidClientId => 'A valid Client-ID must be specified!';

  @override
  String get invalidAppKey => 'An valid App-Key must be specified!';

  @override
  String get invalidUsername => 'Please enter your username!';

  @override
  String get invalidPassword => 'Please enter your password!';

  @override
  String get badCertificate => 'An certificate error occurred!';

  @override
  String unexpectedError(String message) {
    return 'An unexpected error occurred: $message';
  }

  @override
  String get forbidden =>
      'You have not the necessary rights, to execute this action!';

  @override
  String get incorrectCredentials => 'Login failed!';

  @override
  String get records => 'Records';

  @override
  String get adminUsers => 'Admins';

  @override
  String get devices => 'Devices';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get relogin =>
      'You were automatically logged out! Please login again!';

  @override
  String get advanced => 'Advanced';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get cancel => 'Cancel';

  @override
  String get filter => 'Filter';

  @override
  String get save => 'Apply';

  @override
  String get confirmAccount => 'Please update your password to proceed.';

  @override
  String get actualPassword => 'Actual password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm password';

  @override
  String get invalidConfirmPasswords =>
      'New password does not match verification.';

  @override
  String get updatePasswordFailed => 'Updating password failed!';

  @override
  String get actualUser => 'Actual user';

  @override
  String get changePassword => 'Change Password';

  @override
  String get noData => 'No records were found!';

  @override
  String get reload => 'Reload';

  @override
  String get editClient => 'Edit device';

  @override
  String get registerClient => 'Register client';

  @override
  String get displayName => 'Name';

  @override
  String get invalidDisplayName => 'Please enter a name!';

  @override
  String get deleteConfirmation =>
      'Are you really want to delete the selected records?';

  @override
  String get yes => 'Yes';

  @override
  String get createUser => 'Create admin';

  @override
  String get editUser => 'Edit admin';

  @override
  String get notFound => 'The requested record wasn\'t found!';

  @override
  String get retrieveTokenFailed => 'A token could not be retrieved!';

  @override
  String get invalidDeviceName => 'Please enter a device name!';

  @override
  String get deviceName => 'Device name';

  @override
  String lastTokenRefresh(String date) {
    return 'Last activity: $date';
  }

  @override
  String get groups => 'Groups';

  @override
  String get groupName => 'Group name';

  @override
  String get createGroup => 'Create group';

  @override
  String get editGroup => 'Edit group';

  @override
  String get groupIsDefault => 'Default group';

  @override
  String get groupIsDefaultHint =>
      'Group will be assigned per default on client creation.';

  @override
  String get invalidGroupName => 'Please enter a name!';

  @override
  String get invalidGroupIsDefault =>
      'Please specify, whether the group is a default group or not!';

  @override
  String get uploading => 'Uploading files.';

  @override
  String get unknown => 'Unknown';

  @override
  String get date => 'Date';

  @override
  String get artist => 'Artist';

  @override
  String get genre => 'Genre';

  @override
  String get album => 'Album';

  @override
  String toLargeFile(String fileName) {
    return 'File $fileName is to large.';
  }

  @override
  String uploadingFileFailed(String fileName, String error) {
    return 'An error occurred while uploading the file $fileName: $error';
  }

  @override
  String get invalidMp3File => 'File is not a valid MP3 file.';

  @override
  String get invalidFileNoContent => 'File has no content.';

  @override
  String get uploadFolder => 'Upload folder';

  @override
  String get uploadFiles => 'Upload files';

  @override
  String get actualConnectionSettings => 'Actual connection settings';

  @override
  String get editRecord => 'Edit record';

  @override
  String get title => 'Title';

  @override
  String get invalidTitle => 'A title must be specified.';

  @override
  String get uploadFinished => 'Upload finished.';

  @override
  String get notUploadedFiles => 'Following files were not uploaded.';

  @override
  String get uploadSettings => 'Upload settings';

  @override
  String get compressionRate => 'Bitrate in kbit/s';

  @override
  String get compressionInfo =>
      'Compression occurs at the next upload. With an empty bitrate, there is no compression.';

  @override
  String get invalidCompressionRate => 'The value must be greater than zero.';

  @override
  String get version => 'Version';

  @override
  String get back => 'back';

  @override
  String get folder => 'Folder';

  @override
  String get selectGroups => 'Select the groups for the records';

  @override
  String get language => 'Language';

  @override
  String get defaults => 'Default';

  @override
  String get editBitrates => 'Edit bitrates';

  @override
  String get bitrates => 'Bitrates';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get info => 'Info';

  @override
  String get ok => 'Ok';

  @override
  String get livestreams => 'Livestreams';

  @override
  String get editLivestream => 'Edit live stream';

  @override
  String get createLivestream => 'Create live stream';

  @override
  String get streamUrl => 'Url to live stream';

  @override
  String get streamUrlHint =>
      'Internal url to streaming endpoint: http://<address>:<port>';

  @override
  String get similarClients => 'Similar Devices';

  @override
  String get onlyNew => 'New';

  @override
  String get uploadValidation => 'MP3-Tag Validation';

  @override
  String get uploadValidLanguage => 'Language is set';

  @override
  String get uploadValidTitle => 'Title is set';

  @override
  String get uploadValidNumber => 'Tracknumber is set';

  @override
  String get uploadValidCover => 'Cover is set';

  @override
  String get uploadValidArtist => 'Artist is set';

  @override
  String get uploadValidAlbum => 'Album is set';

  @override
  String get uploadValidGenre => 'Genre is set';

  @override
  String get uploadValidAlbums => 'Valid albums';

  @override
  String get uploadValidAlbumInfo =>
      'Album names separated by a comma. If empty, then no limitation of albums.';

  @override
  String get uploadValidGenres => 'Valid genres';

  @override
  String get uploadValidGenreInfo =>
      'Genre names separated with a comma. If empty, then no limitation of genres.';

  @override
  String get uploadValidFilename => 'File name template';

  @override
  String get uploadValidFilenameInfo =>
      'File name must meet special format. Regex. Standard no restriction.';

  @override
  String get uploadInvalidLanguage => 'Language is not set or unknown.';

  @override
  String get uploadInvalidAlbum => 'Album is not set.';

  @override
  String get uploadInvalidAlbums => 'Album is invalid.';

  @override
  String get uploadInvalidGenre => 'Genre is not set.';

  @override
  String get uploadInvalidGenres => 'Genre is invalid.';

  @override
  String get uploadInvalidArtist => 'Artist is not set.';

  @override
  String get uploadInvalidTitle => 'Title is not set.';

  @override
  String get uploadInvalidNumber => 'Track number is not set.';

  @override
  String get uploadInvalidCover => 'Cover is not available.';

  @override
  String get uploadInvalidFilenameFormat =>
      'File name does not match expected format.';

  @override
  String get uploadValidFailed =>
      'An unexpected error occurred while uploading.';

  @override
  String get doNotValidate => 'Do not validate';

  @override
  String get validate => 'Validate';

  @override
  String get required => 'Required';

  @override
  String get assignTo => 'Assign';

  @override
  String get selectLoaded => 'Select all loaded elements';

  @override
  String get makeUndeletable => 'Not deletable';

  @override
  String get lock => 'Lock';

  @override
  String get newUpdate => 'New Update';

  @override
  String get later => 'Later';

  @override
  String get checkUpdate => 'Check new features and improvements.';

  @override
  String get updateInstall => 'Update and install';

  @override
  String get downloading => 'Downloading...';

  @override
  String newVersion(String latestVersion) {
    return 'A new Version $latestVersion is available.';
  }

  @override
  String oldVersion(String appVersion) {
    return 'You are currently running version $appVersion.';
  }

  @override
  String get inactive => 'Inactive';

  @override
  String get cacheSettings => 'Memory management';

  @override
  String get cacheRemove => 'Clear cache';

  @override
  String get cacheRemoveTime => 'Clear after';

  @override
  String get cacheRangeWeek => '1 Week';

  @override
  String get cacheRangeMonth => '1 Month';

  @override
  String get cacheRangeYear => '1 Year';

  @override
  String get cacheRangeNever => 'Never';

  @override
  String get cacheCleared => 'Cache was cleared successfully.';

  @override
  String get cacheClearedFailed => 'Cache could not be cleared.';

  @override
  String get instance => 'Instance';

  @override
  String get sync => 'Sync';

  @override
  String notOwned(String owner) {
    return 'Properties can be edited only by owner \'$owner\'.';
  }

  @override
  String get assignAndRemove => 'Assume groups and delete.';

  @override
  String get peers => 'Instances';

  @override
  String get invitations => 'Invitations';

  @override
  String get audit => 'Audit log';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get close => 'Close';

  @override
  String get copy => 'Copy';

  @override
  String get unlink => 'Remove registration';

  @override
  String get synchronize => 'Synchronize';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get recordsOfInstance => 'Records of instance';

  @override
  String get peerStateRequested => 'Requested';

  @override
  String get peerStatePendingApproval => 'Waiting for approval';

  @override
  String get peerStateResponsePending => 'Approved, response pending';

  @override
  String get peerStateLinked => 'Linked';

  @override
  String get peerStateRejected => 'Rejected';

  @override
  String peerKeysUpdatedAt(String date) {
    return 'Keys last updated: $date';
  }

  @override
  String get peerPendingApprovalInfo =>
      'The instance wants to synchronize records with this instance. After approval the partner is informed and the synchronization is enabled according to the rules. A rejected request is deleted.';

  @override
  String get peerRequestedInfo =>
      'The request was sent and waits for the approval of the admin of the partner.';

  @override
  String get peerUrl => 'Address of the partner';

  @override
  String get invitationCode => 'Invitation code';

  @override
  String get requestRegistration => 'Request registration';

  @override
  String get requestRegistrationSend => 'Request';

  @override
  String get requestRegistrationInfo =>
      'Enter the HTTPS address of the partner and the invitation code created by the admin of the partner.';

  @override
  String get invitationCreated => 'Invitation created';

  @override
  String invitationInfo(String date) {
    return 'Pass the address and the code to the admin of the partner. The code can be used once until $date and is not shown again.';
  }

  @override
  String invitationExpiresAt(String date) {
    return 'Valid until $date';
  }

  @override
  String get outgoingRules => 'Outgoing rules';

  @override
  String get incomingRules => 'Incoming rules';

  @override
  String get outgoingRule => 'Outgoing rule';

  @override
  String get incomingRule => 'Incoming rule';

  @override
  String get outgoingRulesInfo =>
      'Own records matching a rule are sent to the partner. Nothing is sent without a rule. Rules only apply to new records or manual synchronizations.';

  @override
  String get incomingRulesInfo =>
      'Received records are assigned to the groups of the most specific matching rule. Without a matching rule they are unassigned.';

  @override
  String get ruleInfo =>
      'Several values of one criterion are combined with OR, the criteria with AND. Received records are matched by name, ignoring the case.';

  @override
  String get ruleEmptyMatchesAll => 'Empty matches all.';

  @override
  String get ruleMatchesAll => 'All records';

  @override
  String get ruleGroups => 'Groups of received records';

  @override
  String unlinkTitle(String instance) {
    return 'Remove registration of $instance';
  }

  @override
  String get unlinkInfo =>
      'The synchronization is stopped and the partner is informed. Synchronized records are kept unless you delete them.';

  @override
  String get unlinkDeleteRecords => 'Delete synchronized records';

  @override
  String unlinkDeleteRecordsInfo(String instance) {
    return 'All records received from $instance are deleted here, locked ones too. $instance is asked to delete the records of this instance.';
  }

  @override
  String unlinkKeepRecordsInfo(String instance) {
    return 'The records received from $instance are kept here and can be deleted manually.';
  }

  @override
  String get unlinkLocally => 'Remove locally only';

  @override
  String unlinkLocallyInfo(String instance) {
    return '$instance could not be informed. If you remove the registration locally only, $instance keeps the registration until the admin of the partner removes it.';
  }

  @override
  String unlinkLocallyDeleteInfo(String instance) {
    return '$instance could not be informed. If you remove the registration locally only, the records received from $instance are deleted here. The records of this instance are kept by $instance.';
  }

  @override
  String registrationReceived(String instance) {
    return 'New registration request from $instance.';
  }

  @override
  String syncResult(int queued, int skipped) {
    return '$queued transfers queued, $skipped records skipped.';
  }

  @override
  String get federationDisabled =>
      'The synchronization is not configured on the server.';

  @override
  String get federationInvalidUrl =>
      'The address must be a valid HTTPS address.';

  @override
  String get federationRemoteUnreachable => 'The partner is not reachable.';

  @override
  String get federationRemoteRejected =>
      'The partner rejected the request. Check the invitation code.';

  @override
  String get federationInvalidDiscovery =>
      'The partner returns invalid information.';

  @override
  String get federationInstanceConflict =>
      'An instance with this name is already registered.';

  @override
  String get federationInvalidState =>
      'The action is not possible in the current state of the partner.';

  @override
  String get federationInvalidInvitation => 'The invitation code is invalid.';

  @override
  String auditRecords(int count) {
    return '$count records';
  }

  @override
  String get auditStatus => 'Status';

  @override
  String get auditSource => 'Source';

  @override
  String get auditTarget => 'Target';

  @override
  String get auditTransaction => 'Transaction';

  @override
  String get auditMessage => 'Message';

  @override
  String get auditSuccess => 'Successful';

  @override
  String get auditFailed => 'Failed';

  @override
  String get auditSkipped => 'Skipped';

  @override
  String get auditRegistrationRequested => 'Registration requested';

  @override
  String get auditRegistrationReceived => 'Registration request received';

  @override
  String get auditRegistrationApproved => 'Registration approved';

  @override
  String get auditRegistrationRejected => 'Registration rejected';

  @override
  String get auditUnlinked => 'Registration removed';

  @override
  String get auditKeysChanged => 'Keys changed';

  @override
  String get auditRecordPushed => 'Record sent';

  @override
  String get auditRecordReceived => 'Record received';

  @override
  String get auditRecordUpdated => 'Record updated';

  @override
  String get auditRecordDeleted => 'Record deleted';

  @override
  String get auditRecordsRemoved => 'Records removed';

  @override
  String rejectTitle(String instance) {
    return 'Reject request of $instance';
  }

  @override
  String rejectInfo(String instance) {
    return '$instance is informed about the rejection and the request is deleted. If $instance is not reachable, the request is deleted anyway. $instance needs a new invitation code for a new request.';
  }

  @override
  String get auditNewEntries => 'New entries – reload';

  @override
  String get auditRetention => 'Keep audit log';

  @override
  String get auditRetentionInfo =>
      'Older entries of the synchronization audit log are deleted automatically.';

  @override
  String get retentionThreeMonths => '3 Months';

  @override
  String get retentionSixMonths => '6 Months';

  @override
  String get invitationAddress => 'Address of this instance';

  @override
  String get rules => 'Rules';

  @override
  String get ruleAllInstances => 'All instances';

  @override
  String get ruleEmptyAllInstances =>
      'Empty applies to all instances, also to instances linked later.';

  @override
  String get peerNoRules => 'No rule applies to this instance.';

  @override
  String get peerRulesInfo =>
      'Rules are managed under Sync → Rules. Rules restricted to the instance take precedence over rules for all instances.';

  @override
  String approveTitle(String instance) {
    return 'Approve request of $instance';
  }

  @override
  String approveInfo(String instance, int count) {
    return '$instance is informed and the synchronization is enabled. From then on $count outgoing rules apply to $instance: new own records matching them are sent to $instance.';
  }

  @override
  String get ruleSourceGroups => 'Groups of the records which are sent';

  @override
  String receivedFrom(String owner) {
    return 'Received from $owner';
  }

  @override
  String get syncState => 'Synchronization';

  @override
  String get syncStateReceived => 'Received';

  @override
  String get syncStateSent => 'Sent';

  @override
  String get syncStateProblem => 'Problem';

  @override
  String get syncStateNone => 'Not synchronized';

  @override
  String syncProblemWith(String instance) {
    return 'Synchronization with $instance failed';
  }

  @override
  String get syncProblemFailed =>
      'Failed finally. Try again with “Synchronize”.';

  @override
  String syncProblemRetry(String date) {
    return 'Next attempt: $date';
  }

  @override
  String syncSentCount(int count) {
    return 'Sent to $count instances';
  }

  @override
  String syncProblemCount(int count) {
    return '$count problems';
  }

  @override
  String get auditResult => 'Result';

  @override
  String get auditDirection => 'Direction';

  @override
  String get auditAction => 'Action';

  @override
  String get auditIncoming => 'Incoming';

  @override
  String get auditOutgoing => 'Outgoing';

  @override
  String get auditFilterReset => 'Reset filters';

  @override
  String get auditSelectionClear => 'Clear selection';

  @override
  String get auditDeleteSelected => 'Delete selected';

  @override
  String auditDeleteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries will be deleted.',
      one: '1 entry will be deleted.',
    );
    return '$_temp0 Continue?';
  }

  @override
  String get auditFilterRemove => 'Remove filter';

  @override
  String get invitationNew => 'New invitation';

  @override
  String get invitationNewInfo =>
      'An invitation code is created, which a partner instance can use once to register.';

  @override
  String get create => 'Create';

  @override
  String get auditRecordRemoved => 'Record no longer available';

  @override
  String get auditPending => 'Pending';

  @override
  String get invitationValidity => 'Validity';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get syncStatePending => 'Sending';

  @override
  String get auditRecordRevoked => 'Synchronization revoked';

  @override
  String get auditAddressChanged => 'Address changed';

  @override
  String get federationInvalidPeer => 'A selected instance is not linked.';

  @override
  String get federationUnknownKeys =>
      'The instance at the new address cannot prove that it owns a known key. If its keys were replaced as well, remove the registration and request it again.';

  @override
  String get revokeSync => 'Revoke synchronization';

  @override
  String get revokeSyncInfo =>
      'The records are removed on the selected instances and kept here. They are not sent there automatically or with folders anymore until they are synchronized again one by one.';

  @override
  String revokeResult(int count) {
    return '$count removals on partners scheduled.';
  }

  @override
  String transferPercent(int percent) {
    return '$percent %';
  }

  @override
  String transferWaiting(String date) {
    return 'Waiting until $date';
  }

  @override
  String get allInstances => 'All instances';

  @override
  String get changeAddress => 'Change address';

  @override
  String changeAddressTitle(String instance) {
    return 'Change address of $instance';
  }

  @override
  String changeAddressInfo(String instance) {
    return '$instance must be reachable at the new address with the same name and sign with a known key. Open transfers are retried immediately afterwards.';
  }

  @override
  String addressChanged(String instance, String url) {
    return '$instance is reachable at $url now.';
  }

  @override
  String syncRevokedAt(String date) {
    return 'Synchronization revoked on $date';
  }

  @override
  String syncPendingCount(int count) {
    return '$count transfers open';
  }

  @override
  String syncRevokedCount(int count) {
    return 'Revoked for $count instances';
  }
}
