import '../math/mod42.dart';
import '../math/number_theory.dart';
import 'logic_rule.dart';

int _sum(Iterable<int> xs) => xs.fold(0, (a, b) => a + b);

class ModularSumRule extends LogicRule {
  @override
  String get ruleId => 'modular_sum';
  @override
  String get displayName => 'Modular sum';
  @override
  String get worldId => 'modular_rules';
  @override
  int get operationCount => 6;
  @override
  int get transformDepth => 1;
  @override
  int get groupCount => 1;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    return mod42(_sum(operands));
  }

  @override
  String explanation(List<int> operands, int result) {
    final s = _sum(operands);
    return 'Add all six values: ${operands.join(' + ')} = $s. '
        'Normalize with mod42 to $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus:
            'Look at every number in the row together, not just a pair.',
        ruleFamily: 'The output is a wrapped total of the six values.',
        formulaConcept: 'g = mod42(a + b + c + d + e + f).',
      );
}

class AlternatingSumRule extends LogicRule {
  @override
  String get ruleId => 'alternating_sum';
  @override
  String get displayName => 'Alternating sum';
  @override
  String get worldId => 'modular_rules';
  @override
  int get operationCount => 6;
  @override
  int get transformDepth => 1;
  @override
  int get groupCount => 2;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final v = operands[0] -
        operands[1] +
        operands[2] -
        operands[3] +
        operands[4] -
        operands[5];
    return mod42(v);
  }

  @override
  String explanation(List<int> operands, int result) {
    final v = operands[0] -
        operands[1] +
        operands[2] -
        operands[3] +
        operands[4] -
        operands[5];
    return 'Alternate signs by position: '
        '${operands[0]} - ${operands[1]} + ${operands[2]} - ${operands[3]} + '
        '${operands[4]} - ${operands[5]} = $v. Normalize with mod42 to $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'Notice the left-to-right order of the six cells.',
        ruleFamily: 'Positions take turns adding and subtracting.',
        formulaConcept: 'g = mod42(a - b + c - d + e - f).',
      );
}

class OddEvenValueDifferenceRule extends LogicRule {
  @override
  String get ruleId => 'odd_even_value_diff';
  @override
  String get displayName => 'Odd/even value-group difference';
  @override
  String get worldId => 'number_groups';
  @override
  int get operationCount => 4;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 2;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => true;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final odds = operands.where(isOdd);
    final evens = operands.where(isEven);
    return mod42((_sum(odds) - _sum(evens)).abs());
  }

  @override
  String explanation(List<int> operands, int result) {
    final odds = operands.where(isOdd).toList();
    final evens = operands.where(isEven).toList();
    final so = _sum(odds);
    final se = _sum(evens);
    return 'Group by the values themselves (not cell positions). '
        'Odd values ${odds.isEmpty ? '(none)' : odds.join(', ')} sum to $so. '
        'Even values ${evens.isEmpty ? '(none)' : evens.join(', ')} sum to $se. '
        'g = mod42(|$so − $se|) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'Split numbers that are odd from numbers that are even.',
        ruleFamily: 'Compare the two value groups, independent of position.',
        formulaConcept: 'g = mod42(|sum(odd values) − sum(even values)|).',
      );
}

class OddEvenPositionDifferenceRule extends LogicRule {
  @override
  String get ruleId => 'odd_even_position_diff';
  @override
  String get displayName => 'Odd/even position difference';
  @override
  String get worldId => 'number_groups';
  @override
  int get operationCount => 4;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 2;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => true;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final oddPos = operands[0] + operands[2] + operands[4];
    final evenPos = operands[1] + operands[3] + operands[5];
    return mod42((oddPos - evenPos).abs());
  }

  @override
  String explanation(List<int> operands, int result) {
    final oddPos = operands[0] + operands[2] + operands[4];
    final evenPos = operands[1] + operands[3] + operands[5];
    return 'Group by cell position (1-based odd vs even), not by parity of the value. '
        'Positions 1,3,5: ${operands[0]} + ${operands[2]} + ${operands[4]} = $oddPos. '
        'Positions 2,4,6: ${operands[1]} + ${operands[3]} + ${operands[5]} = $evenPos. '
        'g = mod42(|$oddPos − $evenPos|) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus:
            'Look at every other cell: first, third, and fifth versus the rest.',
        ruleFamily:
            'The grouping follows positions, not whether a number is odd.',
        formulaConcept: 'g = mod42(|(a + c + e) − (b + d + f)|).',
      );
}

