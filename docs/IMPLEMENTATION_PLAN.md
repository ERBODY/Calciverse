# Calciverse — Master Implementation Plan

Derived from `CALCIVERSE_MASTER_SPEC.md`, ordered by the AGENTS.md priority phases (P0 → P4).
Tasks are small, independently testable, and ordered by dependency. Each task follows the loop:
DISCOVER → PLAN → IMPLEMENT → TEST → FIX → VERIFY → DOCUMENT.

Global acceptance criteria applying to **every** task (per AGENTS.md, not repeated below):
- `flutter analyze` passes; relevant tests pass; existing functionality preserved.
- All new user-visible strings exist in both English and Arabic; RTL verified.
- Light and dark themes verified.
- No raw exceptions shown to users; errors localized.
- `docs/CHANGELOG.md` updated.

Legend: **Deps** lists task IDs that must be completed first.

---

## P0 — Stabilization

### P0-01 Revoke & externalize the CloudConvert API key
- **Feature**: Security hotfix.
- **Description**: The production CloudConvert JWT is hardcoded in `file_converter_page.dart` and committed to git history. Revoke it in the CloudConvert dashboard (owner action — cannot be done from code), issue a new key, and load it from `.env` via `flutter_dotenv` (already wired in `main.dart`). Show a localized "service not configured" state when the key is absent. Document that `.env` is NOT real protection (spec §53) — the real fix is P2-14 (backend proxy).
- **Existing files**: `lib/pages/file_converter_page.dart`, `.env.example`, `README.md`.
- **New files**: none.
- **Deps**: none. **Blocked on user**: key revocation/rotation.
- **Approach**: replace `_cloudConvertToken` const with `dotenv.env['CLOUDCONVERT_API_KEY']`; guard conversion start when null/empty.
- **UI changes**: error card when unconfigured. **Logic**: key sourcing. **Localization**: new error string.
- **Testing**: manual conversion with/without `.env`; widget test for unconfigured state.
- **Acceptance**: no secret string in current tracked files; converter works with `.env` key; graceful unconfigured state.
- **Risks**: old key remains in git history — rotation is mandatory, history rewrite optional.

### P0-02 Fix translation parity & failing tests
- **Feature**: Localization integrity.
- **Description**: Add the 17 missing Arabic keys (incl. `input`); replace the brittle hardcoded key-count assertion (412) with a dynamic EN↔AR parity check; localize hardcoded English strings (e.g. file-size-limit warning).
- **Existing files**: `lib/utils/translations.dart`, `test/language_test.dart`, `lib/pages/file_converter_page.dart`.
- **Deps**: none.
- **Testing**: `flutter test` fully green.
- **Acceptance**: 0 failing tests; no missing AR keys; parity test can't drift.
- **Risks**: low.

### P0-03 Fix deprecation warnings
- **Feature**: Toolchain health.
- **Description**: Replace `withOpacity` → `withValues`, `DropdownButtonFormField.value` → `initialValue`, `Switch.activeColor` → `activeThumbColor` (47 infos).
- **Existing files**: most pages + `unified_page_design.dart`, `unified_theme.dart`.
- **Deps**: none.
- **Acceptance**: `flutter analyze` → 0 issues.
- **Risks**: purely mechanical; visual regression risk minimal — spot-check both themes.

### P0-04 Remove dead code & dead dependencies
- **Feature**: Cleanup.
- **Description**: Delete unused `lib/widgets/unified_theme.dart` and unreachable `PlaceholderPage`; remove unused deps `converter`, `translator`, `page_transition` from pubspec.
- **Deps**: P0-03 (touches same files).
- **Acceptance**: app builds and runs; pubspec has no unused deps.
- **Risks**: verify nothing references them (grep before delete).

### P0-05 App-wide locale/theme propagation
- **Feature**: Architectural fix.
- **Description**: Introduce a lightweight `AppSettings` ChangeNotifier (or InheritedWidget) exposing language/theme so open pages react to changes, removing 4-param prop drilling. Keep page constructors backward compatible during migration (default to inherited value).
- **Existing files**: `lib/main.dart`, `lib/home_page.dart`, all pages (incremental).
- **New files**: `lib/core/app_settings.dart`.
- **Deps**: none.
- **Testing**: widget test — toggling language rebuilds an open page; manual RTL flip check.
- **Acceptance**: language/theme change reflected without reopening pages.
- **Risks**: broad but mechanical; migrate page-by-page to limit blast radius.

