import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';
import '../../domain/content/worlds.dart';

class WorldsScreen extends ConsumerWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final player = ref.watch(playerProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.worlds)),
      body: ListView(
        children: [
          for (final world in worlds)
            ListTile(
              title: Text(_title(l10n, world.id)),
              subtitle: Text(
                  player.worldUnlocked(world.id) ? l10n.play : l10n.locked),
              enabled: player.worldUnlocked(world.id),
              onTap: player.worldUnlocked(world.id)
                  ? () => context.push('/worlds/${world.id}')
                  : null,
            ),
        ],
      ),
    );
  }

  String _title(AppLocalizations l10n, String id) {
    switch (id) {
      case 'basic_patterns':
        return l10n.worldBasicPatterns;
      case 'modular_rules':
        return l10n.worldModularRules;
      case 'number_groups':
        return l10n.worldNumberGroups;
      case 'prime_logic':
        return l10n.worldPrimeLogic;
      case 'forty_two_symmetry':
        return l10n.worldFortyTwoSymmetry;
      default:
        return l10n.worldMetaRules;
    }
  }
}
