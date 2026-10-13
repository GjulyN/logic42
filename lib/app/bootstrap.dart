import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/puzzle/data/puzzle_catalog.dart';
import 'providers.dart';

Future<void> bootstrapApp(ProviderContainer container) async {
  WidgetsFlutterBinding.ensureInitialized();
  final catalog = container.read(catalogProvider);
  try {
    await catalog.loadAsset('assets/puzzles/seed_pack_v1.json');
  } catch (_) {
    catalog.loadFromSeeds(curatedSeeds);
  }
  await container.read(playerProvider.notifier).hydrate();
  await container.read(settingsProvider.notifier).hydrate();
}
