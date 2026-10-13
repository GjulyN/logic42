import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/generated/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../core/analytics/analytics_events.dart';
import '../../puzzle/domain/rules/logic_rule.dart';

class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rules = ref.watch(ruleRegistryProvider).all;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discovery)),
      body: ListView(
        children: [
          for (final rule in rules)
            ListTile(
              title: Text(rule.displayName),
              subtitle: Text(rule.hints().formulaConcept),
              onTap: () async {
                await ref
                    .read(analyticsProvider)
                    .track(AnalyticsEvents.lessonCompleted(rule.ruleId));
                if (context.mounted) {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => LessonScreen(rule: rule),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.rule});

  final LogicRule rule;

  @override
  Widget build(BuildContext context) {
    const demo = [3, 8, 15, 16, 23, 42];
    final g = rule.evaluate(demo);
    return Scaffold(
      appBar: AppBar(title: Text(rule.displayName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rule.hints().visualFocus),
            const SizedBox(height: 8),
            Text(rule.hints().ruleFamily),
            const SizedBox(height: 8),
            Text(rule.hints().formulaConcept),
            const SizedBox(height: 16),
            Text(demo.join(' | ')),
            Text(rule.explanation(demo, g)),
          ],
        ),
      ),
    );
  }
}
