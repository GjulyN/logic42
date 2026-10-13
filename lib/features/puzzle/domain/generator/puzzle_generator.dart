import '../difficulty/difficulty_calculator.dart';
import '../models/puzzle_definition.dart';
import '../models/puzzle_row.dart';
import '../rules/logic_rule.dart';
import '../rules/rule_registry.dart';
import '../validation/puzzle_validator.dart';
import 'generation_failure.dart';
import 'seeded_rng.dart';

class PuzzleGenerator {
  PuzzleGenerator({
    required this.registry,
    PuzzleValidator? validator,
    DifficultyCalculator? difficulty,
    this.generatorVersion = 1,
    this.maxAttempts = 800,
  })  : validator = validator ?? PuzzleValidator(registry),
        difficulty = difficulty ?? DifficultyCalculator(registry: registry);

  final RuleRegistry registry;
  final PuzzleValidator validator;
  final DifficultyCalculator difficulty;
  final int generatorVersion;
  final int maxAttempts;

  /// Reproducible from {generatorVersion, seed, ruleId, difficulty}.
  PuzzleDefinition generate({
    required int seed,
    required String ruleId,
    String? worldId,
    int? difficultyHint,
  }) {
    final rule = registry.byId(ruleId);
    final rng =
        SeededRng(_mix(seed, ruleId, generatorVersion, difficultyHint ?? 0));
    final breakdown = difficulty.scoreRule(rule);
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final rows = <PuzzleRow>[];
      final keys = <String>{};
      var degenerate = false;
      for (var i = 0; i < 6; i++) {
        List<int> ops;
        var inner = 0;
        do {
          ops = List<int>.generate(6, (_) => rng.nextOperand());
          inner++;
          if (inner > 40) {
            degenerate = true;
            break;
          }
        } while (!keys.add(ops.join(',')));
        if (degenerate) break;
        rows.add(PuzzleRow(operands: ops, result: rule.evaluate(ops)));
      }
      if (degenerate) continue;
      if (_hidesDistinction(rows, rule)) continue;

      final puzzle = PuzzleDefinition(
        id: 'g${generatorVersion}_${rule.ruleId}_$seed',
        ruleId: rule.ruleId,
        worldId: worldId ?? rule.worldId,
        difficultyScore: breakdown.score,
        difficultyLabel: breakdown.label,
        generatorVersion: generatorVersion,
        seed: seed,
        trainingRows: rows.sublist(0, 5),
        targetRow: rows[5],
      );
      final result = validator.validate(puzzle);
      if (result.valid) {
        return PuzzleDefinition(
          id: puzzle.id,
          ruleId: puzzle.ruleId,
          worldId: puzzle.worldId,
          difficultyScore: puzzle.difficultyScore,
          difficultyLabel: puzzle.difficultyLabel,
          generatorVersion: puzzle.generatorVersion,
          seed: puzzle.seed,
          trainingRows: puzzle.trainingRows,
          targetRow: puzzle.targetRow,
          matchingRuleIds: result.matchingRuleIds,
        );
      }
    }
    throw GenerationFailure(
      'No valid unambiguous puzzle for rule=$ruleId seed=$seed '
      'version=$generatorVersion within $maxAttempts attempts',
    );
  }

  bool _hidesDistinction(List<PuzzleRow> rows, LogicRule intended) {
    final constants = rows.map((r) => r.result).toSet();
    if (constants.length == 1) return true;
    return false;
  }

  int _mix(int seed, String ruleId, int version, int difficultyHint) {
    var h = seed ^ (version * 1000003) ^ (difficultyHint * 9176);
    for (final c in ruleId.codeUnits) {
      h = 0x1fffffff & (h * 31 + c);
    }
    return h & 0x7fffffff;
  }
}
