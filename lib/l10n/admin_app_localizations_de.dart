import 'admin_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Meine Mediathek Administration';

  @override
  String get serverName => 'Server (Domain:Port)';

  @override
  String get serverNameUnchanged => 'Server (Domain:Port) (unverändert)';

  @override
  String get invalidServerName => 'Eine korrekte Serveradresse muss angegeben werden!';

  @override
  String get login => 'Anmelden';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get passwordUnchanged => 'Passwort (unverändert)';

  @override
  String get clientId => 'Client-ID';

  @override
  String get clientIdUnchanged => 'Client-ID (unverändert)';

  @override
  String get appKey => 'App-Schlüssel';

  @override
  String get appKeyUnchanged => 'App-Schlüssel (unverändert)';

  @override
  String get invalidClientId => 'Eine korrekte Client-ID muss angegeben werden!';

  @override
  String get invalidAppKey => 'Ein korrekter App-Schlüssel muss angegeben werden!';

  @override
  String get invalidUsername => 'Bitte geben Sie Ihren Benutzernamen an!';

  @override
  String get invalidPassword => 'Bitte geben Sie Ihr Passwort an!';

  @override
  String get badCertificate => 'Es ist ein Zertifikatsfehler aufgetreten!';

  @override
  String unexpectedError(String message) {
    return 'Es ist ein unerwarteter Fehler aufgetreten: $message';
  }

  @override
  String get forbidden => 'Sie haben nicht die notwendigen Rechte, die Aktion auszuführen!';

  @override
  String get incorrectCredentials => 'Anmeldung fehlgeschlagen!';

  @override
  String get records => 'Aufnahmen';

  @override
  String get adminUsers => 'Admins';

  @override
  String get devices => 'Geräte';

  @override
  String get settings => 'Einstellungen';

  @override
  String get logout => 'Abmelden';

  @override
  String get relogin => 'Sie wurden automatisch abgemeldet! Bitte melden Sie sich neu an!';

  @override
  String get advanced => 'Erweitert';

  @override
  String get add => 'Hinzufügen';

  @override
  String get remove => 'Löschen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get filter => 'Filter';

  @override
  String get save => 'Anwenden';

  @override
  String get confirmAccount => 'Bitte aktualisieren Sie Ihr Passwort, um fortzufahren.';

  @override
  String get actualPassword => 'Aktuelles Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Passwort bestätigen';

  @override
  String get invalidConfirmPasswords => 'Neues Passwort stimmt mit Überprüfung nicht überein.';

  @override
  String get updatePasswordFailed => 'Passwortaktualisierung fehlgeschlagen!';

  @override
  String get actualUser => 'Aktueller Benutzer';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get noData => 'Keine Datensätze wurden gefunden!';

  @override
  String get reload => 'Neu laden';

  @override
  String get editClient => 'Gerät bearbeiten';

  @override
  String get registerClient => 'Gerät registrieren';

  @override
  String get displayName => 'Name';

  @override
  String get invalidDisplayName => 'Bitte geben Sie einen Namen an!';

  @override
  String get deleteConfirmation => 'Möchten Sie tatsächlich die gewählten Datensätze löschen?';

  @override
  String get yes => 'Ja';

  @override
  String get createUser => 'Admin hinzufügen';

  @override
  String get editUser => 'Admin bearbeiten';

  @override
  String get notFound => 'Der aufgerufene Datensatz wurde nicht gefunden!';

  @override
  String get retrieveTokenFailed => 'Es konnte kein Token geladen werden!';

  @override
  String get invalidDeviceName => 'Bitte geben Sie eine Gerätebezeichnung an!';

  @override
  String get deviceName => 'Gerätebezeichnung';

  @override
  String lastTokenRefresh(String date) {
    return 'Letzte Aktivität: $date';
  }

  @override
  String get groups => 'Gruppen';

  @override
  String get groupName => 'Gruppenname';

  @override
  String get createGroup => 'Gruppe erstellen';

  @override
  String get editGroup => 'Gruppe bearbeiten';

  @override
  String get groupIsDefault => 'Standardgruppe';

  @override
  String get groupIsDefaultHint => 'Gruppe wird beim Erstellen neuer Geräte automatisch zugewiesen.';

  @override
  String get invalidGroupName => 'Bitte geben Sie einen Namen an!';

  @override
  String get invalidGroupIsDefault => 'Bitte legen Sie fest, ob die Gruppe eine Standardgruppe ist!';

  @override
  String get uploading => 'Dateien werden hochgeladen.';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get date => 'Datum';

  @override
  String get artist => 'Interpret';

  @override
  String get genre => 'Genre';

  @override
  String get album => 'Album';

  @override
  String toLargeFile(String fileName) {
    return 'Datei $fileName ist zu groß.';
  }

  @override
  String uploadingFileFailed(String fileName, String error) {
    return 'Beim Hochladen der Datei $fileName ist ein Fehler aufgetreten: $error';
  }

  @override
  String get invalidMp3File => 'Datei ist keine gültige MP3-Datei.';

  @override
  String get invalidFileNoContent => 'Datei hat keinen Inhalt.';

  @override
  String get uploadFolder => 'Ordner hochladen';

  @override
  String get uploadFiles => 'Dateien hochladen';

  @override
  String get actualConnectionSettings => 'Aktuelle Verbindungseinstellungen';

  @override
  String get editRecord => 'Aufnahme bearbeiten';

  @override
  String get title => 'Titel';

  @override
  String get invalidTitle => 'Ein Titel muss angegeben werden.';

  @override
  String get uploadFinished => 'Upload abgeschlossen.';

  @override
  String get notUploadedFiles => 'Folgende Dateien wurden nicht hochgeladen.';

  @override
  String get uploadSettings => 'Upload Einstellungen';

  @override
  String get compressionRate => 'Bitrate in kbit/s';

  @override
  String get compressionInfo => 'Kompression erfolgt beim nächsten Upload. Bei leerer Bitrate erfolgt keine Kompression.';

  @override
  String get invalidCompressionRate => 'Der Wert muss größer als Null sein.';

  @override
  String get version => 'Version';

  @override
  String get back => 'zurück';

  @override
  String get folder => 'Ordner';

  @override
  String get selectGroups => 'Wählen Sie die Gruppen für die Aufnahmen aus';

  @override
  String get language => 'Sprache';

  @override
  String get defaults => 'Standard';

  @override
  String get editBitrates => 'Bitraten verwalten';

  @override
  String get bitrates => 'Bitraten';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get info => 'Info';

  @override
  String get ok => 'Ok';

  @override
  String get livestreams => 'Livestreams';

  @override
  String get editLivestream => 'Livestream bearbeiten';

  @override
  String get createLivestream => 'Livestream erstellen';

  @override
  String get streamUrl => 'Url zum Livestream';

  @override
  String get streamUrlHint => 'Interne Url zum Streaming-Endpunkt: http://<adresse>:<port>';

  @override
  String get similarClients => 'Ähnliche Geräte';

  @override
  String get onlyNew => 'Neu';

  @override
  String get uploadValidation => 'MP3-Tag Validierung';

  @override
  String get uploadValidLanguage => 'Sprache ist gesetzt';

  @override
  String get uploadValidTitle => 'Titel ist gesetzt';

  @override
  String get uploadValidNumber => 'Tracknummer ist gesetzt';

  @override
  String get uploadValidCover => 'Cover ist gesetzt';

  @override
  String get uploadValidArtist => 'Interpret ist gesetzt';

  @override
  String get uploadValidAlbum => 'Album ist gesetzt';

  @override
  String get uploadValidGenre => 'Genre ist gesetzt';

  @override
  String get uploadValidAlbums => 'Gültige Alben';

  @override
  String get uploadValidAlbumInfo => 'Alben-Namen getrennt mit einem Komma. Wenn leer, dann keine Eingrenzung der Alben.';

  @override
  String get uploadValidGenres => 'Gültige Genres';

  @override
  String get uploadValidGenreInfo => 'Genre-Namen getrennt mit einem Komma. Wenn leer, dann keine Eingrenzung der Genres.';

  @override
  String get uploadValidFilename => 'Dateinamen Format';

  @override
  String get uploadValidFilenameInfo => 'Dateiname muss spezielles Format erfüllen. Regex. Standard keine Begrenzung.';

  @override
  String get uploadInvalidLanguage => 'Sprache ist nicht gesetzt oder unbekannt.';

  @override
  String get uploadInvalidAlbum => 'Album ist nicht gesetzt.';

  @override
  String get uploadInvalidAlbums => 'Album ist ungültig.';

  @override
  String get uploadInvalidGenre => 'Genre ist nicht gesetzt.';

  @override
  String get uploadInvalidGenres => 'Genre ist ungültig.';

  @override
  String get uploadInvalidArtist => 'Interpret ist nicht gesetzt.';

  @override
  String get uploadInvalidTitle => 'Titel ist nicht gesetzt.';

  @override
  String get uploadInvalidNumber => 'Tracknummer ist nicht gesetzt.';

  @override
  String get uploadInvalidCover => 'Cover ist nicht verfügbar.';

  @override
  String get uploadInvalidFilenameFormat => 'Dateiname entspricht nicht erwartetes Format.';

  @override
  String get uploadValidFailed => 'Beim Hochladen ist ein unerwarteter Fehler aufgetreten.';

  @override
  String get doNotValidate => 'Nicht überprüfen';

  @override
  String get validate => 'Überprüfen';

  @override
  String get required => 'Pflichtfeld';

  @override
  String get assignTo => 'Zuordnen';

  @override
  String get selectLoaded => 'Alle geladenen Elemente auswählen';

  @override
  String get makeUndeletable => 'Nicht löschbar';

  @override
  String get lock => 'Sperren';

  @override
  String get newUpdate => 'Neues Update';

  @override
  String get later => 'Später';

  @override
  String get checkUpdate => 'Neue Funktionen und Verbesserungen prüfen.';

  @override
  String get updateInstall => 'Aktualisieren';

  @override
  String get downloading => 'Herunterladen...';

  @override
  String newVersion(String latestVersion) {
    return 'Eine neue Version $latestVersion ist verfügbar.';
  }

  @override
  String oldVersion(String appVersion) {
    return 'Sie verwenden derzeit die Version $appVersion.';
  }
}
