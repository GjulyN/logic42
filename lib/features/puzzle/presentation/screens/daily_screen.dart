import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';
import '../../domain/daily/daily_seed.dart';

class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final puzzle = dailyPuzzle(ref);
    final dateId = dailyPuzzleId(ref.read(clockProvider).nowUtc());
    final rankedUsed =
        ref.watch(playerProvider).dailyRankedDates.contains(dateId);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.daily)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(dateId),
            if (rankedUsed) Text(l10n.rankedUsed),
            FilledButton(
              onPressed: () async {
                ref.read(catalogProvider).registerRuntime(puzzle);
                if (!rankedUsed) {
                  await ref
                      .read(playerProvider.notifier)
                      .markDailyRanked(dateId);
                }
                if (context.mounted) context.push('/play/${puzzle.id}');
              },
              child: Text(rankedUsed ? l10n.practice : l10n.play),
            ),
          ],
        ),
      ),
    );
  }
}
