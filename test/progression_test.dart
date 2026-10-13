import 'package:flutter_test/flutter_test.dart';
import 'package:logic_42/features/progression/domain/daily_rewards.dart';
import 'package:logic_42/features/progression/domain/level_curve.dart';
import 'package:logic_42/features/progression/domain/merge_policy.dart';
import 'package:logic_42/features/progression/domain/scoring_policy.dart';
import 'package:logic_42/features/progression/domain/streak_policy.dart';

void main() {
  test('level boundaries', () {
    expect(levelForXp(0), 1);
    expect(xpToReachLevel(1), 0);
    expect(levelForXp(xpToReachLevel(2)), 2);
    expect(levelForXp(xpToReachLevel(100)), 100);
    expect(xpToReachLevel(3) > xpToReachLevel(2), isTrue);
  });

  test('scoring no farm / give up', () {
    final p = ScoringPolicy();
    final farm = p.score(
      difficultyLabel: 'Easy',
      elapsed: Duration.zero,
      hintsUsed: 0,
      attempts: 1,
      gaveUp: false,
      alreadyCompleted: true,
    );
    expect(farm.awarded, isFalse);
    final give = p.score(
      difficultyLabel: 'Easy',
      elapsed: Duration.zero,
      hintsUsed: 0,
      attempts: 1,
      gaveUp: true,
      alreadyCompleted: false,
    );
    expect(give.totalXp, 0);
  });

  test('time bonus decay', () {
    final p = ScoringPolicy();
    expect(p.timeBonus(Duration.zero), ScoringPolicy.timeBonusCap);
    expect(p.timeBonus(const Duration(seconds: 180)), 0);
  });

  test('streak utc days', () {
    final policy = StreakPolicy();
    var s = const StreakState(current: 0, longest: 0);
    s = policy.onCompletion(
      previous: s,
      nowUtc: DateTime.utc(2026, 1, 1),
    );
    s = policy.onCompletion(
      previous: s,
      nowUtc: DateTime.utc(2026, 1, 2),
    );
    expect(s.current, 2);
    s = policy.onCompletion(
      previous: s,
      nowUtc: DateTime.utc(2026, 1, 4),
    );
    expect(s.current, 1);
  });

  test('rewards idempotent', () {
    final first = claimableRewards(
      streakCurrent: 7,
      alreadyClaimedIds: {},
    );
    expect(first.length, 3);
    final again = claimableRewards(
      streakCurrent: 7,
      alreadyClaimedIds: first.map((e) => e.id).toSet(),
    );
    expect(again, isEmpty);
  });

  test('merge keeps better result', () {
    const a = PuzzleProgressRecord(
      puzzleId: 'p',
      completed: true,
      stars: 3,
      bestTimeMs: 1000,
      attempts: 1,
      hintsUsed: 0,
      xpAwarded: 100,
    );
    const b = PuzzleProgressRecord(
      puzzleId: 'p',
      completed: true,
      stars: 1,
      bestTimeMs: 5000,
      attempts: 4,
      hintsUsed: 3,
      xpAwarded: 40,
    );
    final m = mergeProgress(a, b);
    expect(m.stars, 3);
    expect(m.bestTimeMs, 1000);
    expect(m.xpAwarded, 100);
  });
}
