import '../math/mod42.dart';

class PuzzleRow {
  const PuzzleRow({
    required this.operands,
    this.result,
  });

  /// Exactly six values in 1..42: a, b, c, d, e, f.
  final List<int> operands;

  /// g, when known. Null for the unsolved target cell.
  final int? result;

  int get a => operands[0];
  int get b => operands[1];
  int get c => operands[2];
  int get d => operands[3];
  int get e => operands[4];
  int get f => operands[5];

  void validateShape({required bool requireResult}) {
    assertOperands(operands);
    if (requireResult) {
      final g = result;
      if (g == null || !isInRange(g)) {
        throw FormatException('Row result must be in 1..42, got $g');
      }
    }
  }

  Map<String, Object?> toJson() => {
        'operands': operands,
        'result': result,
      };

  factory PuzzleRow.fromJson(Object? json) {
    if (json is! Map<String, dynamic> && json is! Map) {
      throw const FormatException('PuzzleRow must be an object');
    }
    final map = Map<String, dynamic>.from(json as Map);
    final raw = map['operands'];
    if (raw is! List) {
      throw const FormatException('operands must be a list of 6 integers');
    }
    final operands = raw.map((e) {
      if (e is int) return e;
      if (e is num) return e.toInt();
      throw const FormatException('operands must be integers');
    }).toList();
    final g = map['result'];
    int? result;
    if (g != null) {
      if (g is int) {
        result = g;
      } else if (g is num) {
        result = g.toInt();
      } else {
        throw const FormatException('result must be an integer or null');
      }
    }
    return PuzzleRow(operands: List.unmodifiable(operands), result: result);
  }
}
