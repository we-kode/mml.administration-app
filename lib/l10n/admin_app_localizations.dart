import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'admin_app_localizations_de.dart';
import 'admin_app_localizations_en.dart';
import 'admin_app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/admin_app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Meine Mediathek Administration'**
  String get appTitle;

  /// No description provided for @serverName.
  ///
  /// In de, this message translates to:
  /// **'Server (Domain:Port)'**
  String get serverName;

  /// No description provided for @serverNameUnchanged.
  ///
  /// In de, this message translates to:
  /// **'Server (Domain:Port) (unverändert)'**
  String get serverNameUnchanged;

  /// No description provided for @invalidServerName.
  ///
  /// In de, this message translates to:
  /// **'Eine korrekte Serveradresse muss angegeben werden!'**
  String get invalidServerName;

  /// No description provided for @login.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get login;

  /// No description provided for @username.
  ///
  /// In de, this message translates to:
  /// **'Benutzername'**
  String get username;

  /// No description provided for @password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get password;

  /// No description provided for @passwordUnchanged.
  ///
  /// In de, this message translates to:
  /// **'Passwort (unverändert)'**
  String get passwordUnchanged;

  /// No description provided for @clientId.
  ///
  /// In de, this message translates to:
  /// **'Client-ID'**
  String get clientId;

  /// No description provided for @clientIdUnchanged.
  ///
  /// In de, this message translates to:
  /// **'Client-ID (unverändert)'**
  String get clientIdUnchanged;

  /// No description provided for @appKey.
  ///
  /// In de, this message translates to:
  /// **'App-Schlüssel'**
  String get appKey;

  /// No description provided for @appKeyUnchanged.
  ///
  /// In de, this message translates to:
  /// **'App-Schlüssel (unverändert)'**
  String get appKeyUnchanged;

  /// No description provided for @invalidClientId.
  ///
  /// In de, this message translates to:
  /// **'Eine korrekte Client-ID muss angegeben werden!'**
  String get invalidClientId;

  /// No description provided for @invalidAppKey.
  ///
  /// In de, this message translates to:
  /// **'Ein korrekter App-Schlüssel muss angegeben werden!'**
  String get invalidAppKey;

  /// No description provided for @invalidUsername.
  ///
  /// In de, this message translates to:
  /// **'Bitte geben Sie Ihren Benutzernamen an!'**
  String get invalidUsername;

  /// No description provided for @invalidPassword.
  ///
  /// In de, this message translates to:
  /// **'Bitte geben Sie Ihr Passwort an!'**
  String get invalidPassword;

  /// No description provided for @badCertificate.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein Zertifikatsfehler aufgetreten!'**
  String get badCertificate;

  /// No description provided for @unexpectedError.
  ///
  /// In de, this message translates to:
  /// **'Es ist ein unerwarteter Fehler aufgetreten: {message}'**
  String unexpectedError(String message);

  /// No description provided for @forbidden.
  ///
  /// In de, this message translates to:
  /// **'Sie haben nicht die notwendigen Rechte, die Aktion auszuführen!'**
  String get forbidden;

  /// No description provided for @incorrectCredentials.
  ///
  /// In de, this message translates to:
  /// **'Anmeldung fehlgeschlagen!'**
  String get incorrectCredentials;

  /// No description provided for @records.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen'**
  String get records;

  /// No description provided for @adminUsers.
  ///
  /// In de, this message translates to:
  /// **'Admins'**
  String get adminUsers;

  /// No description provided for @devices.
  ///
  /// In de, this message translates to:
  /// **'Geräte'**
  String get devices;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get logout;

  /// No description provided for @relogin.
  ///
  /// In de, this message translates to:
  /// **'Sie wurden automatisch abgemeldet! Bitte melden Sie sich neu an!'**
  String get relogin;

  /// No description provided for @advanced.
  ///
  /// In de, this message translates to:
  /// **'Erweitert'**
  String get advanced;

  /// No description provided for @add.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get remove;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @filter.
  ///
  /// In de, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Anwenden'**
  String get save;

  /// No description provided for @confirmAccount.
  ///
  /// In de, this message translates to:
  /// **'Bitte aktualisieren Sie Ihr Passwort, um fortzufahren.'**
  String get confirmAccount;

  /// No description provided for @actualPassword.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort'**
  String get actualPassword;

  /// No description provided for @newPassword.
  ///
  /// In de, this message translates to:
  /// **'Neues Passwort'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort bestätigen'**
  String get confirmNewPassword;

  /// No description provided for @invalidConfirmPasswords.
  ///
  /// In de, this message translates to:
  /// **'Neues Passwort stimmt mit Überprüfung nicht überein.'**
  String get invalidConfirmPasswords;

  /// No description provided for @updatePasswordFailed.
  ///
  /// In de, this message translates to:
  /// **'Passwortaktualisierung fehlgeschlagen!'**
  String get updatePasswordFailed;

  /// No description provided for @actualUser.
  ///
  /// In de, this message translates to:
  /// **'Aktueller Benutzer'**
  String get actualUser;

  /// No description provided for @changePassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get changePassword;

  /// No description provided for @noData.
  ///
  /// In de, this message translates to:
  /// **'Keine Datensätze wurden gefunden!'**
  String get noData;

  /// No description provided for @reload.
  ///
  /// In de, this message translates to:
  /// **'Neu laden'**
  String get reload;

  /// No description provided for @editClient.
  ///
  /// In de, this message translates to:
  /// **'Gerät bearbeiten'**
  String get editClient;

  /// No description provided for @registerClient.
  ///
  /// In de, this message translates to:
  /// **'Gerät registrieren'**
  String get registerClient;

  /// No description provided for @displayName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get displayName;

  /// No description provided for @invalidDisplayName.
  ///
  /// In de, this message translates to:
  /// **'Bitte geben Sie einen Namen an!'**
  String get invalidDisplayName;

  /// No description provided for @deleteConfirmation.
  ///
  /// In de, this message translates to:
  /// **'Möchten Sie tatsächlich die gewählten Datensätze löschen?'**
  String get deleteConfirmation;

  /// No description provided for @yes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get yes;

  /// No description provided for @createUser.
  ///
  /// In de, this message translates to:
  /// **'Admin hinzufügen'**
  String get createUser;

  /// No description provided for @editUser.
  ///
  /// In de, this message translates to:
  /// **'Admin bearbeiten'**
  String get editUser;

  /// No description provided for @notFound.
  ///
  /// In de, this message translates to:
  /// **'Der aufgerufene Datensatz wurde nicht gefunden!'**
  String get notFound;

  /// No description provided for @retrieveTokenFailed.
  ///
  /// In de, this message translates to:
  /// **'Es konnte kein Token geladen werden!'**
  String get retrieveTokenFailed;

  /// No description provided for @invalidDeviceName.
  ///
  /// In de, this message translates to:
  /// **'Bitte geben Sie eine Gerätebezeichnung an!'**
  String get invalidDeviceName;

  /// No description provided for @deviceName.
  ///
  /// In de, this message translates to:
  /// **'Gerätebezeichnung'**
  String get deviceName;

  /// No description provided for @lastTokenRefresh.
  ///
  /// In de, this message translates to:
  /// **'Letzte Aktivität: {date}'**
  String lastTokenRefresh(String date);

  /// No description provided for @groups.
  ///
  /// In de, this message translates to:
  /// **'Gruppen'**
  String get groups;

  /// No description provided for @groupName.
  ///
  /// In de, this message translates to:
  /// **'Gruppenname'**
  String get groupName;

  /// No description provided for @createGroup.
  ///
  /// In de, this message translates to:
  /// **'Gruppe erstellen'**
  String get createGroup;

  /// No description provided for @editGroup.
  ///
  /// In de, this message translates to:
  /// **'Gruppe bearbeiten'**
  String get editGroup;

  /// No description provided for @groupIsDefault.
  ///
  /// In de, this message translates to:
  /// **'Standardgruppe'**
  String get groupIsDefault;

  /// No description provided for @groupIsDefaultHint.
  ///
  /// In de, this message translates to:
  /// **'Gruppe wird beim Erstellen neuer Geräte automatisch zugewiesen.'**
  String get groupIsDefaultHint;

  /// No description provided for @invalidGroupName.
  ///
  /// In de, this message translates to:
  /// **'Bitte geben Sie einen Namen an!'**
  String get invalidGroupName;

  /// No description provided for @invalidGroupIsDefault.
  ///
  /// In de, this message translates to:
  /// **'Bitte legen Sie fest, ob die Gruppe eine Standardgruppe ist!'**
  String get invalidGroupIsDefault;

  /// No description provided for @uploading.
  ///
  /// In de, this message translates to:
  /// **'Dateien werden hochgeladen.'**
  String get uploading;

  /// No description provided for @unknown.
  ///
  /// In de, this message translates to:
  /// **'Unbekannt'**
  String get unknown;

  /// No description provided for @date.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get date;

  /// No description provided for @artist.
  ///
  /// In de, this message translates to:
  /// **'Interpret'**
  String get artist;

  /// No description provided for @genre.
  ///
  /// In de, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @album.
  ///
  /// In de, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @toLargeFile.
  ///
  /// In de, this message translates to:
  /// **'Datei {fileName} ist zu groß.'**
  String toLargeFile(String fileName);

  /// No description provided for @uploadingFileFailed.
  ///
  /// In de, this message translates to:
  /// **'Beim Hochladen der Datei {fileName} ist ein Fehler aufgetreten: {error}'**
  String uploadingFileFailed(String fileName, String error);

  /// No description provided for @invalidMp3File.
  ///
  /// In de, this message translates to:
  /// **'Datei ist keine gültige MP3-Datei.'**
  String get invalidMp3File;

  /// No description provided for @invalidFileNoContent.
  ///
  /// In de, this message translates to:
  /// **'Datei hat keinen Inhalt.'**
  String get invalidFileNoContent;

  /// No description provided for @uploadFolder.
  ///
  /// In de, this message translates to:
  /// **'Ordner hochladen'**
  String get uploadFolder;

  /// No description provided for @uploadFiles.
  ///
  /// In de, this message translates to:
  /// **'Dateien hochladen'**
  String get uploadFiles;

  /// No description provided for @actualConnectionSettings.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Verbindungseinstellungen'**
  String get actualConnectionSettings;

  /// No description provided for @editRecord.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme bearbeiten'**
  String get editRecord;

  /// No description provided for @title.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get title;

  /// No description provided for @invalidTitle.
  ///
  /// In de, this message translates to:
  /// **'Ein Titel muss angegeben werden.'**
  String get invalidTitle;

  /// No description provided for @uploadFinished.
  ///
  /// In de, this message translates to:
  /// **'Upload abgeschlossen.'**
  String get uploadFinished;

  /// No description provided for @notUploadedFiles.
  ///
  /// In de, this message translates to:
  /// **'Folgende Dateien wurden nicht hochgeladen.'**
  String get notUploadedFiles;

  /// No description provided for @uploadSettings.
  ///
  /// In de, this message translates to:
  /// **'Upload Einstellungen'**
  String get uploadSettings;

  /// No description provided for @compressionRate.
  ///
  /// In de, this message translates to:
  /// **'Bitrate in kbit/s'**
  String get compressionRate;

  /// No description provided for @compressionInfo.
  ///
  /// In de, this message translates to:
  /// **'Kompression erfolgt beim nächsten Upload. Bei leerer Bitrate erfolgt keine Kompression.'**
  String get compressionInfo;

  /// No description provided for @invalidCompressionRate.
  ///
  /// In de, this message translates to:
  /// **'Der Wert muss größer als Null sein.'**
  String get invalidCompressionRate;

  /// No description provided for @version.
  ///
  /// In de, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @back.
  ///
  /// In de, this message translates to:
  /// **'zurück'**
  String get back;

  /// No description provided for @folder.
  ///
  /// In de, this message translates to:
  /// **'Ordner'**
  String get folder;

  /// No description provided for @selectGroups.
  ///
  /// In de, this message translates to:
  /// **'Wählen Sie die Gruppen für die Aufnahmen aus'**
  String get selectGroups;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @defaults.
  ///
  /// In de, this message translates to:
  /// **'Standard'**
  String get defaults;

  /// No description provided for @editBitrates.
  ///
  /// In de, this message translates to:
  /// **'Bitraten verwalten'**
  String get editBitrates;

  /// No description provided for @bitrates.
  ///
  /// In de, this message translates to:
  /// **'Bitraten'**
  String get bitrates;

  /// No description provided for @bitrate.
  ///
  /// In de, this message translates to:
  /// **'Bitrate'**
  String get bitrate;

  /// No description provided for @info.
  ///
  /// In de, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @ok.
  ///
  /// In de, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @livestreams.
  ///
  /// In de, this message translates to:
  /// **'Livestreams'**
  String get livestreams;

  /// No description provided for @editLivestream.
  ///
  /// In de, this message translates to:
  /// **'Livestream bearbeiten'**
  String get editLivestream;

  /// No description provided for @createLivestream.
  ///
  /// In de, this message translates to:
  /// **'Livestream erstellen'**
  String get createLivestream;

  /// No description provided for @streamUrl.
  ///
  /// In de, this message translates to:
  /// **'Url zum Livestream'**
  String get streamUrl;

  /// No description provided for @streamUrlHint.
  ///
  /// In de, this message translates to:
  /// **'Interne Url zum Streaming-Endpunkt: http://<adresse>:<port>'**
  String get streamUrlHint;

  /// No description provided for @similarClients.
  ///
  /// In de, this message translates to:
  /// **'Ähnliche Geräte'**
  String get similarClients;

  /// No description provided for @onlyNew.
  ///
  /// In de, this message translates to:
  /// **'Neu'**
  String get onlyNew;

  /// No description provided for @uploadValidation.
  ///
  /// In de, this message translates to:
  /// **'MP3-Tag Validierung'**
  String get uploadValidation;

  /// No description provided for @uploadValidLanguage.
  ///
  /// In de, this message translates to:
  /// **'Sprache ist gesetzt'**
  String get uploadValidLanguage;

  /// No description provided for @uploadValidTitle.
  ///
  /// In de, this message translates to:
  /// **'Titel ist gesetzt'**
  String get uploadValidTitle;

  /// No description provided for @uploadValidNumber.
  ///
  /// In de, this message translates to:
  /// **'Tracknummer ist gesetzt'**
  String get uploadValidNumber;

  /// No description provided for @uploadValidCover.
  ///
  /// In de, this message translates to:
  /// **'Cover ist gesetzt'**
  String get uploadValidCover;

  /// No description provided for @uploadValidArtist.
  ///
  /// In de, this message translates to:
  /// **'Interpret ist gesetzt'**
  String get uploadValidArtist;

  /// No description provided for @uploadValidAlbum.
  ///
  /// In de, this message translates to:
  /// **'Album ist gesetzt'**
  String get uploadValidAlbum;

  /// No description provided for @uploadValidGenre.
  ///
  /// In de, this message translates to:
  /// **'Genre ist gesetzt'**
  String get uploadValidGenre;

  /// No description provided for @uploadValidAlbums.
  ///
  /// In de, this message translates to:
  /// **'Gültige Alben'**
  String get uploadValidAlbums;

  /// No description provided for @uploadValidAlbumInfo.
  ///
  /// In de, this message translates to:
  /// **'Alben-Namen getrennt mit einem Komma. Wenn leer, dann keine Eingrenzung der Alben.'**
  String get uploadValidAlbumInfo;

  /// No description provided for @uploadValidGenres.
  ///
  /// In de, this message translates to:
  /// **'Gültige Genres'**
  String get uploadValidGenres;

  /// No description provided for @uploadValidGenreInfo.
  ///
  /// In de, this message translates to:
  /// **'Genre-Namen getrennt mit einem Komma. Wenn leer, dann keine Eingrenzung der Genres.'**
  String get uploadValidGenreInfo;

  /// No description provided for @uploadValidFilename.
  ///
  /// In de, this message translates to:
  /// **'Dateinamen Format'**
  String get uploadValidFilename;

  /// No description provided for @uploadValidFilenameInfo.
  ///
  /// In de, this message translates to:
  /// **'Dateiname muss spezielles Format erfüllen. Regex. Standard keine Begrenzung.'**
  String get uploadValidFilenameInfo;

  /// No description provided for @uploadInvalidLanguage.
  ///
  /// In de, this message translates to:
  /// **'Sprache ist nicht gesetzt oder unbekannt.'**
  String get uploadInvalidLanguage;

  /// No description provided for @uploadInvalidAlbum.
  ///
  /// In de, this message translates to:
  /// **'Album ist nicht gesetzt.'**
  String get uploadInvalidAlbum;

  /// No description provided for @uploadInvalidAlbums.
  ///
  /// In de, this message translates to:
  /// **'Album ist ungültig.'**
  String get uploadInvalidAlbums;

  /// No description provided for @uploadInvalidGenre.
  ///
  /// In de, this message translates to:
  /// **'Genre ist nicht gesetzt.'**
  String get uploadInvalidGenre;

  /// No description provided for @uploadInvalidGenres.
  ///
  /// In de, this message translates to:
  /// **'Genre ist ungültig.'**
  String get uploadInvalidGenres;

  /// No description provided for @uploadInvalidArtist.
  ///
  /// In de, this message translates to:
  /// **'Interpret ist nicht gesetzt.'**
  String get uploadInvalidArtist;

  /// No description provided for @uploadInvalidTitle.
  ///
  /// In de, this message translates to:
  /// **'Titel ist nicht gesetzt.'**
  String get uploadInvalidTitle;

  /// No description provided for @uploadInvalidNumber.
  ///
  /// In de, this message translates to:
  /// **'Tracknummer ist nicht gesetzt.'**
  String get uploadInvalidNumber;

  /// No description provided for @uploadInvalidCover.
  ///
  /// In de, this message translates to:
  /// **'Cover ist nicht verfügbar.'**
  String get uploadInvalidCover;

  /// No description provided for @uploadInvalidFilenameFormat.
  ///
  /// In de, this message translates to:
  /// **'Dateiname entspricht nicht erwartetes Format.'**
  String get uploadInvalidFilenameFormat;

  /// No description provided for @uploadValidFailed.
  ///
  /// In de, this message translates to:
  /// **'Beim Hochladen ist ein unerwarteter Fehler aufgetreten.'**
  String get uploadValidFailed;

  /// No description provided for @doNotValidate.
  ///
  /// In de, this message translates to:
  /// **'Nicht überprüfen'**
  String get doNotValidate;

  /// No description provided for @validate.
  ///
  /// In de, this message translates to:
  /// **'Überprüfen'**
  String get validate;

  /// No description provided for @required.
  ///
  /// In de, this message translates to:
  /// **'Pflichtfeld'**
  String get required;

  /// No description provided for @assignTo.
  ///
  /// In de, this message translates to:
  /// **'Zuordnen'**
  String get assignTo;

  /// No description provided for @selectLoaded.
  ///
  /// In de, this message translates to:
  /// **'Alle geladenen Elemente auswählen'**
  String get selectLoaded;

  /// No description provided for @makeUndeletable.
  ///
  /// In de, this message translates to:
  /// **'Nicht löschbar'**
  String get makeUndeletable;

  /// No description provided for @lock.
  ///
  /// In de, this message translates to:
  /// **'Sperren'**
  String get lock;

  /// No description provided for @newUpdate.
  ///
  /// In de, this message translates to:
  /// **'Neues Update'**
  String get newUpdate;

  /// No description provided for @later.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get later;

  /// No description provided for @checkUpdate.
  ///
  /// In de, this message translates to:
  /// **'Neue Funktionen und Verbesserungen prüfen.'**
  String get checkUpdate;

  /// No description provided for @updateInstall.
  ///
  /// In de, this message translates to:
  /// **'Aktualisieren'**
  String get updateInstall;

  /// No description provided for @downloading.
  ///
  /// In de, this message translates to:
  /// **'Herunterladen...'**
  String get downloading;

  /// No description provided for @newVersion.
  ///
  /// In de, this message translates to:
  /// **'Eine neue Version {latestVersion} ist verfügbar.'**
  String newVersion(String latestVersion);

  /// No description provided for @oldVersion.
  ///
  /// In de, this message translates to:
  /// **'Sie verwenden derzeit die Version {appVersion}.'**
  String oldVersion(String appVersion);

  /// No description provided for @inactive.
  ///
  /// In de, this message translates to:
  /// **'Inaktiv'**
  String get inactive;

  /// No description provided for @cacheSettings.
  ///
  /// In de, this message translates to:
  /// **'Speicherverwaltung'**
  String get cacheSettings;

  /// No description provided for @cacheRemove.
  ///
  /// In de, this message translates to:
  /// **'Cache löschen'**
  String get cacheRemove;

  /// No description provided for @cacheRemoveTime.
  ///
  /// In de, this message translates to:
  /// **'Löschen, nach'**
  String get cacheRemoveTime;

  /// No description provided for @cacheRangeWeek.
  ///
  /// In de, this message translates to:
  /// **'1 Woche'**
  String get cacheRangeWeek;

  /// No description provided for @cacheRangeMonth.
  ///
  /// In de, this message translates to:
  /// **'1 Monat'**
  String get cacheRangeMonth;

  /// No description provided for @cacheRangeYear.
  ///
  /// In de, this message translates to:
  /// **'1 Jahr'**
  String get cacheRangeYear;

  /// No description provided for @cacheRangeNever.
  ///
  /// In de, this message translates to:
  /// **'Nie'**
  String get cacheRangeNever;

  /// No description provided for @cacheCleared.
  ///
  /// In de, this message translates to:
  /// **'Cache wurde erfolgreich gelöscht.'**
  String get cacheCleared;

  /// No description provided for @cacheClearedFailed.
  ///
  /// In de, this message translates to:
  /// **'Cache konnte nicht gelöscht werden.'**
  String get cacheClearedFailed;

  /// No description provided for @instance.
  ///
  /// In de, this message translates to:
  /// **'Instanz'**
  String get instance;

  /// No description provided for @sync.
  ///
  /// In de, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @notOwned.
  ///
  /// In de, this message translates to:
  /// **'Eigenschaften können nur von dem Eigentümer \'{owner}\' bearbeitet werden.'**
  String notOwned(String owner);

  /// No description provided for @assignAndRemove.
  ///
  /// In de, this message translates to:
  /// **'Gruppen übernehmen und löschen.'**
  String get assignAndRemove;

  /// No description provided for @peers.
  ///
  /// In de, this message translates to:
  /// **'Instanzen'**
  String get peers;

  /// No description provided for @invitations.
  ///
  /// In de, this message translates to:
  /// **'Einladungen'**
  String get invitations;

  /// No description provided for @audit.
  ///
  /// In de, this message translates to:
  /// **'Protokoll'**
  String get audit;

  /// No description provided for @approve.
  ///
  /// In de, this message translates to:
  /// **'Annehmen'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In de, this message translates to:
  /// **'Ablehnen'**
  String get reject;

  /// No description provided for @close.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get close;

  /// No description provided for @copy.
  ///
  /// In de, this message translates to:
  /// **'Kopieren'**
  String get copy;

  /// No description provided for @unlink.
  ///
  /// In de, this message translates to:
  /// **'Registrierung aufheben'**
  String get unlink;

  /// No description provided for @synchronize.
  ///
  /// In de, this message translates to:
  /// **'Synchronisieren'**
  String get synchronize;

  /// No description provided for @unassigned.
  ///
  /// In de, this message translates to:
  /// **'Nicht zugeordnet'**
  String get unassigned;

  /// No description provided for @recordsOfInstance.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen von Instanz'**
  String get recordsOfInstance;

  /// No description provided for @peerStateRequested.
  ///
  /// In de, this message translates to:
  /// **'Angefragt'**
  String get peerStateRequested;

  /// No description provided for @peerStatePendingApproval.
  ///
  /// In de, this message translates to:
  /// **'Wartet auf Genehmigung'**
  String get peerStatePendingApproval;

  /// No description provided for @peerStateResponsePending.
  ///
  /// In de, this message translates to:
  /// **'Genehmigt, Rückantwort ausstehend'**
  String get peerStateResponsePending;

  /// No description provided for @peerStateLinked.
  ///
  /// In de, this message translates to:
  /// **'Verknüpft'**
  String get peerStateLinked;

  /// No description provided for @peerStateRejected.
  ///
  /// In de, this message translates to:
  /// **'Abgelehnt'**
  String get peerStateRejected;

  /// No description provided for @peerKeysUpdatedAt.
  ///
  /// In de, this message translates to:
  /// **'Schlüssel zuletzt aktualisiert: {date}'**
  String peerKeysUpdatedAt(String date);

  /// No description provided for @peerPendingApprovalInfo.
  ///
  /// In de, this message translates to:
  /// **'Die Instanz möchte Aufnahmen mit dieser Instanz synchronisieren. Nach dem Annehmen wird der Partner informiert und die Synchronisation gemäß den Regeln aktiviert. Beim Ablehnen wird die Anfrage gelöscht.'**
  String get peerPendingApprovalInfo;

  /// No description provided for @peerRequestedInfo.
  ///
  /// In de, this message translates to:
  /// **'Die Anfrage wurde gesendet und wartet auf die Genehmigung durch den Admin des Partners.'**
  String get peerRequestedInfo;

  /// No description provided for @peerUrl.
  ///
  /// In de, this message translates to:
  /// **'Adresse des Partners'**
  String get peerUrl;

  /// No description provided for @invitationCode.
  ///
  /// In de, this message translates to:
  /// **'Einladungscode'**
  String get invitationCode;

  /// No description provided for @requestRegistration.
  ///
  /// In de, this message translates to:
  /// **'Registrierung anfragen'**
  String get requestRegistration;

  /// No description provided for @requestRegistrationSend.
  ///
  /// In de, this message translates to:
  /// **'Anfragen'**
  String get requestRegistrationSend;

  /// No description provided for @requestRegistrationInfo.
  ///
  /// In de, this message translates to:
  /// **'Gib die HTTPS-Adresse des Partners und den Einladungscode ein, den der Admin des Partners erstellt hat.'**
  String get requestRegistrationInfo;

  /// No description provided for @invitationCreated.
  ///
  /// In de, this message translates to:
  /// **'Einladung erstellt'**
  String get invitationCreated;

  /// No description provided for @invitationInfo.
  ///
  /// In de, this message translates to:
  /// **'Gib Adresse und Code an den Admin des Partners weiter. Der Code kann einmalig bis {date} verwendet werden und wird danach nicht mehr angezeigt.'**
  String invitationInfo(String date);

  /// No description provided for @invitationExpiresAt.
  ///
  /// In de, this message translates to:
  /// **'Gültig bis {date}'**
  String invitationExpiresAt(String date);

  /// No description provided for @outgoingRules.
  ///
  /// In de, this message translates to:
  /// **'Ausgehende Regeln'**
  String get outgoingRules;

  /// No description provided for @incomingRules.
  ///
  /// In de, this message translates to:
  /// **'Eingehende Regeln'**
  String get incomingRules;

  /// No description provided for @outgoingRule.
  ///
  /// In de, this message translates to:
  /// **'Ausgehende Regel'**
  String get outgoingRule;

  /// No description provided for @incomingRule.
  ///
  /// In de, this message translates to:
  /// **'Eingehende Regel'**
  String get incomingRule;

  /// No description provided for @outgoingRulesInfo.
  ///
  /// In de, this message translates to:
  /// **'Eigene Aufnahmen, die zu einer Regel passen, werden an den Partner gesendet. Ohne Regel wird nichts gesendet. Regeln gelten nur für neue Aufnahmen oder bei manueller Synchronisation.'**
  String get outgoingRulesInfo;

  /// No description provided for @incomingRulesInfo.
  ///
  /// In de, this message translates to:
  /// **'Empfangene Aufnahmen werden den Gruppen der spezifischsten passenden Regel zugeordnet. Ohne passende Regel sind sie nicht zugeordnet.'**
  String get incomingRulesInfo;

  /// No description provided for @ruleInfo.
  ///
  /// In de, this message translates to:
  /// **'Mehrere Werte eines Kriteriums sind mit ODER verknüpft, die Kriterien mit UND. Empfangene Aufnahmen werden über den Namen ohne Groß- und Kleinschreibung zugeordnet.'**
  String get ruleInfo;

  /// No description provided for @ruleEmptyMatchesAll.
  ///
  /// In de, this message translates to:
  /// **'Leer passt zu allen.'**
  String get ruleEmptyMatchesAll;

  /// No description provided for @ruleMatchesAll.
  ///
  /// In de, this message translates to:
  /// **'Alle Aufnahmen'**
  String get ruleMatchesAll;

  /// No description provided for @ruleGroups.
  ///
  /// In de, this message translates to:
  /// **'Gruppen für empfangene Aufnahmen'**
  String get ruleGroups;

  /// No description provided for @unlinkTitle.
  ///
  /// In de, this message translates to:
  /// **'Registrierung von {instance} aufheben'**
  String unlinkTitle(String instance);

  /// No description provided for @unlinkInfo.
  ///
  /// In de, this message translates to:
  /// **'Die Synchronisation wird beendet und der Partner wird informiert. Bereits synchronisierte Aufnahmen bleiben erhalten, wenn du sie nicht löschst.'**
  String get unlinkInfo;

  /// No description provided for @unlinkDeleteRecords.
  ///
  /// In de, this message translates to:
  /// **'Synchronisierte Aufnahmen löschen'**
  String get unlinkDeleteRecords;

  /// No description provided for @unlinkDeleteRecordsInfo.
  ///
  /// In de, this message translates to:
  /// **'Alle von {instance} empfangenen Aufnahmen werden hier gelöscht, auch gesperrte. {instance} wird gebeten, die Aufnahmen dieser Instanz zu löschen.'**
  String unlinkDeleteRecordsInfo(String instance);

  /// No description provided for @unlinkKeepRecordsInfo.
  ///
  /// In de, this message translates to:
  /// **'Die von {instance} empfangenen Aufnahmen bleiben hier erhalten und können manuell gelöscht werden.'**
  String unlinkKeepRecordsInfo(String instance);

  /// No description provided for @unlinkLocally.
  ///
  /// In de, this message translates to:
  /// **'Nur lokal aufheben'**
  String get unlinkLocally;

  /// No description provided for @unlinkLocallyInfo.
  ///
  /// In de, this message translates to:
  /// **'{instance} konnte nicht informiert werden. Wenn du die Registrierung nur lokal aufhebst, behält {instance} die Registrierung, bis der Admin des Partners sie entfernt.'**
  String unlinkLocallyInfo(String instance);

  /// No description provided for @unlinkLocallyDeleteInfo.
  ///
  /// In de, this message translates to:
  /// **'{instance} konnte nicht informiert werden. Wenn du die Registrierung nur lokal aufhebst, werden die von {instance} empfangenen Aufnahmen hier gelöscht. Die Aufnahmen dieser Instanz bleiben bei {instance} erhalten.'**
  String unlinkLocallyDeleteInfo(String instance);

  /// No description provided for @registrationReceived.
  ///
  /// In de, this message translates to:
  /// **'Neue Registrierungsanfrage von {instance}.'**
  String registrationReceived(String instance);

  /// No description provided for @syncResult.
  ///
  /// In de, this message translates to:
  /// **'{queued} Übertragungen eingeplant, {skipped} Aufnahmen übersprungen.'**
  String syncResult(int queued, int skipped);

  /// No description provided for @federationDisabled.
  ///
  /// In de, this message translates to:
  /// **'Die Synchronisation ist auf dem Server nicht konfiguriert.'**
  String get federationDisabled;

  /// No description provided for @federationInvalidUrl.
  ///
  /// In de, this message translates to:
  /// **'Die Adresse muss eine gültige HTTPS-Adresse sein.'**
  String get federationInvalidUrl;

  /// No description provided for @federationRemoteUnreachable.
  ///
  /// In de, this message translates to:
  /// **'Der Partner ist nicht erreichbar.'**
  String get federationRemoteUnreachable;

  /// No description provided for @federationRemoteRejected.
  ///
  /// In de, this message translates to:
  /// **'Der Partner hat die Anfrage abgelehnt. Prüfe den Einladungscode.'**
  String get federationRemoteRejected;

  /// No description provided for @federationInvalidDiscovery.
  ///
  /// In de, this message translates to:
  /// **'Der Partner liefert ungültige Informationen.'**
  String get federationInvalidDiscovery;

  /// No description provided for @federationInstanceConflict.
  ///
  /// In de, this message translates to:
  /// **'Eine Instanz mit diesem Namen ist bereits registriert.'**
  String get federationInstanceConflict;

  /// No description provided for @federationInvalidState.
  ///
  /// In de, this message translates to:
  /// **'Die Aktion ist im aktuellen Zustand des Partners nicht möglich.'**
  String get federationInvalidState;

  /// No description provided for @federationInvalidInvitation.
  ///
  /// In de, this message translates to:
  /// **'Der Einladungscode ist ungültig.'**
  String get federationInvalidInvitation;

  /// No description provided for @auditRecords.
  ///
  /// In de, this message translates to:
  /// **'{count} Aufnahmen'**
  String auditRecords(int count);

  /// No description provided for @auditStatus.
  ///
  /// In de, this message translates to:
  /// **'Status'**
  String get auditStatus;

  /// No description provided for @auditSource.
  ///
  /// In de, this message translates to:
  /// **'Quelle'**
  String get auditSource;

  /// No description provided for @auditTarget.
  ///
  /// In de, this message translates to:
  /// **'Ziel'**
  String get auditTarget;

  /// No description provided for @auditTransaction.
  ///
  /// In de, this message translates to:
  /// **'Transaktion'**
  String get auditTransaction;

  /// No description provided for @auditMessage.
  ///
  /// In de, this message translates to:
  /// **'Meldung'**
  String get auditMessage;

  /// No description provided for @auditSuccess.
  ///
  /// In de, this message translates to:
  /// **'Erfolgreich'**
  String get auditSuccess;

  /// No description provided for @auditFailed.
  ///
  /// In de, this message translates to:
  /// **'Fehlgeschlagen'**
  String get auditFailed;

  /// No description provided for @auditSkipped.
  ///
  /// In de, this message translates to:
  /// **'Übersprungen'**
  String get auditSkipped;

  /// No description provided for @auditRegistrationRequested.
  ///
  /// In de, this message translates to:
  /// **'Registrierung angefragt'**
  String get auditRegistrationRequested;

  /// No description provided for @auditRegistrationReceived.
  ///
  /// In de, this message translates to:
  /// **'Registrierungsanfrage erhalten'**
  String get auditRegistrationReceived;

  /// No description provided for @auditRegistrationApproved.
  ///
  /// In de, this message translates to:
  /// **'Registrierung angenommen'**
  String get auditRegistrationApproved;

  /// No description provided for @auditRegistrationRejected.
  ///
  /// In de, this message translates to:
  /// **'Registrierung abgelehnt'**
  String get auditRegistrationRejected;

  /// No description provided for @auditUnlinked.
  ///
  /// In de, this message translates to:
  /// **'Registrierung aufgehoben'**
  String get auditUnlinked;

  /// No description provided for @auditKeysChanged.
  ///
  /// In de, this message translates to:
  /// **'Schlüssel geändert'**
  String get auditKeysChanged;

  /// No description provided for @auditRecordPushed.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme gesendet'**
  String get auditRecordPushed;

  /// No description provided for @auditRecordReceived.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme empfangen'**
  String get auditRecordReceived;

  /// No description provided for @auditRecordUpdated.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme aktualisiert'**
  String get auditRecordUpdated;

  /// No description provided for @auditRecordDeleted.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme gelöscht'**
  String get auditRecordDeleted;

  /// No description provided for @auditRecordsRemoved.
  ///
  /// In de, this message translates to:
  /// **'Aufnahmen entfernt'**
  String get auditRecordsRemoved;

  /// No description provided for @rejectTitle.
  ///
  /// In de, this message translates to:
  /// **'Anfrage von {instance} ablehnen'**
  String rejectTitle(String instance);

  /// No description provided for @rejectInfo.
  ///
  /// In de, this message translates to:
  /// **'{instance} wird über die Ablehnung informiert und die Anfrage wird gelöscht. Ist {instance} nicht erreichbar, wird die Anfrage trotzdem gelöscht. Für eine neue Anfrage braucht {instance} einen neuen Einladungscode.'**
  String rejectInfo(String instance);

  /// No description provided for @auditNewEntries.
  ///
  /// In de, this message translates to:
  /// **'Neue Einträge – neu laden'**
  String get auditNewEntries;

  /// No description provided for @auditRetention.
  ///
  /// In de, this message translates to:
  /// **'Protokoll aufbewahren'**
  String get auditRetention;

  /// No description provided for @auditRetentionInfo.
  ///
  /// In de, this message translates to:
  /// **'Ältere Einträge des Synchronisationsprotokolls werden automatisch gelöscht.'**
  String get auditRetentionInfo;

  /// No description provided for @retentionThreeMonths.
  ///
  /// In de, this message translates to:
  /// **'3 Monate'**
  String get retentionThreeMonths;

  /// No description provided for @retentionSixMonths.
  ///
  /// In de, this message translates to:
  /// **'6 Monate'**
  String get retentionSixMonths;

  /// No description provided for @invitationAddress.
  ///
  /// In de, this message translates to:
  /// **'Adresse dieser Instanz'**
  String get invitationAddress;

  /// No description provided for @rules.
  ///
  /// In de, this message translates to:
  /// **'Regeln'**
  String get rules;

  /// No description provided for @ruleAllInstances.
  ///
  /// In de, this message translates to:
  /// **'Alle Instanzen'**
  String get ruleAllInstances;

  /// No description provided for @ruleEmptyAllInstances.
  ///
  /// In de, this message translates to:
  /// **'Leer gilt für alle Instanzen, auch für später verknüpfte.'**
  String get ruleEmptyAllInstances;

  /// No description provided for @peerNoRules.
  ///
  /// In de, this message translates to:
  /// **'Keine Regel gilt für diese Instanz.'**
  String get peerNoRules;

  /// No description provided for @peerRulesInfo.
  ///
  /// In de, this message translates to:
  /// **'Regeln werden unter Sync → Regeln verwaltet. Auf die Instanz eingegrenzte Regeln haben Vorrang vor Regeln für alle Instanzen.'**
  String get peerRulesInfo;

  /// No description provided for @approveTitle.
  ///
  /// In de, this message translates to:
  /// **'Anfrage von {instance} annehmen'**
  String approveTitle(String instance);

  /// No description provided for @approveInfo.
  ///
  /// In de, this message translates to:
  /// **'{instance} wird informiert und die Synchronisation aktiviert. Ab dann gelten {count} ausgehende Regeln für {instance}: neue eigene Aufnahmen, die dazu passen, werden an {instance} gesendet.'**
  String approveInfo(String instance, int count);

  /// No description provided for @ruleSourceGroups.
  ///
  /// In de, this message translates to:
  /// **'Gruppen der Aufnahmen, die gesendet werden'**
  String get ruleSourceGroups;

  /// No description provided for @receivedFrom.
  ///
  /// In de, this message translates to:
  /// **'Empfangen von {owner}'**
  String receivedFrom(String owner);

  /// No description provided for @syncState.
  ///
  /// In de, this message translates to:
  /// **'Synchronisation'**
  String get syncState;

  /// No description provided for @syncStateReceived.
  ///
  /// In de, this message translates to:
  /// **'Empfangen'**
  String get syncStateReceived;

  /// No description provided for @syncStateSent.
  ///
  /// In de, this message translates to:
  /// **'Gesendet'**
  String get syncStateSent;

  /// No description provided for @syncStateProblem.
  ///
  /// In de, this message translates to:
  /// **'Problem'**
  String get syncStateProblem;

  /// No description provided for @syncStateNone.
  ///
  /// In de, this message translates to:
  /// **'Nicht synchronisiert'**
  String get syncStateNone;

  /// No description provided for @syncProblemWith.
  ///
  /// In de, this message translates to:
  /// **'Synchronisation mit {instance} fehlgeschlagen'**
  String syncProblemWith(String instance);

  /// No description provided for @syncProblemFailed.
  ///
  /// In de, this message translates to:
  /// **'Endgültig fehlgeschlagen. Mit „Synchronisieren“ neu versuchen.'**
  String get syncProblemFailed;

  /// No description provided for @syncProblemRetry.
  ///
  /// In de, this message translates to:
  /// **'Nächster Versuch: {date}'**
  String syncProblemRetry(String date);

  /// No description provided for @syncSentCount.
  ///
  /// In de, this message translates to:
  /// **'An {count} Instanzen gesendet'**
  String syncSentCount(int count);

  /// No description provided for @syncProblemCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Probleme'**
  String syncProblemCount(int count);

  /// No description provided for @auditResult.
  ///
  /// In de, this message translates to:
  /// **'Ergebnis'**
  String get auditResult;

  /// No description provided for @auditDirection.
  ///
  /// In de, this message translates to:
  /// **'Richtung'**
  String get auditDirection;

  /// No description provided for @auditAction.
  ///
  /// In de, this message translates to:
  /// **'Aktion'**
  String get auditAction;

  /// No description provided for @auditIncoming.
  ///
  /// In de, this message translates to:
  /// **'Eingehend'**
  String get auditIncoming;

  /// No description provided for @auditOutgoing.
  ///
  /// In de, this message translates to:
  /// **'Ausgehend'**
  String get auditOutgoing;

  /// No description provided for @auditFilterReset.
  ///
  /// In de, this message translates to:
  /// **'Filter zurücksetzen'**
  String get auditFilterReset;

  /// No description provided for @auditSelectionClear.
  ///
  /// In de, this message translates to:
  /// **'Auswahl aufheben'**
  String get auditSelectionClear;

  /// No description provided for @auditDeleteSelected.
  ///
  /// In de, this message translates to:
  /// **'Ausgewählte löschen'**
  String get auditDeleteSelected;

  /// No description provided for @auditDeleteCount.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Eintrag wird gelöscht.} other{{count} Einträge werden gelöscht.}} Fortfahren?'**
  String auditDeleteCount(int count);

  /// No description provided for @auditFilterRemove.
  ///
  /// In de, this message translates to:
  /// **'Filter entfernen'**
  String get auditFilterRemove;

  /// No description provided for @invitationNew.
  ///
  /// In de, this message translates to:
  /// **'Neue Einladung'**
  String get invitationNew;

  /// No description provided for @invitationNewInfo.
  ///
  /// In de, this message translates to:
  /// **'Es wird ein Einladungscode erstellt, mit dem sich eine Partner-Instanz einmalig registrieren kann.'**
  String get invitationNewInfo;

  /// No description provided for @create.
  ///
  /// In de, this message translates to:
  /// **'Erstellen'**
  String get create;

  /// No description provided for @auditRecordRemoved.
  ///
  /// In de, this message translates to:
  /// **'Aufnahme nicht mehr vorhanden'**
  String get auditRecordRemoved;

  /// No description provided for @auditPending.
  ///
  /// In de, this message translates to:
  /// **'Ausstehend'**
  String get auditPending;

  /// No description provided for @invitationValidity.
  ///
  /// In de, this message translates to:
  /// **'Gültigkeit'**
  String get invitationValidity;

  /// No description provided for @durationHours.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Stunde} other{{count} Stunden}}'**
  String durationHours(int count);

  /// No description provided for @durationDays.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Tag} other{{count} Tage}}'**
  String durationDays(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
