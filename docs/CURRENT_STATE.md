# Calciverse — Current State Audit

Date: 2026-08-29
Audited against: `CALCIVERSE_MASTER_SPEC.md` / `AGENTS.md` (Phase 1 — Repository Discovery)
Toolchain used: Flutter 3.35.4 (stable), Dart 3.9.2

---

## 1. Repository Overview

| Item | Value |
|---|---|
| App name | `calciverse` v1.0.0+1 |
| SDK constraint | `>=3.0.0 <4.0.0` |
| Platforms configured | Android, iOS, Web, Windows, macOS, Linux |
| Dart LOC (lib + test) | ~14,400 lines across 27 files |
| Pages | 19 (18 tools + Settings) |
| Test files | 1 (`test/language_test.dart`, translation-only) |

### Directory layout

```
lib/
├── main.dart                    # App root, theme, locale, dotenv load
├── home_page.dart               # Home grid + navigation switch + PlaceholderPage
├── pages/                       # 19 pages (one file per tool)
├── widgets/
│   ├── unified_page_design.dart # Unified design system components
│   └── unified_theme.dart       # UNUSED (never imported)
└── utils/
    ├── translations.dart        # 1,045-line EN/AR map + number/date formatting
    ├── conversion_mapping.dart  # 4,289-line file-format conversion map
    └── string_formatter.dart    # toTitleCase helper
test/
└── language_test.dart           # 11 translation tests (3 currently FAIL)
```

### Dependencies (pubspec.yaml)

- Used: `flutter_localizations`, `intl`, `shared_preferences`, `http`, `file_picker`, `url_launcher`, `flutter_dotenv`, `cupertino_icons`
- **Declared but never imported (dead deps): `converter`, `translator`, `page_transition`**

---

## 2. Existing Architecture

- **Pattern**: no state management library; plain `StatefulWidget` + `setState` everywhere.
- **Business logic lives inside page widgets.** Conversion factors, calculation formulas, currency rates, and the entire CloudConvert HTTP workflow are defined directly in page state classes. There are no engines, services, repositories, or models layers.
- **Navigation**: imperative `Navigator.push(MaterialPageRoute(...))` from a `switch` in `home_page.dart` (`_getPageForTitle`). No named routes, no deep links, no bottom navigation. Home is a flat 18-item grid (2 columns).
- **Prop drilling (language)**: `currentLanguage`, `toggleTheme`, `isLightTheme`, `changeLanguage` are passed as constructor params through every page. `currentLanguage` is captured at push time, so a **language** change while a tool page is open does not update that page until it is reopened.
- **Theme propagation is NOT broken**: pages and unified widgets read `Theme.of(context)` (e.g. `Theme.of(context).brightness` in `unified_page_design.dart`), which is inherited from `MaterialApp` and rebuilds open routes when `themeMode` changes. The prop-drilled `isLightTheme` flag is only used to render the Settings switch. Verified by code inspection; runtime verification is part of P0-05 before any theme changes — no theme refactor is planned unless testing proves it necessary.
- **Dead code**: `lib/widgets/unified_theme.dart` (522 lines) is never imported; `PlaceholderPage` in `home_page.dart` is unreachable in practice.

## 3. Existing Features / Pages

All 18 tools reachable from Home:

| Category | Pages |
|---|---|
| Unit converters | Length, Area, Weight & Mass, Volume & Fluids, Temperature, Time, Data |
| Calculators | Age, Age Difference, Duration, Percentage, Post-Tax, BMI, Calorie |
| Tools | Zodiac Sign, Event Countdown, Currency Converter, File Converter (CloudConvert) |
| Other | Settings (language, theme toggle, version) |

Feature notes:

- **Unit converters**: each page holds its own `_conversionFactors` map and its own convert function; layout is From/To dropdowns + Convert button + result card. No swap, no copy/share, no precision control, no unit search.
- **Age / Age Difference / Duration**: date pickers + detailed result cards. Duration supports date+time. No include/exclude-start option; Age has no birth time or next-birthday details beyond basics.
- **Percentage**: single screen computing several derived values at once (no modes).
- **Post-Tax**: salary tax / product tax / reverse tax modes.
- **BMI**: metric/imperial, classification, healthy range. **No health disclaimer.**
- **Calorie (864 lines)**: sex/age/weight/height/activity/formula → BMR + goal calories. **No disclaimer.**
- **Zodiac**: date → sign, description. Presented without an "entertainment content" framing.
- **Event Countdown**: single in-memory event (name + date). **Not persisted** — lost on app restart. No time, repeat, notifications, or multiple events.
- **Currency Converter (1,230 lines)**: 160+ currencies with flags, EN/AR names, region grouping, search. **Rates are hardcoded static demo values** in the page (`// Note: These are example rates`). No caching, no last-updated display, no provider abstraction. The UI does not explicitly label rates as demo/sample.
- **File Converter (733 lines)**: real CloudConvert v2 job flow (create job → S3 upload → poll → export URL), format validation via `conversion_mapping.dart` (200+ formats), 100 MB size limit, daily credit counter (10/day, SharedPreferences), localized error mapping for network/timeout/auth/429/5xx.

