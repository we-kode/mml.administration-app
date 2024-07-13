import 'admin_app_localizations.dart';

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
  String get forbidden => 'У вас нет необходимых прав, чтобы выполнить это действие!';

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
  String get relogin => 'Срок действия вашего логина истёк! Пожалуйста, войдите в систему ещё раз!';

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
  String get confirmAccount => 'Пожалуйста, обновите свой пароль, чтобы продолжить.';

  @override
  String get actualPassword => 'Текущий пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmNewPassword => 'Подтвердить пароль';

  @override
  String get invalidConfirmPasswords => 'Новый пароль не соответствует проверке.';

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
  String get deleteConfirmation => 'Вы действительно хотите удалить выбранные записи?';

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
  String get groupIsDefaultHint => 'Группа будет назначена по умолчанию при создании клиента.';

  @override
  String get invalidGroupName => 'Пожалуйста, введите название группы!';

  @override
  String get invalidGroupIsDefault => 'Пожалуйста, укажите, является ли группа стандартной или нет!';

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
  String get compressionInfo => 'Сжатие происходит при следующей загрузке. При пустом битрейте сжатие не происходит.';

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
  String get streamUrlHint => 'Внутренний url-адрес конечной точки трансляции: http://<адрес>:<порт>';

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
  String get uploadValidAlbumInfo => 'Названия альбомов, разделенные запятой. Если пусто, то альбомы не ограничиваются.';

  @override
  String get uploadValidGenres => 'Допустимые жанры';

  @override
  String get uploadValidGenreInfo => 'Названия жанров, разделенные запятой. Если пусто, то жанры не ограничиваются.';

  @override
  String get uploadValidFilename => 'Формат названия файла';

  @override
  String get uploadValidFilenameInfo => 'Название файла должно соответствовать специальному формату. Regex. По умолчанию без ограничений.';

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
  String get uploadInvalidFilenameFormat => 'Имя файла не соответствует ожидаемому формату.';

  @override
  String get uploadValidFailed => 'При загрузке произошла непредвиденная ошибка.';

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
}
