import 'package:cloud_functions/cloud_functions.dart';
import 'package:iron_split/core/base/base_repository.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';

class InviteRepository extends BaseRepository {
  final FirebaseFunctions _functions;

  InviteRepository({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  /// 呼叫 previewInviteCode
  Future<Map<String, dynamic>> previewInviteCode(String code) async {
    return await safeRun(() async {
      final callable = _functions.httpsCallable('previewInviteCode');
      final result = await callable.call({'code': code});
      return Map<String, dynamic>.from(result.data);
    }, AppErrorCodes.inviteInvalid);
  }

  /// 呼叫 joinByInviteCode
  Future<String> joinTask({
    required String code,
    required String displayName,
    String? targetMemberId, // 對應 _selectedGhostId
  }) async {
    return await safeRun(() async {
      final callable = _functions.httpsCallable('joinByInviteCode');
      final result = await callable.call({
        'code': code,
        'displayName': displayName,
        'targetMemberId': targetMemberId,
      });
      return result.data['taskId'] as String;
    }, AppErrorCodes.joinFailed);
  }

  Future<String> createInviteCode(String taskId) async {
    return await safeRun(() async {
      final callable = _functions.httpsCallable('createInviteCode');
      final result = await callable.call({'taskId': taskId});
      return result.data['code'] as String;
    }, AppErrorCodes.inviteCreateFailed);
  }
}