## 4. Current Services / API Integrations

- **CloudConvert** is the only external API. All HTTP logic is inline in `file_converter_page.dart` — there is no service class.
- **No currency API** — rates are static data in the page.
- `flutter_dotenv` loads `.env` at startup, but **nothing ever reads `dotenv.env[...]`** — the env infrastructure is effectively unused.

## 5. Current Storage

`SharedPreferences` only, used for:

| Key | Purpose |
|---|---|
| `isLightTheme` | theme toggle |
| `language` | `en` / `ar` |
| `daily_conversion_credits`, `last_reset_date` | file-converter daily credits |

No history, favorites, presets, custom units, cached rates, or countdown persistence. No local database.

## 6. Current Localization

- Custom static map system in `utils/translations.dart` (~900 keys total, EN + AR), with `getTranslation`, `formatNumber`, `formatDate`, `isRTL`, and English fallback.
- RTL handled via explicit `Directionality` wrappers on Home/Settings and RTL-aware row ordering inside unified components.
- Localized number and date formatting via `intl` (`initializeDateFormatting` in main).
- Key naming is inconsistent (`snake_case` mixed with `'Enter value'`-style sentence keys).
- **Parity gaps**: EN has 429 keys, AR has 412 — 17 English keys are missing Arabic translations (e.g. `input`), which is exactly what the failing tests catch.
- Some user-visible strings are hardcoded English (e.g. `'File size exceeds $_maxFileSizeMB MB limit'` in `file_converter_page.dart`).

## 7. Current Theme

- Light + Dark themes built in `main.dart` via `ThemeData.copyWith`; default is **dark**; there is **no "System" mode**.
- Font: `Cairo` for Arabic, `Roboto` for English — but **no font assets are declared in pubspec**, so these families silently fall back to defaults.
- `unified_page_design.dart` provides the design system actually used: `UnifiedPageDesign` (palette constants), `UnifiedInputSection`, `UnifiedInputField`, `UnifiedDropdownField`, `UnifiedPrimaryButton`, `UnifiedResultCard`.
- `UnifiedResultCard` supports only title/value/icon — no details, formula, or actions (copy/share/save/favorite) anywhere in the app.
- Duplicate/conflicting theming: `unified_theme.dart` defines a parallel unused theme system.

## 8. Verification Runs (this audit)

| Check | Result |
|---|---|
| `flutter pub get` | OK |
| `flutter analyze` | **47 issues, all `info`-level** (mostly `withOpacity`/`activeColor`/`DropdownButtonFormField.value` deprecations). No errors/warnings. |
| `flutter test` | **8 passed, 3 FAILED** — all 3 failures are EN/AR key-parity checks (missing Arabic keys, count mismatch 429 vs 412). |
| `flutter build web` | **Succeeds** (`build/web` produced). |

## 9. Security Risks

1. **CRITICAL — Hardcoded CloudConvert API key (active security incident)**: a full production JWT API token (scopes incl. `task.write`, `user.write`, `webhook.write`) is committed as a string constant `_cloudConvertToken` in `lib/pages/file_converter_page.dart` (line ~36). It is in git history and ships inside every client build. The `.env` mechanism exists but is bypassed entirely.
   - Required actions: **revoke/rotate this key immediately** (owner action); the old credential must never be used again; remove it from tracked source with no fallback credential left in code; add repository secret scanning. Removing the secret from the latest commit does NOT remove it from git history — the historical exposure stands regardless, which is why revocation is mandatory.
   - Configuration tiers must be kept distinct: **local development configuration** (`.env`, dev-only convenience — NOT a security boundary), **client-side configuration** (anything bundled in a Flutter client, especially Web, is extractable and must never contain production secrets), and **production secret management** (secrets live server-side behind a backend proxy: Flutter → proxy → CloudConvert). `.env` must not be presented as the production security solution.
