import 'logic_rule.dart';
import 'rule_families.dart';

class RuleRegistry {
  RuleRegistry({List<LogicRule>? rules})
      : _rules = List.unmodifiable(rules ?? builtInRules()) {
    final ids = <String>{};
    for (final r in _rules) {
      if (!ids.add(r.ruleId)) {
        throw StateError('Duplicate ruleId ${r.ruleId}');
      }
    }
  }

  final List<LogicRule> _rules;

  List<LogicRule> get all => _rules;

  LogicRule byId(String ruleId) {
    return _rules.firstWhere(
      (r) => r.ruleId == ruleId,
      orElse: () => throw StateError('Unknown ruleId $ruleId'),
    );
  }

  List<LogicRule> forWorld(String worldId) =>
      _rules.where((r) => r.worldId == worldId).toList();
}
