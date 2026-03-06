import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:mocktail/mocktail.dart';

class MockDeepLinkSource extends Mock implements DeepLinkSource {}

class MockJoinCodeHandler extends Mock {
  void call(String code);
}

void main() {
  late MockDeepLinkSource mockSource;
  late StreamController<Uri> uriController;
  late DeepLinkService service;

  setUp(() {
    mockSource = MockDeepLinkSource();
    uriController = StreamController<Uri>.broadcast();

    when(() => mockSource.getInitialLink()).thenAnswer((_) async => null);
    when(() => mockSource.uriLinkStream).thenAnswer((_) => uriController.stream);

    service = DeepLinkService(source: mockSource);
  });

  tearDown(() async {
    await uriController.close();
    service.dispose();
  });

  group('DeepLinkService - 核心測試 1: 解析標準邀請連結', () {
    test('應可解析 https 邀請連結並提取 code=123456', () async {
      final intents = <DeepLinkIntent>[];
      final sub = service.intentStream.listen(intents.add);

      await service.initialize();
      uriController.add(Uri.parse('https://ironsplit.app/join?code=123456'));
      await Future<void>.delayed(Duration.zero);

      expect(intents.length, 1);
      expect(intents.first, isA<JoinTaskIntent>());
      expect((intents.first as JoinTaskIntent).code, '123456');

      await sub.cancel();
    });

    test('應可解析 custom scheme 邀請連結並提取 code=123456', () async {
      final intents = <DeepLinkIntent>[];
      final sub = service.intentStream.listen(intents.add);

      await service.initialize();
      uriController.add(Uri.parse('${AppConstants.scheme}://join?code=123456'));
      await Future<void>.delayed(Duration.zero);

      expect(intents.length, 1);
      expect(intents.first, isA<JoinTaskIntent>());
      expect((intents.first as JoinTaskIntent).code, '123456');

      await sub.cancel();
    });
  });

  group('DeepLinkService - SettlementIntent 解析', () {
    test('應可解析 custom scheme 結算連結並提取 taskId=TASK_123', () async {
      final intents = <DeepLinkIntent>[];
      final sub = service.intentStream.listen(intents.add);

      await service.initialize();
      uriController.add(Uri.parse('${AppConstants.scheme}://host/locked/TASK_123'));
      await Future<void>.delayed(Duration.zero);

      expect(intents.length, 1);
      expect(intents.first, isA<SettlementIntent>());
      expect((intents.first as SettlementIntent).taskId, 'TASK_123');

      await sub.cancel();
    });

    test('應可解析 https 結算連結並提取 taskId=TASK_123', () async {
      final intents = <DeepLinkIntent>[];
      final sub = service.intentStream.listen(intents.add);

      await service.initialize();
      uriController.add(Uri.parse('https://ironsplit.app/locked/TASK_123'));
      await Future<void>.delayed(Duration.zero);

      expect(intents.length, 1);
      expect(intents.first, isA<SettlementIntent>());
      expect((intents.first as SettlementIntent).taskId, 'TASK_123');

      await sub.cancel();
    });
  });

  group('DeepLinkService - 核心測試 2: 無效與惡意連結防護', () {
    test('無 code 的 /join 應忽略，不拋例外', () async {
      final intents = <DeepLinkIntent>[];
      final sub = service.intentStream.listen(intents.add);

      await service.initialize();
      uriController.add(Uri.parse('https://ironsplit.app/join'));
      await Future<void>.delayed(Duration.zero);

      expect(intents, isEmpty);
      await sub.cancel();
    });

    test('未知路徑 /unknown 應忽略，不拋例外', () async {
      final intents = <DeepLinkIntent>[];
      final sub = service.intentStream.listen(intents.add);

      await service.initialize();
      uriController.add(Uri.parse('https://ironsplit.app/unknown'));
      await Future<void>.delayed(Duration.zero);

      expect(intents, isEmpty);
      await sub.cancel();
    });

    test('缺少 taskId 的 /locked 或 /locked/ 應視為 UnknownIntent 並忽略', () async {
      final intents = <DeepLinkIntent>[];
      final sub = service.intentStream.listen(intents.add);

      await service.initialize();
      uriController.add(Uri.parse('https://ironsplit.app/locked'));
      uriController.add(Uri.parse('${AppConstants.scheme}://host/locked/'));
      await Future<void>.delayed(Duration.zero);

      // DeepLinkService 對 UnknownIntent 不發射事件，因此應維持空列表
      expect(intents, isEmpty);

      await sub.cancel();
    });

    test('損壞 URL 字串應被安全處理，不拋未捕捉例外', () async {
      final intents = <DeepLinkIntent>[];
      final sub = service.intentStream.listen(intents.add);

      expect(() => service.handleRawLink('http://%zz'), returnsNormally);
      expect(() => service.handleRawLink(':'), returnsNormally);
      expect(() => service.handleRawLink('not a url'), returnsNormally);

      await Future<void>.delayed(Duration.zero);
      expect(intents, isEmpty);

      await sub.cancel();
    });
  });

  group('DeepLinkService - 核心測試 3: 攔截成功後觸發後續邏輯', () {
    test('攔截到邀請碼後，應可透過 intent stream 觸發儲存/路由邏輯', () async {
      final onJoinCode = MockJoinCodeHandler();
      when(() => onJoinCode.call(any())).thenReturn(null);

      final sub = service.intentStream.listen((intent) {
        if (intent is JoinTaskIntent) {
          onJoinCode.call(intent.code);
        }
      });

      await service.initialize();
      uriController.add(Uri.parse('https://ironsplit.app/join?code=ABC999'));
      await Future<void>.delayed(Duration.zero);

      verify(() => onJoinCode.call('ABC999')).called(1);
      await sub.cancel();
    });
  });
}
