enum ReviewableType { service, company }

extension ReviewableTypeApiValue on ReviewableType {
  String get apiValue => switch (this) {
    ReviewableType.service => 'service',
    ReviewableType.company => 'company',
  };
}