### P0-06 Storage service abstraction
- **Feature**: Storage foundation.
- **Description**: Create `StorageService` wrapping SharedPreferences (typed get/set, JSON list helpers) as the single storage entry point, ready to swap in a local DB later (spec §129). Migrate existing keys (`isLightTheme`, `language`, credits).
- **New files**: `lib/core/storage/storage_service.dart`.
- **Deps**: none.
- **Testing**: unit tests with `SharedPreferences.setMockInitialValues`.
- **Acceptance**: no page talks to SharedPreferences directly (except via service).
- **Risks**: key-name migration — reuse existing key names exactly.

### P0-07 Conversion Engine (units)
- **Feature**: Reusable engine.
- **Description**: Extract all unit conversion factor maps and math from the 7 converter pages into `ConversionEngine` with the pipeline Input → Validate → Normalize → Base Unit → Target → Format (spec §123). Pages keep their current UI, delegating math to the engine. Temperature handled with offset formulas, not factors.
- **Existing files**: `length_page.dart`, `area_page.dart`, `weight_and_mass_page.dart`, `volume_and_fluid_units_page.dart`, `temperature_page.dart`, `time_page.dart`, `data_page.dart`.
- **New files**: `lib/engines/conversion/conversion_engine.dart`, `lib/engines/conversion/unit_definitions.dart`.
- **Deps**: none.
- **Testing**: unit tests: every unit ↔ base round-trip, precision/rounding, zero, extreme values, invalid input.
- **Acceptance**: identical results to current pages (golden values captured before refactor); no factor maps left in pages.
- **Risks**: silent value regressions — mitigate with before/after fixture tests.

### P0-08 Date Engine
- **Feature**: Reusable engine.
- **Description**: Extract date math from Age, Age Difference, Duration, Countdown, Zodiac into `DateEngine` (age breakdown, next birthday, difference, duration incl. include/exclude start, leap years, month boundaries).
- **New files**: `lib/engines/date/date_engine.dart`.
- **Deps**: none.
- **Testing**: unit tests: Feb 29 birthdays, month-end boundaries, DST-agnostic durations, future-date validation.
- **Acceptance**: pages delegate to engine with unchanged results.
- **Risks**: subtle off-by-one differences — capture current behavior in fixtures first.

### P0-09 Health Engine + disclaimers
- **Feature**: Reusable engine + compliance.
- **Description**: Extract BMI and calorie/BMR math into `HealthEngine`; add localized informational disclaimers to BMI and Calorie pages ("estimate, not medical advice" — spec §39, AGENTS Health Rules). Frame Zodiac descriptions as entertainment content.
- **Existing files**: `bmi_calculator_page.dart`, `calorie_calculator_page.dart`, `zodiac_sign_page.dart`.
- **New files**: `lib/engines/health/health_engine.dart`.
- **Deps**: none.
- **Testing**: unit tests for BMI classification boundaries, Mifflin/Harris BMR values.
- **Acceptance**: disclaimers visible in EN/AR; engine tested.
- **Risks**: low.

### P0-10 CloudConvertService extraction
- **Feature**: Service layer.
- **Description**: Move the CloudConvert job/upload/poll/export HTTP flow out of `file_converter_page.dart` into `CloudConvertService` with typed results, honest progress states (Uploading/Processing/Finalizing — fixing the broken compounding progress heuristic), and a typed error taxonomy (network/timeout/auth/rate-limit/service/unsupported). Enforce credit check *before* starting and only deduct on a validly started job (spec §57). Stop leaking raw `$e` in dialogs.
- **Existing files**: `lib/pages/file_converter_page.dart`.
- **New files**: `lib/services/cloudconvert/cloudconvert_service.dart`, `lib/core/errors/app_error.dart`.
- **Deps**: P0-01.
- **Testing**: unit tests with mocked `http.Client` for each job state and error type.
- **Acceptance**: page contains only UI; conversion works end-to-end; all error paths localized.
- **Risks**: highest-value existing feature — test manually with a real small file before merging.

