import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/services/currency_service.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_task_create_notice_dialog.dart';
import 'package:iron_split/features/task/presentation/bottom_sheets/b02_split_expense_edit_bottom_sheet.dart';
import 'package:iron_split/features/task/presentation/bottom_sheets/b07_payment_method_edit_bottom_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

// ==========================================
// 1. 資料模型
// ==========================================
class SplitItemModel {
  String id;
  double amount;
  String? note;
  String splitMethod;
  List<String> memberIds;

  SplitItemModel({
    required this.id,
    required this.amount,
    this.note,
    this.splitMethod = 'even',
    required this.memberIds,
  });
}

// ==========================================
// 2. 主頁面 Widget
// ==========================================
class S15RecordEditPage extends StatefulWidget {
  final String taskId;
  final String? recordId;
  final String baseCurrency;

  const S15RecordEditPage({
    super.key,
    required this.taskId,
    this.recordId,
    this.baseCurrency = 'TWD',
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
  int _selectedCategoryIndex = 0;
  bool _isRateLoading = false;
  bool _isSaving = false;
  bool _isLoadingTaskData = true;

  // Payment Method
  String _payerType = 'member';
  String _payerId = 'me';

  // Data from Firestore
  List<Map<String, dynamic>> _taskMembers = [];

  // Split Logic State
  List<SplitItemModel> _subItems = [];
  String _baseSplitMethod = 'even';
  List<String> _baseMemberIds = [];

  // Category Data
  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.restaurant, 'label': 'Food'},
    {'icon': Icons.directions_bus, 'label': 'Transport'},
    {'icon': Icons.hotel, 'label': 'Accommodation'},
    {'icon': Icons.shopping_bag, 'label': 'Shopping'},
    {'icon': Icons.local_activity, 'label': 'Activity'},
    {'icon': Icons.flight, 'label': 'Flight'},
    {'icon': Icons.local_grocery_store, 'label': 'Groceries'},
    {'icon': Icons.more_horiz, 'label': 'Others'},
  ];

  final List<String> _currencies =
      kSupportedCurrencies.map((c) => c.code).toList();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedCurrency = widget.baseCurrency;

    _loadCurrencyPreference();
    _fetchTaskData();

