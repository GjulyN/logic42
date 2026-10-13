class DifficultyConfig {
  const DifficultyConfig({
    this.easyMax = 28,
    this.mediumMax = 48,
    this.hardMax = 68,
  });

  final int easyMax;
  final int mediumMax;
  final int hardMax;

  String labelFor(int score) {
    if (score <= easyMax) return 'Easy';
    if (score <= mediumMax) return 'Medium';
    if (score <= hardMax) return 'Hard';
    return 'Expert';
  }
}

class DifficultyBreakdown {
  const DifficultyBreakdown({
    required this.score,
    required this.label,
    required this.operationCount,
    required this.transformDepth,
    required this.groupCount,
    required this.ordering,
    required this.moduloAbs,
    required this.distractorSimilarity,
    required this.ambiguityMargin,
    required this.resultDistributionScore,
  });

  final int score;
  final String label;
  final int operationCount;
  final int transformDepth;
  final int groupCount;
  final int ordering;
  final int moduloAbs;
  final int distractorSimilarity;
  final int ambiguityMargin;
  final int resultDistributionScore;
}
