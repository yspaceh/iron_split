import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/onboarding/data/pending_invite_local_store.dart';

class OnboardingService {
  final AuthRepository _authRepo;
  final InviteRepository _inviteRepo; // 新增依賴
  final PendingInviteLocalStore _localStore; // 新增依賴

  OnboardingService({
    required AuthRepository authRepo,
    InviteRepository? inviteRepo,
    PendingInviteLocalStore? localStore,
  })  : _authRepo = authRepo,
        _inviteRepo = inviteRepo ?? InviteRepository(),
        _localStore = localStore ?? PendingInviteLocalStore();

  /// 驗證名字格式 (業務規則)
  /// 回傳錯誤訊息，若為 null 代表驗證通過
  AppErrorCodes? validateName(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return null; // 空值不回傳錯誤，只是未完成
    }

    if (trimmed.length > 10) {
      return AppErrorCodes.nameLengthExceeded; // 雖然 UI 有擋，後端邏輯也要擋
    }

    // 禁止控制字元 (Regex 規則從原本 UI 搬過來)
    final hasControlChars = trimmed.contains(RegExp(r'[\x00-\x1F\x7F]'));
    if (hasControlChars) {
      return AppErrorCodes.invalidChar;
    }

    return null; // Valid
  }

  /// 提交名字
  Future<void> submitName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw AppErrorCodes.fieldRequired;
    }
    final error = validateName(trimmed);
    if (error != null) {
      throw error;
    }
    await _authRepo.updateDisplayName(name.trim());
  }

  /// 執行預覽並分析 Ghost 狀態 (邏輯搬家)
  /// 回傳：包含 taskData, ghosts, isAutoAssign 的物件
  Future<InviteAnalysisResult> analyzeInvite(String code) async {
    final data = await _inviteRepo.previewInviteCode(code);

    // 解析 Ghosts
    List<Map<String, dynamic>> ghosts = [];
    final ghostsData = data['ghosts'] as List?;

    bool autoAssign = true;

    if (ghostsData != null) {
      ghosts =
          ghostsData.map((e) => Map<String, dynamic>.from(e as Map)).toList();

      // [核心邏輯] Check if all ghosts are financially identical
      if (ghosts.length > 1) {
        final first = ghosts.first;
        const double epsilon = 0.001;

        for (var i = 1; i < ghosts.length; i++) {
          final current = ghosts[i];
          final double prepaid1 = (first['prepaid'] as num?)?.toDouble() ?? 0.0;
          final double prepaid2 =
              (current['prepaid'] as num?)?.toDouble() ?? 0.0;
          final double expense1 = (first['expense'] as num?)?.toDouble() ?? 0.0;
          final double expense2 =
              (current['expense'] as num?)?.toDouble() ?? 0.0;

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
  }) async {
    final user = _authRepo.currentUser;
    if (user == null) {
      throw AppErrorCodes.unauthorized;
    }

    final taskId = await _inviteRepo.joinTask(
      code: code,
      displayName: user.displayName ?? 'Guest',
      targetMemberId: targetMemberId,
    );

    await _localStore.clear();
    return taskId;
  }
}

/// 簡單的 DTO 用來回傳分析結果
class InviteAnalysisResult {
  final Map<String, dynamic> taskData;
  final List<Map<String, dynamic>> ghosts;
  final bool isAutoAssign;

  InviteAnalysisResult({
    required this.taskData,
    required this.ghosts,
    required this.isAutoAssign,
  });
}
