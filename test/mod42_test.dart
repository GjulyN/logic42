import 'package:flutter_test/flutter_test.dart';
import 'package:logic_42/features/puzzle/domain/math/mod42.dart';
import 'package:logic_42/features/puzzle/domain/math/number_theory.dart';

void main() {
  group('mod42', () {
    test('positive in range', () {
      expect(mod42(1), 1);
      expect(mod42(42), 42);
      expect(mod42(21), 21);
    });
    test('zero maps to 42', () {
      expect(mod42(0), 42);
    });
    test('multiples of 42', () {
      expect(mod42(42), 42);
      expect(mod42(84), 42);
    });
    test('just after wrap', () {
      expect(mod42(43), 1);
    });
    test('negatives', () {
      expect(mod42(-1), 41);
      expect(mod42(-41), 1);
      expect(mod42(-42), 42);
    });
  });

  group('primes', () {
    test('1 is neither', () {
      expect(isPrime(1), isFalse);
      expect(isComposite(1), isFalse);
    });
    test('2 is prime', () => expect(isPrime(2), isTrue));
    test('42 is composite', () {
      expect(isPrime(42), isFalse);
      expect(isComposite(42), isTrue);
    });
  });
}
