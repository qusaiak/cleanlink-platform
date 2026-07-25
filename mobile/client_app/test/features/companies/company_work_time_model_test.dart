import 'package:client_app/features/companies/data/models/company_model.dart';
import 'package:client_app/features/companies/data/models/company_work_time_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> workTime(dynamic isHoliday) => {
    'id': 1,
    'company_id': 2,
    'day_of_week': 0,
    'open_at': '08:00:00',
    'close_at': '16:00:00',
    'is_holiday': isHoliday,
  };

  for (final value in [0, false, '0']) {
    test('maps is_holiday $value to false', () {
      expect(CompanyWorkTimeModel.fromJson(workTime(value)).isHoliday, isFalse);
    });
  }

  for (final value in [1, true, '1']) {
    test('maps is_holiday $value to true', () {
      expect(CompanyWorkTimeModel.fromJson(workTime(value)).isHoliday, isTrue);
    });
  }

  test('missing workTimes maps to an empty list', () {
    expect(CompanyModel.fromJson(const {}).workTimes, isEmpty);
  });

  test('null workTimes maps to an empty list', () {
    expect(CompanyModel.fromJson(const {'workTimes': null}).workTimes, isEmpty);
  });

  test('malformed working-time items are skipped', () {
    final company = CompanyModel.fromJson({
      'workTimes': [
        workTime(0),
        {'id': 'invalid'},
        {1: 'invalid-key'},
        'invalid',
      ],
    });
    expect(company.workTimes, hasLength(1));
  });
}
