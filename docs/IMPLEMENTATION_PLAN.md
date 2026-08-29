# Calciverse — Master Implementation Plan

Revision 2 — incorporates owner review feedback (security incident handling, theme-diagnosis correction, task-quality fields, final priority order).

Derived from `CALCIVERSE_MASTER_SPEC.md`, ordered by the approved priority phases (P0 → P4).
Tasks are small, independently testable, and ordered by dependency. Each task follows the loop:
DISCOVER → PLAN → IMPLEMENT → TEST → FIX → VERIFY → DOCUMENT.

## Plan Classification

To keep the plan honest, every item below falls into one of these classes:

- **Current state**: documented in `docs/CURRENT_STATE.md` (source of truth for existing behavior — where the spec and the code differ, useful existing behavior is preserved and discrepancies documented).
- **Confirmed bugs**: failing tests (P0-02), countdown non-persistence (P0-11), fake compounding progress (P0-10), zero-credit conversion allowed (P0-10), unlabeled demo currency rates (P0-12), stale language on open pages (P0-05).
- **Architectural improvements**: engines/services extraction (P0-06…P0-12), Tool Registry (P1-01), typed errors, storage abstraction.
- **Future features**: P1 UX layer, P2 expansion, P3 file/scan, P4 ecosystem.
- **Owner-blocked items**: CloudConvert key revocation (P0-01), backend hosting choice (P2-14), rate API provider selection (P2-12), notifications scope (P2-11), premium direction (P4-12).
- **External-service dependencies**: CloudConvert API (P0-10, P2-14, P2-15), currency rate API (P2-12), IANA tz data (P2-10).

## Global acceptance criteria (apply to EVERY task; not repeated below)

- `flutter analyze` passes; relevant tests pass; existing functionality preserved.
- All new user-visible strings exist in both English and Arabic; RTL verified.
- Light and dark themes verified.
- No raw exceptions (`$e`) shown to users; errors localized and typed where appropriate.
- No refactoring of unrelated code; incremental migrations only.
- `docs/CHANGELOG.md` updated at meaningful milestones (completed features, security fixes, architectural changes, releases — not trivial edits).

Legend: **Deps** lists task IDs that must be completed first. **Rollback** = "revert commit" unless stated otherwise (all tasks are delivered as reviewable, independently revertible PRs).

---

## P0 — Security / Stabilization / Architecture

### P0-01 CloudConvert credential incident
- **Feature**: Security incident response.
- **Goal**: Eliminate the exposed CloudConvert credential from tracked source and establish honest configuration tiers.
- **Why**: A production CloudConvert JWT is hardcoded in `file_converter_page.dart` and committed to git history — an active security incident. Removing it from the latest commit does NOT remove it from history, so revocation is mandatory regardless of any later history rewrite.
- **Existing files**: `lib/pages/file_converter_page.dart`, `.env.example`, `README.md`, `docs/CURRENT_STATE.md`.
- **New files**: `docs/SECURITY.md` (configuration-tier documentation), secret-scan CI config (see approach).
- **Deps**: none. **Owner-blocked**: key revocation/rotation in the CloudConvert dashboard (owner action; the old credential must never be used again).
- **Technical approach**: delete the hardcoded token; read `CLOUDCONVERT_API_KEY` from `dotenv.env` as **local development configuration only** — with NO fallback credential in source. When no valid configuration exists, the File Converter shows a localized configuration/service-unavailable state and conversion cannot start. Add a repository secret scan (e.g. `gitleaks`) run locally and wired into CI (P0-13). Document the three tiers in `docs/SECURITY.md`: local development configuration (`.env`, dev convenience, NOT a security boundary), client-side configuration (anything bundled in a Flutter client is extractable — never production secrets), and production secret management (server-side behind the backend proxy, P2-14). `.env` is explicitly NOT the production security solution; the production architecture remains Flutter client → secure backend/proxy → CloudConvert.
- **UI changes**: localized service-unavailable card/state on the File Converter when unconfigured.
- **Business logic changes**: key sourcing + configured-check guard.
- **Localization changes**: new EN/AR strings for the unavailable state.
- **Storage changes**: none.
- **Tests**: widget test for the unconfigured state; secret-scan run passes; manual conversion with a rotated key in `.env`.
- **Acceptance criteria**:
  - No CloudConvert secret remains in current tracked source files.
  - The exposed credential is revoked/rotated (owner confirms).
  - Repository secret scanning passes.
  - No fallback production credential exists in the client.
  - File Converter shows a localized configuration/service-unavailable state when no valid service configuration exists.
  - The historical exposure is documented in `docs/SECURITY.md` / CHANGELOG.
- **Risks**: converter unusable for users until a dev key is configured — acceptable; correctness over fake availability.
- **Rollback**: revert commit (the removed secret must NOT be restored under any circumstances).

### P0-02 Fix translation parity & failing tests
- **Feature**: Localization integrity.
- **Goal**: Green test suite, full EN↔AR key parity, no fragile assertions.
- **Why**: 3 tests fail today (17 missing Arabic keys incl. `input`; hardcoded key-count 412), and some UI strings are hardcoded English.
- **Existing files**: `lib/utils/translations.dart`, `test/language_test.dart`, `lib/pages/file_converter_page.dart`.
- **New files**: none. **Deps**: none.
- **Technical approach**: add missing Arabic keys; replace the hardcoded count assertion with a dynamic EN↔AR key-parity test (both directions); move hardcoded English strings (e.g. file-size-limit warning) into the translation map.
- **UI changes**: none visible (strings become localized). **Business logic changes**: none. **Localization changes**: the task itself. **Storage changes**: none.
- **Tests**: `flutter test` fully green; dynamic parity test cannot drift.
- **Acceptance criteria**: 0 failing tests; no missing AR keys; no hardcoded key counts; no hardcoded English UI strings in touched files.
- **Risks**: low — translation quality of new Arabic strings needs owner spot-check.

