import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics_events.dart';
import '../../../core/clock/clock.dart';
import '../../progression/domain/scoring_policy.dart';
import '../domain/models/puzzle_definition.dart';
import '../domain/rules/logic_rule.dart';
import '../domain/rules/rule_registry.dart';

enum PlayPhase { playing, correct, givenUp }

class PlayState {
  const PlayState({
    required this.puzzle,
    required this.startedAt,
    this.buffer = '',
    this.guess,
    this.hintsUsed = 0,
    this.attempts = 0,
    this.phase = PlayPhase.playing,
    this.lastWrong = false,
    this.paused = false,
    this.accumulated = Duration.zero,
    this.score,
    this.selected = true,
  });

  final PuzzleDefinition puzzle;
  final DateTime startedAt;
  final String buffer;
  final int? guess;
  final int hintsUsed;
  final int attempts;
  final PlayPhase phase;
  final bool lastWrong;
  final bool paused;
  final Duration accumulated;
  final ScoreBreakdown? score;
  final bool selected;

  PlayState copyWith({
    String? buffer,
    int? guess,
    bool clearGuess = false,
    int? hintsUsed,
    int? attempts,
    PlayPhase? phase,
    bool? lastWrong,
    bool? paused,
    Duration? accumulated,
    ScoreBreakdown? score,
    bool? selected,
  }) {
    return PlayState(
      puzzle: puzzle,
      startedAt: startedAt,
      buffer: buffer ?? this.buffer,
      guess: clearGuess ? null : (guess ?? this.guess),
      hintsUsed: hintsUsed ?? this.hintsUsed,
      attempts: attempts ?? this.attempts,
      phase: phase ?? this.phase,
      lastWrong: lastWrong ?? this.lastWrong,
      paused: paused ?? this.paused,
      accumulated: accumulated ?? this.accumulated,
      score: score ?? this.score,
      selected: selected ?? this.selected,
    );
  }
}

class PlayController extends Notifier<PlayState?> {
  @override
  PlayState? build() => null;

  void start(PuzzleDefinition puzzle, Clock clock) {
    state = PlayState(puzzle: puzzle, startedAt: clock.now());
  }

  void typeDigit(int n) {
    final s = state;
    if (s == null || s.phase != PlayPhase.playing) return;
    if (n < 1 || n > 42) return;
    state = s.copyWith(buffer: '$n', guess: n, lastWrong: false);
  }

  void delete() {
    final s = state;
    if (s == null) return;
    state = s.copyWith(buffer: '', clearGuess: true, lastWrong: false);
  }

  bool submit() {
    final s = state;
    if (s == null) return false;
    final g = s.guess;
    if (g == null || g < 1 || g > 42) return false;
    final attempts = s.attempts + 1;
    if (g == s.puzzle.answer) {
      state = s.copyWith(
        attempts: attempts,
        phase: PlayPhase.correct,
        lastWrong: false,
      );
      return true;
    }
    state = s.copyWith(attempts: attempts, lastWrong: true);
    return false;
  }

  void useHint() {
    final s = state;
    if (s == null || s.hintsUsed >= 3) return;
    state = s.copyWith(hintsUsed: s.hintsUsed + 1);
  }

  void giveUp() {
    final s = state;
    if (s == null) return;
    state = s.copyWith(phase: PlayPhase.givenUp);
  }

  void pause(Clock clock) {
    final s = state;
    if (s == null || s.paused) return;
    state = s.copyWith(
      paused: true,
      accumulated: s.accumulated + clock.now().difference(s.startedAt),
    );
  }

  void resume(Clock clock) {
    final s = state;
    if (s == null || !s.paused) return;
    state = PlayState(
      puzzle: s.puzzle,
      startedAt: clock.now(),
      buffer: s.buffer,
      guess: s.guess,
      hintsUsed: s.hintsUsed,
      attempts: s.attempts,
      phase: s.phase,
      lastWrong: s.lastWrong,
      paused: false,
      accumulated: s.accumulated,
      score: s.score,
      selected: s.selected,
    );
  }

  void attachScore(ScoreBreakdown score) {
    final s = state;
    if (s == null) return;
    state = s.copyWith(score: score);
  }

  Duration elapsed(Clock clock) {
    final s = state;
    if (s == null) return Duration.zero;
    if (s.paused) return s.accumulated;
    return s.accumulated + clock.now().difference(s.startedAt);
  }

  LogicRule rule(RuleRegistry registry) => registry.byId(state!.puzzle.ruleId);
}

final playProvider =
    NotifierProvider<PlayController, PlayState?>(PlayController.new);

List<bool> visualMask(LogicRule rule) {
  switch (rule.ruleId) {
    case 'odd_even_position_diff':
    case 'alternating_sum':
      return [true, false, true, false, true, false];
    case 'min_plus_max':
    case 'range':
    case 'median_pair_sum':
    case 'forty_two_symmetry':
      return [true, true, true, true, true, true];
    default:
      return [true, true, true, true, true, true];
  }
}

AnalyticsEvent? hintEvent(String puzzleId, int level) =>
    AnalyticsEvents.hintUsed(puzzleId: puzzleId, level: level);