### P0-11 Persist countdown events
- **Feature**: Bug fix (data loss).
- **Description**: Persist countdown events via `StorageService` (JSON list), supporting multiple events (spec §36 groundwork). Keep current single-event UI; render a list if >1 exists.
- **Existing files**: `lib/pages/event_countdown_page.dart`.
- **Deps**: P0-06.
- **Testing**: unit test serialization; manual restart check.
- **Acceptance**: events survive restart.
- **Risks**: low.

### P0-12 Currency demo-rate labeling + Currency Engine
- **Feature**: Honesty fix + engine.
- **Description**: Extract the 160+ currency metadata and rates into `CurrencyEngine` with a `RateProvider` interface whose current implementation is `StaticDemoRateProvider`. Show an explicit localized "Demo rates — not live" badge and rate-source line in the Currency page (spec §50, AGENTS Currency Rules).
- **Existing files**: `lib/pages/currency_converter_page.dart`.
- **New files**: `lib/engines/currency/currency_engine.dart`, `lib/engines/currency/rate_provider.dart`, `lib/engines/currency/static_rates.dart`.
- **Deps**: none.
- **Testing**: unit tests for cross-rate conversion (A→USD→B), search by code/name/AR name.
- **Acceptance**: UI clearly shows demo status; conversions unchanged.
- **Risks**: low.

### P0-13 Testing foundation & CI
- **Feature**: Infrastructure.
- **Description**: Add GitHub Actions workflow running `flutter analyze`, `flutter test`, and `flutter build web` on PRs. Add a shared widget-test harness (pump app in EN/AR × light/dark).
- **New files**: `.github/workflows/ci.yml`, `test/helpers/test_harness.dart`.
- **Deps**: P0-02 (tests must be green first).
- **Acceptance**: CI green on main; harness used by at least one widget test.
- **Risks**: none.

---

## P1 — Core Experience

### P1-01 Tool registry
- **Feature**: Foundation for Home/Search/Favorites/History.
- **Description**: Central `ToolRegistry` describing every tool: id, category, icon, EN/AR names, search aliases (EN+AR), route builder. Home grid renders from the registry instead of the hardcoded switch.
- **Existing files**: `lib/home_page.dart`.
- **New files**: `lib/core/tools/tool_registry.dart`, `lib/core/tools/tool_definition.dart`.
- **Deps**: P0-05.
- **Testing**: unit test: every registered tool has EN+AR names, unique id, buildable page.
- **Acceptance**: Home identical visually but registry-driven.
- **Risks**: missing a tool during migration — assert registry count == 18.

### P1-02 Bottom navigation shell
- **Feature**: App structure (spec §4).
- **Description**: New shell with tabs Home / Tools / Smart / History / Favorites / Settings (Smart & History & Favorites can be stubs initially). Existing pages keep working via push navigation.
- **New files**: `lib/pages/shell_page.dart`, stub pages.
- **Deps**: P1-01.
- **Testing**: widget test tab switching, RTL tab order.
- **Acceptance**: all 18 tools remain reachable; tabs functional.
- **Risks**: navigation regressions — keep old push flows intact.

### P1-03 Home redesign
- **Feature**: Spec §5–8.
- **Description**: Home = header + tagline, big search field (routes to Global Search), Quick Tools (default 8, usage-ordered later), Recent Tools (from usage log), category cards. Categories from ToolRegistry.
- **New files**: `lib/pages/home/` widgets.
- **Deps**: P1-01, P1-02, P1-05 (usage log).
- **Testing**: widget tests EN/AR; empty-state for recents.
- **Acceptance**: Home shows ≤15 items (spec §141); all categories navigate.
- **Risks**: scope creep — smart ordering ships in P4.

