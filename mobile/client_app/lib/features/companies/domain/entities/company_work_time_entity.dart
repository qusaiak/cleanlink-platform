import 'package:equatable/equatable.dart';

class CompanyWorkTimeEntity extends Equatable {
  final int id;
  final int companyId;
  final int dayOfWeek;
  final String? openAt;
  final String? closeAt;
  final bool isHoliday;

  const CompanyWorkTimeEntity({
    required this.id,
    required this.companyId,
    required this.dayOfWeek,
    required this.openAt,
    required this.closeAt,
    required this.isHoliday,
  });

  @override
  List<Object?> get props => [
    id,
    companyId,
    dayOfWeek,
    openAt,
    closeAt,
    isHoliday,
  ];
}
