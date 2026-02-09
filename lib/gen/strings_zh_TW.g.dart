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
	late final TranslationsS10HomeTaskListZhTw S10_Home_TaskList = TranslationsS10HomeTaskListZhTw.internal(_root);
	late final TranslationsS11InviteConfirmZhTw S11_Invite_Confirm = TranslationsS11InviteConfirmZhTw.internal(_root);
	late final TranslationsS12TaskCloseNoticeZhTw S12_TaskClose_Notice = TranslationsS12TaskCloseNoticeZhTw.internal(_root);
	late final TranslationsS13TaskDashboardZhTw S13_Task_Dashboard = TranslationsS13TaskDashboardZhTw.internal(_root);
	late final TranslationsS14TaskSettingsZhTw S14_Task_Settings = TranslationsS14TaskSettingsZhTw.internal(_root);
	late final TranslationsS15RecordEditZhTw S15_Record_Edit = TranslationsS15RecordEditZhTw.internal(_root);
	late final TranslationsS16TaskCreateEditZhTw S16_TaskCreate_Edit = TranslationsS16TaskCreateEditZhTw.internal(_root);
	late final TranslationsS17TaskLockedZhTw S17_Task_Locked = TranslationsS17TaskLockedZhTw.internal(_root);
	late final TranslationsS30SettlementConfirmZhTw S30_settlement_confirm = TranslationsS30SettlementConfirmZhTw.internal(_root);
	late final TranslationsS31SettlementPaymentInfoZhTw S31_settlement_payment_info = TranslationsS31SettlementPaymentInfoZhTw.internal(_root);
	late final TranslationsS32SettlementResultZhTw S32_settlement_result = TranslationsS32SettlementResultZhTw.internal(_root);
	late final TranslationsS50OnboardingConsentZhTw S50_Onboarding_Consent = TranslationsS50OnboardingConsentZhTw.internal(_root);
	late final TranslationsS51OnboardingNameZhTw S51_Onboarding_Name = TranslationsS51OnboardingNameZhTw.internal(_root);
	late final TranslationsS52TaskSettingsLogZhTw S52_TaskSettings_Log = TranslationsS52TaskSettingsLogZhTw.internal(_root);
	late final TranslationsS53TaskSettingsMembersZhTw S53_TaskSettings_Members = TranslationsS53TaskSettingsMembersZhTw.internal(_root);
	late final TranslationsS71SystemSettingsTosZhTw S71_SystemSettings_Tos = TranslationsS71SystemSettingsTosZhTw.internal(_root);
	late final TranslationsD01MemberRoleIntroZhTw D01_MemberRole_Intro = TranslationsD01MemberRoleIntroZhTw.internal(_root);
	late final TranslationsD02InviteResultZhTw D02_Invite_Result = TranslationsD02InviteResultZhTw.internal(_root);
	late final TranslationsD03TaskCreateConfirmZhTw D03_TaskCreate_Confirm = TranslationsD03TaskCreateConfirmZhTw.internal(_root);
	late final TranslationsD04CommonUnsavedConfirmZhTw D04_CommonUnsaved_Confirm = TranslationsD04CommonUnsavedConfirmZhTw.internal(_root);
	late final TranslationsD05DateJumpNoResultZhTw D05_DateJump_NoResult = TranslationsD05DateJumpNoResultZhTw.internal(_root);
	late final TranslationsD06SettlementConfirmZhTw D06_settlement_confirm = TranslationsD06SettlementConfirmZhTw.internal(_root);
	late final TranslationsD08TaskClosedConfirmZhTw D08_TaskClosed_Confirm = TranslationsD08TaskClosedConfirmZhTw.internal(_root);
	late final TranslationsD09TaskSettingsCurrencyConfirmZhTw D09_TaskSettings_CurrencyConfirm = TranslationsD09TaskSettingsCurrencyConfirmZhTw.internal(_root);
	late final TranslationsD10RecordDeleteConfirmZhTw D10_RecordDelete_Confirm = TranslationsD10RecordDeleteConfirmZhTw.internal(_root);
	late final TranslationsD11RandomResultZhTw D11_random_result = TranslationsD11RandomResultZhTw.internal(_root);
	late final TranslationsB02SplitExpenseEditZhTw B02_SplitExpense_Edit = TranslationsB02SplitExpenseEditZhTw.internal(_root);
	late final TranslationsB03SplitMethodEditZhTw B03_SplitMethod_Edit = TranslationsB03SplitMethodEditZhTw.internal(_root);
	late final TranslationsB04PaymentMergeZhTw B04_payment_merge = TranslationsB04PaymentMergeZhTw.internal(_root);
	late final TranslationsB06PaymentInfoDetailZhTw B06_payment_info_detail = TranslationsB06PaymentInfoDetailZhTw.internal(_root);
	late final TranslationsB07PaymentMethodEditZhTw B07_PaymentMethod_Edit = TranslationsB07PaymentMethodEditZhTw.internal(_root);
	late final TranslationsErrorZhTw error = TranslationsErrorZhTw.internal(_root);
}

// Path: common
class TranslationsCommonZhTw {
	TranslationsCommonZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonButtonsZhTw buttons = TranslationsCommonButtonsZhTw.internal(_root);
	late final TranslationsCommonErrorZhTw error = TranslationsCommonErrorZhTw.internal(_root);
	late final TranslationsCommonCategoryZhTw category = TranslationsCommonCategoryZhTw.internal(_root);
	late final TranslationsCommonCurrencyZhTw currency = TranslationsCommonCurrencyZhTw.internal(_root);
	late final TranslationsCommonRemainderRuleZhTw remainder_rule = TranslationsCommonRemainderRuleZhTw.internal(_root);
	late final TranslationsCommonSplitMethodZhTw split_method = TranslationsCommonSplitMethodZhTw.internal(_root);
	late final TranslationsCommonPaymentInfoZhTw payment_info = TranslationsCommonPaymentInfoZhTw.internal(_root);
	late final TranslationsCommonPaymentStatusZhTw payment_status = TranslationsCommonPaymentStatusZhTw.internal(_root);
	late final TranslationsCommonShareZhTw share = TranslationsCommonShareZhTw.internal(_root);

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

	/// zh-TW: '已結算'
	String get label_settlement => '已結算';
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
	String get title => '任務主頁';

	late final TranslationsS13TaskDashboardButtonsZhTw buttons = TranslationsS13TaskDashboardButtonsZhTw.internal(_root);
	late final TranslationsS13TaskDashboardTabZhTw tab = TranslationsS13TaskDashboardTabZhTw.internal(_root);
	late final TranslationsS13TaskDashboardLabelZhTw label = TranslationsS13TaskDashboardLabelZhTw.internal(_root);
	late final TranslationsS13TaskDashboardEmptyZhTw empty = TranslationsS13TaskDashboardEmptyZhTw.internal(_root);

	/// zh-TW: '支出'
	String get daily_expense_label => '支出';

	/// zh-TW: '收支幣別明細'
	String get dialog_balance_detail => '收支幣別明細';

	late final TranslationsS13TaskDashboardSectionZhTw section = TranslationsS13TaskDashboardSectionZhTw.internal(_root);
}

// Path: S14_Task_Settings
class TranslationsS14TaskSettingsZhTw {
	TranslationsS14TaskSettingsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務設定'
	String get title => '任務設定';

