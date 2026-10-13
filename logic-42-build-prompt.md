# Logic 42 — Build Specification and Master Coding-Agent Prompt

## Direct recommendation

Use **Cursor as the primary coding agent** for this Flutter project. Cursor can edit a multi-file codebase, run terminal commands, and use a version-controlled `AGENTS.md` or `.cursor/rules/` file for persistent instructions; Replit’s documented mobile workflow is centered on Expo/Expo Go rather than Flutter, so it is less suitable for this exact stack.[^1][^2][^3][^4]

Build the first release as an **offline-first Android/iOS MVP**, with Firebase synchronization and online services behind interfaces and feature flags. Flutter’s architecture guidance recommends separation into views, view models, repositories, and services, which fits a puzzle engine that must remain testable independently of Firebase and the UI.[^5][^6][^7]

## Critical rule correction

The proposed board is **6 rows × 7 columns**, not 7 rows × 6 columns. Each row has six operands and one result:

```text
a | b | c | d | e | f | g
```

For a mathematically determinate core puzzle, rows 1–5 must show `a…f` and their computed `g`; row 6 must show `a…f` with **only `g` missing**. If all seven cells in row 6 are blank, the hidden row cannot generally be deduced from the five equations unless a second, explicitly defined column-generation rule is provided.

All rule outputs must stay in `1…42`. Ordinary modulo can return zero, so use the one-based normalization:

```text
mod42(value) = ((value - 1) mod 42) + 1
```

The example dataset in the concept document must be treated as visual mock data, not production puzzle data: its displayed outputs do not match the three example formulas. Every shipped puzzle therefore needs automatic validation against its declared rule.

## Product decisions

| Area | MVP decision |
|---|---|
| Platforms | Android and iOS |
| Orientation | Portrait primary; responsive landscape support |
| Core board | 6 rows × 7 columns; first five complete, sixth missing only `g` |
| Puzzle source | Curated JSON seed pack plus deterministic validated generator |
| Offline behavior | All classic puzzles, progression, settings, and streak data work locally |
| Online behavior | Anonymous auth, cloud save, daily puzzle, leaderboard, analytics, and crash reports |
| State management | Riverpod |
| Navigation | `go_router` |
| Models | Immutable Dart models with explicit JSON serialization |
| Local persistence | Repository abstraction; structured local database for progress; preferences only for small settings |
| Monetization | Disabled feature flag and store-service interface; no live products in the first build |
| Accessibility | Screen-reader labels, scalable text, high contrast, non-color-only feedback, at least 48 dp touch targets |
| Languages | English first; localization structure ready for German and Arabic, including RTL |

Firebase offers Flutter plugins for Authentication, Firestore, Analytics, and Crashlytics, while Firestore provides realtime synchronization and offline support.[^8] App Check should protect production Firebase resources, using Play Integrity on Android and Apple attestation providers on iOS.[^9][^10]

Small preferences such as theme and sound can use key-value persistence, but Flutter documents that this mechanism is for a relatively small collection of primitive values; structured puzzle progress should remain behind a database/repository abstraction.[^11][^12]

## Master agent prompt

Copy the complete block below into **Cursor Agent in Plan Mode**. On Replit, create a general Flutter workspace rather than selecting its Expo-oriented “Mobile app” template, then paste the same prompt.[^13][^4]

