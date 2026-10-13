import '../rules/logic_rule.dart';
import '../rules/rule_registry.dart';
import 'difficulty_config.dart';

class DifficultyCalculator {
  DifficultyCalculator({
    required this.registry,
    this.config = const DifficultyConfig(),
    Map<String, int>? resultDistributionScores,
  }) : resultDistributionScores = resultDistributionScores ?? const {};

  final RuleRegistry registry;
  final DifficultyConfig config;

  /// Optional precomputed scores from generated result frequencies.
  /// Not named entropy unless Shannon entropy is actually computed.
  final Map<String, int> resultDistributionScores;

  DifficultyBreakdown scoreRule(
    LogicRule rule, {
    int distractorSimilarity = 0,
    int ambiguityMargin = 10,
  }) {
    final operation = (rule.operationCount * 4).clamp(0, 40);
    final depth = (rule.transformDepth * 8).clamp(0, 24);
    final groups = (rule.groupCount * 5).clamp(0, 20);
    final ordering = rule.requiresSorting ? 12 : 0;
    final moduloAbs =
        (rule.usesModulo ? 6 : 0) + (rule.usesAbsoluteValue ? 6 : 0);
    final dist = resultDistributionScores[rule.ruleId] ?? 8;
    final total = (operation +
            depth +
            groups +
            ordering +
            moduloAbs +
            distractorSimilarity +
            ambiguityMargin +
            dist)
        .clamp(0, 100);
    return DifficultyBreakdown(
      score: total,
      label: config.labelFor(total),
      operationCount: operation,
      transformDepth: depth,
      groupCount: groups,
      ordering: ordering,
      moduloAbs: moduloAbs,
      distractorSimilarity: distractorSimilarity,
      ambiguityMargin: ambiguityMargin,
      resultDistributionScore: dist,
    );
  }
}
