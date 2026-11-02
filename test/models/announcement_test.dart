import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mml_admin/models/announcement.dart';
import 'package:mml_admin/models/model_list.dart';
import 'package:mml_admin/services/announcements.dart';
import 'package:mml_admin/view_models/announcements/overview.dart';

class FakeAnnouncementService implements AnnouncementService {
  final int? statusCode;

  FakeAnnouncementService([this.statusCode]);

  @override
  Future<ModelList> get(String? filter, int? offset, int? take) async {
    if (statusCode != null) {
      throw DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: statusCode,
        ),
      );
    }
    return ModelList([], 0, 0);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('sends the period in UTC and omits missing dates', () {
    final local = DateTime(2026, 11, 2, 10);
    final json = Announcement(
      title: 'T',
      message: 'M',
      validTo: local,
    ).toJson();

    expect(json['validTo'], local.toUtc().toIso8601String());
    expect(json.containsKey('validFrom'), isFalse);
    expect(json.containsKey('updatedAt'), isFalse);
    expect(json['severity'], 1);
  });

  test('is active only within its period', () {
    final now = DateTime(2026, 11, 2, 12);
    expect(Announcement().isActive(now), isTrue);
    expect(
      Announcement(
        validFrom: now.subtract(const Duration(hours: 1)),
        validTo: now.add(const Duration(hours: 1)),
      ).isActive(now),
      isTrue,
    );
    expect(
      Announcement(
        validTo: now.subtract(const Duration(minutes: 1)),
      ).isActive(now),
      isFalse,
    );
    expect(
      Announcement(
        validFrom: now.add(const Duration(minutes: 1)),
      ).isActive(now),
      isFalse,
    );
  });

  test('marks announcements as unsupported on servers without them', () async {
    final vm = AnnouncementsViewModel(service: FakeAnnouncementService(404));
    await vm.init();
    expect(vm.isSupported, isFalse);
  });

  test('keeps announcements supported on other errors', () async {
    final vm = AnnouncementsViewModel(service: FakeAnnouncementService(500));
    await vm.init();
    expect(vm.isSupported, isTrue);

    final supported = AnnouncementsViewModel(
      service: FakeAnnouncementService(),
    );
    await supported.init();
    expect(supported.isSupported, isTrue);
  });
}