```markdown
You are the lead Flutter engineer, game-systems designer, QA engineer, and release engineer for a production mobile logic-puzzle game named “Logic 42”.

Your task is to create a complete, runnable, tested, polished Flutter application for Android and iOS. Do not merely provide snippets or a tutorial. Inspect the current repository, create or repair the actual project files, run commands, run tests, fix errors, and leave the repository in a releasable state.

# WORKING METHOD

1. Start in planning mode.
2. Inspect the repository and installed toolchain before changing files.
3. Write `IMPLEMENTATION_PLAN.md` with milestones, proposed file tree, dependencies, risks, and acceptance tests.
4. If the repository is empty, initialize a Flutter app named `logic_42` with an appropriate reverse-domain application ID that is easy to replace through configuration.
5. Implement one milestone at a time. After each milestone, format, analyze, and test the project.
6. Never claim a task is complete unless the relevant command succeeds.
7. Do not hide failures, delete tests to make CI pass, or replace real logic with mock success responses.
8. Prefer stable, actively maintained packages compatible with the installed Flutter/Dart SDK. Check compatibility before adding packages; do not invent package APIs.
9. Keep Firebase, billing, and platform-specific integrations behind interfaces so the game remains fully playable offline when these services are absent.
10. Preserve secrets: never commit signing keys, service-account files, API keys, `.env` secrets, or production Firebase credentials.
11. Ask for a human decision only when blocked by credentials, Apple/Google developer accounts, legal text, signing certificates, or irreversible store configuration. Otherwise make a sensible documented default and continue.

# PRODUCT DEFINITION

Game title: Logic 42
Genre: Logic puzzle, mathematical reasoning, and metacognitive pattern recognition
Inspiration: Sudoku and KenKen, but do not copy their branding, artwork, text, puzzle layouts, or proprietary assets.
Theme: A subtle “42” science-fiction wit and cosmic-number atmosphere, without copyrighted characters, quotations, names, artwork, or trade dress from The Hitchhiker’s Guide to the Galaxy.

Core loop:
- Display a 6-row × 7-column number board.
- Each row follows `a | b | c | d | e | f | g`.
- `a…f` are operands in the inclusive range 1–42.
- `g` is the output of one hidden mathematical rule and is also in 1–42.
- Rows 1–5 show all seven values as examples.
- Row 6 shows `a…f`; only `g` is blank and editable.
- The player studies rows 1–5, enters the final `g`, and submits.
- A correct answer triggers clear feedback, explanation, XP, progress save, and next-puzzle action.
- An incorrect answer gives restrained feedback and permits another attempt; do not reveal the answer automatically.

Important mathematical constraint:
- Implement one-based modulo exactly as `mod42(x) = ((x - 1) % 42 + 42) % 42 + 1`, so every result is 1–42 even for zero or negative intermediate values.
- Never use ordinary `% 42` directly as the final normalization because it can return 0.

Do not implement a final row with all seven cells blank in Classic Mode. Such a puzzle is underdetermined without a second explicit generation rule. Architect the model so a future “Meta Row” mode could add independent column rules, but keep it disabled in the MVP.

# RULE ENGINE

Create a pure-Dart domain package/folder with no Flutter or Firebase imports.

Required abstractions:
- `LogicRule` interface/abstract class
- Stable `ruleId`, display name, world, difficulty parameters, evaluate method, explanation builder, and hint stages
- `PuzzleDefinition`
- `PuzzleRow`
- `PuzzleValidationResult`
- `PuzzleGenerator`
- `DifficultyCalculator`
- `RuleRegistry`

Every rule must:
- Accept exactly six integers in 1–42.
- Be deterministic.
- Return exactly one integer in 1–42.
- Produce a human-readable explanation with substituted values.
- Expose three progressive hints.
- Be unit-tested with normal, boundary, zero-remainder, and negative-intermediate cases where applicable.

Implement at least these launch rule families:

1. Modular sum
   - `g = mod42(a+b+c+d+e+f)`.

2. Alternating sum
   - `g = mod42(a-b+c-d+e-f)`.

3. Odd/even value-group difference
   - Group the six operands by whether each value is odd or even.
   - `g = mod42(abs(sum(odd values)-sum(even values)))`.
   - Clearly distinguish this from odd/even cell positions.

4. Odd/even position difference
   - `g = mod42(abs((a+c+e)-(b+d+f)))`.

5. Min/max and range family
   - Include rules built from `min`, `max`, range, and median-pair operations, each with an unambiguous formula.

6. Prime/composite family
   - Correctly classify 1 as neither prime nor composite.
   - Example: normalized absolute difference between the sums of prime and non-prime operands.

7. Digit-sum family
   - Use decimal digit sums of operands, then normalize.

8. Count-weighted family
   - Use counts of odd, even, prime, multiples, or values above/below 21, with formulas that remain explainable.

9. 42-symmetry rule
   - Sort values to `x1 <= x2 <= x3 <= x4 <= x5 <= x6`.
   - Pair `(x1,x6)`, `(x2,x5)`, `(x3,x4)`.
   - `offset = abs((x1+x6)-42) + abs((x2+x5)-42) + abs((x3+x4)-42)`.
   - `g = mod42(offset)`.

10. Meta/composed family
   - Compose at most two named primitive transforms for initial Expert content.
   - Explanations must show both stages.
   - Avoid arbitrary formulas that cannot be reasonably inferred from five examples.

Add rule ambiguity analysis:
- For every generated puzzle, evaluate all enabled rules against all six rows.
- Reject a puzzle if another enabled rule produces the same five training outputs and the same target answer.
- Prefer puzzles where exactly one enabled rule matches all five training rows.
- Reject duplicate operand rows, degenerate rows that hide the intended distinction, and puzzles whose examples accidentally make a simpler rule appear valid.
- Record matching rule IDs in validation diagnostics.

Puzzle generation:
- Use a seeded pseudo-random generator so a puzzle is reproducible from `{generatorVersion, seed, ruleId, difficulty}`.
- Never use current time inside the pure generator.
- Generate candidates, validate them, and cap attempts to prevent an infinite loop.
- Return a typed failure if no valid puzzle is found within the cap.
- Daily puzzles must derive their seed from the UTC date plus a server-controlled salt/version, not from the device clock alone.
- Curated puzzles should be stored as versioned JSON assets and validated at test/build time.

Difficulty scoring:
- Implement a documented 0–100 score rather than vague labels only.
- Components: rule operation count, transform depth, number of groups, ordering/sorting requirement, modulo/absolute-value use, distractor similarity, ambiguity margin, and observed result distribution.
- Map scores to Easy, Medium, Hard, and Expert using constants in one configuration file.
- Do not call a measure “entropy” unless it is actually computed from a defined probability distribution. If implemented, calculate Shannon entropy from generated result frequencies; otherwise name it `resultDistributionScore`.

# CONTENT STRUCTURE

Worlds:
1. Basic Patterns
2. Modular Rules
3. Number Groups
4. Prime Logic
5. 42 Symmetry
6. Meta Rules

Design for 40 puzzles per world and 240 total, but do not hand-author fake content. Ship:
- A small, high-quality curated seed set sufficient to demonstrate every implemented rule and world.
- A deterministic generator that can create and validate the remaining content.
- A developer CLI command or Dart script that generates a candidate pack, validates every puzzle, rejects ambiguity, and writes versioned JSON.
- A validation report listing puzzle count, rule distribution, difficulty distribution, duplicate count, invalid count, and ambiguous count.

The app must never present an unvalidated puzzle.

# GAME MODES

Classic:
- World map, sequential unlocks, 1–3 stars, best time, attempts, hints used, and completion status.

Daily Puzzle:
- One deterministic UTC puzzle per date.
- Works from a cached signed/validated definition when offline.
- One ranked submission per user/day; local practice retries are allowed but are not ranked.
- Store completion time, hints, attempts, and app/puzzle version.

Speed Mode:
- Configurable timed run, default 5 puzzles.
- Pause safely when app lifecycle changes; define whether background time counts and apply consistently.
- Local best scores, with online leaderboard interface disabled until backend validation is configured.

Discovery Mode:
- Interactive lessons for each rule family.
- Show worked examples, allow practice, and explain mistakes.

# HINTS

Use three progressive hint levels:
1. Visual focus: highlight relevant values, groups, positions, or pairs without naming the rule.
2. Rule family: state a conceptual clue such as “Compare mirrored pairs around 42.”
3. Formula concept: reveal the operation structure but not the substituted result.

Hints must be generated from the declared rule, not manually duplicated strings. Track hint use for scoring. The player must be able to review the full worked solution only after solving or explicitly giving up.

# SCORING AND PROGRESSION

Create a centralized, tested scoring policy:
- Base XP by difficulty.
- Time bonus with a documented cap and smooth decay.
- No-hint bonus.
- First-attempt bonus.
- Giving up grants no completion bonus.
- Prevent repeated offline reopening from farming XP for the same puzzle.

Levels:
- Player level 1–100.
- Use a monotonic XP curve defined by a pure function and tested at level boundaries.
- Display current XP, next-level threshold, and earned XP breakdown.

Streaks:
- 3-day, 7-day, and 30-day milestones.
- Base daily boundaries on UTC for consistent server reconciliation.
- Handle missed days, device clock changes, reinstall, and offline completion records.

Daily rewards:
- Day 1: hint token.
- Day 3: puzzle pack entitlement placeholder.
- Day 7: badge.
- Make rewards data-driven and idempotent so the same reward cannot be claimed twice.

# UI/UX

Visual direction:
- Original, minimalist number-grid design.
- Light and dark themes.
- Calm neutral surfaces, one accent color, and a special but accessible “42” accent.
- Subtle motion and haptics, both disableable.
- No copyrighted science-fiction assets or quotations.

Required screens:
- Splash/bootstrap
- First-run onboarding
- Home dashboard
- World selection
- Level/puzzle selection
- Puzzle play
- Pause sheet
- Hint sheet
- Correct-answer/result screen
- Worked solution screen
- Discovery lessons
- Daily puzzle
- Speed mode
- Statistics
- Achievements/badges
- Settings
- Profile/sign-in upgrade
- Premium information screen, visible only when the monetization feature flag is enabled
- Privacy/about/legal placeholders

Puzzle interaction:
- Fit seven cells without horizontal scrolling on common phone widths.
- Make the result column visually distinct.
- Use a custom 1–42 number entry sheet or compact keypad; do not require a full keyboard.
- Provide delete, submit, and optional note/scratch interaction only if it remains uncluttered.
- Clearly differentiate selected, related, editable, correct, and incorrect states without relying only on color.
- Prevent invalid values outside 1–42.
- Support screen readers with meaningful row/column labels and spoken formulas after completion.
- Respect system text scaling and reduced-motion preferences.

Localization:
- Use Flutter localization resources from the beginning.
- English strings complete.
- Add structural support and sample translations for German and Arabic.
- Verify RTL layout for Arabic; do not reverse mathematical operand order in a way that changes meaning.
- No user-facing string literals scattered through widgets.

# ARCHITECTURE

Use a feature-first, layered structure with clear boundaries. Follow this conceptual layout, adapting filenames if needed:

lib/
  app/
    app.dart
    router.dart
    bootstrap.dart
    theme/
    localization/
    config/
  core/
    errors/
    result/
    analytics/
    clock/
    persistence/
    widgets/
  features/
    puzzle/domain/
    puzzle/data/
    puzzle/presentation/
    progression/domain/
    progression/data/
    progression/presentation/
    daily/
    speed/
    discovery/
    profile/
    settings/
    monetization/
  services/
    firebase/
    local/

test/
integration_test/
tool/
assets/puzzles/
docs/

Architectural requirements:
- Views contain presentation only.
- View models/controllers own UI state and commands.
- Repositories are sources of truth.
- Services wrap plugins, databases, Firebase, and platform APIs.
- Pure domain logic never imports Flutter, Firebase, Riverpod, or storage packages.
- Use dependency injection through Riverpod providers.
- Use sealed/typed states for loading, data, empty, and error states.
- Avoid global mutable singletons.
- Use an injectable `Clock` for date, streak, timer, and daily-puzzle tests.
- Use an injectable random source/seed for generation tests.
- Keep models immutable and validate all decoded JSON.
- Add migrations/versioning for local progress and puzzle packs.

Recommended packages, subject to installed-SDK compatibility checks:
- `flutter_riverpod`
- `go_router`
- `freezed` and `json_serializable`, or equally robust explicit immutable models if code generation causes toolchain incompatibility
- A maintained structured local database such as Drift for puzzle/progress records
- `shared_preferences` only for small non-sensitive settings
- `intl` and Flutter localization tooling
- Firebase Core, Authentication, Cloud Firestore, Analytics, Crashlytics, and App Check behind optional adapters
- `in_app_purchase` behind a disabled store-service adapter

Do not store secrets or authoritative premium entitlements in shared preferences.

# FIREBASE AND BACKEND

The application must compile and run in `offlineDemo` flavor without Firebase configuration files.

Create flavors/configurations:
- `offlineDemo`: local data, no analytics, no auth requirement, no billing.
- `development`: Firebase emulator or development project.
- `production`: production Firebase and App Check enforcement.

Firebase features:
- Anonymous authentication by default, with an upgrade path to supported sign-in providers.
- Cloud Firestore for cloud profile/progress, daily puzzle metadata, and leaderboard read models.
- Analytics through a domain event interface.
- Crashlytics only after appropriate initialization and consent/configuration.
- App Check for production.
- Cloud saves with conflict resolution using per-puzzle completion records and deterministic merge rules; never overwrite a better result with a worse result.

Security:
- Provide Firestore security rules and emulator tests.
- Users may read/write only their own private profile/progress.
- Public leaderboard entries expose only safe display data.
- Never trust client-submitted XP, premium status, daily seed, score, solve time, or leaderboard rank.
- Create a callable/server verification design for ranked submissions that re-evaluates the puzzle answer and computes score server-side.
- Rate-limit or otherwise protect ranked submission endpoints.
- Provide required Firestore indexes in repository configuration.
- Document Firebase setup in `docs/FIREBASE_SETUP.md`.

If credentials are unavailable, implement and test local adapters, add Firebase adapter code that compiles when configured, and document exact human setup steps. Do not fabricate configuration files.

# MONETIZATION

Premium concept: one-time upgrade priced conceptually at USD 4.99, with localized store pricing shown from the store rather than hard-coded in the UI.

Premium benefits:
- Infinite validated puzzle generator.
- Expert worlds.
- Advanced statistics.

Implementation rules:
- Default `monetizationEnabled` to false.
- No ads.
- Define `EntitlementRepository` and `StoreService` interfaces.
- Use official Apple/Google in-app purchase mechanisms when enabled.
- Include purchase restoration.
- Cache entitlements for offline UX but verify them with the store/backend when possible.
- Never unlock premium based only on a mutable local boolean.
- The free/offline build must remain complete and usable.

# ANALYTICS AND PRIVACY

Create typed analytics events with no mathematical answer leakage and no unnecessary personal data:
- onboarding_completed
- puzzle_started
- answer_submitted
- puzzle_solved
- hint_used
- puzzle_abandoned
- daily_completed
- speed_run_completed
- lesson_completed
- purchase_screen_viewed

Add an analytics consent/configuration mechanism appropriate to the selected regions and services. Include placeholder privacy-policy and terms screens clearly marked for owner-supplied legal text; do not invent legal guarantees.

# TESTING

Create a serious automated test suite.

Unit tests:
- One-based modulo for positive, zero, multiples of 42, and negative inputs.
- Every rule family and explanation data.
- Prime classification including 1, 2, and 42.
- Puzzle JSON decoding and invalid-data rejection.
- Puzzle generator determinism.
- Puzzle uniqueness and ambiguity detection.
- Difficulty scoring boundaries.
- XP, level, streak, rewards, timer, and conflict merge policies.

Property/fuzz tests:
- Thousands of generated operand sets per rule.
- Every output remains 1–42.
- Same seed/version produces the same puzzle.
- Generated puzzles pass validation.
- No uncaught exceptions for valid inputs.

Widget tests:
- Board renders 6 × 7 correctly.
- Only the final output is editable.
- Input rejects 0, 43, empty submission, and malformed text.
- Hint progression.
- Correct/incorrect feedback.
- Theme, localization, RTL, and large-text smoke tests.

Integration tests:
- First launch to solving a Classic puzzle.
- Close/reopen and progress restoration.
- Offline Daily puzzle from cache.
- Anonymous profile to cloud-sync adapter using emulators/fakes.
- Premium restore flow through a fake store adapter.

Golden tests are optional if stable in the environment, but core widget and integration tests are mandatory.

# QUALITY GATES

Before declaring completion, run and fix:
- `dart format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- `flutter test integration_test` when a supported emulator/device is available
- Android debug build
- Android release app bundle build when signing-independent build is possible
- iOS build without codesigning when running on macOS; otherwise document that iOS compilation needs macOS/Xcode

