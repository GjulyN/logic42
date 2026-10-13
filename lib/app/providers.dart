import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/analytics/analytics_events.dart';
import '../core/clock/clock.dart';
import '../features/monetization/domain/entitlement_repository.dart';
import '../features/progression/domain/daily_rewards.dart';
import '../features/progression/domain/level_curve.dart';
import '../features/progression/domain/merge_policy.dart';
import '../features/progression/domain/scoring_policy.dart';
import '../features/progression/domain/streak_policy.dart';
import '../features/puzzle/data/puzzle_catalog.dart';
import '../features/puzzle/domain/content/worlds.dart';
import '../features/puzzle/domain/daily/daily_seed.dart';
import '../features/puzzle/domain/models/puzzle_definition.dart';
import '../features/puzzle/domain/rules/rule_registry.dart';
import '../services/firebase/firebase_ports.dart';
import '../services/local/progress_store.dart';
import 'config/app_flavor.dart';

final appConfigProvider =
    Provider<AppConfig>((ref) => AppConfig.fromEnvironment());

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final analyticsProvider =
    Provider<AnalyticsPort>((ref) => const NoOpAnalytics());

final crashProvider = Provider<CrashPort>((ref) => const NoOpCrash());

final authProvider = Provider<AuthPort>((ref) => LocalAuthAdapter());

final storeServiceProvider =
    Provider<StoreService>((ref) => const DisabledStoreService());

final entitlementProvider = Provider<EntitlementRepository>(
    (ref) => const OfflineEntitlementRepository());

final ruleRegistryProvider = Provider<RuleRegistry>((ref) => RuleRegistry());

final catalogProvider = Provider<PuzzleCatalog>((ref) {
  return PuzzleCatalog(registry: ref.watch(ruleRegistryProvider));
});

final progressStoreProvider = Provider<ProgressStore>((ref) => ProgressStore());

final playerProvider =
    NotifierProvider<PlayerController, PlayerSnapshot>(PlayerController.new);

class PlayerController extends Notifier<PlayerSnapshot> {
  @override
  PlayerSnapshot build() => PlayerSnapshot.empty();

  Future<void> hydrate() async {
    state = await ref.read(progressStoreProvider).load();
  }

  Future<void> _persist() => ref.read(progressStoreProvider).save(state);

  Future<void> completeOnboarding() async {
    state.onboardingComplete = true;
    await _persist();
    state = _copy(state);
  }

  PuzzleProgressRecord recordFor(String puzzleId) {
    return state.progress[puzzleId] ??
        PuzzleProgressRecord(
          puzzleId: puzzleId,
          completed: false,
          stars: 0,
          bestTimeMs: 0,
          attempts: 0,
          hintsUsed: 0,
          xpAwarded: 0,
        );
  }

  Future<ScoreBreakdown> applySolve({
    required PuzzleDefinition puzzle,
    required Duration elapsed,
    required int hintsUsed,
    required int attempts,
    required bool gaveUp,
  }) async {
    final existing = recordFor(puzzle.id);
    final policy = ScoringPolicy();
    final breakdown = policy.score(
      difficultyLabel: puzzle.difficultyLabel,
      elapsed: elapsed,
      hintsUsed: hintsUsed,
      attempts: attempts,
      gaveUp: gaveUp,
      alreadyCompleted: existing.completed && existing.xpAwarded > 0,
    );
    final stars =
        gaveUp ? 0 : starsFor(hintsUsed: hintsUsed, attempts: attempts);
    final merged = PuzzleProgressRecord(
      puzzleId: puzzle.id,
      completed: existing.completed || !gaveUp,
      stars: stars > existing.stars ? stars : existing.stars,
      bestTimeMs: () {
        if (gaveUp) return existing.bestTimeMs;
        if (existing.bestTimeMs <= 0) return elapsed.inMilliseconds;
        return elapsed.inMilliseconds < existing.bestTimeMs
            ? elapsed.inMilliseconds
            : existing.bestTimeMs;
      }(),
      attempts: existing.attempts + attempts,
      hintsUsed: existing.completed
          ? existing.hintsUsed
          : (existing.hintsUsed > hintsUsed ? existing.hintsUsed : hintsUsed),
      xpAwarded:
          existing.xpAwarded + (breakdown.awarded ? breakdown.totalXp : 0),
    );
    state.progress[puzzle.id] = mergeProgress(
      existing.completed ? existing : merged,
      merged,
    );
    if (breakdown.awarded) {
      state.xp += breakdown.totalXp;
      state.streak = StreakPolicy().onCompletion(
        previous: state.streak,
        nowUtc: ref.read(clockProvider).nowUtc(),
      );
      for (final reward in claimableRewards(
        streakCurrent: state.streak.current,
        alreadyClaimedIds: state.claimedRewardIds,
      )) {
        state.claimedRewardIds.add(reward.id);
        if (reward.kind == 'hint_token') state.hintTokens += 1;
        if (reward.kind == 'badge') state.badges.add(reward.id);
      }
    }
    await _persist();
    state = _copy(state);
    return breakdown;
  }

