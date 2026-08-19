/// THE single place the attach/detach request body is defined.
///
/// `POST /api/worker/update-skills` and `DELETE /api/worker/detach-skills` both
/// carry the skill id(s), but the exact key — and whether it is an array or a
/// scalar — is a backend contract that was never confirmed. Getting it wrong is
/// invisible from the app: Laravel answers **422** and nothing is written, so
/// the screen just "does nothing".
///
/// Rather than hard-coding one guess, the shape is described as data here:
/// [preferred] is what the app sends first, and [candidates] is the ordered
/// list the data source walks through **only when a 422 comes back** (a 422 is
/// a validation refusal, so the request had no side effect and retrying is
/// safe). The winning shape is logged in capitals and remembered for the rest
/// of the run.
///
/// To pin the contract once you have seen the log, move that shape to the front
/// of [candidates] / set it as [preferred] — this file is the only place to
/// edit, and nothing else in the app spells the field name out.
class SkillsPayload {
  /// The JSON key, e.g. `skill_ids`.
  final String field;

  /// Whether the value is a JSON array (`[4]`) or a bare scalar (`4`).
  final bool asArray;

  const SkillsPayload({required this.field, required this.asArray});

  /// What the app tries first.
  ///
  /// `skill_ids` as an array is the shape this repo's own endpoint
  /// documentation described before the feature was wired up, and it is the
  /// Laravel convention for a `belongsToMany` sync on a `skills()` relation.
  static const SkillsPayload preferred = SkillsPayload(
    field: 'skill_ids',
    asArray: true,
  );

  /// Every spelling worth trying, most likely first. Kept small and explicit —
  /// these are the four shapes a Laravel validator realistically asks for.
  static const List<SkillsPayload> candidates = [
    preferred,
    SkillsPayload(field: 'skills', asArray: true),
    SkillsPayload(field: 'skill_id', asArray: false),
    SkillsPayload(field: 'skills', asArray: false),
  ];

  /// The request body for [skillIds].
  ///
  /// The ids are copied through `List<int>.of` so what goes on the wire is a
  /// real JSON array of NUMBERS — never `["4"]` and never a stringified array,
  /// both of which fail Laravel's `integer` / `exists` rules.
  Map<String, dynamic> body(List<int> skillIds) => {
    field: asArray
        ? List<int>.of(skillIds)
        : (skillIds.isEmpty ? null : skillIds.first),
  };

  /// Human-readable shape for the logs, e.g. `{"skill_ids": [<int>]}`.
  String get label => asArray ? '{"$field": [<int>]}' : '{"$field": <int>}';

  @override
  String toString() => label;
}
