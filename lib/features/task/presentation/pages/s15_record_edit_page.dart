import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/core/services/currency_service.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/features/common/presentation/bottom_sheets/currency_picker_sheet.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_common_unsaved_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/d10_record_delete_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/features/common/presentation/widgets/common_wheel_picker.dart';
import 'package:iron_split/features/task/presentation/bottom_sheets/b02_split_expense_edit_bottom_sheet.dart';
import 'package:iron_split/features/task/presentation/bottom_sheets/b03_split_method_edit_bottom_sheet.dart';
import 'package:iron_split/features/task/presentation/bottom_sheets/b07_payment_method_edit_bottom_sheet.dart';
import 'package:iron_split/core/services/record_service.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/services/calculation_service.dart';

// ==========================================
// 2. 主頁面 Widget
// ==========================================
class S15RecordEditPage extends StatefulWidget {
  final String taskId;
  final String? recordId;
  final RecordModel? record;
  final String baseCurrency;
  final double prepayBalance; // NEW
  final DateTime? initialDate;

  const S15RecordEditPage({
    super.key,
    required this.taskId,
    this.recordId,
    this.record,
    this.baseCurrency = CurrencyOption.defaultCode,
    this.prepayBalance = 0.0, // NEW
    this.initialDate,
  });

  @override
  State<S15RecordEditPage> createState() => _S15RecordEditPageState();
}

