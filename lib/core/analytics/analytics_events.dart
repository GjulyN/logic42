class AnalyticsEvent {
  const AnalyticsEvent(this.name, [this.params = const {}]);

  final String name;
  final Map<String, Object> params;
}

abstract class AnalyticsPort {
  Future<void> track(AnalyticsEvent event);
}

class NoOpAnalytics implements AnalyticsPort {
  const NoOpAnalytics();

  @override
  Future<void> track(AnalyticsEvent event) async {}
}

class AnalyticsEvents {
  static AnalyticsEvent onboardingCompleted() =>
      const AnalyticsEvent('onboarding_completed');

  static AnalyticsEvent puzzleStarted(String puzzleId) =>
      AnalyticsEvent('puzzle_started', {'puzzle_id': puzzleId});

  static AnalyticsEvent answerSubmitted({
    required String puzzleId,
    required bool correct,
  }) =>
      AnalyticsEvent('answer_submitted', {
        'puzzle_id': puzzleId,
        'correct': correct,
      });

  static AnalyticsEvent puzzleSolved(String puzzleId) =>
      AnalyticsEvent('puzzle_solved', {'puzzle_id': puzzleId});

  static AnalyticsEvent hintUsed({
    required String puzzleId,
    required int level,
  }) =>
      AnalyticsEvent('hint_used', {'puzzle_id': puzzleId, 'level': level});

  static AnalyticsEvent puzzleAbandoned(String puzzleId) =>
      AnalyticsEvent('puzzle_abandoned', {'puzzle_id': puzzleId});

  static AnalyticsEvent dailyCompleted() =>
      const AnalyticsEvent('daily_completed');

  static AnalyticsEvent speedRunCompleted() =>
      const AnalyticsEvent('speed_run_completed');

  static AnalyticsEvent lessonCompleted(String lessonId) =>
      AnalyticsEvent('lesson_completed', {'lesson_id': lessonId});

  static AnalyticsEvent purchaseScreenViewed() =>
      const AnalyticsEvent('purchase_screen_viewed');
}
