import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../features/progression/domain/merge_policy.dart';
import '../../features/progression/domain/streak_policy.dart';

class PlayerSnapshot {
  PlayerSnapshot({
    required this.schemaVersion,
    required this.xp,
    required this.onboardingComplete,
    required this.streak,
    required this.claimedRewardIds,
    required this.progress,
    required this.hintTokens,
    required this.badges,
    required this.dailyRankedDates,
    required this.speedBestMs,
  });

  int schemaVersion;
  int xp;
  bool onboardingComplete;
  StreakState streak;
  Set<String> claimedRewardIds;
  Map<String, PuzzleProgressRecord> progress;
  int hintTokens;
  Set<String> badges;
  Set<String> dailyRankedDates;
  int? speedBestMs;

  static PlayerSnapshot empty() => PlayerSnapshot(
        schemaVersion: 1,
        xp: 0,
        onboardingComplete: false,
        streak: const StreakState(current: 0, longest: 0),
        claimedRewardIds: {},
        progress: {},
        hintTokens: 0,
        badges: {},
        dailyRankedDates: {},
        speedBestMs: null,
      );

  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'xp': xp,
        'onboardingComplete': onboardingComplete,
        'streak': {
          'current': streak.current,
          'longest': streak.longest,
          'lastCompletionUtcDay':
              streak.lastCompletionUtcDay?.toIso8601String(),
          'milestone3': streak.milestone3,
          'milestone7': streak.milestone7,
          'milestone30': streak.milestone30,
        },
        'claimedRewardIds': claimedRewardIds.toList(),
        'progress': progress.map(
          (k, v) => MapEntry(k, {
            'puzzleId': v.puzzleId,
            'completed': v.completed,
            'stars': v.stars,
            'bestTimeMs': v.bestTimeMs,
            'attempts': v.attempts,
            'hintsUsed': v.hintsUsed,
            'xpAwarded': v.xpAwarded,
          }),
        ),
        'hintTokens': hintTokens,
        'badges': badges.toList(),
        'dailyRankedDates': dailyRankedDates.toList(),
        'speedBestMs': speedBestMs,
      };

  static PlayerSnapshot fromJson(Map<String, dynamic> json) {
    final streakMap = Map<String, dynamic>.from(json['streak'] as Map? ?? {});
    final last = streakMap['lastCompletionUtcDay'] as String?;
    final progressRaw =
        Map<String, dynamic>.from(json['progress'] as Map? ?? {});
    return PlayerSnapshot(
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      streak: StreakState(
        current: streakMap['current'] as int? ?? 0,
        longest: streakMap['longest'] as int? ?? 0,
        lastCompletionUtcDay: last == null ? null : DateTime.parse(last),
        milestone3: streakMap['milestone3'] as bool? ?? false,
        milestone7: streakMap['milestone7'] as bool? ?? false,
        milestone30: streakMap['milestone30'] as bool? ?? false,
      ),
      claimedRewardIds: {
        ...((json['claimedRewardIds'] as List?) ?? []).map((e) => e.toString()),
      },
      progress: progressRaw.map((k, v) {
        final m = Map<String, dynamic>.from(v as Map);
        return MapEntry(
          k,
          PuzzleProgressRecord(
            puzzleId: m['puzzleId'] as String,
            completed: m['completed'] as bool? ?? false,
            stars: m['stars'] as int? ?? 0,
            bestTimeMs: m['bestTimeMs'] as int? ?? 0,
            attempts: m['attempts'] as int? ?? 0,
            hintsUsed: m['hintsUsed'] as int? ?? 0,
            xpAwarded: m['xpAwarded'] as int? ?? 0,
          ),
        );
      }),
      hintTokens: json['hintTokens'] as int? ?? 0,
      badges: {...((json['badges'] as List?) ?? []).map((e) => e.toString())},
      dailyRankedDates: {
        ...((json['dailyRankedDates'] as List?) ?? []).map((e) => e.toString()),
      },
      speedBestMs: json['speedBestMs'] as int?,
    );
  }
}

class ProgressStore {
  ProgressStore({this.overrideFile});

  final File? overrideFile;
  static const currentSchema = 1;

  Future<File> _file() async {
    if (overrideFile != null) return overrideFile!;
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'logic42_progress_v1.json'));
  }

  Future<PlayerSnapshot> load() async {
    final file = await _file();
    if (!await file.exists()) return PlayerSnapshot.empty();
    final json = jsonDecode(await file.readAsString());
    if (json is! Map) return PlayerSnapshot.empty();
    var snap = PlayerSnapshot.fromJson(Map<String, dynamic>.from(json));
    snap = migrate(snap);
    return snap;
  }

  PlayerSnapshot migrate(PlayerSnapshot snap) {
    if (snap.schemaVersion > currentSchema) {
      throw StateError(
          'Progress schema ${snap.schemaVersion} is newer than $currentSchema');
    }
    snap.schemaVersion = currentSchema;
    return snap;
  }

  Future<void> save(PlayerSnapshot snapshot) async {
    final file = await _file();
    await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(snapshot.toJson()));
  }
}
