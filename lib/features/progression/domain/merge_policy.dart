class PuzzleProgressRecord {
  const PuzzleProgressRecord({
    required this.puzzleId,
    required this.completed,
    required this.stars,
    required this.bestTimeMs,
    required this.attempts,
    required this.hintsUsed,
    required this.xpAwarded,
  });

  final String puzzleId;
  final bool completed;
  final int stars;
  final int bestTimeMs;
  final int attempts;
  final int hintsUsed;
  final int xpAwarded;
}

/// Never overwrite a better result with a worse one.
PuzzleProgressRecord mergeProgress(
  PuzzleProgressRecord local,
  PuzzleProgressRecord remote,
) {
  if (local.puzzleId != remote.puzzleId) {
    throw ArgumentError('Cannot merge different puzzle ids');
  }
  final completed = local.completed || remote.completed;
  final stars = local.stars > remote.stars ? local.stars : remote.stars;
  final bestTime = () {
    if (local.bestTimeMs <= 0) return remote.bestTimeMs;
    if (remote.bestTimeMs <= 0) return local.bestTimeMs;
    return local.bestTimeMs < remote.bestTimeMs
        ? local.bestTimeMs
        : remote.bestTimeMs;
  }();
  final attempts =
      local.attempts > remote.attempts ? local.attempts : remote.attempts;
  final hints = local.hintsUsed < remote.hintsUsed
      ? local.hintsUsed
      : remote.hintsUsed;
  final xp = local.xpAwarded > remote.xpAwarded
      ? local.xpAwarded
      : remote.xpAwarded;
  return PuzzleProgressRecord(
    puzzleId: local.puzzleId,
    completed: completed,
    stars: stars,
    bestTimeMs: bestTime,
    attempts: attempts,
    hintsUsed: completed ? hints : (local.hintsUsed + remote.hintsUsed),
    xpAwarded: xp,
  );
}

int starsFor({required int hintsUsed, required int attempts}) {
  if (attempts <= 1 && hintsUsed == 0) return 3;
  if (hintsUsed <= 1 && attempts <= 2) return 2;
  return 1;
}