	late final TranslationsS14TaskSettingsSectionZhTw section = TranslationsS14TaskSettingsSectionZhTw.internal(_root);
	late final TranslationsS14TaskSettingsMenuZhTw menu = TranslationsS14TaskSettingsMenuZhTw.internal(_root);
}

// Path: S15_Record_Edit
class TranslationsS15RecordEditZhTw {
	TranslationsS15RecordEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsS15RecordEditTitleZhTw title = TranslationsS15RecordEditTitleZhTw.internal(_root);
	late final TranslationsS15RecordEditButtonsZhTw buttons = TranslationsS15RecordEditButtonsZhTw.internal(_root);
	late final TranslationsS15RecordEditSectionZhTw section = TranslationsS15RecordEditSectionZhTw.internal(_root);
	late final TranslationsS15RecordEditValZhTw val = TranslationsS15RecordEditValZhTw.internal(_root);
	late final TranslationsS15RecordEditTabZhTw tab = TranslationsS15RecordEditTabZhTw.internal(_root);

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

	late final TranslationsS15RecordEditRateDialogZhTw rate_dialog = TranslationsS15RecordEditRateDialogZhTw.internal(_root);
	late final TranslationsS15RecordEditLabelZhTw label = TranslationsS15RecordEditLabelZhTw.internal(_root);
	late final TranslationsS15RecordEditHintZhTw hint = TranslationsS15RecordEditHintZhTw.internal(_root);
}

// Path: S16_TaskCreate_Edit
class TranslationsS16TaskCreateEditZhTw {
	TranslationsS16TaskCreateEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增任務'
	String get title => '新增任務';

	late final TranslationsS16TaskCreateEditButtonsZhTw buttons = TranslationsS16TaskCreateEditButtonsZhTw.internal(_root);
	late final TranslationsS16TaskCreateEditSectionZhTw section = TranslationsS16TaskCreateEditSectionZhTw.internal(_root);
	late final TranslationsS16TaskCreateEditLabelZhTw label = TranslationsS16TaskCreateEditLabelZhTw.internal(_root);
	late final TranslationsS16TaskCreateEditHintZhTw hint = TranslationsS16TaskCreateEditHintZhTw.internal(_root);
}

// Path: S17_Task_Locked
class TranslationsS17TaskLockedZhTw {
	TranslationsS17TaskLockedZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsS17TaskLockedButtonsZhTw buttons = TranslationsS17TaskLockedButtonsZhTw.internal(_root);

	/// zh-TW: '資料將於 {days} 天後自動刪除。請在期間內下載您的紀錄'
	String retention_notice({required Object days}) => '資料將於 ${days} 天後自動刪除。請在期間內下載您的紀錄';

	/// zh-TW: '由 {name} 吸收'
	String label_remainder_absorbed_by({required Object name}) => '由 ${name} 吸收';

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

// Path: S30_settlement_confirm
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

// Path: S31_settlement_payment_info
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

// Path: S32_settlement_result
class TranslationsS32SettlementResultZhTw {
	TranslationsS32SettlementResultZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結算成功'
	String get title => '結算成功';

	/// zh-TW: '所有帳目已核對無誤。請將結果分享給成員以進行付款。'
	String get content => '所有帳目已核對無誤。請將結果分享給成員以進行付款。';

	/// zh-TW: '等待揭曉...'
	String get waiting_reveal => '等待揭曉...';

	/// zh-TW: '餘額歸屬：'
	String get remainder_winner_prefix => '餘額歸屬：';

	/// zh-TW: '{winnerName}總金額變更至{prefix} {total}'
	String remainder_winner_total({required Object winnerName, required Object prefix, required Object total}) => '${winnerName}總金額變更至${prefix} ${total}';

	/// zh-TW: '本次結算總額'
	String get total_label => '本次結算總額';

	late final TranslationsS32SettlementResultButtonsZhTw buttons = TranslationsS32SettlementResultButtonsZhTw.internal(_root);
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
}

// Path: D04_CommonUnsaved_Confirm
class TranslationsD04CommonUnsavedConfirmZhTw {
	TranslationsD04CommonUnsavedConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '尚未儲存'
	String get title => '尚未儲存';

	/// zh-TW: '變更將不會被儲存，確定要離開嗎？'
	String get content => '變更將不會被儲存，確定要離開嗎？';
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

// Path: D06_settlement_confirm
class TranslationsD06SettlementConfirmZhTw {
	TranslationsD06SettlementConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結算確認'
	String get title => '結算確認';

	/// zh-TW: '結算後任務將立即鎖定，無法再新增、刪除或編輯任何紀錄。 請確認所有帳目皆已核對無誤。'
	String get warning_text => '結算後任務將立即鎖定，無法再新增、刪除或編輯任何紀錄。\n請確認所有帳目皆已核對無誤。';

	late final TranslationsD06SettlementConfirmButtonsZhTw buttons = TranslationsD06SettlementConfirmButtonsZhTw.internal(_root);
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

// Path: D11_random_result
class TranslationsD11RandomResultZhTw {
	TranslationsD11RandomResultZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '餘額輪盤得主'
	String get title => '餘額輪盤得主';

	/// zh-TW: '略過'
	String get skip => '略過';

	/// zh-TW: '就是你了！'
	String get winner_reveal => '就是你了！';

	late final TranslationsD11RandomResultButtonsZhTw buttons = TranslationsD11RandomResultButtonsZhTw.internal(_root);
}

// Path: B02_SplitExpense_Edit
class TranslationsB02SplitExpenseEditZhTw {
	TranslationsB02SplitExpenseEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '編輯細項'
	String get title => '編輯細項';

	late final TranslationsB02SplitExpenseEditButtonsZhTw buttons = TranslationsB02SplitExpenseEditButtonsZhTw.internal(_root);
	late final TranslationsB02SplitExpenseEditLabelZhTw label = TranslationsB02SplitExpenseEditLabelZhTw.internal(_root);

	/// zh-TW: '項目名稱尚未輸入'
	String get item_name_empty => '項目名稱尚未輸入';

	late final TranslationsB02SplitExpenseEditHintZhTw hint = TranslationsB02SplitExpenseEditHintZhTw.internal(_root);
}

// Path: B03_SplitMethod_Edit
class TranslationsB03SplitMethodEditZhTw {
	TranslationsB03SplitMethodEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '選擇分攤方式'
	String get title => '選擇分攤方式';

	late final TranslationsB03SplitMethodEditButtonsZhTw buttons = TranslationsB03SplitMethodEditButtonsZhTw.internal(_root);
	late final TranslationsB03SplitMethodEditLabelZhTw label = TranslationsB03SplitMethodEditLabelZhTw.internal(_root);

	/// zh-TW: '金額不符'
	String get mismatch => '金額不符';
}

// Path: B04_payment_merge
class TranslationsB04PaymentMergeZhTw {
	TranslationsB04PaymentMergeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '合併成員款項'
	String get title => '合併成員款項';

	late final TranslationsB04PaymentMergeLabelZhTw label = TranslationsB04PaymentMergeLabelZhTw.internal(_root);
	late final TranslationsB04PaymentMergeButtonsZhTw buttons = TranslationsB04PaymentMergeButtonsZhTw.internal(_root);
}

// Path: B06_payment_info_detail
class TranslationsB06PaymentInfoDetailZhTw {
	TranslationsB06PaymentInfoDetailZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '已複製到剪貼簿'
	String get label_copied => '已複製到剪貼簿';