  Future<void> markDailyRanked(String dateId) async {
    state.dailyRankedDates.add(dateId);
    await _persist();
    state = _copy(state);
  }

  Future<void> recordSpeedBest(int ms) async {
    if (state.speedBestMs == null || ms < state.speedBestMs!) {
      state.speedBestMs = ms;
      await _persist();
      state = _copy(state);
    }
  }

  bool worldUnlocked(String worldId) {
    final order = worlds.firstWhere((w) => w.id == worldId).order;
    if (order <= 1) return true;
    final prev = worlds.firstWhere((w) => w.order == order - 1);
    final prevPuzzles = ref.read(catalogProvider).forWorld(prev.id);
    if (prevPuzzles.isEmpty) return true;
    return prevPuzzles.every((p) => recordFor(p.definition.id).completed);
  }

  int get level => levelForXp(state.xp);

  PlayerSnapshot _copy(PlayerSnapshot s) => PlayerSnapshot.fromJson(
        Map<String, dynamic>.from(s.toJson()),
      );
}

final settingsProvider =
    NotifierProvider<SettingsController, SettingsState>(SettingsController.new);

class SettingsState {
  const SettingsState({
    this.themeMode = 0,
    this.sound = true,
    this.haptics = true,
    this.reduceMotion = false,
    this.highContrast = false,
  });

  final int themeMode;
  final bool sound;
  final bool haptics;
  final bool reduceMotion;
  final bool highContrast;

  SettingsState copyWith({
    int? themeMode,
    bool? sound,
    bool? haptics,
    bool? reduceMotion,
    bool? highContrast,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      sound: sound ?? this.sound,
      haptics: haptics ?? this.haptics,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      highContrast: highContrast ?? this.highContrast,
    );
  }
}

class SettingsController extends Notifier<SettingsState> {
  static const _prefix = 'logic42.settings.';

  @override
  SettingsState build() => const SettingsState();

  Future<void> hydrate() async {
    final p = await SharedPreferences.getInstance();
    state = SettingsState(
      themeMode: p.getInt('${_prefix}theme') ?? 0,
      sound: p.getBool('${_prefix}sound') ?? true,
      haptics: p.getBool('${_prefix}haptics') ?? true,
      reduceMotion: p.getBool('${_prefix}reduceMotion') ?? false,
      highContrast: p.getBool('${_prefix}highContrast') ?? false,
    );
  }

  Future<void> update(SettingsState next) async {
    state = next;
    final p = await SharedPreferences.getInstance();
    await p.setInt('${_prefix}theme', next.themeMode);
    await p.setBool('${_prefix}sound', next.sound);
    await p.setBool('${_prefix}haptics', next.haptics);
    await p.setBool('${_prefix}reduceMotion', next.reduceMotion);
    await p.setBool('${_prefix}highContrast', next.highContrast);
  }
}

PuzzleDefinition dailyPuzzle(WidgetRef ref) {
  final config = ref.read(appConfigProvider);
  final clock = ref.read(clockProvider);
  final catalog = ref.read(catalogProvider);
  final registry = ref.read(ruleRegistryProvider);
  final utc = clock.nowUtc();
  final seed = dailySeed(
    utcDate: utc,
    saltVersion: config.dailySaltVersion,
    salt: config.dailySalt,
  );
  final rules = registry.all;
  final rule = rules[seed % rules.length];
  return catalog.generator.generate(seed: seed, ruleId: rule.ruleId);
}