Also:
- Remove dead code and unused dependencies.
- Ensure no secrets are tracked by Git.
- Ensure `offlineDemo` starts without Firebase files.
- Ensure all shipped puzzle JSON passes the validator.
- Provide a concise test/build report with command results and any environment limitation.

# CI/CD

Add GitHub Actions that, on pull requests and main branch pushes:
- Set up a pinned compatible Flutter version.
- Install dependencies.
- Verify formatting.
- Run analyzer.
- Run unit and widget tests with coverage.
- Build the offline Android app bundle or APK.
- Upload test/coverage artifacts where appropriate.

Do not place signing secrets in the repository. Document secure store-signing setup separately.

# DOCUMENTATION AND DELIVERABLES

Create:
- `README.md`: product overview, screenshots placeholders, prerequisites, setup, run, test, build, flavors, and architecture summary.
- `AGENTS.md`: concise persistent rules, commands, architecture boundaries, and “definition of done” for future coding-agent sessions.
- `IMPLEMENTATION_PLAN.md`: checked-off milestones and remaining account-dependent actions.
- `docs/ARCHITECTURE.md`.
- `docs/PUZZLE_FORMAT.md` with JSON schema and examples.
- `docs/RULE_AUTHORING.md` explaining how to add and test a new rule.
- `docs/GENERATOR_VALIDATION.md` explaining ambiguity rejection and metrics.
- `docs/FIREBASE_SETUP.md`.
- `docs/STORE_RELEASE.md` for Android and iOS checklists.
- `docs/PRIVACY_DATA_MAP.md` listing every collected/stored field and purpose.
- `CHANGELOG.md`.

