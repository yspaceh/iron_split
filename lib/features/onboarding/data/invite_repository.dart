import 'package:cloud_functions/cloud_functions.dart';
import 'package:iron_split/core/base/base_repository.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/invite_code_model.dart';

class InviteRepository extends BaseRepository {
  final FirebaseFunctions _functions;

  InviteRepository({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  /// 呼叫 previewInviteCode
  Future<Map<String, dynamic>> previewInviteCode(String code) async {
    return await safeRun(() async {
      final callable = _functions.httpsCallable('previewInviteCode');
      final result = await callable.call({'code': code});
      if (result.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(result.data);
      } else {
        throw AppErrorCodes.inviteInvalid;
      }
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
      final taskId = result.data?['taskId'];
      if (taskId is String) {
        return taskId;
      } else {
        throw AppErrorCodes.joinFailed; // 或其他更具體的錯誤
      }
    }, AppErrorCodes.joinFailed);
  }

  Future<InviteCodeDetail> createInviteCode(String taskId) async {
    return await safeRun(() async {
      final callable = _functions.httpsCallable('createInviteCode');
      final result = await callable.call({'taskId': taskId});
      if (result.data is Map) {
        final data = Map<String, dynamic>.from(result.data as Map);
        return InviteCodeDetail.fromMap(data);
      } else {
        throw AppErrorCodes.inviteCreateFailed;
      }
    }, AppErrorCodes.inviteCreateFailed);
  }
}
