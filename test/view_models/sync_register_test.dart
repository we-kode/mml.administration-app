import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/l10n/admin_app_localizations.dart';
import 'package:mml_admin/view_models/sync/register.dart';

void main() {
  final locales = lookupAppLocalizations(const Locale('en'));
  final vm = PeerRegisterViewModel();

  test('accepts https urls only', () {
    expect(vm.validateUrl('https://beta.example.org', locales), isNull);
    expect(vm.validateUrl(' https://beta.example.org:8443 ', locales), isNull);
    expect(vm.validateUrl('http://beta.example.org', locales), isNotNull);
    expect(vm.validateUrl('beta.example.org', locales), isNotNull);
    expect(vm.validateUrl('', locales), isNotNull);
  });

  test('accepts invitation codes with or without separators', () {
    expect(vm.validateCode('ABCDE-FGHJK-MNPQR-STVWX', locales), isNull);
    expect(vm.validateCode('abcdefghjkmnpqrstvwx', locales), isNull);
    expect(vm.validateCode('ABCDE-FGHJK', locales), isNotNull);
    expect(vm.validateCode('ABCDE FGHJK MNPQR STVWX', locales), isNotNull);
  });
}