class RangeRule extends LogicRule {
  @override
  String get ruleId => 'range';
  @override
  String get displayName => 'Range';
  @override
  String get worldId => 'basic_patterns';
  @override
  int get operationCount => 3;
  @override
  int get transformDepth => 1;
  @override
  int get groupCount => 1;
  @override
  bool get requiresSorting => true;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    return mod42(operands.reduce((a, b) => a > b ? a : b) -
        operands.reduce((a, b) => a < b ? a : b));
  }

  @override
  String explanation(List<int> operands, int result) {
    final mn = operands.reduce((a, b) => a < b ? a : b);
    final mx = operands.reduce((a, b) => a > b ? a : b);
    return 'Range is max − min: $mx − $mn = ${mx - mn}. '
        'Normalize with mod42 to $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'Find the smallest and largest values in the row.',
        ruleFamily: 'The output comes from the spread of the six numbers.',
        formulaConcept: 'g = mod42(max − min).',
      );
}

class MinPlusMaxRule extends LogicRule {
  @override
  String get ruleId => 'min_plus_max';
  @override
  String get displayName => 'Min plus max';
  @override
  String get worldId => 'basic_patterns';
  @override
  int get operationCount => 3;
  @override
  int get transformDepth => 1;
  @override
  int get groupCount => 1;
  @override
  bool get requiresSorting => true;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final mn = operands.reduce((a, b) => a < b ? a : b);
    final mx = operands.reduce((a, b) => a > b ? a : b);
    return mod42(mn + mx);
  }

  @override
  String explanation(List<int> operands, int result) {
    final mn = operands.reduce((a, b) => a < b ? a : b);
    final mx = operands.reduce((a, b) => a > b ? a : b);
    return 'Add the extremes: min $mn + max $mx = ${mn + mx}. '
        'Normalize with mod42 to $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'Only the smallest and largest cells matter.',
        ruleFamily: 'Combine the two extremes of the row.',
        formulaConcept: 'g = mod42(min + max).',
      );
}

class MedianPairSumRule extends LogicRule {
  @override
  String get ruleId => 'median_pair_sum';
  @override
  String get displayName => 'Median pair sum';
  @override
  String get worldId => 'basic_patterns';
  @override
  int get operationCount => 4;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 1;
  @override
  bool get requiresSorting => true;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final s = sortedCopy(operands);
    return mod42(s[2] + s[3]);
  }

  @override
  String explanation(List<int> operands, int result) {
    final s = sortedCopy(operands);
    return 'Sort to ${s.join(', ')}. The middle pair is ${s[2]} and ${s[3]}. '
        'g = mod42(${s[2]} + ${s[3]}) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus:
            'Imagine the six numbers lined up from smallest to largest.',
        ruleFamily: 'The two central values after sorting are combined.',
        formulaConcept: 'Sort x1≤…≤x6, then g = mod42(x3 + x4).',
      );
}

class PrimeNonprimeDifferenceRule extends LogicRule {
  @override
  String get ruleId => 'prime_nonprime_diff';
  @override
  String get displayName => 'Prime vs non-prime difference';
  @override
  String get worldId => 'prime_logic';
  @override
  int get operationCount => 4;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 2;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => true;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final primes = operands.where(isPrime);
    final others = operands.where((n) => !isPrime(n));
    return mod42((_sum(primes) - _sum(others)).abs());
  }

  @override
  String explanation(List<int> operands, int result) {
    final primes = operands.where(isPrime).toList();
    final others = operands.where((n) => !isPrime(n)).toList();
    final sp = _sum(primes);
    final so = _sum(others);
    return '1 is neither prime nor composite, so it counts with non-primes. '
        'Primes ${primes.isEmpty ? '(none)' : primes.join(', ')} sum to $sp. '
        'Non-primes ${others.isEmpty ? '(none)' : others.join(', ')} sum to $so. '
        'g = mod42(|$sp − $so|) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'Mark which values are prime. Treat 1 as not prime.',
        ruleFamily: 'Compare the prime group with everything else.',
        formulaConcept: 'g = mod42(|sum(primes) − sum(non-primes)|).',
      );
}

