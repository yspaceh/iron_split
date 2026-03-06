#!/usr/bin/env bash
set -euo pipefail

flutter test \
  test/mvp/widget/s13_task_dashboard_page_test.dart \
  test/mvp/widget/s17_task_locked_page_test.dart \
  test/mvp/widget/s32_settlement_result_page_test.dart
