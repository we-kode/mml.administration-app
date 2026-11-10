import 'dart:io';

import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mml_admin/components/progress_indicator.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/announcement.dart';
import 'package:mml_admin/models/client.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/announcements.dart';
import 'package:mml_admin/services/clients.dart';
import 'package:mml_admin/services/group.dart';
import 'package:mml_admin/services/messenger.dart';
import 'package:mml_admin/services/router.dart';

/// View model of the dialog to create or edit an announcement.
class AnnouncementEditViewModel extends ChangeNotifier {
  /// [AnnouncementService] used to load and store the announcement.
  final AnnouncementService _service = AnnouncementService.getInstance();

  /// Key of the edit form.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Current build context.
  late BuildContext _context;

  /// Locales of the application.
  late AppLocalizations locales;

  /// The announcement to be created or edited.
  late Announcement announcement;

  /// Names of the clients loaded so far by their id.
  final Map<String, String> _clientNames = {};

  /// Flag that indicates whether the announcement is successful loaded.
  bool loadedSuccessfully = false;

  /// Whether the announcement is only valid in a period.
  bool get hasPeriod =>
      announcement.validFrom != null || announcement.validTo != null;

  /// Loads the announcement with the given [id] or creates a new one.
  Future<bool> init(BuildContext context, String? id) async {
    locales = AppLocalizations.of(context)!;
    _context = context;

    // The dialog calls init while it is built, so listeners are notified
    // after the build at the earliest.
    await Future<void>.microtask(() {});

    try {
      announcement = id == null
          ? Announcement()
          : await _service.getAnnouncement(id);
      if (announcement.clientIds.isNotEmpty) {
        await _loadAllClients();
      }
      loadedSuccessfully = true;
      notifyListeners();
      return true;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(messenger.notFound);
      }

      if (context.mounted) Navigator.pop(context, true);
      return false;
    }
  }

  /// Loads a chunk of the registered clients the announcement can be shown
  /// to.
  Future<ModelList> loadClients({
    String? filter,
    int? offset,
    int? take,
  }) async {
    var page = await ClientService.getInstance().getClients(
      filter,
      offset,
      take,
      null,
    );
    for (var client in page.whereType<Client>()) {
      _clientNames[client.clientId!] = client.displayName ?? client.clientId!;
    }
    return page;
  }

  /// Names of the selected clients or null, if no client is selected.
  String? get selectedClientNames => announcement.clientIds.isEmpty
      ? null
      : announcement.clientIds.map((id) => _clientNames[id] ?? id).join(', ');

  /// Sets the clients the announcement is shown to.
  void setClients(List<dynamic> clientIds) {
    announcement.clientIds = List<String>.from(clientIds);
    notifyListeners();
  }

  // The client list of the identity service does not support loading all
  // clients at once, so the names are loaded page by page.
  Future<void> _loadAllClients() async {
    var loaded = 0;
    ModelList page;
    do {
      page = await loadClients(offset: loaded, take: 100);
      loaded += page.whereType<Client>().length;
    } while (loaded < page.totalCount && page.whereType<Client>().isNotEmpty);
  }

  /// Validates the [title] of the announcement.
  String? validateTitle(String? title) {
    return (title ?? '').trim().isNotEmpty ? null : locales.invalidTitle;
  }

  /// Validates the [message] of the announcement.
  String? validateMessage(String? message) {
    return (message ?? '').trim().isNotEmpty ? null : locales.invalidMessage;
  }

  /// Validates that the end of the period is after its start.
  String? validatePeriod() {
    var from = announcement.validFrom;
    var to = announcement.validTo;
    return from != null && to != null && !to.isAfter(from)
        ? locales.invalidPeriod
        : null;
  }

  /// Sets the [severity] of the announcement.
  void setSeverity(int severity) {
    announcement.severity = severity;
    notifyListeners();
  }

  /// Limits the validity to a period starting now for one day or removes the
  /// period, so the announcement is valid until it is deleted.
  void setHasPeriod(bool value) {
    var now = DateTime.now();
    announcement.validFrom = value ? now : null;
    announcement.validTo = value ? now.add(const Duration(days: 1)) : null;
    notifyListeners();
  }

  /// Sets the start of the period.
  void setValidFrom(DateTime? value) {
    announcement.validFrom = value;
    notifyListeners();
  }

  /// Sets the end of the period.
  void setValidTo(DateTime? value) {
    announcement.validTo = value;
    notifyListeners();
  }

  /// Loads all groups from the server.
  Future<ModelList> getGroups() {
    return GroupService.getInstance().getMediaGroups(null, 0, -1);
  }

  /// Saves the announcement and closes the dialog.
  void save() async {
    var nav = Navigator.of(_context);

    showProgressIndicator();

    if (!loadedSuccessfully ||
        !formKey.currentState!.validate() ||
        validatePeriod() != null) {
      RouterService.getInstance().navigatorKey.currentState!.pop();
      return;
    }

    formKey.currentState!.save();

    var shouldClose = false;
    try {
      await _service.update(announcement);
      shouldClose = true;
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.notFound) {
        var messenger = MessengerService.getInstance();
        messenger.showMessage(messenger.notFound);
        shouldClose = true;
      }
    } finally {
      RouterService.getInstance().navigatorKey.currentState!.pop();

      if (shouldClose) {
        nav.pop(true);
      }
    }
  }
}
