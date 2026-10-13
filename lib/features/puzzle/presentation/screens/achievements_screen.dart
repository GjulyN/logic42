import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = ref.watch(playerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievements)),
      body: ListView(
        children: [
          ListTile(
            title: const Text('3-day streak'),
            trailing: Icon(p.streak.milestone3 ? Icons.verified : Icons.lock),
          ),
          ListTile(
            title: const Text('7-day streak'),
            trailing: Icon(p.streak.milestone7 ? Icons.verified : Icons.lock),
          ),
          ListTile(
            title: const Text('30-day streak'),
            trailing: Icon(p.streak.milestone30 ? Icons.verified : Icons.lock),
          ),
          for (final b in p.badges) ListTile(title: Text(b)),
        ],
      ),
    );
  }
}
