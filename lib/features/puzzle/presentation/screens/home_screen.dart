import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';
import '../../../../features/progression/domain/level_curve.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final player = ref.watch(playerProvider);
    final level = levelForXp(player.xp);
    final next = xpForNextLevel(player.xp);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.level(level), style: Theme.of(context).textTheme.titleLarge),
          Text('${l10n.xp}: ${player.xp} / $next'),
          Text('${l10n.streak}: ${player.streak.current}'),
          const SizedBox(height: 16),
          _tile(context, l10n.classic, '/worlds'),
          _tile(context, l10n.daily, '/daily'),
          _tile(context, l10n.speed, '/speed'),
          _tile(context, l10n.discovery, '/discovery'),
          _tile(context, l10n.stats, '/stats'),
          _tile(context, l10n.achievements, '/achievements'),
          _tile(context, l10n.settings, '/settings'),
          _tile(context, l10n.profile, '/profile'),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String label, String path) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(path),
        minVerticalPadding: 16,
      ),
    );
  }
}
