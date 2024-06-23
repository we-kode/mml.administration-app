import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'admin_app_localizations_de.dart';
import 'admin_app_localizations_en.dart';
import 'admin_app_localizations_ru.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('ru')
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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
