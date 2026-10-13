import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';

class LevelsScreen extends ConsumerWidget {
  const LevelsScreen({super.key, required this.worldId});

  final String worldId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final puzzles = ref.watch(catalogProvider).forWorld(worldId);
    final player = ref.watch(playerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.classic)),
      body: ListView.builder(
        itemCount: puzzles.length,
        itemBuilder: (context, i) {
          final item = puzzles[i];
          final rec = player.recordFor(item.definition.id);
          final locked = i > 0 &&
              !player.recordFor(puzzles[i - 1].definition.id).completed;
          return ListTile(
            title: Text('${item.index}. ${item.definition.difficultyLabel}'),
            subtitle: Text(
              rec.completed
                  ? '${'★' * rec.stars}  ${l10n.attempts} ${rec.attempts}'
                  : (locked ? l10n.locked : l10n.play),
            ),
            enabled: !locked,
            onTap: locked ? null : () => context.push('/play/${item.definition.id}'),
          );
        },
      ),
    );
  }
}
