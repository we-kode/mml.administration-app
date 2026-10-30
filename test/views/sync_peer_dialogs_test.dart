import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/models/federation/peer.dart';
import 'package:mml_admin/models/federation/peer_state.dart';
import 'package:mml_admin/views/sync/unlink.dart';

void main() {
  final locales = lookupAppLocalizations(const Locale('en'));
  final peers = [
    Peer(
      peerId: 'p1',
      instance: 'beta',
      baseUrl: 'https://beta.example',
      state: PeerState.linked,
    ),
    Peer(
      peerId: 'p2',
      instance: 'gamma',
      baseUrl: 'https://gamma.example',
      state: PeerState.linked,
    ),
  ];

  Future<void> open(
    WidgetTester tester,
    Future<void> Function(BuildContext) show,
  ) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => show(context),
            child: const Text('open'),
          ),
        ),
      ),
    );
  }

  testWidgets('selects all partners initially and single partners', (
    tester,
  ) async {
    List<String>? result;
    await open(
      tester,
      (context) async => result = await showPeerSelectionDialog(
        context,
        peers,
        title: locales.revokeSync,
        action: locales.revokeSync,
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(locales.allInstances));
    await tester.pumpAndSettle();
    var confirm = find.widgetWithText(TextButton, locales.revokeSync);
    expect(tester.widget<TextButton>(confirm).onPressed, isNull);

    await tester.tap(find.text('gamma'));
    await tester.pumpAndSettle();
    await tester.tap(confirm);
    await tester.pumpAndSettle();

    expect(result, ['p2']);
  });

  testWidgets('cancel returns no selection', (tester) async {
    List<String>? result = [];
    await open(
      tester,
      (context) async => result = await showPeerSelectionDialog(
        context,
        peers,
        title: locales.synchronize,
        action: locales.synchronize,
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(locales.cancel));
    await tester.pumpAndSettle();

    expect(result, isNull);
  });

  testWidgets('accepts only https addresses', (tester) async {
    String? result;
    await open(
      tester,
      (context) async => result = await showAddressDialog(
        context,
        'beta',
        'https://beta.example',
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'http://beta.new');
    await tester.tap(find.text(locales.save));
    await tester.pumpAndSettle();
    expect(find.text(locales.federationInvalidUrl), findsOneWidget);
    expect(result, isNull);

    await tester.enterText(find.byType(TextFormField), ' https://beta.new ');
    await tester.tap(find.text(locales.save));
    await tester.pumpAndSettle();
    expect(result, 'https://beta.new');
  });

  testWidgets('enter submits the address only when valid', (tester) async {
    String? result;
    await open(
      tester,
      (context) async => result = await showAddressDialog(
        context,
        'beta',
        'https://beta.example',
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'http://beta.new');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text(locales.federationInvalidUrl), findsOneWidget);
    expect(result, isNull);

    await tester.enterText(find.byType(TextFormField), 'https://beta.new');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(result, 'https://beta.new');
  });
}
