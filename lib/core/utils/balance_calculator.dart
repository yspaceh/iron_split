import 'package:iron_split/core/models/record_model.dart';

class BalanceCalculator {
  /// 計算特定使用者的淨餘額 (Net Balance)
  /// 公式：(總支付 Credit) - (總消費 Debit)
  static double calculatePersonalNetBalance({
    required List<RecordModel> allRecords,
    required String uid,
  }) {
    double totalPaid = 0.0;
    double totalConsumed = 0.0;

    for (var record in allRecords) {
      totalPaid += calculatePersonalCredit(record, uid);
      totalConsumed += calculatePersonalDebit(record, uid);
    }

    return totalPaid - totalConsumed;
  }

  /// 判斷使用者是否與此紀錄有關
  static bool isUserInvolved(RecordModel record, String uid) {
    if (calculatePersonalCredit(record, uid) > 0) return true;
    if (calculatePersonalDebit(record, uid) > 0) return true;

    // 邊緣情況：金額為 0 但在名單內 (例如被請客)
    if (record.items.isNotEmpty) {
      for (var item in record.items) {
        if (item.splitMemberIds.contains(uid)) return true;
      }
    }
    if (record.splitDetails != null && record.splitDetails!.containsKey(uid)) {
      return true;
    }
    if (record.splitMemberIds.contains(uid)) {
      return true;
    }

    return false;
  }

  /// 公開方法：計算單筆紀錄對使用者的消費影響
  static double calculatePersonalDebit(RecordModel record, String uid) {
    return _calculateDebit(record, uid);
  }

  // --- 內部輔助方法 ---

  // 計算「貢獻/支付」(Credit)
  // 計算「貢獻/支付」(Credit)
  static double calculatePersonalCredit(RecordModel record, String uid) {
    // 1. 收入 (Income/預收)
    // S15 邏輯：Income 的 payerId 為 null，"入金者" 存在 splitMemberIds/splitDetails 中
    if (record.type == 'income') {
      double myCredit = 0.0;

      // 優先讀取詳細金額 (權重/精確模式)
      if (record.splitDetails != null &&
          record.splitDetails!.containsKey(uid)) {
        myCredit += (record.splitDetails![uid] as num).toDouble();
      }
      // 否則使用平均分攤 (Even)
      else if (record.splitMemberIds.contains(uid)) {
        myCredit += record.amount / record.splitMemberIds.length;
      }
      return myCredit;
    }

    // 2. 支出 (Expense)
    if (record.payerType == 'member') {
      // 單人代墊
      return (record.payerId == uid) ? record.amount : 0.0;
    } else if (record.payerType == 'mixed') {
      // 混合支付
      if (record.paymentDetails != null &&
          record.paymentDetails!['memberAdvance'] is Map) {
        final advances = record.paymentDetails!['memberAdvance'] as Map;
        if (advances.containsKey(uid)) {
          return (advances[uid] as num).toDouble();
        }
      }
    }
    // payerType == 'prepay' (公款支付)，沒人獲得 Credit
    return 0.0;
  }

  // 計算「消費/分攤」(Debit)
  static double _calculateDebit(RecordModel record, String uid) {
    if (record.type == 'income') return 0.0;

    double myDebit = 0.0;
    double amountCoveredByItems = 0.0;

    // 1. 先算細項 (Items)
    if (record.items.isNotEmpty) {
      for (var item in record.items) {
        amountCoveredByItems += item.amount; // 累加細項總額

        if (item.splitMemberIds.contains(uid)) {
          if (item.splitDetails != null &&
              item.splitDetails!.containsKey(uid)) {
            myDebit += (item.splitDetails![uid] as num).toDouble();
          } else {
            myDebit += (item.amount / item.splitMemberIds.length);
          }
        }
      }
    }

    // 2. 再算剩餘金額 (Base Amount)
    // 混合模式：總金額 4000，細項 500，剩 3500 也要分攤
    double remainingBase = record.amount - amountCoveredByItems;

    // 浮點數誤差容許值
    if (remainingBase > 0.001) {
      if (record.splitDetails != null &&
          record.splitDetails!.containsKey(uid)) {
        // 詳細分攤 (Percent/Exact)
        final double myWeight =
            (record.splitDetails![uid] as num? ?? 0.0).toDouble();
        // Calculate total weights of all members in this split
        final double totalWeights = record.splitDetails!.values
            .fold(0.0, (sum, w) => sum + (w as num).toDouble());

        if (totalWeights > 0) {
          myDebit += remainingBase * (myWeight / totalWeights);
        }
      } else if (record.splitMemberIds.contains(uid)) {
        // 平均分攤 (Even)
        myDebit += (remainingBase / record.splitMemberIds.length);
      }
    }

    return myDebit;
  }