class _S15RecordEditPageState extends State<S15RecordEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _amountController = TextEditingController();
  final _exchangeRateController = TextEditingController(text: '1.0');
  final _titleController = TextEditingController();
  final _memoController = TextEditingController();

  // State
  late DateTime _selectedDate;
  late String _selectedCurrency;
  String _selectedCategoryId = 'fastfood';
  bool _isRateLoading = false;
  bool _isSaving = false;
  bool _isLoadingTaskData = true;
  double _lastKnownAmount = 0.0;

  // 記錄類型切換 (0: 支出, 1: 預收
  int _recordTypeIndex = 0;

  // Payment Method
  String _payerType = 'prepay';
  String _payerId = '';

  // REMOVED: double _taskPrepayBalance = 0.0;
  Map<String, dynamic>? _complexPaymentData; // 儲存 B07 回傳的混合支付資料

  // Data from Firestore
  List<Map<String, dynamic>> _taskMembers = [];

  // Split Logic State
  final List<RecordItem> _items = [];
  String _baseSplitMethod = 'even';
  List<String> _baseMemberIds = [];

  // 儲存「剩餘金額卡片」的詳細分攤設定 (權重或金額)
  Map<String, double> _baseRawDetails = {};

  final List<String> _currencies =
      kSupportedCurrencies.map((c) => c.code).toList();

  bool _isCurrencyInitialized = false;

  @override
  void initState() {
    super.initState();

    // 1. 基本數據初始化
    if (widget.record != null) {
      // === 編輯模式 (以既有紀錄內容為主) ===
      final r = widget.record!;
      _recordTypeIndex = r.type == 'income' ? 1 : 0;
      _amountController.text = r.amount.truncateToDouble() == r.amount
          ? r.amount.toInt().toString()
          : r.amount.toString();
      _selectedDate = r.date;
      _selectedCurrency = r.currency; // 編輯模式直接鎖定紀錄幣別
      _exchangeRateController.text = r.exchangeRate.toString();

      if (r.type == 'expense') {
        _titleController.text = r.title;
        _selectedCategoryId = r.categoryId;
      }
      _memoController.text = r.memo ?? '';
      _payerType = r.payerType;
      _payerId = r.payerId ?? '';
      _complexPaymentData = r.paymentDetails;
      _baseSplitMethod = r.splitMethod;
      _baseMemberIds = List.from(r.splitMemberIds);
      _baseRawDetails = Map.from(r.splitDetails ?? {});
      _items.addAll(r.items);
    } else {
      // === 新建模式 ===
      _selectedDate = widget.initialDate ?? DateTime.now();
      // 這裡先給一個安全值，真正的偵測放在 didChangeDependencies
      _selectedCurrency = widget.baseCurrency;
      _loadCurrencyPreference();
    }

    _lastKnownAmount = double.tryParse(_amountController.text) ?? 0.0;
    _fetchTaskData();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 只有在「新建模式」且「尚未初始化過幣別」時才執行
    if (widget.record == null && !_isCurrencyInitialized) {
      _isCurrencyInitialized = true;

      // 現在呼叫 localeOf(context) 是安全的
      final String suggestedCurrency =
          CurrencyOption.detectSystemCurrency(context);

      setState(() {
        // 邏輯：有偵測到就用偵測的，否則用任務預設的 (widget.baseCurrency)
        _selectedCurrency = suggestedCurrency != CurrencyOption.defaultCode
            ? suggestedCurrency
            : widget.baseCurrency;
      });
    }
  }

  Future<void> _fetchTaskData() async {
    try {
      if (mounted) setState(() => _isLoadingTaskData = true);

      final docSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();

      if (docSnapshot.exists && mounted) {
        final data = docSnapshot.data()!;

        // 1. Parse Members from Firestore (Handle Map or List)
        List<Map<String, dynamic>> realMembers = [];
        if (data.containsKey('members')) {
          final dynamic rawMembers = data['members'];
          if (rawMembers is List) {
            realMembers =
                rawMembers.map((m) => m as Map<String, dynamic>).toList();
          } else if (rawMembers is Map) {
            realMembers = (rawMembers as Map<String, dynamic>).entries.map((e) {
              final memberData = e.value as Map<String, dynamic>;
              if (!memberData.containsKey('id')) {
                memberData['id'] = e.key;
              }
              // Fallback name if missing
              if (memberData['name'] == null) {
                memberData['name'] = memberData['displayName'] ?? 'Member';
              }
              return memberData;
            }).toList();
          }
        }

        // 2. Sort Members: Captain -> Linked -> Ghosts (by ID)
        realMembers.sort((a, b) {
          // Rule 1: Captain first
          final bool aIsCaptain = a['role'] == 'captain';
          final bool bIsCaptain = b['role'] == 'captain';
          if (aIsCaptain && !bIsCaptain) return -1;
          if (!aIsCaptain && bIsCaptain) return 1;

          // Rule 2: Linked Users before Ghosts
          final bool aLinked = a['isLinked'] ?? false;
          final bool bLinked = b['isLinked'] ?? false;
          if (aLinked && !bLinked) return -1;
          if (!aLinked && bLinked) return 1;

          // Rule 3: Stable Sort by ID for Ghosts (virtual_member_1 vs 2)
          final String idA = a['id'] as String? ?? '';
          final String idB = b['id'] as String? ?? '';
          return idA.compareTo(idB);
        });

        // 3. Assign to State (No more fake generation!)
        _taskMembers = realMembers;
      } else {
        debugPrint("⚠️ Document does not exist: tasks/${widget.taskId}");
      }

      // 4. Init Split Members (Only Reset in Create Mode)
      if (mounted) {
        setState(() {
          if (widget.record == null) {
            _baseMemberIds =
                _taskMembers.map((m) => m['id'] as String).toList();
          }
        });
      }
    } catch (e) {
      debugPrint("❌ Error fetching task data: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoadingTaskData = false);
      }
    }
  }

  Future<void> _loadCurrencyPreference() async {
    final lastCurrency = await PreferencesService.getLastCurrency();
    if (lastCurrency != null && _currencies.contains(lastCurrency)) {
      setState(() {
        _selectedCurrency = lastCurrency;
      });
      if (_selectedCurrency != widget.baseCurrency) {
        _onCurrencyChanged(_selectedCurrency);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _exchangeRateController.dispose();
    _titleController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    final currentAmount = double.tryParse(_amountController.text) ?? 0.0;
    if ((currentAmount - _lastKnownAmount).abs() > 0.001) {
      setState(() {
        _lastKnownAmount = currentAmount;
        // RESET LOGIC
        if (_items.isNotEmpty || _baseSplitMethod != 'even') {
          _items.clear();
          _baseSplitMethod = 'even';
          if (_taskMembers.isNotEmpty) {
            _baseMemberIds =
                _taskMembers.map((m) => m['id'] as String).toList();
          }
          _baseRawDetails.clear();
        }
      });
    } else {
      setState(() {});
    }
  }

  double get _totalAmount => double.tryParse(_amountController.text) ?? 0.0;

  bool get _hasPaymentError {
    return _payerType == 'prepay' &&
        widget.prepayBalance <= 0; // Use widget.prepayBalance
  }

  double get _baseRemainingAmount {
    final subTotal = _items.fold(0.0, (prev, curr) => prev + curr.amount);
    final remaining = _totalAmount - subTotal;
    return remaining > 0 ? remaining : 0.0;
  }

  // --- Actions ---

  // 1. Base Card Action: Configure Split Method (B03)
  Future<void> _handleBaseSplitConfig() async {
    final amountToSplit =
        _recordTypeIndex == 1 ? _totalAmount : _baseRemainingAmount;

    final Map<String, double> defaultWeights = {
      for (var m in _taskMembers) m['id']: 1.0
    };

    final currencySymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == _selectedCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    final rate = double.tryParse(_exchangeRateController.text) ?? 1.0;
    final baseSymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == widget.baseCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => B03SplitMethodEditBottomSheet(
        totalAmount: amountToSplit,
        currencySymbol: currencySymbol,
        allMembers: _taskMembers,
        defaultMemberWeights: defaultWeights,
        initialSplitMethod: _baseSplitMethod,
        initialMemberIds: _baseMemberIds,
        initialDetails: _baseRawDetails,
        exchangeRate: rate,
        baseCurrencySymbol: baseSymbol,
        baseCurrencyCode: widget.baseCurrency,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _baseSplitMethod = result['splitMethod'];
        _baseMemberIds = List<String>.from(result['memberIds']);
        _baseRawDetails = Map<String, double>.from(result['details']);
      });
    }
  }

  // 2. Add Item Action: Open B02
  Future<void> _handleCreateSubItem() async {
    if (_baseRemainingAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.S15_Record_Edit.err_amount_not_enough)));
      return;
    }

    final Map<String, double> defaultWeights = {
      for (var m in _taskMembers) m['id']: 1.0
    };

    final currencySymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == _selectedCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    final rate = double.tryParse(_exchangeRateController.text) ?? 1.0;
    final baseSymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == widget.baseCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    final result = await showModalBottomSheet<RecordItem>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => B02SplitExpenseEditBottomSheet(
        item: null,
        allMembers: _taskMembers,
        defaultWeights: defaultWeights,
        currencySymbol: currencySymbol,
        parentTitle: _titleController.text,
        availableAmount: _baseRemainingAmount,
        exchangeRate: rate,
        baseCurrencySymbol: baseSymbol,
        baseCurrencyCode: widget.baseCurrency,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _items.add(result);
      });
    }
  }

  // 3. Edit Item Action: Open B02
  Future<void> _handleItemEdit(RecordItem item) async {
    final Map<String, double> defaultWeights = {
      for (var m in _taskMembers) m['id']: 1.0
    };

    final currencySymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == _selectedCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    final rate = double.tryParse(_exchangeRateController.text) ?? 1.0;
    final baseSymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == widget.baseCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    final result = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => B02SplitExpenseEditBottomSheet(
        item: item,
        allMembers: _taskMembers,
        defaultWeights: defaultWeights,
        currencySymbol: currencySymbol,
        parentTitle: _titleController.text,
        availableAmount: _baseRemainingAmount + item.amount,
        exchangeRate: rate,
        baseCurrencySymbol: baseSymbol,
        baseCurrencyCode: widget.baseCurrency,
      ),
    );

    if (result == 'DELETE' && mounted) {
      setState(() {
        _items.removeWhere((element) => element.id == item.id);
      });
    } else if (result is RecordItem && mounted) {
      setState(() {
        final index = _items.indexWhere((element) => element.id == item.id);
        if (index != -1) {
          _items[index] = result;
        }
      });
    }
  }

  void _showCurrencyPicker() {
    CurrencyPickerSheet.show(
      context: context,
      initialCode: _selectedCurrency,
      onSelected: (currency) async {
        if (currency.code != _selectedCurrency) {
          await _onCurrencyChanged(currency.code);
        }
      },
    );
  }

  String _getCategoryLabel(String key) {
    switch (key) {
      case 't.category.food':
        return t.category.food;
      case 't.category.transport':
        return t.category.transport;
      case 't.category.shopping':
        return t.category.shopping;
      case 't.category.entertainment':
        return t.category.entertainment;
      case 't.category.accommodation':
        return t.category.accommodation;
      case 't.category.others':
        return t.category.others;
      default:
        return t.category.others;
    }
  }

  void _showCategoryPicker() {
    final int initialIndex = kAppCategories
        .indexWhere((c) => c.id == _selectedCategoryId)
        .clamp(0, kAppCategories.length - 1);
    int tempIndex = initialIndex;

    showCommonWheelPicker(
      context: context,
      onConfirm: () =>
          setState(() => _selectedCategoryId = kAppCategories[tempIndex].id),
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController:
            FixedExtentScrollController(initialItem: initialIndex),
        onSelectedItemChanged: (index) => tempIndex = index,
        children: kAppCategories
            .map((c) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(c.icon, size: 20),
                    const SizedBox(width: 8),
                    Text(_getCategoryLabel(c.labelKey)),
                  ],
                ))
            .toList(),
      ),
    );
  }

  void _showDatePicker() {
    DateTime tempDate = _selectedDate;
    showCommonWheelPicker(
      context: context,
      onConfirm: () => setState(() => _selectedDate = tempDate),
      child: CupertinoDatePicker(
        initialDateTime: _selectedDate,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) => tempDate = val,
      ),
    );
  }

  Future<void> _onCurrencyChanged(String newCurrency) async {
    setState(() => _selectedCurrency = newCurrency);
    await PreferencesService.saveLastCurrency(newCurrency);
    await _fetchExchangeRate();
  }

  Future<void> _fetchExchangeRate() async {
    if (_selectedCurrency == widget.baseCurrency) {
      _exchangeRateController.text = '1.0';
      return;
    }

    setState(() => _isRateLoading = true);
    final rate = await CurrencyService.fetchRate(
        from: _selectedCurrency, to: widget.baseCurrency);

    if (mounted) {
      setState(() {
        _isRateLoading = false;
        if (rate != null) {
          _exchangeRateController.text = rate.toString();
        }
      });
    }
  }

  void _showRateInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.S15_Record_Edit.info_rate_source),
        content: Text(t.S15_Record_Edit.msg_rate_source),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.S15_Record_Edit.btn_close),
          ),
        ],
      ),
    );
  }

  // 呼叫 B07 並處理回傳
  Future<void> _handlePaymentMethod() async {
    if (_taskMembers.isEmpty) return;

    // 防呆：必須先有金額才能開 B07
    final totalAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (totalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(t.S15_Record_Edit.err_input_amount)), // 建議補上 i18n
      );
      return;
    }

    final currencySymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == _selectedCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => B07PaymentMethodEditBottomSheet(
        totalAmount: totalAmount,
        prepayBalance: widget.prepayBalance, // Use widget.prepayBalance
        members: _taskMembers,
        currencySymbol: currencySymbol,
        // 傳入當前狀態 (若有複雜資料優先用，否則用簡易狀態推導)
        initialUsePrepay:
            _complexPaymentData?['usePrepay'] ?? (_payerType == 'prepay'),
        initialPrepayAmount: _complexPaymentData?['prepayAmount'] ??
            (_payerType == 'prepay' ? totalAmount : 0.0),
        initialMemberAdvance: _complexPaymentData?['memberAdvance'] != null
            ? Map<String, double>.from(_complexPaymentData!['memberAdvance'])
            : (_payerType == 'member' ? {_payerId: totalAmount} : {}),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        // 1. 儲存複雜資料
        _complexPaymentData = result;

        // 2. 更新 S15 顯示邏輯
        final bool usePrepay = result['usePrepay'];
        final bool useAdvance = result['useAdvance'];
        final Map<String, double> advances = result['memberAdvance'];

        if (usePrepay && !useAdvance) {
          _payerType = 'prepay';
        } else if (!usePrepay && useAdvance) {
          _payerType = 'member';
          final payers = advances.entries.where((e) => e.value > 0).toList();
          if (payers.length == 1) {
            _payerId = payers.first.key;
          } else {
            _payerId = 'multiple'; // 標記為多人代墊
          }
        } else {
          _payerType = 'mixed'; // 標記為混合支付
        }
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    // 額外檢查：如果顯示紅框 (預收餘額不足)，禁止儲存 (僅限支出模式)
    if (_recordTypeIndex == 0 && _hasPaymentError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(t.B07_PaymentMethod_Edit.err_balance_not_enough)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final isIncome = _recordTypeIndex == 1;

      final recordData = {
        'date': Timestamp.fromDate(_selectedDate),
        'title': isIncome
            ? t.S15_Record_Edit.type_income_title
            : _titleController.text,
        'type': isIncome ? 'income' : 'expense',
        'categoryIndex': kAppCategories
            .indexWhere((c) => c.id == _selectedCategoryId), // Legacy support
        'categoryId': _selectedCategoryId,
        'payerType': isIncome ? 'none' : _payerType,
        'payerId': (!isIncome && _payerType == 'member') ? _payerId : null,
        'paymentDetails': isIncome ? null : _complexPaymentData,
        'amount': double.parse(_amountController.text),
        'currency': _selectedCurrency,
        'exchangeRate': double.parse(_exchangeRateController.text),
        'splitMethod': _baseSplitMethod,
        'splitMemberIds': _baseMemberIds,
        'splitDetails': _baseRawDetails,
        'items': isIncome ? [] : _items.map((x) => x.toMap()).toList(),
        'memo': _memoController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': uid,
      };

      final recordsRef = FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .collection('records');

      if (widget.recordId == null) {
        await recordsRef.add(recordData);
      } else {
        await recordsRef.doc(widget.recordId).update(recordData);
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  bool _hasUnsavedChanges() {
    // 1. Create Mode
    if (widget.record == null) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      // For Income, title is not input, so only check amount
      if (_recordTypeIndex == 1) return amount > 0;
      return amount > 0 || _titleController.text.trim().isNotEmpty;
    }

    // 2. Edit Mode
    final r = widget.record!;

    // Check Type Change
    final currentType = _recordTypeIndex == 0 ? 'expense' : 'income';
    if (currentType != r.type) return true;

    // --- Common Fields (Checked for BOTH) ---
    final currentAmount = double.tryParse(_amountController.text) ?? 0.0;
    if ((currentAmount - r.amount).abs() > 0.001) return true;

    if (!_isSameDay(_selectedDate, r.date)) return true;
    if (_selectedCurrency != r.currency) return true;

    final currentRate = double.tryParse(_exchangeRateController.text) ?? 1.0;
    if ((currentRate - (r.exchangeRate)).abs() > 0.000001) return true;

    if (_memoController.text != (r.memo ?? '')) return true;

    // Split Logic (Income ALSO has split members)
    if (_baseSplitMethod != r.splitMethod) return true;
    if (!listEquals(_baseMemberIds, r.splitMemberIds)) return true;
    // Optional: Deep compare splitDetails if needed
    // if (!mapEquals(_baseRawDetails, r.splitDetails)) return true;

    // --- Mode Specific Checks ---
    if (_recordTypeIndex == 0) {
      // [Expense Only]
      if (_titleController.text != r.title) return true;
      if (_selectedCategoryId != r.categoryId) return true;

      // Payer
      if (_payerType != r.payerType) return true;
      if (_payerId != (r.payerId ?? '')) return true;

      // Items (Sub-items)
      if (_items.length != r.items.length) return true;
      for (int i = 0; i < _items.length; i++) {
        if (!_isItemEqual(_items[i], r.items[i])) return true;
      }
    } else {
      // [Income Only]
      // Skip Title (auto-generated)
      // Skip Category (hidden)
      // Skip Payer (always none)
      // Skip Items (always empty)
    }

    return false;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isItemEqual(RecordItem a, RecordItem b) {
    if (a.id != b.id)
      return false; // Usually ID matches if editing same item, but here comparing by index
    if (a.name != b.name) return false;
    if (a.amount != b.amount) return false;
    if (a.splitMethod != b.splitMethod) return false;
    if (!listEquals(a.splitMemberIds, b.splitMemberIds)) return false;
    // Note: splitDetails comparison if needed, but usually derived from method/ids or manual
    return true;
  }

  Future<void> _handleClose() async {
    if (!_hasUnsavedChanges()) {
      if (mounted) context.pop();
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => const D04CommonUnsavedConfirmDialog(),
    );

    if (shouldDiscard == true && mounted) {
      context.pop();
    }
  }

  Future<void> _handleDelete() async {
    final currencySymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == _selectedCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final amountText =
        "$currencySymbol ${NumberFormat("#,##0.##").format(amount)}";

    await showDialog(
      context: context,
      builder: (context) => D10RecordDeleteConfirmDialog(
        title: _titleController.text,
        amount: amountText,
        onConfirm: () async {
          try {
            await RecordService.deleteRecord(widget.taskId, widget.recordId!);
            if (mounted) {
              context.pop(); // Close S15
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(t.D10_RecordDelete_Confirm.deleted_success)),
              );
            }
          } catch (e) {
            debugPrint("Delete failed: $e");
          }
        },
      ),
    );
  }

  // --- Helper Widgets ---

  Widget buildPickerField(
      {required String label,
      required String value,
      required IconData icon,
      required VoidCallback onTap,
      bool isError = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              Icon(icon, color: isError ? colorScheme.error : null), // Icon 變色
          // 邊框變色邏輯
          enabledBorder: isError
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.error),
                )
              : OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: isError
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.error, width: 2),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: isError ? colorScheme.error : null // 文字變色
                        ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCard({
    required double amount,
    required String methodLabel,
    required List<String> memberIds,
    String? note,
    required VoidCallback onTap,
    bool isBaseCard = false,
    bool showSplitAction = false,
    VoidCallback? onSplitTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currencySymbol = kSupportedCurrencies
        .firstWhere((e) => e.code == _selectedCurrency,
            orElse: () => kSupportedCurrencies.first)
        .symbol;

    if (_isLoadingTaskData) {
      return const SizedBox(
          height: 100, child: Center(child: CircularProgressIndicator()));
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      // 稍微加深底色，讓卡片更明顯
      color: isBaseCard
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),
      child: Column(
        children: [
          // 上半部：可點擊的資訊區
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$currencySymbol ${NumberFormat("#,##0.##").format(amount)}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800, // 加粗
                          color: colorScheme.onSurface, // 深黑色
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary, // 改用實心主色
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getSplitMethodLabel(methodLabel),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary, // 白字
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end, // 底部對齊
                    children: [
                      // 左邊：說明文字 (給予彈性空間，但保留右邊給頭像)
                      Expanded(
                        flex: 4, // 左邊佔 40%
                        child: note != null
                            ? Text(
                                note,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2, // 允許換行
                                overflow: TextOverflow.ellipsis,
                              )
                            : (isBaseCard
                                ? Text(t.S15_Record_Edit.base_card_title,
                                    style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500))
                                : const SizedBox.shrink()),
                      ),
                      const SizedBox(width: 8),
                      // 右邊：頭像區 (給予更多空間顯示兩行)
                      Expanded(
                        flex: 6, // 右邊佔 60%
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CommonAvatarStack(
                            allMembers: _taskMembers,
                            targetMemberIds: memberIds,
                            radius: 11,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 下半部：分拆按鈕 (黏在卡片底部)
          if (showSplitAction && onSplitTap != null) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            InkWell(
              onTap: onSplitTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      t.S15_Record_Edit.add_item,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getSplitMethodLabel(String method) {
    switch (method) {
      case 'even':
        return t.S15_Record_Edit.method_even;
      case 'exact':
        return t.S15_Record_Edit.method_exact;
      case 'percent':
        return t.S15_Record_Edit.method_percent;
      default:
        return method;
    }
  }

  // 支援多種支付型態顯示
  String _getPayerDisplayName(String type, String id) {
    if (type == 'prepay') {
      final balanceStr = NumberFormat("#,##0.##").format(widget.prepayBalance);
      return "${t.B07_PaymentMethod_Edit.type_prepay} ($balanceStr)";
    }
    if (type == 'mixed') {
      return t.B07_PaymentMethod_Edit.type_mixed;
    }
    if (id == 'multiple') {
      return t.B07_PaymentMethod_Edit.type_member;
    }

    final member = _taskMembers.firstWhere(
      (m) => m['id'] == id,
      orElse: () => {'name': '?'},
    );
    return t.S15_Record_Edit.val_member_paid(name: member['name']);
  }

  Widget _buildExpenseForm() {
    // 1. 複製這些變數進來 (因為原本 build 裡的變數這裡讀不到)
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isForeign = _selectedCurrency != widget.baseCurrency;
    final currencyOption = kSupportedCurrencies.firstWhere(
        (e) => e.code == _selectedCurrency,
        orElse: () => kSupportedCurrencies.first);

    // 2. 貼上你原本的 ListView
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildPickerField(
          label: t.S15_Record_Edit.label_date,
          value: DateFormat('yyyy/MM/dd (E)').format(_selectedDate),
          icon: Icons.calendar_today,
          onTap: _showDatePicker,
        ),
        const SizedBox(height: 16),
        buildPickerField(
          label: t.S15_Record_Edit.label_payment_method,
          value: _getPayerDisplayName(_payerType, _payerId),
          icon: _payerType == 'prepay'
              ? Icons.account_balance_wallet
              : Icons.person,
          onTap: _handlePaymentMethod,
          isError: _hasPaymentError,
        ),
        // 若有錯誤顯示紅字提示 (加在欄位下方)
        if (_hasPaymentError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              t.B07_PaymentMethod_Edit.err_balance_not_enough,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            InkWell(
              onTap: _showCategoryPicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CategoryConstant.getCategoryById(_selectedCategoryId).icon,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: t.S15_Record_Edit.label_title,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (v) => v?.isEmpty == true ? "Required" : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _showCurrencyPicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currencyOption.symbol,
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      currencyOption.code,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: t.S15_Record_Edit.label_amount,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (v) =>
                    (double.tryParse(v ?? '') ?? 0) <= 0 ? "Invalid" : null,
              ),
            ),
          ],
        ),
        if (isForeign) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _exchangeRateController,
            onChanged: (_) => setState(() {}),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: t.S15_Record_Edit.label_rate(
                  base: widget.baseCurrency, target: _selectedCurrency),
              prefixIcon: IconButton(
                icon: const Icon(Icons.currency_exchange),
                onPressed: _isRateLoading ? null : _fetchExchangeRate,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isRateLoading)
                    const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: _showRateInfoDialog,
                  ),
                ],
              ),
            ),
          ),
          Builder(
            builder: (context) {
              final amount = double.tryParse(_amountController.text) ?? 0.0;
              final rate = double.tryParse(_exchangeRateController.text) ?? 0.0;
              final converted = amount * rate;
              final baseSymbol = kSupportedCurrencies
                  .firstWhere((e) => e.code == widget.baseCurrency,
                      orElse: () => kSupportedCurrencies.first)
                  .symbol;
              final baseCode = widget.baseCurrency;
              final formattedAmount =
                  CurrencyOption.formatAmount(converted, baseCode);

              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  t.S15_Record_Edit.val_converted_amount(
                      base: baseCode,
                      symbol: baseSymbol,
                      amount: formattedAmount),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 12),
        if (_items.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              t.S15_Record_Edit.section_items,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ..._items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildExpenseCard(
                  amount: item.amount,
                  methodLabel: item.splitMethod,
                  memberIds: item.splitMemberIds,
                  note: item.name,
                  isBaseCard: false,
                  onTap: () => _handleItemEdit(item),
                ),
              )),
        ],
        if (_baseRemainingAmount > 0 || _items.isEmpty) ...[
          _buildExpenseCard(
            amount: _baseRemainingAmount,
            methodLabel: _baseSplitMethod,
            memberIds: _baseMemberIds,
            note: null,
            isBaseCard: true,
            onTap: () => _handleBaseSplitConfig(),
            // 只有基本卡片且有餘額時，顯示分拆按鈕
            showSplitAction: _baseRemainingAmount > 0,
            onSplitTap: _handleCreateSubItem,
          ),
          if (_baseSplitMethod == 'even' && _baseMemberIds.isNotEmpty)
            Builder(
              builder: (context) {
                final rate =
                    double.tryParse(_exchangeRateController.text) ?? 1.0;
                final baseTotal = CalculationService.calculateBaseTotal(
                    _baseRemainingAmount, rate);
                final split = CalculationService.calculateEvenSplit(
                    baseTotal, _baseMemberIds.length);
                if (split.remainder > 0) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      t.S13_Task_Dashboard.label_remainder(
                          amount:
                              "${widget.baseCurrency} ${CurrencyOption.formatAmount(split.remainder, widget.baseCurrency)}"),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                      textAlign: TextAlign.end,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
        const SizedBox(height: 16),
        TextFormField(
          controller: _memoController,
          keyboardType: TextInputType.multiline,
          // 1. 鎖定高度：最小與最大都是 2 行
          minLines: 2,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: t.S15_Record_Edit.label_memo,
            // 2. 讓 Label (提示文字) 在多行模式下也能靠左上
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // 3. 調整內距
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildIncomeForm() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isForeign = _selectedCurrency != widget.baseCurrency;
    final currencyOption = kSupportedCurrencies.firstWhere(
        (e) => e.code == _selectedCurrency,
        orElse: () => kSupportedCurrencies.first);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        buildPickerField(
          label: t.S15_Record_Edit.label_date,
          value: DateFormat('yyyy/MM/dd (E)').format(_selectedDate),
          icon: Icons.calendar_today,
          onTap: _showDatePicker,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _showCurrencyPicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currencyOption.symbol,
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      currencyOption.code,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: t.S15_Record_Edit.label_amount,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (v) =>
                    (double.tryParse(v ?? '') ?? 0) <= 0 ? "Invalid" : null,
              ),
            ),
          ],
        ),
        if (isForeign) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _exchangeRateController,
            onChanged: (_) => setState(() {}),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: t.S15_Record_Edit.label_rate(
                  base: widget.baseCurrency, target: _selectedCurrency),
              prefixIcon: IconButton(
                icon: const Icon(Icons.currency_exchange),
                onPressed: _isRateLoading ? null : _fetchExchangeRate,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isRateLoading)
                    const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: _showRateInfoDialog,
                  ),
                ],
              ),
            ),
          ),
          Builder(
            builder: (context) {
              final amount = double.tryParse(_amountController.text) ?? 0.0;
              final rate = double.tryParse(_exchangeRateController.text) ?? 0.0;
              final converted = amount * rate;
              final baseSymbol = kSupportedCurrencies
                  .firstWhere((e) => e.code == widget.baseCurrency,
                      orElse: () => kSupportedCurrencies.first)
                  .symbol;
              final baseCode = widget.baseCurrency;
              final formattedAmount =
                  CurrencyOption.formatAmount(converted, baseCode);

              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  t.S15_Record_Edit.val_converted_amount(
                      base: baseCode,
                      symbol: baseSymbol,
                      amount: formattedAmount),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 12),
        _buildExpenseCard(
          amount: _totalAmount,
          methodLabel: _baseSplitMethod,
          memberIds: _baseMemberIds,
          note: t.S15_Record_Edit.base_card_title_income,
          isBaseCard: true,
          onTap: () => _handleBaseSplitConfig(),
          showSplitAction: false,
          onSplitTap: null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _memoController,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: t.S15_Record_Edit.label_memo,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingTaskData) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recordId == null
            ? t.S15_Record_Edit.title_create
            : t.S15_Record_Edit.title_edit),
        leading:
            IconButton(icon: const Icon(Icons.close), onPressed: _handleClose),
        actions: [
          if (widget.recordId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.error,
              onPressed: _handleDelete,
            ),
          TextButton(
            onPressed: _isSaving ? null : _onSave,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(t.common.save,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Column(
        children: [
          // 1. 頂部切換開關
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                // 1. 定義選項 (使用 i18n 變數)
                segments: <ButtonSegment<int>>[
                  ButtonSegment<int>(
                    value: 0,
                    label: Text(t.S15_Record_Edit.tab_expense), // "支出"
                    icon: const Icon(Icons.receipt_long),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    label: Text(t.S15_Record_Edit.tab_income), // "預收"
                    icon: const Icon(Icons.savings_outlined),
                  ),
                ],
                // 2. 當前選中的項目
                selected: {_recordTypeIndex},

                // 3. 切換事件
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    _recordTypeIndex = newSelection.first;
                  });
                },

                showSelectedIcon: false, // 不顯示打勾圖示，保持簡潔
              ),
            ),
          ),

          // 2. 內容區：根據切換顯示不同表單
          Expanded(
            child: Form(
              key: _formKey, // Form Key 依然包在最外面，保護你的驗證邏輯
              child: _recordTypeIndex == 0
                  ? _buildExpenseForm()
                  : _buildIncomeForm(),
            ),
          ),
        ],
      ),
    );
  }
}