Create original placeholder app icon and splash assets using simple geometric “42” shapes only if tooling permits. Mark them as replaceable production placeholders.

# ACCEPTANCE CRITERIA

The result is acceptable only if:
1. The app launches in offlineDemo mode without Firebase credentials.
2. A new user can complete onboarding, select a world, open a puzzle, use hints, enter an answer, receive feedback, earn XP, and see progress persist after restart.
3. The board is exactly 6 rows × 7 columns, with only row 6 column `g` editable in the main mode.
4. All operands and outputs are 1–42.
5. Every shipped puzzle is reproducible, valid, and unambiguous against the enabled rule registry.
6. The displayed explanation exactly matches the rule that generated the answer.
7. Light/dark mode, English localization, German/Arabic structure, RTL, text scaling, and screen-reader semantics are present.
8. Missing network/Firebase configuration never blocks offline play.
9. Unit and widget tests pass; integration tests pass where the environment supports them.
10. Analyzer has no errors.
11. Android build succeeds.
12. There are no committed secrets, fabricated credentials, hidden TODOs in core logic, or placeholder implementations that falsely report success.
13. Account-dependent tasks such as store signing, Firebase project creation, legal-policy approval, and live in-app products are documented as explicit human actions.

# EXECUTION ORDER

Milestone 1: repository audit, plan, Flutter initialization, architecture skeleton, theme, routing, localization.
Milestone 2: pure rule engine, modulo normalization, models, registry, validator, ambiguity checker, and comprehensive unit tests.
Milestone 3: curated JSON format, deterministic generator, content validation CLI, and generated validation report.
Milestone 4: playable Classic vertical slice with local persistence and progression.
Milestone 5: hints, explanations, Discovery, Speed, Daily caching, statistics, accessibility, and polish.
Milestone 6: Firebase interfaces/adapters, emulator rules/tests, cloud merge policy, analytics, Crashlytics, and App Check documentation.
Milestone 7: disabled monetization adapter, restore flow with fake store, legal/privacy placeholders.
Milestone 8: integration tests, CI, release documentation, final quality gates, and build report.

