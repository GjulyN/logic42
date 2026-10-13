/// One-based modulo onto the closed range 1..42.
///
/// Ordinary `% 42` can return 0. This maps every integer, including 0 and
/// negatives, onto {1, 2, ..., 42}.
int mod42(int value) {
  return ((value - 1) % 42 + 42) % 42 + 1;
}

const int kMinValue = 1;
const int kMaxValue = 42;

bool isInRange(int value) => value >= kMinValue && value <= kMaxValue;

void assertOperands(List<int> operands) {
  if (operands.length != 6) {
    throw ArgumentError.value(operands, 'operands', 'exactly six required');
  }
  for (final v in operands) {
    if (!isInRange(v)) {
      throw ArgumentError.value(v, 'operand', 'must be in 1..42');
    }
  }
}
