import '../math/mod42.dart';
import '../models/puzzle_definition.dart';
import '../models/puzzle_row.dart';
import '../models/puzzle_validation_result.dart';
import '../rules/logic_rule.dart';
import '../rules/rule_registry.dart';

class PuzzleValidator {
  PuzzleValidator(this.registry);

  final RuleRegistry registry;

  PuzzleValidationResult validate(PuzzleDefinition puzzle) {
    final reasons = <String>[];
    if (puzzle.trainingRows.length != 5) {
      reasons.add('Expected 5 training rows');
    }
    if (puzzle.targetRow.result == null) {
      reasons.add('Target row must include the validated answer g');
    }
    try {
      for (final row in puzzle.trainingRows) {
        row.validateShape(requireResult: true);
      }
      puzzle.targetRow.validateShape(requireResult: true);
    } catch (e) {
      reasons.add(e.toString());
    }

    final allRows = [...puzzle.trainingRows, puzzle.targetRow];
    final seen = <String>{};
    for (final row in allRows) {
      final key = row.operands.join(',');
      if (!seen.add(key)) {
        reasons.add('Duplicate operand row $key');
      }
    }

    LogicRule rule;
    try {
      rule = registry.byId(puzzle.ruleId);
    } catch (e) {
      return PuzzleValidationResult.fail(['Unknown rule ${puzzle.ruleId}']);
    }

    for (var i = 0; i < puzzle.trainingRows.length; i++) {
      final row = puzzle.trainingRows[i];
      final expected = rule.evaluate(row.operands);
      if (row.result != expected) {
        reasons.add(
          'Training row ${i + 1} g=${row.result} does not match ${rule.ruleId}=$expected',
        );
      }
      if (row.result != null && !isInRange(row.result!)) {
        reasons.add('Training row ${i + 1} out of range');
      }
    }
    final targetExpected = rule.evaluate(puzzle.targetRow.operands);
    if (puzzle.targetRow.result != targetExpected) {
      reasons.add(
        'Target g=${puzzle.targetRow.result} does not match ${rule.ruleId}=$targetExpected',
      );
    }

    final matching = matchingRules(allRows);
    if (!matching.contains(puzzle.ruleId)) {
      reasons.add('Declared rule does not match all six rows');
    }
    final others = matching.where((id) => id != puzzle.ruleId).toList();
    if (others.isNotEmpty) {
      reasons.add(
        'Ambiguous: also matched ${others.join(', ')} on all six rows',
      );
    }

    if (_trainingOnlySimplerFalsePositive(puzzle, rule)) {
      reasons.add('Training rows accidentally match a simpler competing rule');
    }

    if (reasons.isNotEmpty) {
      return PuzzleValidationResult.fail(reasons, matching: matching);
    }
    return PuzzleValidationResult.ok(matching);
  }

  List<String> matchingRules(List<PuzzleRow> rows) {
    final ids = <String>[];
    for (final rule in registry.all) {
      if (_matchesAll(rule, rows)) {
        ids.add(rule.ruleId);
      }
    }
    return ids;
  }

  bool _matchesAll(LogicRule rule, List<PuzzleRow> rows) {
    for (final row in rows) {
      final g = row.result;
      if (g == null) return false;
      if (rule.evaluate(row.operands) != g) return false;
    }
    return true;
  }

  /// Reject if another enabled rule matches the five training outputs
  /// (even if the sixth differs) — those examples hide the intended distinction.
  bool _trainingOnlySimplerFalsePositive(
    PuzzleDefinition puzzle,
    LogicRule intended,
  ) {
    for (final other in registry.all) {
      if (other.ruleId == intended.ruleId) continue;
      var trainingOk = true;
      for (final row in puzzle.trainingRows) {
        if (other.evaluate(row.operands) != row.result) {
          trainingOk = false;
          break;
        }
      }
      if (trainingOk) return true;
    }
    return false;
  }
}
