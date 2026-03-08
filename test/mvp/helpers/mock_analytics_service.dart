import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsService extends Mock implements AnalyticsService {}

bool _fallbacksRegistered = false;

void _registerFallbackValues() {
  if (_fallbacksRegistered) return;
  registerFallbackValue(InviteMethod.link);
  registerFallbackValue(PayerType.member);
  registerFallbackValue(InviteEntryPoint.manual);
  registerFallbackValue(Duration.zero);
  _fallbacksRegistered = true;
}

void stubAnalyticsService(MockAnalyticsService analytics) {
  _registerFallbackValues();
  when(() => analytics.logTaskCreate(
        expectedDays: any(named: 'expectedDays'),
        memberTotal: any(named: 'memberTotal'),
      )).thenAnswer((_) async {});
  when(() => analytics.logTaskJoin(method: any(named: 'method')))
      .thenAnswer((_) async {});
  when(() => analytics.logTaskDeleteManual(durationDays: any(named: 'durationDays')))
      .thenAnswer((_) async {});
  when(() => analytics.logExpenseAdd(
        splitMethod: any(named: 'splitMethod'),
        subItemsLength: any(named: 'subItemsLength'),
        payerType: any(named: 'payerType'),
        category: any(named: 'category'),
        hasNote: any(named: 'hasNote'),
      )).thenAnswer((_) async {});
  when(() => analytics.logInviteEntryOpen(entryPoint: any(named: 'entryPoint')))
      .thenAnswer((_) async {});
  when(() => analytics.logInviteSend(
        method: any(named: 'method'),
        entryPoint: any(named: 'entryPoint'),
      )).thenAnswer((_) async {});
  when(() => analytics.logInviteDismiss(duration: any(named: 'duration')))
      .thenAnswer((_) async {});
  when(() => analytics.logExecuteSettlement(
        actualDays: any(named: 'actualDays'),
        expenseCount: any(named: 'expenseCount'),
        memberCount: any(named: 'memberCount'),
        remainderRule: any(named: 'remainderRule'),
        linkedMemberCount: any(named: 'linkedMemberCount'),
      )).thenAnswer((_) async {});
  when(() => analytics.logReportExport()).thenAnswer((_) async {});
  when(() => analytics.syncUserProperties()).thenAnswer((_) async {});
}
