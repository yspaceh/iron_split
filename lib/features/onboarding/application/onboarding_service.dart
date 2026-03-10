import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/core/services/logger_service.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/onboarding/data/pending_invite_local_store.dart';

enum InviteMethod { link, qr, code }

class OnboardingService {
  final AuthRepository _authRepo;
  final InviteRepository _inviteRepo; // 新增依賴
  final PendingInviteLocalStore _localStore; // 新增依賴
  final AnalyticsService _analyticsService;
  final LoggerService _loggerService;

  OnboardingService({
    required AuthRepository authRepo,
    InviteRepository? inviteRepo,
    PendingInviteLocalStore? localStore,
    AnalyticsService? analyticsService,
    LoggerService? loggerService,
  })  : _loggerService = loggerService ?? LoggerService.instance,
        _authRepo = authRepo,
        _inviteRepo = inviteRepo ?? InviteRepository(),
        _localStore = localStore ??
            PendingInviteLocalStore(loggerService ?? LoggerService.instance),
        _analyticsService = analyticsService ?? AnalyticsService.instance;

  /// 驗證名字格式 (業務規則)
  /// 回傳錯誤訊息，若為 null 代表驗證通過
  void validateName(String name) {
    try {
      final trimmed = name.trim();

      if (trimmed.isEmpty) throw AppErrorCodes.fieldRequired;

      if (trimmed.length > 10) throw AppErrorCodes.nameLengthExceeded;

      // 禁止控制字元 (Regex 規則從原本 UI 搬過來)
      final hasControlChars = trimmed.contains(RegExp(r'[\x00-\x1F\x7F]'));
      if (hasControlChars) throw AppErrorCodes.invalidChar;
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  /// 提交名字
  Future<void> submitName(String name) async {
    try {
      final trimmed = name.trim();
      validateName(trimmed);
      await _authRepo.updateDisplayName(name.trim());
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  /// 執行預覽並分析 Ghost 狀態 (邏輯搬家)
  /// 回傳：包含 taskData, ghosts, isAutoAssign 的物件
  Future<InviteAnalysisResult> analyzeInvite(String code) async {
    final data = await _inviteRepo.previewInviteCode(code);

    // 解析 Ghosts
    List<TaskMember> ghosts = [];
    final ghostsData = data['ghosts'] as List?;

    bool autoAssign = true;

    if (ghostsData != null) {
      ghosts = ghostsData.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        return TaskMember.fromMap(map['id'] ?? map['uid'] ?? '', map);
      }).toList();

      // [核心邏輯] Check if all ghosts are financially identical
      if (ghosts.length > 1) {
        final first = ghosts.first;
        const double epsilon = 0.001;

        for (var i = 1; i < ghosts.length; i++) {
          final current = ghosts[i];

          // 直接讀取 TaskMember 的 prepaid 與 expense 屬性
          final double prepaid1 = first.prepaid;
          final double prepaid2 = current.prepaid;
          final double expense1 = first.expense;
          final double expense2 = current.expense;

          if ((prepaid1 - prepaid2).abs() > epsilon ||
              (expense1 - expense2).abs() > epsilon) {
            autoAssign = false; // 財務不同，必須手動選擇
            break;
          }
        }
      }
    }

    return InviteAnalysisResult(
      taskData: data,
      ghosts: ghosts,
      isAutoAssign: autoAssign,
    );
  }

  /// 執行加入
  Future<String> confirmJoin({
    required String code,
    String? targetMemberId,
    String? displayName,
    required InviteMethod method,
  }) async {
    final taskId = await _inviteRepo.joinTask(
      code: code,
      displayName: displayName ?? 'New Member',
      targetMemberId: targetMemberId,
    );

    await _localStore.clear();
    try {
      await _analyticsService.logTaskJoin(
        method: method,
      );
    } catch (e, stackTrace) {
      _loggerService.recordError(
        e,
        stackTrace,
        reason:
            'AnalyticsService: OnboardingService - confirmJoin: Failed to log confirm join',
      );
    }

    return taskId;
  }
}

/// 簡單的 DTO 用來回傳分析結果
class InviteAnalysisResult {
  final Map<String, dynamic> taskData;
  final List<TaskMember> ghosts;
  final bool isAutoAssign;

  InviteAnalysisResult({
    required this.taskData,
    required this.ghosts,
    required this.isAutoAssign,
  });
}
