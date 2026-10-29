import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/record_sync_state.dart';
import 'package:mml_admin/models/model_base.dart';

/// A synchronization state which can be selected in filters.
class SyncStateOption extends ModelBase {
  /// The state, see [RecordSyncState].
  final int state;

  /// Locales used for the name of the state.
  final AppLocalizations locales;

  /// Initializes the option.
  SyncStateOption(this.state, this.locales);

  @override
  String getDisplayDescription() {
    switch (state) {
      case RecordSyncState.received:
        return locales.syncStateReceived;
      case RecordSyncState.sent:
        return locales.syncStateSent;
      case RecordSyncState.problem:
        return locales.syncStateProblem;
      case RecordSyncState.pending:
        return locales.syncStatePending;
      default:
        return locales.syncStateNone;
    }
  }

  @override
  dynamic getIdentifier() {
    return state;
  }
}
