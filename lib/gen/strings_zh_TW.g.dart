///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsZhTw = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.zhTw,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-TW>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonZhTw common = TranslationsCommonZhTw.internal(_root);
	late final TranslationsLogActionZhTw log_action = TranslationsLogActionZhTw.internal(_root);
	late final TranslationsDialogZhTw dialog = TranslationsDialogZhTw.internal(_root);
	late final TranslationsS10HomeTaskListZhTw S10_Home_TaskList = TranslationsS10HomeTaskListZhTw.internal(_root);
	late final TranslationsS11InviteConfirmZhTw S11_Invite_Confirm = TranslationsS11InviteConfirmZhTw.internal(_root);
	late final TranslationsS12TaskCloseNoticeZhTw S12_TaskClose_Notice = TranslationsS12TaskCloseNoticeZhTw.internal(_root);
	late final TranslationsS13TaskDashboardZhTw S13_Task_Dashboard = TranslationsS13TaskDashboardZhTw.internal(_root);
	late final TranslationsS14TaskSettingsZhTw S14_Task_Settings = TranslationsS14TaskSettingsZhTw.internal(_root);
	late final TranslationsS15RecordEditZhTw S15_Record_Edit = TranslationsS15RecordEditZhTw.internal(_root);
	late final TranslationsS16TaskCreateEditZhTw S16_TaskCreate_Edit = TranslationsS16TaskCreateEditZhTw.internal(_root);
	late final TranslationsS17TaskLockedZhTw S17_Task_Locked = TranslationsS17TaskLockedZhTw.internal(_root);
	late final TranslationsS30SettlementConfirmZhTw s30_settlement_confirm = TranslationsS30SettlementConfirmZhTw.internal(_root);
	late final TranslationsS31SettlementPaymentInfoZhTw s31_settlement_payment_info = TranslationsS31SettlementPaymentInfoZhTw.internal(_root);
	late final TranslationsS50OnboardingConsentZhTw S50_Onboarding_Consent = TranslationsS50OnboardingConsentZhTw.internal(_root);
	late final TranslationsS51OnboardingNameZhTw S51_Onboarding_Name = TranslationsS51OnboardingNameZhTw.internal(_root);
	late final TranslationsS52TaskSettingsLogZhTw S52_TaskSettings_Log = TranslationsS52TaskSettingsLogZhTw.internal(_root);
	late final TranslationsS53TaskSettingsMembersZhTw S53_TaskSettings_Members = TranslationsS53TaskSettingsMembersZhTw.internal(_root);
	late final TranslationsS71SystemSettingsTosZhTw S71_SystemSettings_Tos = TranslationsS71SystemSettingsTosZhTw.internal(_root);
	late final TranslationsD01MemberRoleIntroZhTw D01_MemberRole_Intro = TranslationsD01MemberRoleIntroZhTw.internal(_root);
	late final TranslationsD02InviteResultZhTw D02_Invite_Result = TranslationsD02InviteResultZhTw.internal(_root);
	late final TranslationsD03TaskCreateConfirmZhTw D03_TaskCreate_Confirm = TranslationsD03TaskCreateConfirmZhTw.internal(_root);
	late final TranslationsD05DateJumpNoResultZhTw D05_DateJump_NoResult = TranslationsD05DateJumpNoResultZhTw.internal(_root);
	late final TranslationsD08TaskClosedConfirmZhTw D08_TaskClosed_Confirm = TranslationsD08TaskClosedConfirmZhTw.internal(_root);
	late final TranslationsD09TaskSettingsCurrencyConfirmZhTw D09_TaskSettings_CurrencyConfirm = TranslationsD09TaskSettingsCurrencyConfirmZhTw.internal(_root);
	late final TranslationsD10RecordDeleteConfirmZhTw D10_RecordDelete_Confirm = TranslationsD10RecordDeleteConfirmZhTw.internal(_root);
	late final TranslationsB02SplitExpenseEditZhTw B02_SplitExpense_Edit = TranslationsB02SplitExpenseEditZhTw.internal(_root);
	late final TranslationsB03SplitMethodEditZhTw B03_SplitMethod_Edit = TranslationsB03SplitMethodEditZhTw.internal(_root);
	late final TranslationsB04PaymentMergeZhTw b04_payment_merge = TranslationsB04PaymentMergeZhTw.internal(_root);
	late final TranslationsB07PaymentMethodEditZhTw B07_PaymentMethod_Edit = TranslationsB07PaymentMethodEditZhTw.internal(_root);
	late final TranslationsErrorZhTw error = TranslationsErrorZhTw.internal(_root);
}

// Path: common
class TranslationsCommonZhTw {
	TranslationsCommonZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonButtonsZhTw buttons = TranslationsCommonButtonsZhTw.internal(_root);
	late final TranslationsCommonCategoryZhTw category = TranslationsCommonCategoryZhTw.internal(_root);
	late final TranslationsCommonCurrencyZhTw currency = TranslationsCommonCurrencyZhTw.internal(_root);
	late final TranslationsCommonRemainderRuleZhTw remainder_rule = TranslationsCommonRemainderRuleZhTw.internal(_root);
	late final TranslationsCommonPaymentInfoZhTw payment_info = TranslationsCommonPaymentInfoZhTw.internal(_root);

	/// zh-TW: '錯誤: {message}'
	String error_prefix({required Object message}) => '錯誤: ${message}';

	/// zh-TW: '請先登入'
	String get please_login => '請先登入';

	/// zh-TW: '讀取中...'
	String get loading => '讀取中...';

	/// zh-TW: '我'
	String get me => '我';

	/// zh-TW: '必填'
	String get required => '必填';

	/// zh-TW: '成員'
	String get member_prefix => '成員';

	/// zh-TW: '無紀錄'
	String get no_record => '無紀錄';

	/// zh-TW: '今天'
	String get today => '今天';

	/// zh-TW: '未命名'
	String get untitled => '未命名';
}

// Path: log_action
class TranslationsLogActionZhTw {
	TranslationsLogActionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '建立任務'
	String get create_task => '建立任務';

	/// zh-TW: '更新設定'
	String get update_settings => '更新設定';

	/// zh-TW: '新增成員'
	String get add_member => '新增成員';

	/// zh-TW: '移除成員'
	String get remove_member => '移除成員';

	/// zh-TW: '新增記帳'
	String get create_record => '新增記帳';

	/// zh-TW: '修改記帳'
	String get update_record => '修改記帳';

	/// zh-TW: '刪除記帳'
	String get delete_record => '刪除記帳';

	/// zh-TW: '執行結算'
	String get settle_up => '執行結算';

	/// zh-TW: '未知操作'
	String get unknown => '未知操作';

	/// zh-TW: '結束任務'
	String get close_task => '結束任務';
}

// Path: dialog
class TranslationsDialogZhTw {
	TranslationsDialogZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '尚未儲存'
	String get unsaved_changes_title => '尚未儲存';

	/// zh-TW: '變更將不會被儲存，確定要離開嗎？'
	String get unsaved_changes_content => '變更將不會被儲存，確定要離開嗎？';
}

// Path: S10_Home_TaskList
class TranslationsS10HomeTaskListZhTw {
	TranslationsS10HomeTaskListZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '我的任務'
	String get title => '我的任務';

	/// zh-TW: '進行中'
	String get tab_in_progress => '進行中';

	/// zh-TW: '已完成'
	String get tab_completed => '已完成';

	/// zh-TW: '鐵公雞準備中...'
	String get mascot_preparing => '鐵公雞準備中...';

	/// zh-TW: '目前沒有進行中的任務'
	String get empty_in_progress => '目前沒有進行中的任務';

	/// zh-TW: '沒有已完成的任務'
	String get empty_completed => '沒有已完成的任務';

	/// zh-TW: '日期未定'
	String get date_tbd => '日期未定';

	/// zh-TW: '確認刪除'
	String get delete_confirm_title => '確認刪除';

	/// zh-TW: '確定要刪除這個任務嗎？'
	String get delete_confirm_content => '確定要刪除這個任務嗎？';
}

// Path: S11_Invite_Confirm
class TranslationsS11InviteConfirmZhTw {
	TranslationsS11InviteConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '加入任務'
	String get title => '加入任務';

	/// zh-TW: '您受邀加入以下任務：'
	String get subtitle => '您受邀加入以下任務：';

	late final TranslationsS11InviteConfirmButtonsZhTw buttons = TranslationsS11InviteConfirmButtonsZhTw.internal(_root);

	/// zh-TW: '正在讀取邀請函...'
	String get loading_invite => '正在讀取邀請函...';

	/// zh-TW: '哎呀！無法加入任務'
	String get join_failed_title => '哎呀！無法加入任務';

	/// zh-TW: '請問您是以下成員嗎？'
	String get identity_match_title => '請問您是以下成員嗎？';

	/// zh-TW: '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。'
	String get identity_match_desc => '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。';

	/// zh-TW: '將以「連結帳號」方式加入'
	String get status_linking => '將以「連結帳號」方式加入';

	/// zh-TW: '將以「新成員」身分加入'
	String get status_new_member => '將以「新成員」身分加入';

	/// zh-TW: '加入失敗：{message}'
	String error_join_failed({required Object message}) => '加入失敗：${message}';

	/// zh-TW: '發生錯誤：{message}'
	String error_generic({required Object message}) => '發生錯誤：${message}';

	/// zh-TW: '選擇要繼承的成員'
	String get label_select_ghost => '選擇要繼承的成員';

	/// zh-TW: '已墊付'
	String get label_prepaid => '已墊付';

	/// zh-TW: '應分攤'
	String get label_expense => '應分攤';
}

