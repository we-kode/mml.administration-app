import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mml_admin/components/async_list_view.dart';
import 'package:mml_admin/models/id3_tag_filter.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/models/record_folder.dart';
import 'package:mml_admin/models/subfilter.dart';
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

        return FutureBuilder(
          future: vm.init(context),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return AsyncListView(
              subfilter: RecordTagFilter(
                isFolderView: vm.isFolderView,
              ),
              navState: vm.navigationState,
              moveUp: (subFilter) {
                vm.moveFolderUp(subFilter as ID3TagFilter);
                vm.navigationState.path = RecordFolder.fromDate(
                  subFilter.startDate,
                  subFilter.endDate,
                )?.getIdentifier();
              },
              subactions: [
                ActionButton(
                  icon: const Icon(Icons.drive_folder_upload),
                  onPressed: () async {
                    String? selected =
                        await FilePicker.platform.getDirectoryPath(
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
              deleteItems: <ModelBase>(List<ModelBase> items) => vm.delete(
                items,
                context,
              ),
              editItem: (ModelBase item, Subfilter? subfilter) async {
                if (item is RecordFolder) {
                  vm.navigationState.path = item.getIdentifier();
                  (subfilter as ID3TagFilter)[ID3TagFilters.date] =
                      DateTimeRange(
                    start: DateTime(
                      item.year,
                      item.month ?? 1,
                      item.day ?? 1,
                    ),
                    end: DateTime(
                      item.year,
                      item.month ?? 12,
                      item.day ??
                          DateUtils.getDaysInMonth(
                            item.year,
                            item.month ?? 12,
                          ),
                    ),
                  );
                  return true;
                }

                return await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return RecordEditDialog(
                      recordId: (item as Record).recordId,
                    );
                  },
                );
              },
              loadData: ({
                String? filter,
                int? offset,
                int? take,
                dynamic subfilter,
              }) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    if (!(subfilter as ID3TagFilter).isGrouped) {
                      vm.navigationState.path = null;
                    }
                  },
                );

                return vm.load(
                  filter: filter,
                  offset: offset,
                  take: take,
                  subfilter: subfilter,
                );
              },
            );
          },
        );
      },
    );
  }
}