### P0-03 Fix deprecation warnings
- **Feature**: Toolchain health.
- **Goal**: `flutter analyze` produces zero issues caused by application code.
- **Why**: 47 info-level deprecations (`withOpacity`, `DropdownButtonFormField.value`, `Switch.activeColor`) will break on future Flutter upgrades.
- **Existing files**: most pages + `unified_page_design.dart`.
- **New files**: none. **Deps**: none.
- **Technical approach**: mechanical migration — `withOpacity` → `withValues`, `value` → `initialValue`, `activeColor` → `activeThumbColor`.
- **UI changes**: none intended. **Business logic changes**: none. **Localization changes**: none. **Storage changes**: none.
- **Tests**: analyze → 0 issues; visual spot-check of Light AND Dark themes after migration (required).
- **Acceptance criteria**: `flutter analyze` → 0 application-code issues; both themes visually verified.
- **Risks**: subtle opacity/color regressions — mitigated by two-theme spot-check.

### P0-04 Remove dead code & dead dependencies
- **Feature**: Cleanup.
- **Goal**: No unused code or dependencies.
- **Why**: `lib/widgets/unified_theme.dart` (522 lines) is never imported; `PlaceholderPage` unreachable; `converter`, `translator`, `page_transition` declared but never imported.
- **Existing files**: `pubspec.yaml`, `lib/home_page.dart`. **New files**: none. **Deps**: P0-03 (avoid conflicting edits).
- **Technical approach**: verify zero references (grep) → remove → `flutter pub get` → rebuild → rerun tests, in that order.
- **UI/logic/localization/storage changes**: none.
- **Tests**: full analyze + test + `flutter build web` after removal.
- **Acceptance criteria**: app builds and runs; tests pass; no unused deps in pubspec.
- **Risks**: hidden dynamic references — mitigated by pre-removal grep + post-removal rebuild.

### P0-05 Language state propagation (theme verified, not refactored)
- **Feature**: Architectural fix (language/locale only).
- **Goal**: Language changes take effect on already-open pages; remove constructor prop-drilling for locale state.
- **Why**: `currentLanguage` is captured at push time, so open pages keep the old language until reopened. **Theme propagation is NOT broken** — pages read `Theme.of(context)`, which rebuilds open routes when `themeMode` changes (verified by code inspection). Theme architecture is therefore explicitly out of scope unless runtime verification proves otherwise.
- **Existing files**: `lib/main.dart`, `lib/home_page.dart`, all pages (incremental migration).
- **New files**: `lib/core/app_language.dart` (InheritedWidget/ChangeNotifier for locale state).
- **Deps**: none.
- **Technical approach**: (1) runtime-verify theme propagation with a widget test (toggle themeMode, assert open route restyles) — if it passes, no theme changes are made; (2) introduce an inherited locale scope; migrate pages page-by-page, keeping constructor params temporarily defaulting to the inherited value for backward compatibility.
- **UI changes**: none visual. **Business logic changes**: locale state access. **Localization changes**: none. **Storage changes**: none (same `language` key via P0-06 later).
- **Tests**: widget test — changing language rebuilds an open page's strings; theme-propagation verification test; RTL flip check.
- **Acceptance criteria**: language change reflected on open pages without reopening; theme behavior unchanged and verified; no unnecessary theme refactoring performed.
- **Risks**: broad-but-mechanical migration — limited by page-by-page rollout with defaults.

### P0-06 Storage service abstraction
- **Feature**: Storage foundation.
- **Goal**: Single storage entry point, migration-friendly toward a future local DB.
- **Why**: Pages talk to SharedPreferences directly; history/presets/events need a service boundary; SharedPreferences is fine for small settings but not a long-term strategy for unbounded data.
- **Existing files**: `lib/main.dart`, `lib/pages/settings_page.dart`, `lib/pages/file_converter_page.dart`.
- **New files**: `lib/core/storage/storage_service.dart`.
- **Deps**: none.
- **Technical approach**: `StorageService` wrapping SharedPreferences with typed get/set and JSON-list helpers plus size caps; interface kept storage-implementation-independent so a Hive/Drift backend can be swapped in later (P4-08). Reuse existing key names exactly (`isLightTheme`, `language`, credits keys) — no data migration needed.
- **UI changes**: none. **Business logic changes**: storage access routed through service. **Localization changes**: none. **Storage changes**: abstraction only, same underlying keys.
- **Tests**: unit tests with `SharedPreferences.setMockInitialValues` (typed round-trips, JSON list caps).
- **Acceptance criteria**: no page reads SharedPreferences directly; existing settings survive upgrade.
- **Risks**: key-name drift — mitigated by reusing exact existing keys.

