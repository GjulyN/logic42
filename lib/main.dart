import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';

Future<void> main() async {
  final container = ProviderContainer();
  await bootstrapApp(container);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const Logic42App(),
    ),
  );
}
