import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/generator/puzzle_generator.dart';
import '../domain/models/puzzle_definition.dart';
import '../domain/rules/rule_registry.dart';
import '../domain/validation/puzzle_validator.dart';

class CatalogPuzzle {
  const CatalogPuzzle({
    required this.worldId,
    required this.index,
    required this.definition,
  });

  final String worldId;
  final int index;
  final PuzzleDefinition definition;
}

class PuzzleCatalog {
  PuzzleCatalog({
    required this.registry,
    PuzzleValidator? validator,
    PuzzleGenerator? generator,
  })  : validator = validator ?? PuzzleValidator(registry),
        generator = generator ?? PuzzleGenerator(registry: registry);

  final RuleRegistry registry;
  final PuzzleValidator validator;
  final PuzzleGenerator generator;

  List<CatalogPuzzle> _puzzles = const [];

  List<CatalogPuzzle> get puzzles => _puzzles;

  List<CatalogPuzzle> forWorld(String worldId) =>
      _puzzles.where((p) => p.worldId == worldId).toList()
        ..sort((a, b) => a.index.compareTo(b.index));

  CatalogPuzzle byId(String id) =>
      _puzzles.firstWhere((p) => p.definition.id == id);

  void registerRuntime(PuzzleDefinition def, {String? worldId, int index = 0}) {
    if (_puzzles.any((p) => p.definition.id == def.id)) return;
    _puzzles = List.unmodifiable([
      ..._puzzles,
      CatalogPuzzle(
        worldId: worldId ?? def.worldId,
        index: index,
        definition: def,
      ),
    ]);
  }

  Future<void> loadAsset(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    loadJsonString(raw);
  }

  void loadJsonString(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('Pack must be an object');
    }
    final pack = Map<String, dynamic>.from(decoded);
    final version = pack['packVersion'];
    if (version is! int) {
      throw const FormatException('packVersion required');
    }
    final list = pack['puzzles'];
    if (list is! List) {
      throw const FormatException('puzzles array required');
    }
    final loaded = <CatalogPuzzle>[];
    for (final item in list) {
      final map = Map<String, dynamic>.from(item as Map);
      final def = PuzzleDefinition.fromJson(map['definition'] ?? map);
      final result = validator.validate(def);
      if (!result.valid) {
        throw FormatException(
          'Unvalidated puzzle ${def.id}: ${result.reasons.join('; ')}',
        );
      }
      loaded.add(
        CatalogPuzzle(
          worldId: map['worldId'] as String? ?? def.worldId,
          index: map['index'] as int? ?? 0,
          definition: def,
        ),
      );
    }
    _puzzles = List.unmodifiable(loaded);
  }

  /// Developer fallback: generate a validated seed pack from declared seeds.
  void loadFromSeeds(List<SeedSpec> seeds) {
    final loaded = <CatalogPuzzle>[];
    for (final spec in seeds) {
      final def = generator.generate(
        seed: spec.seed,
        ruleId: spec.ruleId,
        worldId: spec.worldId,
      );
      final result = validator.validate(def);
      if (!result.valid) {
        throw FormatException(
          'Seed ${spec.seed}/${spec.ruleId} invalid: ${result.reasons.join('; ')}',
        );
      }
      loaded.add(
        CatalogPuzzle(
            worldId: spec.worldId, index: spec.index, definition: def),
      );
    }
    _puzzles = List.unmodifiable(loaded);
  }
}

class SeedSpec {
  const SeedSpec({
    required this.seed,
    required this.ruleId,
    required this.worldId,
    required this.index,
  });

  final int seed;
  final String ruleId;
  final String worldId;
  final int index;
}

/// High-quality seed coordinates; JSON is the shipping format.
const curatedSeeds = <SeedSpec>[
  SeedSpec(seed: 101, ruleId: 'range', worldId: 'basic_patterns', index: 1),
  SeedSpec(
      seed: 102, ruleId: 'min_plus_max', worldId: 'basic_patterns', index: 2),
  SeedSpec(
      seed: 103,
      ruleId: 'median_pair_sum',
      worldId: 'basic_patterns',
      index: 3),
  SeedSpec(seed: 104, ruleId: 'digit_sum', worldId: 'basic_patterns', index: 4),
  SeedSpec(
      seed: 201, ruleId: 'modular_sum', worldId: 'modular_rules', index: 1),
  SeedSpec(
      seed: 202, ruleId: 'alternating_sum', worldId: 'modular_rules', index: 2),
  SeedSpec(
      seed: 301,
      ruleId: 'odd_even_value_diff',
      worldId: 'number_groups',
      index: 1),
  SeedSpec(
      seed: 302,
      ruleId: 'odd_even_position_diff',
      worldId: 'number_groups',
      index: 2),
  SeedSpec(
      seed: 303,
      ruleId: 'count_weighted_parity',
      worldId: 'number_groups',
      index: 3),
  SeedSpec(
      seed: 304, ruleId: 'count_above_21', worldId: 'number_groups', index: 4),
  SeedSpec(
      seed: 401,
      ruleId: 'prime_nonprime_diff',
      worldId: 'prime_logic',
      index: 1),
  SeedSpec(
      seed: 501,
      ruleId: 'forty_two_symmetry',
      worldId: 'forty_two_symmetry',
      index: 1),
  SeedSpec(
      seed: 601,
      ruleId: 'meta_digit_then_range',
      worldId: 'meta_rules',
      index: 1),
  SeedSpec(
      seed: 602,
      ruleId: 'meta_prime_count_times_sum',
      worldId: 'meta_rules',
      index: 2),
];
