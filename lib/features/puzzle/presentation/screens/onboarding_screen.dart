import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/providers.dart';
import '../../../../core/analytics/analytics_events.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.onboardingTitle,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(l10n.onboardingBody),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                await ref.read(playerProvider.notifier).completeOnboarding();
                await ref
                    .read(analyticsProvider)
                    .track(AnalyticsEvents.onboardingCompleted());
                if (context.mounted) context.go('/home');
              },
              child: Text(l10n.continueLabel),
            ),
          ],
        ),
      ),
    );
  }
}