// Path: S12_TaskClose_Notice
class TranslationsS12TaskCloseNoticeZhTw {
	TranslationsS12TaskCloseNoticeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結束任務確認'
	String get title => '結束任務確認';

	/// zh-TW: '關閉此任務後，所有紀錄與設定將被鎖定。系統將進入唯讀模式，您將無法新增或編輯任何資料。'
	String get content => '關閉此任務後，所有紀錄與設定將被鎖定。系統將進入唯讀模式，您將無法新增或編輯任何資料。';

	late final TranslationsS12TaskCloseNoticeButtonsZhTw buttons = TranslationsS12TaskCloseNoticeButtonsZhTw.internal(_root);
}

// Path: S13_Task_Dashboard
class TranslationsS13TaskDashboardZhTw {
	TranslationsS13TaskDashboardZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務主頁'
	String get title_active => '任務主頁';

	late final TranslationsS13TaskDashboardButtonsZhTw buttons = TranslationsS13TaskDashboardButtonsZhTw.internal(_root);

	/// zh-TW: '大家'
	String get tab_group => '大家';

	/// zh-TW: '個人'
	String get tab_personal => '個人';

	/// zh-TW: '公款餘額'
	String get label_prepay_balance => '公款餘額';

	/// zh-TW: '我的收支'
	String get label_my_balance => '我的收支';

	/// zh-TW: '暫存零頭: {amount}'
	String label_remainder({required Object amount}) => '暫存零頭: ${amount}';

	/// zh-TW: '結餘'
	String get label_balance => '結餘';

	/// zh-TW: '總費用'
	String get label_total_expense => '總費用';

	/// zh-TW: '總預收'
	String get label_total_prepay => '總預收';

	/// zh-TW: '零頭罐'
	String get label_remainder_pot => '零頭罐';

	/// zh-TW: '尚無收支紀錄'
	String get empty_records => '尚無收支紀錄';

	/// zh-TW: '準備前往記帳頁面...'
	String get nav_to_record => '準備前往記帳頁面...';

	/// zh-TW: '支出'
	String get daily_expense_label => '支出';

	/// zh-TW: '收支幣別明細'
	String get dialog_balance_detail => '收支幣別明細';

	/// zh-TW: '支出明細'
	String get section_expense => '支出明細';

	/// zh-TW: '預收明細'
	String get section_income => '預收明細';

	/// zh-TW: '本日支出'
	String get daily_stats_title => '本日支出';

	/// zh-TW: '個人本日支出'
	String get personal_daily_total => '個人本日支出';

	/// zh-TW: '應收'
	String get personal_to_receive => '應收';

	/// zh-TW: '應付'
	String get personal_to_pay => '應付';

	/// zh-TW: '這天沒有與你有關的紀錄'
	String get personal_empty_desc => '這天沒有與你有關的紀錄';

	/// zh-TW: '總金額'
	String get total_amount_label => '總金額';

	/// zh-TW: '此任務已關閉。資料將保留 30 天，請下載您的紀錄。'
	String get retention_notice => '此任務已關閉。資料將保留 30 天，請下載您的紀錄。';
}

// Path: S14_Task_Settings
class TranslationsS14TaskSettingsZhTw {
	TranslationsS14TaskSettingsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務設定'
	String get title => '任務設定';

	/// zh-TW: '成員設定'
	String get menu_member_settings => '成員設定';

	/// zh-TW: '歷史紀錄'
	String get menu_history => '歷史紀錄';

	/// zh-TW: '結束任務'
	String get menu_end_task => '結束任務';

	/// zh-TW: '剩餘款'
	String get section_remainder => '剩餘款';
}

// Path: S15_Record_Edit
class TranslationsS15RecordEditZhTw {
	TranslationsS15RecordEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '記一筆'
	String get title_create => '記一筆';

	/// zh-TW: '編輯紀錄'
	String get title_edit => '編輯紀錄';

	late final TranslationsS15RecordEditButtonsZhTw buttons = TranslationsS15RecordEditButtonsZhTw.internal(_root);

	/// zh-TW: '分攤資訊'
	String get section_split => '分攤資訊';

	/// zh-TW: '日期'
	String get label_date => '日期';

	/// zh-TW: '項目名稱'
	String get label_title => '項目名稱';

	/// zh-TW: '輸入消費項目 (如：晚餐)'
	String get hint_title => '輸入消費項目 (如：晚餐)';

	/// zh-TW: '支付方式'
	String get label_payment_method => '支付方式';

	/// zh-TW: '預收'
	String get val_prepay => '預收';

	/// zh-TW: '{name} 先付'
	String val_member_paid({required Object name}) => '${name} 先付';

	/// zh-TW: '金額'
	String get label_amount => '金額';

	/// zh-TW: '匯率 (1 {base} = ? {target})'
	String label_rate({required Object base, required Object target}) => '匯率 (1 ${base} = ? ${target})';

	/// zh-TW: '備註'
	String get label_memo => '備註';

	/// zh-TW: '輸入備註...'
	String get hint_memo => '輸入備註...';

	/// zh-TW: '細項分拆'
	String get val_split_details => '細項分拆';

	/// zh-TW: '總計 {amount} 由 {method} 分攤'
	String val_split_summary({required Object amount, required Object method}) => '總計 ${amount} 由 ${method} 分攤';

	/// zh-TW: '匯率來源'
	String get info_rate_source => '匯率來源';

	/// zh-TW: '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。'
	String get msg_rate_source => '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。';

	/// zh-TW: '≈ {base}{symbol} {amount}'
	String val_converted_amount({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}';

	/// zh-TW: '剩餘金額'
	String get val_split_remaining => '剩餘金額';

	/// zh-TW: '剩餘金額不足'
	String get err_amount_not_enough => '剩餘金額不足';

	/// zh-TW: '細項說明'
	String get val_mock_note => '細項說明';

	/// zh-TW: '支出'
	String get tab_expense => '支出';

	/// zh-TW: '預收'
	String get tab_income => '預收';

	/// zh-TW: '預收功能開發中...'
	String get msg_income_developing => '預收功能開發中...';

	/// zh-TW: '此功能尚未實作'
	String get msg_not_implemented => '此功能尚未實作';

	/// zh-TW: '請先輸入金額'
	String get err_input_amount => '請先輸入金額';

	/// zh-TW: '細項分拆'
	String get section_items => '細項分拆';

	/// zh-TW: '新增細項'
	String get add_item => '新增細項';

	/// zh-TW: '剩餘金額 (Base)'
	String get base_card_title => '剩餘金額 (Base)';

	/// zh-TW: '預收款'
	String get type_income_title => '預收款';

	/// zh-TW: '剩餘金額 (Base)'
	String get base_card_title_expense => '剩餘金額 (Base)';

	/// zh-TW: '資金來源 (入金者)'
	String get base_card_title_income => '資金來源 (入金者)';

	/// zh-TW: '多人'
	String get payer_multiple => '多人';
}

// Path: S16_TaskCreate_Edit
class TranslationsS16TaskCreateEditZhTw {
	TranslationsS16TaskCreateEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增任務'
	String get title => '新增任務';

	late final TranslationsS16TaskCreateEditButtonsZhTw buttons = TranslationsS16TaskCreateEditButtonsZhTw.internal(_root);

	/// zh-TW: '任務名稱'
	String get section_name => '任務名稱';

	/// zh-TW: '任務期間'
	String get section_period => '任務期間';

	/// zh-TW: '結算設定'
	String get section_settings => '結算設定';

	/// zh-TW: '例如：東京五日遊'
	String get field_name_hint => '例如：東京五日遊';

	/// zh-TW: '{current}/20'
	String field_name_counter({required Object current}) => '${current}/20';

	/// zh-TW: '開始日期'
	String get field_start_date => '開始日期';

	/// zh-TW: '結束日期'
	String get field_end_date => '結束日期';

	/// zh-TW: '結算幣別'
	String get field_currency => '結算幣別';

	/// zh-TW: '參加人數'
	String get field_member_count => '參加人數';

	/// zh-TW: '請輸入任務名稱'
	String get error_name_empty => '請輸入任務名稱';

	/// zh-TW: '任務名稱'
	String get label_name => '任務名稱';

	/// zh-TW: '日期'
	String get label_date => '日期';

	/// zh-TW: '貨幣'
	String get label_currency => '貨幣';
}

// Path: S17_Task_Locked
class TranslationsS17TaskLockedZhTw {
	TranslationsS17TaskLockedZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsS17TaskLockedButtonsZhTw buttons = TranslationsS17TaskLockedButtonsZhTw.internal(_root);

	/// zh-TW: '此任務已關閉。資料將保留 30 天，請下載您的紀錄。'
	String get retention_notice => '此任務已關閉。資料將保留 30 天，請下載您的紀錄。';

	/// zh-TW: '零錢罐 {amount} 由 {name} 吸收'
	String label_remainder_absorbed_by({required Object amount, required Object name}) => '零錢罐 ${amount} 由 ${name} 吸收';

	/// zh-TW: '待處理'
	String get section_pending => '待處理';

	/// zh-TW: '已處理'
	String get section_cleared => '已處理';

	/// zh-TW: '應付'
	String get member_payment_status_pay => '應付';

	/// zh-TW: '應收'
	String get member_payment_status_receive => '應收';

	/// zh-TW: '確認收款/付款'
	String get dialog_mark_cleared_title => '確認收款/付款';