Begin now by inspecting the repository and toolchain, then write the plan. Do not start with a large code dump in chat; create and modify the repository files directly.
```

## Persistent Cursor rule

After the initial build, keep a compact `AGENTS.md` in the repository. Cursor automatically recognizes `AGENTS.md`, while project rules under `.cursor/rules/` can provide more narrowly scoped instructions; its documentation recommends keeping individual rules focused and below 500 lines.[^1][^14]

A suitable starter file is:

```markdown
# Logic 42 Agent Rules

- Run `dart format`, `flutter analyze`, and relevant tests after every meaningful change.
- Keep puzzle rules, generation, validation, scoring, and progression pure Dart.
- UI code must not import Firebase or database implementations directly.
- All outputs must use one-based modulo and remain in 1–42.
- Never ship an unvalidated or ambiguous puzzle.
- Keep offlineDemo fully playable without credentials or network access.
- Add tests with every rule or scoring change.
- Never commit secrets, signing files, service-account credentials, or production configuration.
- Do not mark account-dependent release tasks complete without verification.
- Prefer small, reviewable changes and report exact commands run.
```

## Publication constraints

Flutter recommends a mix of unit, widget, and integration tests, with integration tests covering complete app flows on devices or emulators.[^15][^16] Android app bundles should be exercised through internal, alpha, or beta testing before production release.[^17]

If premium functionality is later enabled, Apple requires in-app purchase for unlocking in-app features, levels, or a full version, and Google Play similarly requires its billing system for in-app digital goods unless a policy exception applies.[^18][^19][^20] Store prices should therefore come from each store’s product metadata, not from a hard-coded “$4.99” label.

Because the developer is a student in Germany whose current residence/work conditions reportedly do not permit self-employment, the safe project default is a free, non-monetized release until explicit authorization is obtained from the Ausländerbehörde; the previous discussion specifically distinguished app publication from receiving monetization income.[^21] This is why the prompt keeps billing disabled behind a feature flag rather than removing the architecture entirely.

## Human-only release tasks

No coding agent can make the app literally “ready to publish” without access to external accounts and owner decisions. The final manual checklist must still include:

- Choose and verify the permanent Android application ID and iOS bundle ID.
- Create Apple Developer, App Store Connect, Google Play Console, and Firebase projects.
- Add platform configuration files outside public source control where appropriate.
- Configure Android upload/app-signing keys and Apple certificates/profiles.
- Supply final icon, screenshots, support URL, privacy-policy URL, age rating, store descriptions, and review notes.
- Configure and review Firestore rules, indexes, App Check, backend verification, data retention, and consent behavior.
- Create store products only after monetization is legally and operationally authorized.
- Test with Google Play internal testing and TestFlight before production submission.
- Review platform rules immediately before submission; Apple advises considering its review guidelines during development, not only at the end.[^22]

---

## References

1. [Rules | Cursor Docs](https://cursor.com/help/customization/rules) - Give Agent persistent instructions for coding style, patterns, and workflows.

2. [cursor.com](https://cursor.com/docs/agent/overview.md)

3. [Agent mode | Cursor Docs](https://cursor.com/help/ai-features/agent) - Start conversations, give instructions, review changes, and interrupt Agent.

4. [Build a mobile app - Replit Docs](https://docs.replit.com/build/mobile-app)

5. [Guide to app architecture - Flutter documentation](https://docs.flutter.dev/app-architecture/guide) - The recommended way to architect a Flutter app.

6. [Architecture recommendations and resources - Flutter](https://docs.flutter.dev/app-architecture/recommendations) - Recommendations for building scalable Flutter applications.

7. [Common architecture concepts - Flutter](https://docs.flutter.dev/app-architecture/concepts) - Learn about common architecture concepts in application design, and how they apply to Flutter.

8. [Welcome to Firebase for Flutter! | Firebase Documentation](https://firebase.google.com/docs/flutter)

9. [Get started using App Check in Flutter apps - Firebase](https://firebase.google.com/docs/app-check/flutter/default-providers) - A guide on how to get started with App Check in Flutter apps using the default providers.

10. [Quotas & limits](https://firebase.google.com/docs/app-check) - An introduction to Firebase App Check, a service that helps protect your backend resources from abus...

11. [docs.flutter.dev › cookbook › persistenceStore key-value data on disk - Flutter](https://docs.flutter.dev/cookbook/persistence/key-value) - Learn how to use the shared_preferences package to store key-value data.

12. [Flutter persistence cookbook](https://docs.flutter.dev/cookbook/persistence) - A catalog of recipes for adding persistence to your Flutter app.

13. [Best practices for coding with agents - Cursor](https://cursor.com/blog/agent-best-practices) - A comprehensive guide to working with coding agents, from starting with plans to managing context, c...

14. [cursor.com](https://cursor.com/docs/rules.md)

15. [docs.flutter.dev · testing · overviewTesting Flutter apps](https://docs.flutter.dev/testing/overview) - Learn more about the different types of testing and how to write them.

16. [Check app functionality with an integration test](https://docs.flutter.dev/testing/integration-tests) - Learn how to write integration tests

17. [Build and release an Android app - Flutter documentation](https://docs.flutter.dev/deployment/android) - How to prepare for and release an Android app to the Play store.

18. [Business](https://developer.apple.com/app-store/review/guidelines/) - The App Review Guidelines provide guidance and examples across a range of development topics, includ...

19. [Understanding Google Play's payments policy](https://support.google.com/googleplay/android-developer/answer/10281818?hl=en-GB) - Google Play's billing system is required for developers offering in-app purchases of digital goods a...

20. [Payments - Play Console Help](https://support.google.com/googleplay/android-developer/answer/9858738?hl=en) - Developers charging for app downloads from Google Play must use Google Play's billing system as the ...

21. [I am currently a student in germany enrolled at TU braunschweig, I have 2 accounts the main one is with sparkasse and the second is with Revolut. I want to publish a game on appstore and googleplay, Can i do that freely and link it to a bank account, since my work permit allows for 140 full days and no self work](https://www.perplexity.ai/search/5acd6c4e-ebaa-47e5-8774-99b30d9a0308) - Short answer: you can publish a free app, but you should not monetize it—or receive app-store payout...

22. [Submit Your APP](https://developer.apple.com/app-store/submitting/) - Make sure your apps take advantage of the latest capabilities in Apple platforms so you can deliver ...

