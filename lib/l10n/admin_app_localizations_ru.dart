// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'admin_app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Администрация Моя Медиатека';

  @override
  String get serverName => 'Сервер (домен:порт)';

  @override
  String get serverNameUnchanged => 'Сервер (домен:порт) (прежний)';

  @override
  String get invalidServerName => 'Адрес сервера неправильный!';

  @override
  String get login => 'Войти';

  @override
  String get username => 'Логин';

  @override
  String get password => 'Пароль';

  @override
  String get passwordUnchanged => 'Пароль (прежний)';

  @override
  String get clientId => 'Идентификатор клиента';

  @override
  String get clientIdUnchanged => 'Идентификатор клиента (прежний)';

  @override
  String get appKey => 'Ключ приложения';

  @override
  String get appKeyUnchanged => 'Ключ приложения (прежний)';

  @override
  String get invalidClientId => 'Идентификатор клиента неправильный!';

  @override
  String get invalidAppKey => 'Ключ приложения неправильный!';

  @override
  String get invalidUsername => 'Пожалуйста введите логин!';

  @override
  String get invalidPassword => 'Пожалуйста введите пароль!';

  @override
  String get badCertificate => 'Произошла ошибка с сертификатом!';

  @override
  String unexpectedError(String message) {
    return 'Произошла непредвиденная ошибка: $message';
  }

  @override
  String get forbidden =>
      'У вас нет необходимых прав, чтобы выполнить это действие!';

  @override
  String get incorrectCredentials => 'Не удалось войти в систему!';

  @override
  String get records => 'Записи';

  @override
  String get adminUsers => 'Админы';

  @override
  String get devices => 'Устройства';

  @override
  String get settings => 'Настройки';

  @override
  String get logout => 'Выйти';

  @override
  String get relogin =>
      'Срок действия вашего логина истёк! Пожалуйста, войдите в систему ещё раз!';

  @override
  String get advanced => 'Дополнительные настройки';

  @override
  String get add => 'Добавить';

  @override
  String get remove => 'Удалить';

  @override
  String get cancel => 'Отменить';

  @override
  String get filter => 'Фильтр';

  @override
  String get save => 'Применить';

  @override
  String get confirmAccount =>
      'Пожалуйста, обновите свой пароль, чтобы продолжить.';

  @override
  String get actualPassword => 'Текущий пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmNewPassword => 'Подтвердить пароль';

  @override
  String get invalidConfirmPasswords =>
      'Новый пароль не соответствует проверке.';

  @override
  String get updatePasswordFailed => 'Не удалось обновить пароль!';

  @override
  String get actualUser => 'Текущий пользователь';

  @override
  String get changePassword => 'Сменить пароль';

  @override
  String get noData => 'Никаких записей найдено не было!';

  @override
  String get reload => 'Перезагрузить';

  @override
  String get editClient => 'Переименовать устройства';

  @override
  String get registerClient => 'Зарегистрировать устройство';

  @override
  String get displayName => 'Имя';

  @override
  String get invalidDisplayName => 'Пожалуйста введите имя!';

  @override
  String get deleteConfirmation =>
      'Вы действительно хотите удалить выбранные записи?';

  @override
  String get yes => 'Да';

  @override
  String get createUser => 'Добавить администратора';

  @override
  String get editUser => 'Изменить администратора';

  @override
  String get notFound => 'Запрошенная запись не найдена!';

  @override
  String get retrieveTokenFailed => 'Не удалось загрузить токен!';

  @override
  String get invalidDeviceName => 'Пожалуйста, введите название устройства!';

  @override
  String get deviceName => 'Название устройства';

  @override
  String lastTokenRefresh(String date) {
    return 'Последняя активность: $date';
  }

  @override
  String get groups => 'Группы';

  @override
  String get groupName => 'Название группы';

  @override
  String get createGroup => 'Добавить группу';

  @override
  String get editGroup => 'Изменить группу';

  @override
  String get groupIsDefault => 'Стандартная группа';

  @override
  String get groupIsDefaultHint =>
      'Группа будет назначена по умолчанию при создании клиента.';

  @override
  String get invalidGroupName => 'Пожалуйста, введите название группы!';

  @override
  String get invalidGroupIsDefault =>
      'Пожалуйста, укажите, является ли группа стандартной или нет!';

  @override
  String get uploading => 'Загрузка файлов.';

  @override
  String get unknown => 'Неизвестный';

  @override
  String get date => 'Дата';

  @override
  String get artist => 'Исполнитель';

  @override
  String get genre => 'Жанр';

  @override
  String get album => 'Альбом';

  @override
  String toLargeFile(String fileName) {
    return 'Файл $fileName слишком большой.';
  }

  @override
  String uploadingFileFailed(String fileName, String error) {
    return 'Произошла ошибка при загрузке файла $fileName: $error';
  }

  @override
  String get invalidMp3File => 'Файл не является допустимым файлом MP3.';

  @override
  String get invalidFileNoContent => 'В файле нет содержимого.';

  @override
  String get uploadFolder => 'Загрузить папку';

  @override
  String get uploadFiles => 'Загрузить файлы';

  @override
  String get actualConnectionSettings => 'Текущие настройки подключения';

  @override
  String get editRecord => 'Изменить запись';

  @override
  String get title => 'Название';

  @override
  String get invalidTitle => 'Необходимо указать название.';

  @override
  String get uploadFinished => 'Загрузка завершена';

  @override
  String get notUploadedFiles => 'Следующие файлы не были загружены.';

  @override
  String get uploadSettings => 'Параметры загрузки';

  @override
  String get compressionRate => 'Битрейт в кбит/с';

  @override
  String get compressionInfo =>
      'Сжатие происходит при следующей загрузке. При пустом битрейте сжатие не происходит.';

  @override
  String get invalidCompressionRate => 'Значение должно быть больше нуля.';

  @override
  String get version => 'Версия';

  @override
  String get back => 'назад';

  @override
  String get folder => 'Папка';

  @override
  String get selectGroups => 'Выберите группы для записи';

  @override
  String get language => 'Язык';

  @override
  String get defaults => 'По умолчанию';

  @override
  String get editBitrates => 'Редактировать битрейты';

  @override
  String get bitrates => 'Bitraten';

  @override
  String get bitrate => 'Bitrate';

  @override
  String get info => 'Инфо';

  @override
  String get ok => 'OK';

  @override
  String get livestreams => 'Трансляции';

  @override
  String get editLivestream => 'Редактировать трансляцию';

  @override
  String get createLivestream => 'Добавить трансляцию';

  @override
  String get streamUrl => 'Ссылка на трансляцию';

  @override
  String get streamUrlHint =>
      'Внутренний url-адрес конечной точки трансляции: http://<адрес>:<порт>';

  @override
  String get similarClients => 'Похожее устройство';

  @override
  String get onlyNew => 'Новые';

  @override
  String get uploadValidation => 'Проверка MP3-тегов';

  @override
  String get uploadValidLanguage => 'Язык указан';

  @override
  String get uploadValidTitle => 'Название указана';

  @override
  String get uploadValidNumber => 'Номер трека указан';

  @override
  String get uploadValidCover => 'Обложка указана';

  @override
  String get uploadValidArtist => 'Исполнитель указан';

  @override
  String get uploadValidAlbum => 'Альбом указан';

  @override
  String get uploadValidGenre => 'Жанр указан';

  @override
  String get uploadValidAlbums => 'Допустимые альбомы';

  @override
  String get uploadValidAlbumInfo =>
      'Названия альбомов, разделенные запятой. Если пусто, то альбомы не ограничиваются.';

  @override
  String get uploadValidGenres => 'Допустимые жанры';

  @override
  String get uploadValidGenreInfo =>
      'Названия жанров, разделенные запятой. Если пусто, то жанры не ограничиваются.';

  @override
  String get uploadValidFilename => 'Формат названия файла';

  @override
  String get uploadValidFilenameInfo =>
      'Название файла должно соответствовать специальному формату. Regex. По умолчанию без ограничений.';

  @override
  String get uploadInvalidLanguage => 'Язык не указан или неизвестен.';

  @override
  String get uploadInvalidAlbum => 'Альбом не указан.';

  @override
  String get uploadInvalidAlbums => 'Альбом является недопустимым.';

  @override
  String get uploadInvalidGenre => 'Жанр не указан.';

  @override
  String get uploadInvalidGenres => 'Жанр является недопустимым.';

  @override
  String get uploadInvalidArtist => 'Исполнитель не указан.';

  @override
  String get uploadInvalidTitle => 'Название не указано.';

  @override
  String get uploadInvalidNumber => 'Номер трека не указан.';

  @override
  String get uploadInvalidCover => 'Обложка отсутствует.';

  @override
  String get uploadInvalidFilenameFormat =>
      'Имя файла не соответствует ожидаемому формату.';

  @override
  String get uploadValidFailed =>
      'При загрузке произошла непредвиденная ошибка.';

  @override
  String get doNotValidate => 'Не проверять';

  @override
  String get validate => 'Проверить';

  @override
  String get required => 'Обязательное';

  @override
  String get assignTo => 'Назначить';

  @override
  String get selectLoaded => 'Выбрать все загруженные элементы';

  @override
  String get makeUndeletable => 'Неудаляемый';

  @override
  String get lock => 'Заблокировать';

  @override
  String get newUpdate => 'Новое обновление';

  @override
  String get later => 'Позже';

  @override
  String get checkUpdate => 'Посмотрите новые функции и улучшения.';

  @override
  String get updateInstall => 'Обновить и установить';

  @override
  String get downloading => 'Скачивание...';

  @override
  String newVersion(String latestVersion) {
    return 'Доступна новая версия $latestVersion.';
  }

  @override
  String oldVersion(String appVersion) {
    return 'В данный момент используется версия $appVersion.';
  }

  @override
  String get inactive => 'Неактивный';

  @override
  String get cacheSettings => 'Управление памятью';

  @override
  String get cacheRemove => 'Очистить кэш';

  @override
  String get cacheRemoveTime => 'Очистить через';

  @override
  String get cacheRangeWeek => '1 неделя';

  @override
  String get cacheRangeMonth => '1 месяц';

  @override
  String get cacheRangeYear => '1 год';

  @override
  String get cacheRangeNever => 'Никогда';

  @override
  String get cacheCleared => 'Кэш был успешно очищен.';

  @override
  String get cacheClearedFailed => 'Кэш не может быть очищен.';

  @override
  String get instance => 'Инстанция';

  @override
  String get sync => 'Синк';

  @override
  String notOwned(String owner) {
    return 'Свойства могут быть изменены только владельцем \'$owner\'.';
  }

  @override
  String get assignAndRemove => 'Gruppen übernehmen und löschen.';

  @override
  String get peers => 'Экземпляры';

  @override
  String get invitations => 'Приглашения';

  @override
  String get audit => 'Журнал';

  @override
  String get approve => 'Принять';

  @override
  String get reject => 'Отклонить';

  @override
  String get close => 'Закрыть';

  @override
  String get copy => 'Копировать';

  @override
  String get unlink => 'Отменить регистрацию';

  @override
  String get synchronize => 'Синхронизировать';

  @override
  String get unassigned => 'Не назначено';

  @override
  String get recordsOfInstance => 'Записи экземпляра';

  @override
  String get peerStateRequested => 'Запрошено';

  @override
  String get peerStatePendingApproval => 'Ожидает подтверждения';

  @override
  String get peerStateResponsePending => 'Подтверждено, ответ ожидается';

  @override
  String get peerStateLinked => 'Связано';

  @override
  String get peerStateRejected => 'Отклонено';

  @override
  String peerKeysUpdatedAt(String date) {
    return 'Ключи обновлены: $date';
  }

  @override
  String get peerPendingApprovalInfo =>
      'Экземпляр хочет синхронизировать записи с этим экземпляром. После подтверждения партнёр будет уведомлён, и синхронизация будет включена согласно правилам. Отклонённый запрос удаляется.';

  @override
  String get peerRequestedInfo =>
      'Запрос отправлен и ожидает подтверждения администратором партнёра.';

  @override
  String get peerUrl => 'Адрес партнёра';

  @override
  String get invitationCode => 'Код приглашения';

  @override
  String get requestRegistration => 'Запросить регистрацию';

  @override
  String get requestRegistrationSend => 'Запросить';

  @override
  String get requestRegistrationInfo =>
      'Введите HTTPS-адрес партнёра и код приглашения, созданный администратором партнёра.';

  @override
  String get invitationCreated => 'Приглашение создано';

  @override
  String invitationInfo(String date) {
    return 'Передайте адрес и код администратору партнёра. Код можно использовать один раз до $date, после этого он больше не отображается.';
  }

  @override
  String invitationExpiresAt(String date) {
    return 'Действительно до $date';
  }

  @override
  String get outgoingRules => 'Исходящие правила';

  @override
  String get incomingRules => 'Входящие правила';

  @override
  String get outgoingRule => 'Исходящее правило';

  @override
  String get incomingRule => 'Входящее правило';

  @override
  String get outgoingRulesInfo =>
      'Собственные записи, соответствующие правилу, отправляются партнёру. Без правила ничего не отправляется. Правила применяются только к новым записям или при ручной синхронизации.';

  @override
  String get incomingRulesInfo =>
      'Полученные записи назначаются группам наиболее точного подходящего правила. Без подходящего правила они не назначены.';

  @override
  String get ruleInfo =>
      'Несколько значений одного критерия объединяются через ИЛИ, критерии — через И. Полученные записи сопоставляются по имени без учёта регистра.';

  @override
  String get ruleEmptyMatchesAll => 'Пусто — подходит всё.';

  @override
  String get ruleMatchesAll => 'Все записи';

  @override
  String get ruleGroups => 'Группы для полученных записей';

  @override
  String unlinkTitle(String instance) {
    return 'Отменить регистрацию $instance';
  }

  @override
  String get unlinkInfo =>
      'Синхронизация прекращается, партнёр уведомляется. Синхронизированные записи сохраняются, если вы их не удалите.';

  @override
  String get unlinkDeleteRecords => 'Удалить синхронизированные записи';

  @override
  String unlinkDeleteRecordsInfo(String instance) {
    return 'Все записи, полученные от $instance, удаляются здесь, включая заблокированные. $instance будет предложено удалить записи этого экземпляра.';
  }

  @override
  String unlinkKeepRecordsInfo(String instance) {
    return 'Записи, полученные от $instance, сохраняются здесь и могут быть удалены вручную.';
  }

  @override
  String get unlinkLocally => 'Отменить только локально';

  @override
  String unlinkLocallyInfo(String instance) {
    return 'Не удалось уведомить $instance. Если отменить регистрацию только локально, $instance сохранит регистрацию, пока её не удалит администратор партнёра.';
  }

  @override
  String unlinkLocallyDeleteInfo(String instance) {
    return 'Не удалось уведомить $instance. Если отменить регистрацию только локально, полученные от $instance записи удаляются здесь. Записи этого экземпляра остаются у $instance.';
  }

  @override
  String registrationReceived(String instance) {
    return 'Новый запрос на регистрацию от $instance.';
  }

  @override
  String syncResult(int queued, int skipped) {
    return 'Запланировано передач: $queued, пропущено записей: $skipped.';
  }

  @override
  String get federationDisabled => 'Синхронизация не настроена на сервере.';

  @override
  String get federationInvalidUrl =>
      'Адрес должен быть действительным HTTPS-адресом.';

  @override
  String get federationRemoteUnreachable => 'Партнёр недоступен.';

  @override
  String get federationRemoteRejected =>
      'Партнёр отклонил запрос. Проверьте код приглашения.';

  @override
  String get federationInvalidDiscovery =>
      'Партнёр возвращает неверные данные.';

  @override
  String get federationInstanceConflict =>
      'Экземпляр с таким именем уже зарегистрирован.';

  @override
  String get federationInvalidState =>
      'Действие невозможно в текущем состоянии партнёра.';

  @override
  String get federationInvalidInvitation => 'Код приглашения недействителен.';

  @override
  String auditRecords(int count) {
    return 'Записей: $count';
  }

  @override
  String get auditStatus => 'Статус';

  @override
  String get auditSource => 'Источник';

  @override
  String get auditTarget => 'Цель';

  @override
  String get auditTransaction => 'Транзакция';

  @override
  String get auditMessage => 'Сообщение';

  @override
  String get auditSuccess => 'Успешно';

  @override
  String get auditFailed => 'Ошибка';

  @override
  String get auditSkipped => 'Пропущено';

  @override
  String get auditRegistrationRequested => 'Регистрация запрошена';

  @override
  String get auditRegistrationReceived => 'Получен запрос на регистрацию';

  @override
  String get auditRegistrationApproved => 'Регистрация принята';

  @override
  String get auditRegistrationRejected => 'Регистрация отклонена';

  @override
  String get auditUnlinked => 'Регистрация отменена';

  @override
  String get auditKeysChanged => 'Ключи изменены';

  @override
  String get auditRecordPushed => 'Запись отправлена';

  @override
  String get auditRecordReceived => 'Запись получена';

  @override
  String get auditRecordUpdated => 'Запись обновлена';

  @override
  String get auditRecordDeleted => 'Запись удалена';

  @override
  String get auditRecordsRemoved => 'Записи удалены';

  @override
  String rejectTitle(String instance) {
    return 'Отклонить запрос $instance';
  }

  @override
  String rejectInfo(String instance) {
    return '$instance будет уведомлён об отклонении, запрос будет удалён. Если $instance недоступен, запрос всё равно удаляется. Для нового запроса $instance нужен новый код приглашения.';
  }

  @override
  String get auditNewEntries => 'Новые записи — обновить';

  @override
  String get auditRetention => 'Хранить журнал';

  @override
  String get auditRetentionInfo =>
      'Более старые записи журнала синхронизации удаляются автоматически.';

  @override
  String get retentionThreeMonths => '3 месяца';

  @override
  String get retentionSixMonths => '6 месяцев';

  @override
  String get invitationAddress => 'Адрес этого экземпляра';

  @override
  String get rules => 'Правила';

  @override
  String get ruleAllInstances => 'Все экземпляры';

  @override
  String get ruleEmptyAllInstances =>
      'Пусто — действует для всех экземпляров, в том числе связанных позже.';

  @override
  String get peerNoRules => 'Для этого экземпляра нет правил.';

  @override
  String get peerRulesInfo =>
      'Правила управляются в разделе Sync → Правила. Правила, ограниченные экземпляром, имеют приоритет над правилами для всех экземпляров.';

  @override
  String approveTitle(String instance) {
    return 'Принять запрос $instance';
  }

  @override
  String approveInfo(String instance, int count) {
    return '$instance будет уведомлён, синхронизация включится. С этого момента для $instance действуют исходящие правила: $count. Новые собственные записи, соответствующие им, отправляются $instance.';
  }

  @override
  String get ruleSourceGroups => 'Группы отправляемых записей';

  @override
  String receivedFrom(String owner) {
    return 'Получено от $owner';
  }

  @override
  String get syncState => 'Синхронизация';

  @override
  String get syncStateReceived => 'Получено';

  @override
  String get syncStateSent => 'Отправлено';

  @override
  String get syncStateProblem => 'Проблема';

  @override
  String get syncStateNone => 'Не синхронизировано';

  @override
  String syncProblemWith(String instance) {
    return 'Ошибка синхронизации с $instance';
  }

  @override
  String get syncProblemFailed =>
      'Окончательная ошибка. Повторите через «Синхронизировать».';

  @override
  String syncProblemRetry(String date) {
    return 'Следующая попытка: $date';
  }

  @override
  String syncSentCount(int count) {
    return 'Отправлено экземплярам: $count';
  }

  @override
  String syncProblemCount(int count) {
    return 'Проблем: $count';
  }

  @override
  String get auditResult => 'Результат';

  @override
  String get auditDirection => 'Направление';

  @override
  String get auditAction => 'Действие';

  @override
  String get auditIncoming => 'Входящее';

  @override
  String get auditOutgoing => 'Исходящее';

  @override
  String get auditFilterReset => 'Сбросить фильтры';

  @override
  String get auditSelectionClear => 'Снять выделение';

  @override
  String get auditDeleteSelected => 'Удалить выбранные';

  @override
  String auditDeleteCount(int count) {
    return 'Будет удалено записей: $count. Продолжить?';
  }

  @override
  String get auditFilterRemove => 'Убрать фильтр';

  @override
  String get invitationNew => 'Новое приглашение';

  @override
  String get invitationNewInfo =>
      'Будет создан код приглашения, с помощью которого экземпляр-партнёр сможет один раз зарегистрироваться.';

  @override
  String get create => 'Создать';

  @override
  String get auditRecordRemoved => 'Запись больше не существует';

  @override
  String get auditPending => 'Ожидает';

  @override
  String get invitationValidity => 'Срок действия';

  @override
  String durationHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа',
      many: '$count часов',
      few: '$count часа',
      one: '1 час',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '1 день',
    );
    return '$_temp0';
  }
}
