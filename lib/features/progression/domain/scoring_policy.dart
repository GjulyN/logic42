class ScoreBreakdown {
  const ScoreBreakdown({
    required this.baseXp,
    required this.timeBonus,
    required this.noHintBonus,
    required this.firstAttemptBonus,
    required this.totalXp,
    required this.awarded,
    required this.reason,
  });

  final int baseXp;
  final int timeBonus;
  final int noHintBonus;
  final int firstAttemptBonus;
  final int totalXp;
  final bool awarded;
  final String reason;
}

class ScoringPolicy {
  static const easyBase = 100;
  static const mediumBase = 150;
  static const hardBase = 220;
  static const expertBase = 300;
  static const noHintBonus = 25;
  static const firstAttemptBonus = 25;
  static const timeBonusCap = 50;
  static const timeDecaySeconds = 180;

  int baseForLabel(String difficultyLabel) {
    switch (difficultyLabel) {
      case 'Easy':
        return easyBase;
      case 'Medium':
        return mediumBase;
      case 'Hard':
        return hardBase;
      case 'Expert':
        return expertBase;
      default:
        return mediumBase;
    }
  }

  /// Smooth linear decay from [timeBonusCap] at t=0 to 0 at [timeDecaySeconds].
  int timeBonus(Duration elapsed) {
    final t = elapsed.inSeconds;
    if (t <= 0) return timeBonusCap;
    if (t >= timeDecaySeconds) return 0;
    return ((timeBonusCap * (timeDecaySeconds - t)) / timeDecaySeconds).round();
  }

  ScoreBreakdown score({
    required String difficultyLabel,
    required Duration elapsed,
    required int hintsUsed,
    required int attempts,
    required bool gaveUp,
    required bool alreadyCompleted,
  }) {
    if (alreadyCompleted) {
      return const ScoreBreakdown(
        baseXp: 0,
        timeBonus: 0,
        noHintBonus: 0,
        firstAttemptBonus: 0,
        totalXp: 0,
        awarded: false,
        reason: 'xp_already_awarded',
      );
    }
    if (gaveUp) {
      return const ScoreBreakdown(
        baseXp: 0,
        timeBonus: 0,
        noHintBonus: 0,
        firstAttemptBonus: 0,
        totalXp: 0,
        awarded: false,
        reason: 'gave_up',
      );
    }
    final base = baseForLabel(difficultyLabel);
    final time = timeBonus(elapsed);
    final noHint = hintsUsed == 0 ? noHintBonus : 0;
    final first = attempts <= 1 ? firstAttemptBonus : 0;
    return ScoreBreakdown(
      baseXp: base,
      timeBonus: time,
      noHintBonus: noHint,
      firstAttemptBonus: first,
      totalXp: base + time + noHint + first,
      awarded: true,
      reason: 'solved',
    );
  }
}
