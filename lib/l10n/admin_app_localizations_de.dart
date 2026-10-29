// ignore: unused_import
import 'package:intl/intl.dart' as intl;
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
  String get invalidServerName =>
      'Eine korrekte Serveradresse muss angegeben werden!';

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
  String get invalidClientId =>
      'Eine korrekte Client-ID muss angegeben werden!';

  @override
  String get invalidAppKey =>
      'Ein korrekter App-Schlüssel muss angegeben werden!';

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
  String get forbidden =>
      'Sie haben nicht die notwendigen Rechte, die Aktion auszuführen!';

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
  String get relogin =>
      'Sie wurden automatisch abgemeldet! Bitte melden Sie sich neu an!';

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
  String get confirmAccount =>
      'Bitte aktualisieren Sie Ihr Passwort, um fortzufahren.';

  @override
  String get actualPassword => 'Aktuelles Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Passwort bestätigen';

  @override
  String get invalidConfirmPasswords =>
      'Neues Passwort stimmt mit Überprüfung nicht überein.';

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
  String get deleteConfirmation =>
      'Möchten Sie tatsächlich die gewählten Datensätze löschen?';

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
  String get groupIsDefaultHint =>
      'Gruppe wird beim Erstellen neuer Geräte automatisch zugewiesen.';

  @override
  String get invalidGroupName => 'Bitte geben Sie einen Namen an!';

  @override
  String get invalidGroupIsDefault =>
      'Bitte legen Sie fest, ob die Gruppe eine Standardgruppe ist!';

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
  String get compressionInfo =>
      'Kompression erfolgt beim nächsten Upload. Bei leerer Bitrate erfolgt keine Kompression.';

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
  String get streamUrlHint =>
      'Interne Url zum Streaming-Endpunkt: http://<adresse>:<port>';

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
  String get uploadValidAlbumInfo =>
      'Alben-Namen getrennt mit einem Komma. Wenn leer, dann keine Eingrenzung der Alben.';

  @override
  String get uploadValidGenres => 'Gültige Genres';

  @override
  String get uploadValidGenreInfo =>
      'Genre-Namen getrennt mit einem Komma. Wenn leer, dann keine Eingrenzung der Genres.';

  @override
  String get uploadValidFilename => 'Dateinamen Format';

  @override
  String get uploadValidFilenameInfo =>
      'Dateiname muss spezielles Format erfüllen. Regex. Standard keine Begrenzung.';

  @override
  String get uploadInvalidLanguage =>
      'Sprache ist nicht gesetzt oder unbekannt.';

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
  String get uploadInvalidFilenameFormat =>
      'Dateiname entspricht nicht erwartetes Format.';

  @override
  String get uploadValidFailed =>
      'Beim Hochladen ist ein unerwarteter Fehler aufgetreten.';

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

  @override
  String get inactive => 'Inaktiv';

  @override
  String get cacheSettings => 'Speicherverwaltung';

  @override
  String get cacheRemove => 'Cache löschen';

  @override
  String get cacheRemoveTime => 'Löschen, nach';

  @override
  String get cacheRangeWeek => '1 Woche';

  @override
  String get cacheRangeMonth => '1 Monat';

  @override
  String get cacheRangeYear => '1 Jahr';

  @override
  String get cacheRangeNever => 'Nie';

  @override
  String get cacheCleared => 'Cache wurde erfolgreich gelöscht.';

  @override
  String get cacheClearedFailed => 'Cache konnte nicht gelöscht werden.';

  @override
  String get instance => 'Instanz';

  @override
  String get sync => 'Sync';

  @override
  String notOwned(String owner) {
    return 'Eigenschaften können nur von dem Eigentümer \'$owner\' bearbeitet werden.';
  }

  @override
  String get assignAndRemove => 'Gruppen übernehmen und löschen.';

  @override
  String get peers => 'Instanzen';

  @override
  String get invitations => 'Einladungen';

  @override
  String get audit => 'Protokoll';

  @override
  String get approve => 'Annehmen';

  @override
  String get reject => 'Ablehnen';

  @override
  String get close => 'Schließen';

  @override
  String get copy => 'Kopieren';

  @override
  String get unlink => 'Registrierung aufheben';

  @override
  String get synchronize => 'Synchronisieren';

  @override
  String get unassigned => 'Nicht zugeordnet';

  @override
  String get recordsOfInstance => 'Aufnahmen von Instanz';

  @override
  String get peerStateRequested => 'Angefragt';

  @override
  String get peerStatePendingApproval => 'Wartet auf Genehmigung';

  @override
  String get peerStateResponsePending => 'Genehmigt, Rückantwort ausstehend';

  @override
  String get peerStateLinked => 'Verknüpft';

  @override
  String get peerStateRejected => 'Abgelehnt';

  @override
  String peerKeysUpdatedAt(String date) {
    return 'Schlüssel zuletzt aktualisiert: $date';
  }

  @override
  String get peerPendingApprovalInfo =>
      'Die Instanz möchte Aufnahmen mit dieser Instanz synchronisieren. Nach dem Annehmen wird der Partner informiert und die Synchronisation gemäß den Regeln aktiviert. Beim Ablehnen wird die Anfrage gelöscht.';

  @override
  String get peerRequestedInfo =>
      'Die Anfrage wurde gesendet und wartet auf die Genehmigung durch den Admin des Partners.';

  @override
  String get peerUrl => 'Adresse des Partners';

  @override
  String get invitationCode => 'Einladungscode';

  @override
  String get requestRegistration => 'Registrierung anfragen';

  @override
  String get requestRegistrationSend => 'Anfragen';

  @override
  String get requestRegistrationInfo =>
      'Gib die HTTPS-Adresse des Partners und den Einladungscode ein, den der Admin des Partners erstellt hat.';

  @override
  String get invitationCreated => 'Einladung erstellt';

  @override
  String invitationInfo(String date) {
    return 'Gib Adresse und Code an den Admin des Partners weiter. Der Code kann einmalig bis $date verwendet werden und wird danach nicht mehr angezeigt.';
  }

  @override
  String invitationExpiresAt(String date) {
    return 'Gültig bis $date';
  }

  @override
  String get outgoingRules => 'Ausgehende Regeln';

  @override
  String get incomingRules => 'Eingehende Regeln';

  @override
  String get outgoingRule => 'Ausgehende Regel';

  @override
  String get incomingRule => 'Eingehende Regel';

  @override
  String get outgoingRulesInfo =>
      'Eigene Aufnahmen, die zu einer Regel passen, werden an den Partner gesendet. Ohne Regel wird nichts gesendet. Regeln gelten nur für neue Aufnahmen oder bei manueller Synchronisation.';

  @override
  String get incomingRulesInfo =>
      'Empfangene Aufnahmen werden den Gruppen der spezifischsten passenden Regel zugeordnet. Ohne passende Regel sind sie nicht zugeordnet.';

  @override
  String get ruleInfo =>
      'Mehrere Werte eines Kriteriums sind mit ODER verknüpft, die Kriterien mit UND. Empfangene Aufnahmen werden über den Namen ohne Groß- und Kleinschreibung zugeordnet.';

  @override
  String get ruleEmptyMatchesAll => 'Leer passt zu allen.';

  @override
  String get ruleMatchesAll => 'Alle Aufnahmen';

  @override
  String get ruleGroups => 'Gruppen für empfangene Aufnahmen';

  @override
  String unlinkTitle(String instance) {
    return 'Registrierung von $instance aufheben';
  }

  @override
  String get unlinkInfo =>
      'Die Synchronisation wird beendet und der Partner wird informiert. Bereits synchronisierte Aufnahmen bleiben erhalten, wenn du sie nicht löschst.';

  @override
  String get unlinkDeleteRecords => 'Synchronisierte Aufnahmen löschen';

  @override
  String unlinkDeleteRecordsInfo(String instance) {
    return 'Alle von $instance empfangenen Aufnahmen werden hier gelöscht, auch gesperrte. $instance wird gebeten, die Aufnahmen dieser Instanz zu löschen.';
  }

  @override
  String unlinkKeepRecordsInfo(String instance) {
    return 'Die von $instance empfangenen Aufnahmen bleiben hier erhalten und können manuell gelöscht werden.';
  }

  @override
  String get unlinkLocally => 'Nur lokal aufheben';

  @override
  String unlinkLocallyInfo(String instance) {
    return '$instance konnte nicht informiert werden. Wenn du die Registrierung nur lokal aufhebst, behält $instance die Registrierung, bis der Admin des Partners sie entfernt.';
  }

  @override
  String unlinkLocallyDeleteInfo(String instance) {
    return '$instance konnte nicht informiert werden. Wenn du die Registrierung nur lokal aufhebst, werden die von $instance empfangenen Aufnahmen hier gelöscht. Die Aufnahmen dieser Instanz bleiben bei $instance erhalten.';
  }

  @override
  String registrationReceived(String instance) {
    return 'Neue Registrierungsanfrage von $instance.';
  }

  @override
  String syncResult(int queued, int skipped) {
    return '$queued Übertragungen eingeplant, $skipped Aufnahmen übersprungen.';
  }

  @override
  String get federationDisabled =>
      'Die Synchronisation ist auf dem Server nicht konfiguriert.';

  @override
  String get federationInvalidUrl =>
      'Die Adresse muss eine gültige HTTPS-Adresse sein.';

  @override
  String get federationRemoteUnreachable => 'Der Partner ist nicht erreichbar.';

  @override
  String get federationRemoteRejected =>
      'Der Partner hat die Anfrage abgelehnt. Prüfe den Einladungscode.';

  @override
  String get federationInvalidDiscovery =>
      'Der Partner liefert ungültige Informationen.';

  @override
  String get federationInstanceConflict =>
      'Eine Instanz mit diesem Namen ist bereits registriert.';

  @override
  String get federationInvalidState =>
      'Die Aktion ist im aktuellen Zustand des Partners nicht möglich.';

  @override
  String get federationInvalidInvitation => 'Der Einladungscode ist ungültig.';

  @override
  String auditRecords(int count) {
    return '$count Aufnahmen';
  }

  @override
  String get auditStatus => 'Status';

  @override
  String get auditSource => 'Quelle';

  @override
  String get auditTarget => 'Ziel';

  @override
  String get auditTransaction => 'Transaktion';

  @override
  String get auditMessage => 'Meldung';

  @override
  String get auditSuccess => 'Erfolgreich';

  @override
  String get auditFailed => 'Fehlgeschlagen';

  @override
  String get auditSkipped => 'Übersprungen';

  @override
  String get auditRegistrationRequested => 'Registrierung angefragt';

  @override
  String get auditRegistrationReceived => 'Registrierungsanfrage erhalten';

  @override
  String get auditRegistrationApproved => 'Registrierung angenommen';

  @override
  String get auditRegistrationRejected => 'Registrierung abgelehnt';

  @override
  String get auditUnlinked => 'Registrierung aufgehoben';

  @override
  String get auditKeysChanged => 'Schlüssel geändert';

  @override
  String get auditRecordPushed => 'Aufnahme gesendet';

  @override
  String get auditRecordReceived => 'Aufnahme empfangen';

  @override
  String get auditRecordUpdated => 'Aufnahme aktualisiert';

  @override
  String get auditRecordDeleted => 'Aufnahme gelöscht';

  @override
  String get auditRecordsRemoved => 'Aufnahmen entfernt';

  @override
  String rejectTitle(String instance) {
    return 'Anfrage von $instance ablehnen';
  }

  @override
  String rejectInfo(String instance) {
    return '$instance wird über die Ablehnung informiert und die Anfrage wird gelöscht. Ist $instance nicht erreichbar, wird die Anfrage trotzdem gelöscht. Für eine neue Anfrage braucht $instance einen neuen Einladungscode.';
  }

  @override
  String get auditNewEntries => 'Neue Einträge – neu laden';

  @override
  String get auditRetention => 'Protokoll aufbewahren';

  @override
  String get auditRetentionInfo =>
      'Ältere Einträge des Synchronisationsprotokolls werden automatisch gelöscht.';

  @override
  String get retentionThreeMonths => '3 Monate';

  @override
  String get retentionSixMonths => '6 Monate';

  @override
  String get invitationAddress => 'Adresse dieser Instanz';

  @override
  String get rules => 'Regeln';

  @override
  String get ruleAllInstances => 'Alle Instanzen';

  @override
  String get ruleEmptyAllInstances =>
      'Leer gilt für alle Instanzen, auch für später verknüpfte.';

  @override
  String get peerNoRules => 'Keine Regel gilt für diese Instanz.';

  @override
  String get peerRulesInfo =>
      'Regeln werden unter Sync → Regeln verwaltet. Auf die Instanz eingegrenzte Regeln haben Vorrang vor Regeln für alle Instanzen.';

  @override
  String approveTitle(String instance) {
    return 'Anfrage von $instance annehmen';
  }

  @override
  String approveInfo(String instance, int count) {
    return '$instance wird informiert und die Synchronisation aktiviert. Ab dann gelten $count ausgehende Regeln für $instance: neue eigene Aufnahmen, die dazu passen, werden an $instance gesendet.';
  }

  @override
  String get ruleSourceGroups => 'Gruppen der Aufnahmen, die gesendet werden';

  @override
  String receivedFrom(String owner) {
    return 'Empfangen von $owner';
  }

  @override
  String get syncState => 'Synchronisation';

  @override
  String get syncStateReceived => 'Empfangen';

  @override
  String get syncStateSent => 'Gesendet';

  @override
  String get syncStateProblem => 'Problem';

  @override
  String get syncStateNone => 'Nicht synchronisiert';

  @override
  String syncProblemWith(String instance) {
    return 'Synchronisation mit $instance fehlgeschlagen';
  }

  @override
  String get syncProblemFailed =>
      'Endgültig fehlgeschlagen. Mit „Synchronisieren“ neu versuchen.';

  @override
  String syncProblemRetry(String date) {
    return 'Nächster Versuch: $date';
  }

  @override
  String syncSentCount(int count) {
    return 'An $count Instanzen gesendet';
  }

  @override
  String syncProblemCount(int count) {
    return '$count Probleme';
  }

  @override
  String get auditResult => 'Ergebnis';

  @override
  String get auditDirection => 'Richtung';

  @override
  String get auditAction => 'Aktion';

  @override
  String get auditIncoming => 'Eingehend';

  @override
  String get auditOutgoing => 'Ausgehend';

  @override
  String get auditFilterReset => 'Filter zurücksetzen';

  @override
  String get auditSelectionClear => 'Auswahl aufheben';

  @override
  String get auditDeleteSelected => 'Ausgewählte löschen';

  @override
  String auditDeleteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge werden gelöscht.',
      one: '1 Eintrag wird gelöscht.',
    );
    return '$_temp0 Fortfahren?';
  }

  @override
  String get auditFilterRemove => 'Filter entfernen';

  @override
  String get invitationNew => 'Neue Einladung';

  @override
  String get invitationNewInfo =>
      'Es wird ein Einladungscode erstellt, mit dem sich eine Partner-Instanz einmalig registrieren kann.';

  @override
  String get create => 'Erstellen';

  @override
  String get auditRecordRemoved => 'Aufnahme nicht mehr vorhanden';

  @override
  String get auditPending => 'Ausstehend';

  @override
  String get invitationValidity => 'Gültigkeit';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get syncStatePending => 'Wird gesendet';

  @override
  String get auditRecordRevoked => 'Synchronisation aufgehoben';

  @override
  String get auditAddressChanged => 'Adresse geändert';

  @override
  String get federationInvalidPeer =>
      'Eine ausgewählte Instanz ist nicht verknüpft.';

  @override
  String get federationUnknownKeys =>
      'Die Instanz unter der neuen Adresse kann nicht nachweisen, dass sie einen bekannten Schlüssel besitzt. Wurden auch die Schlüssel ersetzt, muss die Verknüpfung aufgehoben und neu angefragt werden.';

  @override
  String get revokeSync => 'Synchronisation aufheben';

  @override
  String get revokeSyncInfo =>
      'Die Aufnahmen werden bei den ausgewählten Instanzen entfernt und bleiben hier erhalten. Sie werden dorthin nicht mehr automatisch oder über Ordner gesendet, bis sie einzeln wieder synchronisiert werden.';

  @override
  String revokeResult(int count) {
    return '$count Entfernungen bei Partnern eingeplant.';
  }

  @override
  String transferPercent(int percent) {
    return '$percent %';
  }

  @override
  String transferWaiting(String date) {
    return 'Wartet bis $date';
  }

  @override
  String get allInstances => 'Alle Instanzen';

  @override
  String get changeAddress => 'Adresse ändern';

  @override
  String changeAddressTitle(String instance) {
    return 'Adresse von $instance ändern';
  }

  @override
  String changeAddressInfo(String instance) {
    return 'Unter der neuen Adresse muss $instance mit demselben Namen erreichbar sein und mit einem bekannten Schlüssel signieren. Offene Übertragungen werden danach sofort wiederholt.';
  }

  @override
  String addressChanged(String instance, String url) {
    return '$instance ist jetzt unter $url erreichbar.';
  }

  @override
  String syncRevokedAt(String date) {
    return 'Synchronisation aufgehoben am $date';
  }

  @override
  String syncPendingCount(int count) {
    return '$count Übertragungen offen';
  }

  @override
  String syncRevokedCount(int count) {
    return 'Bei $count Instanzen aufgehoben';
  }
}
