class PuzzleValidationResult {
  const PuzzleValidationResult({
    required this.valid,
    required this.matchingRuleIds,
    this.reasons = const [],
  });

  final bool valid;
  final List<String> matchingRuleIds;
  final List<String> reasons;

  factory PuzzleValidationResult.ok(List<String> matching) =>
      PuzzleValidationResult(valid: true, matchingRuleIds: matching);

  factory PuzzleValidationResult.fail(
    List<String> reasons, {
    List<String> matching = const [],
  }) =>
      PuzzleValidationResult(
        valid: false,
        matchingRuleIds: matching,
        reasons: reasons,
      );
}