### P0-07 Conversion Engine (units)
- **Feature**: Reusable engine.
- **Goal**: One shared engine for all unit conversion math; pages become UI-only for conversion.
- **Why**: 7 pages each duplicate factor maps and convert functions (violates the no-duplicated-formulas rule); precision/formatting is inconsistent.
- **Existing files**: `length_page.dart`, `area_page.dart`, `weight_and_mass_page.dart`, `volume_and_fluid_units_page.dart`, `temperature_page.dart`, `time_page.dart`, `data_page.dart`.
- **New files**: `lib/engines/conversion/conversion_engine.dart`, `lib/engines/conversion/unit_definitions.dart`, `test/fixtures/conversion_regression.dart`.
- **Deps**: none.
- **Technical approach**: pipeline Input → Validate → Normalize → Base Unit → Target → Format. **Before migrating any page, capture its current outputs as regression fixtures**, then delegate. Special cases handled correctly: temperature via offset formulas (not factors); decimal (KB) vs binary (KiB) data units; US vs Imperial distinctions; calendar-dependent date units (months/years) are NOT modeled as fixed physical factors — the Time converter keeps only fixed-duration units, calendar arithmetic belongs to the Date Engine; reciprocal-style conversions (fuel economy, P2-06) supported by design.
- **UI changes**: none (identical results). **Business logic changes**: extraction. **Localization changes**: none. **Storage changes**: none.
- **Tests**: unit tests — every unit ↔ base round-trip, precision/rounding, zero, extreme values, invalid input, KB/KiB, US/Imperial; regression fixtures match pre-refactor outputs.
- **Acceptance criteria**: identical results to current pages (fixtures prove it); no factor maps left in pages.
- **Risks**: silent value regressions — mitigated by fixtures-first rule.
- **Rollback**: pages keep their old code paths until each page's fixture suite passes; revert per-page.

### P0-08 Date Engine
- **Feature**: Reusable engine.
- **Goal**: Centralize all date/calendar arithmetic.
- **Why**: Age, Age Difference, Duration, Countdown, Zodiac each embed date math; calendar arithmetic (months/years) must not be treated as fixed-duration units.
- **Existing files**: `age_calculator_page.dart`, `age_difference_page.dart`, `duration_calculator_page.dart`, `event_countdown_page.dart`, `zodiac_sign_page.dart`.
- **New files**: `lib/engines/date/date_engine.dart`, regression fixtures.
- **Deps**: none.
- **Technical approach**: fixtures-first extraction of age breakdown, next birthday, difference, and duration (calendar-aware month/year handling; leap years; month boundaries). Designed to later host add/subtract dates (P2-08), business days (P2-09), and DST/time zones (P2-10) without rework.
- **UI changes**: none. **Business logic changes**: extraction. **Localization changes**: none. **Storage changes**: none.
- **Tests**: Feb 29 birthdays, Jan 31 + 1 month boundaries, leap years, zero/negative spans, future-date validation; fixtures match current behavior.
- **Acceptance criteria**: pages delegate to engine with unchanged results (or documented, owner-approved corrections).
- **Risks**: off-by-one behavior differences — fixtures make any change explicit and reviewable.

### P0-09 Health Engine + disclaimers
- **Feature**: Reusable engine + content compliance.
- **Goal**: Shared, tested health math; honest informational framing.
- **Why**: BMI/BMR/calorie math is page-embedded and untested; health tools lack the required localized disclaimers; Zodiac lacks entertainment framing. Health features are informational calculators — no diagnosis/treatment/prevention claims.
- **Existing files**: `bmi_calculator_page.dart`, `calorie_calculator_page.dart`, `zodiac_sign_page.dart`.
- **New files**: `lib/engines/health/health_engine.dart`.
- **Deps**: none.
- **Technical approach**: extract BMI classification and BMR/TDEE formulas (Mifflin-St Jeor, Harris-Benedict) into `HealthEngine`, designed to host future macro calculations; add localized "informational estimate, not medical advice" disclaimers; frame Zodiac as entertainment content.
- **UI changes**: disclaimer sections. **Business logic changes**: extraction. **Localization changes**: EN/AR disclaimer strings. **Storage changes**: none.
- **Tests**: BMI classification boundary values; BMR golden values per formula; fixtures match current outputs.
- **Acceptance criteria**: disclaimers visible in EN/AR on BMI + Calorie; Zodiac framed as entertainment; engine unit-tested.
- **Risks**: low.

### P0-10 CloudConvertService extraction + progress/credit fixes
- **Feature**: Service layer + confirmed bug fixes.
- **Goal**: Page owns UI only; service owns the HTTP workflow; honest progress; correct credit behavior.
- **Why**: The page owns the entire CloudConvert HTTP workflow; progress is faked by mathematical compounding (`0.5 + p*0.5`); a user with zero credits can still start a conversion; raw `$e` leaks to users.
- **Existing files**: `lib/pages/file_converter_page.dart`.
- **New files**: `lib/services/cloudconvert/cloudconvert_service.dart`, `lib/core/errors/app_error.dart`.
- **Deps**: P0-01, P0-06.
- **Technical approach**: `CloudConvertService` handles job creation, upload, polling, export URL, typed errors (validation/network/timeout/auth/rate-limit/unsupported-format/service), timeouts, and status. **Progress**: no invented percentages — honest state progression Preparing → Uploading → Processing → Finalizing → Completed (true upload percentage may be shown where genuinely measurable; job phases are states, not fake numbers). **Credits**: check before starting and block at zero (client-side UX enforcement only — documented as NOT a security boundary; clearing SharedPreferences resets it; the future backend (P2-14) is the authoritative quota layer). Deduct only when a job validly starts.
- **UI changes**: state-based progress UI; zero-credit blocked state. **Business logic changes**: extraction + fixes. **Localization changes**: state labels + typed error messages EN/AR. **Storage changes**: credits via StorageService.
- **Tests**: unit tests with mocked `http.Client` for every job state and error type; zero-credit blocking test; widget test of state progression.
- **Acceptance criteria**: page contains no HTTP code; conversion works end-to-end with a rotated key; zero credits blocks starting; no compounding progress; all error paths localized; no `$e` in UI.
- **Risks**: this is the most valuable existing feature — manual end-to-end test with a real small file required before merge.
- **Rollback**: keep the old page implementation in git; revert restores it wholesale.