    _amountController.addListener(() => setState(() {}));
  }

  Future<void> _fetchTaskData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();

      if (docSnapshot.exists && mounted) {
        final data = docSnapshot.data()!;

        // 1. 解析真實成員 (處理 Map 與 List 兩種格式)
        List<Map<String, dynamic>> realMembers = [];
        if (data.containsKey('members')) {
          final dynamic rawMembers = data['members'];
          if (rawMembers is List) {
            realMembers =
                rawMembers.map((m) => m as Map<String, dynamic>).toList();
          } else if (rawMembers is Map) {
            // 如果是 Map，轉成 List 並確保 ID 存在
            realMembers = (rawMembers as Map<String, dynamic>).entries.map((e) {
              final memberData = e.value as Map<String, dynamic>;
              if (!memberData.containsKey('id')) {
                memberData['id'] = e.key;
              }
              return memberData;
            }).toList();
          }
        }

        // 2. 取得最大人數設定 (預設 1)
        final int maxMembers = data['maxMembers'] ?? 1;

        // 3. 自動補齊空位 (產生暫時的虛擬成員)
        if (realMembers.length < maxMembers) {
          final int missingCount = maxMembers - realMembers.length;
          for (int i = 0; i < missingCount; i++) {
            final int index = realMembers.length + 1;
            realMembers.add({
              'id': 'temp_member_${DateTime.now().millisecondsSinceEpoch}_$i',
              'name': '成員 $index',
              'avatar': null,
              'isLinked': false,
            });
          }
        }

        _taskMembers = realMembers;
      } else {
        debugPrint("⚠️ Document does not exist: tasks/${widget.taskId}");
      }

      // 4. 初始化分攤成員 (確保畫面更新)
      if (mounted) {
        setState(() {
          _baseMemberIds = _taskMembers.map((m) => m['id'] as String).toList();
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

  double get _totalAmount => double.tryParse(_amountController.text) ?? 0.0;

  double get _baseRemainingAmount {
    final subTotal = _subItems.fold(0.0, (sum, item) => sum + item.amount);
    final remaining = _totalAmount - subTotal;
    return remaining > 0 ? remaining : 0.0;
  }

  // --- Actions ---

  Future<void> _handleCardTap(
      {required bool isBase, SplitItemModel? subItem}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.S15_Record_Edit.msg_function_not_implemented)),
    );
  }

  Future<void> _handleCreateSubItem() async {
    if (_baseRemainingAmount <= 0) return;

    final memberIds = _taskMembers.map((m) => m['id'] as String).toList();

    await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => B02SplitExpenseEditBottomSheet(
        totalAmount: _baseRemainingAmount,
        splitMethod: 'even',
        initialDetails: {},
        memberIds: memberIds,
      ),
    );

    if (mounted) {
      _addMockSubItemForDemo();
    }
  }

  void _addMockSubItemForDemo() {
    final double splitAmount = 500;
    if (_baseRemainingAmount < splitAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.S15_Record_Edit.err_amount_not_enough)));
      return;
    }

    setState(() {
      _subItems.add(SplitItemModel(
        id: DateTime.now().toString(),
        amount: splitAmount,
        note: t.S15_Record_Edit.val_mock_note,
        splitMethod: 'even',
        memberIds: _taskMembers.map((m) => m['id'] as String).toList(),
      ));
    });
  }

  // --- Wheel Picker Logic ---
  void _showWheelBottomSheet({
    required Widget child,
    required VoidCallback onDone,
  }) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) => Container(
        height: 320,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(t.common.cancel,
                        style: const TextStyle(color: Colors.grey)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDone();
                    },
                    child: Text(
                      t.S16_TaskCreate_Edit.picker_done,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    String tempCurrency = _selectedCurrency;
    _showWheelBottomSheet(
      onDone: () {
        if (tempCurrency != _selectedCurrency) {
          _onCurrencyChanged(tempCurrency);
        }
      },
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController: FixedExtentScrollController(
            initialItem: _currencies.indexOf(_selectedCurrency)),
        onSelectedItemChanged: (index) => tempCurrency = _currencies[index],
        children: _currencies.map((code) {
          final option = kSupportedCurrencies.firstWhere((e) => e.code == code);
          return Center(child: Text("${option.code} - ${option.name}"));
        }).toList(),
      ),
    );
  }

  void _showCategoryPicker() {
    int tempIndex = _selectedCategoryIndex;
    _showWheelBottomSheet(
      onDone: () => setState(() => _selectedCategoryIndex = tempIndex),
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController:
            FixedExtentScrollController(initialItem: _selectedCategoryIndex),
        onSelectedItemChanged: (index) => tempIndex = index,
        children: _categories
            .map((c) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(c['icon'] as IconData, size: 20),
                    const SizedBox(width: 8),
                    Text(c['label'] as String),
                  ],
                ))
            .toList(),
      ),
    );
  }

  void _showDatePicker() {
    DateTime tempDate = _selectedDate;
    _showWheelBottomSheet(
      onDone: () => setState(() => _selectedDate = tempDate),
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

  Future<void> _handlePaymentMethod() async {
    if (_taskMembers.isEmpty) return;

    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => B07PaymentMethodEditBottomSheet(
        currentType: _payerType,
        currentId: _payerId == 'me' ? null : _payerId,
        members: _taskMembers,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _payerType = result['type']!;
        if (_payerType == 'member') {
          _payerId = result['id']!;
        }
      });
    }
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      // 注意：這裡只儲存了基本卡片資料，_subItems 需要另外處理或存入 splitDetails 結構
      final recordData = {
        'date': Timestamp.fromDate(_selectedDate),
        'title': _titleController.text,
        'categoryIndex': _selectedCategoryIndex,
        'payerType': _payerType,
        'payerId': _payerType == 'member' ? _payerId : null,
        'amount': double.parse(_amountController.text),
        'currency': _selectedCurrency,
        'exchangeRate': double.parse(_exchangeRateController.text),
        'splitMethod': _baseSplitMethod,
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

  Future<void> _handleClose() async {
    if (_titleController.text.isNotEmpty || _amountController.text.isNotEmpty) {
      final shouldLeave = await showDialog<bool>(
        context: context,
        builder: (context) => const D04TaskCreateNoticeDialog(),
      );
      if (shouldLeave != true) return;
    }
    if (mounted) context.pop();
  }

  // --- Helper Widgets ---

  Widget buildPickerField(
      {required String label,
      required String value,
      required IconData icon,
      required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(List<String> memberIds) {
    final activeMembers =
        _taskMembers.where((m) => memberIds.contains(m['id'])).toList();

    // 使用 Wrap 讓頭像自動換行，不堆疊，且限制寬度
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Wrap(
        alignment: WrapAlignment.end, // 靠右對齊
        spacing: 4, // 水平間距
        runSpacing: 4, // 垂直間距 (第二行)
        children: activeMembers.map((member) {
          final avatarId = member['avatar'];
          final name = member['name'] ?? '?';

          return _buildSingleAvatar(avatarId, name);
        }).toList(),
      ),
    );
  }

  Widget _buildSingleAvatar(dynamic avatarId, String name) {
    if (avatarId != null && avatarId.toString().isNotEmpty) {
      final String rawId = avatarId.toString();
      // ✅ 使用共用常數取得路徑 (會自動轉換 badger -> 19_badger)
      final String assetPath = AvatarConstants.getAssetPath(rawId);

      return CircleAvatar(
        radius: 11,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: AssetImage(assetPath),
        onBackgroundImageError: (_, __) {
          // 如果真的找不到圖，也不要崩潰
          debugPrint("❌ Failed to load avatar: $assetPath");
        },
      );
    } else {
      // 無圖片時顯示首字
      return CircleAvatar(
        radius: 11,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
              fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  Widget _buildExpenseCard({
    required double amount,
    required String methodLabel,
    required List<String> memberIds,
    String? note,
    required VoidCallback onTap,
    bool isBaseCard = false,
    bool showSplitAction = false, // ✅ 新增控制參數
    VoidCallback? onSplitTap, // ✅ 新增按鈕動作
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
          : colorScheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // 如果有分拆按鈕，底部不要圓角 (或者是讓按鈕包在裡面) -> 這裡選擇包在裡面
        side: isBaseCard
            ? BorderSide.none
            : BorderSide(color: colorScheme.outlineVariant),
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
                                ? Text(t.S15_Record_Edit.val_split_remaining,
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
                          child: _buildAvatarStack(memberIds),
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
                    Icon(Icons.call_split,
                        size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      t.S15_Record_Edit.val_split_details,
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

  String _getPayerDisplayName(String type, String id) {
    if (type == 'prepay') return t.S15_Record_Edit.val_prepay;

    final member = _taskMembers.firstWhere(
      (m) => m['id'] == id,
      orElse: () => {'name': '?'},
    );
    return t.S15_Record_Edit.val_member_paid(name: member['name']);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isForeign = _selectedCurrency != widget.baseCurrency;

    final currencyOption = kSupportedCurrencies.firstWhere(
        (e) => e.code == _selectedCurrency,
        orElse: () => kSupportedCurrencies.first);

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            buildPickerField(
              label: t.S15_Record_Edit.label_date,
              value: DateFormat('yyyy/MM/dd').format(_selectedDate),
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
                      _categories[_selectedCategoryIndex]['icon'],
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
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
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: t.S15_Record_Edit.label_rate(
                      base: widget.baseCurrency, target: _selectedCurrency),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.currency_exchange),
                    onPressed: _isRateLoading ? null : _fetchExchangeRate,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                  final rate =
                      double.tryParse(_exchangeRateController.text) ?? 0.0;
                  final converted = amount * rate;
                  final baseSymbol = kSupportedCurrencies
                      .firstWhere((e) => e.code == widget.baseCurrency,
                          orElse: () => kSupportedCurrencies.first)
                      .symbol;
                  final baseCode = widget.baseCurrency;
                  final formattedAmount =
                      NumberFormat("#,##0.##").format(converted);

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
            if (_subItems.isNotEmpty)
              ..._subItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildExpenseCard(
                      amount: item.amount,
                      methodLabel: item.splitMethod,
                      memberIds: item.memberIds,
                      note: item.note,
                      isBaseCard: false,
                      onTap: () => _handleCardTap(isBase: false, subItem: item),
                    ),
                  )),
            if (_baseRemainingAmount > 0 || _subItems.isEmpty)
              _buildExpenseCard(
                amount: _baseRemainingAmount,
                methodLabel: _baseSplitMethod,
                memberIds: _baseMemberIds,
                note: null,
                isBaseCard: true,
                onTap: () => _handleCardTap(isBase: true),
                // 只有基本卡片且有餘額時，顯示分拆按鈕
                showSplitAction: _baseRemainingAmount > 0,
                onSplitTap: _handleCreateSubItem,
              ),
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
        ),
      ),
    );
  }
}
