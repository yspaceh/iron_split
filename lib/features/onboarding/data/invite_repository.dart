import 'package:cloud_functions/cloud_functions.dart';

class InviteRepository {
  final FirebaseFunctions _functions;

  InviteRepository({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  /// 呼叫 previewInviteCode
  Future<Map<String, dynamic>> previewInviteCode(String code) async {
    try {
      final callable = _functions.httpsCallable('previewInviteCode');
      final result = await callable.call({'code': code});
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      // 這裡可以做更細緻的錯誤轉換，暫時透傳
      rethrow;
    }
  }

  /// 呼叫 joinByInviteCode
  Future<String> joinTask({
    required String code,
    required String displayName,
    String? targetMemberId, // 對應 _selectedGhostId
  }) async {
    try {
      final callable = _functions.httpsCallable('joinByInviteCode');
      final result = await callable.call({
        'code': code,
        'displayName': displayName,
        'targetMemberId': targetMemberId,
      });
      return result.data['taskId'] as String;
    } catch (e) {
      rethrow;
    }
  }
}