  /// [修正] 計算公款池餘額 (Prepay Balance)
  /// 只計算 Income (入金) 和 PayerType 為 Prepay (公款支出) 的差額
  static double calculatePrepayBalance(List<RecordModel> records) {
    double totalPool = 0.0;
    for (var r in records) {
      if (r.type == 'income') {
        totalPool += r.amount;
      } else if (r.type == 'expense') {
        if (r.payerType == 'prepay') {
          totalPool -= r.amount;
        }
        // 混合支付中，若有使用公款 (paymentDetails['usePrepay'] == true)，
        // 且 paymentDetails['prepayAmount'] 有值，也應扣除。
        // MVP 簡化版：若 payerType == 'mixed' 且 paymentDetails 包含 'prepayAmount'
        else if (r.payerType == 'mixed' && r.paymentDetails != null) {
          final pAmount = r.paymentDetails!['prepayAmount'];
          if (pAmount is num) {
            totalPool -= pAmount.toDouble();
          }
        }
      }
    }
    return totalPool;
  }

  /// [新增] 計算零頭罐 (Remainder Buffer)
  /// 邏輯：總金額 (Base Total) - 所有成員分攤總和 (Sum of Member Shares)
  static double calculateRemainderBuffer(List<RecordModel> records) {
    double totalBuffer = 0.0;

    for (var r in records) {
      // 只計算支出 (Income 通常是整數入帳，若有匯率差也可在此擴充)
      if (r.type != 'expense') continue;

      // 1. 錨定總額 (Anchor Total in Base Currency)
      // 根據 Bible: BaseTotal = Round(Amount * Rate)
      // 這裡使用浮點數計算，呈現實際的差額
      final double baseTotal = r.amount * r.exchangeRate;

      // 2. 計算已分攤總額 (Allocated Total)
      double allocatedTotal = 0.0;

      // A. 優先計算細項 (Items)
      if (r.items.isNotEmpty) {
        for (var item in r.items) {
          // 計算該 item 的總額 (換算後)
          // 注意：item.amount 通常是原幣，需乘上 r.exchangeRate
          double itemBaseTotal = item.amount * r.exchangeRate;

          // 計算該 item 實際分出去多少
          if (item.splitDetails != null && item.splitDetails!.isNotEmpty) {
            // 如果有詳細分攤表，直接加總 value
            // (假設 splitDetails 存的是 Base Currency)
            for (var val in item.splitDetails!.values) {
              allocatedTotal += val;
            }
          } else if (item.splitMemberIds.isNotEmpty) {
            // 平均分攤：(Floor(Total / N) * N) 或是單純除法
            // 為了算出零頭，我們模擬平均分攤後的加總
            // 假設系統是無條件捨去小數點 (Floor)，則零頭會變大
            // 這裡先用精確除法後的加總 (若是除不盡，double 會有微小誤差)
            // 若要符合 Bible 的 Floor 邏輯：
            // double perPerson = (itemBaseTotal / item.splitMemberIds.length).floorToDouble(); // 或保留2位
            // allocatedTotal += perPerson * item.splitMemberIds.length;

            // 為了相容現有資料，先用標準除法
            allocatedTotal += itemBaseTotal;
          }
        }
      }
      // B. 計算簡易分攤 (Simple Split)
      else {
        if (r.splitDetails != null && r.splitDetails!.isNotEmpty) {
          for (var val in r.splitDetails!.values) {
            allocatedTotal += val;
          }
        } else if (r.splitMemberIds.isNotEmpty) {
          // 平均分攤：假設全部分完
          // 若您希望顯示「除不盡的零頭」，這裡可以實作 Floor 邏輯
          allocatedTotal += baseTotal;
        }
      }

      // 3. 差額歸入零頭罐
      // 正常情況下，baseTotal 應該 >= allocatedTotal
      // 剩餘的 (baseTotal - allocatedTotal) 就是零頭
      // 若使用精確分攤 (Exact)，可能會剛好為 0
      double remainder = baseTotal - allocatedTotal;

      // 忽略極小的浮點數誤差
      if (remainder.abs() > 0.001) {
        totalBuffer += remainder;
      }
    }

    return totalBuffer;
  }
}
