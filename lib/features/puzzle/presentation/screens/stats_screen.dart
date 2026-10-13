import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';
import '../../../progression/domain/level_curve.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = ref.watch(playerProvider);
    final solved = p.progress.values.where((e) => e.completed).length;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.stats)),
      body: ListView(
        children: [
          ListTile(title: Text(l10n.xp), subtitle: Text('${p.xp}')),
          ListTile(title: Text(l10n.level(levelForXp(p.xp)))),
          ListTile(
              title: Text(l10n.streak), subtitle: Text('${p.streak.current}')),
          ListTile(title: Text(l10n.classic), subtitle: Text('$solved')),
        ],
      ),
    );
  }
}