	late final TranslationsB06PaymentInfoDetailButtonsZhTw buttons = TranslationsB06PaymentInfoDetailButtonsZhTw.internal(_root);
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
	late final TranslationsErrorDialogZhTw dialog = TranslationsErrorDialogZhTw.internal(_root);
	late final TranslationsErrorSettlementZhTw settlement = TranslationsErrorSettlementZhTw.internal(_root);
	late final TranslationsErrorMessageZhTw message = TranslationsErrorMessageZhTw.internal(_root);
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

	/// zh-TW: '確定'
	String get ok => '確定';

	/// zh-TW: '重新整理'
	String get refresh => '重新整理';

	/// zh-TW: '重試'
	String get retry => '重試';
}

// Path: common.error
class TranslationsCommonErrorZhTw {
	TranslationsCommonErrorZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '錯誤'
	String get title => '錯誤';

	/// zh-TW: '發生未知錯誤: {error}'
	String unknown({required Object error}) => '發生未知錯誤: ${error}';
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

	late final TranslationsCommonRemainderRuleRuleZhTw rule = TranslationsCommonRemainderRuleRuleZhTw.internal(_root);
	late final TranslationsCommonRemainderRuleDescriptionZhTw description = TranslationsCommonRemainderRuleDescriptionZhTw.internal(_root);

	/// zh-TW: '零頭 {amount} 將存入零頭罐,結算時分配'
	String message_remainder({required Object amount}) => '零頭 ${amount} 將存入零頭罐,結算時分配';
}

// Path: common.split_method
class TranslationsCommonSplitMethodZhTw {
	TranslationsCommonSplitMethodZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '平均分攤'
	String get even => '平均分攤';

	/// zh-TW: '比例分攤'
	String get percent => '比例分攤';

	/// zh-TW: '指定金額'
	String get exact => '指定金額';
}

// Path: common.payment_info
class TranslationsCommonPaymentInfoZhTw {
	TranslationsCommonPaymentInfoZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonPaymentInfoModeZhTw mode = TranslationsCommonPaymentInfoModeZhTw.internal(_root);
	late final TranslationsCommonPaymentInfoDescriptionZhTw description = TranslationsCommonPaymentInfoDescriptionZhTw.internal(_root);
	late final TranslationsCommonPaymentInfoTypeZhTw type = TranslationsCommonPaymentInfoTypeZhTw.internal(_root);
	late final TranslationsCommonPaymentInfoLabelZhTw label = TranslationsCommonPaymentInfoLabelZhTw.internal(_root);
	late final TranslationsCommonPaymentInfoHintZhTw hint = TranslationsCommonPaymentInfoHintZhTw.internal(_root);
}

// Path: common.payment_status
class TranslationsCommonPaymentStatusZhTw {
	TranslationsCommonPaymentStatusZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '應付'
	String get payable => '應付';

	/// zh-TW: '可退'
	String get receivable => '可退';
}

// Path: common.share
class TranslationsCommonShareZhTw {
	TranslationsCommonShareZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonShareInviteZhTw invite = TranslationsCommonShareInviteZhTw.internal(_root);
	late final TranslationsCommonShareSettlementZhTw settlement = TranslationsCommonShareSettlementZhTw.internal(_root);
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

	/// zh-TW: '新增紀錄'
	String get record => '新增紀錄';

	/// zh-TW: '結算'
	String get settlement => '結算';

	/// zh-TW: '下載記錄'
	String get download => '下載記錄';

	/// zh-TW: '新增'
	String get add => '新增';
}

// Path: S13_Task_Dashboard.tab
class TranslationsS13TaskDashboardTabZhTw {
	TranslationsS13TaskDashboardTabZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '群組'
	String get group => '群組';

	/// zh-TW: '個人'
	String get personal => '個人';
}

// Path: S13_Task_Dashboard.label
class TranslationsS13TaskDashboardLabelZhTw {
	TranslationsS13TaskDashboardLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '總費用'
	String get total_expense => '總費用';

	/// zh-TW: '總預收'
	String get total_prepay => '總預收';

	/// zh-TW: '總費用'
	String get total_expense_personal => '總費用';

	/// zh-TW: '總預收（含代墊）'
	String get total_prepay_personal => '總預收（含代墊）';
}

// Path: S13_Task_Dashboard.empty
class TranslationsS13TaskDashboardEmptyZhTw {
	TranslationsS13TaskDashboardEmptyZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '尚無收支紀錄'
	String get records => '尚無收支紀錄';

	/// zh-TW: '無有關紀錄'
	String get personal_records => '無有關紀錄';
}

// Path: S13_Task_Dashboard.section
class TranslationsS13TaskDashboardSectionZhTw {
	TranslationsS13TaskDashboardSectionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '支出明細'
	String get expense => '支出明細';

	/// zh-TW: '預收明細'
	String get income => '預收明細';

	/// zh-TW: '預收餘額'
	String get prepay_balance => '預收餘額';
}

// Path: S14_Task_Settings.section
class TranslationsS14TaskSettingsSectionZhTw {
	TranslationsS14TaskSettingsSectionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務名稱'
	String get task_name => '任務名稱';

	/// zh-TW: '任務期間'
	String get task_period => '任務期間';

	/// zh-TW: '結算設定'
	String get settlement => '結算設定';

	/// zh-TW: '其他設定'
	String get other => '其他設定';
}

// Path: S14_Task_Settings.menu
class TranslationsS14TaskSettingsMenuZhTw {
	TranslationsS14TaskSettingsMenuZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '成員設定'
	String get member_settings => '成員設定';

	/// zh-TW: '歷史紀錄'
	String get history => '歷史紀錄';

	/// zh-TW: '結束任務'
	String get close_task => '結束任務';
}

// Path: S15_Record_Edit.title
class TranslationsS15RecordEditTitleZhTw {
	TranslationsS15RecordEditTitleZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增紀錄'
	String get add => '新增紀錄';

	/// zh-TW: '編輯紀錄'
	String get edit => '編輯紀錄';
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

	/// zh-TW: '新增細項'
	String get add_item => '新增細項';
}

// Path: S15_Record_Edit.section
class TranslationsS15RecordEditSectionZhTw {
	TranslationsS15RecordEditSectionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '分攤資訊'
	String get split => '分攤資訊';

	/// zh-TW: '細項分拆'
	String get items => '細項分拆';
}

// Path: S15_Record_Edit.val
class TranslationsS15RecordEditValZhTw {
	TranslationsS15RecordEditValZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '預收'
	String get prepay => '預收';

	/// zh-TW: '{name} 先付'
	String member_paid({required Object name}) => '${name} 先付';

	/// zh-TW: '細項分拆'
	String get split_details => '細項分拆';

	/// zh-TW: '總計 {amount} 由 {method} 分攤'
	String split_summary({required Object amount, required Object method}) => '總計 ${amount} 由 ${method} 分攤';

	/// zh-TW: '≈ {base}{symbol} {amount}'
	String converted_amount({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}';

	/// zh-TW: '剩餘金額'
	String get split_remaining => '剩餘金額';

	/// zh-TW: '細項說明'
	String get mock_note => '細項說明';
}

// Path: S15_Record_Edit.tab
class TranslationsS15RecordEditTabZhTw {
	TranslationsS15RecordEditTabZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '費用'
	String get expense => '費用';

