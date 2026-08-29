# Calciverse — Changelog

Project change log. Updated at meaningful milestones: completed features, security fixes, architectural changes, and releases — not trivial edits.

## [Unreleased]

### Documentation
- 2026-08-29 — Repository audit completed (`docs/CURRENT_STATE.md`): architecture, features, verification runs (analyze/test/build), security risks, bugs, technical debt, spec gap analysis.
- 2026-08-29 — Master implementation plan created and revised per owner review (`docs/IMPLEMENTATION_PLAN.md`): P0–P4 phases, per-task fields, dependency graph, owner blockers.

### Security (documented, not yet remediated)
- 2026-08-29 — **Security incident identified**: a production CloudConvert API credential is hardcoded in `lib/pages/file_converter_page.dart` and present in git history. Remediation is P0-01 (owner must revoke/rotate the key; secret removed from tracked source; secret scanning added). The historical exposure stands regardless of any later git-history rewrite.