### P0-11 Persist countdown events
- **Feature**: Confirmed bug fix (data loss).
- **Goal**: Countdown events survive app restart; groundwork for multiple events.
- **Why**: Events are held in memory only and lost on restart.
- **Existing files**: `lib/pages/event_countdown_page.dart`.
- **New files**: `lib/models/countdown_event.dart`.
- **Deps**: P0-06.
- **Technical approach**: JSON-serialized event list via StorageService (size-capped); current single-event UI preserved, renders a list when >1 exists (full multi-event UX is P2-11).
- **UI changes**: minimal (list rendering). **Business logic changes**: persistence. **Localization changes**: none/minimal. **Storage changes**: new `countdown_events` key.
- **Tests**: serialization round-trip unit test; restart persistence check.
- **Acceptance criteria**: events survive restart; existing single-event flow unchanged.
- **Risks**: low.

### P0-12 Currency Engine + demo-rate labeling
- **Feature**: Engine + honesty fix.
- **Goal**: Provider-abstracted currency conversion; UI never presents static rates as live.
- **Why**: 160+ currencies with hardcoded static rates presented without any demo/sample labeling (confirmed bug); no provider abstraction exists for the future real API.
- **Existing files**: `lib/pages/currency_converter_page.dart`.
- **New files**: `lib/engines/currency/currency_engine.dart`, `lib/engines/currency/rate_provider.dart`, `lib/engines/currency/static_demo_rate_provider.dart`.
- **Deps**: none.
- **Technical approach**: extract metadata + rates into `CurrencyEngine` fed by a `RateProvider` interface; current data becomes `StaticDemoRateProvider`. Architecture explicitly shaped for the future pipeline: Rate Provider → normalization → cache → lastUpdated → offline fallback → Currency Engine → UI (realized in P2-12). UI shows a persistent localized "Demo rates — not live" badge and rate-source line; the word "live" never appears for static data.
- **UI changes**: demo badge + source line. **Business logic changes**: extraction. **Localization changes**: badge strings EN/AR. **Storage changes**: none yet.
- **Tests**: cross-rate conversion (A→USD→B) unit tests; search by code/EN name/AR name; fixture parity with current results.
- **Acceptance criteria**: demo status clearly visible in both languages; conversion results unchanged.
- **Risks**: low.

### P0-13 Testing foundation & CI
- **Feature**: Infrastructure.
- **Goal**: Every PR verified automatically; shared test harness.
- **Why**: Testing is a first-class requirement; no CI exists; deprecations and secrets must not accumulate.
- **Existing files**: none. **New files**: `.github/workflows/ci.yml`, `test/helpers/test_harness.dart`.
- **Deps**: P0-02 (tests must be green first), P0-01 (secret scan config).
- **Technical approach**: GitHub Actions running `flutter analyze`, `flutter test`, `flutter build web`, and the repository secret scan on every PR. Shared widget-test harness pumping the app in EN/AR × light/dark for reuse by all future widget tests.
- **UI/logic/localization/storage changes**: none.
- **Tests**: CI green on the PR introducing it; harness used by at least one widget test.
- **Acceptance criteria**: CI blocks analyze/test/build/secret-scan failures; harness merged and documented.
- **Risks**: none significant.

### P0-14 Documentation baseline
- **Feature**: Project documentation.
- **Goal**: `docs/CURRENT_STATE.md`, `docs/IMPLEMENTATION_PLAN.md`, `docs/CHANGELOG.md`, `docs/FINAL_AUDIT.md` exist and are maintained.
- **Why**: Required baseline; CHANGELOG records milestones; FINAL_AUDIT will classify every spec requirement at the end.
- **Existing files**: `docs/CURRENT_STATE.md`, `docs/IMPLEMENTATION_PLAN.md`. **New files**: `docs/CHANGELOG.md` (created with this revision), `docs/FINAL_AUDIT.md` (skeleton; completed in FIN-01).
- **Deps**: none.
- **Technical approach**: CHANGELOG updated at meaningful milestones only (features, security fixes, architectural changes, releases). CURRENT_STATE refreshed when reality changes materially.
- **Acceptance criteria**: all four files exist; CHANGELOG has entries for P0 milestones as they complete.
- **Risks**: none.

---

## P1 — Core Product Experience

### P1-01 Tool Registry
- **Feature**: Core architectural foundation.
- **Goal**: Single source of truth describing every tool, powering Home, Tools, Global Search, Favorites, Related Tools, Smart routing, and future usage statistics.
- **Why**: Navigation is a hardcoded switch; search/favorites/smart features would otherwise each grow their own hardcoded if/else tool lists — explicitly forbidden.
- **Existing files**: `lib/home_page.dart`.
- **New files**: `lib/core/tools/tool_registry.dart`, `lib/core/tools/tool_definition.dart`.
- **Deps**: P0-05.
- **Technical approach**: `ToolDefinition` with unique id, category, EN/AR titles, EN/AR descriptions, icon, EN/AR aliases, keywords, supported input types, route/page builder, related tool ids, and availability/platform metadata where needed. Home grid renders from the registry; the navigation switch is deleted.
- **UI changes**: none visually (Home identical). **Business logic changes**: registry-driven navigation. **Localization changes**: titles/descriptions/aliases in both languages. **Storage changes**: none.
- **Tests**: unit test — every tool has EN+AR titles/descriptions, unique id, buildable page; registry count == 18.
- **Acceptance criteria**: Home visually unchanged but registry-driven; zero hardcoded tool switches remain.
- **Risks**: missing a tool during migration — count assertion mitigates.

