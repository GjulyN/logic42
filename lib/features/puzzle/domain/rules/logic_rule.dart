class HintStages {
  const HintStages({
    required this.visualFocus,
    required this.ruleFamily,
    required this.formulaConcept,
  });

  /// Highlight relevant cells/groups without naming the rule.
  final String visualFocus;

  /// Conceptual family clue.
  final String ruleFamily;

  /// Operation structure without the substituted result.
  final String formulaConcept;
}

abstract class LogicRule {
  String get ruleId;
  String get displayName;
  String get worldId;
  int get operationCount;
  int get transformDepth;
  int get groupCount;
  bool get requiresSorting;
  bool get usesModulo;
  bool get usesAbsoluteValue;

  int evaluate(List<int> operands);

  String explanation(List<int> operands, int result);

  HintStages hints();
}