	/// zh-TW: '確定將 {name} 標記為已處理？'
	String dialog_mark_cleared_content({required Object name}) => '確定將 ${name} 標記為已處理？';
}

// Path: s30_settlement_confirm
class TranslationsS30SettlementConfirmZhTw {
	TranslationsS30SettlementConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結算確認'
	String get title => '結算確認';

	late final TranslationsS30SettlementConfirmButtonsZhTw buttons = TranslationsS30SettlementConfirmButtonsZhTw.internal(_root);
	late final TranslationsS30SettlementConfirmStepsZhTw steps = TranslationsS30SettlementConfirmStepsZhTw.internal(_root);
	late final TranslationsS30SettlementConfirmWarningZhTw warning = TranslationsS30SettlementConfirmWarningZhTw.internal(_root);

	/// zh-TW: '應付'
	String get label_payable => '應付';

	/// zh-TW: '可退'
	String get label_refund => '可退';

	late final TranslationsS30SettlementConfirmListItemZhTw list_item = TranslationsS30SettlementConfirmListItemZhTw.internal(_root);
}

// Path: s31_settlement_payment_info
class TranslationsS31SettlementPaymentInfoZhTw {
	TranslationsS31SettlementPaymentInfoZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '收款資訊'
	String get title => '收款資訊';

	/// zh-TW: '收款資訊僅供本次結算使用。預設資料加密儲存於本機。'
	String get setup_instruction => '收款資訊僅供本次結算使用。預設資料加密儲存於本機。';

	/// zh-TW: '儲存為預設收款資訊 (存在手機)'
	String get sync_save => '儲存為預設收款資訊 (存在手機)';

	/// zh-TW: '同步更新我的預設收款資訊'
	String get sync_update => '同步更新我的預設收款資訊';

	late final TranslationsS31SettlementPaymentInfoButtonsZhTw buttons = TranslationsS31SettlementPaymentInfoButtonsZhTw.internal(_root);
}

// Path: S50_Onboarding_Consent
class TranslationsS50OnboardingConsentZhTw {
	TranslationsS50OnboardingConsentZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '歡迎使用 Iron Split'
	String get title => '歡迎使用 Iron Split';

	late final TranslationsS50OnboardingConsentButtonsZhTw buttons = TranslationsS50OnboardingConsentButtonsZhTw.internal(_root);

	/// zh-TW: '歡迎使用 Iron Split。點擊開始即代表您同意我們的 '
	String get content_prefix => '歡迎使用 Iron Split。點擊開始即代表您同意我們的 ';

	/// zh-TW: '服務條款'
	String get terms_link => '服務條款';

	/// zh-TW: ' 與 '
	String get and => ' 與 ';

	/// zh-TW: '隱私政策'
	String get privacy_link => '隱私政策';

	/// zh-TW: '。我們採用匿名登入，保障您的隱私。'
	String get content_suffix => '。我們採用匿名登入，保障您的隱私。';

	/// zh-TW: '登入失敗: {message}'
	String login_failed({required Object message}) => '登入失敗: ${message}';
}

// Path: S51_Onboarding_Name
class TranslationsS51OnboardingNameZhTw {
	TranslationsS51OnboardingNameZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '名稱設定'
	String get title => '名稱設定';

	late final TranslationsS51OnboardingNameButtonsZhTw buttons = TranslationsS51OnboardingNameButtonsZhTw.internal(_root);

	/// zh-TW: '請輸入您在 App 內的顯示名稱（1-10 個字）。'
	String get description => '請輸入您在 App 內的顯示名稱（1-10 個字）。';

	/// zh-TW: '輸入暱稱'
	String get field_hint => '輸入暱稱';

	/// zh-TW: '{current}/10'
	String field_counter({required Object current}) => '${current}/10';

	/// zh-TW: '名稱不能為空'
	String get error_empty => '名稱不能為空';

	/// zh-TW: '最多 10 個字'
	String get error_too_long => '最多 10 個字';

	/// zh-TW: '包含無效字元'
	String get error_invalid_char => '包含無效字元';
}

// Path: S52_TaskSettings_Log
class TranslationsS52TaskSettingsLogZhTw {
	TranslationsS52TaskSettingsLogZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '活動紀錄'
	String get title => '活動紀錄';

	late final TranslationsS52TaskSettingsLogButtonsZhTw buttons = TranslationsS52TaskSettingsLogButtonsZhTw.internal(_root);

	/// zh-TW: '目前沒有任何活動紀錄'
	String get empty_log => '目前沒有任何活動紀錄';

	/// zh-TW: '活動紀錄'
	String get export_file_prefix => '活動紀錄';

	late final TranslationsS52TaskSettingsLogCsvHeaderZhTw csv_header = TranslationsS52TaskSettingsLogCsvHeaderZhTw.internal(_root);

	/// zh-TW: '預收'
	String get type_income => '預收';

	/// zh-TW: '支出'
	String get type_expense => '支出';

	/// zh-TW: '支付'
	String get label_payment => '支付';

	/// zh-TW: '預收款'
	String get payment_income => '預收款';

	/// zh-TW: '公款支付'
	String get payment_pool => '公款支付';

	/// zh-TW: '代墊'
	String get payment_single_suffix => '代墊';

	/// zh-TW: '多人代墊'
	String get payment_multiple => '多人代墊';

	/// zh-TW: '人'
	String get unit_members => '人';

	/// zh-TW: '細項'
	String get unit_items => '細項';
}

// Path: S53_TaskSettings_Members
class TranslationsS53TaskSettingsMembersZhTw {
	TranslationsS53TaskSettingsMembersZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '成員管理'
	String get title => '成員管理';

	late final TranslationsS53TaskSettingsMembersButtonsZhTw buttons = TranslationsS53TaskSettingsMembersButtonsZhTw.internal(_root);

	/// zh-TW: '預設比例'
	String get label_default_ratio => '預設比例';

	/// zh-TW: '無法刪除成員'
	String get dialog_delete_error_title => '無法刪除成員';

	/// zh-TW: '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。'
	String get dialog_delete_error_content => '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。';

	/// zh-TW: '成員'
	String get member_default_name => '成員';

	/// zh-TW: '成員名稱'
	String get member_name => '成員名稱';
}

// Path: S71_SystemSettings_Tos
class TranslationsS71SystemSettingsTosZhTw {
	TranslationsS71SystemSettingsTosZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '服務條款'
	String get title => '服務條款';
}

// Path: D01_MemberRole_Intro
class TranslationsD01MemberRoleIntroZhTw {
	TranslationsD01MemberRoleIntroZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '你的角色是...'
	String get title => '你的角色是...';

	late final TranslationsD01MemberRoleIntroButtonsZhTw buttons = TranslationsD01MemberRoleIntroButtonsZhTw.internal(_root);

	/// zh-TW: '還有 1 次機會'
	String get desc_reroll_left => '還有 1 次機會';

	/// zh-TW: '機會已用完'
	String get desc_reroll_empty => '機會已用完';

	/// zh-TW: '這是你在本次任務中的專屬頭像。所有分帳紀錄都會使用這個動物代表你喔！'
	String get dialog_content => '這是你在本次任務中的專屬頭像。所有分帳紀錄都會使用這個動物代表你喔！';
}

// Path: D02_Invite_Result
class TranslationsD02InviteResultZhTw {
	TranslationsD02InviteResultZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '加入失敗'
	String get title => '加入失敗';

	late final TranslationsD02InviteResultButtonsZhTw buttons = TranslationsD02InviteResultButtonsZhTw.internal(_root);

	/// zh-TW: '邀請碼無效，請確認連結是否正確。'
	String get error_INVALID_CODE => '邀請碼無效，請確認連結是否正確。';

	/// zh-TW: '邀請連結已過期 (超過 15 分鐘)，請請隊長重新分享。'
	String get error_EXPIRED_CODE => '邀請連結已過期 (超過 15 分鐘)，請請隊長重新分享。';

	/// zh-TW: '任務人數已滿 (上限 15 人)，無法加入。'
	String get error_TASK_FULL => '任務人數已滿 (上限 15 人)，無法加入。';

	/// zh-TW: '身分驗證失敗，請重新啟動 App。'
	String get error_AUTH_REQUIRED => '身分驗證失敗，請重新啟動 App。';

	/// zh-TW: '發生未知錯誤，請稍後再試。'
	String get error_UNKNOWN => '發生未知錯誤，請稍後再試。';
}

// Path: D03_TaskCreate_Confirm
class TranslationsD03TaskCreateConfirmZhTw {
	TranslationsD03TaskCreateConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認任務設定'
	String get title => '確認任務設定';

	late final TranslationsD03TaskCreateConfirmButtonsZhTw buttons = TranslationsD03TaskCreateConfirmButtonsZhTw.internal(_root);

	/// zh-TW: '任務名稱'
	String get label_name => '任務名稱';

	/// zh-TW: '期間'
	String get label_period => '期間';

	/// zh-TW: '幣別'
	String get label_currency => '幣別';

	/// zh-TW: '人數'
	String get label_members => '人數';

	/// zh-TW: '正在建立任務...'
	String get creating_task => '正在建立任務...';

	/// zh-TW: '準備邀請函...'
	String get preparing_share => '準備邀請函...';

	/// zh-TW: '邀請加入 Iron Split 任務'
	String get share_subject => '邀請加入 Iron Split 任務';

