import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

enum LogAction {
  createTask,
  updateSettings,
  addMember,
  removeMember,
  createRecord,
  updateRecord,
  deleteRecord,
  settleUp,
  unknown,
}

class ActivityLogModel {
  final String id;
  final String operatorUid;
  final LogAction actionType;
  final Map<String, dynamic> details;
  final DateTime createdAt;

  ActivityLogModel({
    required this.id,
    required this.operatorUid,
    required this.actionType,
    required this.details,
    required this.createdAt,
  });

  factory ActivityLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLogModel(
      id: doc.id,
      operatorUid: data['operatorUid'] ?? '',
      actionType: _parseAction(data['actionType']),
      details: data['details'] as Map<String, dynamic>? ?? {},
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static LogAction _parseAction(String? type) {
    switch (type) {
      case 'create_task':
        return LogAction.createTask;
      case 'update_settings':
        return LogAction.updateSettings;
      case 'add_member':
        return LogAction.addMember;
      case 'remove_member':
        return LogAction.removeMember;
      case 'create_record':
        return LogAction.createRecord;
      case 'update_record':
        return LogAction.updateRecord;
      case 'delete_record':
        return LogAction.deleteRecord;
      case 'settle_up':
        return LogAction.settleUp;
      default:
        return LogAction.unknown;
    }
  }

  String getLocalizedAction(BuildContext context) {
    switch (actionType) {
      case LogAction.createTask:
        return t.log_action.create_task;
      case LogAction.updateSettings:
        return t.log_action.update_settings;
      case LogAction.addMember:
        return t.log_action.add_member;
      case LogAction.removeMember:
        return t.log_action.remove_member;
      case LogAction.createRecord:
        return t.log_action.create_record;
      case LogAction.updateRecord:
        return t.log_action.update_record;
      case LogAction.deleteRecord:
        return t.log_action.delete_record;
      case LogAction.settleUp:
        return t.log_action.settle_up;
      case LogAction.unknown:
        return t.log_action.unknown;
    }
  }

  String getFormattedDetails() {
    final buffer = StringBuffer();

    // Handle Record Name
    if (details.containsKey('recordName')) {
      buffer.write(details['recordName']);
    }

    // Handle Currency & Amount (Create/Delete)
    if (details.containsKey('currency') && details.containsKey('amount')) {
      if (buffer.isNotEmpty) buffer.write(" ");
      final currency = details['currency'];
      final amount = CurrencyOption.formatAmount(details['amount'], currency);
      buffer.write("($currency $amount)");
    }

    // Handle Update (Old -> New)
    if (details.containsKey('oldAmount') && details.containsKey('newAmount')) {
      if (buffer.isNotEmpty) buffer.write(" ");
      final currency = details['currency'] ?? '';
      final oldAmt =
          CurrencyOption.formatAmount(details['oldAmount'], currency);
      final newAmt =
          CurrencyOption.formatAmount(details['newAmount'], currency);
      buffer.write("($currency $oldAmt -> $newAmt)");
    }

    if (buffer.isEmpty && details.isNotEmpty) {
      // Fallback: print first value if logic above missed
      return details.values.first.toString();
    }

    return buffer.toString();
  }
}