class DigitSumRule extends LogicRule {
  @override
  String get ruleId => 'digit_sum';
  @override
  String get displayName => 'Digit sum';
  @override
  String get worldId => 'basic_patterns';
  @override
  int get operationCount => 7;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 1;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    return mod42(_sum(operands.map(decimalDigitSum)));
  }

  @override
  String explanation(List<int> operands, int result) {
    final parts = operands.map(decimalDigitSum).toList();
    final s = _sum(parts);
    return 'Take each decimal digit sum: ${operands.asMap().entries.map((e) => '${e.value}→${parts[e.key]}').join(', ')}. '
        'Add them: ${parts.join(' + ')} = $s. Normalize with mod42 to $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'Two-digit numbers can be split into their digits.',
        ruleFamily: 'The rule works on digit totals, not the raw values alone.',
        formulaConcept: 'g = mod42(digitSum(a)+…+digitSum(f)).',
      );
}

class CountWeightedParityRule extends LogicRule {
  @override
  String get ruleId => 'count_weighted_parity';
  @override
  String get displayName => 'Count-weighted parity';
  @override
  String get worldId => 'number_groups';
  @override
  int get operationCount => 4;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 2;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final oddCount = operands.where(isOdd).length;
    final evenCount = operands.where(isEven).length;
    return mod42(oddCount * 7 + evenCount * 3);
  }

  @override
  String explanation(List<int> operands, int result) {
    final oddCount = operands.where(isOdd).length;
    final evenCount = operands.where(isEven).length;
    return 'Count odds ($oddCount) and evens ($evenCount). '
        'g = mod42($oddCount×7 + $evenCount×3) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'How many odd values versus even values are in the row?',
        ruleFamily: 'The counts are weighted, then wrapped into 1–42.',
        formulaConcept: 'g = mod42(oddCount×7 + evenCount×3).',
      );
}

class CountAbove21Rule extends LogicRule {
  @override
  String get ruleId => 'count_above_21';
  @override
  String get displayName => 'Count above 21';
  @override
  String get worldId => 'number_groups';
  @override
  int get operationCount => 3;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 2;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final high = operands.where((n) => n > 21).length;
    final low = operands.where((n) => n <= 21).length;
    return mod42(high * 11 + low * 5);
  }

  @override
  String explanation(List<int> operands, int result) {
    final high = operands.where((n) => n > 21).length;
    final low = operands.where((n) => n <= 21).length;
    return 'Count values above 21 ($high) and at most 21 ($low). '
        'g = mod42($high×11 + $low×5) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'Compare each value to 21.',
        ruleFamily: 'A weighted count of high versus low values.',
        formulaConcept: 'g = mod42(count(>21)×11 + count(≤21)×5).',
      );
}

class FortyTwoSymmetryRule extends LogicRule {
  @override
  String get ruleId => 'forty_two_symmetry';
  @override
  String get displayName => '42 symmetry';
  @override
  String get worldId => 'forty_two_symmetry';
  @override
  int get operationCount => 8;
  @override
  int get transformDepth => 3;
  @override
  int get groupCount => 3;
  @override
  bool get requiresSorting => true;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => true;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final x = sortedCopy(operands);
    final offset = (x[0] + x[5] - 42).abs() +
        (x[1] + x[4] - 42).abs() +
        (x[2] + x[3] - 42).abs();
    return mod42(offset);
  }

  @override
  String explanation(List<int> operands, int result) {
    final x = sortedCopy(operands);
    final p1 = (x[0] + x[5] - 42).abs();
    final p2 = (x[1] + x[4] - 42).abs();
    final p3 = (x[2] + x[3] - 42).abs();
    final offset = p1 + p2 + p3;
    return 'Sort to ${x.join(', ')}. Pair (x1,x6), (x2,x5), (x3,x4) and measure distance from 42: '
        '|${x[0]}+${x[5]}−42|=$p1, |${x[1]}+${x[4]}−42|=$p2, |${x[2]}+${x[3]}−42|=$p3. '
        'offset=$offset. g = mod42(offset) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus:
            'After sorting, look at mirrored pairs from the ends inward.',
        ruleFamily: 'Compare mirrored pairs around 42.',
        formulaConcept:
            'Sort, then g = mod42(|x1+x6−42| + |x2+x5−42| + |x3+x4−42|).',
      );
}