### P1-02 Navigation shell
- **Feature**: App structure.
- **Goal**: Bottom navigation with Home / Tools / Smart / History / Favorites / Settings.
- **Why**: Spec-mandated final structure; current app is a single grid screen.
- **New files**: `lib/pages/shell_page.dart` + stub tab pages. **Existing files**: `lib/main.dart`.
- **Deps**: P1-01.
- **Technical approach**: shell with tabs (Smart/History/Favorites as localized stubs until their tasks land); existing push navigation untouched — no simultaneous rewrite of all pages.
- **UI changes**: bottom navigation. **Business logic**: tab state. **Localization**: tab labels EN/AR. **Storage**: none.
- **Tests**: widget tests — tab switching, RTL tab order, all 18 tools still reachable.
- **Acceptance criteria**: tabs functional; no existing flow broken.
- **Risks**: navigation regressions — mitigated by keeping push flows intact.

### P1-03 Home redesign
- **Feature**: Spec Home experience.
- **Goal**: Header + tagline, search field, Quick Tools, Recent Tools, category cards.
- **Why**: Current flat 18-item grid doesn't scale and lacks discovery.
- **New files**: `lib/pages/home/` widgets. **Existing files**: `lib/home_page.dart`.
- **Deps**: P1-01, P1-02, P1-05 (usage log for recents).
- **Technical approach**: sections driven by ToolRegistry categories and the usage log; search field routes to Global Search; ≤15 items visible; smart ordering deferred to P4-02.
- **UI changes**: full Home layout. **Business logic**: recents from usage log. **Localization**: all new strings EN/AR. **Storage**: none new.
- **Tests**: widget tests EN/AR incl. empty recents state.
- **Acceptance criteria**: all categories navigate; recents update with usage; ≤15 items on Home.
- **Risks**: scope creep — personalization is P4-01/02.

### P1-04 Global Search
- **Feature**: Search across everything.
- **Goal**: Find tools, units, currencies by official and colloquial names in EN and AR.
- **Why**: Core discovery mechanism; must NOT be hardcoded if/else checks tied to pages.
- **New files**: `lib/core/search/search_engine.dart`, `lib/pages/search_page.dart`.
- **Deps**: P1-01 (tool metadata), P0-07 (unit metadata), P0-12 (currency metadata).
- **Technical approach**: search over registries only (ToolRegistry aliases/keywords, unit registry, currency metadata) with normalized substring + alias matching; results grouped by type; selection opens the tool (with unit/currency preselection where supported).
- **UI changes**: search page. **Business logic**: search engine. **Localization**: EN/AR queries + labels. **Storage**: none.
- **Tests**: unit tests — Arabic queries, code queries ("USD"), partial matches, aliases; zero-result state.
- **Acceptance criteria**: tools findable by non-official names in both languages; no page-specific search code.
- **Risks**: relevance quality — start deterministic, tune later.

### P1-05 History service + usage log
- **Feature**: Reusable service.
- **Goal**: Central calculation history + tool-usage log.
- **Why**: Spec requirement; also feeds Home recents and future smart ordering. Must be a reusable service, not page-specific storage code.
- **New files**: `lib/core/history/history_service.dart`, `lib/models/history_entry.dart`.
- **Deps**: P0-06.
- **Technical approach**: `HistoryEntry` = tool id, timestamp, input summary, result, status (if relevant), reopen/reuse metadata where available. JSON via StorageService, size-capped (~200 entries); interface storage-agnostic for the P4-08 DB migration. Opt-out toggle honored (wired in P1-12).
- **UI changes**: none (service). **Business logic**: recording hooks in tools. **Localization**: none yet. **Storage**: new capped keys.
- **Tests**: append/cap/clear/disable unit tests; serialization round-trip.
- **Acceptance criteria**: converters + calculators record history when enabled; cap enforced.
- **Risks**: SharedPreferences scale — cap now, DB later (P4-08).

### P1-06 History page
- **Feature**: History tab UX.
- **Goal**: Browse, reuse, and manage history.
- **New files**: `lib/pages/history_page.dart`. **Deps**: P1-05, P1-02, P1-08.
- **Technical approach**: list + detail; actions: open tool, reuse inputs (via registry reopen metadata, first for a subset of tools), copy, share, favorite, delete; search/filter; clear-all with confirmation; empty state.
- **UI/localization**: full page EN/AR. **Storage**: via HistoryService only.
- **Tests**: widget tests incl. empty state and clear-all confirm.
- **Acceptance criteria**: all actions functional in EN/AR/RTL.
- **Risks**: reuse metadata coverage — documented per-tool.

### P1-07 Favorites
- **Feature**: Reusable service + tab.
- **Goal**: Favorite tools AND saved calculations.
- **New files**: `lib/core/favorites/favorites_service.dart`, `lib/pages/favorites_page.dart`. **Deps**: P1-01, P0-06.
- **Technical approach**: `FavoritesService` (two collections: tool ids, saved calculations); ⭐ toggle in the shared tool header; Favorites tab with two sections + empty states.
- **UI changes**: header star, tab. **Localization**: EN/AR. **Storage**: new keys via StorageService.
- **Tests**: unit + widget; persistence across restart.
- **Acceptance criteria**: favorite from any tool header; both sections functional.
- **Risks**: low.

