import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(l10n.offlineAccount),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                await ref.read(authProvider).ensureAnonymousUser();
              },
              child: Text(l10n.signInUpgrade),
            ),
          ],
        ),
      ),
    );
  }
}
