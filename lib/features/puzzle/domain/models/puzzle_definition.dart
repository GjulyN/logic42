import 'puzzle_row.dart';

class PuzzleDefinition {
  const PuzzleDefinition({
    required this.id,
    required this.ruleId,
    required this.worldId,
    required this.difficultyScore,
    required this.difficultyLabel,
    required this.generatorVersion,
    required this.seed,
    required this.trainingRows,
    required this.targetRow,
    this.matchingRuleIds = const [],
  });

  final String id;
  final String ruleId;
  final String worldId;
  final int difficultyScore;
  final String difficultyLabel;
  final int generatorVersion;
  final int seed;

  /// Rows 1–5: complete examples (operands + g).
  final List<PuzzleRow> trainingRows;

  /// Row 6: operands present, result is the hidden answer (stored for
  /// validation; UI must not display it until solved or given up).
  final PuzzleRow targetRow;

  final List<String> matchingRuleIds;

  int get answer {
    final g = targetRow.result;
    if (g == null) {
      throw StateError('Target row is missing the validated answer');
    }
    return g;
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'ruleId': ruleId,
        'worldId': worldId,
        'difficultyScore': difficultyScore,
        'difficultyLabel': difficultyLabel,
        'generatorVersion': generatorVersion,
        'seed': seed,
        'trainingRows': trainingRows.map((r) => r.toJson()).toList(),
        'targetRow': targetRow.toJson(),
        'matchingRuleIds': matchingRuleIds,
      };

  factory PuzzleDefinition.fromJson(Object? json) {
    if (json is! Map) {
      throw const FormatException('PuzzleDefinition must be an object');
    }
    final map = Map<String, dynamic>.from(json);
    String req(String key) {
      final v = map[key];
      if (v is! String || v.isEmpty) {
        throw FormatException('$key must be a non-empty string');
      }
      return v;
    }

    int reqInt(String key) {
      final v = map[key];
      if (v is int) return v;
      if (v is num) return v.toInt();
      throw FormatException('$key must be an integer');
    }

    final trainingRaw = map['trainingRows'];
    if (trainingRaw is! List || trainingRaw.length != 5) {
      throw const FormatException('trainingRows must contain exactly 5 rows');
    }
    final training = trainingRaw.map(PuzzleRow.fromJson).toList();
    final target = PuzzleRow.fromJson(map['targetRow']);
    final matching = map['matchingRuleIds'];
    return PuzzleDefinition(
      id: req('id'),
      ruleId: req('ruleId'),
      worldId: req('worldId'),
      difficultyScore: reqInt('difficultyScore'),
      difficultyLabel: req('difficultyLabel'),
      generatorVersion: reqInt('generatorVersion'),
      seed: reqInt('seed'),
      trainingRows: List.unmodifiable(training),
      targetRow: target,
      matchingRuleIds: matching is List
          ? List.unmodifiable(matching.map((e) => e.toString()))
          : const [],
    );
  }
}
