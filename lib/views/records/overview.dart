import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/views/records/edit.dart';
import 'package:mml_admin/views/records/record_tag_filter.dart';
import 'package:mml_admin/components/expandable_fab.dart';
import 'package:mml_admin/models/model_base.dart';
import 'package:mml_admin/view_models/records/overview.dart';
import 'package:mml_admin/views/records/upload.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// Overview screen of the uploaded records to the music lib.
class RecordsScreen extends StatelessWidget {
  /// Initializes the instance.
  const RecordsScreen({Key? key}) : super(key: key);

  /// Builds the records overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordsViewModel>(
      create: (context) => RecordsViewModel(),
      builder: (context, _) {
        var vm = Provider.of<RecordsViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AsyncListView(
          subfilter: RecordTagFilter(),
          subactions: [
            ActionButton(
              icon: const Icon(Icons.drive_folder_upload),
              onPressed: () async {
                String? selected = await FilePicker.platform.getDirectoryPath(
                  lockParentWindow: true,
                  dialogTitle: locales.uploadFolder,
                );
                if (selected == null) {
                  return;
                }

                return await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return RecordUploadDialog(
                      folderPath: selected,
                      files: const [],
                    );
                  },
                );
              },
            ),
            ActionButton(
              icon: const Icon(Icons.file_upload),
              onPressed: () async {
                FilePickerResult? selected =
                    await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: ['mp3'],
                  dialogTitle: locales.uploadFiles,
                );

                if (selected == null) {
                  return;
                }

                return await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return RecordUploadDialog(
                      folderPath: null,
                      files: selected.files,
                    );
                  },
                );
              },
            ),
          ],
          deleteItems: <String>(List<String> recordIds) => vm.delete(
            recordIds,
            context,
          ),
          editItem: (ModelBase record) async {
            return await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return RecordEditDialog(
                  recordId: (record as Record).recordId,
                );
              },
            );
          },
          loadData: vm.load,
        );
      },
    );
  }
}
