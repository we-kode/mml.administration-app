# Graph Report - mml.administration-app  (2026-09-19)

## Corpus Check
- 124 files · ~39,688 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 35 file(s) not represented in the graph (top: (none) 10, .xcconfig 4, .plist 3)

## Summary
- 1842 nodes · 2682 edges · 91 communities (88 shown, 3 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 16 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a762aa03`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- client.dart
- admin_app_localizations_de.dart
- admin_app_localizations_en.dart
- admin_app_localizations_ru.dart
- async_list_view.dart
- package:mml_admin/services/messenger.dart
- lib/main.dart
- my_application.cc
- record_validation.dart
- view_models/records/upload.dart
- services/record.dart
- models/record.dart
- async_select_list_dialog.dart
- view_models/clients/register.dart
- package:mml_admin/models/model_list.dart
- router.dart
- expandable_fab.dart
- check_animation.dart
- view_models/change_password.dart
- view_models/login.dart
- AppDelegate.swift
- views/clients/register.dart
- views/records/record_tag_filter.dart
- image_cache_manager.dart
- string
- view_models/settings/settings_upload_validation.dart
- view_models/clients/edit.dart
- ChangeNotifier
- StatelessWidget
- win32_window.cpp
- view_models/clients/overview.dart
- package:dio/dio.dart
- Win32Window
- chip_choices.dart
- view_models/livestreams/edit.dart
- package:flutter/material.dart
- view_models/settings/settings.dart
- view_models/users/edit.dart
- package:mml_admin/l10n/admin_app_localizations.dart
- client_registration.dart
- views/settings/settings_upload_validation.dart
- services/user.dart
- view_models/groups/edit.dart
- views/records/edit.dart
- view_models/main.dart
- view_models/settings/settings_compression.dart
- id3_tag_filter.dart
- view_models/records/edit.dart
- view_models/records/overview.dart
- dart:io
- views/clients/client_tag_filter.dart
- api.dart
- registration.dart
- @JsonSerializable
- utils.cpp
- package:json_annotation/json_annotation.dart
- State
- package:mml_admin/services/router.dart
- model_base.dart
- clients.dart
- services/group.dart
- view_models/settings/settings_genre_bitrate.dart
- flutter_window.h
- MessageHandler
- messenger.dart
- models/group.dart
- models/user.dart
- livestreams.dart
- view_models/livestreams/overview.dart
- navigation_state.dart
- genre.dart
- record_folder.dart
- views/users/overview.dart
- package:intl/intl.dart
- MessageHandler
- Size
- view_models/settings/settings_connection.dart
- livestream.dart
- views/clients/edit.dart
- views/settings/settings.dart
- package:provider/provider.dart
- views/groups/edit.dart
- package:mml_admin/models/group.dart
- Point
- ListSubfilterView
- language.dart
- package:mml_admin/models/user.dart
- AppLocalizations
- customize
- bool?
- String?

## God Nodes (most connected - your core abstractions)
1. `Win32Window` - 24 edges
2. `ModelBase` - 16 edges
3. `MessageHandler` - 12 edges
4. `GroupService` - 11 edges
5. `ModelList` - 10 edges
6. `FlutterWindow` - 10 edges
7. `Create` - 10 edges
8. `WndProc` - 10 edges
9. `MessageHandler` - 9 edges
10. `ApiService` - 8 edges

## Surprising Connections (you probably didn't know these)
- `OnCreate` --calls--> `RegisterPlugins()`  [INFERRED]
  windows/runner/flutter_window.h → windows/flutter/generated_plugin_registrant.cc
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  windows/runner/main.cpp → windows/runner/utils.cpp
- `Win32Window::Win32Window()` --calls--> `Destroy`  [INFERRED]
  windows/runner/win32_window.cpp → windows/runner/win32_window.h
- `ClientTagFilterView` --inherits--> `ListSubfilterView`  [EXTRACTED]
  lib/views/clients/client_tag_filter.dart → lib/components/list_subfilter_view.dart
- `RecordTagFilter` --inherits--> `ListSubfilterView`  [EXTRACTED]
  lib/views/records/record_tag_filter.dart → lib/components/list_subfilter_view.dart

## Import Cycles
- None detected.

## Communities (91 total, 3 thin omitted)

### Community 0 - "client.dart"
Cohesion: 0.14
Nodes (13): clientId, deviceIdentifier, displayName, fromJson, getAvatar, getDisplayDescription, getDisplayDescriptionSuffix, getIdentifier (+5 more)

### Community 1 - "admin_app_localizations_de.dart"
Cohesion: 0.01
Nodes (157): admin_app_localizations.dart, actualConnectionSettings, actualPassword, actualUser, add, adminUsers, advanced, album (+149 more)

### Community 2 - "admin_app_localizations_en.dart"
Cohesion: 0.01
Nodes (156): actualConnectionSettings, actualPassword, actualUser, add, adminUsers, advanced, album, appKey (+148 more)

### Community 3 - "admin_app_localizations_ru.dart"
Cohesion: 0.01
Nodes (156): actualConnectionSettings, actualPassword, actualUser, add, adminUsers, advanced, album, appKey (+148 more)

### Community 4 - "async_list_view.dart"
Cohesion: 0.04
Nodes (50): ActionPerformedFunction, _actualGroup, AddFunction, addItem, assignItems, availableTags, AvailableTagsChangedFunction, build (+42 more)

### Community 5 - "package:mml_admin/services/messenger.dart"
Cohesion: 0.17
Nodes (11): AdminApp, build, dragDevices, MMLAdminScrollBehavior, MaterialScrollBehavior, package:flutter/gestures.dart, package:flutter_localizations/flutter_localizations.dart, package:mml_admin/lib_color_schemes.g.dart (+3 more)

### Community 6 - "lib/main.dart"
Cohesion: 0.10
Nodes (19): admin_app.dart, HttpOverrides, appLocales, createHttpClient, ensureInitialized, findSystemLocale, init, locale (+11 more)

### Community 7 - "my_application.cc"
Cohesion: 0.06
Nodes (31): FlPluginRegistry, flutter_linux, flutter_secure_storage_linux_plugin, flutter_secure_storage_windows_plugin, GApplication, gboolean, gchar, gdkx (+23 more)

### Community 8 - "record_validation.dart"
Cohesion: 0.07
Nodes (26): album, albums, artist, cover, filename, fileNameTemplate, fromJson, genre (+18 more)

### Community 9 - "view_models/records/upload.dart"
Cohesion: 0.06
Nodes (34): fileCount, files, folder, getGroups, _groupService, init, initUpload, _isMp3 (+26 more)

### Community 10 - "services/record.dart"
Cohesion: 0.05
Nodes (41): _apiService, assign, assignedFolderGroups, assignedGroups, assignFolders, delete, deleteBitrate, deleteFolder (+33 more)

### Community 11 - "models/record.dart"
Cohesion: 0.07
Nodes (29): album, artist, bitrate, cover, date, duration, fromJson, genre (+21 more)

### Community 12 - "async_select_list_dialog.dart"
Cohesion: 0.07
Nodes (28): build, _createActions, _createListHeaderWidget, _createListTile, _createListViewWidget, _createLoadingTile, _createLoadingWidget, _createNoDataWidget (+20 more)

### Community 13 - "view_models/clients/register.dart"
Cohesion: 0.07
Nodes (27): abort, assignAndDeleteClient, client, _closeOnError, _context, deleteClient, dispose, formKey (+19 more)

### Community 14 - "package:mml_admin/models/model_list.dart"
Cohesion: 0.18
Nodes (10): GroupService, clear, load, tagFilter, updateFilter, _groupService, loadGroups, route (+2 more)

### Community 15 - "router.dart"
Cohesion: 0.09
Nodes (23): getInstance, _instance, navigatorKey, MainViewModel, build, MainScreen, _navItem, package:http/http.dart (+15 more)

### Community 16 - "expandable_fab.dart"
Cohesion: 0.08
Nodes (25): Animation, build, _buildExpandingActionButtons, _buildTapToCloseFab, _buildTapToOpenFab, child, children, _controller (+17 more)

### Community 17 - "check_animation.dart"
Cohesion: 0.10
Nodes (21): AnimationController, build, _controller, createState, dispose, initState, onStop, StopFunction (+13 more)

### Community 18 - "view_models/change_password.dart"
Cohesion: 0.08
Nodes (23): actualPassword, _actualPasswordError, afterConfirmation, cancel, clearActualPasswordError, clearNewPasswordError, confirmPassword, _context (+15 more)

### Community 19 - "view_models/login.dart"
Cohesion: 0.08
Nodes (23): afterLogin, appKey, clientId, _context, formKey, init, locales, login (+15 more)

### Community 20 - "AppDelegate.swift"
Cohesion: 0.18
Nodes (8): Cocoa, FlutterAppDelegate, FlutterMacOS, AppDelegate, Bool, MainFlutterWindow, NSApplication, NSWindow

### Community 21 - "views/clients/register.dart"
Cohesion: 0.15
Nodes (15): ClientsRegisterViewModel, SettingsConnectionViewModel, _actualState, build, ClientRegisterDialog, _createActions, _createRegisterForm, build (+7 more)

### Community 22 - "views/records/record_tag_filter.dart"
Cohesion: 0.20
Nodes (9): build, _createTagFilter, _handleDateFilter, _handleFilter, _handleFolderFilter, package:calendar_date_picker2/calendar_date_picker2.dart, package:mml_admin/components/horizontal_spacer.dart, package:mml_admin/models/id3_tag_filter.dart (+1 more)

### Community 23 - "image_cache_manager.dart"
Cohesion: 0.06
Nodes (33): CacheManager, cacheSizeMB, clearCache, durationLimit, getFileStream, ImageCacheManager, init, _instance (+25 more)

### Community 24 - "string"
Cohesion: 0.13
Nodes (13): IsValidGuid, albumId, albumName, fromJson, getDisplayDescription, toJson, artistId, fromJson (+5 more)

### Community 25 - "view_models/settings/settings_upload_validation.dart"
Cohesion: 0.15
Nodes (12): FormState, RecordValidation, abort, _context, init, locales, model, _recordService (+4 more)

### Community 26 - "view_models/clients/edit.dart"
Cohesion: 0.10
Nodes (19): _addBackendErrors, clearBackendErrors, client, clientLoadedSuccessfully, _context, deviceNameField, displayNameField, errors (+11 more)

### Community 27 - "ChangeNotifier"
Cohesion: 0.10
Nodes (23): ChangeNotifier, ClientTagFilterViewModel, ClientsViewModel, LiveStreamsViewModel, RecordTagFilterViewModel, SyncOverviewViewModel, build, ClientsScreen (+15 more)

### Community 28 - "StatelessWidget"
Cohesion: 0.15
Nodes (16): @immutable, ActionButton, _ExpandingActionButton, build, ShimmerCover, ChangePasswordViewModel, LoginViewModel, build (+8 more)

### Community 29 - "win32_window.cpp"
Cohesion: 0.19
Nodes (13): dwmapi, wchar_t, Scale(), Create, Destroy, UpdateTheme, Win32Window::Win32Window(), WindowClassRegistrar (+5 more)

### Community 30 - "view_models/clients/overview.dart"
Cohesion: 0.17
Nodes (11): clientCount, groups, groupsChanged, _groupService, init, loadAssignedGroups, loadClients, loadGroups (+3 more)

### Community 31 - "package:dio/dio.dart"
Cohesion: 0.13
Nodes (15): FileService, ApiService, _apiService, CoverFileService, getInstance, _instance, _apiService, getInstance (+7 more)

### Community 32 - "Win32Window"
Cohesion: 0.14
Nodes (20): FlutterViewController, RECT, unique_ptr, FlutterWindow, flutter_controller_, OnCreate, OnDestroy, project_ (+12 more)

### Community 33 - "chip_choices.dart"
Cohesion: 0.12
Nodes (17): activeColor, build, ChipChoices, _ChipChoicesState, createState, initialSelectedItems, initState, _isActive (+9 more)

### Community 34 - "view_models/livestreams/edit.dart"
Cohesion: 0.11
Nodes (17): _addBackendErrors, clearBackendErrors, _context, errors, formKey, getGroups, _groupService, groupsField (+9 more)

### Community 35 - "package:flutter/material.dart"
Cohesion: 0.18
Nodes (8): false, localization, shouldDelete, showDeleteDialog, horizontalSpacer, verticalSpacer, package:flutter/material.dart, return shouldDelete ??

### Community 36 - "view_models/settings/settings.dart"
Cohesion: 0.12
Nodes (16): cacheManager, changePassword, clearCache, _context, init, instance, locales, _messengerService (+8 more)

### Community 37 - "view_models/users/edit.dart"
Cohesion: 0.12
Nodes (16): _addBackendErrors, clearBackendErrors, _context, errors, formKey, init, locales, nameField (+8 more)

### Community 38 - "package:mml_admin/l10n/admin_app_localizations.dart"
Cohesion: 0.14
Nodes (15): floatingExtendedChipUpdate, locales, SettingsCompressionViewModel, SettingsGenreBitrateViewModel, build, _createActions, SettingsCompressionScreen, build (+7 more)

### Community 39 - "client_registration.dart"
Cohesion: 0.12
Nodes (14): dart:convert, appKey, ClientRegistration, endpoint, fromJson, toJson, token, toString (+6 more)

### Community 40 - "views/settings/settings_upload_validation.dart"
Cohesion: 0.24
Nodes (9): RecordValidationState, SettingsUploadValidationViewModel, build, _createActions, SettingsUploadValidationScreen, _switchFormField, package:mml_admin/models/record_validation.dart, package:mml_admin/view_models/settings/settings_upload_validation.dart (+1 more)

### Community 41 - "services/user.dart"
Cohesion: 0.12
Nodes (15): _apiService, createUser, deleteUsers, getInstance, getUser, getUserInfo, getUsers, _instance (+7 more)

### Community 42 - "view_models/groups/edit.dart"
Cohesion: 0.12
Nodes (15): _addBackendErrors, clearBackendErrors, _context, errors, formKey, group, groupLoadedSuccessfully, _groupService (+7 more)

### Community 43 - "views/records/edit.dart"
Cohesion: 0.24
Nodes (9): RecordEditViewModel, build, _createActions, _createEditForm, RecordEditDialog, recordId, package:material_symbols_icons/material_symbols_icons.dart, package:mml_admin/components/chip_choices.dart (+1 more)

### Community 44 - "view_models/main.dart"
Cohesion: 0.12
Nodes (16): RouterService, binaryUri, changeLogUri, _context, fileName, init, latestVersionUri, loadPage (+8 more)

### Community 45 - "view_models/settings/settings_compression.dart"
Cohesion: 0.12
Nodes (15): abort, _addBackendErrors, clearBackendErrors, compressionField, _context, errors, init, locales (+7 more)

### Community 46 - "id3_tag_filter.dart"
Cohesion: 0.05
Nodes (40): dart:collection, dart:math, filter, asFlag, Flag, _languageCodes, clear, ClientTagFilter (+32 more)

### Community 47 - "view_models/records/edit.dart"
Cohesion: 0.13
Nodes (14): _context, formKey, getGroups, _groupService, init, instance, isEditable, loadedSuccessfully (+6 more)

### Community 48 - "view_models/records/overview.dart"
Cohesion: 0.13
Nodes (14): groups, groupsChanged, _groupService, init, isFolderView, load, loadAssignedGroups, loadGroups (+6 more)

### Community 49 - "dart:io"
Cohesion: 0.14
Nodes (13): dart:async, dart:io, contentType, file, filename, filePath, fromFileSync, length (+5 more)

### Community 50 - "views/clients/client_tag_filter.dart"
Cohesion: 0.20
Nodes (9): build, clients, _createActiveTagFilter, _createTagFilter, _handleFilter, tagFilter, package:mml_admin/components/list_subfilter_view.dart, package:mml_admin/models/client_tag_filter.dart (+1 more)

### Community 51 - "api.dart"
Cohesion: 0.14
Nodes (13): Dio, _addDefaultErrorHandlerInterceptor, _addRequestOptionsInterceptor, _dio, getInstance, initDio, _instance, _messenger (+5 more)

### Community 52 - "registration.dart"
Cohesion: 0.14
Nodes (13): HubConnection, ClientRegisteredFunction, close, connect, _connection, onRegistered, onUpdate, RegistrationService (+5 more)

### Community 53 - "@JsonSerializable"
Cohesion: 0.28
Nodes (13): @JsonSerializable, Album, Artist, Client, GenreBitrate, Genre, Group, Language (+5 more)

### Community 54 - "utils.cpp"
Cohesion: 0.17
Nodes (13): flutter_windows, _In_, _In_opt_, io, iostream, stdio, vector, wWinMain() (+5 more)

### Community 55 - "package:json_annotation/json_annotation.dart"
Cohesion: 0.15
Nodes (12): int?, bitrate, fromJson, genreId, getDisplayDescription, name, toJson, compressionRate (+4 more)

### Community 56 - "State"
Cohesion: 0.25
Nodes (11): AsyncListView, _AsyncListViewState, AsyncSelectListDialog, _AsyncSelectListDialogState, CheckAnimation, CheckAnimationState, ErrorAnimation, ErrorAnimationState (+3 more)

### Community 57 - "package:mml_admin/services/router.dart"
Cohesion: 0.16
Nodes (12): showProgressIndicator, UserService, load, route, loadUsers, route, _userService, package:mml_admin/components/delete_dialog.dart (+4 more)

### Community 58 - "model_base.dart"
Cohesion: 0.15
Nodes (12): getAvatar, getDisplayDescription, getDisplayDescriptionSuffix, getGroup, getIdentifier, getMetadata, getPrefixIcon, getSecureState (+4 more)

### Community 59 - "clients.dart"
Cohesion: 0.14
Nodes (13): _apiService, assignClients, assignedGroups, ClientService, deleteClients, getClient, getClients, getConnectionSettings (+5 more)

### Community 60 - "services/group.dart"
Cohesion: 0.18
Nodes (10): _apiService, createGroup, deleteGroups, getGroup, getGroups, getInstance, getMediaGroups, _instance (+2 more)

### Community 61 - "view_models/settings/settings_genre_bitrate.dart"
Cohesion: 0.11
Nodes (18): RecordService, SecureStorageService, clear, load, _service, _storage, tagFilter, updateFilter (+10 more)

### Community 62 - "flutter_window.h"
Cohesion: 0.39
Nodes (5): dart_project, flutter_view_controller, functional, memory, windows

### Community 63 - "MessageHandler"
Cohesion: 0.18
Nodes (10): generated_plugin_registrant, optional, DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM (+2 more)

### Community 64 - "messenger.dart"
Cohesion: 0.18
Nodes (10): GlobalKey, fileToLarge, getInstance, _instance, MessengerService, showMessage, snackbarKey, unexpectedError (+2 more)

### Community 65 - "models/group.dart"
Cohesion: 0.18
Nodes (10): int get, fromJson, getDisplayDescription, getIdentifier, hashCode, id, isDefault, name (+2 more)

### Community 66 - "models/user.dart"
Cohesion: 0.18
Nodes (10): fromJson, getDisplayDescription, getIdentifier, id, isConfirmed, name, newPassword, oldPassword (+2 more)

### Community 67 - "livestreams.dart"
Cohesion: 0.18
Nodes (10): _apiService, assign, assignedGroups, delete, getInstance, getLivestream, _instance, LivestreamService (+2 more)

### Community 68 - "view_models/livestreams/overview.dart"
Cohesion: 0.15
Nodes (12): ModelList, groups, groupsChanged, _groupService, init, load, loadAssignedGroups, loadGroups (+4 more)

### Community 69 - "navigation_state.dart"
Cohesion: 0.25
Nodes (7): bool get, NavigationState, _path, _returnClicked, returnPressed, returnReleased, String? get

### Community 70 - "genre.dart"
Cohesion: 0.33
Nodes (5): fromJson, genreId, getDisplayDescription, name, toJson

### Community 71 - "record_folder.dart"
Cohesion: 0.20
Nodes (9): day, fromDate, fromJson, getDisplayDescription, getPrefixIcon, month, toJson, year (+1 more)

### Community 72 - "views/users/overview.dart"
Cohesion: 0.47
Nodes (5): UsersOverviewViewModel, build, UsersOverviewScreen, package:mml_admin/view_models/users/overview.dart, package:mml_admin/views/users/edit.dart

### Community 73 - "package:intl/intl.dart"
Cohesion: 0.40
Nodes (4): DateTime?, DateTimeExtended, weekdayName, package:intl/intl.dart

### Community 74 - "MessageHandler"
Cohesion: 0.36
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetHandle, GetThisFromHandle (+2 more)

### Community 75 - "Size"
Cohesion: 0.50
Nodes (3): Size, height, width

### Community 76 - "view_models/settings/settings_connection.dart"
Cohesion: 0.25
Nodes (7): BuildContext, abort, connectionSettings, _context, formKey, init, package:mml_admin/services/clients.dart

### Community 77 - "livestream.dart"
Cohesion: 0.22
Nodes (8): fromJson, getDisplayDescription, getTags, groups, recordId, title, toJson, url

### Community 78 - "views/clients/edit.dart"
Cohesion: 0.32
Nodes (7): ClientsEditViewModel, build, ClientEditDialog, clientId, _createActions, _createEditForm, package:mml_admin/view_models/clients/edit.dart

### Community 79 - "views/settings/settings.dart"
Cohesion: 0.28
Nodes (8): SettingsViewModel, build, SettingsScreen, package:mml_admin/view_models/settings/settings.dart, package:mml_admin/views/settings/settings_compression.dart, package:mml_admin/views/settings/settings_connection.dart, package:mml_admin/views/settings/settings_genre_bitrate.dart, package:mml_admin/views/settings/settings_upload_validation.dart

### Community 80 - "package:provider/provider.dart"
Cohesion: 0.28
Nodes (8): UsersEditDialogViewModel, build, _createActions, _createEditForm, userId, UsersEditDialog, package:mml_admin/view_models/users/edit.dart, package:provider/provider.dart

### Community 81 - "views/groups/edit.dart"
Cohesion: 0.28
Nodes (8): GroupEditDialogViewModel, build, _createActions, _createEditForm, GroupEditDialog, groupId, package:mml_admin/components/vertical_spacer.dart, package:mml_admin/view_models/groups/edit.dart

### Community 82 - "package:mml_admin/models/group.dart"
Cohesion: 0.17
Nodes (13): GroupsOverviewViewModel, LivestreamEditDialogViewModel, build, GroupsOverviewScreen, build, _createActions, _createEditForm, id (+5 more)

### Community 83 - "Point"
Cohesion: 0.50
Nodes (3): Point, x, y

### Community 84 - "ListSubfilterView"
Cohesion: 0.67
Nodes (3): ListSubfilterView, ClientTagFilterView, RecordTagFilter

### Community 88 - "language.dart"
Cohesion: 0.33
Nodes (5): fromJson, getDisplayDescription, languageId, name, toJson

### Community 89 - "package:mml_admin/models/user.dart"
Cohesion: 0.40
Nodes (4): ChangePasswordArguments, isManualTriggered, user, package:mml_admin/models/user.dart

### Community 90 - "AppLocalizations"
Cohesion: 0.50
Nodes (4): AppLocalizations, AppLocalizationsDe, AppLocalizationsEn, AppLocalizationsRu

## Knowledge Gaps
- **1280 isolated node(s):** `dragDevices`, `build`, `LoadDataFunction`, `DeleteFunction`, `ActionPerformedFunction` (+1275 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1429 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Win32Window` connect `Win32Window` to `MessageHandler`, `Size`, `Point`, `win32_window.cpp`, `flutter_window.h`, `MessageHandler`?**
  _High betweenness centrality (0.060) - this node is a cross-community bridge._
- **Why does `AppLocalizationsEn` connect `AppLocalizations` to `admin_app_localizations_en.dart`?**
  _High betweenness centrality (0.032) - this node is a cross-community bridge._
- **Why does `OnCreate` connect `Win32Window` to `my_application.cc`, `MessageHandler`?**
  _High betweenness centrality (0.030) - this node is a cross-community bridge._
- **What connects `dragDevices`, `build`, `LoadDataFunction` to the rest of the system?**
  _1280 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `client.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._
- **Should `admin_app_localizations_de.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.012658227848101266 - nodes in this community are weakly interconnected._
- **Should `admin_app_localizations_en.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.012738853503184714 - nodes in this community are weakly interconnected._