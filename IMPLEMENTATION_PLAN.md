# Logic 42 — Implementation Plan

Status: in progress. Flutter SDK was not on PATH at audit time; the project is initialized for SDK `3.35+` / Dart `3.9+` (stable channel). Commands below assume `C:\Users\admin\flutter\bin` is on PATH.

Application ID (replaceable): `app.logic42.game`  
Project name: `logic_42`  
Default flavor: `offlineDemo`

## Audit (Milestone 1)

| Item | Result |
|---|---|
| Repository | Folder contained only `logic-42-build-prompt.md` |
| Git | Available (`2.49`) |
| Flutter/Dart | Not on PATH; installing stable SDK locally |
| Firebase credentials | Absent (correct; `offlineDemo` must run without them) |
| Signing | None (documented as human-only) |

## Proposed file tree

See `docs/ARCHITECTURE.md` after scaffold. High-level:

```
lib/app/          bootstrap, router, theme, l10n, config/flavors
lib/core/         result, clock, errors, widgets
lib/features/     puzzle, progression, daily, speed, discovery, profile, settings, monetization
lib/services/     local persistence, firebase adapters (optional)
test/             unit + widget
integration_test/ first-run classic flow
tool/             puzzle pack generator CLI
assets/puzzles/   versioned curated + generated JSON
docs/             architecture, puzzle format, firebase, store
.github/workflows/ci.yml
```

## Dependencies (SDK-compatible, no invented APIs)

- `flutter_riverpod`, `go_router`
- `shared_preferences` (theme, sound, reduced-motion override)
- `path_provider` + versioned JSON progress store (structured, migratable; Drift deferred until codegen is verified)
- `intl` + `flutter_localizations` / `flutter_gen` ARB
- Firebase packages behind optional adapters; app compiles without `google-services.json`
- `in_app_purchase` behind `StoreService` with `monetizationEnabled: false`

## Milestones

- [x] M1 — Plan, architecture skeleton, theme, routing, localization
- [ ] M2 — Pure rule engine, mod42, registry, validator, unit tests
- [ ] M3 — JSON format, generator, `tool/` CLI, validation report
- [ ] M4 — Classic vertical slice + local persistence + XP
- [ ] M5 — Hints, Discovery, Speed, Daily cache, stats, a11y
- [ ] M6 — Firebase interfaces + docs + merge policy (no fabricated creds)
- [ ] M7 — Disabled monetization + fake store restore + legal placeholders
- [ ] M8 — Integration tests, CI, quality gates, build report

## Risks

| Risk | Mitigation |
|---|---|
| Flutter/Android toolchain missing | Install SDK; still ship complete Dart sources; document Android Studio/SDK as human step if `flutter build apk` cannot run |
| Rule ambiguity too strict | Cap generator attempts; ship curated unambiguous seeds |
| Codegen (freezed/drift) friction | Explicit immutable models + JSON store |
| iOS build on Windows | Document; skip codesign |
| Firebase absent | `offlineDemo` adapters only |

## Account-dependent (not agent-completable)

Apple Developer, Play Console, Firebase project, signing keys, legal text, store listings, live IAP (kept disabled; student/non-self-employment constraint).

## Acceptance tests (agent)

1. `offlineDemo` launches without Firebase files.
2. Onboarding → world → puzzle → hints → submit → XP → restart restore.
3. Board is 6×7; only row 6 `g` is editable.
4. All values 1–42 via one-based `mod42`.
5. Shipped JSON validates and is unambiguous.
6. `dart format`, `flutter analyze`, `flutter test` pass when SDK is available.
