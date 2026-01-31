import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/domain/models/activity_log_model.dart';
import 'package:iron_split/features/task/domain/services/activity_log_service.dart';

class S14TaskSettingsViewModel extends ChangeNotifier {
  final String taskId;

  // UI State
  TextEditingController nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  CurrencyOption? _currency;
  String _remainderRule = 'random';
  bool _isLoading = true;

  // Logic Helper
  String? _initialName;
  String? _createdBy;
  Map<String, dynamic> _membersData = {};

  // Getters
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  CurrencyOption? get currency => _currency;
  String get remainderRule => _remainderRule;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get membersData => _membersData;

  bool get isOwner {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return currentUid != null && currentUid == _createdBy;
  }

  S14TaskSettingsViewModel({required this.taskId});

  Future<void> init() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        nameController.text = data['name'] ?? '';
        _initialName = data['name'] ?? '';

        _startDate = (data['startDate'] as Timestamp?)?.toDate();
        _endDate = (data['endDate'] as Timestamp?)?.toDate();
        _currency = CurrencyOption.getCurrencyOption(
            data['baseCurrency'] ?? CurrencyOption.defaultCode);
        _remainderRule = data['remainderRule'] ?? 'random';
        _createdBy = data['createdBy'] as String?;
        _membersData = data['members'] as Map<String, dynamic>? ?? {};

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Actions ---

  Future<void> updateName() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) return;
    if (newName == _initialName) return;

    _initialName = newName;
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({'name': newName});

    await ActivityLogService.log(
      taskId: taskId,
      action: LogAction.updateSettings,
      details: {
        'settingType': 'task_name',
        'newValue': newName,
      },
    );
  }

  Future<void> updateDateRange(DateTime start, DateTime end) async {
    _startDate = start;
    _endDate = end;
    notifyListeners();

    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'startDate': Timestamp.fromDate(start),
      'endDate': Timestamp.fromDate(end),
    });

    final dateStr =
        "${DateFormat('yyyy/MM/dd').format(start)} - ${DateFormat('yyyy/MM/dd').format(end)}";

    await ActivityLogService.log(
      taskId: taskId,
      action: LogAction.updateSettings,
      details: {
        'settingType': 'date_range',
        'newValue': dateStr,
      },
    );
  }

  Future<void> updateRemainderRule(String newRule) async {
    _remainderRule = newRule;
    notifyListeners();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({'remainderRule': newRule});

    await ActivityLogService.log(
      taskId: taskId,
      action: LogAction.updateSettings,
      details: {
        'settingType': 'remainder_rule',
        'newValue': newRule,
      },
    );
  }

  // 更新幣別 (僅 UI 狀態，實際寫入由 D09 完成)
  void updateCurrency(CurrencyOption newCurrency) {
    _currency = newCurrency;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