	/// zh-TW: '預收'
	String get income => '預收';
}

// Path: S15_Record_Edit.rate_dialog
class TranslationsS15RecordEditRateDialogZhTw {
	TranslationsS15RecordEditRateDialogZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '匯率來源'
	String get title => '匯率來源';

	/// zh-TW: '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。'
	String get message => '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。';
}

// Path: S15_Record_Edit.label
class TranslationsS15RecordEditLabelZhTw {
	TranslationsS15RecordEditLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '日期'
	String get date => '日期';

	/// zh-TW: '項目名稱'
	String get title => '項目名稱';

	/// zh-TW: '支付方式'
	String get payment_method => '支付方式';

	/// zh-TW: '金額'
	String get amount => '金額';

	/// zh-TW: '匯率 (1 {base} = ? {target})'
	String rate_with_base({required Object base, required Object target}) => '匯率 (1 ${base} = ? ${target})';

	/// zh-TW: '匯率'
	String get rate => '匯率';

	/// zh-TW: '備註'
	String get memo => '備註';
}

// Path: S15_Record_Edit.hint
class TranslationsS15RecordEditHintZhTw {
	TranslationsS15RecordEditHintZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsS15RecordEditHintCategoryZhTw category = TranslationsS15RecordEditHintCategoryZhTw.internal(_root);

	/// zh-TW: '例：{category}'
	String item({required Object category}) => '例：${category}';

	/// zh-TW: '例：備註事項'
	String get memo => '例：備註事項';
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

// Path: S16_TaskCreate_Edit.section
class TranslationsS16TaskCreateEditSectionZhTw {
	TranslationsS16TaskCreateEditSectionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務名稱'
	String get task_name => '任務名稱';

	/// zh-TW: '任務期間'
	String get task_period => '任務期間';

	/// zh-TW: '結算設定'
	String get settlement => '結算設定';
}

// Path: S16_TaskCreate_Edit.label
class TranslationsS16TaskCreateEditLabelZhTw {
	TranslationsS16TaskCreateEditLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務名稱'
	String get name => '任務名稱';

	/// zh-TW: '{current}/{max}'
	String name_counter({required Object current, required Object max}) => '${current}/${max}';

	/// zh-TW: '開始日期'
	String get start_date => '開始日期';

	/// zh-TW: '結束日期'
	String get end_date => '結束日期';

	/// zh-TW: '結算幣別'
	String get currency => '結算幣別';

	/// zh-TW: '參加人數'
	String get member_count => '參加人數';

	/// zh-TW: '日期'
	String get date => '日期';
}

// Path: S16_TaskCreate_Edit.hint
class TranslationsS16TaskCreateEditHintZhTw {
	TranslationsS16TaskCreateEditHintZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '例：東京五日遊'
	String get name => '例：東京五日遊';
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

// Path: S30_settlement_confirm.buttons
class TranslationsS30SettlementConfirmButtonsZhTw {
	TranslationsS30SettlementConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '收款設定'
	String get next => '收款設定';
}

// Path: S30_settlement_confirm.steps
class TranslationsS30SettlementConfirmStepsZhTw {
	TranslationsS30SettlementConfirmStepsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認金額'
	String get confirm_amount => '確認金額';

	/// zh-TW: '收款設定'
	String get payment_info => '收款設定';
}

// Path: S30_settlement_confirm.warning
class TranslationsS30SettlementConfirmWarningZhTw {
	TranslationsS30SettlementConfirmWarningZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '餘額將於下一步結算完成後揭曉！'
	String get random_reveal => '餘額將於下一步結算完成後揭曉！';
}

// Path: S30_settlement_confirm.list_item
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

// Path: S31_settlement_payment_info.buttons
class TranslationsS31SettlementPaymentInfoButtonsZhTw {
	TranslationsS31SettlementPaymentInfoButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結算'
	String get settle => '結算';

	/// zh-TW: '上一步'
	String get prev_step => '上一步';
}

// Path: S32_settlement_result.buttons
class TranslationsS32SettlementResultButtonsZhTw {
	TranslationsS32SettlementResultButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '發送結算通知'
	String get share => '發送結算通知';

	/// zh-TW: '返回任務首頁'
	String get back => '返回任務首頁';
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

// Path: D06_settlement_confirm.buttons
class TranslationsD06SettlementConfirmButtonsZhTw {
	TranslationsD06SettlementConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確定結算'
	String get confirm => '確定結算';
}

// Path: D08_TaskClosed_Confirm.buttons
class TranslationsD08TaskClosedConfirmButtonsZhTw {
	TranslationsD08TaskClosedConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認'
	String get confirm => '確認';
}

// Path: D11_random_result.buttons
class TranslationsD11RandomResultButtonsZhTw {
	TranslationsD11RandomResultButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確定'
	String get close => '確定';
}

// Path: B02_SplitExpense_Edit.buttons
class TranslationsB02SplitExpenseEditButtonsZhTw {
	TranslationsB02SplitExpenseEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認分拆'
	String get save => '確認分拆';
}

// Path: B02_SplitExpense_Edit.label
class TranslationsB02SplitExpenseEditLabelZhTw {
	TranslationsB02SplitExpenseEditLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '細項名稱'
	String get sub_item => '細項名稱';

	/// zh-TW: '分攤設定'
	String get split_method => '分攤設定';
}

// Path: B02_SplitExpense_Edit.hint
class TranslationsB02SplitExpenseEditHintZhTw {
	TranslationsB02SplitExpenseEditHintZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '例：子項目'
	String get sub_item => '例：子項目';
}

// Path: B03_SplitMethod_Edit.buttons
class TranslationsB03SplitMethodEditButtonsZhTw {
	TranslationsB03SplitMethodEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '調整權重'
	String get adjust_weight => '調整權重';
}

// Path: B03_SplitMethod_Edit.label
class TranslationsB03SplitMethodEditLabelZhTw {
	TranslationsB03SplitMethodEditLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '{current} / {target}'
	String total({required Object current, required Object target}) => '${current} / ${target}';
}

// Path: B04_payment_merge.label
class TranslationsB04PaymentMergeLabelZhTw {
	TranslationsB04PaymentMergeLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '代表'
	String get head_member => '代表';

	/// zh-TW: '合併總額'
	String get merge_amount => '合併總額';
}

// Path: B04_payment_merge.buttons
class TranslationsB04PaymentMergeButtonsZhTw {
	TranslationsB04PaymentMergeButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '取消'
	String get cancel => '取消';