2. **Client-side secret architecture**: even with `.env`, any key bundled in a Flutter client (especially Web) is extractable. Spec §120 mandates a backend layer; none exists.
3. **Client-side-only credit limit**: the 10/day quota lives in SharedPreferences and can be reset by clearing app data — it does not protect the CloudConvert account.
4. **Raw exception text shown to users**: several `_showErrorDialog('...: $e')` calls leak exception details (file picking, generic conversion errors).
5. Converted-file download URLs (temporary CloudConvert links) are opened via `url_launcher` with no expiry messaging.

## 10. Bugs Discovered

1. **3 failing tests** — EN/AR translation parity (17 missing Arabic keys).
2. **Event Countdown is not persisted** — events are lost on restart (spec expects persistent, multiple countdowns).
3. **Conversion progress heuristic is broken**: `_conversionProgress = 0.5 + (_conversionProgress * 0.5)` compounds toward 1.0 regardless of actual job progress.
4. **Credits are decremented only on success but not checked before conversion**: a user with 0 credits can still convert (the counter just stays at 0); the limit is display-only.
5. **Language changes don't propagate to already-open pages** (constructor prop drilling; page must be reopened). Theme changes DO propagate via `Theme.of(context)`.
6. **Demo currency rates are not labeled** as demo/sample in the UI (spec §50 forbids presenting them as real).
7. Home tool keys are inconsistent (`'Length'`, `'Area'` capitalized vs `snake_case` elsewhere), which makes the translation lookup fragile.
8. `.env` missing at runtime only logs a debug warning; the File Converter silently uses the hardcoded key.

## 11. Technical Debt

- **No separation of concerns**: business logic (formulas, rates, API calls) inside widget classes; violates spec §122 and AGENTS architecture rules.
- **Duplicate conversion logic**: 5+ pages each embed their own factor maps and convert functions; no shared Conversion Engine.
- **1,045-line translations file** and **4,289-line conversion mapping** as single monolithic Dart maps (spec §99/§131 recommend splitting into logical modules/data models).
- **Dead code / dead deps**: `unified_theme.dart`, `PlaceholderPage`, `converter`, `translator`, `page_transition`.
- **No state management or DI**, no models layer, no routing table.
- **47 deprecation warnings** (`withOpacity`, `DropdownButtonFormField.value`, `Switch.activeColor`) — will break on future Flutter upgrades.
- Missing font assets for declared `Cairo`/`Roboto` families.
- No result actions (copy/share/save) anywhere; no history/favorites/presets storage layer.
- SharedPreferences-only storage won't scale to history/presets/events (spec §129).

## 12. Missing Tests

- **No unit tests for any calculation logic**: unit conversions, age/duration math (leap years, month boundaries), BMI/BMR, percentage, tax, currency conversion, zodiac boundaries.
- **No widget tests** at all (no RTL, light/dark, or page rendering tests).
- **No tests for conversion_mapping** (validity/symmetry of the 200+ format graph).
- **No service-level tests** for the CloudConvert flow (no service exists to test).
- The only suite (translations) is failing and asserts a hardcoded key count (412) that must be updated whenever keys are added — brittle by design.

## 13. Gap Summary vs Master Spec

| Spec area | Status |
|---|---|
| Existing 18 tools, EN/AR, RTL, dark/light, unified components | ✅ Present, preserve |
| Home redesign (search, quick tools, recents, categories) | ❌ Not implemented (flat grid) |
| Global Search / Universal Input / Smart page | ❌ Not implemented |
| Scientific calculator / calculator memory | ❌ Not implemented |
| History / Favorites / Presets / Custom units | ❌ Not implemented (no storage layer) |
| Result actions (copy/share/save/favorite/explain) | ❌ Not implemented |
| Finance suite (loan, EMI, interest, ROI, tip, savings…) | ❌ Not implemented |
| Advanced converters (speed, pressure, energy…) / cooking | ❌ Not implemented |
| Add/Subtract date, Business days, Time zones | ❌ Not implemented |
| Multi-currency, real rate provider, caching, freshness | ❌ Not implemented (static demo rates) |
| Backend proxy for CloudConvert | ❌ Not implemented (hardcoded client key) |
| OCR / QR / Barcode / Image / PDF tools | ❌ Not implemented |
| Widgets / Quick actions / Export-import / Onboarding | ❌ Not implemented |
| Privacy Center / expanded Settings | ❌ Not implemented (minimal Settings) |
| System theme mode | ❌ Not implemented |
| Engines (calculator/conversion/date/currency/finance/health) | ❌ Not implemented |
| Testing foundation | ❌ 1 failing translation suite only |
