import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization/generated/app_localizations.dart';
import 'providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class Logic42App extends ConsumerWidget {
  const Logic42App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);
    final themeMode = switch (settings.themeMode) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    var light = buildLightTheme();
    var dark = buildDarkTheme();
    if (settings.highContrast) {
      light = light.copyWith(
        colorScheme: light.colorScheme.copyWith(
          primary: Colors.black,
          onPrimary: Colors.white,
        ),
      );
      dark = dark.copyWith(
        colorScheme: dark.colorScheme.copyWith(
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
      );
    }
    return MaterialApp.router(
      title: 'Logic 42',
      theme: light,
      darkTheme: dark,
      themeMode: themeMode,
      routerConfig: router,
      localeListResolutionCallback: (locales, supported) {
        return basicLocaleListResolution(locales, supported);
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
