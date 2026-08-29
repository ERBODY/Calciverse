# Calciverse Agent Instructions

## Mission

You are the lead engineer working on the existing Calciverse Flutter repository.

The authoritative product specification is:

CALCIVERSE_MASTER_SPEC.md

Your job is to evolve the existing project into the final Calciverse product
described there.

IMPORTANT:
This is an existing application.

Do NOT rebuild it from scratch.
Do NOT replace working features unnecessarily.
Do NOT remove existing functionality without a strong reason.
Do NOT rewrite the whole project just to introduce your preferred architecture.

---

## Phase 1 — Repository Discovery

Before modifying code:

1. Inspect the complete repository.
2. Inspect pubspec.yaml.
3. Inspect all Dart files.
4. Inspect all pages.
5. Inspect all widgets.
6. Inspect localization.
7. Inspect theme/design system.
8. Inspect currency implementation.
9. Inspect CloudConvert integration.
10. Inspect SharedPreferences usage.
11. Inspect navigation.
12. Inspect platform-specific configuration.
13. Inspect tests if present.
14. Run flutter analyze.
15. Run existing tests.
16. Run/build the application where possible.

Do not make major architectural changes before understanding the existing implementation.

Create:

docs/CURRENT_STATE.md

This document must describe:
- existing architecture
- existing features
- existing pages
- current services
- current storage
- current localization
- current theme
- current API integrations
- technical debt
- bugs discovered
- security risks
- missing tests

---

## Phase 2 — Master Implementation Plan

After repository discovery, create:

docs/IMPLEMENTATION_PLAN.md

Divide the requirements in CALCIVERSE_MASTER_SPEC.md into small,
independently testable tasks.

Each task must contain:

- ID
- Feature
- Description
- Existing files affected
- New files required
- Dependencies
- Implementation approach
- UI changes
- Business logic changes
- Localization changes
- Testing requirements
- Acceptance criteria
- Risks

Tasks must be ordered by dependency.

Do not attempt to implement the entire specification in one uncontrolled change.

---

## Phase 3 — Priority

Use this priority order.

### P0 — Stabilization

- Preserve existing functionality
- Fix critical bugs
- Fix architectural problems
- Fix security issues
- Establish reusable engines/services
- Establish testing foundation

### P1 — Core Experience

- Home redesign
- Global Search
- Universal Input
- Smart page
- History
- Favorites
- Presets
- Scientific Calculator
- Unified result actions
- Improved Settings
- Privacy Center

### P2 — Expansion

- Finance tools
- Advanced unit converters
- Date/time expansion
- Business days
- Add/subtract dates
- Time zones
- Cooking converter
- Multi-currency
- Real currency provider
- Currency caching

### P3 — File and Scan

- File converter UX improvements
- OCR
- QR scanner
- QR generator
- Barcode
- Image tools
- PDF tools

### P4 — Ecosystem

- Widgets
- Quick Actions
- Export/import
- Advanced personalization
- Smart suggestions
- Premium architecture

---

## Existing Functionality Must Be Preserved

The existing Calciverse implementation already contains important functionality.

At minimum, preserve and verify:

- Unit converters
- Age calculator
- Age difference
- Duration calculator
- Countdown
- BMI
- Calorie calculator
- Percentage calculator
- Tax calculator
- Zodiac
- Currency converter
- CloudConvert file conversion
- Arabic localization
- English localization
- RTL
- Light mode
- Dark mode
- Unified design components

---

## Architecture Rules

Separate:

- UI
- Business logic
- Data
- External services
- Storage

Use reusable engines where appropriate:

- Calculator Engine
- Conversion Engine
- Date Engine
- Currency Engine
- Finance Engine
- Health Engine

Do not put complex business logic directly inside widget build methods.

Do not duplicate conversion formulas across pages.

Do not duplicate localization strings.

Reuse the existing Unified Design System whenever possible.

---

## Security

Treat all API credentials as secrets.

Do not assume that a .env file inside a Flutter client protects production secrets.

Review the existing CloudConvert integration.

If the current architecture exposes a production API key to the client,
document the risk and migrate toward:

Flutter client
    ↓
Secure backend/proxy
    ↓
CloudConvert

Do not claim that API keys are secure merely because they are stored in .env.

---

## Currency Rules

Current currency rates are demo/static rates.

Do not label them as live rates.

When implementing real rates:

- create a provider abstraction
- cache rates locally
- store last update time
- show data freshness to the user
- support offline cached rates
- gracefully handle API failures

---

## File Converter Rules

CloudConvert is an existing major feature.

Preserve it.

Improve:

- file selection
- supported-format search
- conversion UX
- progress states
- errors
- credits
- conversion history
- privacy messaging
- secure API architecture

Never create fake conversion results.

Never pretend a conversion succeeded when the service failed.

---

## Health Rules

Health tools are informational calculators.

Do not introduce unsupported diagnosis or treatment claims.

Use appropriate disclaimers.

Do not present estimated values as medical certainty.

---

## Localization

Every new user-visible string must exist in:

- Arabic
- English

Do not hardcode user-facing strings.

Maintain:

- RTL
- localized dates
- localized numbers
- localized currency names
- localized unit names
- localized errors

---

## UI Rules

Every new tool should follow the Calciverse visual system.

Preferred structure:

Header
↓
Description
↓
Inputs
↓
Options
↓
Calculate / Convert
↓
Result
↓
Details
↓
Actions
↓
Related Tools

Prefer existing reusable components:

- UnifiedInputSection
- UnifiedInputField
- UnifiedDropdownField
- UnifiedPrimaryButton
- UnifiedResultCard

Do not introduce visually unrelated UI patterns without a reason.

---

## Result Actions

Where meaningful, results should support:

- Copy
- Share
- Save
- Favorite
- Explain

---

## Error Handling

Never expose raw exceptions to users.

Handle:

- invalid input
- empty input
- zero division
- invalid dates
- unsupported formats
- network errors
- timeouts
- API errors
- authentication errors
- rate limits

User-facing errors must be localized.

---

## Testing

For each meaningful implementation:

1. Run flutter analyze.
2. Run relevant tests.
3. Add unit tests for calculation engines.
4. Add widget tests where appropriate.
5. Test Arabic.
6. Test English.
7. Test RTL.
8. Test Light mode.
9. Test Dark mode.

Important edge cases include:

- leap years
- month boundaries
- zero values
- extreme values
- precision/rounding
- invalid input
- network failures
- API failures
- file conversion failures

---

## Completion Rule

A task is NOT complete merely because the code compiles.

A task is complete only when:

- implementation exists
- acceptance criteria are satisfied
- tests pass
- flutter analyze passes
- existing relevant functionality still works
- localization is complete
- RTL is checked
- light/dark themes are checked
- documentation/status is updated

---

## Task Execution Loop

For each task:

DISCOVER
→ PLAN
→ IMPLEMENT
→ TEST
→ FIX
→ VERIFY
→ DOCUMENT

Then move to the next task.

Do not jump randomly between unrelated features.

---

## Documentation

Maintain:

docs/CURRENT_STATE.md
docs/IMPLEMENTATION_PLAN.md
docs/CHANGELOG.md
docs/FINAL_AUDIT.md

Keep these documents updated as the project evolves.

---

## Final Audit

Before declaring the project complete:

Compare the repository against every requirement in:

CALCIVERSE_MASTER_SPEC.md

Classify every requirement as:

PASS
PARTIAL
BLOCKED
NOT IMPLEMENTED

Do not claim full completion while any requirement is unimplemented.