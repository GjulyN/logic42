import 'dart:convert';
import 'dart:io';

import 'package:logic_42/features/puzzle/data/puzzle_catalog.dart';
import 'package:logic_42/features/puzzle/domain/generator/generation_failure.dart';
import 'package:logic_42/features/puzzle/domain/generator/puzzle_generator.dart';
import 'package:logic_42/features/puzzle/domain/rules/rule_registry.dart';
import 'package:logic_42/features/puzzle/domain/validation/puzzle_validator.dart';

void main(List<String> args) {
  final registry = RuleRegistry();
  final validator = PuzzleValidator(registry);
  final generator = PuzzleGenerator(registry: registry, validator: validator);
  final puzzles = <Map<String, Object?>>[];
  var invalid = 0;
  var ambiguous = 0;
  var duplicates = 0;
  final ids = <String>{};
  final ruleCounts = <String, int>{};
  final diffCounts = <String, int>{};

  for (final spec in curatedSeeds) {
    try {
      final def = generator.generate(
        seed: spec.seed,
        ruleId: spec.ruleId,
        worldId: spec.worldId,
      );
      final result = validator.validate(def);
      if (!result.valid) {
        invalid++;
        if (result.reasons.any((r) => r.contains('Ambiguous'))) {
          ambiguous++;
        }
        stderr.writeln('REJECT ${def.id}: ${result.reasons.join('; ')}');
        continue;
      }
      if (!ids.add(def.id)) {
        duplicates++;
        continue;
      }
      ruleCounts[def.ruleId] = (ruleCounts[def.ruleId] ?? 0) + 1;
      diffCounts[def.difficultyLabel] =
          (diffCounts[def.difficultyLabel] ?? 0) + 1;
      puzzles.add({
        'worldId': spec.worldId,
        'index': spec.index,
        'definition': def.toJson(),
      });
    } on GenerationFailure catch (e) {
      invalid++;
      stderr.writeln(e);
    }
  }

  final pack = {
    'packVersion': 1,
    'generatorVersion': 1,
    'puzzles': puzzles,
  };
  final out = File('assets/puzzles/seed_pack_v1.json');
  out.parent.createSync(recursive: true);
  out.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(pack));

  final report = {
    'puzzleCount': puzzles.length,
    'ruleDistribution': ruleCounts,
    'difficultyDistribution': diffCounts,
    'duplicateCount': duplicates,
    'invalidCount': invalid,
    'ambiguousCount': ambiguous,
  };
  File('docs/validation_report.json')
    ..parent.createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(report));
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(report));
  if (puzzles.isEmpty) {
    exitCode = 1;
  }
}
