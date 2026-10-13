bool isPrime(int n) {
  if (n <= 1) return false;
  if (n == 2) return true;
  if (n.isEven) return false;
  for (var d = 3; d * d <= n; d += 2) {
    if (n % d == 0) return false;
  }
  return true;
}

/// 1 is neither prime nor composite.
bool isComposite(int n) => n > 1 && !isPrime(n);

bool isOdd(int n) => n.isOdd;

bool isEven(int n) => n.isEven;

int decimalDigitSum(int n) {
  var x = n.abs();
  var s = 0;
  while (x > 0) {
    s += x % 10;
    x ~/= 10;
  }
  return s;
}

List<int> sortedCopy(List<int> values) {
  final copy = List<int>.from(values);
  copy.sort();
  return copy;
}