	/// zh-TW: '快來加入我的 Iron Split 任務「{taskName}」！ 邀請碼：{code} 連結：{link}'
	String share_message({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「${taskName}」！\n邀請碼：${code}\n連結：${link}';
}

// Path: D05_DateJump_NoResult
class TranslationsD05DateJumpNoResultZhTw {
	TranslationsD05DateJumpNoResultZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '無紀錄'
	String get title => '無紀錄';

	late final TranslationsD05DateJumpNoResultButtonsZhTw buttons = TranslationsD05DateJumpNoResultButtonsZhTw.internal(_root);

	/// zh-TW: '找不到此日期的紀錄，要新增一筆嗎？'
	String get content => '找不到此日期的紀錄，要新增一筆嗎？';
}

// Path: D08_TaskClosed_Confirm
class TranslationsD08TaskClosedConfirmZhTw {
	TranslationsD08TaskClosedConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認結束任務'
	String get title => '確認結束任務';

	late final TranslationsD08TaskClosedConfirmButtonsZhTw buttons = TranslationsD08TaskClosedConfirmButtonsZhTw.internal(_root);

	/// zh-TW: '此操作無法復原。所有資料將被永久鎖定。 確定要繼續嗎？'
	String get content => '此操作無法復原。所有資料將被永久鎖定。\n\n確定要繼續嗎？';
}

// Path: D09_TaskSettings_CurrencyConfirm
class TranslationsD09TaskSettingsCurrencyConfirmZhTw {
	TranslationsD09TaskSettingsCurrencyConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '變更結算幣別？'
	String get title => '變更結算幣別？';

	/// zh-TW: '變更幣別將會重置所有匯率設定，這可能會影響目前的帳目金額。確定要變更嗎？'
	String get content => '變更幣別將會重置所有匯率設定，這可能會影響目前的帳目金額。確定要變更嗎？';
}

// Path: D10_RecordDelete_Confirm
class TranslationsD10RecordDeleteConfirmZhTw {
	TranslationsD10RecordDeleteConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '刪除紀錄？'
	String get delete_record_title => '刪除紀錄？';

	/// zh-TW: '確定要刪除 {title} ({amount}) 嗎？'
	String delete_record_content({required Object title, required Object amount}) => '確定要刪除 ${title} (${amount}) 嗎？';

	/// zh-TW: '紀錄已刪除'
	String get deleted_success => '紀錄已刪除';
}

// Path: B02_SplitExpense_Edit
class TranslationsB02SplitExpenseEditZhTw {
	TranslationsB02SplitExpenseEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '編輯細項'
	String get title => '編輯細項';

	late final TranslationsB02SplitExpenseEditButtonsZhTw buttons = TranslationsB02SplitExpenseEditButtonsZhTw.internal(_root);

	/// zh-TW: '項目名稱'
	String get name_label => '項目名稱';

	/// zh-TW: '金額'
	String get amount_label => '金額';

	/// zh-TW: '分攤設定'
	String get split_button_prefix => '分攤設定';

	/// zh-TW: '備註'
	String get hint_memo => '備註';

	/// zh-TW: '成員分配'
	String get section_members => '成員分配';

	/// zh-TW: '剩餘: {amount}'
	String label_remainder({required Object amount}) => '剩餘: ${amount}';

	/// zh-TW: '總計: {current}/{target}'
	String label_total({required Object current, required Object target}) => '總計: ${current}/${target}';

	/// zh-TW: '總金額不符'
	String get error_total_mismatch => '總金額不符';

	/// zh-TW: '總比例必須為 100%'
	String get error_percent_mismatch => '總比例必須為 100%';

	/// zh-TW: '金額'
	String get hint_amount => '金額';

	/// zh-TW: '%'
	String get hint_percent => '%';
}

// Path: B03_SplitMethod_Edit
class TranslationsB03SplitMethodEditZhTw {
	TranslationsB03SplitMethodEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '選擇分攤方式'
	String get title => '選擇分攤方式';

	late final TranslationsB03SplitMethodEditButtonsZhTw buttons = TranslationsB03SplitMethodEditButtonsZhTw.internal(_root);

	/// zh-TW: '平均分攤'
	String get method_even => '平均分攤';

	/// zh-TW: '比例分攤'
	String get method_percent => '比例分攤';

	/// zh-TW: '指定金額'
	String get method_exact => '指定金額';

	/// zh-TW: '選定成員平分，餘額存入餘額罐'
	String get desc_even => '選定成員平分，餘額存入餘額罐';

	/// zh-TW: '依設定比例分配'
	String get desc_percent => '依設定比例分配';

	/// zh-TW: '手動輸入金額，總額需吻合'
	String get desc_exact => '手動輸入金額，總額需吻合';

	/// zh-TW: '餘額 {amount} 將存入餘額罐 (結算時分配)'
	String msg_leftover_pot({required Object amount}) => '餘額 ${amount} 將存入餘額罐 (結算時分配)';

	/// zh-TW: '比例'
	String get label_weight => '比例';

	/// zh-TW: '總金額不符 (差額 {diff})'
	String error_total_mismatch({required Object diff}) => '總金額不符 (差額 ${diff})';
}

// Path: b04_payment_merge
class TranslationsB04PaymentMergeZhTw {
	TranslationsB04PaymentMergeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '合併成員款項'
	String get title => '合併成員款項';

	/// zh-TW: '將成員合併至代表成員之下，應收退款金額將合併，方便只向代表成員收款。'
	String get description => '將成員合併至代表成員之下，應收退款金額將合併，方便只向代表成員收款。';

	/// zh-TW: '代表成員'
	String get section_head => '代表成員';

	/// zh-TW: '選擇合併成員'
	String get section_candidates => '選擇合併成員';

	/// zh-TW: '應付'
	String get status_payable => '應付';

	/// zh-TW: '可退'
	String get status_receivable => '可退';

	late final TranslationsB04PaymentMergeButtonsZhTw buttons = TranslationsB04PaymentMergeButtonsZhTw.internal(_root);
}

// Path: B07_PaymentMethod_Edit
class TranslationsB07PaymentMethodEditZhTw {
	TranslationsB07PaymentMethodEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '選擇資金來源'
	String get title => '選擇資金來源';

	/// zh-TW: '成員墊付'
	String get type_member => '成員墊付';

	/// zh-TW: '公款支付'
	String get type_prepay => '公款支付';

	/// zh-TW: '混合支付'
	String get type_mixed => '混合支付';

	/// zh-TW: '公款餘額: {amount}'
	String prepay_balance({required Object amount}) => '公款餘額: ${amount}';

	/// zh-TW: '餘額不足'
	String get err_balance_not_enough => '餘額不足';

	/// zh-TW: '墊付成員'
	String get section_payer => '墊付成員';

	/// zh-TW: '支付金額'
	String get label_amount => '支付金額';

	/// zh-TW: '費用總額'
	String get total_label => '費用總額';

	/// zh-TW: '公款支付'
	String get total_prepay => '公款支付';

	/// zh-TW: '墊付總計'
	String get total_advance => '墊付總計';

	/// zh-TW: '金額吻合'
	String get status_balanced => '金額吻合';

	/// zh-TW: '尚差 {amount}'
	String status_remaining({required Object amount}) => '尚差 ${amount}';

	/// zh-TW: '已自動填入公款餘額'
	String get msg_auto_fill_prepay => '已自動填入公款餘額';
}

// Path: error
class TranslationsErrorZhTw {
	TranslationsErrorZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsErrorTaskFullZhTw taskFull = TranslationsErrorTaskFullZhTw.internal(_root);
	late final TranslationsErrorExpiredCodeZhTw expiredCode = TranslationsErrorExpiredCodeZhTw.internal(_root);
	late final TranslationsErrorInvalidCodeZhTw invalidCode = TranslationsErrorInvalidCodeZhTw.internal(_root);
	late final TranslationsErrorAuthRequiredZhTw authRequired = TranslationsErrorAuthRequiredZhTw.internal(_root);
	late final TranslationsErrorAlreadyInTaskZhTw alreadyInTask = TranslationsErrorAlreadyInTaskZhTw.internal(_root);
	late final TranslationsErrorUnknownZhTw unknown = TranslationsErrorUnknownZhTw.internal(_root);
}

// Path: common.buttons
class TranslationsCommonButtonsZhTw {
	TranslationsCommonButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '取消'
	String get cancel => '取消';

	/// zh-TW: '刪除'
	String get delete => '刪除';

	/// zh-TW: '確認'
	String get confirm => '確認';

	/// zh-TW: '返回'
	String get back => '返回';

	/// zh-TW: '保存'
	String get save => '保存';

	/// zh-TW: '編輯'
	String get edit => '編輯';

	/// zh-TW: '關閉'
	String get close => '關閉';

	/// zh-TW: '放棄變更'
	String get discard => '放棄變更';

	/// zh-TW: '繼續編輯'
	String get keep_editing => '繼續編輯';
}

// Path: common.category
class TranslationsCommonCategoryZhTw {
	TranslationsCommonCategoryZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '飲食'
	String get food => '飲食';

	/// zh-TW: '交通'
	String get transport => '交通';

	/// zh-TW: '購物'
	String get shopping => '購物';

	/// zh-TW: '娛樂'
	String get entertainment => '娛樂';

	/// zh-TW: '住宿'
	String get accommodation => '住宿';

	/// zh-TW: '其他'
	String get others => '其他';
}

// Path: common.currency
class TranslationsCommonCurrencyZhTw {
	TranslationsCommonCurrencyZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新台幣'
	String get twd => '新台幣';

	/// zh-TW: '日圓'
	String get jpy => '日圓';

	/// zh-TW: '美金'
	String get usd => '美金';

	/// zh-TW: '歐元'
	String get eur => '歐元';

	/// zh-TW: '韓元'
	String get krw => '韓元';

	/// zh-TW: '人民幣'
	String get cny => '人民幣';

	/// zh-TW: '英鎊'
	String get gbp => '英鎊';

	/// zh-TW: '加拿大幣'
	String get cad => '加拿大幣';

	/// zh-TW: '澳幣'
	String get aud => '澳幣';

	/// zh-TW: '瑞士法郎'
	String get chf => '瑞士法郎';

	/// zh-TW: '丹麥幣'
	String get dkk => '丹麥幣';

	/// zh-TW: '港幣'
	String get hkd => '港幣';

	/// zh-TW: '挪威幣'
	String get nok => '挪威幣';

	/// zh-TW: '紐西蘭幣'
	String get nzd => '紐西蘭幣';

	/// zh-TW: '新加坡幣'
	String get sgd => '新加坡幣';

	/// zh-TW: '泰幣'
	String get thb => '泰幣';

	/// zh-TW: '南非幣'
	String get zar => '南非幣';

	/// zh-TW: '俄羅斯幣'
	String get rub => '俄羅斯幣';

	/// zh-TW: '越南盾'
	String get vnd => '越南盾';

	/// zh-TW: '印尼盾'
	String get idr => '印尼盾';

	/// zh-TW: '馬來幣'
	String get myr => '馬來幣';

	/// zh-TW: '菲律賓幣'
	String get php => '菲律賓幣';

	/// zh-TW: '澳門幣'
	String get mop => '澳門幣';

	/// zh-TW: '瑞典克朗'
	String get sek => '瑞典克朗';

	/// zh-TW: '阿聯酋迪拉姆'
	String get aed => '阿聯酋迪拉姆';

	/// zh-TW: '沙烏地里亞爾'
	String get sar => '沙烏地里亞爾';

	/// zh-TW: '土耳其里拉'
	String get try_ => '土耳其里拉';

	/// zh-TW: '印度盧比'
	String get inr => '印度盧比';
}

// Path: common.remainder_rule
class TranslationsCommonRemainderRuleZhTw {
	TranslationsCommonRemainderRuleZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '零頭處理'
	String get title => '零頭處理';

	/// zh-TW: '餘額輪盤'
	String get rule_random => '餘額輪盤';

	/// zh-TW: '順序輪替'
	String get rule_order => '順序輪替';

	/// zh-TW: '指定成員'
	String get rule_member => '指定成員';
}

// Path: common.payment_info
class TranslationsCommonPaymentInfoZhTw {
	TranslationsCommonPaymentInfoZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '收款方式'
	String get method_label => '收款方式';

	/// zh-TW: '請直接私訊聯絡'
	String get mode_private => '請直接私訊聯絡';

	/// zh-TW: '不顯示詳細資訊，請成員直接找你'
	String get mode_private_desc => '不顯示詳細資訊，請成員直接找你';

	/// zh-TW: '提供收款資訊'
	String get mode_public => '提供收款資訊';

	/// zh-TW: '顯示銀行帳號或支付連結'
	String get mode_public_desc => '顯示銀行帳號或支付連結';

	/// zh-TW: '現金'
	String get type_cash => '現金';

	/// zh-TW: '銀行轉帳'
	String get type_bank => '銀行轉帳';

	/// zh-TW: '其他支付 App'
	String get type_apps => '其他支付 App';

	/// zh-TW: '銀行代碼 / 名稱'
	String get bank_name_hint => '銀行代碼 / 名稱';

	/// zh-TW: '帳號'
	String get bank_account_hint => '帳號';

	/// zh-TW: 'App 名稱 (如: LinePay)'
	String get app_name => 'App 名稱 (如: LinePay)';

	/// zh-TW: '連結 / ID'
	String get app_link => '連結 / ID';
}

// Path: S11_Invite_Confirm.buttons
class TranslationsS11InviteConfirmButtonsZhTw {
	TranslationsS11InviteConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '加入'
	String get confirm => '加入';

	/// zh-TW: '取消'
	String get cancel => '取消';

	/// zh-TW: '回首頁'
	String get home => '回首頁';
}

// Path: S12_TaskClose_Notice.buttons
class TranslationsS12TaskCloseNoticeButtonsZhTw {
	TranslationsS12TaskCloseNoticeButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結束任務'
	String get close => '結束任務';
}

// Path: S13_Task_Dashboard.buttons
class TranslationsS13TaskDashboardButtonsZhTw {
	TranslationsS13TaskDashboardButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '記一筆'
	String get record => '記一筆';

	/// zh-TW: '結算'
	String get settlement => '結算';

	/// zh-TW: '下載記錄'
	String get download => '下載記錄';
}

// Path: S15_Record_Edit.buttons
class TranslationsS15RecordEditButtonsZhTw {
	TranslationsS15RecordEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '儲存紀錄'
	String get save => '儲存紀錄';

	/// zh-TW: '關閉'
	String get close => '關閉';
}

// Path: S16_TaskCreate_Edit.buttons
class TranslationsS16TaskCreateEditButtonsZhTw {
	TranslationsS16TaskCreateEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '保存'
	String get save => '保存';

	/// zh-TW: '確定'
	String get done => '確定';
}

// Path: S17_Task_Locked.buttons
class TranslationsS17TaskLockedButtonsZhTw {
	TranslationsS17TaskLockedButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '下載紀錄'
	String get download => '下載紀錄';

	/// zh-TW: '通知成員'
	String get notify_members => '通知成員';

	/// zh-TW: '查看收退款帳戶'
	String get view_payment_details => '查看收退款帳戶';
}

// Path: s30_settlement_confirm.buttons
class TranslationsS30SettlementConfirmButtonsZhTw {
	TranslationsS30SettlementConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '收款設定'
	String get next => '收款設定';
}

// Path: s30_settlement_confirm.steps
class TranslationsS30SettlementConfirmStepsZhTw {
	TranslationsS30SettlementConfirmStepsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認金額'
	String get confirm_amount => '確認金額';

	/// zh-TW: '收款設定'
	String get payment_info => '收款設定';
}

// Path: s30_settlement_confirm.warning
class TranslationsS30SettlementConfirmWarningZhTw {
	TranslationsS30SettlementConfirmWarningZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '餘額將於下一步結算完成後揭曉！'
	String get random_reveal => '餘額將於下一步結算完成後揭曉！';
}

// Path: s30_settlement_confirm.list_item
class TranslationsS30SettlementConfirmListItemZhTw {
	TranslationsS30SettlementConfirmListItemZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '合併'
	String get merged_label => '合併';

	/// zh-TW: '包含：'
	String get includes => '包含：';

	/// zh-TW: '本金'
	String get principal => '本金';

	/// zh-TW: '隨機餘額'
	String get random_remainder => '隨機餘額';

	/// zh-TW: '餘額'
	String get remainder => '餘額';
}

// Path: s31_settlement_payment_info.buttons
class TranslationsS31SettlementPaymentInfoButtonsZhTw {
	TranslationsS31SettlementPaymentInfoButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結算'
	String get settle => '結算';

	/// zh-TW: '上一步'
	String get prev_step => '上一步';
}

// Path: S50_Onboarding_Consent.buttons
class TranslationsS50OnboardingConsentButtonsZhTw {
	TranslationsS50OnboardingConsentButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '開始使用'
	String get agree => '開始使用';
}

// Path: S51_Onboarding_Name.buttons
class TranslationsS51OnboardingNameButtonsZhTw {
	TranslationsS51OnboardingNameButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '設定完成'
	String get next => '設定完成';
}

// Path: S52_TaskSettings_Log.buttons
class TranslationsS52TaskSettingsLogButtonsZhTw {
	TranslationsS52TaskSettingsLogButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '匯出 CSV'
	String get export_csv => '匯出 CSV';
}

// Path: S52_TaskSettings_Log.csv_header
class TranslationsS52TaskSettingsLogCsvHeaderZhTw {
	TranslationsS52TaskSettingsLogCsvHeaderZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '時間'
	String get time => '時間';

	/// zh-TW: '操作者'
	String get user => '操作者';

	/// zh-TW: '動作'
	String get action => '動作';

	/// zh-TW: '內容'
	String get details => '內容';
}

// Path: S53_TaskSettings_Members.buttons
class TranslationsS53TaskSettingsMembersButtonsZhTw {
	TranslationsS53TaskSettingsMembersButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增成員'
	String get add => '新增成員';

	/// zh-TW: '發送邀請'
	String get invite => '發送邀請';
}

// Path: D01_MemberRole_Intro.buttons
class TranslationsD01MemberRoleIntroButtonsZhTw {
	TranslationsD01MemberRoleIntroButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '換個動物'
	String get reroll => '換個動物';

	/// zh-TW: '進入任務'
	String get enter => '進入任務';
}

// Path: D02_Invite_Result.buttons
class TranslationsD02InviteResultButtonsZhTw {
	TranslationsD02InviteResultButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '回首頁'
	String get back => '回首頁';
}

// Path: D03_TaskCreate_Confirm.buttons
class TranslationsD03TaskCreateConfirmButtonsZhTw {
	TranslationsD03TaskCreateConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認'
	String get confirm => '確認';

	/// zh-TW: '返回編輯'
	String get back => '返回編輯';
}

// Path: D05_DateJump_NoResult.buttons
class TranslationsD05DateJumpNoResultButtonsZhTw {
	TranslationsD05DateJumpNoResultButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '返回'
	String get cancel => '返回';

	/// zh-TW: '新增紀錄'
	String get add => '新增紀錄';
}

// Path: D08_TaskClosed_Confirm.buttons
class TranslationsD08TaskClosedConfirmButtonsZhTw {
	TranslationsD08TaskClosedConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認'
	String get confirm => '確認';
}

// Path: B02_SplitExpense_Edit.buttons
class TranslationsB02SplitExpenseEditButtonsZhTw {
	TranslationsB02SplitExpenseEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認分拆'
	String get save => '確認分拆';
}

// Path: B03_SplitMethod_Edit.buttons
class TranslationsB03SplitMethodEditButtonsZhTw {
	TranslationsB03SplitMethodEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '調整權重'
	String get adjust_weight => '調整權重';
}

// Path: b04_payment_merge.buttons
class TranslationsB04PaymentMergeButtonsZhTw {
	TranslationsB04PaymentMergeButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '取消'
	String get cancel => '取消';

	/// zh-TW: '合併'
	String get confirm => '合併';
}

// Path: error.taskFull
class TranslationsErrorTaskFullZhTw {
	TranslationsErrorTaskFullZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務已滿'
	String get title => '任務已滿';

	/// zh-TW: '此任務成員數已達上限 {limit} 人，請聯繫隊長。'
	String message({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。';
}

// Path: error.expiredCode
class TranslationsErrorExpiredCodeZhTw {
	TranslationsErrorExpiredCodeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '邀請碼已過期'
	String get title => '邀請碼已過期';

	/// zh-TW: '此邀請連結已失效（時限 {minutes} 分鐘）。請請隊長重新產生。'
	String message({required Object minutes}) => '此邀請連結已失效（時限 ${minutes} 分鐘）。請請隊長重新產生。';
}

// Path: error.invalidCode
class TranslationsErrorInvalidCodeZhTw {
	TranslationsErrorInvalidCodeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '連結無效'
	String get title => '連結無效';

	/// zh-TW: '無效的邀請連結，請確認是否正確或已被刪除。'
	String get message => '無效的邀請連結，請確認是否正確或已被刪除。';
}

// Path: error.authRequired
class TranslationsErrorAuthRequiredZhTw {
	TranslationsErrorAuthRequiredZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '需要登入'
	String get title => '需要登入';

	/// zh-TW: '請先登入後再加入任務。'
	String get message => '請先登入後再加入任務。';
}

// Path: error.alreadyInTask
class TranslationsErrorAlreadyInTaskZhTw {
	TranslationsErrorAlreadyInTaskZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '您已是成員'
	String get title => '您已是成員';

	/// zh-TW: '您已經在這個任務中了。'
	String get message => '您已經在這個任務中了。';
}

// Path: error.unknown
class TranslationsErrorUnknownZhTw {
	TranslationsErrorUnknownZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '發生錯誤'
	String get title => '發生錯誤';

	/// zh-TW: '發生未預期的錯誤，請稍後再試。'
	String get message => '發生未預期的錯誤，請稍後再試。';
}

/// The flat map containing all translations for locale <zh-TW>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.buttons.cancel' => '取消',
			'common.buttons.delete' => '刪除',
			'common.buttons.confirm' => '確認',
			'common.buttons.back' => '返回',
			'common.buttons.save' => '保存',
			'common.buttons.edit' => '編輯',
			'common.buttons.close' => '關閉',
			'common.buttons.discard' => '放棄變更',
			'common.buttons.keep_editing' => '繼續編輯',
			'common.category.food' => '飲食',
			'common.category.transport' => '交通',
			'common.category.shopping' => '購物',
			'common.category.entertainment' => '娛樂',
			'common.category.accommodation' => '住宿',
			'common.category.others' => '其他',
			'common.currency.twd' => '新台幣',
			'common.currency.jpy' => '日圓',
			'common.currency.usd' => '美金',
			'common.currency.eur' => '歐元',
			'common.currency.krw' => '韓元',
			'common.currency.cny' => '人民幣',
			'common.currency.gbp' => '英鎊',
			'common.currency.cad' => '加拿大幣',
			'common.currency.aud' => '澳幣',
			'common.currency.chf' => '瑞士法郎',
			'common.currency.dkk' => '丹麥幣',
			'common.currency.hkd' => '港幣',
			'common.currency.nok' => '挪威幣',
			'common.currency.nzd' => '紐西蘭幣',
			'common.currency.sgd' => '新加坡幣',
			'common.currency.thb' => '泰幣',
			'common.currency.zar' => '南非幣',
			'common.currency.rub' => '俄羅斯幣',
			'common.currency.vnd' => '越南盾',
			'common.currency.idr' => '印尼盾',
			'common.currency.myr' => '馬來幣',
			'common.currency.php' => '菲律賓幣',
			'common.currency.mop' => '澳門幣',
			'common.currency.sek' => '瑞典克朗',
			'common.currency.aed' => '阿聯酋迪拉姆',
			'common.currency.sar' => '沙烏地里亞爾',
			'common.currency.try_' => '土耳其里拉',
			'common.currency.inr' => '印度盧比',
			'common.remainder_rule.title' => '零頭處理',
			'common.remainder_rule.rule_random' => '餘額輪盤',
			'common.remainder_rule.rule_order' => '順序輪替',
			'common.remainder_rule.rule_member' => '指定成員',
			'common.payment_info.method_label' => '收款方式',
			'common.payment_info.mode_private' => '請直接私訊聯絡',
			'common.payment_info.mode_private_desc' => '不顯示詳細資訊，請成員直接找你',
			'common.payment_info.mode_public' => '提供收款資訊',
			'common.payment_info.mode_public_desc' => '顯示銀行帳號或支付連結',
			'common.payment_info.type_cash' => '現金',
			'common.payment_info.type_bank' => '銀行轉帳',
			'common.payment_info.type_apps' => '其他支付 App',
			'common.payment_info.bank_name_hint' => '銀行代碼 / 名稱',
			'common.payment_info.bank_account_hint' => '帳號',
			'common.payment_info.app_name' => 'App 名稱 (如: LinePay)',
			'common.payment_info.app_link' => '連結 / ID',
			'common.error_prefix' => ({required Object message}) => '錯誤: ${message}',
			'common.please_login' => '請先登入',
			'common.loading' => '讀取中...',
			'common.me' => '我',
			'common.required' => '必填',
			'common.member_prefix' => '成員',
			'common.no_record' => '無紀錄',
			'common.today' => '今天',
			'common.untitled' => '未命名',
			'log_action.create_task' => '建立任務',
			'log_action.update_settings' => '更新設定',
			'log_action.add_member' => '新增成員',
			'log_action.remove_member' => '移除成員',
			'log_action.create_record' => '新增記帳',
			'log_action.update_record' => '修改記帳',
			'log_action.delete_record' => '刪除記帳',
			'log_action.settle_up' => '執行結算',
			'log_action.unknown' => '未知操作',
			'log_action.close_task' => '結束任務',
			'dialog.unsaved_changes_title' => '尚未儲存',
			'dialog.unsaved_changes_content' => '變更將不會被儲存，確定要離開嗎？',
			'S10_Home_TaskList.title' => '我的任務',
			'S10_Home_TaskList.tab_in_progress' => '進行中',
			'S10_Home_TaskList.tab_completed' => '已完成',
			'S10_Home_TaskList.mascot_preparing' => '鐵公雞準備中...',
			'S10_Home_TaskList.empty_in_progress' => '目前沒有進行中的任務',
			'S10_Home_TaskList.empty_completed' => '沒有已完成的任務',
			'S10_Home_TaskList.date_tbd' => '日期未定',
			'S10_Home_TaskList.delete_confirm_title' => '確認刪除',
			'S10_Home_TaskList.delete_confirm_content' => '確定要刪除這個任務嗎？',
			'S11_Invite_Confirm.title' => '加入任務',
			'S11_Invite_Confirm.subtitle' => '您受邀加入以下任務：',
			'S11_Invite_Confirm.buttons.confirm' => '加入',
			'S11_Invite_Confirm.buttons.cancel' => '取消',
			'S11_Invite_Confirm.buttons.home' => '回首頁',
			'S11_Invite_Confirm.loading_invite' => '正在讀取邀請函...',
			'S11_Invite_Confirm.join_failed_title' => '哎呀！無法加入任務',
			'S11_Invite_Confirm.identity_match_title' => '請問您是以下成員嗎？',
			'S11_Invite_Confirm.identity_match_desc' => '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。',
			'S11_Invite_Confirm.status_linking' => '將以「連結帳號」方式加入',
			'S11_Invite_Confirm.status_new_member' => '將以「新成員」身分加入',
			'S11_Invite_Confirm.error_join_failed' => ({required Object message}) => '加入失敗：${message}',
			'S11_Invite_Confirm.error_generic' => ({required Object message}) => '發生錯誤：${message}',
			'S11_Invite_Confirm.label_select_ghost' => '選擇要繼承的成員',
			'S11_Invite_Confirm.label_prepaid' => '已墊付',
			'S11_Invite_Confirm.label_expense' => '應分攤',
			'S12_TaskClose_Notice.title' => '結束任務確認',
			'S12_TaskClose_Notice.content' => '關閉此任務後，所有紀錄與設定將被鎖定。系統將進入唯讀模式，您將無法新增或編輯任何資料。',
			'S12_TaskClose_Notice.buttons.close' => '結束任務',
			'S13_Task_Dashboard.title_active' => '任務主頁',
			'S13_Task_Dashboard.buttons.record' => '記一筆',
			'S13_Task_Dashboard.buttons.settlement' => '結算',
			'S13_Task_Dashboard.buttons.download' => '下載記錄',
			'S13_Task_Dashboard.tab_group' => '大家',
			'S13_Task_Dashboard.tab_personal' => '個人',
			'S13_Task_Dashboard.label_prepay_balance' => '公款餘額',
			'S13_Task_Dashboard.label_my_balance' => '我的收支',
			'S13_Task_Dashboard.label_remainder' => ({required Object amount}) => '暫存零頭: ${amount}',
			'S13_Task_Dashboard.label_balance' => '結餘',
			'S13_Task_Dashboard.label_total_expense' => '總費用',
			'S13_Task_Dashboard.label_total_prepay' => '總預收',
			'S13_Task_Dashboard.label_remainder_pot' => '零頭罐',
			'S13_Task_Dashboard.empty_records' => '尚無收支紀錄',
			'S13_Task_Dashboard.nav_to_record' => '準備前往記帳頁面...',
			'S13_Task_Dashboard.daily_expense_label' => '支出',
			'S13_Task_Dashboard.dialog_balance_detail' => '收支幣別明細',
			'S13_Task_Dashboard.section_expense' => '支出明細',
			'S13_Task_Dashboard.section_income' => '預收明細',
			'S13_Task_Dashboard.daily_stats_title' => '本日支出',
			'S13_Task_Dashboard.personal_daily_total' => '個人本日支出',
			'S13_Task_Dashboard.personal_to_receive' => '應收',
			'S13_Task_Dashboard.personal_to_pay' => '應付',
			'S13_Task_Dashboard.personal_empty_desc' => '這天沒有與你有關的紀錄',
			'S13_Task_Dashboard.total_amount_label' => '總金額',
			'S13_Task_Dashboard.retention_notice' => '此任務已關閉。資料將保留 30 天，請下載您的紀錄。',
			'S14_Task_Settings.title' => '任務設定',
			'S14_Task_Settings.menu_member_settings' => '成員設定',
			'S14_Task_Settings.menu_history' => '歷史紀錄',
			'S14_Task_Settings.menu_end_task' => '結束任務',
			'S14_Task_Settings.section_remainder' => '剩餘款',
			'S15_Record_Edit.title_create' => '記一筆',
			'S15_Record_Edit.title_edit' => '編輯紀錄',
			'S15_Record_Edit.buttons.save' => '儲存紀錄',
			'S15_Record_Edit.buttons.close' => '關閉',
			'S15_Record_Edit.section_split' => '分攤資訊',
			'S15_Record_Edit.label_date' => '日期',
			'S15_Record_Edit.label_title' => '項目名稱',
			'S15_Record_Edit.hint_title' => '輸入消費項目 (如：晚餐)',
			'S15_Record_Edit.label_payment_method' => '支付方式',
			'S15_Record_Edit.val_prepay' => '預收',
			'S15_Record_Edit.val_member_paid' => ({required Object name}) => '${name} 先付',
			'S15_Record_Edit.label_amount' => '金額',
			'S15_Record_Edit.label_rate' => ({required Object base, required Object target}) => '匯率 (1 ${base} = ? ${target})',
			'S15_Record_Edit.label_memo' => '備註',
			'S15_Record_Edit.hint_memo' => '輸入備註...',
			'S15_Record_Edit.val_split_details' => '細項分拆',
			'S15_Record_Edit.val_split_summary' => ({required Object amount, required Object method}) => '總計 ${amount} 由 ${method} 分攤',
			'S15_Record_Edit.info_rate_source' => '匯率來源',
			'S15_Record_Edit.msg_rate_source' => '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。',
			'S15_Record_Edit.val_converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			'S15_Record_Edit.val_split_remaining' => '剩餘金額',
			'S15_Record_Edit.err_amount_not_enough' => '剩餘金額不足',
			'S15_Record_Edit.val_mock_note' => '細項說明',
			'S15_Record_Edit.tab_expense' => '支出',
			'S15_Record_Edit.tab_income' => '預收',
			'S15_Record_Edit.msg_income_developing' => '預收功能開發中...',
			'S15_Record_Edit.msg_not_implemented' => '此功能尚未實作',
			'S15_Record_Edit.err_input_amount' => '請先輸入金額',
			'S15_Record_Edit.section_items' => '細項分拆',
			'S15_Record_Edit.add_item' => '新增細項',
			'S15_Record_Edit.base_card_title' => '剩餘金額 (Base)',
			'S15_Record_Edit.type_income_title' => '預收款',
			'S15_Record_Edit.base_card_title_expense' => '剩餘金額 (Base)',
			'S15_Record_Edit.base_card_title_income' => '資金來源 (入金者)',
			'S15_Record_Edit.payer_multiple' => '多人',
			'S16_TaskCreate_Edit.title' => '新增任務',
			'S16_TaskCreate_Edit.buttons.save' => '保存',
			'S16_TaskCreate_Edit.buttons.done' => '確定',
			'S16_TaskCreate_Edit.section_name' => '任務名稱',
			'S16_TaskCreate_Edit.section_period' => '任務期間',
			'S16_TaskCreate_Edit.section_settings' => '結算設定',
			'S16_TaskCreate_Edit.field_name_hint' => '例如：東京五日遊',
			'S16_TaskCreate_Edit.field_name_counter' => ({required Object current}) => '${current}/20',
			'S16_TaskCreate_Edit.field_start_date' => '開始日期',
			'S16_TaskCreate_Edit.field_end_date' => '結束日期',
			'S16_TaskCreate_Edit.field_currency' => '結算幣別',
			'S16_TaskCreate_Edit.field_member_count' => '參加人數',
			'S16_TaskCreate_Edit.error_name_empty' => '請輸入任務名稱',
			'S16_TaskCreate_Edit.label_name' => '任務名稱',
			'S16_TaskCreate_Edit.label_date' => '日期',
			'S16_TaskCreate_Edit.label_currency' => '貨幣',
			'S17_Task_Locked.buttons.download' => '下載紀錄',
			'S17_Task_Locked.buttons.notify_members' => '通知成員',
			'S17_Task_Locked.buttons.view_payment_details' => '查看收退款帳戶',
			'S17_Task_Locked.retention_notice' => '此任務已關閉。資料將保留 30 天，請下載您的紀錄。',
			'S17_Task_Locked.label_remainder_absorbed_by' => ({required Object amount, required Object name}) => '零錢罐 ${amount} 由 ${name} 吸收',
			'S17_Task_Locked.section_pending' => '待處理',
			'S17_Task_Locked.section_cleared' => '已處理',
			'S17_Task_Locked.member_payment_status_pay' => '應付',
			'S17_Task_Locked.member_payment_status_receive' => '應收',
			'S17_Task_Locked.dialog_mark_cleared_title' => '確認收款/付款',
			'S17_Task_Locked.dialog_mark_cleared_content' => ({required Object name}) => '確定將 ${name} 標記為已處理？',
			's30_settlement_confirm.title' => '結算確認',
			's30_settlement_confirm.buttons.next' => '收款設定',
			's30_settlement_confirm.steps.confirm_amount' => '確認金額',
			's30_settlement_confirm.steps.payment_info' => '收款設定',
			's30_settlement_confirm.warning.random_reveal' => '餘額將於下一步結算完成後揭曉！',
			's30_settlement_confirm.label_payable' => '應付',
			's30_settlement_confirm.label_refund' => '可退',
			's30_settlement_confirm.list_item.merged_label' => '合併',
			's30_settlement_confirm.list_item.includes' => '包含：',
			's30_settlement_confirm.list_item.principal' => '本金',
			's30_settlement_confirm.list_item.random_remainder' => '隨機餘額',
			's30_settlement_confirm.list_item.remainder' => '餘額',
			's31_settlement_payment_info.title' => '收款資訊',
			's31_settlement_payment_info.setup_instruction' => '收款資訊僅供本次結算使用。預設資料加密儲存於本機。',
			's31_settlement_payment_info.sync_save' => '儲存為預設收款資訊 (存在手機)',
			's31_settlement_payment_info.sync_update' => '同步更新我的預設收款資訊',
			's31_settlement_payment_info.buttons.settle' => '結算',
			's31_settlement_payment_info.buttons.prev_step' => '上一步',
			'S50_Onboarding_Consent.title' => '歡迎使用 Iron Split',
			'S50_Onboarding_Consent.buttons.agree' => '開始使用',
			'S50_Onboarding_Consent.content_prefix' => '歡迎使用 Iron Split。點擊開始即代表您同意我們的 ',
			'S50_Onboarding_Consent.terms_link' => '服務條款',
			'S50_Onboarding_Consent.and' => ' 與 ',
			'S50_Onboarding_Consent.privacy_link' => '隱私政策',
			'S50_Onboarding_Consent.content_suffix' => '。我們採用匿名登入，保障您的隱私。',
			'S50_Onboarding_Consent.login_failed' => ({required Object message}) => '登入失敗: ${message}',
			'S51_Onboarding_Name.title' => '名稱設定',
			'S51_Onboarding_Name.buttons.next' => '設定完成',
			'S51_Onboarding_Name.description' => '請輸入您在 App 內的顯示名稱（1-10 個字）。',
			'S51_Onboarding_Name.field_hint' => '輸入暱稱',
			'S51_Onboarding_Name.field_counter' => ({required Object current}) => '${current}/10',
			'S51_Onboarding_Name.error_empty' => '名稱不能為空',
			'S51_Onboarding_Name.error_too_long' => '最多 10 個字',
			'S51_Onboarding_Name.error_invalid_char' => '包含無效字元',
			'S52_TaskSettings_Log.title' => '活動紀錄',
			'S52_TaskSettings_Log.buttons.export_csv' => '匯出 CSV',
			'S52_TaskSettings_Log.empty_log' => '目前沒有任何活動紀錄',
			'S52_TaskSettings_Log.export_file_prefix' => '活動紀錄',
			'S52_TaskSettings_Log.csv_header.time' => '時間',
			'S52_TaskSettings_Log.csv_header.user' => '操作者',
			'S52_TaskSettings_Log.csv_header.action' => '動作',
			'S52_TaskSettings_Log.csv_header.details' => '內容',
			'S52_TaskSettings_Log.type_income' => '預收',
			'S52_TaskSettings_Log.type_expense' => '支出',
			'S52_TaskSettings_Log.label_payment' => '支付',
			'S52_TaskSettings_Log.payment_income' => '預收款',
			'S52_TaskSettings_Log.payment_pool' => '公款支付',
			'S52_TaskSettings_Log.payment_single_suffix' => '代墊',
			'S52_TaskSettings_Log.payment_multiple' => '多人代墊',
			'S52_TaskSettings_Log.unit_members' => '人',
			'S52_TaskSettings_Log.unit_items' => '細項',
			'S53_TaskSettings_Members.title' => '成員管理',
			'S53_TaskSettings_Members.buttons.add' => '新增成員',
			'S53_TaskSettings_Members.buttons.invite' => '發送邀請',
			'S53_TaskSettings_Members.label_default_ratio' => '預設比例',
			'S53_TaskSettings_Members.dialog_delete_error_title' => '無法刪除成員',
			'S53_TaskSettings_Members.dialog_delete_error_content' => '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。',
			'S53_TaskSettings_Members.member_default_name' => '成員',
			'S53_TaskSettings_Members.member_name' => '成員名稱',
			'S71_SystemSettings_Tos.title' => '服務條款',
			'D01_MemberRole_Intro.title' => '你的角色是...',
			'D01_MemberRole_Intro.buttons.reroll' => '換個動物',
			'D01_MemberRole_Intro.buttons.enter' => '進入任務',
			'D01_MemberRole_Intro.desc_reroll_left' => '還有 1 次機會',
			'D01_MemberRole_Intro.desc_reroll_empty' => '機會已用完',
			'D01_MemberRole_Intro.dialog_content' => '這是你在本次任務中的專屬頭像。所有分帳紀錄都會使用這個動物代表你喔！',
			'D02_Invite_Result.title' => '加入失敗',
			'D02_Invite_Result.buttons.back' => '回首頁',
			'D02_Invite_Result.error_INVALID_CODE' => '邀請碼無效，請確認連結是否正確。',
			'D02_Invite_Result.error_EXPIRED_CODE' => '邀請連結已過期 (超過 15 分鐘)，請請隊長重新分享。',
			'D02_Invite_Result.error_TASK_FULL' => '任務人數已滿 (上限 15 人)，無法加入。',
			'D02_Invite_Result.error_AUTH_REQUIRED' => '身分驗證失敗，請重新啟動 App。',
			'D02_Invite_Result.error_UNKNOWN' => '發生未知錯誤，請稍後再試。',
			'D03_TaskCreate_Confirm.title' => '確認任務設定',
			'D03_TaskCreate_Confirm.buttons.confirm' => '確認',
			'D03_TaskCreate_Confirm.buttons.back' => '返回編輯',
			'D03_TaskCreate_Confirm.label_name' => '任務名稱',
			'D03_TaskCreate_Confirm.label_period' => '期間',
			'D03_TaskCreate_Confirm.label_currency' => '幣別',
			'D03_TaskCreate_Confirm.label_members' => '人數',
			'D03_TaskCreate_Confirm.creating_task' => '正在建立任務...',
			'D03_TaskCreate_Confirm.preparing_share' => '準備邀請函...',
			'D03_TaskCreate_Confirm.share_subject' => '邀請加入 Iron Split 任務',
			'D03_TaskCreate_Confirm.share_message' => ({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「${taskName}」！\n邀請碼：${code}\n連結：${link}',
			'D05_DateJump_NoResult.title' => '無紀錄',
			'D05_DateJump_NoResult.buttons.cancel' => '返回',
			'D05_DateJump_NoResult.buttons.add' => '新增紀錄',
			'D05_DateJump_NoResult.content' => '找不到此日期的紀錄，要新增一筆嗎？',
			'D08_TaskClosed_Confirm.title' => '確認結束任務',
			'D08_TaskClosed_Confirm.buttons.confirm' => '確認',
			'D08_TaskClosed_Confirm.content' => '此操作無法復原。所有資料將被永久鎖定。\n\n確定要繼續嗎？',
			'D09_TaskSettings_CurrencyConfirm.title' => '變更結算幣別？',
			'D09_TaskSettings_CurrencyConfirm.content' => '變更幣別將會重置所有匯率設定，這可能會影響目前的帳目金額。確定要變更嗎？',
			'D10_RecordDelete_Confirm.delete_record_title' => '刪除紀錄？',
			'D10_RecordDelete_Confirm.delete_record_content' => ({required Object title, required Object amount}) => '確定要刪除 ${title} (${amount}) 嗎？',
			'D10_RecordDelete_Confirm.deleted_success' => '紀錄已刪除',
			'B02_SplitExpense_Edit.title' => '編輯細項',
			'B02_SplitExpense_Edit.buttons.save' => '確認分拆',
			'B02_SplitExpense_Edit.name_label' => '項目名稱',
			'B02_SplitExpense_Edit.amount_label' => '金額',
			'B02_SplitExpense_Edit.split_button_prefix' => '分攤設定',
			'B02_SplitExpense_Edit.hint_memo' => '備註',
			'B02_SplitExpense_Edit.section_members' => '成員分配',
			'B02_SplitExpense_Edit.label_remainder' => ({required Object amount}) => '剩餘: ${amount}',
			'B02_SplitExpense_Edit.label_total' => ({required Object current, required Object target}) => '總計: ${current}/${target}',
			'B02_SplitExpense_Edit.error_total_mismatch' => '總金額不符',
			'B02_SplitExpense_Edit.error_percent_mismatch' => '總比例必須為 100%',
			'B02_SplitExpense_Edit.hint_amount' => '金額',
			'B02_SplitExpense_Edit.hint_percent' => '%',
			'B03_SplitMethod_Edit.title' => '選擇分攤方式',
			'B03_SplitMethod_Edit.buttons.adjust_weight' => '調整權重',
			'B03_SplitMethod_Edit.method_even' => '平均分攤',
			'B03_SplitMethod_Edit.method_percent' => '比例分攤',
			'B03_SplitMethod_Edit.method_exact' => '指定金額',
			'B03_SplitMethod_Edit.desc_even' => '選定成員平分，餘額存入餘額罐',
			'B03_SplitMethod_Edit.desc_percent' => '依設定比例分配',
			'B03_SplitMethod_Edit.desc_exact' => '手動輸入金額，總額需吻合',
			'B03_SplitMethod_Edit.msg_leftover_pot' => ({required Object amount}) => '餘額 ${amount} 將存入餘額罐 (結算時分配)',
			'B03_SplitMethod_Edit.label_weight' => '比例',
			'B03_SplitMethod_Edit.error_total_mismatch' => ({required Object diff}) => '總金額不符 (差額 ${diff})',
			'b04_payment_merge.title' => '合併成員款項',
			'b04_payment_merge.description' => '將成員合併至代表成員之下，應收退款金額將合併，方便只向代表成員收款。',
			'b04_payment_merge.section_head' => '代表成員',
			'b04_payment_merge.section_candidates' => '選擇合併成員',
			'b04_payment_merge.status_payable' => '應付',
			'b04_payment_merge.status_receivable' => '可退',
			'b04_payment_merge.buttons.cancel' => '取消',
			'b04_payment_merge.buttons.confirm' => '合併',
			'B07_PaymentMethod_Edit.title' => '選擇資金來源',
			'B07_PaymentMethod_Edit.type_member' => '成員墊付',
			'B07_PaymentMethod_Edit.type_prepay' => '公款支付',
			'B07_PaymentMethod_Edit.type_mixed' => '混合支付',
			'B07_PaymentMethod_Edit.prepay_balance' => ({required Object amount}) => '公款餘額: ${amount}',
			'B07_PaymentMethod_Edit.err_balance_not_enough' => '餘額不足',
			'B07_PaymentMethod_Edit.section_payer' => '墊付成員',
			'B07_PaymentMethod_Edit.label_amount' => '支付金額',
			'B07_PaymentMethod_Edit.total_label' => '費用總額',
			'B07_PaymentMethod_Edit.total_prepay' => '公款支付',
			'B07_PaymentMethod_Edit.total_advance' => '墊付總計',
			'B07_PaymentMethod_Edit.status_balanced' => '金額吻合',
			'B07_PaymentMethod_Edit.status_remaining' => ({required Object amount}) => '尚差 ${amount}',
			'B07_PaymentMethod_Edit.msg_auto_fill_prepay' => '已自動填入公款餘額',
			'error.taskFull.title' => '任務已滿',
			'error.taskFull.message' => ({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。',
			'error.expiredCode.title' => '邀請碼已過期',
			'error.expiredCode.message' => ({required Object minutes}) => '此邀請連結已失效（時限 ${minutes} 分鐘）。請請隊長重新產生。',
			'error.invalidCode.title' => '連結無效',
			'error.invalidCode.message' => '無效的邀請連結，請確認是否正確或已被刪除。',
			'error.authRequired.title' => '需要登入',
			'error.authRequired.message' => '請先登入後再加入任務。',
			'error.alreadyInTask.title' => '您已是成員',
			'error.alreadyInTask.message' => '您已經在這個任務中了。',
			'error.unknown.title' => '發生錯誤',
			'error.unknown.message' => '發生未預期的錯誤，請稍後再試。',
			_ => null,
		};
	}
}
