import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';
import '../../../../core/analytics/analytics_events.dart';
import '../../domain/rules/logic_rule.dart';
import '../../data/puzzle_catalog.dart';
import '../board.dart';
import '../play_controller.dart';

class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key, required this.puzzleId});

  final String puzzleId;

  @override
  ConsumerState<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catalog = ref.read(catalogProvider);
      final entry = _findPuzzle(catalog, widget.puzzleId);
      if (entry == null) {
        context.go('/home');
        return;
      }
      final puzzle = entry.definition;
      ref.read(playProvider.notifier).start(puzzle, ref.read(clockProvider));
      ref
          .read(analyticsProvider)
          .track(AnalyticsEvents.puzzleStarted(puzzle.id));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final clock = ref.read(clockProvider);
    final play = ref.read(playProvider.notifier);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      play.pause(clock);
    } else if (state == AppLifecycleState.resumed) {
      play.resume(clock);
    }
  }

  Future<void> _submit() async {
    final play = ref.read(playProvider.notifier);
    final s = ref.read(playProvider);
    if (s == null) return;
    final ok = play.submit();
    await ref.read(analyticsProvider).track(
          AnalyticsEvents.answerSubmitted(puzzleId: s.puzzle.id, correct: ok),
        );
    if (!ok) return;
    final settings = ref.read(settingsProvider);
    if (settings.haptics) {
      await HapticFeedback.mediumImpact();
    }
    final elapsed = play.elapsed(ref.read(clockProvider));
    final score = await ref.read(playerProvider.notifier).applySolve(
          puzzle: s.puzzle,
          elapsed: elapsed,
          hintsUsed: ref.read(playProvider)!.hintsUsed,
          attempts: ref.read(playProvider)!.attempts,
          gaveUp: false,
        );
    ref.read(playProvider.notifier).attachScore(score);
    await ref
        .read(analyticsProvider)
        .track(AnalyticsEvents.puzzleSolved(s.puzzle.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(playProvider);
    final settings = ref.watch(settingsProvider);
    if (state == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final rule = ref.read(ruleRegistryProvider).byId(state.puzzle.ruleId);
    final related = state.hintsUsed >= 1 ? visualMask(rule) : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.pause,
            onPressed: () => _pauseSheet(context, l10n),
            icon: const Icon(Icons.pause),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            PuzzleBoard(
              puzzle: state.puzzle,
              guess: state.guess,
              selected: state.selected && state.phase == PlayPhase.playing,
              onSelectEditable: () {},
              relatedMask: related,
              feedback: state.phase == PlayPhase.correct
                  ? true
                  : (state.lastWrong ? false : null),
              revealAnswer: state.phase == PlayPhase.givenUp,
              highContrast: settings.highContrast,
            ),
            if (state.lastWrong)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(l10n.incorrect, semanticsLabel: l10n.incorrect),
              ),
            if (state.phase == PlayPhase.playing) ...[
              NumberPad(
                buffer: state.buffer,
                onDigit: ref.read(playProvider.notifier).typeDigit,
                onDelete: ref.read(playProvider.notifier).delete,
                onSubmit: _submit,
              ),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: state.hintsUsed < 3 ? _openHint : null,
                    child: Text('${l10n.hint} ${state.hintsUsed}/3'),
                  ),
                  TextButton(
                    onPressed: () async {
                      ref.read(playProvider.notifier).giveUp();
                      await ref.read(playerProvider.notifier).applySolve(
                            puzzle: state.puzzle,
                            elapsed: ref
                                .read(playProvider.notifier)
                                .elapsed(ref.read(clockProvider)),
                            hintsUsed: state.hintsUsed,
                            attempts: state.attempts,
                            gaveUp: true,
                          );
                      await ref.read(analyticsProvider).track(
                          AnalyticsEvents.puzzleAbandoned(state.puzzle.id));
                    },
                    child: Text(l10n.giveUp),
                  ),
                ],
              ),
            ],
            if (state.phase == PlayPhase.correct)
              _result(context, l10n, rule, false),
            if (state.phase == PlayPhase.givenUp)
              _result(context, l10n, rule, true),
          ],
        ),
      ),
    );
  }

  Widget _result(
    BuildContext context,
    AppLocalizations l10n,
    LogicRule rule,
    bool givenUp,
  ) {
    final state = ref.read(playProvider)!;
    final explanation =
        rule.explanation(state.puzzle.targetRow.operands, state.puzzle.answer);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(givenUp ? l10n.solution : l10n.correct,
            style: Theme.of(context).textTheme.headlineSmall),
        if (state.score != null && state.score!.awarded)
          Text('${l10n.xpEarned}: ${state.score!.totalXp} '
              '(${state.score!.baseXp}+${state.score!.timeBonus}+'
              '${state.score!.noHintBonus}+${state.score!.firstAttemptBonus})'),
        const SizedBox(height: 8),
        Text(l10n.solution, style: Theme.of(context).textTheme.titleMedium),
        Text(explanation),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => context.pop(),
          child: Text(l10n.nextPuzzle),
        ),
      ],
    );
  }

  void _openHint() {
    final state = ref.read(playProvider)!;
    ref.read(playProvider.notifier).useHint();
    final level = ref.read(playProvider)!.hintsUsed;
    ref.read(analyticsProvider).track(
          AnalyticsEvents.hintUsed(puzzleId: state.puzzle.id, level: level),
        );
    final rule = ref.read(ruleRegistryProvider).byId(state.puzzle.ruleId);
    final hints = rule.hints();
    final text = switch (level) {
      1 => hints.visualFocus,
      2 => hints.ruleFamily,
      _ => hints.formulaConcept,
    };
    showModalBottomSheet<void>(
      context: context,
      builder: (c) => Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text),
      ),
    );
  }

  void _pauseSheet(BuildContext context, AppLocalizations l10n) {
    ref.read(playProvider.notifier).pause(ref.read(clockProvider));
    showModalBottomSheet<void>(
      context: context,
      builder: (c) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.pause),
            FilledButton(
              onPressed: () {
                ref.read(playProvider.notifier).resume(ref.read(clockProvider));
                Navigator.pop(c);
              },
              child: Text(l10n.resume),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      ref.read(playProvider.notifier).resume(ref.read(clockProvider));
    });
  }

  static CatalogPuzzle? _findPuzzle(PuzzleCatalog catalog, String id) {
    for (final entry in catalog.puzzles) {
      if (entry.definition.id == id) return entry;
    }
    return null;
  }
}
