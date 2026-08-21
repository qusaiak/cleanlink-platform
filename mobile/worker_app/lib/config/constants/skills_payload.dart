class SkillsPayload {
  final String field;

  final bool asArray;

  const SkillsPayload({required this.field, required this.asArray});

  static const SkillsPayload preferred = SkillsPayload(
    field: 'skill_ids',
    asArray: true,
  );

  static const List<SkillsPayload> candidates = [
    preferred,
    SkillsPayload(field: 'skills', asArray: true),
    SkillsPayload(field: 'skill_id', asArray: false),
    SkillsPayload(field: 'skills', asArray: false),
  ];

  Map<String, dynamic> body(List<int> skillIds) => {
    field: asArray
        ? List<int>.of(skillIds)
        : (skillIds.isEmpty ? null : skillIds.first),
  };

  String get label => asArray ? '{"$field": [<int>]}' : '{"$field": <int>}';

  @override
  String toString() => label;
}
