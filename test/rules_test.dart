import 'package:flutter_test/flutter_test.dart';
import 'package:logic_42/features/puzzle/domain/math/mod42.dart';
import 'package:logic_42/features/puzzle/domain/rules/rule_registry.dart';

void main() {
  final registry = RuleRegistry();

  test('all rule ids unique', () {
    final ids = registry.all.map((r) => r.ruleId).toSet();
    expect(ids.length, registry.all.length);
  });

  for (final rule in registry.all) {
    group(rule.ruleId, () {
      test('normal evaluate in 1..42', () {
        const ops = [1, 2, 3, 4, 5, 6];
        final g = rule.evaluate(ops);
        expect(isInRange(g), isTrue);
        expect(rule.explanation(ops, g), contains('$g'));
        expect(rule.hints().visualFocus, isNotEmpty);
        expect(rule.hints().ruleFamily, isNotEmpty);
        expect(rule.hints().formulaConcept, isNotEmpty);
      });

      test('boundary operands', () {
        const ops = [1, 1, 1, 42, 42, 42];
        expect(isInRange(rule.evaluate(ops)), isTrue);
      });

      test('rejects wrong arity', () {
        expect(() => rule.evaluate([1, 2, 3]), throwsArgumentError);
      });
    });
  }

  test('alternating sum can be negative before wrap', () {
    final rule = registry.byId('alternating_sum');
    const ops = [1, 42, 1, 42, 1, 42];
    expect(rule.evaluate(ops), 5);
  });

  test('modular sum wrap', () {
    final rule = registry.byId('modular_sum');
    const ops = [40, 40, 40, 40, 40, 40];
    expect(rule.evaluate(ops), mod42(240));
  });
}