### P1-04 Global Search
- **Feature**: Spec §9.
- **Description**: Search across tool names, aliases, unit names, currency names/codes/countries (EN+AR). Results grouped by type; selecting opens the tool.
- **New files**: `lib/core/search/search_engine.dart`, `lib/pages/search_page.dart`.
- **Deps**: P1-01, P0-07, P0-12 (unit/currency metadata).
- **Testing**: unit tests: Arabic queries, code queries ("USD"), partial matches, aliases.
- **Acceptance**: finds tools by non-official names in both languages.
- **Risks**: search quality — start with normalized substring + alias matching.

### P1-05 History service + usage log
- **Feature**: Spec §15–16 foundation.
- **Description**: `HistoryService` recording entries {tool, date, time, input summary, result} plus a tool-usage log (for recents/quick tools). Opt-out toggle in Settings. Storage via StorageService (JSON, capped e.g. 200 entries).
- **New files**: `lib/core/history/history_service.dart`, `lib/models/history_entry.dart`.
- **Deps**: P0-06.
- **Testing**: unit tests: append, cap, clear, disable.
- **Acceptance**: converters + calculators write history when enabled.
- **Risks**: SharedPreferences scale — cap size; DB migration is P4 option.

### P1-06 History page
- **Feature**: Spec §15–16.
- **Description**: History tab: list, detail view, actions (open tool, reuse inputs, copy, share, favorite, delete), search/filter/clear-all, empty state.
- **Deps**: P1-05, P1-02, P1-08.
- **Testing**: widget tests incl. empty state and clear-all confirm.
- **Acceptance**: all actions functional in EN/AR.
- **Risks**: "reuse" needs per-tool input restoration — implement via registry deep-link params for a first subset of tools.

### P1-07 Favorites (tools + saved calculations)
- **Feature**: Spec §17.
- **Description**: `FavoritesService`; ⭐ toggle in every tool header (spec §144); Favorites tab with two sections (tools / saved calculations); empty states.
- **New files**: `lib/core/favorites/favorites_service.dart`, `lib/pages/favorites_page.dart`.
- **Deps**: P1-01, P0-06.
- **Testing**: unit + widget tests; persistence across restart.
- **Acceptance**: favorite from any tool header; appears in tab and Home.
- **Risks**: low.

### P1-08 Unified result actions
- **Feature**: Spec §91–94.
- **Description**: Extend `UnifiedResultCard` with optional details section, "How is this calculated?" explanation sheet, and actions row: Copy (value/details), Share (text; image later), Save (history), Favorite. SnackBar "Copied" feedback. Adopt in converters + calculators incrementally.
- **Existing files**: `lib/widgets/unified_page_design.dart`, all tool pages.
- **New files**: `lib/widgets/result_actions.dart`.
- **Deps**: P1-05, P1-07 (save/favorite hooks; copy/share can land first).
- **Testing**: widget tests: copy puts value on clipboard; actions render RTL correctly.
- **Acceptance**: every tool result exposes at least Copy + Share.
- **Risks**: touch all pages — roll out page-by-page.

### P1-09 Scientific calculator
- **Feature**: Spec §13–14.
- **Description**: New tool: expression evaluation (+ − × ÷, parentheses, ^, √, π, e, !, %, trig + inverse, log/ln/exp), DEG/RAD toggle, memory (MC/MR/M+/M−/MS), local calculation history. Build `CalculatorEngine` (tokenizer + shunting-yard) — no eval library needed, or use a vetted package.
- **New files**: `lib/engines/calculator/calculator_engine.dart`, `lib/pages/scientific_calculator_page.dart`.
- **Deps**: P1-01 (registry), P1-08 (result actions).
- **Testing**: extensive unit tests: precedence, unary minus, factorial of non-integers (error), div-by-zero, deg/rad trig values.
- **Acceptance**: correct results for a documented test matrix; localized errors.
- **Risks**: parser complexity — highest-effort P1 task; keep engine UI-independent.