### P1-08 Unified result actions
- **Feature**: Shared result UX.
- **Goal**: Every result exposes Copy result / Copy details / Share text / Save / Favorite / Explanation, where appropriate.
- **Why**: No result actions exist anywhere; must be one shared component, not per-page implementations.
- **Existing files**: `lib/widgets/unified_page_design.dart`, tool pages (incremental). **New files**: `lib/widgets/result_actions.dart`.
- **Deps**: P1-05, P1-07 (Save/Favorite hooks; Copy/Share can land first).
- **Technical approach**: extend `UnifiedResultCard` with optional details section, "How is this calculated?" sheet showing formulas/logic (without implementation internals), and an actions row; localized SnackBar copy feedback; adopt page-by-page.
- **UI changes**: actions row + sheet. **Localization**: action labels, feedback, explanations EN/AR. **Storage**: via services.
- **Tests**: widget tests — clipboard content, RTL layout, snackbar feedback.
- **Acceptance criteria**: every migrated tool exposes at least Copy + Share; explanations for calculators.
- **Risks**: touches many pages — incremental rollout.

### P1-09 Scientific calculator
- **Feature**: New core tool.
- **Goal**: Full scientific calculator with memory and local history.
- **New files**: `lib/engines/calculator/calculator_engine.dart`, `lib/pages/scientific_calculator_page.dart`. **Deps**: P1-01, P1-08.
- **Technical approach**: `CalculatorEngine` — tokenizer + shunting-yard evaluator (no eval; UI-independent): + − × ÷, parentheses, ^, √, π, e, !, %, trig + inverse (DEG/RAD toggle), log/ln/exp; memory MC/MR/M+/M−/MS; typed math errors (div-by-zero, domain errors).
- **UI changes**: new page. **Localization**: labels + errors EN/AR. **Storage**: memory/history via services.
- **Tests**: extensive unit matrix — precedence, unary minus, non-integer factorial (error), div-by-zero, deg/rad trig golden values.
- **Acceptance criteria**: documented test matrix passes; localized errors; engine has zero Flutter imports.
- **Risks**: parser complexity — highest-effort P1 task; engine isolated for testability.

### P1-10 Universal Input + Smart page
- **Feature**: Deterministic natural-input parsing.
- **Goal**: Free-text input classified into structured intents and answered inline.
- **Why**: Spec core feature. Must NOT depend on page-specific hardcoded parsing and must NOT be a fake-AI parser producing uncertain results.
- **New files**: `lib/core/smart/universal_input_engine.dart`, `lib/pages/smart_page.dart`. **Deps**: P1-09, P0-07, P0-12, P1-04, P1-01.
- **Technical approach**: deterministic pattern/grammar rules over the registries (ToolRegistry, unit registry + aliases, currency registry + aliases) delegating to CalculatorEngine / ConversionEngine / CurrencyEngine. V1 intents: arithmetic, unit conversion ("5 km to mi"), currency ("100 usd to eur"), percentages; date phrases follow once the Date Engine work in P2 lands. Supported patterns are documented (`docs/SMART_PATTERNS.md`). Unrecognized input falls back to Global Search. Architecture allows an AI/NLP layer later without rewriting the engines.
- **UI changes**: Smart tab — input, "understood as" card, result, Open Tool/Copy/Save/Share. **Localization**: EN + AR phrase patterns and labels. **Storage**: history via services.
- **Tests**: unit tests per intent in both languages, alias handling, ambiguous-input fallback.
- **Acceptance criteria**: four V1 intents work in EN and AR; patterns documented; graceful fallback.
- **Risks**: pattern coverage expectations — controlled by explicit documentation of what's supported.

### P1-11 Presets
- **Feature**: Reusable input bundles.
- **New files**: `lib/core/presets/presets_service.dart`. **Deps**: P0-06, P1-08.
- **Technical approach**: named per-tool input bundles (`Map<String,String>` contract); save/apply/rename/delete; first adopters: BMI, Calorie, Currency, Post-Tax; storage-agnostic interface.
- **Tests**: serialization unit tests; apply-preset widget test.
- **Acceptance criteria**: create/apply/delete on 4 tools; empty states localized.
- **Risks**: per-tool input schema drift — simple string-map contract.

### P1-12 Settings expansion
- **Feature**: Full settings surface.
- **Goal**: Appearance (language, theme incl. **System** mode, font size), Defaults (default currency, metric/imperial, precision), History (enable/clear/auto-cleanup), Files (cloud-processing info), About.
- **Existing files**: `lib/pages/settings_page.dart`, `lib/main.dart`. **Deps**: P0-05, P0-06, P1-05.
- **Technical approach**: sectioned settings persisted via StorageService; precision feeds ConversionEngine formatting as a default (per-tool overrides allowed — precision is not forced on all tools); System theme mode added to the existing light/dark modes.
- **Tests**: widget tests per section; precision formatting unit test.
- **Acceptance criteria**: settings persist and take effect app-wide immediately.
- **Risks**: System-mode addition touches theme plumbing — covered by the P0-05 verification tests.

### P1-13 Privacy Center
- **Feature**: Transparency page.
- **Goal**: Honest disclosure of local vs cloud data handling with per-category deletion.
- **New files**: `lib/pages/privacy_center_page.dart`. **Deps**: P1-05, P1-07, P1-11.
- **Technical approach**: lists what's stored locally (settings/favorites/history/presets/cache) and what goes to cloud (CloudConvert file lifecycle honestly described, incl. temporary URLs); per-category delete + Delete All with confirmations. File Converter page gains a visible "files are processed using cloud conversion services" notice.
- **Tests**: widget tests — delete flows verifiably clear storage.
- **Acceptance criteria**: honest copy EN/AR; no "100% secure" claims; deletions verified.
- **Risks**: copy accuracy — factual statements only.

