import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/view_models/records/upload.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// View of the upload dialog for records.
class RecordUploadDialog extends StatelessWidget {
  /// The path of the folder from where files should be uploaded or null if single files will be uplaoded.
  final String? folderPath;

  /// List of files which should be uploaded or null if files from a whole folder will be uploaded.
  final List<PlatformFile>? files;

  /// Initializes the view for the records upload dialog.
  const RecordUploadDialog({
    Key? key,
    required this.folderPath,
    required this.files,
  }) : super(key: key);

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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
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
            return Row(
              children: value.uploadedFiles == value.fileCount
                  ? [Text(vm.locales.uploadFinished)]
                  : _uploadProgressTile(value),
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
            onPressed: value.uploadedFiles == value.fileCount
                ? null
                : () => Navigator.pop(context, false),
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<RecordsUploadDialogViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.uploadedFiles == value.fileCount
                ? () => Navigator.pop(context, true)
                : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }

  /// Returns the uplaoding progress content.
  List<Widget> _uploadProgressTile(RecordsUploadDialogViewModel vm) {
    return [
      Text(vm.uploadingFileName),
      const Spacer(),
      Text(vm.uploadedFiles.toString()),
      const Text("/"),
      Text(vm.fileCount.toString())
    ];
  }
}