### P1-10 Universal Input engine + Smart page
- **Feature**: Spec §10–12.
- **Description**: Parser that classifies free text: arithmetic expression → CalculatorEngine; "5 km to mi" → ConversionEngine; "100 usd to eur" → CurrencyEngine; percentage phrases; date phrases (later). Smart tab UI: input, "understood as" card, result, Open Tool / Copy / Save / Share. Same engine powers Home search field fallback.
- **New files**: `lib/core/smart/universal_input_engine.dart`, `lib/pages/smart_page.dart`.
- **Deps**: P1-09, P0-07, P0-12, P1-04.
- **Testing**: unit tests: EN + AR phrases, unit aliases, ambiguous input fallback to search.
- **Acceptance**: the three core intents (math, unit, currency) work in both languages.
- **Risks**: NLP scope — restrict to pattern grammar, not ML; document supported patterns.

### P1-11 Presets
- **Feature**: Spec §18.
- **Description**: `PresetsService` storing named input bundles per tool; Save-as-preset from tool pages (start: BMI, Calorie, Currency, Tax); preset picker on those pages; management UI (rename/delete); empty state.
- **New files**: `lib/core/presets/presets_service.dart`.
- **Deps**: P0-06, P1-08.
- **Testing**: unit tests serialization; widget test apply-preset fills inputs.
- **Acceptance**: create/apply/delete presets on 4 tools.
- **Risks**: per-tool input schemas — define a simple `Map<String,String>` contract.

### P1-12 Settings expansion
- **Feature**: Spec §105, §95–97, §100.
- **Description**: Restructure Settings into sections: Appearance (language, theme incl. **System** mode, font size), Defaults (default currency, metric/imperial, precision), History (enable/clear/auto-cleanup), Files (cloud-processing info), About (version/licenses). Wire precision into ConversionEngine formatting and defaults into relevant tools.
- **Existing files**: `lib/pages/settings_page.dart`, `lib/main.dart`.
- **Deps**: P0-05, P0-06, P1-05.
- **Testing**: widget tests; unit test precision formatting.
- **Acceptance**: settings persist and take effect app-wide immediately.
- **Risks**: precision must not be forced on all tools (spec §95) — per-tool override allowed.

### P1-13 Privacy Center
- **Feature**: Spec §106–107, §63.
- **Description**: New page from Settings: what's stored locally (settings/favorites/history/presets/cache), what goes to cloud (CloudConvert file lifecycle honestly described), per-category delete buttons + Delete All. File Converter page gets a transparent "Files are processed using cloud conversion services" notice.
- **New files**: `lib/pages/privacy_center_page.dart`.
- **Deps**: P1-05, P1-07, P1-11 (deletable data exists).
- **Testing**: widget test delete flows with confirmations.
- **Acceptance**: honest copy in EN/AR; deletions verifiably clear storage.
- **Risks**: legal-ish copy — keep factual, no "100% secure" claims.

### P1-14 Converter UX upgrade (swap, precision, unit search)
- **Feature**: Spec §20–27.
- **Description**: Add to all 7 unit converters: ⇄ Swap, precision control (from Settings default), searchable unit picker, clear-input buttons, Data converter decimal (KB) vs binary (KiB) distinction, US/Imperial gallon labeling, unit info snippets for uncommon units (Qirat, Donum).
- **Deps**: P0-07, P1-08, P1-12.
- **Testing**: engine tests for KiB/KB; widget test swap behavior.
- **Acceptance**: consistent converter template across all 7 pages.
- **Risks**: layout churn — reuse one shared converter scaffold widget.

---

## P2 — Expansion

### P2-01 Finance Engine
- **Description**: `FinanceEngine`: simple/compound interest, loan payment + amortization schedule, EMI, ROI, profit/margin/markup, savings goal, tip/bill split. Pure functions, fully unit-tested (spec §126, §132).
- **New files**: `lib/engines/finance/finance_engine.dart`.
- **Deps**: none (engine only).
- **Testing**: golden-value tests against known financial tables; rounding rules documented.
- **Risks**: financial correctness — cite formulas in doc comments.

### P2-02 Finance tools: Loan + EMI (spec §73–74)
- **Deps**: P2-01, P1-01, P1-08. Amortization table with lazy rendering.
### P2-03 Finance tools: Interest (simple + compound) + Investment (spec §75–77)
- **Deps**: P2-01. Include "assumed return, not a guarantee" disclaimer.
### P2-04 Finance tools: ROI + Profit/Margin/Markup modes (spec §78–79)
- **Deps**: P2-01.
### P2-05 Finance tools: Salary (generic, no country tax rules), Tip & Bill Split, Savings Goal (spec §80–82)
- **Deps**: P2-01.

