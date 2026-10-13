import 'dart:math';

/// Deterministic RNG wrapper. Never uses DateTime.
class SeededRng {
  SeededRng(int seed) : _random = Random(seed);

  final Random _random;

  int nextInt(int max) => _random.nextInt(max);

  /// Inclusive range 1..42.
  int nextOperand() => 1 + _random.nextInt(42);
}
