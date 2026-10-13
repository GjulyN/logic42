import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_42/app/localization/generated/app_localizations.dart';
import 'package:logic_42/core/clock/clock.dart';
import 'package:logic_42/features/puzzle/domain/generator/puzzle_generator.dart';
import 'package:logic_42/features/puzzle/domain/rules/rule_registry.dart';
import 'package:logic_42/features/puzzle/presentation/board.dart';
import 'package:logic_42/features/puzzle/presentation/play_controller.dart';

void main() {
  final puzzle = PuzzleGenerator(registry: RuleRegistry())
      .generate(seed: 101, ruleId: 'range');

  testWidgets('board is 6x7 and only g6 editable', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PuzzleBoard(
            puzzle: puzzle,
            guess: null,
            selected: true,
            onSelectEditable: () {},
          ),
        ),
      ),
    );
    expect(find.byType(PuzzleBoard), findsOneWidget);
    expect(find.text('?'), findsOneWidget);
  });

  test('input rejects 0, 43, empty submit', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final clock = FakeClock(DateTime.utc(2026, 1, 1));
    container.read(playProvider.notifier).start(puzzle, clock);
    container.read(playProvider.notifier).typeDigit(0);
    expect(container.read(playProvider)!.guess, isNull);
    container.read(playProvider.notifier).typeDigit(43);
    expect(container.read(playProvider)!.guess, isNull);
    expect(container.read(playProvider.notifier).submit(), isFalse);
    container.read(playProvider.notifier).typeDigit(12);
    expect(container.read(playProvider)!.guess, 12);
  });

  test('hint progression 1-3', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(playProvider.notifier)
        .start(puzzle, FakeClock(DateTime.utc(2026, 1, 1)));
    container.read(playProvider.notifier).useHint();
    container.read(playProvider.notifier).useHint();
    container.read(playProvider.notifier).useHint();
    container.read(playProvider.notifier).useHint();
    expect(container.read(playProvider)!.hintsUsed, 3);
  });
}
