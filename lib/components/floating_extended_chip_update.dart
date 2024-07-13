import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:updat/updat.dart';

/// Creates a update button with extended information about version and changelog. User can decide by it`s own, when to
/// downlaod and install the update.
Widget floatingExtendedChipUpdate({
  required BuildContext context,
  required String? latestVersion,
  required String appVersion,
  required UpdatStatus status,
  required void Function() checkForUpdate,
  required void Function() openDialog,
  required void Function() startUpdate,
  required Future<void> Function() launchInstaller,
  required void Function() dismissUpdate,
}) {
  final locales = AppLocalizations.of(context)!;

  if (status == UpdatStatus.readyToInstall) {
    launchInstaller();
  }

  if (status != UpdatStatus.available &&
      status != UpdatStatus.availableWithChangelog &&
      status != UpdatStatus.downloading) {
    return Container();
  }

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locales.newUpdate,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            locales.newVersion(latestVersion ?? appVersion),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            locales.oldVersion(appVersion),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: openDialog,
            child: Text(
              locales.checkUpdate,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              if (status != UpdatStatus.downloading)
                TextButton(
                  onPressed: dismissUpdate,
                  child: Text(locales.later),
                ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed:
                    status == UpdatStatus.downloading ? null : startUpdate,
                icon: Icon(status == UpdatStatus.downloading
                    ? Symbols.downloading
                    : Symbols.install_desktop),
                label: Text(
                  status == UpdatStatus.downloading
                      ? locales.downloading
                      : locales.updateInstall,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
