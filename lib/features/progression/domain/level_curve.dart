/// Player levels 1–100. Cumulative XP required to *reach* [level].
/// Level 1 requires 0. Pure monotonic quadratic.
int xpToReachLevel(int level) {
  if (level <= 1) return 0;
  if (level > 100) level = 100;
  final n = level - 1;
  return 40 * n * n + 60 * n;
}

int levelForXp(int xp) {
  var level = 1;
  for (var l = 2; l <= 100; l++) {
    if (xp >= xpToReachLevel(l)) {
      level = l;
    } else {
      break;
    }
  }
  return level;
}

int xpForNextLevel(int xp) {
  final level = levelForXp(xp);
  if (level >= 100) return xpToReachLevel(100);
  return xpToReachLevel(level + 1);
}
