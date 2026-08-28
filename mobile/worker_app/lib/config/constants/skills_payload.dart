class SkillsPayload {
  const SkillsPayload._();

  static Map<String, dynamic> body(List<int> skillIds) => {
    'skill_ids': List<int>.of(skillIds),
  };
}