	/// zh-TW: '合併'
	String get confirm => '合併';
}

// Path: B06_payment_info_detail.buttons
class TranslationsB06PaymentInfoDetailButtonsZhTw {
	TranslationsB06PaymentInfoDetailButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '複製'
	String get copy => '複製';
}

// Path: error.dialog
class TranslationsErrorDialogZhTw {
	TranslationsErrorDialogZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsErrorDialogTaskFullZhTw task_full = TranslationsErrorDialogTaskFullZhTw.internal(_root);
	late final TranslationsErrorDialogExpiredCodeZhTw expired_code = TranslationsErrorDialogExpiredCodeZhTw.internal(_root);
	late final TranslationsErrorDialogInvalidCodeZhTw invalid_code = TranslationsErrorDialogInvalidCodeZhTw.internal(_root);
	late final TranslationsErrorDialogAuthRequiredZhTw auth_required = TranslationsErrorDialogAuthRequiredZhTw.internal(_root);
	late final TranslationsErrorDialogAlreadyInTaskZhTw already_in_task = TranslationsErrorDialogAlreadyInTaskZhTw.internal(_root);
	late final TranslationsErrorDialogUnknownZhTw unknown = TranslationsErrorDialogUnknownZhTw.internal(_root);
	late final TranslationsErrorDialogDeleteFailedZhTw delete_failed = TranslationsErrorDialogDeleteFailedZhTw.internal(_root);
	late final TranslationsErrorDialogMemberDeleteFailedZhTw member_delete_failed = TranslationsErrorDialogMemberDeleteFailedZhTw.internal(_root);
	late final TranslationsErrorDialogDataConflictZhTw data_conflict = TranslationsErrorDialogDataConflictZhTw.internal(_root);
}

// Path: error.settlement
class TranslationsErrorSettlementZhTw {
	TranslationsErrorSettlementZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '此任務狀態異常（可能已被結算），請刷新頁面。'
	String get status_invalid => '此任務狀態異常（可能已被結算），請刷新頁面。';

	/// zh-TW: '只有建立者可以執行結算。'
	String get permission_denied => '只有建立者可以執行結算。';

	/// zh-TW: '系統錯誤，結算失敗，請稍後再試。'
	String get transaction_failed => '系統錯誤，結算失敗，請稍後再試。';
}

// Path: error.message
class TranslationsErrorMessageZhTw {
	TranslationsErrorMessageZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '發生未預期的錯誤'
	String get unknown => '發生未預期的錯誤';

	/// zh-TW: '金額無效'
	String get invalid_amount => '金額無效';

	/// zh-TW: '此欄位為必填'
	String get required => '此欄位為必填';

	/// zh-TW: '請輸入{key}'
	String empty({required Object key}) => '請輸入${key}';

	/// zh-TW: '格式錯誤'
	String get format => '格式錯誤';

	/// zh-TW: '{key}不可為 0'
	String zero({required Object key}) => '${key}不可為 0';

	/// zh-TW: '剩餘金額不足'
	String get amount_not_enough => '剩餘金額不足';

	/// zh-TW: '金額不符'
	String get amount_mismatch => '金額不符';

	/// zh-TW: '此款項已被使用'
	String get income_is_used => '此款項已被使用';

	/// zh-TW: '權限不足'
	String get permission_denied => '權限不足';

	/// zh-TW: '網路連線異常，請稍後再試'
	String get network_error => '網路連線異常，請稍後再試';

	/// zh-TW: '找不到資料，請稍後再試'
	String get data_not_found => '找不到資料，請稍後再試';

	/// zh-TW: '載入失敗，請稍後再試'
	String get load_failed => '載入失敗，請稍後再試';

	/// zh-TW: '請先輸入{key}'
	String enter_first({required Object key}) => '請先輸入${key}';

	/// zh-TW: '儲存失敗，請稍後再試'
	String get save_failed => '儲存失敗，請稍後再試';

	/// zh-TW: '刪除失敗，請稍後再試'
	String get delete_failed => '刪除失敗，請稍後再試';

	/// zh-TW: '為替レートの更新失敗'
	String get rate_fetch_failed => '為替レートの更新失敗';
}

// Path: common.remainder_rule.rule
class TranslationsCommonRemainderRuleRuleZhTw {
	TranslationsCommonRemainderRuleRuleZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '隨機指定'
	String get random => '隨機指定';

	/// zh-TW: '順序輪替'
	String get order => '順序輪替';

	/// zh-TW: '指定成員'
	String get member => '指定成員';
}

// Path: common.remainder_rule.description
class TranslationsCommonRemainderRuleDescriptionZhTw {
	TranslationsCommonRemainderRuleDescriptionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '零頭 {amount} 源自於匯率換算或分攤計算時產生的微小差額。'
	String remainder({required Object amount}) => '零頭 ${amount} 源自於匯率換算或分攤計算時產生的微小差額。';

	/// zh-TW: '系統將在每次結算時，隨機挑選一位幸運兒來吸收所有零頭。'
	String get random => '系統將在每次結算時，隨機挑選一位幸運兒來吸收所有零頭。';

	/// zh-TW: '依照成員加入的順序，將零頭依序分配，直到分完為止。'
	String get order => '依照成員加入的順序，將零頭依序分配，直到分完為止。';

	/// zh-TW: '指定一位特定的成員，固定由他/她來吸收所有的零頭。'
	String get member => '指定一位特定的成員，固定由他/她來吸收所有的零頭。';
}

// Path: common.payment_info.mode
class TranslationsCommonPaymentInfoModeZhTw {
	TranslationsCommonPaymentInfoModeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '請直接私訊聯絡'
	String get private => '請直接私訊聯絡';

	/// zh-TW: '提供收款資訊'
	String get public => '提供收款資訊';
}

// Path: common.payment_info.description
class TranslationsCommonPaymentInfoDescriptionZhTw {
	TranslationsCommonPaymentInfoDescriptionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '不顯示詳細資訊，請成員直接找你'
	String get private => '不顯示詳細資訊，請成員直接找你';

	/// zh-TW: '顯示收款資訊給成員'
	String get public => '顯示收款資訊給成員';
}

// Path: common.payment_info.type
class TranslationsCommonPaymentInfoTypeZhTw {
	TranslationsCommonPaymentInfoTypeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '現金'
	String get cash => '現金';

	/// zh-TW: '銀行轉帳'
	String get bank => '銀行轉帳';

	/// zh-TW: '其他支付 App'
	String get apps => '其他支付 App';
}

// Path: common.payment_info.label
class TranslationsCommonPaymentInfoLabelZhTw {
	TranslationsCommonPaymentInfoLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '銀行代碼 / 名稱'
	String get bank_name => '銀行代碼 / 名稱';

	/// zh-TW: '帳號'
	String get bank_account => '帳號';

	/// zh-TW: 'App 名稱'
	String get app_name => 'App 名稱';

	/// zh-TW: '連結 / ID'
	String get app_link => '連結 / ID';
}

// Path: common.payment_info.hint
class TranslationsCommonPaymentInfoHintZhTw {
	TranslationsCommonPaymentInfoHintZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '例：004-台灣銀行'
	String get bank_name => '例：004-台灣銀行';

	/// zh-TW: '例：123-456-789012'
	String get bank_account => '例：123-456-789012';

	/// zh-TW: '例：LinePay'
	String get app_name => '例：LinePay';

	/// zh-TW: '例：lineid12345'
	String get app_link => '例：lineid12345';
}

// Path: common.share.invite
class TranslationsCommonShareInviteZhTw {
	TranslationsCommonShareInviteZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '邀請加入 Iron Split 任務'
	String get subject => '邀請加入 Iron Split 任務';