### P1-14 Converter UX improvements
- **Feature**: Shared converter polish.
- **Goal**: Swap, precision control, searchable unit picker, clear buttons, unit info snippets across all 7 unit converters.
- **Deps**: P0-07, P1-08, P1-12.
- **Technical approach**: one shared converter scaffold widget (no 7 divergent layouts); ⇄ swap; precision from Settings default; searchable unit picker fed by the unit registry; KB/KiB and US/Imperial gallon labeling surfaced in UI; info snippets for uncommon units.
- **Tests**: swap widget test; KiB/KB engine tests; picker search test.
- **Acceptance criteria**: consistent template across all 7 pages; no behavior regressions (fixtures).
- **Risks**: layout churn — single shared scaffold contains it.

---

## P2 — Product Expansion

(Tasks below keep the full field set; several fields are one-liners where genuinely trivial.)

### P2-01 Finance Engine
- **Goal/Why**: isolated, unit-tested financial math (separate module/engine; formulas never in UI).
- **New files**: `lib/engines/finance/finance_engine.dart`. **Deps**: none.
- **Approach**: pure functions — simple/compound interest, loan payment + amortization, EMI, ROI, profit/margin/markup, savings goal, tip/bill split; formulas cited in doc comments; documented rounding rules.
- **Tests**: golden values against known financial tables; zero/extreme/rounding edges. **Storage/UI/Localization**: none (engine only).
- **Acceptance**: all functions tested; no UI dependency.
- **Risks**: financial correctness — mitigated by cited formulas + goldens.

### P2-02 Loan + EMI tools
- **Deps**: P2-01, P1-01, P1-08. Amortization table lazily rendered; localized; history/preset integration. **Acceptance**: results match engine goldens; EN/AR/RTL verified.
### P2-03 Interest (simple/compound) + Investment tools
- **Deps**: P2-01. Includes localized "assumed return, not a guarantee" disclaimer. **Acceptance**: disclaimer present EN/AR.
### P2-04 ROI + Profit/Margin/Markup tools
- **Deps**: P2-01. Mode-based single page. **Acceptance**: each mode tested against goldens.
### P2-05 Salary (generic, no country tax rules), Tip & Bill Split, Savings Goal
- **Deps**: P2-01. **Acceptance**: explicitly documents that no country-specific tax rules are claimed.

### P2-06 Advanced converters
- **Goal**: Speed, Pressure, Energy, Power, Force, Frequency, Angle, Torque, Density, Fuel Economy via the shared engine + shared scaffold — no duplicate converter implementations.
- **Deps**: P0-07, P1-14.
- **Approach**: new unit definitions only; fuel economy uses the engine's reciprocal-conversion support.
- **Tests**: unit round-trips incl. reciprocal fuel-economy cases. **Acceptance**: ten new categories, one page template.

### P2-07 Cooking converter
- **Deps**: P2-06. Volume↔volume plus volume↔weight via ingredient densities (flour/sugar/rice/water/milk); densities documented as approximations. **Acceptance**: density table sourced + localized ingredient names.

### P2-08 Add/Subtract Date tool
- **Deps**: P0-08. Calendar arithmetic in DateEngine (Jan 31 + 1 month policy documented and tested; leap years). **Acceptance**: edge-case matrix passes.
### P2-09 Business Days calculator
- **Deps**: P0-08. Configurable working week (Sun–Thu / Mon–Fri) + user holiday list (stored via StorageService). **Acceptance**: both week conventions tested.
### P2-10 Time Zone converter
- **Deps**: P0-08. IANA tz database via `timezone` package — real timezone data, DST-correct; never fixed offsets. **Acceptance**: DST-transition test cases pass.
### P2-11 Countdown expansion
- **Deps**: P0-11. Multiple events, time-of-day, icon, edit/delete; notifications as a separate sub-deliverable gated on platform capability checks (**owner decision**: notifications in scope?). **Acceptance**: multi-event CRUD persisted; graceful no-notification fallback.

### P2-12 Real currency provider + cache + freshness
- **Goal**: Live rates through the P0-12 abstraction: Rate Provider → normalization → cache → lastUpdated → offline fallback → Currency Engine → UI.
- **Deps**: P0-12, P0-06. **Owner-blocked**: provider selection (free vs paid, ToS; if a key is required it must be routed via the P2-14 backend, never bundled in the client).
- **Approach**: real `RateProvider` implementation; local cache with `lastUpdated`; freshness display; offline fallback to cached rates with a "Using cached rates" banner; graceful API-failure handling; `StaticDemoRateProvider` remains the labeled fallback of last resort.
- **Tests**: mocked provider — fresh fetch, stale cache, offline, API error, cross-rate normalization.
- **Acceptance**: rates only labeled live when actually fetched; freshness timestamp visible; offline mode works.

### P2-13 Multi-currency view, favorite currencies, primary currency
- **Deps**: P2-12, P1-07, P1-12. **Acceptance**: one amount → N favorite currencies; primary currency default honored.

### P2-14 CloudConvert backend proxy
- **Goal**: Production secret management — the client never holds the CloudConvert key.
- **Deps**: P0-10. **Owner-blocked**: hosting choice/account (e.g. Cloudflare Worker vs small server; possibly separate repo).
- **Approach**: minimal backend holding the key; endpoints: create job, job status; server-side rate limiting becomes the authoritative quota (replacing trust in client credits); `CloudConvertService` switches base URL via configuration.
- **Tests**: integration tests against deployed proxy; client error paths.
- **Acceptance**: no CloudConvert credential in any client configuration; server-side quota enforced.
- **Risks**: new infrastructure to operate.
- **Rollback**: client config flag can point back to direct mode in dev only.

### P2-15 File Converter UX expansion
- **Deps**: P0-10, P1-05. Searchable format picker (200+ formats grouped), credits card ("7/10 remaining" + reset time), from→to format info, per-conversion history with status via HistoryService. **Acceptance**: all new strings EN/AR; history records status transitions.

---

## P3 — File / Scan

