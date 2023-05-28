import 'package:flutter/material.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/records/edit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

/// Edit screen of the record of the music lib.
class RecordEditDialog extends StatelessWidget {
  /// Id of the record to be edited.
  final String? recordId;

  /// Initializes the instance.
  const RecordEditDialog({Key? key, required this.recordId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordEditViewModel>(
      create: (context) => RecordEditViewModel(),
      builder: (context, _) {
        var vm = Provider.of<RecordEditViewModel>(context, listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(locales.editRecord),
          content: FutureBuilder(
            future: vm.init(context, recordId),
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
                  ? _createEditForm(context, vm)
                  : Container();
            },
          ),
          actions: _createActions(context, vm),
        );
      },
    );
  }

  /// Creates the edit form that should be shown in the dialog.
  Widget _createEditForm(BuildContext context, RecordEditViewModel vm) {
    return Form(
      key: vm.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: vm.record.title,
            decoration: InputDecoration(
              labelText: vm.locales.title,
              errorMaxLines: 5,
            ),
            onSaved: (String? title) {
              vm.record.title = title!;
            },
            onChanged: (String? title) {
              vm.record.title = title;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: vm.validateTitle,
          ),
          verticalSpacer,
          TextFormField(
            initialValue: vm.record.artist,
            decoration: InputDecoration(
              labelText: vm.locales.artist,
              errorMaxLines: 5,
            ),
            onSaved: (String? artist) {
              vm.record.artist = artist;
            },
            onChanged: (String? artist) {
              vm.record.artist = artist;
            },
          ),
          verticalSpacer,
          TextFormField(
            initialValue: vm.record.album,
            decoration: InputDecoration(
              labelText: vm.locales.album,
              errorMaxLines: 5,
            ),
            onSaved: (String? album) {
              vm.record.album = album;
            },
            onChanged: (String? album) {
              vm.record.album = album;
            },
          ),
          verticalSpacer,
          TextFormField(
            initialValue: vm.record.genre,
            decoration: InputDecoration(
              labelText: vm.locales.genre,
              errorMaxLines: 5,
            ),
            onSaved: (String? genre) {
              vm.record.genre = genre;
            },
            onChanged: (String? genre) {
              vm.record.genre = genre;
            },
          ),
          verticalSpacer,
          TextFormField(
            initialValue: vm.record.language,
            decoration: InputDecoration(
              labelText: vm.locales.language,
              errorMaxLines: 5,
            ),
            onSaved: (String? language) {
              vm.record.language = language;
            },
            onChanged: (String? language) {
              vm.record.language = language;
            },
          ),
          verticalSpacer,
          Text(
            vm.locales.groups,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          verticalSpacer,
          ChipChoices(
            loadData: vm.getGroups,
            initialSelectedItems: vm.record.groups,
            onSelectionChanged: (selecteItems) =>
                vm.record.groups = selecteItems
                    .map(
                      (e) => e as Group,
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  /// Creates a list of action widgets that should be shown at the bottom of the
  /// edit dialog.
  List<Widget> _createActions(BuildContext context, RecordEditViewModel vm) {
    var locales = AppLocalizations.of(context)!;

    return [
      Consumer<RecordEditViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.loadedSuccessfully
                ? () => Navigator.pop(context, false)
                : null,
            child: Text(locales.cancel),
          );
        },
      ),
      Consumer<RecordEditViewModel>(
        builder: (context, value, child) {
          return TextButton(
            onPressed: value.loadedSuccessfully ? vm.saveRecord : null,
            child: Text(locales.save),
          );
        },
      ),
    ];
  }
}
