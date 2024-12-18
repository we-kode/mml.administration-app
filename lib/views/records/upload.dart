import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/components/uploading_animation.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/records/upload.dart';
import 'package:provider/provider.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';

/// View of the upload dialog for records.
class RecordUploadDialog extends StatelessWidget {
  /// The path of the folder from where files should be uploaded or null if single files will be uploaded.
  final String? folderPath;

  /// List of files which should be uploaded or null if files from a whole folder will be uploaded.
  final List<PlatformFile>? files;

  /// Initializes the view for the records upload dialog.
  const RecordUploadDialog({
    super.key,
    required this.folderPath,
    required this.files,
  });

  /// Builds the records upload dialog.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordsUploadDialogViewModel>(
      create: (context) => RecordsUploadDialogViewModel(),
      builder: (context, _) {
        var vm =
            Provider.of<RecordsUploadDialogViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(
            locales.uploading,
          ),
          content: FutureBuilder(
            future: vm.init(context, folderPath, files),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              }

              return snapshot.data!
                  ? _createUploadContent(context, vm)
                  : Container();
            },
          ),
          actions: _createActions(context, vm),
        );
      },
    );
  }

  /// Creates the upload content that should be shown in the dialog.
  Widget _createUploadContent(
      BuildContext context, RecordsUploadDialogViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer<RecordsUploadDialogViewModel>(
          builder: (context, value, child) {
            return value.state == UploadProcessState.groups
                ? Column(
                    children: [
                      Text(
                        vm.locales.selectGroups,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      verticalSpacer,
                      ChipChoices(
                        loadData: vm.getGroups,
                        initialSelectedItems: vm.selectedGroups,
                        onSelectionChanged: (selectableItems) =>
                            vm.selectedGroups = selectableItems
                                .map(
                                  (e) => e as Group,
                                )
                                .toList(),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: value.uploadedFiles == value.fileCount
                        ? _uploadFinishedTile(value)
                        : _uploadProgressTile(
                            value,
                            context,
                          ),
                  );
          },
        ),
      ],
    );
  }

  /// Creates a list of action widgets that should be shown at the bottom of the dialog.
  List<Widget> _createActions(
    BuildContext context,
    RecordsUploadDialogViewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<RecordsUploadDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.state != UploadProcessState.groups &&
                    value.uploadedFiles == value.fileCount
                ? null
                : () => Navigator.pop(context, false),
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<RecordsUploadDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.state == UploadProcessState.groups
                ? value.initUpload
                : value.uploadedFiles == value.fileCount
                    ? () => Navigator.pop(context, true)
                    : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }

  /// Returns the uploading progress content.
  List<Widget> _uploadProgressTile(
    RecordsUploadDialogViewModel vm,
    BuildContext context,
  ) {
    return [
      const SizedBox(
        height: 256,
        width: 256,
        child: UploadAnimation(),
      ),
      Row(
        children: [
          Text(
            vm.uploadingFileName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          Text(
            vm.uploadedFiles.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            '/',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            vm.fileCount.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    ];
  }

  /// Returns the result text when upload finished.
  List<Widget> _uploadFinishedTile(RecordsUploadDialogViewModel vm) {
    return [
      Text(vm.locales.uploadFinished),
      verticalSpacer,
      if (vm.notUploadedFiles.isNotEmpty) Text(vm.locales.notUploadedFiles),
      if (vm.notUploadedFiles.isNotEmpty)
        SizedBox(
          height: 500,
          width: 500, // Constrain height.
          child: ListView.separated(
            itemCount: vm.notUploadedFiles.length,
            itemBuilder: (BuildContext context, int index) {
              return ExpansionTile(
                title: Text(
                  vm.notUploadedFiles.keys.elementAt(index),
                ),
                children: [
                  SizedBox(
                    height: 100,
                    width: 400,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int iIndex) {
                        return ListTile(
                          title: Text(
                            vm.localizeError(
                              vm.notUploadedFiles[vm.notUploadedFiles.keys
                                  .elementAt(index)]![iIndex],
                            ),
                          ),
                        );
                      },
                      itemCount: vm
                          .notUploadedFiles[
                              vm.notUploadedFiles.keys.elementAt(index)]
                          ?.length,
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
    ];
  }
}
