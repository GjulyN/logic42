import 'package:flutter/material.dart';

import '../../../../app/localization/generated/app_localizations.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.kind});

  final String kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (kind) {
      'privacy' => l10n.privacy,
      'terms' => l10n.terms,
      _ => l10n.about,
    };
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(l10n.legalPlaceholder),
      ),
    );
  }
}
