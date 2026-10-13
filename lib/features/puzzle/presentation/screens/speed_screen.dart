import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';
import '../../../../core/analytics/analytics_events.dart';

class SpeedScreen extends ConsumerWidget {
  const SpeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final best = ref.watch(playerProvider).speedBestMs;
    final puzzles = ref.watch(catalogProvider).puzzles.take(5).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.speed)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(l10n.speedPaused),
            if (best != null) Text('${l10n.bestTime}: ${best}ms'),
            FilledButton(
              onPressed: puzzles.isEmpty
                  ? null
                  : () async {
                      if (context.mounted) {
                        context.push('/play/${puzzles.first.definition.id}');
                      }
                      await ref
                          .read(analyticsProvider)
                          .track(AnalyticsEvents.speedRunCompleted());
                    },
              child: Text(l10n.speedStart),
            ),
          ],
        ),
      ),
    );
  }
}