### P2-06 Advanced converters
- **Description**: Add Speed, Pressure, Energy, Power, Force, Frequency, Angle, Torque, Density, Fuel Economy (reciprocal-aware) to ConversionEngine + one shared converter page template (spec §28, §155 — avoid 10 duplicated pages).
- **Deps**: P0-07, P1-14.
- **Testing**: unit tests incl. fuel-economy reciprocal conversions.

### P2-07 Cooking converter (spec §29)
- **Description**: Volume↔volume plus volume↔weight with ingredient densities (flour/sugar/rice/water/milk).
- **Deps**: P2-06.

### P2-08 Add/Subtract Date tool (spec §33)
- **Deps**: P0-08. Edge cases: month-end (Jan 31 + 1 month), leap years.
### P2-09 Business Days calculator (spec §34)
- **Deps**: P0-08. Configurable working week (Sun–Thu / Mon–Fri) + holiday list.
### P2-10 Time Zone converter (spec §89)
- **Deps**: P0-08. Use IANA tz database (`timezone` package), not fixed offsets; DST-correct.
### P2-11 Countdown upgrade: multiple events, time, icon, edit/delete; notifications optional (spec §35–37)
- **Deps**: P0-11. Notifications require `flutter_local_notifications` + platform config; make notifications a separate sub-deliverable.

### P2-12 Real currency provider + caching + freshness (spec §51–52)
- **Description**: Implement a real `RateProvider` (e.g. open exchange-rate API; key via backend or free keyless API), normalization, local cache with `lastUpdated`, offline fallback to cached rates with "Using cached rates" banner, graceful API-failure handling. Demo provider remains the fallback, still labeled.
- **Deps**: P0-12, P0-06.
- **Testing**: mocked provider tests: fresh fetch, stale cache, offline, API error.
- **Risks**: provider ToS/keys — if key required, route through P2-14 backend.

### P2-13 Multi-currency view + currency favorites + primary currency (spec §47–49)
- **Deps**: P2-12, P1-07, P1-12.

### P2-14 CloudConvert backend proxy
- **Description**: Minimal backend (e.g. Cloudflare Worker / small server) holding the CloudConvert key; endpoints: create job, job status. Flutter `CloudConvertService` switches to proxy base URL; server-side rate limiting replaces trust in client credits. This closes the P0-01 residual risk (spec §53, §120).
- **New files**: `server/` (or separate repo — owner decision), client config.
- **Deps**: P0-10. **Blocked on user**: hosting choice/account.
- **Testing**: integration test against deployed proxy; client error paths.
- **Risks**: new infrastructure to operate; deployment decision needed from owner.

### P2-15 File Converter UX: format search, credits display with reset time, format info, conversion history (spec §54–62)
- **Deps**: P0-10, P1-05. Searchable format picker (200+ formats grouped by category), "7/10 remaining + reset time" card, from→to info, per-conversion history records with status.

---

## P3 — File & Scan

### P3-01 QR Generator (spec §70) — pure local, `qr_flutter`; URL/text/Wi-Fi/contact/email/phone; save/share image.
- **Deps**: P1-01, P1-08.
### P3-02 QR Scanner (spec §68–69) — `mobile_scanner`; show content first, never auto-open links; Open/Copy/Share actions. Camera support differs per platform (spec §135) — gate by capability.
- **Deps**: P3-01 (shared QR page shell).
### P3-03 Barcode scanner (spec §71) — raw data display only; no product-name claims.
- **Deps**: P3-02.
### P3-04 OCR (spec §66–67) — on-device via `google_mlkit_text_recognition` (mobile); result editable, Copy/Share/Save/Export TXT. Label honestly as On-Device; hide on unsupported platforms.
- **Deps**: P1-01, P1-08.
### P3-05 Image tools (spec §64) — local convert (JPG/PNG/WebP), resize with aspect lock, quality compression, rotate. Package: `image`.
- **Deps**: P1-01.
### P3-06 PDF tools (spec §65) — merge/split/extract/rotate locally (`pdf`/`pdfx`); verify feasibility per operation before promising compression.
- **Deps**: P3-05.
### P3-07 Cross-tool workflows (spec §90, §143) — Related Tools section in tool template: BMI→BMR/TDEE, Age→Zodiac/Countdown, OCR→PDF export, Currency→Finance.
- **Deps**: P1-01, P1-08, relevant tools shipped.

