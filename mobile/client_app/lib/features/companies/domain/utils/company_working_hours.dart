import '../entities/company_work_time_entity.dart';

class CompanyTimeParts {
  final int hour;
  final int minute;
  final int second;

  const CompanyTimeParts({
    required this.hour,
    required this.minute,
    required this.second,
  });

  int get secondsSinceMidnight => hour * 3600 + minute * 60 + second;
}

int backendWeekday(DateTime dateTime) => dateTime.weekday % 7;

CompanyWorkTimeEntity? getCompanyWorkTimeForDay(
  List<CompanyWorkTimeEntity> workTimes,
  int dayOfWeek,
) {
  for (final workTime in workTimes) {
    if (workTime.dayOfWeek == dayOfWeek) return workTime;
  }
  return null;
}

CompanyWorkTimeEntity? getTodayCompanyWorkTime(
  List<CompanyWorkTimeEntity> workTimes, {
  DateTime? now,
}) =>
    getCompanyWorkTimeForDay(workTimes, backendWeekday(now ?? DateTime.now()));

CompanyTimeParts? parseCompanyTime(String? value) {
  if (value == null) return null;
  final parts = value.trim().split(':');
  if (parts.length < 2 || parts.length > 3) return null;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  final second = parts.length == 3 ? int.tryParse(parts[2]) : 0;
  if (hour == null ||
      minute == null ||
      second == null ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59 ||
      second < 0 ||
      second > 59) {
    return null;
  }

  return CompanyTimeParts(hour: hour, minute: minute, second: second);
}

bool isCompanyCurrentlyOpen(
  List<CompanyWorkTimeEntity> workTimes, {
  DateTime? now,
}) {
  final localNow = now ?? DateTime.now();
  final today = getTodayCompanyWorkTime(workTimes, now: localNow);
  if (today == null || today.isHoliday) return false;

  final opening = parseCompanyTime(today.openAt);
  final closing = parseCompanyTime(today.closeAt);
  if (opening == null || closing == null) return false;

  final currentSeconds =
      localNow.hour * 3600 + localNow.minute * 60 + localNow.second;
  final openingSeconds = opening.secondsSinceMidnight;
  final closingSeconds = closing.secondsSinceMidnight;

  if (openingSeconds < closingSeconds) {
    return currentSeconds >= openingSeconds && currentSeconds < closingSeconds;
  }
  if (openingSeconds > closingSeconds) {
    return currentSeconds >= openingSeconds || currentSeconds < closingSeconds;
  }
  return false;
}