### P3-01 QR Generator — local-only (`qr_flutter`); URL/text/Wi-Fi/contact/email/phone; save/share image. **Deps**: P1-01, P1-08. **Acceptance**: generated codes scan correctly; documented as fully local processing.
### P3-02 QR Scanner — `mobile_scanner`; content shown first, links NEVER auto-opened; Open/Copy/Share actions; camera capability checks per platform with graceful fallback (hidden/disabled where unsupported). **Deps**: P3-01. **Acceptance**: no auto-navigation; unsupported platforms degrade gracefully.
### P3-03 Barcode scanner — raw data display only; no product-name claims. **Deps**: P3-02.
### P3-04 OCR — on-device via ML Kit text recognition (mobile); clearly labeled **On-Device** (vs Cloud); editable result; Copy/Share/Save/Export TXT; hidden on unsupported platforms. **Deps**: P1-01, P1-08. **Acceptance**: on-device/cloud distinction explicit in UI; no capability overclaiming.
### P3-05 Image tools — local convert (JPG/PNG/WebP), resize with aspect lock, quality compression, rotate (`image` package); labeled local processing. **Deps**: P1-01.
### P3-06 PDF tools — merge/split/extract/rotate locally; per-operation feasibility verified before the tool is listed (no claimed-but-unimplemented capabilities). **Deps**: P3-05.
### P3-07 Cross-tool workflows — Related Tools section in the shared tool template, driven by ToolRegistry `relatedTools` (BMI→Calorie, Age→Zodiac/Countdown, OCR→PDF export, Currency→Finance). **Deps**: P1-01, P1-08 + relevant tools.

---

## P4 — Ecosystem

### P4-01 Home personalization — customizable quick tools/order/sections, local-only. **Deps**: P1-03.
### P4-02 Local learning / smart ordering — usage-frequency ordering of Quick Tools and unit/currency pickers; fully local. **Deps**: P1-05, P1-03.
### P4-03 Export / Import — JSON export of favorites/presets/custom units/preferences/events; import with validation + confirmation. **Deps**: P1-07, P1-11, P2-11.
### P4-04 Custom units — user-defined units (name/symbol/base/factor) in converters under "My Units". **Deps**: P0-07, P1-14.
### P4-05 Onboarding — 3 skippable screens + language/theme pick on first launch. **Deps**: P1-03.
### P4-06 Quick Actions — Android/iOS app shortcuts (Smart, Currency, File Converter, QR, Calculator) with platform capability checks. **Deps**: P1-02 + relevant tools.
### P4-07 Home-screen widgets — platform-dependent; Android first (currency pair, countdown); feasibility spike precedes commitment. **Deps**: P2-12, P2-11.
### P4-08 Storage migration to local DB — move history/presets/events behind the existing service interfaces to Hive/Drift if volumes demand it; interfaces unchanged. **Deps**: P1-05, P1-11, P2-11.
### P4-09 Accessibility & responsive pass — semantic labels, touch targets, contrast; tablet navigation rail; desktop/web layouts. **Deps**: P1-02, P1-08.
### P4-10 Translation architecture split — split `translations.dart` into logical modules (core/calculators/units/currencies/files/settings/errors) with zero key changes; parity tests guard the split. **Deps**: P0-02.
### P4-11 About + What's New + tool statistics. **Deps**: P1-12.
### P4-12 Premium groundwork — feature-flag layer only; **owner-blocked**: no paywall work without explicit direction. **Deps**: P1-12.

---

## Final Phase — Audit

### FIN-01 `docs/FINAL_AUDIT.md`
- Compare the actual repository against every requirement of `CALCIVERSE_MASTER_SPEC.md`; classify each as **PASS / PARTIAL / BLOCKED / NOT IMPLEMENTED**. Nothing is claimed "complete" while requirements remain unimplemented. `docs/CHANGELOG.md` maintained throughout.
- **Deps**: all shipped work.

---

## Dependency Graph (high level)

```
P0-01 ─→ P0-10 ─→ P2-14, P2-15
P0-01, P0-02 ─→ P0-13 (CI + secret scan)
P0-06 ─→ P0-10, P0-11 ─→ P2-11 ─→ P4-03, P4-07
P0-06 ─→ P1-05 ─→ P1-03, P1-06, P4-02, P4-08
P0-05 ─→ P1-01 ─→ P1-02 ─→ P1-03; P1-04; P1-07; P3-*, P4-*
P0-07 ─→ P1-04, P1-10, P1-14 ─→ P2-06 ─→ P2-07; P4-04
P0-08 ─→ P2-08, P2-09, P2-10
P0-12 ─→ P1-04, P1-10, P2-12 ─→ P2-13, P4-07
P1-08 ─→ (adopted incrementally by nearly all tool tasks)
P1-09 ─→ P1-10
P2-01 ─→ P2-02..P2-05
```

## Owner Decisions / Blockers

1. **P0-01 (URGENT)**: revoke/rotate the exposed CloudConvert key in the CloudConvert dashboard; the old credential must never be used again.
2. **P2-14**: backend hosting choice for the CloudConvert proxy (and whether it lives in this repo or a separate one).
3. **P2-12**: currency rate API provider selection (free vs paid, ToS; keyed providers require the backend first).
4. **P2-11**: whether push notifications are in scope (adds per-platform setup).
5. **P4-12**: premium/monetization direction before any paywall work.

## First implementation task after approval

**P0-01 CloudConvert credential incident** — remove the hardcoded token, add the unconfigured-state UX, add secret scanning, and write `docs/SECURITY.md`; in parallel the owner revokes the exposed key. P0-02 (translation parity) can proceed immediately after (or concurrently, as it is independent).
