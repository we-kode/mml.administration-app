import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mml_admin/models/federation/audit_status.dart';
import 'package:mml_admin/models/federation/record_sync_state.dart';
import 'package:mml_admin/models/record.dart';
import 'package:mml_admin/services/federation.dart';
import 'package:mml_admin/services/federation_events.dart';

/// Shows the progress of the transfers of a record to partners, which is
/// updated with the federation events of the server. When a transfer is
/// finished, the indicator shows the new synchronization state of the record.
class TransferIndicator extends StatefulWidget {
  /// The record being sent.
  final Record record;

  /// Tooltip of the indicator.
  final String message;

  /// Icon shown within the progress.
  final IconData icon;

  /// Creates the icon of a synchronization state other than pending.
  final Widget? Function(BuildContext context) stateIcon;

  /// Initializes the indicator.
  const TransferIndicator({
    super.key,
    required this.record,
    required this.message,
    required this.icon,
    required this.stateIcon,
  });

  @override
  State<TransferIndicator> createState() => _TransferIndicatorState();
}

class _TransferIndicatorState extends State<TransferIndicator> {
  final Map<String, double> _fractions = {};
  StreamSubscription<FederationEvent>? _events;

  @override
  void initState() {
    super.initState();
    _events = FederationEventService.getInstance().events.listen(_onEvent);
  }

  @override
  void dispose() {
    _events?.cancel();
    super.dispose();
  }

  void _onEvent(FederationEvent event) {
    var progress = event.progress;
    if (progress != null && progress.recordId == widget.record.recordId) {
      setState(() => _fractions[progress.instance] = progress.fraction);
      return;
    }

    var entry = event.entry;
    if (entry != null &&
        entry.status != AuditStatus.pending &&
        entry.recordIds.contains(widget.record.recordId)) {
      _reloadState();
    }
  }

  // a record can be sent to several partners, so the state is loaded again
  // after each finished operation.
  Future<void> _reloadState() async {
    try {
      var sync = await FederationService.getInstance().getRecordSync(
        widget.record.recordId!,
      );
      if (mounted) {
        setState(() => widget.record.syncState = sync.ownState);
      }
    } catch (_) {
      // The progress is shown until the list is reloaded.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.record.syncState != RecordSyncState.pending) {
      return widget.stateIcon(context) ?? const SizedBox.shrink();
    }

    var colors = Theme.of(context).colorScheme;
    var value = _fractions.isEmpty
        ? null
        : _fractions.values.reduce((a, b) => a + b) / _fractions.length;
    return Tooltip(
      message: widget.message,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: value, strokeWidth: 2),
            Icon(widget.icon, size: 12, color: colors.primary),
          ],
        ),
      ),
    );
  }
}
