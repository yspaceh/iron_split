# TESTING Guide

This document defines the testing strategy and conventions for `iron_split`.

## 1. Test Layers

### Unit (`test/mvp/unit`)
- Purpose: Validate pure/domain logic and repository contract behavior.
- Scope:
  - Calculation/rounding/business rules.
  - Error mapping and edge handling.
  - Payload shape and update contract.
- Must not depend on real navigation/UI rendering.

### Widget (`test/mvp/widget`)
- Purpose: Validate page/view behavior in Flutter widget tree.
- Scope:
  - UI states (empty/data/error).
  - User interaction and navigation.
  - Dialog/toast/loading state transitions.
- Uses fake router + mocked dependencies.

### Integration (`integration_test/mvp`)
- Purpose: Validate cross-screen flow and recovery behavior.
- Scope:
  - Happy path and high-risk failure path.
  - Recovery correctness (no wrong route, no wrong write).
  - Race-condition and deep-link flow.
- Run as suite on `main` (see CI section).

### Smoke (`tool/test_smoke_widget.sh`)
- Purpose: Fast confidence check on high-value screens.
- Scope: Minimal but critical widget tests (`S13`, `S17`, `S32`).

## 2. Naming Convention

### File naming
- Unit: `<subject>_test.dart`
  - Examples: `settlement_service_test.dart`, `currency_constants_test.dart`
- Widget: `<screen_or_contract>_test.dart`
  - Examples: `s10_home_task_list_page_test.dart`, `router_s31_contract_test.dart`
- Integration: `<flow>_test.dart`
  - Examples: `settlement_flow_test.dart`, `deep_link_locked_recovery_test.dart`

### Test naming
- Prefer behavior-first naming:
  - `given/when/then` style or explicit scenario/result style.
- Use exact risk intent in title for failure/recovery cases.
- Avoid vague names like `should work`.

## 3. Mock / Fake Rules

### Default rule
- Mock all external boundaries:
  - `TaskRepository`, `RecordRepository`, `AuthRepository`, `SystemRepository`, network/share/deep-link services.

### Use real implementation only when deterministic and local
- Allowed examples:
  - `TaskService` for pure filter/sort behavior in widget tests.
  - Static formatters/constants in unit tests.

### Stream testing
- Use `StreamController.broadcast()` to simulate timing/race updates.
- Re-emit state after route changes when subscriber does not replay history.
- In race tests, enforce a deterministic expected branch (no broad OR assertion).

### Localization testing
- For deferred locale bundles, test locale keys via generated translation bundles directly.
- Avoid flaky async locale switching in widget tests unless truly needed for UI behavior.

## 4. Command Reference

### Local
- All unit tests:
  - `flutter test test/mvp/unit`
- All widget tests:
  - `flutter test test/mvp/widget`
- All integration tests:
  - `flutter test integration_test/mvp`
- Smoke:
  - `bash tool/test_smoke_widget.sh`
- Firestore rules contract tests:
  - `cd functions && npm run test:rules`

### Targeted
- Single file:
  - `flutter test path/to/test_file.dart`

## 5. CI Mapping

- PR Gate (`.github/workflows/ci-tests.yml`)
  - Runs: unit + widget.
  - Trigger: pull request to `main`.

- Integration Suite (`.github/workflows/integration-tests.yml`)
  - Runs: `integration_test/mvp`.
- Trigger: push to `main`, manual dispatch.

## 6. Minimum Requirement For New Feature

At least one of the following must be added for each new feature/fix:
- Unit test for business rule.
- Widget test for screen interaction/state.
- Integration test for cross-screen flow (required for high-risk paths).

For regression fixes:
- Add a failing test first that reproduces the bug.
- Then fix production code.
- Keep assertion strict enough to catch the original bug again.

## 7. Current Coverage Snapshot (MVP)

- Unit: calculators/services/repository contracts/localization currency formatting.
- Widget: `S00/S10/S11/S12/S13/S14/S15/S16/S17/S30/S31/S32/S54` and router contract.
- Integration: bootstrap pending invite, S16 create flow, settlement flow, deep-link locked recovery, race condition branch.
