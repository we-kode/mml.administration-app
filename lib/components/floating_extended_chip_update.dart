import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/app_update_status.dart';
import 'package:mml_admin/view_models/app_update.dart';
import 'package:provider/provider.dart';

/// Update card with extended information about version and changelog. The
/// user decides when to download and install the update.
class FloatingExtendedChipUpdate extends StatelessWidget {
  /// Initializes the instance.
  const FloatingExtendedChipUpdate({super.key});

  /// Builds the card while an update is available, downloading or its
  /// download failed.
  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.of(context)!;
    final vm = context.watch<AppUpdateViewModel>();
    final downloading = vm.status == AppUpdateStatus.downloading;
    final failed = vm.status == AppUpdateStatus.downloadFailed;

    if (vm.status != AppUpdateStatus.available && !downloading && !failed) {
      return const SizedBox.shrink();
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
              locales.newVersion(vm.latestVersion ?? vm.currentVersion),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              locales.oldVersion(vm.currentVersion),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(locales.newUpdate),
                  content: SizedBox(
                    width: 600,
                    child: SingleChildScrollView(
                      child: SelectableText(vm.changelog),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(locales.close),
                    ),
                  ],
                ),
              ),
              child: Text(
                locales.checkUpdate,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (failed) ...[
              const SizedBox(height: 8),
              Text(
                locales.updateDownloadFailed,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 15),
            Row(
              children: [
                if (!downloading)
                  TextButton(onPressed: vm.dismiss, child: Text(locales.later)),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: downloading ? null : vm.startUpdate,
                  icon: Icon(
                    downloading ? Symbols.downloading : Symbols.install_desktop,
                  ),
                  label: Text(
                    downloading ? locales.downloading : locales.updateInstall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