	/// zh-TW: '快來加入我的 Iron Split 任務「{taskName}」！ 邀請碼：{code} 連結：{link}'
	String message({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「${taskName}」！\n邀請碼：${code}\n連結：${link}';
}

// Path: common.share.settlement
class TranslationsCommonShareSettlementZhTw {
	TranslationsCommonShareSettlementZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: 'Iron Split 任務結算通知'
	String get subject => 'Iron Split 任務結算通知';

	/// zh-TW: '結算已完成！ 請開啟 Iron Split App 確認「{taskName}」您的支付金額。 連結：{link}'
	String message({required Object taskName, required Object link}) => '結算已完成！\n請開啟 Iron Split App 確認「${taskName}」您的支付金額。\n連結：${link}';
}

// Path: S15_Record_Edit.hint.category
class TranslationsS15RecordEditHintCategoryZhTw {
	TranslationsS15RecordEditHintCategoryZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '晚餐'
	String get food => '晚餐';

	/// zh-TW: '車費'
	String get transport => '車費';

	/// zh-TW: '紀念品'
	String get shopping => '紀念品';

	/// zh-TW: '電影票'
	String get entertainment => '電影票';

	/// zh-TW: '住宿費'
	String get accommodation => '住宿費';

	/// zh-TW: '其他費用'
	String get others => '其他費用';
}

// Path: error.dialog.task_full
class TranslationsErrorDialogTaskFullZhTw {
	TranslationsErrorDialogTaskFullZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務已滿'
	String get title => '任務已滿';

	/// zh-TW: '此任務成員數已達上限 {limit} 人，請聯繫隊長。'
	String message({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。';
}

// Path: error.dialog.expired_code
class TranslationsErrorDialogExpiredCodeZhTw {
	TranslationsErrorDialogExpiredCodeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '邀請碼已過期'
	String get title => '邀請碼已過期';

	/// zh-TW: '此邀請連結已失效（時限 {minutes} 分鐘）。請請隊長重新產生。'
	String message({required Object minutes}) => '此邀請連結已失效（時限 ${minutes} 分鐘）。請請隊長重新產生。';
}

// Path: error.dialog.invalid_code
class TranslationsErrorDialogInvalidCodeZhTw {
	TranslationsErrorDialogInvalidCodeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '連結無效'
	String get title => '連結無效';

	/// zh-TW: '無效的邀請連結，請確認是否正確或已被刪除。'
	String get message => '無效的邀請連結，請確認是否正確或已被刪除。';
}

// Path: error.dialog.auth_required
class TranslationsErrorDialogAuthRequiredZhTw {
	TranslationsErrorDialogAuthRequiredZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '需要登入'
	String get title => '需要登入';

	/// zh-TW: '請先登入後再加入任務。'
	String get message => '請先登入後再加入任務。';
}

// Path: error.dialog.already_in_task
class TranslationsErrorDialogAlreadyInTaskZhTw {
	TranslationsErrorDialogAlreadyInTaskZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '您已是成員'
	String get title => '您已是成員';

	/// zh-TW: '您已經在這個任務中了。'
	String get message => '您已經在這個任務中了。';
}

// Path: error.dialog.unknown
class TranslationsErrorDialogUnknownZhTw {
	TranslationsErrorDialogUnknownZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '發生錯誤'
	String get title => '發生錯誤';

	/// zh-TW: '發生未預期的錯誤，請稍後再試。'
	String get message => '發生未預期的錯誤，請稍後再試。';
}

// Path: error.dialog.delete_failed
class TranslationsErrorDialogDeleteFailedZhTw {
	TranslationsErrorDialogDeleteFailedZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '刪除失敗'
	String get title => '刪除失敗';

	/// zh-TW: '刪除失敗，請稍後再試。'
	String get message => '刪除失敗，請稍後再試。';
}

// Path: error.dialog.member_delete_failed
class TranslationsErrorDialogMemberDeleteFailedZhTw {
	TranslationsErrorDialogMemberDeleteFailedZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '無法刪除成員'
	String get title => '無法刪除成員';

	/// zh-TW: '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。'
	String get message => '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。';
}

// Path: error.dialog.data_conflict
class TranslationsErrorDialogDataConflictZhTw {
	TranslationsErrorDialogDataConflictZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '帳目已變動'
	String get title => '帳目已變動';

	/// zh-TW: '在您檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。'
	String get message => '在您檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。';
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
			'common.buttons.ok' => '確定',
			'common.buttons.refresh' => '重新整理',
			'common.buttons.retry' => '重試',
			'common.error.title' => '錯誤',
			'common.error.unknown' => ({required Object error}) => '發生未知錯誤: ${error}',
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
			'common.remainder_rule.rule.random' => '隨機指定',
			'common.remainder_rule.rule.order' => '順序輪替',
			'common.remainder_rule.rule.member' => '指定成員',
			'common.remainder_rule.description.remainder' => ({required Object amount}) => '零頭 ${amount} 源自於匯率換算或分攤計算時產生的微小差額。',
			'common.remainder_rule.description.random' => '系統將在每次結算時，隨機挑選一位幸運兒來吸收所有零頭。',
			'common.remainder_rule.description.order' => '依照成員加入的順序，將零頭依序分配，直到分完為止。',
			'common.remainder_rule.description.member' => '指定一位特定的成員，固定由他/她來吸收所有的零頭。',
			'common.remainder_rule.message_remainder' => ({required Object amount}) => '零頭 ${amount} 將存入零頭罐,結算時分配',
			'common.split_method.even' => '平均分攤',
			'common.split_method.percent' => '比例分攤',
			'common.split_method.exact' => '指定金額',
			'common.payment_info.mode.private' => '請直接私訊聯絡',
			'common.payment_info.mode.public' => '提供收款資訊',
			'common.payment_info.description.private' => '不顯示詳細資訊，請成員直接找你',
			'common.payment_info.description.public' => '顯示收款資訊給成員',
			'common.payment_info.type.cash' => '現金',
			'common.payment_info.type.bank' => '銀行轉帳',
			'common.payment_info.type.apps' => '其他支付 App',
			'common.payment_info.label.bank_name' => '銀行代碼 / 名稱',
			'common.payment_info.label.bank_account' => '帳號',
			'common.payment_info.label.app_name' => 'App 名稱',
			'common.payment_info.label.app_link' => '連結 / ID',
			'common.payment_info.hint.bank_name' => '例：004-台灣銀行',
			'common.payment_info.hint.bank_account' => '例：123-456-789012',
			'common.payment_info.hint.app_name' => '例：LinePay',
			'common.payment_info.hint.app_link' => '例：lineid12345',
			'common.payment_status.payable' => '應付',
			'common.payment_status.receivable' => '可退',
			'common.share.invite.subject' => '邀請加入 Iron Split 任務',
			'common.share.invite.message' => ({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「${taskName}」！\n邀請碼：${code}\n連結：${link}',
			'common.share.settlement.subject' => 'Iron Split 任務結算通知',
			'common.share.settlement.message' => ({required Object taskName, required Object link}) => '結算已完成！\n請開啟 Iron Split App 確認「${taskName}」您的支付金額。\n連結：${link}',
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
			'S10_Home_TaskList.title' => '我的任務',
			'S10_Home_TaskList.tab_in_progress' => '進行中',
			'S10_Home_TaskList.tab_completed' => '已完成',
			'S10_Home_TaskList.mascot_preparing' => '鐵公雞準備中...',
			'S10_Home_TaskList.empty_in_progress' => '目前沒有進行中的任務',
			'S10_Home_TaskList.empty_completed' => '沒有已完成的任務',
			'S10_Home_TaskList.date_tbd' => '日期未定',
			'S10_Home_TaskList.delete_confirm_title' => '確認刪除',
			'S10_Home_TaskList.delete_confirm_content' => '確定要刪除這個任務嗎？',
			'S10_Home_TaskList.label_settlement' => '已結算',
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
			'S13_Task_Dashboard.title' => '任務主頁',
			'S13_Task_Dashboard.buttons.record' => '新增紀錄',
			'S13_Task_Dashboard.buttons.settlement' => '結算',
			'S13_Task_Dashboard.buttons.download' => '下載記錄',
			'S13_Task_Dashboard.buttons.add' => '新增',
			'S13_Task_Dashboard.tab.group' => '群組',
			'S13_Task_Dashboard.tab.personal' => '個人',
			'S13_Task_Dashboard.label.total_expense' => '總費用',
			'S13_Task_Dashboard.label.total_prepay' => '總預收',
			'S13_Task_Dashboard.label.total_expense_personal' => '總費用',
			'S13_Task_Dashboard.label.total_prepay_personal' => '總預收（含代墊）',
			'S13_Task_Dashboard.empty.records' => '尚無收支紀錄',
			'S13_Task_Dashboard.empty.personal_records' => '無有關紀錄',
			'S13_Task_Dashboard.daily_expense_label' => '支出',
			'S13_Task_Dashboard.dialog_balance_detail' => '收支幣別明細',
			'S13_Task_Dashboard.section.expense' => '支出明細',
			'S13_Task_Dashboard.section.income' => '預收明細',
			'S13_Task_Dashboard.section.prepay_balance' => '預收餘額',
			'S14_Task_Settings.title' => '任務設定',
			'S14_Task_Settings.section.task_name' => '任務名稱',
			'S14_Task_Settings.section.task_period' => '任務期間',
			'S14_Task_Settings.section.settlement' => '結算設定',
			'S14_Task_Settings.section.other' => '其他設定',
			'S14_Task_Settings.menu.member_settings' => '成員設定',
			'S14_Task_Settings.menu.history' => '歷史紀錄',
			'S14_Task_Settings.menu.close_task' => '結束任務',
			'S15_Record_Edit.title.add' => '新增紀錄',
			'S15_Record_Edit.title.edit' => '編輯紀錄',
			'S15_Record_Edit.buttons.save' => '儲存紀錄',
			'S15_Record_Edit.buttons.close' => '關閉',
			'S15_Record_Edit.buttons.add_item' => '新增細項',
			'S15_Record_Edit.section.split' => '分攤資訊',
			'S15_Record_Edit.section.items' => '細項分拆',
			'S15_Record_Edit.val.prepay' => '預收',
			'S15_Record_Edit.val.member_paid' => ({required Object name}) => '${name} 先付',
			'S15_Record_Edit.val.split_details' => '細項分拆',
			'S15_Record_Edit.val.split_summary' => ({required Object amount, required Object method}) => '總計 ${amount} 由 ${method} 分攤',
			'S15_Record_Edit.val.converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			'S15_Record_Edit.val.split_remaining' => '剩餘金額',
			'S15_Record_Edit.val.mock_note' => '細項說明',
			'S15_Record_Edit.tab.expense' => '費用',
			'S15_Record_Edit.tab.income' => '預收',
			'S15_Record_Edit.base_card_title' => '剩餘金額 (Base)',
			'S15_Record_Edit.type_income_title' => '預收款',
			'S15_Record_Edit.base_card_title_expense' => '剩餘金額 (Base)',
			'S15_Record_Edit.base_card_title_income' => '資金來源 (入金者)',
			'S15_Record_Edit.payer_multiple' => '多人',
			'S15_Record_Edit.rate_dialog.title' => '匯率來源',
			'S15_Record_Edit.rate_dialog.message' => '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。',
			'S15_Record_Edit.label.date' => '日期',
			'S15_Record_Edit.label.title' => '項目名稱',
			'S15_Record_Edit.label.payment_method' => '支付方式',
			'S15_Record_Edit.label.amount' => '金額',
			'S15_Record_Edit.label.rate_with_base' => ({required Object base, required Object target}) => '匯率 (1 ${base} = ? ${target})',
			'S15_Record_Edit.label.rate' => '匯率',
			'S15_Record_Edit.label.memo' => '備註',
			'S15_Record_Edit.hint.category.food' => '晚餐',
			'S15_Record_Edit.hint.category.transport' => '車費',
			'S15_Record_Edit.hint.category.shopping' => '紀念品',
			'S15_Record_Edit.hint.category.entertainment' => '電影票',
			'S15_Record_Edit.hint.category.accommodation' => '住宿費',
			'S15_Record_Edit.hint.category.others' => '其他費用',
			'S15_Record_Edit.hint.item' => ({required Object category}) => '例：${category}',
			'S15_Record_Edit.hint.memo' => '例：備註事項',
			'S16_TaskCreate_Edit.title' => '新增任務',
			'S16_TaskCreate_Edit.buttons.save' => '保存',
			'S16_TaskCreate_Edit.buttons.done' => '確定',
			'S16_TaskCreate_Edit.section.task_name' => '任務名稱',
			'S16_TaskCreate_Edit.section.task_period' => '任務期間',
			'S16_TaskCreate_Edit.section.settlement' => '結算設定',
			'S16_TaskCreate_Edit.label.name' => '任務名稱',
			'S16_TaskCreate_Edit.label.name_counter' => ({required Object current, required Object max}) => '${current}/${max}',
			'S16_TaskCreate_Edit.label.start_date' => '開始日期',
			'S16_TaskCreate_Edit.label.end_date' => '結束日期',
			'S16_TaskCreate_Edit.label.currency' => '結算幣別',
			'S16_TaskCreate_Edit.label.member_count' => '參加人數',
			'S16_TaskCreate_Edit.label.date' => '日期',
			'S16_TaskCreate_Edit.hint.name' => '例：東京五日遊',
			'S17_Task_Locked.buttons.download' => '下載紀錄',
			'S17_Task_Locked.buttons.notify_members' => '通知成員',
			'S17_Task_Locked.buttons.view_payment_details' => '查看收退款帳戶',
			'S17_Task_Locked.retention_notice' => ({required Object days}) => '資料將於 ${days} 天後自動刪除。請在期間內下載您的紀錄',
			'S17_Task_Locked.label_remainder_absorbed_by' => ({required Object name}) => '由 ${name} 吸收',
			'S17_Task_Locked.section_pending' => '待處理',
			'S17_Task_Locked.section_cleared' => '已處理',
			'S17_Task_Locked.member_payment_status_pay' => '應付',
			'S17_Task_Locked.member_payment_status_receive' => '應收',
			'S17_Task_Locked.dialog_mark_cleared_title' => '確認收款/付款',
			'S17_Task_Locked.dialog_mark_cleared_content' => ({required Object name}) => '確定將 ${name} 標記為已處理？',
			'S30_settlement_confirm.title' => '結算確認',
			'S30_settlement_confirm.buttons.next' => '收款設定',
			'S30_settlement_confirm.steps.confirm_amount' => '確認金額',
			'S30_settlement_confirm.steps.payment_info' => '收款設定',
			'S30_settlement_confirm.warning.random_reveal' => '餘額將於下一步結算完成後揭曉！',
			'S30_settlement_confirm.label_payable' => '應付',
			'S30_settlement_confirm.label_refund' => '可退',
			'S30_settlement_confirm.list_item.merged_label' => '合併',
			'S30_settlement_confirm.list_item.includes' => '包含：',
			'S30_settlement_confirm.list_item.principal' => '本金',
			'S30_settlement_confirm.list_item.random_remainder' => '隨機餘額',
			'S30_settlement_confirm.list_item.remainder' => '餘額',
			'S31_settlement_payment_info.title' => '收款資訊',
			'S31_settlement_payment_info.setup_instruction' => '收款資訊僅供本次結算使用。預設資料加密儲存於本機。',
			'S31_settlement_payment_info.sync_save' => '儲存為預設收款資訊 (存在手機)',
			'S31_settlement_payment_info.sync_update' => '同步更新我的預設收款資訊',
			'S31_settlement_payment_info.buttons.settle' => '結算',
			'S31_settlement_payment_info.buttons.prev_step' => '上一步',
			'S32_settlement_result.title' => '結算成功',
			'S32_settlement_result.content' => '所有帳目已核對無誤。請將結果分享給成員以進行付款。',
			'S32_settlement_result.waiting_reveal' => '等待揭曉...',
			'S32_settlement_result.remainder_winner_prefix' => '餘額歸屬：',
			'S32_settlement_result.remainder_winner_total' => ({required Object winnerName, required Object prefix, required Object total}) => '${winnerName}總金額變更至${prefix} ${total}',
			'S32_settlement_result.total_label' => '本次結算總額',
			'S32_settlement_result.buttons.share' => '發送結算通知',
			'S32_settlement_result.buttons.back' => '返回任務首頁',
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
			'D04_CommonUnsaved_Confirm.title' => '尚未儲存',
			'D04_CommonUnsaved_Confirm.content' => '變更將不會被儲存，確定要離開嗎？',
			'D05_DateJump_NoResult.title' => '無紀錄',
			'D05_DateJump_NoResult.buttons.cancel' => '返回',
			'D05_DateJump_NoResult.buttons.add' => '新增紀錄',
			'D05_DateJump_NoResult.content' => '找不到此日期的紀錄，要新增一筆嗎？',
			'D06_settlement_confirm.title' => '結算確認',
			'D06_settlement_confirm.warning_text' => '結算後任務將立即鎖定，無法再新增、刪除或編輯任何紀錄。\n請確認所有帳目皆已核對無誤。',
			'D06_settlement_confirm.buttons.confirm' => '確定結算',
			'D08_TaskClosed_Confirm.title' => '確認結束任務',
			'D08_TaskClosed_Confirm.buttons.confirm' => '確認',
			'D08_TaskClosed_Confirm.content' => '此操作無法復原。所有資料將被永久鎖定。\n\n確定要繼續嗎？',
			'D09_TaskSettings_CurrencyConfirm.title' => '變更結算幣別？',
			'D09_TaskSettings_CurrencyConfirm.content' => '變更幣別將會重置所有匯率設定，這可能會影響目前的帳目金額。確定要變更嗎？',
			'D10_RecordDelete_Confirm.delete_record_title' => '刪除紀錄？',
			'D10_RecordDelete_Confirm.delete_record_content' => ({required Object title, required Object amount}) => '確定要刪除 ${title} (${amount}) 嗎？',
			'D10_RecordDelete_Confirm.deleted_success' => '紀錄已刪除',
			'D11_random_result.title' => '餘額輪盤得主',
			'D11_random_result.skip' => '略過',
			'D11_random_result.winner_reveal' => '就是你了！',
			'D11_random_result.buttons.close' => '確定',
			'B02_SplitExpense_Edit.title' => '編輯細項',
			'B02_SplitExpense_Edit.buttons.save' => '確認分拆',
			'B02_SplitExpense_Edit.label.sub_item' => '細項名稱',
			'B02_SplitExpense_Edit.label.split_method' => '分攤設定',
			'B02_SplitExpense_Edit.item_name_empty' => '項目名稱尚未輸入',
			'B02_SplitExpense_Edit.hint.sub_item' => '例：子項目',
			'B03_SplitMethod_Edit.title' => '選擇分攤方式',
			'B03_SplitMethod_Edit.buttons.adjust_weight' => '調整權重',
			'B03_SplitMethod_Edit.label.total' => ({required Object current, required Object target}) => '${current} / ${target}',
			'B03_SplitMethod_Edit.mismatch' => '金額不符',
			'B04_payment_merge.title' => '合併成員款項',
			'B04_payment_merge.label.head_member' => '代表',
			'B04_payment_merge.label.merge_amount' => '合併總額',
			'B04_payment_merge.buttons.cancel' => '取消',
			'B04_payment_merge.buttons.confirm' => '合併',
			'B06_payment_info_detail.label_copied' => '已複製到剪貼簿',
			'B06_payment_info_detail.buttons.copy' => '複製',
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
			'error.dialog.task_full.title' => '任務已滿',
			'error.dialog.task_full.message' => ({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。',
			'error.dialog.expired_code.title' => '邀請碼已過期',
			'error.dialog.expired_code.message' => ({required Object minutes}) => '此邀請連結已失效（時限 ${minutes} 分鐘）。請請隊長重新產生。',
			'error.dialog.invalid_code.title' => '連結無效',
			'error.dialog.invalid_code.message' => '無效的邀請連結，請確認是否正確或已被刪除。',
			'error.dialog.auth_required.title' => '需要登入',
			'error.dialog.auth_required.message' => '請先登入後再加入任務。',
			'error.dialog.already_in_task.title' => '您已是成員',
			'error.dialog.already_in_task.message' => '您已經在這個任務中了。',
			'error.dialog.unknown.title' => '發生錯誤',
			'error.dialog.unknown.message' => '發生未預期的錯誤，請稍後再試。',
			'error.dialog.delete_failed.title' => '刪除失敗',
			'error.dialog.delete_failed.message' => '刪除失敗，請稍後再試。',
			'error.dialog.member_delete_failed.title' => '無法刪除成員',
			'error.dialog.member_delete_failed.message' => '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。',
			'error.dialog.data_conflict.title' => '帳目已變動',
			'error.dialog.data_conflict.message' => '在您檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。',
			'error.settlement.status_invalid' => '此任務狀態異常（可能已被結算），請刷新頁面。',
			'error.settlement.permission_denied' => '只有建立者可以執行結算。',
			'error.settlement.transaction_failed' => '系統錯誤，結算失敗，請稍後再試。',
			'error.message.unknown' => '發生未預期的錯誤',
			'error.message.invalid_amount' => '金額無效',
			'error.message.required' => '此欄位為必填',
			'error.message.empty' => ({required Object key}) => '請輸入${key}',
			'error.message.format' => '格式錯誤',
			'error.message.zero' => ({required Object key}) => '${key}不可為 0',
			'error.message.amount_not_enough' => '剩餘金額不足',
			'error.message.amount_mismatch' => '金額不符',
			'error.message.income_is_used' => '此款項已被使用',
			'error.message.permission_denied' => '權限不足',
			'error.message.network_error' => '網路連線異常，請稍後再試',
			'error.message.data_not_found' => '找不到資料，請稍後再試',
			'error.message.load_failed' => '載入失敗，請稍後再試',
			'error.message.enter_first' => ({required Object key}) => '請先輸入${key}',
			'error.message.save_failed' => '儲存失敗，請稍後再試',
			'error.message.delete_failed' => '刪除失敗，請稍後再試',
			'error.message.rate_fetch_failed' => '為替レートの更新失敗',
			_ => null,
		};
	}
}
