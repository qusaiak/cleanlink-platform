import 'package:client_app/features/companies/domain/entities/company_work_time_entity.dart';
import 'package:client_app/features/companies/domain/utils/company_working_hours.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CompanyWorkTimeEntity schedule({
    int day = 1,
    String? openAt = '08:00:00',
    String? closeAt = '16:00:00',
    bool holiday = false,
  }) => CompanyWorkTimeEntity(
    id: 1,
    companyId: 1,
    dayOfWeek: day,
    openAt: openAt,
    closeAt: closeAt,
    isHoliday: holiday,
  );

  test('maps Dart Sunday to backend day zero', () {
    final sunday = DateTime(2026, 7, 19, 10);
    expect(backendWeekday(sunday), 0);
    expect(isCompanyCurrentlyOpen([schedule(day: 0)], now: sunday), isTrue);
  });

  test('is open during a normal shift', () {
    expect(
      isCompanyCurrentlyOpen([schedule()], now: DateTime(2026, 7, 20, 12)),
      isTrue,
    );
  });

  test('is closed before opening', () {
    expect(
      isCompanyCurrentlyOpen([schedule()], now: DateTime(2026, 7, 20, 7, 59)),
      isFalse,
    );
  });

  test('is closed exactly at closing', () {
    expect(
      isCompanyCurrentlyOpen([schedule()], now: DateTime(2026, 7, 20, 16)),
      isFalse,
    );
  });

  test('is closed on a holiday', () {
    expect(
      isCompanyCurrentlyOpen([
        schedule(holiday: true),
      ], now: DateTime(2026, 7, 20, 12)),
      isFalse,
    );
  });

  test('is closed when today schedule is missing', () {
    expect(
      isCompanyCurrentlyOpen([
        schedule(day: 2),
      ], now: DateTime(2026, 7, 20, 12)),
      isFalse,
    );
  });

  test('is closed when opening or closing is null', () {
    expect(
      isCompanyCurrentlyOpen([
        schedule(openAt: null),
      ], now: DateTime(2026, 7, 20, 12)),
      isFalse,
    );
    expect(
      isCompanyCurrentlyOpen([
        schedule(closeAt: null),
      ], now: DateTime(2026, 7, 20, 12)),
      isFalse,
    );
  });

  test('supports an overnight shift before midnight', () {
    expect(
      isCompanyCurrentlyOpen([
        schedule(openAt: '20:00:00', closeAt: '02:00:00'),
      ], now: DateTime(2026, 7, 20, 23)),
      isTrue,
    );
  });

  test('supports an overnight shift after midnight', () {
    expect(
      isCompanyCurrentlyOpen([
        schedule(openAt: '20:00:00', closeAt: '02:00:00'),
      ], now: DateTime(2026, 7, 20, 1)),
      isTrue,
    );
  });

  test('malformed time text is closed', () {
    expect(
      isCompanyCurrentlyOpen([
        schedule(openAt: 'not-a-time'),
      ], now: DateTime(2026, 7, 20, 12)),
      isFalse,
    );
  });
}
