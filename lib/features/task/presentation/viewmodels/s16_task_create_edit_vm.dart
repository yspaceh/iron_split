import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart';

class S16TaskCreateEditViewModel extends ChangeNotifier {
  // State
  late DateTime _startDate;
  late DateTime _endDate;
  CurrencyOption _baseCurrencyOption = CurrencyOption.defaultCurrencyOption;
  int _memberCount = 1;
  bool _isCurrencyInitialized = false;
  bool _isProcessing = false;
  String? _statusText; // 用於顯示 Loading 狀態文字 (e.g. "建立中...", "產生邀請碼...")

  // Getters
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  CurrencyOption get baseCurrencyOption => _baseCurrencyOption;
  int get memberCount => _memberCount;
  bool get isCurrencyEnabled => true; // 保留原始邏輯
  bool get isProcessing => _isProcessing;
  String? get statusText => _statusText;

  S16TaskCreateEditViewModel() {
    // 1. 初始化日期 (今天)
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = _startDate;
  }

  // 初始化幣別 (避免重複偵測)
  void initCurrency() {
    if (!_isCurrencyInitialized) {
      _isCurrencyInitialized = true;
      final CurrencyOption suggestedCurrency =
          CurrencyOption.detectSystemCurrency();
      _baseCurrencyOption = suggestedCurrency;
      // 這裡不需 notifyListeners，因為通常是在 build 前或第一幀執行，
      // 若有需要可加，但需注意 notify 時機
    }
  }

  // --- Setters (Update State) ---

  void updateStartDate(DateTime date) {
    _startDate = date;
    // 防呆：結束日不能早於開始日 (可選)
    if (_endDate.isBefore(_startDate)) {
      _endDate = _startDate;
    }
    notifyListeners();
  }

  void updateEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  void updateCurrency(CurrencyOption currency) {
    _baseCurrencyOption = currency;
    notifyListeners();
  }

  void updateMemberCount(int count) {
    _memberCount = count;
    notifyListeners();
  }

  /// 核心邏輯：建立任務
  Future<({String taskId, String? inviteCode})?> createTask(
      String taskName, Translations t) async {
    _isProcessing = true;
    _statusText = t.D03_TaskCreate_Confirm.creating_task;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isProcessing = false;
      notifyListeners();
      throw Exception("User not logged in");
    }

    try {
      // 1. Prepare Members Map
      final Map<String, dynamic> membersMap = {};

      // A. Add Captain
      membersMap[user.uid] = {
        'role': 'captain',
        'displayName': user.displayName ?? 'Captain',
        'joinedAt': FieldValue.serverTimestamp(),
        'avatar': _getRandomAvatar(),
        'isLinked': true,
        'hasSeenRoleIntro': false,
      };

      // B. Add Ghost Members
      for (int i = 1; i < _memberCount; i++) {
        final ghostId = 'virtual_member_$i';
        final prefix = t.common.member_prefix;

        membersMap[ghostId] = {
          'role': 'member',
          'displayName': '$prefix ${i + 1}',
          'joinedAt': FieldValue.serverTimestamp(),
          'avatar': _getRandomAvatar(),
          'isLinked': false,
          'hasSeenRoleIntro': false,
        };
      }

      // 2. 寫入 DB
      final docRef = await FirebaseFirestore.instance.collection('tasks').add({
        'name': taskName,
        'createdBy': user.uid,
        'memberCount': _memberCount,
        'maxMembers': _memberCount,
        'baseCurrency': _baseCurrencyOption.code,
        'startDate': Timestamp.fromDate(_startDate),
        'endDate': Timestamp.fromDate(_endDate),
        'status': 'ongoing',
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'members': membersMap,
        'activeInviteCode': null,
        // 'remainderRule': 'random', // Optional based on Model
      });

      // 3. Activity Log
      final dateStr =
          "${DateFormat('yyyy/MM/dd').format(_startDate)} - ${DateFormat('yyyy/MM/dd').format(_endDate)}";

      await ActivityLogService.log(
        taskId: docRef.id,
        action: LogAction.createTask,
        details: {
          'recordName': taskName,
          'currency': _baseCurrencyOption.code,
          'memberCount': _memberCount,
          'dateRange': dateStr,
        },
      );

      // 4. Invite Code & Share
      String? inviteCode;
      if (_memberCount > 1) {
        _statusText = t.D03_TaskCreate_Confirm.preparing_share;
        notifyListeners();

        // 呼叫 API 取得邀請碼
        final callable =
            FirebaseFunctions.instance.httpsCallable('createInviteCode');
        final res = await callable.call({'taskId': docRef.id});
        final data = Map<String, dynamic>.from(res.data);
        inviteCode = data['code'];
      }

      _isProcessing = false;
      notifyListeners();
      return (taskId: docRef.id, inviteCode: inviteCode);
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      rethrow; // 拋出異常讓 Page 處理 (顯示 SnackBar)
    }
  }

  String _getRandomAvatar() {
    const avatars = [
      "cow",
      "pig",
      "deer",
      "horse",
      "sheep",
      "goat",
      "duck",
      "stoat",
      "rabbit",
      "mouse",
      "cat",
      "dog",
      "otter",
      "owl",
      "fox",
      "hedgehog",
      "donkey",
      "squirrel",
      "badger",
      "robin"
    ];
    return avatars[Random().nextInt(avatars.length)];
  }
}
