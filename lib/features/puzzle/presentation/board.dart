import 'package:flutter/material.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/theme/app_theme.dart';
import '../domain/models/puzzle_definition.dart';

const columns = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({
    super.key,
    required this.puzzle,
    required this.guess,
    required this.selected,
    required this.onSelectEditable,
    this.relatedMask,
    this.feedback,
    this.revealAnswer = false,
    this.highContrast = false,
  });

  final PuzzleDefinition puzzle;
  final int? guess;
  final bool selected;
  final VoidCallback onSelectEditable;
  final List<bool>? relatedMask;
  final bool? feedback;
  final bool revealAnswer;
  final bool highContrast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = [...puzzle.trainingRows, puzzle.targetRow];
    return Semantics(
      container: true,
      label: l10n.appTitle,
      child: Column(
        children: [
          for (var r = 0; r < 6; r++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  for (var c = 0; c < 7; c++)
                    Expanded(
                      child: _cell(
                        context,
                        l10n,
                        row: r,
                        col: c,
                        isResult: c == 6,
                        value: c < 6
                            ? rows[r].operands[c]
                            : (r < 5
                                ? rows[r].result
                                : (revealAnswer ? puzzle.answer : guess)),
                        editable: r == 5 && c == 6,
                        related: relatedMask != null &&
                            c < 6 &&
                            relatedMask![c],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _cell(
    BuildContext context,
    AppLocalizations l10n, {
    required int row,
    required int col,
    required bool isResult,
    required int? value,
    required bool editable,
    required bool related,
  }) {
    final cs = Theme.of(context).colorScheme;
    Color bg = isResult ? cs.secondaryContainer : cs.surfaceContainerHighest;
    if (editable) bg = cs.primaryContainer;
    if (related) bg = cs.tertiaryContainer;
    if (feedback == true && editable) bg = Colors.green.shade700;
    if (feedback == false && editable) bg = Colors.red.shade800;
    if (highContrast) {
      bg = editable ? Colors.black : (isResult ? Colors.grey.shade800 : cs.surface);
    }
    final border = Border.all(
      color: selected && editable ? AppColors.accent42 : cs.outline,
      width: selected && editable ? 3 : (isResult ? 2 : 1),
    );
    final text = value?.toString() ?? (editable ? '?' : '');
    final style = TextStyle(
      fontWeight: isResult || editable ? FontWeight.w800 : FontWeight.w600,
      fontSize: 16,
      decoration: related ? TextDecoration.underline : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Semantics(
        button: editable,
        selected: selected && editable,
        label: l10n.cellLabel(row + 1, columns[col]),
        value: text,
        child: InkWell(
          onTap: editable ? onSelectEditable : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: bg,
                border: border,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  text,
                  style: style,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.buffer,
    required this.onDigit,
    required this.onDelete,
    required this.onSubmit,
  });

  final String buffer;
  final ValueChanged<int> onDigit;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(buffer.isEmpty ? l10n.enterNumber : buffer,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final row in [
          [1, 2, 3, 4, 5, 6, 7],
          [8, 9, 10, 11, 12, 13, 14],
          [15, 16, 17, 18, 19, 20, 21],
          [22, 23, 24, 25, 26, 27, 28],
          [29, 30, 31, 32, 33, 34, 35],
          [36, 37, 38, 39, 40, 41, 42],
        ])
          Row(
            children: [
              for (final n in row)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      height: 48,
                      child: FilledButton.tonal(
                        onPressed: () => onDigit(n),
                        child: Text('$n'),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onDelete,
                child: Text(l10n.delete),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: onSubmit,
                child: Text(l10n.submit),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
