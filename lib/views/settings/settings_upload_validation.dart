import 'package:flutter/material.dart';
import 'package:mml_admin/models/record_validation.dart';
import 'package:mml_admin/view_models/settings/settings_upload_validation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/admin_app_localizations.dart';

class SettingsUploadValidationScreen extends StatelessWidget {
  /// Initializes the instance.
  const SettingsUploadValidationScreen({Key? key}) : super(key: key);

  /// Builds the clients overview screen.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsUploadValidationViewModel>(
      create: (context) => SettingsUploadValidationViewModel(),
      builder: (context, _) {
        var vm = Provider.of<SettingsUploadValidationViewModel>(context,
            listen: false);
        var locales = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(locales.uploadValidation),
          content: FutureBuilder(
            future: vm.init(context),
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
                  ? Form(
                      key: vm.uploadValidationSettingsKey,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _switchFormField(
                              vm,
                              vm.locales.uploadValidLanguage,
                              Icons.translate,
                              RecordValidationKeys.language,
                            ),
                            _switchFormField(
                              vm,
                              vm.locales.uploadValidTitle,
                              Icons.title,
                              RecordValidationKeys.title,
                            ),
                            _switchFormField(
                              vm,
                              vm.locales.uploadValidArtist,
                              Icons.person,
                              RecordValidationKeys.artist,
                            ),
                            _switchFormField(
                              vm,
                              vm.locales.uploadValidNumber,
                              Icons.tag,
                              RecordValidationKeys.number,
                            ),
                            _switchFormField(
                              vm,
                              vm.locales.uploadValidCover,
                              Icons.image_outlined,
                              RecordValidationKeys.cover,
                            ),
                            _switchFormField(
                              vm,
                              vm.locales.uploadValidAlbum,
                              Icons.library_music,
                              RecordValidationKeys.album,
                            ),
                            Consumer<SettingsUploadValidationViewModel>(
                              builder: (context, vm, _) {
                                return TextFormField(
                                  enabled: vm.model.isRequiredAlbum ?? false,
                                  decoration: InputDecoration(
                                    labelText: vm.locales.uploadValidAlbums,
                                    hintText: vm.locales.uploadValidAlbumInfo,
                                  ),
                                  initialValue: vm.model.albums ?? '',
                                  onSaved: (String? value) {
                                    vm.model.albums = value;
                                  },
                                  onChanged: (String? value) {
                                    vm.model.albums = value;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                );
                              },
                            ),
                            _switchFormField(
                              vm,
                              vm.locales.uploadValidGenre,
                              Icons.discount,
                              RecordValidationKeys.genre,
                            ),
                            Consumer<SettingsUploadValidationViewModel>(
                              builder: (context, vm, _) {
                                return TextFormField(
                                  enabled: vm.model.isRequiredGenre ??
                                      false, // Only if album active
                                  decoration: InputDecoration(
                                    labelText: vm.locales.uploadValidGenres,
                                    hintText: vm.locales.uploadValidGenreInfo,
                                  ),
                                  initialValue: vm.model.genres ?? '',
                                  onSaved: (String? value) {
                                    vm.model.genres = value;
                                  },
                                  onChanged: (String? value) {
                                    vm.model.genres = value;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                );
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: vm.locales.upladValidFilename,
                                hintText: vm.locales.uploadValidFilenameInfo,
                              ),
                              initialValue: vm.model.fileNameTemplate == null ||
                                      vm.model.fileNameTemplate!.isEmpty
                                  ? '(.*)'
                                  : vm.model.fileNameTemplate,
                              onSaved: (String? value) {
                                vm.model.fileNameTemplate =
                                    value == null || value.isEmpty
                                        ? '(.*)'
                                        : value;
                              },
                              onChanged: (String? value) {
                                vm.model.fileNameTemplate =
                                    value == null || value.isEmpty
                                        ? '(.*)'
                                        : value;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          ),
          actions: _createActions(context, vm),
        );
      },
    );
  }

  /// Creates a switch form field
  FormField<bool> _switchFormField(SettingsUploadValidationViewModel vm,
      String title, IconData icon, String modelValue) {
    return FormField<bool>(
      initialValue: vm.model[modelValue],
      builder: (FormFieldState<bool> field) {
        return InputDecorator(
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
            trailing: Consumer<SettingsUploadValidationViewModel>(
              builder: (context, vm, _) {
                return Switch(
                  onChanged: (value) => {
                    vm.update(modelValue, value),
                  },
                  value: vm.model[modelValue],
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Creates a list of action widgets that should be shown at the bottom of the
  /// edit dialog.
  List<Widget> _createActions(
    BuildContext context,
    SettingsUploadValidationViewModel vm,
  ) {
    var locales = AppLocalizations.of(context)!;

    return [
      TextButton(
        onPressed: vm.abort,
        child: Text(locales.cancel),
      ),
      TextButton(
        onPressed: vm.save,
        child: Text(locales.save),
      ),
    ];
  }
}
