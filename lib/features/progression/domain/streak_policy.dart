class StreakState {
  const StreakState({
    required this.current,
    required this.longest,
    this.lastCompletionUtcDay,
    this.milestone3 = false,
    this.milestone7 = false,
    this.milestone30 = false,
  });

  final int current;
  final int longest;
  final DateTime? lastCompletionUtcDay;
  final bool milestone3;
  final bool milestone7;
  final bool milestone30;

  StreakState copyWith({
    int? current,
    int? longest,
    DateTime? lastCompletionUtcDay,
    bool? milestone3,
    bool? milestone7,
    bool? milestone30,
  }) {
    return StreakState(
      current: current ?? this.current,
      longest: longest ?? this.longest,
      lastCompletionUtcDay: lastCompletionUtcDay ?? this.lastCompletionUtcDay,
      milestone3: milestone3 ?? this.milestone3,
      milestone7: milestone7 ?? this.milestone7,
      milestone30: milestone30 ?? this.milestone30,
    );
  }
}

class StreakPolicy {
  DateTime utcDay(DateTime utc) => DateTime.utc(utc.year, utc.month, utc.day);

  /// Device clock in the future is clamped to [nowUtc] for awarding;
  /// far-past completion does not extend a live streak.
  StreakState onCompletion({
    required StreakState previous,
    required DateTime nowUtc,
    DateTime? claimedCompletionUtc,
  }) {
    final nowDay = utcDay(nowUtc);
    var claim = claimedCompletionUtc == null ? nowUtc : claimedCompletionUtc.toUtc();
    if (claim.isAfter(nowUtc.add(const Duration(hours: 2)))) {
      claim = nowUtc;
    }
    final claimDay = utcDay(claim);
    final last = previous.lastCompletionUtcDay;
    if (last != null && last == claimDay) {
      return previous;
    }
    var next = 1;
    if (last != null) {
      final delta = claimDay.difference(last).inDays;
      if (delta == 1) {
        next = previous.current + 1;
      } else if (delta <= 0) {
        next = previous.current;
      } else {
        next = 1;
      }
    }
    final longest = next > previous.longest ? next : previous.longest;
    return previous.copyWith(
      current: next,
      longest: longest,
      lastCompletionUtcDay: claimDay,
      milestone3: previous.milestone3 || next >= 3,
      milestone7: previous.milestone7 || next >= 7,
      milestone30: previous.milestone30 || next >= 30,
    );
  }
}
