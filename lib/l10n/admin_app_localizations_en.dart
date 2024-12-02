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
  String get forbidden => 'You have not the necessary rights, to execute this action!';

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
  String get relogin => 'You were automatically logged out! Please login again!';

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
  String get invalidConfirmPasswords => 'New password does not match verification.';

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
  String get deleteConfirmation => 'Are you really want to delete the selected records?';

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
  String get groupIsDefaultHint => 'Group will be assigned per default on client creation.';

  @override
  String get invalidGroupName => 'Please enter a name!';

  @override
  String get invalidGroupIsDefault => 'Please specify, whether the group is a default group or not!';

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
  String get compressionInfo => 'Compression occurs at the next upload. With an empty bitrate, there is no compression.';

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
  String get streamUrlHint => 'Internal url to streaming endpoint: http://<address>:<port>';

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
  String get uploadValidAlbumInfo => 'Album names separated by a comma. If empty, then no limitation of albums.';

  @override
  String get uploadValidGenres => 'Valid genres';

  @override
  String get uploadValidGenreInfo => 'Genre names separated with a comma. If empty, then no limitation of genres.';

  @override
  String get uploadValidFilename => 'File name template';

  @override
  String get uploadValidFilenameInfo => 'File name must meet special format. Regex. Standard no restriction.';

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
  String get uploadInvalidFilenameFormat => 'File name does not match expected format.';

  @override
  String get uploadValidFailed => 'An unexpected error occurred while uploading.';

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
}