---

## P4 — Ecosystem

### P4-01 Home personalization (spec §111) — customize quick tools, order, sections; local only.
- **Deps**: P1-03.
### P4-02 Local learning / smart ordering (spec §112) — order Quick Tools & unit/currency pickers by local usage frequency.
- **Deps**: P1-05, P1-03.
### P4-03 Export / Import settings (spec §113) — JSON export of favorites/presets/custom units/preferences/events; import with validation.
- **Deps**: P1-07, P1-11, P2-11.
### P4-04 Custom units (spec §19) — user-defined units (name/symbol/base/factor) surfaced in converters under "My Units".
- **Deps**: P0-07, P1-14.
### P4-05 Onboarding + first launch (spec §117–118) — 3 screens + language/theme pick; skippable.
- **Deps**: P1-03.
### P4-06 Quick Actions (spec §115) — Android/iOS app shortcuts: Smart, Currency, File Converter, QR, Calculator.
- **Deps**: P1-02, relevant tools.
### P4-07 Home-screen widgets (spec §114) — platform-dependent; Android first (currency pair, countdown). Feasibility spike first.
- **Deps**: P2-12, P2-11.
### P4-08 Storage migration to local DB (spec §129) — move history/presets/events to Hive/Drift behind existing service interfaces if volumes demand it.
- **Deps**: P1-05, P1-11, P2-11.
### P4-09 Accessibility & responsive pass (spec §102–104) — semantic labels on result cards, touch targets, contrast audit; tablet navigation rail; desktop/web layout.
- **Deps**: P1-02, P1-08.
### P4-10 Translation architecture split (spec §99) — split `translations.dart` into logical modules (core/calculators/units/currencies/files/settings/errors) with no key changes.
- **Deps**: P0-02.
### P4-11 About page + What's New + tool statistics (spec §138–140).
- **Deps**: P1-12.
### P4-12 Premium architecture groundwork (AGENTS P4) — feature-flag layer only; no paywall implementation without owner direction.
- **Deps**: P1-12.

---

## Final Phase — Audit

### FIN-01 `docs/FINAL_AUDIT.md`
- Compare repo against every requirement of `CALCIVERSE_MASTER_SPEC.md`; classify each as PASS / PARTIAL / BLOCKED / NOT IMPLEMENTED. Maintain `docs/CHANGELOG.md` throughout all phases.
- **Deps**: all shipped work.

---

## Dependency Graph (high level)

```
P0-01 ─→ P0-10 ─→ P2-14, P2-15
P0-06 ─→ P0-11 ─→ P2-11 ─→ P4-03, P4-07
P0-06 ─→ P1-05 ─→ P1-06, P1-03, P4-02, P4-08
P0-07 ─→ P1-04, P1-10, P1-14 ─→ P2-06 ─→ P2-07; P4-04
P0-08 ─→ P2-08, P2-09, P2-10
P0-12 ─→ P2-12 ─→ P2-13, P4-07
P1-01 ─→ P1-02 ─→ P1-03; P1-04; P1-07; P3-*, P4-*
P1-08 ─→ (adopted by nearly all tool tasks)
P1-09 ─→ P1-10
P2-01 ─→ P2-02..P2-05
```

## Items Requiring Owner Decisions (blockers)

1. **P0-01**: revoke/rotate the leaked CloudConvert key (dashboard access required).
2. **P2-14**: backend hosting choice for the CloudConvert proxy.
3. **P2-12**: currency rate API provider selection (free vs paid, ToS).
4. **P2-11**: whether push notifications are in scope for v-next (adds platform setup).
5. **P4-12**: premium/monetization direction before any paywall work.
