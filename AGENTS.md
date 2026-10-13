# Logic 42 Agent Rules

- Run `dart format`, `flutter analyze`, and relevant tests after every meaningful change.
- Keep puzzle rules, generation, validation, scoring, and progression pure Dart (`lib/features/puzzle/domain`, `lib/features/progression/domain`). Those folders must not import Flutter, Firebase, Riverpod, or storage packages.
- UI code must not import Firebase or database implementations directly; use repositories and adapters.
- All outputs must use one-based modulo (`mod42`) and remain in 1–42.
- Never ship an unvalidated or ambiguous puzzle.
- Keep `offlineDemo` fully playable without credentials or network access.
- Add tests with every rule or scoring change.
- Never commit secrets, signing files, service-account credentials, or production Firebase configuration.
- Do not mark account-dependent release tasks complete without verification.
- Prefer small, reviewable changes and report exact commands run.
- Default `monetizationEnabled` is false; do not unlock premium from a local boolean.
