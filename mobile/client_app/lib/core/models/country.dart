class Country {
  final String name;
  final String nameAr;
  final String code;
  final String dialCode;

  const Country({
    required this.name,
    required this.nameAr,
    required this.code,
    required this.dialCode,
  });

  @override
  bool operator ==(Object other) =>
      other is Country && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

const List<Country> kCountries = <Country>[
  Country(name: 'Syria', nameAr: 'سوريا', code: 'SY', dialCode: '+963'),
];

const Country kDefaultCountry = Country(
  name: 'Syria',
  nameAr: 'سوريا',
  code: 'SY',
  dialCode: '+963',
);
