import 'package:flutter_test/flutter_test.dart';
import 'package:logic_42/features/puzzle/data/puzzle_catalog.dart';
import 'package:logic_42/features/puzzle/domain/generator/puzzle_generator.dart';
import 'package:logic_42/features/puzzle/domain/math/mod42.dart';
import 'package:logic_42/features/puzzle/domain/rules/rule_registry.dart';
import 'package:logic_42/features/puzzle/domain/validation/puzzle_validator.dart';

void main() {
  final registry = RuleRegistry();
  final generator = PuzzleGenerator(registry: registry, maxAttempts: 1200);
  final validator = PuzzleValidator(registry);

  test('same seed is deterministic', () {
    final a = generator.generate(seed: 42, ruleId: 'modular_sum');
    final b = generator.generate(seed: 42, ruleId: 'modular_sum');
    expect(a.toJson(), b.toJson());
  });

  test('curated seeds validate', () {
    for (final spec in curatedSeeds) {
      final p = generator.generate(
        seed: spec.seed,
        ruleId: spec.ruleId,
        worldId: spec.worldId,
      );
      final r = validator.validate(p);
      expect(r.valid, isTrue, reason: '${spec.ruleId}: ${r.reasons}');
      expect(p.trainingRows.length, 5);
      expect(p.targetRow.result, isNotNull);
      expect(isInRange(p.answer), isTrue);
    }
  });

  test('fuzz outputs stay in range', () {
    for (final rule in registry.all) {
      for (var i = 0; i < 200; i++) {
        final ops = [
          1 + (i * 3) % 42,
          1 + (i * 5) % 42,
          1 + (i * 7) % 42,
          1 + (i * 11) % 42,
          1 + (i * 13) % 42,
          1 + (i * 17) % 42,
        ];
        expect(isInRange(rule.evaluate(ops)), isTrue);
      }
    }
  });

  test('invalid json rejected', () {
    expect(
      () => PuzzleCatalog(registry: registry).loadJsonString('[]'),
      throwsFormatException,
    );
  });
}
