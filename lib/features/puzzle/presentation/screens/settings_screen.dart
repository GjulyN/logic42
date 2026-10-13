import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.theme),
            subtitle: Text(switch (s.themeMode) {
              1 => 'Light',
              2 => 'Dark',
              _ => 'System',
            }),
            onTap: () => n.update(s.copyWith(themeMode: (s.themeMode + 1) % 3)),
          ),
          SwitchListTile(
            title: Text(l10n.sound),
            value: s.sound,
            onChanged: (v) => n.update(s.copyWith(sound: v)),
          ),
          SwitchListTile(
            title: Text(l10n.haptics),
            value: s.haptics,
            onChanged: (v) => n.update(s.copyWith(haptics: v)),
          ),
          SwitchListTile(
            title: Text(l10n.reduceMotion),
            value: s.reduceMotion,
            onChanged: (v) => n.update(s.copyWith(reduceMotion: v)),
          ),
          SwitchListTile(
            title: Text(l10n.highContrast),
            value: s.highContrast,
            onChanged: (v) => n.update(s.copyWith(highContrast: v)),
          ),
          ListTile(
            title: Text(l10n.privacy),
            onTap: () => context.push('/legal/privacy'),
          ),
          ListTile(
            title: Text(l10n.terms),
            onTap: () => context.push('/legal/terms'),
          ),
          ListTile(
            title: Text(l10n.about),
            onTap: () => context.push('/legal/about'),
          ),
        ],
      ),
    );
  }
}
