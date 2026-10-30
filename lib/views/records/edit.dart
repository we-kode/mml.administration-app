import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mml_admin/components/chip_choices.dart';
import 'package:mml_admin/components/vertical_spacer.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/sync_direction.dart';
import 'package:mml_admin/models/federation/transfer_progress.dart';
import 'package:mml_admin/models/group.dart';
import 'package:mml_admin/view_models/records/edit.dart';
import 'package:provider/provider.dart';

/// Edit screen of the record of the music lib.
class RecordEditDialog extends StatelessWidget {
  /// Id of the record to be edited.
  final String? recordId;

  /// Initializes the instance.
  const RecordEditDialog({super.key, required this.recordId});

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
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [CircularProgressIndicator()],
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: Container(
                  height: 200,
                  width: 200,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: vm.record.getAvatar(context),
                ),
              ),
            ),
            if (!vm.isEditable)
              ListTile(
                leading: const Icon(Symbols.warning),
                title: Text(vm.locales.notOwned(vm.record.ownerInstance)),
              ),
            TextFormField(
              onFieldSubmitted: (_) => vm.saveRecord(),
              enabled: vm.isEditable,
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
              onFieldSubmitted: (_) => vm.saveRecord(),
              enabled: vm.isEditable,
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
              onFieldSubmitted: (_) => vm.saveRecord(),
              enabled: vm.isEditable,
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
              onFieldSubmitted: (_) => vm.saveRecord(),
              enabled: vm.isEditable,
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
              onFieldSubmitted: (_) => vm.saveRecord(),
              enabled: vm.isEditable,
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
            ListTile(
              title: Text(vm.locales.makeUndeletable),
              trailing: Consumer<RecordEditViewModel>(
                builder: (context, vm, _) {
                  return Switch(
                    value: vm.record.locked ?? false,
                    onChanged: (value) => vm.lock(),
                  );
                },
              ),
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
              onSelectionChanged: (selectableItems) => vm.record.groups =
                  selectableItems.map((e) => e as Group).toList(),
            ),
            verticalSpacer,
            Consumer<RecordEditViewModel>(
              builder: (context, vm, _) => _createSyncSection(context, vm),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates the synchronization section: the origin of a received record or
  /// the partners an own record was sent to and the problems. The details are
  /// collapsed, since the list can be long.
  Widget _createSyncSection(BuildContext context, RecordEditViewModel vm) {
    var format = DateFormat.yMd().add_Hm();
    var problems = vm.sync.problems
        .map(
          (problem) => ListTile(
            dense: true,
            leading: Icon(
              Symbols.sync_problem,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(vm.locales.syncProblemWith(problem.instance)),
            subtitle: Text(
              [
                if (problem.error?.isNotEmpty ?? false) problem.error!,
                problem.failed || problem.nextAttemptAt == null
                    ? vm.locales.syncProblemFailed
                    : vm.locales.syncProblemRetry(
                        format.format(problem.nextAttemptAt!.toLocal()),
                      ),
              ].join('\n'),
            ),
          ),
        )
        .toList();

    if (!vm.isEditable) {
      var received = vm.sync.links
          .where((link) => link.direction == SyncDirection.incoming)
          .firstOrNull;
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(SyncDirection.icon(SyncDirection.incoming)),
        title: Text(vm.locales.receivedFrom(vm.record.ownerInstance)),
        subtitle: received != null
            ? Text(format.format(received.syncedAt.toLocal()))
            : null,
      );
    }

    var sent = vm.sync.links
        .where((link) => link.direction == SyncDirection.outgoing)
        .map(
          (link) => ListTile(
            dense: true,
            leading: Icon(SyncDirection.icon(SyncDirection.outgoing)),
            title: Text(link.instance ?? ''),
            subtitle: Text(format.format(link.syncedAt.toLocal())),
          ),
        )
        .toList();
    var transfers = vm.sync.transfers.map((transfer) {
      var fraction = transferFraction(transfer.transferred, transfer.size);
      return ListTile(
        dense: true,
        leading: const Icon(Symbols.sync),
        title: Text(transfer.instance),
        subtitle: fraction == null
            ? Text(
                vm.locales.transferWaiting(
                  format.format(transfer.nextAttemptAt.toLocal()),
                ),
              )
            : LinearProgressIndicator(value: fraction),
        trailing: fraction == null
            ? null
            : Text(vm.locales.transferPercent((fraction * 100).floor())),
      );
    }).toList();
    var exclusions = vm.sync.exclusions
        .map(
          (exclusion) => ListTile(
            dense: true,
            leading: const Icon(Symbols.sync_disabled),
            title: Text(exclusion.instance),
            subtitle: Text(
              vm.locales.syncRevokedAt(
                format.format(exclusion.createdAt.toLocal()),
              ),
            ),
          ),
        )
        .toList();
    var button = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (vm.sentTo.isNotEmpty)
          IconButton(
            onPressed: vm.revokeSync,
            icon: const Icon(Symbols.sync_disabled),
            tooltip: vm.locales.revokeSync,
          ),
        IconButton(
          onPressed: vm.synchronize,
          icon: const Icon(Symbols.sync),
          tooltip: vm.locales.synchronize,
        ),
      ],
    );
    var title = Text(vm.locales.syncState);

    if (sent.isEmpty &&
        problems.isEmpty &&
        transfers.isEmpty &&
        exclusions.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: title,
        trailing: button,
      );
    }

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      shape: const Border(),
      collapsedShape: const Border(),
      controlAffinity: ListTileControlAffinity.leading,
      title: title,
      subtitle: Text(
        [
          if (sent.isNotEmpty) vm.locales.syncSentCount(sent.length),
          if (transfers.isNotEmpty)
            vm.locales.syncPendingCount(transfers.length),
          if (problems.isNotEmpty) vm.locales.syncProblemCount(problems.length),
          if (exclusions.isNotEmpty)
            vm.locales.syncRevokedCount(exclusions.length),
        ].join(' · '),
      ),
      trailing: button,
      children: [...problems, ...transfers, ...sent, ...exclusions],
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