class DigitThenRangeMetaRule extends LogicRule {
  @override
  String get ruleId => 'meta_digit_then_range';
  @override
  String get displayName => 'Digit sums then range';
  @override
  String get worldId => 'meta_rules';
  @override
  int get operationCount => 9;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 1;
  @override
  bool get requiresSorting => true;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final digits = operands.map(decimalDigitSum).toList();
    final mn = digits.reduce((a, b) => a < b ? a : b);
    final mx = digits.reduce((a, b) => a > b ? a : b);
    return mod42(mx - mn);
  }

  @override
  String explanation(List<int> operands, int result) {
    final digits = operands.map(decimalDigitSum).toList();
    final mn = digits.reduce((a, b) => a < b ? a : b);
    final mx = digits.reduce((a, b) => a > b ? a : b);
    return 'Stage 1 — digit sums: ${digits.join(', ')}. '
        'Stage 2 — range of those sums: $mx − $mn = ${mx - mn}. '
        'g = mod42(${mx - mn}) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus:
            'Transform each cell first, then look at the new six numbers.',
        ruleFamily: 'Two named steps: digit sums, then a range.',
        formulaConcept: 'g = mod42(max(digitSums) − min(digitSums)).',
      );
}

class PrimeCountThenModMetaRule extends LogicRule {
  @override
  String get ruleId => 'meta_prime_count_times_sum';
  @override
  String get displayName => 'Prime count times digit total';
  @override
  String get worldId => 'meta_rules';
  @override
  int get operationCount => 8;
  @override
  int get transformDepth => 2;
  @override
  int get groupCount => 2;
  @override
  bool get requiresSorting => false;
  @override
  bool get usesModulo => true;
  @override
  bool get usesAbsoluteValue => false;

  @override
  int evaluate(List<int> operands) {
    assertOperands(operands);
    final primeCount = operands.where(isPrime).length;
    final digitTotal = _sum(operands.map(decimalDigitSum));
    return mod42(primeCount * digitTotal);
  }

  @override
  String explanation(List<int> operands, int result) {
    final primeCount = operands.where(isPrime).length;
    final digits = operands.map(decimalDigitSum).toList();
    final digitTotal = _sum(digits);
    return 'Stage 1 — count primes (1 is not prime): $primeCount. '
        'Stage 2 — sum of digit sums ${digits.join(' + ')} = $digitTotal. '
        'g = mod42($primeCount × $digitTotal) = $result.';
  }

  @override
  HintStages hints() => const HintStages(
        visualFocus: 'Count primes, then look at the digits of every cell.',
        ruleFamily: 'Two named steps: a prime count and a digit-sum total.',
        formulaConcept: 'g = mod42(primeCount × sum(digitSums)).',
      );
}

List<LogicRule> builtInRules() => [
      ModularSumRule(),
      AlternatingSumRule(),
      OddEvenValueDifferenceRule(),
      OddEvenPositionDifferenceRule(),
      RangeRule(),
      MinPlusMaxRule(),
      MedianPairSumRule(),
      PrimeNonprimeDifferenceRule(),
      DigitSumRule(),
      CountWeightedParityRule(),
      CountAbove21Rule(),
      FortyTwoSymmetryRule(),
      DigitThenRangeMetaRule(),
      PrimeCountThenModMetaRule(),
    ];
