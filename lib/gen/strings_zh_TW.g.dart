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
	late final TranslationsS10HomeTaskListZhTw s10_home_task_list = TranslationsS10HomeTaskListZhTw.internal(_root);
	late final TranslationsS11InviteConfirmZhTw s11_invite_confirm = TranslationsS11InviteConfirmZhTw.internal(_root);
	late final TranslationsS12TaskCloseNoticeZhTw s12_task_close_notice = TranslationsS12TaskCloseNoticeZhTw.internal(_root);
	late final TranslationsS13TaskDashboardZhTw s13_task_dashboard = TranslationsS13TaskDashboardZhTw.internal(_root);
	late final TranslationsS14TaskSettingsZhTw s14_task_settings = TranslationsS14TaskSettingsZhTw.internal(_root);
	late final TranslationsS15RecordEditZhTw s15_record_edit = TranslationsS15RecordEditZhTw.internal(_root);
	late final TranslationsS16TaskCreateEditZhTw s16_task_create_edit = TranslationsS16TaskCreateEditZhTw.internal(_root);
	late final TranslationsS17TaskLockedZhTw s17_task_locked = TranslationsS17TaskLockedZhTw.internal(_root);
	late final TranslationsS18TaskJoinZhTw s18_task_join = TranslationsS18TaskJoinZhTw.internal(_root);
	late final TranslationsS30SettlementConfirmZhTw s30_settlement_confirm = TranslationsS30SettlementConfirmZhTw.internal(_root);
	late final TranslationsS31SettlementPaymentInfoZhTw s31_settlement_payment_info = TranslationsS31SettlementPaymentInfoZhTw.internal(_root);
	late final TranslationsS32SettlementResultZhTw s32_settlement_result = TranslationsS32SettlementResultZhTw.internal(_root);
	late final TranslationsS50OnboardingConsentZhTw s50_onboarding_consent = TranslationsS50OnboardingConsentZhTw.internal(_root);
	late final TranslationsS51OnboardingNameZhTw s51_onboarding_name = TranslationsS51OnboardingNameZhTw.internal(_root);
	late final TranslationsS52TaskSettingsLogZhTw s52_task_settings_log = TranslationsS52TaskSettingsLogZhTw.internal(_root);
	late final TranslationsS53TaskSettingsMembersZhTw s53_task_settings_members = TranslationsS53TaskSettingsMembersZhTw.internal(_root);
	late final TranslationsS54TaskSettingsInviteZhTw s54_task_settings_invite = TranslationsS54TaskSettingsInviteZhTw.internal(_root);
	late final TranslationsS70SystemSettingsZhTw s70_system_settings = TranslationsS70SystemSettingsZhTw.internal(_root);
	late final TranslationsS72TermsUpdateZhTw s72_terms_update = TranslationsS72TermsUpdateZhTw.internal(_root);
	late final TranslationsS74DeleteAccountNoticeZhTw s74_delete_account_notice = TranslationsS74DeleteAccountNoticeZhTw.internal(_root);
	late final TranslationsD01MemberRoleIntroZhTw d01_member_role_intro = TranslationsD01MemberRoleIntroZhTw.internal(_root);
	late final TranslationsD02InviteResultZhTw d02_invite_result = TranslationsD02InviteResultZhTw.internal(_root);
	late final TranslationsD03TaskCreateConfirmZhTw d03_task_create_confirm = TranslationsD03TaskCreateConfirmZhTw.internal(_root);
	late final TranslationsD04CommonUnsavedConfirmZhTw d04_common_unsaved_confirm = TranslationsD04CommonUnsavedConfirmZhTw.internal(_root);
	late final TranslationsD05DateJumpNoResultZhTw d05_date_jump_no_result = TranslationsD05DateJumpNoResultZhTw.internal(_root);
	late final TranslationsD06SettlementConfirmZhTw d06_settlement_confirm = TranslationsD06SettlementConfirmZhTw.internal(_root);
	late final TranslationsD08TaskClosedConfirmZhTw d08_task_closed_confirm = TranslationsD08TaskClosedConfirmZhTw.internal(_root);
	late final TranslationsD09TaskSettingsCurrencyConfirmZhTw d09_task_settings_currency_confirm = TranslationsD09TaskSettingsCurrencyConfirmZhTw.internal(_root);
	late final TranslationsD10RecordDeleteConfirmZhTw d10_record_delete_confirm = TranslationsD10RecordDeleteConfirmZhTw.internal(_root);
	late final TranslationsD11RandomResultZhTw d11_random_result = TranslationsD11RandomResultZhTw.internal(_root);
	late final TranslationsD12LogoutConfirmZhTw d12_logout_confirm = TranslationsD12LogoutConfirmZhTw.internal(_root);
	late final TranslationsD13DeleteAccountConfirmZhTw d13_delete_account_confirm = TranslationsD13DeleteAccountConfirmZhTw.internal(_root);
	late final TranslationsD14DateSelectZhTw d14_date_select = TranslationsD14DateSelectZhTw.internal(_root);
	late final TranslationsB02SplitExpenseEditZhTw b02_split_expense_edit = TranslationsB02SplitExpenseEditZhTw.internal(_root);
	late final TranslationsB03SplitMethodEditZhTw b03_split_method_edit = TranslationsB03SplitMethodEditZhTw.internal(_root);
	late final TranslationsB04PaymentMergeZhTw b04_payment_merge = TranslationsB04PaymentMergeZhTw.internal(_root);
	late final TranslationsB07PaymentMethodEditZhTw b07_payment_method_edit = TranslationsB07PaymentMethodEditZhTw.internal(_root);
	late final TranslationsSuccessZhTw success = TranslationsSuccessZhTw.internal(_root);
	late final TranslationsErrorZhTw error = TranslationsErrorZhTw.internal(_root);
}

// Path: common
class TranslationsCommonZhTw {
	TranslationsCommonZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonButtonsZhTw buttons = TranslationsCommonButtonsZhTw.internal(_root);
	late final TranslationsCommonLabelZhTw label = TranslationsCommonLabelZhTw.internal(_root);
	late final TranslationsCommonCategoryZhTw category = TranslationsCommonCategoryZhTw.internal(_root);
	late final TranslationsCommonCurrencyZhTw currency = TranslationsCommonCurrencyZhTw.internal(_root);
	late final TranslationsCommonAvatarZhTw avatar = TranslationsCommonAvatarZhTw.internal(_root);
	late final TranslationsCommonRemainderRuleZhTw remainder_rule = TranslationsCommonRemainderRuleZhTw.internal(_root);
	late final TranslationsCommonSplitMethodZhTw split_method = TranslationsCommonSplitMethodZhTw.internal(_root);
	late final TranslationsCommonPaymentMethodZhTw payment_method = TranslationsCommonPaymentMethodZhTw.internal(_root);
	late final TranslationsCommonLanguageZhTw language = TranslationsCommonLanguageZhTw.internal(_root);
	late final TranslationsCommonThemeZhTw theme = TranslationsCommonThemeZhTw.internal(_root);
	late final TranslationsCommonDisplayZhTw display = TranslationsCommonDisplayZhTw.internal(_root);
	late final TranslationsCommonPaymentInfoZhTw payment_info = TranslationsCommonPaymentInfoZhTw.internal(_root);
	late final TranslationsCommonPaymentStatusZhTw payment_status = TranslationsCommonPaymentStatusZhTw.internal(_root);
	late final TranslationsCommonTermsZhTw terms = TranslationsCommonTermsZhTw.internal(_root);
	late final TranslationsCommonShareZhTw share = TranslationsCommonShareZhTw.internal(_root);

	/// zh-TW: '準備中...'
	String get preparing => '準備中...';

	/// zh-TW: '我'
	String get me => '我';

	/// zh-TW: '必填'
	String get required => '必填';

	/// zh-TW: '成員'
	String get member_prefix => '成員';

	/// zh-TW: '尚無紀錄'
	String get no_record => '尚無紀錄';

	/// zh-TW: '今天'
	String get today => '今天';
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

// Path: s10_home_task_list
class TranslationsS10HomeTaskListZhTw {
	TranslationsS10HomeTaskListZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務列表'
	String get title => '任務列表';

	late final TranslationsS10HomeTaskListTabZhTw tab = TranslationsS10HomeTaskListTabZhTw.internal(_root);
	late final TranslationsS10HomeTaskListEmptyZhTw empty = TranslationsS10HomeTaskListEmptyZhTw.internal(_root);
	late final TranslationsS10HomeTaskListButtonsZhTw buttons = TranslationsS10HomeTaskListButtonsZhTw.internal(_root);

	/// zh-TW: '日期未定'
	String get date_tbd => '日期未定';

	late final TranslationsS10HomeTaskListLabelZhTw label = TranslationsS10HomeTaskListLabelZhTw.internal(_root);
}

// Path: s11_invite_confirm
class TranslationsS11InviteConfirmZhTw {
	TranslationsS11InviteConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '加入任務'
	String get title => '加入任務';

	/// zh-TW: '受邀加入以下任務'
	String get subtitle => '受邀加入以下任務';

	late final TranslationsS11InviteConfirmButtonsZhTw buttons = TranslationsS11InviteConfirmButtonsZhTw.internal(_root);
	late final TranslationsS11InviteConfirmLabelZhTw label = TranslationsS11InviteConfirmLabelZhTw.internal(_root);
}

// Path: s12_task_close_notice
class TranslationsS12TaskCloseNoticeZhTw {
	TranslationsS12TaskCloseNoticeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結束任務確認'
	String get title => '結束任務確認';

	/// zh-TW: '結束任務後，所有紀錄與設定將被鎖定。系統將進入唯讀模式，將無法新增或編輯任何資料。'
	String get content => '結束任務後，所有紀錄與設定將被鎖定。系統將進入唯讀模式，將無法新增或編輯任何資料。';

	late final TranslationsS12TaskCloseNoticeButtonsZhTw buttons = TranslationsS12TaskCloseNoticeButtonsZhTw.internal(_root);
}

// Path: s13_task_dashboard
class TranslationsS13TaskDashboardZhTw {
	TranslationsS13TaskDashboardZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務總覽'
	String get title => '任務總覽';

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

// Path: s14_task_settings
class TranslationsS14TaskSettingsZhTw {
	TranslationsS14TaskSettingsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務設定'
	String get title => '任務設定';

	late final TranslationsS14TaskSettingsSectionZhTw section = TranslationsS14TaskSettingsSectionZhTw.internal(_root);
	late final TranslationsS14TaskSettingsMenuZhTw menu = TranslationsS14TaskSettingsMenuZhTw.internal(_root);
}

// Path: s15_record_edit
class TranslationsS15RecordEditZhTw {
	TranslationsS15RecordEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsS15RecordEditTitleZhTw title = TranslationsS15RecordEditTitleZhTw.internal(_root);
	late final TranslationsS15RecordEditButtonsZhTw buttons = TranslationsS15RecordEditButtonsZhTw.internal(_root);
	late final TranslationsS15RecordEditSectionZhTw section = TranslationsS15RecordEditSectionZhTw.internal(_root);
	late final TranslationsS15RecordEditValZhTw val = TranslationsS15RecordEditValZhTw.internal(_root);
	late final TranslationsS15RecordEditTabZhTw tab = TranslationsS15RecordEditTabZhTw.internal(_root);

	/// zh-TW: '剩餘金額'
	String get base_card => '剩餘金額';

	/// zh-TW: '預收款'
	String get type_prepay => '預收款';

	/// zh-TW: '多人'
	String get payer_multiple => '多人';

	late final TranslationsS15RecordEditRateDialogZhTw rate_dialog = TranslationsS15RecordEditRateDialogZhTw.internal(_root);
	late final TranslationsS15RecordEditLabelZhTw label = TranslationsS15RecordEditLabelZhTw.internal(_root);
	late final TranslationsS15RecordEditHintZhTw hint = TranslationsS15RecordEditHintZhTw.internal(_root);
}

// Path: s16_task_create_edit
class TranslationsS16TaskCreateEditZhTw {
	TranslationsS16TaskCreateEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增任務'
	String get title => '新增任務';

	late final TranslationsS16TaskCreateEditSectionZhTw section = TranslationsS16TaskCreateEditSectionZhTw.internal(_root);
	late final TranslationsS16TaskCreateEditLabelZhTw label = TranslationsS16TaskCreateEditLabelZhTw.internal(_root);
	late final TranslationsS16TaskCreateEditHintZhTw hint = TranslationsS16TaskCreateEditHintZhTw.internal(_root);
}

// Path: s17_task_locked
class TranslationsS17TaskLockedZhTw {
	TranslationsS17TaskLockedZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsS17TaskLockedButtonsZhTw buttons = TranslationsS17TaskLockedButtonsZhTw.internal(_root);
	late final TranslationsS17TaskLockedSectionZhTw section = TranslationsS17TaskLockedSectionZhTw.internal(_root);

	/// zh-TW: '資料將於 {days} 天後自動刪除。請在期間內下載任務紀錄'
	String retention_notice({required Object days}) => '資料將於 ${days} 天後自動刪除。請在期間內下載任務紀錄';

	/// zh-TW: '由 {name} 承擔'
	String remainder_absorbed_by({required Object name}) => '由 ${name} 承擔';

	late final TranslationsS17TaskLockedExportZhTw export = TranslationsS17TaskLockedExportZhTw.internal(_root);
}

// Path: s18_task_join
class TranslationsS18TaskJoinZhTw {
	TranslationsS18TaskJoinZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '加入任務'
	String get title => '加入任務';

	late final TranslationsS18TaskJoinTabsZhTw tabs = TranslationsS18TaskJoinTabsZhTw.internal(_root);
	late final TranslationsS18TaskJoinLabelZhTw label = TranslationsS18TaskJoinLabelZhTw.internal(_root);
	late final TranslationsS18TaskJoinHintZhTw hint = TranslationsS18TaskJoinHintZhTw.internal(_root);
	late final TranslationsS18TaskJoinContentZhTw content = TranslationsS18TaskJoinContentZhTw.internal(_root);
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

	/// zh-TW: '設為預設收款資訊（僅儲存於本機）'
	String get sync_save => '設為預設收款資訊（僅儲存於本機）';

	/// zh-TW: '同步更新預設收款資訊'
	String get sync_update => '同步更新預設收款資訊';

	late final TranslationsS31SettlementPaymentInfoButtonsZhTw buttons = TranslationsS31SettlementPaymentInfoButtonsZhTw.internal(_root);
}

// Path: s32_settlement_result
class TranslationsS32SettlementResultZhTw {
	TranslationsS32SettlementResultZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結算成功'
	String get title => '結算成功';

	/// zh-TW: '帳目已確認。請通知成員完成付款。'
	String get content => '帳目已確認。請通知成員完成付款。';

	/// zh-TW: '等待揭曉...'
	String get waiting_reveal => '等待揭曉...';

	/// zh-TW: '零頭歸屬：'
	String get remainder_winner_prefix => '零頭歸屬：';

	/// zh-TW: '{winnerName}總金額為：{prefix}{total}'
	String remainder_winner_total({required Object winnerName, required Object prefix, required Object total}) => '${winnerName}總金額為：${prefix}${total}';

	/// zh-TW: '本次結算總額'
	String get total_label => '本次結算總額';

	late final TranslationsS32SettlementResultButtonsZhTw buttons = TranslationsS32SettlementResultButtonsZhTw.internal(_root);
}

// Path: s50_onboarding_consent
class TranslationsS50OnboardingConsentZhTw {
	TranslationsS50OnboardingConsentZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '歡迎使用 Iron Split'
	String get title => '歡迎使用 Iron Split';

	late final TranslationsS50OnboardingConsentButtonsZhTw buttons = TranslationsS50OnboardingConsentButtonsZhTw.internal(_root);
	late final TranslationsS50OnboardingConsentContentZhTw content = TranslationsS50OnboardingConsentContentZhTw.internal(_root);
}

// Path: s51_onboarding_name
class TranslationsS51OnboardingNameZhTw {
	TranslationsS51OnboardingNameZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '名稱設定'
	String get title => '名稱設定';

	/// zh-TW: '請輸入顯示名稱。'
	String get content => '請輸入顯示名稱。';

	/// zh-TW: '顯示名稱'
	String get label => '顯示名稱';

	/// zh-TW: '輸入暱稱'
	String get hint => '輸入暱稱';

	/// zh-TW: '{current}/{max}'
	String counter({required Object current, required Object max}) => '${current}/${max}';
}

// Path: s52_task_settings_log
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
	late final TranslationsS52TaskSettingsLogTypeZhTw type = TranslationsS52TaskSettingsLogTypeZhTw.internal(_root);
	late final TranslationsS52TaskSettingsLogPaymentTypeZhTw payment_type = TranslationsS52TaskSettingsLogPaymentTypeZhTw.internal(_root);
	late final TranslationsS52TaskSettingsLogUnitZhTw unit = TranslationsS52TaskSettingsLogUnitZhTw.internal(_root);
}

// Path: s53_task_settings_members
class TranslationsS53TaskSettingsMembersZhTw {
	TranslationsS53TaskSettingsMembersZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '成員管理'
	String get title => '成員管理';

	late final TranslationsS53TaskSettingsMembersButtonsZhTw buttons = TranslationsS53TaskSettingsMembersButtonsZhTw.internal(_root);
	late final TranslationsS53TaskSettingsMembersLabelZhTw label = TranslationsS53TaskSettingsMembersLabelZhTw.internal(_root);

	/// zh-TW: '成員'
	String get member_default_name => '成員';

	/// zh-TW: '成員名稱'
	String get member_name => '成員名稱';
}

// Path: s54_task_settings_invite
class TranslationsS54TaskSettingsInviteZhTw {
	TranslationsS54TaskSettingsInviteZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務邀請'
	String get title => '任務邀請';

	late final TranslationsS54TaskSettingsInviteButtonsZhTw buttons = TranslationsS54TaskSettingsInviteButtonsZhTw.internal(_root);
	late final TranslationsS54TaskSettingsInviteLabelZhTw label = TranslationsS54TaskSettingsInviteLabelZhTw.internal(_root);
}

// Path: s70_system_settings
class TranslationsS70SystemSettingsZhTw {
	TranslationsS70SystemSettingsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '系統設定'
	String get title => '系統設定';

	late final TranslationsS70SystemSettingsSectionZhTw section = TranslationsS70SystemSettingsSectionZhTw.internal(_root);
	late final TranslationsS70SystemSettingsMenuZhTw menu = TranslationsS70SystemSettingsMenuZhTw.internal(_root);
}

// Path: s72_terms_update
class TranslationsS72TermsUpdateZhTw {
	TranslationsS72TermsUpdateZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '{type}更新'
	String title({required Object type}) => '${type}更新';

	/// zh-TW: '我們更新了{type}，請閱讀並同意以繼續使用。'
	String content({required Object type}) => '我們更新了${type}，請閱讀並同意以繼續使用。';
}

// Path: s74_delete_account_notice
class TranslationsS74DeleteAccountNoticeZhTw {
	TranslationsS74DeleteAccountNoticeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '刪除帳號確認'
	String get title => '刪除帳號確認';

	/// zh-TW: '此動作無法復原，個人資料將被刪除，隊長權限將會自動移轉至其他成員，但在共用帳本中的紀錄將會保留（轉為未連結狀態）。'
	String get content => '此動作無法復原，個人資料將被刪除，隊長權限將會自動移轉至其他成員，但在共用帳本中的紀錄將會保留（轉為未連結狀態）。';

	late final TranslationsS74DeleteAccountNoticeButtonsZhTw buttons = TranslationsS74DeleteAccountNoticeButtonsZhTw.internal(_root);
}

// Path: d01_member_role_intro
class TranslationsD01MemberRoleIntroZhTw {
	TranslationsD01MemberRoleIntroZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '本次角色'
	String get title => '本次角色';

	late final TranslationsD01MemberRoleIntroButtonsZhTw buttons = TranslationsD01MemberRoleIntroButtonsZhTw.internal(_root);

	/// zh-TW: '本次任務的專屬頭像{avatar}。 分帳紀錄將以 {avatar} 代表。'
	String content({required Object avatar}) => '本次任務的專屬頭像${avatar}。\n分帳紀錄將以 ${avatar} 代表。';

	late final TranslationsD01MemberRoleIntroRerollZhTw reroll = TranslationsD01MemberRoleIntroRerollZhTw.internal(_root);
}

// Path: d02_invite_result
class TranslationsD02InviteResultZhTw {
	TranslationsD02InviteResultZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '加入失敗'
	String get title => '加入失敗';
}

// Path: d03_task_create_confirm
class TranslationsD03TaskCreateConfirmZhTw {
	TranslationsD03TaskCreateConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務設定確認'
	String get title => '任務設定確認';

	late final TranslationsD03TaskCreateConfirmButtonsZhTw buttons = TranslationsD03TaskCreateConfirmButtonsZhTw.internal(_root);
}

// Path: d04_common_unsaved_confirm
class TranslationsD04CommonUnsavedConfirmZhTw {
	TranslationsD04CommonUnsavedConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '尚未儲存'
	String get title => '尚未儲存';

	/// zh-TW: '變更將不會被儲存，確定要離開嗎？'
	String get content => '變更將不會被儲存，確定要離開嗎？';
}

// Path: d05_date_jump_no_result
class TranslationsD05DateJumpNoResultZhTw {
	TranslationsD05DateJumpNoResultZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '無紀錄'
	String get title => '無紀錄';

	/// zh-TW: '此日期無紀錄。是否新增？'
	String get content => '此日期無紀錄。是否新增？';
}

// Path: d06_settlement_confirm
class TranslationsD06SettlementConfirmZhTw {
	TranslationsD06SettlementConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結算確認'
	String get title => '結算確認';

	/// zh-TW: '結算後任務將立即鎖定，無法新增、刪除或編輯紀錄。 請確認帳目已核對無誤。'
	String get content => '結算後任務將立即鎖定，無法新增、刪除或編輯紀錄。\n請確認帳目已核對無誤。';
}

// Path: d08_task_closed_confirm
class TranslationsD08TaskClosedConfirmZhTw {
	TranslationsD08TaskClosedConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結束任務確認'
	String get title => '結束任務確認';

	/// zh-TW: '此操作無法復原。所有資料將被永久鎖定。 確定要繼續嗎？'
	String get content => '此操作無法復原。所有資料將被永久鎖定。\n\n確定要繼續嗎？';
}

// Path: d09_task_settings_currency_confirm
class TranslationsD09TaskSettingsCurrencyConfirmZhTw {
	TranslationsD09TaskSettingsCurrencyConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '變更結算幣別'
	String get title => '變更結算幣別';

	/// zh-TW: '變更幣別將會重置所有匯率設定，這可能會影響目前的帳目金額。確定要變更嗎？'
	String get content => '變更幣別將會重置所有匯率設定，這可能會影響目前的帳目金額。確定要變更嗎？';
}

// Path: d10_record_delete_confirm
class TranslationsD10RecordDeleteConfirmZhTw {
	TranslationsD10RecordDeleteConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '刪除紀錄確認'
	String get title => '刪除紀錄確認';

	/// zh-TW: '確定要刪除 {title}（{amount}）嗎？'
	String content({required Object title, required Object amount}) => '確定要刪除 ${title}（${amount}）嗎？';
}

// Path: d11_random_result
class TranslationsD11RandomResultZhTw {
	TranslationsD11RandomResultZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '零頭得主'
	String get title => '零頭得主';

	/// zh-TW: '略過'
	String get skip => '略過';
}

// Path: d12_logout_confirm
class TranslationsD12LogoutConfirmZhTw {
	TranslationsD12LogoutConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '登出確認'
	String get title => '登出確認';

	/// zh-TW: '若不同意更新後的條款，將無法繼續使用本服務。 帳號將會登出。'
	String get content => '若不同意更新後的條款，將無法繼續使用本服務。\n帳號將會登出。';

	late final TranslationsD12LogoutConfirmButtonsZhTw buttons = TranslationsD12LogoutConfirmButtonsZhTw.internal(_root);
}

// Path: d13_delete_account_confirm
class TranslationsD13DeleteAccountConfirmZhTw {
	TranslationsD13DeleteAccountConfirmZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '刪除帳號確認'
	String get title => '刪除帳號確認';

	/// zh-TW: '此操作無法復原。所有資料將被永久刪除。 確定要繼續嗎？'
	String get content => '此操作無法復原。所有資料將被永久刪除。\n\n確定要繼續嗎？';
}

// Path: d14_date_select
class TranslationsD14DateSelectZhTw {
	TranslationsD14DateSelectZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '選擇日期'
	String get title => '選擇日期';
}

// Path: b02_split_expense_edit
class TranslationsB02SplitExpenseEditZhTw {
	TranslationsB02SplitExpenseEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '編輯細項'
	String get title => '編輯細項';

	late final TranslationsB02SplitExpenseEditButtonsZhTw buttons = TranslationsB02SplitExpenseEditButtonsZhTw.internal(_root);

	/// zh-TW: '項目名稱尚未輸入'
	String get item_name_empty => '項目名稱尚未輸入';

	late final TranslationsB02SplitExpenseEditHintZhTw hint = TranslationsB02SplitExpenseEditHintZhTw.internal(_root);
}

// Path: b03_split_method_edit
class TranslationsB03SplitMethodEditZhTw {
	TranslationsB03SplitMethodEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '分攤方式設定'
	String get title => '分攤方式設定';

	late final TranslationsB03SplitMethodEditButtonsZhTw buttons = TranslationsB03SplitMethodEditButtonsZhTw.internal(_root);
	late final TranslationsB03SplitMethodEditLabelZhTw label = TranslationsB03SplitMethodEditLabelZhTw.internal(_root);

	/// zh-TW: '金額不符'
	String get mismatch => '金額不符';
}

// Path: b04_payment_merge
class TranslationsB04PaymentMergeZhTw {
	TranslationsB04PaymentMergeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '合併成員款項'
	String get title => '合併成員款項';

	late final TranslationsB04PaymentMergeLabelZhTw label = TranslationsB04PaymentMergeLabelZhTw.internal(_root);
}

// Path: b07_payment_method_edit
class TranslationsB07PaymentMethodEditZhTw {
	TranslationsB07PaymentMethodEditZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '資金來源設定'
	String get title => '資金來源設定';

	/// zh-TW: '預收款餘額：{amount}'
	String prepay_balance({required Object amount}) => '預收款餘額：${amount}';

	/// zh-TW: '代墊成員'
	String get payer_member => '代墊成員';

	late final TranslationsB07PaymentMethodEditLabelZhTw label = TranslationsB07PaymentMethodEditLabelZhTw.internal(_root);
	late final TranslationsB07PaymentMethodEditStatusZhTw status = TranslationsB07PaymentMethodEditStatusZhTw.internal(_root);
}

// Path: success
class TranslationsSuccessZhTw {
	TranslationsSuccessZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '已成功儲存。'
	String get saved => '已成功儲存。';

	/// zh-TW: '已成功刪除。'
	String get deleted => '已成功刪除。';

	/// zh-TW: '已複製到剪貼簿'
	String get copied => '已複製到剪貼簿';
}

// Path: error
class TranslationsErrorZhTw {
	TranslationsErrorZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '錯誤'
	String get title => '錯誤';

	/// zh-TW: '發生未知錯誤：{error}'
	String unknown({required Object error}) => '發生未知錯誤：${error}';

	late final TranslationsErrorDialogZhTw dialog = TranslationsErrorDialogZhTw.internal(_root);
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

	/// zh-TW: '儲存'
	String get save => '儲存';

	/// zh-TW: '編輯'
	String get edit => '編輯';

	/// zh-TW: '關閉'
	String get close => '關閉';

	/// zh-TW: '下載紀錄'
	String get download => '下載紀錄';

	/// zh-TW: '結算'
	String get settlement => '結算';

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

	/// zh-TW: '完成'
	String get done => '完成';

	/// zh-TW: '同意'
	String get agree => '同意';

	/// zh-TW: '不同意'
	String get decline => '不同意';

	/// zh-TW: '新增紀錄'
	String get add_record => '新增紀錄';

	/// zh-TW: '複製'
	String get copy => '複製';
}

// Path: common.label
class TranslationsCommonLabelZhTw {
	TranslationsCommonLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '任務名稱'
	String get task_name => '任務名稱';

	/// zh-TW: '項目名稱'
	String get item_name => '項目名稱';

	/// zh-TW: '細項名稱'
	String get sub_item => '細項名稱';

	/// zh-TW: '金額'
	String get amount => '金額';

	/// zh-TW: '日期'
	String get date => '日期';

	/// zh-TW: '結算幣別'
	String get currency => '結算幣別';

	/// zh-TW: '分攤設定'
	String get split_method => '分攤設定';

	/// zh-TW: '開始日期'
	String get start_date => '開始日期';

	/// zh-TW: '結束日期'
	String get end_date => '結束日期';

	/// zh-TW: '參加人數'
	String get member_count => '參加人數';

	/// zh-TW: '期間'
	String get period => '期間';

	/// zh-TW: '支付方式'
	String get payment_method => '支付方式';

	/// zh-TW: '匯率'
	String get rate => '匯率';

	/// zh-TW: '備註'
	String get memo => '備註';
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

// Path: common.avatar
class TranslationsCommonAvatarZhTw {
	TranslationsCommonAvatarZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '荷斯登乳牛'
	String get cow => '荷斯登乳牛';

	/// zh-TW: '小豬'
	String get pig => '小豬';

	/// zh-TW: '狍鹿'
	String get deer => '狍鹿';

	/// zh-TW: '馬'
	String get horse => '馬';

	/// zh-TW: '薩福克羊'
	String get sheep => '薩福克羊';

	/// zh-TW: '家山羊'
	String get goat => '家山羊';

	/// zh-TW: '綠頭鴨'
	String get duck => '綠頭鴨';

	/// zh-TW: '白鼬'
	String get stoat => '白鼬';

	/// zh-TW: '歐洲野兔'
	String get rabbit => '歐洲野兔';

	/// zh-TW: '老鼠'
	String get mouse => '老鼠';

	/// zh-TW: '虎斑家貓'
	String get cat => '虎斑家貓';

	/// zh-TW: '邊境牧羊犬'
	String get dog => '邊境牧羊犬';

	/// zh-TW: '歐亞水獺'
	String get otter => '歐亞水獺';

	/// zh-TW: '倉鴞'
	String get owl => '倉鴞';

	/// zh-TW: '赤狐'
	String get fox => '赤狐';

	/// zh-TW: '歐洲刺蝟'
	String get hedgehog => '歐洲刺蝟';

	/// zh-TW: '驢子'
	String get donkey => '驢子';

	/// zh-TW: '紅松鼠'
	String get squirrel => '紅松鼠';

	/// zh-TW: '歐洲獾'
	String get badger => '歐洲獾';

	/// zh-TW: '歐亞知更鳥'
	String get robin => '歐亞知更鳥';
}

// Path: common.remainder_rule
class TranslationsCommonRemainderRuleZhTw {
	TranslationsCommonRemainderRuleZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '零頭處理'
	String get title => '零頭處理';

	late final TranslationsCommonRemainderRuleRuleZhTw rule = TranslationsCommonRemainderRuleRuleZhTw.internal(_root);
	late final TranslationsCommonRemainderRuleContentZhTw content = TranslationsCommonRemainderRuleContentZhTw.internal(_root);
	late final TranslationsCommonRemainderRuleMessageZhTw message = TranslationsCommonRemainderRuleMessageZhTw.internal(_root);
}

// Path: common.split_method
class TranslationsCommonSplitMethodZhTw {
	TranslationsCommonSplitMethodZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '均分'
	String get even => '均分';

	/// zh-TW: '比例'
	String get percent => '比例';

	/// zh-TW: '指定'
	String get exact => '指定';
}

// Path: common.payment_method
class TranslationsCommonPaymentMethodZhTw {
	TranslationsCommonPaymentMethodZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '成員代墊'
	String get member => '成員代墊';

	/// zh-TW: '預收款支付'
	String get prepay => '預收款支付';

	/// zh-TW: '混合支付'
	String get mixed => '混合支付';
}

// Path: common.language
class TranslationsCommonLanguageZhTw {
	TranslationsCommonLanguageZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '語言設定'
	String get title => '語言設定';

	/// zh-TW: '繁體中文'
	String get zh_TW => '繁體中文';

	/// zh-TW: '英文'
	String get en_US => '英文';

	/// zh-TW: '日文'
	String get jp_JP => '日文';
}

// Path: common.theme
class TranslationsCommonThemeZhTw {
	TranslationsCommonThemeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '主題設定'
	String get title => '主題設定';

	/// zh-TW: '系統預設'
	String get system => '系統預設';

	/// zh-TW: '淺色模式'
	String get light => '淺色模式';

	/// zh-TW: '深色模式'
	String get dark => '深色模式';
}

// Path: common.display
class TranslationsCommonDisplayZhTw {
	TranslationsCommonDisplayZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '顯示設定'
	String get title => '顯示設定';

	/// zh-TW: '系統預設'
	String get system => '系統預設';

	/// zh-TW: '放大顯示'
	String get enlarged => '放大顯示';

	/// zh-TW: '標準顯示'
	String get standard => '標準顯示';
}

// Path: common.payment_info
class TranslationsCommonPaymentInfoZhTw {
	TranslationsCommonPaymentInfoZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonPaymentInfoModeZhTw mode = TranslationsCommonPaymentInfoModeZhTw.internal(_root);
	late final TranslationsCommonPaymentInfoContentZhTw content = TranslationsCommonPaymentInfoContentZhTw.internal(_root);
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
	String get refund => '可退';
}

// Path: common.terms
class TranslationsCommonTermsZhTw {
	TranslationsCommonTermsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonTermsLabelZhTw label = TranslationsCommonTermsLabelZhTw.internal(_root);

	/// zh-TW: '和'
	String get and => '和';
}

// Path: common.share
class TranslationsCommonShareZhTw {
	TranslationsCommonShareZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsCommonShareInviteZhTw invite = TranslationsCommonShareInviteZhTw.internal(_root);
	late final TranslationsCommonShareSettlementZhTw settlement = TranslationsCommonShareSettlementZhTw.internal(_root);
}

// Path: s10_home_task_list.tab
class TranslationsS10HomeTaskListTabZhTw {
	TranslationsS10HomeTaskListTabZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '進行中'
	String get in_progress => '進行中';

	/// zh-TW: '已完成'
	String get completed => '已完成';
}

// Path: s10_home_task_list.empty
class TranslationsS10HomeTaskListEmptyZhTw {
	TranslationsS10HomeTaskListEmptyZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '目前沒有進行中的任務'
	String get in_progress => '目前沒有進行中的任務';

	/// zh-TW: '沒有已完成的任務'
	String get completed => '沒有已完成的任務';
}

// Path: s10_home_task_list.buttons
class TranslationsS10HomeTaskListButtonsZhTw {
	TranslationsS10HomeTaskListButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增任務'
	String get add_task => '新增任務';

	/// zh-TW: '加入任務'
	String get join_task => '加入任務';
}

// Path: s10_home_task_list.label
class TranslationsS10HomeTaskListLabelZhTw {
	TranslationsS10HomeTaskListLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '已結算'
	String get settlement => '已結算';
}

// Path: s11_invite_confirm.buttons
class TranslationsS11InviteConfirmButtonsZhTw {
	TranslationsS11InviteConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '加入'
	String get join => '加入';

	/// zh-TW: '回任務列表'
	String get back_task_list => '回任務列表';
}

// Path: s11_invite_confirm.label
class TranslationsS11InviteConfirmLabelZhTw {
	TranslationsS11InviteConfirmLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '選擇要繼承的成員'
	String get select_ghost => '選擇要繼承的成員';

	/// zh-TW: '已代墊'
	String get prepaid => '已代墊';

	/// zh-TW: '應分攤'
	String get expense => '應分攤';
}

// Path: s12_task_close_notice.buttons
class TranslationsS12TaskCloseNoticeButtonsZhTw {
	TranslationsS12TaskCloseNoticeButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '結束任務'
	String get close_task => '結束任務';
}

// Path: s13_task_dashboard.buttons
class TranslationsS13TaskDashboardButtonsZhTw {
	TranslationsS13TaskDashboardButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增'
	String get add => '新增';
}

// Path: s13_task_dashboard.tab
class TranslationsS13TaskDashboardTabZhTw {
	TranslationsS13TaskDashboardTabZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '群組'
	String get group => '群組';

	/// zh-TW: '個人'
	String get personal => '個人';
}

// Path: s13_task_dashboard.label
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

// Path: s13_task_dashboard.empty
class TranslationsS13TaskDashboardEmptyZhTw {
	TranslationsS13TaskDashboardEmptyZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '尚無紀錄'
	String get records => '尚無紀錄';

	/// zh-TW: '尚無紀錄'
	String get personal_records => '尚無紀錄';
}

// Path: s13_task_dashboard.section
class TranslationsS13TaskDashboardSectionZhTw {
	TranslationsS13TaskDashboardSectionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '支出明細'
	String get expense => '支出明細';

	/// zh-TW: '預收明細'
	String get prepay => '預收明細';

	/// zh-TW: '預收餘額'
	String get prepay_balance => '預收餘額';

	/// zh-TW: '無資料'
	String get no_data => '無資料';
}

// Path: s14_task_settings.section
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

// Path: s14_task_settings.menu
class TranslationsS14TaskSettingsMenuZhTw {
	TranslationsS14TaskSettingsMenuZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '發送邀請'
	String get invite => '發送邀請';

	/// zh-TW: '成員設定'
	String get member_settings => '成員設定';

	/// zh-TW: '歷史紀錄'
	String get history => '歷史紀錄';

	/// zh-TW: '結束任務'
	String get close_task => '結束任務';
}

// Path: s15_record_edit.title
class TranslationsS15RecordEditTitleZhTw {
	TranslationsS15RecordEditTitleZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增紀錄'
	String get add => '新增紀錄';

	/// zh-TW: '編輯紀錄'
	String get edit => '編輯紀錄';
}

// Path: s15_record_edit.buttons
class TranslationsS15RecordEditButtonsZhTw {
	TranslationsS15RecordEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增細項'
	String get add_item => '新增細項';
}

// Path: s15_record_edit.section
class TranslationsS15RecordEditSectionZhTw {
	TranslationsS15RecordEditSectionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '分攤資訊'
	String get split => '分攤資訊';

	/// zh-TW: '細項分拆'
	String get items => '細項分拆';
}

// Path: s15_record_edit.val
class TranslationsS15RecordEditValZhTw {
	TranslationsS15RecordEditValZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '預收'
	String get prepay => '預收';

	/// zh-TW: '{name} 代墊'
	String member_paid({required Object name}) => '${name} 代墊';

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

// Path: s15_record_edit.tab
class TranslationsS15RecordEditTabZhTw {
	TranslationsS15RecordEditTabZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '費用'
	String get expense => '費用';

	/// zh-TW: '預收'
	String get prepay => '預收';
}

// Path: s15_record_edit.rate_dialog
class TranslationsS15RecordEditRateDialogZhTw {
	TranslationsS15RecordEditRateDialogZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '匯率來源'
	String get title => '匯率來源';

	/// zh-TW: '匯率資料來自 Open Exchange Rates（免費版），僅供參考。實際匯率請依換匯水單為準。'
	String get content => '匯率資料來自 Open Exchange Rates（免費版），僅供參考。實際匯率請依換匯水單為準。';
}

// Path: s15_record_edit.label
class TranslationsS15RecordEditLabelZhTw {
	TranslationsS15RecordEditLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '匯率（1 {base} = ? {target}）'
	String rate_with_base({required Object base, required Object target}) => '匯率（1 ${base} = ? ${target}）';
}

// Path: s15_record_edit.hint
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

// Path: s16_task_create_edit.section
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

// Path: s16_task_create_edit.label
class TranslationsS16TaskCreateEditLabelZhTw {
	TranslationsS16TaskCreateEditLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '{current}/{max}'
	String name_counter({required Object current, required Object max}) => '${current}/${max}';
}

// Path: s16_task_create_edit.hint
class TranslationsS16TaskCreateEditHintZhTw {
	TranslationsS16TaskCreateEditHintZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '例：東京五日遊'
	String get name => '例：東京五日遊';
}

// Path: s17_task_locked.buttons
class TranslationsS17TaskLockedButtonsZhTw {
	TranslationsS17TaskLockedButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '通知成員'
	String get notify_members => '通知成員';

	/// zh-TW: '隊長收退款帳戶'
	String get view_payment_info => '隊長收退款帳戶';
}

// Path: s17_task_locked.section
class TranslationsS17TaskLockedSectionZhTw {
	TranslationsS17TaskLockedSectionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '待處理'
	String get pending => '待處理';

	/// zh-TW: '已處理'
	String get cleared => '已處理';
}

// Path: s17_task_locked.export
class TranslationsS17TaskLockedExportZhTw {
	TranslationsS17TaskLockedExportZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '報表資訊'
	String get report_info => '報表資訊';

	/// zh-TW: '任務名稱'
	String get task_name => '任務名稱';

	/// zh-TW: '報表製作時間'
	String get export_time => '報表製作時間';

	/// zh-TW: '結算幣別'
	String get base_currency => '結算幣別';

	/// zh-TW: '結算總表'
	String get settlement_summary => '結算總表';

	/// zh-TW: '成員'
	String get member => '成員';

	/// zh-TW: '角色'
	String get role => '角色';

	/// zh-TW: '淨額'
	String get net_amount => '淨額';

	/// zh-TW: '狀態'
	String get status => '狀態';

	/// zh-TW: '可退'
	String get receiver => '可退';

	/// zh-TW: '應付'
	String get payer => '應付';

	/// zh-TW: '已處理'
	String get cleared => '已處理';

	/// zh-TW: '未處理'
	String get pending => '未處理';

	/// zh-TW: '資金與零頭'
	String get fund_analysis => '資金與零頭';

	/// zh-TW: '總費用'
	String get total_expense => '總費用';

	/// zh-TW: '總預收'
	String get total_prepay => '總預收';

	/// zh-TW: '零頭總額'
	String get remainder_buffer => '零頭總額';

	/// zh-TW: '零頭得主'
	String get remainder_absorbed_by => '零頭得主';

	/// zh-TW: '交易流水帳'
	String get transaction_details => '交易流水帳';

	/// zh-TW: '日期'
	String get date => '日期';

	/// zh-TW: '標題'
	String get title => '標題';

	/// zh-TW: '類型'
	String get type => '類型';

	/// zh-TW: '原始金額'
	String get original_amount => '原始金額';

	/// zh-TW: '幣別'
	String get currency => '幣別';

	/// zh-TW: '匯率'
	String get rate => '匯率';

	/// zh-TW: '結算幣別金額'
	String get base_amount => '結算幣別金額';

	/// zh-TW: '零頭'
	String get net_remainder => '零頭';

	/// zh-TW: '預收款'
	String get pool => '預收款';

	/// zh-TW: '混合支付'
	String get mixed => '混合支付';
}

// Path: s18_task_join.tabs
class TranslationsS18TaskJoinTabsZhTw {
	TranslationsS18TaskJoinTabsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '輸入'
	String get input => '輸入';

	/// zh-TW: '掃描'
	String get scan => '掃描';
}

// Path: s18_task_join.label
class TranslationsS18TaskJoinLabelZhTw {
	TranslationsS18TaskJoinLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '邀請碼'
	String get input => '邀請碼';
}

// Path: s18_task_join.hint
class TranslationsS18TaskJoinHintZhTw {
	TranslationsS18TaskJoinHintZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '請輸入 8 碼邀請碼'
	String get input => '請輸入 8 碼邀請碼';
}

// Path: s18_task_join.content
class TranslationsS18TaskJoinContentZhTw {
	TranslationsS18TaskJoinContentZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '請將行動條碼放入框內即可自動掃描'
	String get scan => '請將行動條碼放入框內即可自動掃描';
}

// Path: s30_settlement_confirm.buttons
class TranslationsS30SettlementConfirmButtonsZhTw {
	TranslationsS30SettlementConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '收款設定'
	String get set_payment_info => '收款設定';
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

	/// zh-TW: '零頭歸屬將於下一步結算完成後揭曉。'
	String get random_reveal => '零頭歸屬將於下一步結算完成後揭曉。';
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

	/// zh-TW: '隨機零頭'
	String get random_remainder => '隨機零頭';

	/// zh-TW: '零頭'
	String get remainder => '零頭';
}

// Path: s31_settlement_payment_info.buttons
class TranslationsS31SettlementPaymentInfoButtonsZhTw {
	TranslationsS31SettlementPaymentInfoButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '上一步'
	String get prev_step => '上一步';
}

// Path: s32_settlement_result.buttons
class TranslationsS32SettlementResultButtonsZhTw {
	TranslationsS32SettlementResultButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '發送結算通知'
	String get share => '發送結算通知';

	/// zh-TW: '返回任務'
	String get back_task_dashboard => '返回任務';
}

// Path: s50_onboarding_consent.buttons
class TranslationsS50OnboardingConsentButtonsZhTw {
	TranslationsS50OnboardingConsentButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '開始'
	String get start => '開始';
}

// Path: s50_onboarding_consent.content
class TranslationsS50OnboardingConsentContentZhTw {
	TranslationsS50OnboardingConsentContentZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '讓分帳變得簡單。 我是艾隆・魯斯特，負責記帳與分攤。 無論是旅行、聚餐、共同生活，支出將被清楚紀錄，分攤方式皆有明確規則。 分帳，本該清楚。 點擊「開始」即表示同意我們的 '
	String get prefix => '讓分帳變得簡單。\n\n我是艾隆・魯斯特，負責記帳與分攤。\n無論是旅行、聚餐、共同生活，支出將被清楚紀錄，分攤方式皆有明確規則。\n\n分帳，本該清楚。\n\n點擊「開始」即表示同意我們的 ';

	/// zh-TW: '。'
	String get suffix => '。';
}

// Path: s52_task_settings_log.buttons
class TranslationsS52TaskSettingsLogButtonsZhTw {
	TranslationsS52TaskSettingsLogButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '匯出 CSV'
	String get export_csv => '匯出 CSV';
}

// Path: s52_task_settings_log.csv_header
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

// Path: s52_task_settings_log.type
class TranslationsS52TaskSettingsLogTypeZhTw {
	TranslationsS52TaskSettingsLogTypeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '預收'
	String get prepay => '預收';

	/// zh-TW: '支出'
	String get expense => '支出';
}

// Path: s52_task_settings_log.payment_type
class TranslationsS52TaskSettingsLogPaymentTypeZhTw {
	TranslationsS52TaskSettingsLogPaymentTypeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '預收款支付'
	String get prepay => '預收款支付';

	/// zh-TW: '代墊'
	String get single_suffix => '代墊';

	/// zh-TW: '多人代墊'
	String get multiple => '多人代墊';
}

// Path: s52_task_settings_log.unit
class TranslationsS52TaskSettingsLogUnitZhTw {
	TranslationsS52TaskSettingsLogUnitZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '人'
	String get members => '人';

	/// zh-TW: '細項'
	String get items => '細項';
}

// Path: s53_task_settings_members.buttons
class TranslationsS53TaskSettingsMembersButtonsZhTw {
	TranslationsS53TaskSettingsMembersButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '新增成員'
	String get add_member => '新增成員';
}

// Path: s53_task_settings_members.label
class TranslationsS53TaskSettingsMembersLabelZhTw {
	TranslationsS53TaskSettingsMembersLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '預設比例'
	String get default_ratio => '預設比例';
}

// Path: s54_task_settings_invite.buttons
class TranslationsS54TaskSettingsInviteButtonsZhTw {
	TranslationsS54TaskSettingsInviteButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '分享'
	String get share => '分享';

	/// zh-TW: '重新產生'
	String get regenerate => '重新產生';
}

// Path: s54_task_settings_invite.label
class TranslationsS54TaskSettingsInviteLabelZhTw {
	TranslationsS54TaskSettingsInviteLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '有效期限'
	String get expires_in => '有效期限';

	/// zh-TW: '邀請碼已過期'
	String get invite_expired => '邀請碼已過期';
}

// Path: s70_system_settings.section
class TranslationsS70SystemSettingsSectionZhTw {
	TranslationsS70SystemSettingsSectionZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '基本設定'
	String get basic => '基本設定';

	/// zh-TW: '相關條款'
	String get legal => '相關條款';

	/// zh-TW: '帳號設定'
	String get account => '帳號設定';
}

// Path: s70_system_settings.menu
class TranslationsS70SystemSettingsMenuZhTw {
	TranslationsS70SystemSettingsMenuZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '顯示名稱'
	String get user_name => '顯示名稱';

	/// zh-TW: '顯示語言'
	String get language => '顯示語言';

	/// zh-TW: '外觀主題'
	String get theme => '外觀主題';

	/// zh-TW: '服務條款'
	String get terms => '服務條款';

	/// zh-TW: '隱私政策'
	String get privacy => '隱私政策';

	/// zh-TW: '收款帳戶設定'
	String get payment_info => '收款帳戶設定';

	/// zh-TW: '刪除帳號'
	String get delete_account => '刪除帳號';
}

// Path: s74_delete_account_notice.buttons
class TranslationsS74DeleteAccountNoticeButtonsZhTw {
	TranslationsS74DeleteAccountNoticeButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '刪除帳號'
	String get delete_account => '刪除帳號';
}

// Path: d01_member_role_intro.buttons
class TranslationsD01MemberRoleIntroButtonsZhTw {
	TranslationsD01MemberRoleIntroButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '換個動物'
	String get reroll => '換個動物';

	/// zh-TW: '進入任務'
	String get enter => '進入任務';
}

// Path: d01_member_role_intro.reroll
class TranslationsD01MemberRoleIntroRerollZhTw {
	TranslationsD01MemberRoleIntroRerollZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '機會已用完'
	String get empty => '機會已用完';
}

// Path: d03_task_create_confirm.buttons
class TranslationsD03TaskCreateConfirmButtonsZhTw {
	TranslationsD03TaskCreateConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '返回編輯'
	String get back_edit => '返回編輯';
}

// Path: d12_logout_confirm.buttons
class TranslationsD12LogoutConfirmButtonsZhTw {
	TranslationsD12LogoutConfirmButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認登出'
	String get logout => '確認登出';
}

// Path: b02_split_expense_edit.buttons
class TranslationsB02SplitExpenseEditButtonsZhTw {
	TranslationsB02SplitExpenseEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '確認分拆'
	String get confirm_split => '確認分拆';
}

// Path: b02_split_expense_edit.hint
class TranslationsB02SplitExpenseEditHintZhTw {
	TranslationsB02SplitExpenseEditHintZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '例：子項目'
	String get sub_item => '例：子項目';
}

// Path: b03_split_method_edit.buttons
class TranslationsB03SplitMethodEditButtonsZhTw {
	TranslationsB03SplitMethodEditButtonsZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '調整權重'
	String get adjust_weight => '調整權重';
}

// Path: b03_split_method_edit.label
class TranslationsB03SplitMethodEditLabelZhTw {
	TranslationsB03SplitMethodEditLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '{current} / {target}'
	String total({required Object current, required Object target}) => '${current} / ${target}';
}

// Path: b04_payment_merge.label
class TranslationsB04PaymentMergeLabelZhTw {
	TranslationsB04PaymentMergeLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '代表'
	String get head_member => '代表';

	/// zh-TW: '合併總額'
	String get merge_amount => '合併總額';
}

// Path: b07_payment_method_edit.label
class TranslationsB07PaymentMethodEditLabelZhTw {
	TranslationsB07PaymentMethodEditLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '支付金額'
	String get amount => '支付金額';

	/// zh-TW: '費用總額'
	String get total_expense => '費用總額';

	/// zh-TW: '預收款支付'
	String get prepay => '預收款支付';

	/// zh-TW: '代墊總計'
	String get total_advance => '代墊總計';
}

// Path: b07_payment_method_edit.status
class TranslationsB07PaymentMethodEditStatusZhTw {
	TranslationsB07PaymentMethodEditStatusZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '餘額不足'
	String get not_enough => '餘額不足';

	/// zh-TW: '金額吻合'
	String get balanced => '金額吻合';

	/// zh-TW: '差額 {amount}'
	String remaining({required Object amount}) => '差額 ${amount}';
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

// Path: error.message
class TranslationsErrorMessageZhTw {
	TranslationsErrorMessageZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '發生未知錯誤。'
	String get unknown => '發生未知錯誤。';

	/// zh-TW: '金額無效。'
	String get invalid_amount => '金額無效。';

	/// zh-TW: '此欄位為必填。'
	String get required => '此欄位為必填。';

	/// zh-TW: '請輸入{key}。'
	String empty({required Object key}) => '請輸入${key}。';

	/// zh-TW: '格式錯誤。'
	String get format => '格式錯誤。';

	/// zh-TW: '{key}不可為 0。'
	String zero({required Object key}) => '${key}不可為 0。';

	/// zh-TW: '剩餘金額不足。'
	String get amount_not_enough => '剩餘金額不足。';

	/// zh-TW: '金額不符。'
	String get amount_mismatch => '金額不符。';

	/// zh-TW: '此筆款項已被使用或預收款不足，無法更動。'
	String get prepay_is_used => '此筆款項已被使用或預收款不足，無法更動。';

	/// zh-TW: '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。'
	String get data_is_used => '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。';

	/// zh-TW: '權限不足，無法執行此操作。'
	String get permission_denied => '權限不足，無法執行此操作。';

	/// zh-TW: '網路連線失敗，請檢查網路連線。'
	String get network_error => '網路連線失敗，請檢查網路連線。';

	/// zh-TW: '找不到相關資料。'
	String get data_not_found => '找不到相關資料。';

	/// zh-TW: '請先輸入{key}。'
	String enter_first({required Object key}) => '請先輸入${key}。';

	/// zh-TW: '無法產生報表，請檢查儲存空間或稍後重試。'
	String get export_failed => '無法產生報表，請檢查儲存空間或稍後重試。';

	/// zh-TW: '儲存失敗，請稍後再試。'
	String get save_failed => '儲存失敗，請稍後再試。';

	/// zh-TW: '刪除失敗，請稍後再試。'
	String get delete_failed => '刪除失敗，請稍後再試。';

	/// zh-TW: '任務結束失敗，請稍後再試。'
	String get task_close_failed => '任務結束失敗，請稍後再試。';

	/// zh-TW: '匯率取得失敗。'
	String get rate_fetch_failed => '匯率取得失敗。';

	/// zh-TW: '最多 {max} 個字。'
	String length_exceeded({required Object max}) => '最多 ${max} 個字。';

	/// zh-TW: '包含無效字元。'
	String get invalid_char => '包含無效字元。';

	/// zh-TW: '邀請碼無效，請確認連結是否正確。'
	String get invalid_code => '邀請碼無效，請確認連結是否正確。';

	/// zh-TW: '邀請連結已過期（超過 {expiry_minutes} 分鐘），請隊長重新分享。'
	String expired_code({required Object expiry_minutes}) => '邀請連結已過期（超過 ${expiry_minutes} 分鐘），請隊長重新分享。';

	/// zh-TW: '任務人數已滿（上限{limit}人）。'
	String task_full({required Object limit}) => '任務人數已滿（上限${limit}人）。';

	/// zh-TW: '登入狀態異常，請重新啟動 App。'
	String get auth_required => '登入狀態異常，請重新啟動 App。';

	/// zh-TW: '載入失敗，請稍後再試。'
	String get init_failed => '載入失敗，請稍後再試。';

	/// zh-TW: '帳號未登入，請重新登入。'
	String get unauthorized => '帳號未登入，請重新登入。';

	/// zh-TW: '任務已進入結算狀態，無法修改資料。'
	String get task_locked => '任務已進入結算狀態，無法修改資料。';

	/// zh-TW: '伺服器回應逾時，請稍後再試。'
	String get timeout => '伺服器回應逾時，請稍後再試。';

	/// zh-TW: '系統流量達到上限，請稍後再試。'
	String get quota_exceeded => '系統流量達到上限，請稍後再試。';

	/// zh-TW: '加入任務失敗，請稍後再試。'
	String get join_failed => '加入任務失敗，請稍後再試。';

	/// zh-TW: '無法產生邀請碼，請稍後再試。'
	String get invite_create_failed => '無法產生邀請碼，請稍後再試。';

	/// zh-TW: '檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。'
	String get data_conflict => '檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。';

	/// zh-TW: '此任務狀態異常（可能已被結算），請刷新頁面。'
	String get task_status_error => '此任務狀態異常（可能已被結算），請刷新頁面。';

	/// zh-TW: '系統錯誤，結算失敗，請稍後再試。'
	String get settlement_failed => '系統錯誤，結算失敗，請稍後再試。';

	/// zh-TW: '分享失敗，請稍後再試。'
	String get share_failed => '分享失敗，請稍後再試。';

	/// zh-TW: '登入失敗，請稍後再試。'
	String get login_failed => '登入失敗，請稍後再試。';

	/// zh-TW: '登出失敗，請稍後再試。'
	String get logout_failed => '登出失敗，請稍後再試。';

	/// zh-TW: '掃描失敗，請稍後再試。'
	String get scan_failed => '掃描失敗，請稍後再試。';

	/// zh-TW: '無效的行動條碼。'
	String get invalid_qr_code => '無效的行動條碼。';

	/// zh-TW: '請於系統設定中開啟相機權限。'
	String get camera_permission_denied => '請於系統設定中開啟相機權限。';
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

// Path: common.remainder_rule.content
class TranslationsCommonRemainderRuleContentZhTw {
	TranslationsCommonRemainderRuleContentZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '零頭 {amount} 源自於匯率換算或分攤計算時產生的微小差額。'
	String remainder({required Object amount}) => '零頭 ${amount} 源自於匯率換算或分攤計算時產生的微小差額。';

	/// zh-TW: '系統將於每次結算時，隨機指定一位成員承擔零頭差額。'
	String get random => '系統將於每次結算時，隨機指定一位成員承擔零頭差額。';

	/// zh-TW: '依照成員加入的順序，將零頭依序分配，直到分完為止。'
	String get order => '依照成員加入的順序，將零頭依序分配，直到分完為止。';

	/// zh-TW: '指定一位成員固定承擔所有零頭差額。'
	String get member => '指定一位成員固定承擔所有零頭差額。';
}

// Path: common.remainder_rule.message
class TranslationsCommonRemainderRuleMessageZhTw {
	TranslationsCommonRemainderRuleMessageZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '零頭 {amount} 將暫存，於結算時分配。'
	String remainder({required Object amount}) => '零頭 ${amount} 將暫存，於結算時分配。';

	/// zh-TW: '零頭 {amount} 已與支付匯差自動抵銷。'
	String zero_balance({required Object amount}) => '零頭 ${amount} 已與支付匯差自動抵銷。';
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

// Path: common.payment_info.content
class TranslationsCommonPaymentInfoContentZhTw {
	TranslationsCommonPaymentInfoContentZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '不顯示詳細資訊，請成員直接聯繫'
	String get private => '不顯示詳細資訊，請成員直接聯繫';

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

// Path: common.terms.label
class TranslationsCommonTermsLabelZhTw {
	TranslationsCommonTermsLabelZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '服務條款'
	String get terms => '服務條款';

	/// zh-TW: '隱私政策'
	String get privacy => '隱私政策';

	/// zh-TW: '法律條款'
	String get both => '法律條款';
}

// Path: common.share.invite
class TranslationsCommonShareInviteZhTw {
	TranslationsCommonShareInviteZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '邀請加入 Iron Split 任務'
	String get subject => '邀請加入 Iron Split 任務';

	/// zh-TW: '邀請加入 Iron Split 任務「{taskName}」。 邀請碼：{code} 連結：{link}'
	String content({required Object taskName, required Object code, required Object link}) => '邀請加入 Iron Split 任務「${taskName}」。\n邀請碼：${code}\n連結：${link}';
}

// Path: common.share.settlement
class TranslationsCommonShareSettlementZhTw {
	TranslationsCommonShareSettlementZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: 'Iron Split 任務結算通知'
	String get subject => 'Iron Split 任務結算通知';

	/// zh-TW: '結算已完成。 請開啟 Iron Split App 確認「{taskName}」的支付金額。 連結：{link}'
	String content({required Object taskName, required Object link}) => '結算已完成。\n請開啟 Iron Split App 確認「${taskName}」的支付金額。\n連結：${link}';
}

// Path: s15_record_edit.hint.category
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

	/// zh-TW: '門票'
	String get entertainment => '門票';

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
	String content({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。';
}

// Path: error.dialog.expired_code
class TranslationsErrorDialogExpiredCodeZhTw {
	TranslationsErrorDialogExpiredCodeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '邀請碼已過期'
	String get title => '邀請碼已過期';

	/// zh-TW: '此邀請連結已失效（有效時間 {minutes} 分鐘）。請隊長重新產生。'
	String content({required Object minutes}) => '此邀請連結已失效（有效時間 ${minutes} 分鐘）。請隊長重新產生。';
}

// Path: error.dialog.invalid_code
class TranslationsErrorDialogInvalidCodeZhTw {
	TranslationsErrorDialogInvalidCodeZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '連結無效'
	String get title => '連結無效';

	/// zh-TW: '無效的邀請連結，請確認是否正確或已被刪除。'
	String get content => '無效的邀請連結，請確認是否正確或已被刪除。';
}

// Path: error.dialog.auth_required
class TranslationsErrorDialogAuthRequiredZhTw {
	TranslationsErrorDialogAuthRequiredZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '需要登入'
	String get title => '需要登入';

	/// zh-TW: '請先登入後再加入任務。'
	String get content => '請先登入後再加入任務。';
}

// Path: error.dialog.already_in_task
class TranslationsErrorDialogAlreadyInTaskZhTw {
	TranslationsErrorDialogAlreadyInTaskZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '已是成員'
	String get title => '已是成員';

	/// zh-TW: '已加入此任務。'
	String get content => '已加入此任務。';
}

// Path: error.dialog.unknown
class TranslationsErrorDialogUnknownZhTw {
	TranslationsErrorDialogUnknownZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '發生錯誤'
	String get title => '發生錯誤';

	/// zh-TW: '發生未預期的錯誤，請稍後再試。'
	String get content => '發生未預期的錯誤，請稍後再試。';
}

// Path: error.dialog.delete_failed
class TranslationsErrorDialogDeleteFailedZhTw {
	TranslationsErrorDialogDeleteFailedZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '刪除失敗'
	String get title => '刪除失敗';

	/// zh-TW: '刪除失敗，請稍後再試。'
	String get content => '刪除失敗，請稍後再試。';
}

// Path: error.dialog.member_delete_failed
class TranslationsErrorDialogMemberDeleteFailedZhTw {
	TranslationsErrorDialogMemberDeleteFailedZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '無法刪除成員'
	String get title => '無法刪除成員';

	/// zh-TW: '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。'
	String get content => '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。';
}

// Path: error.dialog.data_conflict
class TranslationsErrorDialogDataConflictZhTw {
	TranslationsErrorDialogDataConflictZhTw.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh-TW: '帳目已變動'
	String get title => '帳目已變動';

	/// zh-TW: '檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。'
	String get content => '檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。';
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
			'common.buttons.save' => '儲存',
			'common.buttons.edit' => '編輯',
			'common.buttons.close' => '關閉',
			'common.buttons.download' => '下載紀錄',
			'common.buttons.settlement' => '結算',
			'common.buttons.discard' => '放棄變更',
			'common.buttons.keep_editing' => '繼續編輯',
			'common.buttons.ok' => '確定',
			'common.buttons.refresh' => '重新整理',
			'common.buttons.retry' => '重試',
			'common.buttons.done' => '完成',
			'common.buttons.agree' => '同意',
			'common.buttons.decline' => '不同意',
			'common.buttons.add_record' => '新增紀錄',
			'common.buttons.copy' => '複製',
			'common.label.task_name' => '任務名稱',
			'common.label.item_name' => '項目名稱',
			'common.label.sub_item' => '細項名稱',
			'common.label.amount' => '金額',
			'common.label.date' => '日期',
			'common.label.currency' => '結算幣別',
			'common.label.split_method' => '分攤設定',
			'common.label.start_date' => '開始日期',
			'common.label.end_date' => '結束日期',
			'common.label.member_count' => '參加人數',
			'common.label.period' => '期間',
			'common.label.payment_method' => '支付方式',
			'common.label.rate' => '匯率',
			'common.label.memo' => '備註',
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
			'common.avatar.cow' => '荷斯登乳牛',
			'common.avatar.pig' => '小豬',
			'common.avatar.deer' => '狍鹿',
			'common.avatar.horse' => '馬',
			'common.avatar.sheep' => '薩福克羊',
			'common.avatar.goat' => '家山羊',
			'common.avatar.duck' => '綠頭鴨',
			'common.avatar.stoat' => '白鼬',
			'common.avatar.rabbit' => '歐洲野兔',
			'common.avatar.mouse' => '老鼠',
			'common.avatar.cat' => '虎斑家貓',
			'common.avatar.dog' => '邊境牧羊犬',
			'common.avatar.otter' => '歐亞水獺',
			'common.avatar.owl' => '倉鴞',
			'common.avatar.fox' => '赤狐',
			'common.avatar.hedgehog' => '歐洲刺蝟',
			'common.avatar.donkey' => '驢子',
			'common.avatar.squirrel' => '紅松鼠',
			'common.avatar.badger' => '歐洲獾',
			'common.avatar.robin' => '歐亞知更鳥',
			'common.remainder_rule.title' => '零頭處理',
			'common.remainder_rule.rule.random' => '隨機指定',
			'common.remainder_rule.rule.order' => '順序輪替',
			'common.remainder_rule.rule.member' => '指定成員',
			'common.remainder_rule.content.remainder' => ({required Object amount}) => '零頭 ${amount} 源自於匯率換算或分攤計算時產生的微小差額。',
			'common.remainder_rule.content.random' => '系統將於每次結算時，隨機指定一位成員承擔零頭差額。',
			'common.remainder_rule.content.order' => '依照成員加入的順序，將零頭依序分配，直到分完為止。',
			'common.remainder_rule.content.member' => '指定一位成員固定承擔所有零頭差額。',
			'common.remainder_rule.message.remainder' => ({required Object amount}) => '零頭 ${amount} 將暫存，於結算時分配。',
			'common.remainder_rule.message.zero_balance' => ({required Object amount}) => '零頭 ${amount} 已與支付匯差自動抵銷。',
			'common.split_method.even' => '均分',
			'common.split_method.percent' => '比例',
			'common.split_method.exact' => '指定',
			'common.payment_method.member' => '成員代墊',
			'common.payment_method.prepay' => '預收款支付',
			'common.payment_method.mixed' => '混合支付',
			'common.language.title' => '語言設定',
			'common.language.zh_TW' => '繁體中文',
			'common.language.en_US' => '英文',
			'common.language.jp_JP' => '日文',
			'common.theme.title' => '主題設定',
			'common.theme.system' => '系統預設',
			'common.theme.light' => '淺色模式',
			'common.theme.dark' => '深色模式',
			'common.display.title' => '顯示設定',
			'common.display.system' => '系統預設',
			'common.display.enlarged' => '放大顯示',
			'common.display.standard' => '標準顯示',
			'common.payment_info.mode.private' => '請直接私訊聯絡',
			'common.payment_info.mode.public' => '提供收款資訊',
			'common.payment_info.content.private' => '不顯示詳細資訊，請成員直接聯繫',
			'common.payment_info.content.public' => '顯示收款資訊給成員',
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
			'common.payment_status.refund' => '可退',
			'common.terms.label.terms' => '服務條款',
			'common.terms.label.privacy' => '隱私政策',
			'common.terms.label.both' => '法律條款',
			'common.terms.and' => '和',
			'common.share.invite.subject' => '邀請加入 Iron Split 任務',
			'common.share.invite.content' => ({required Object taskName, required Object code, required Object link}) => '邀請加入 Iron Split 任務「${taskName}」。\n邀請碼：${code}\n連結：${link}',
			'common.share.settlement.subject' => 'Iron Split 任務結算通知',
			'common.share.settlement.content' => ({required Object taskName, required Object link}) => '結算已完成。\n請開啟 Iron Split App 確認「${taskName}」的支付金額。\n連結：${link}',
			'common.preparing' => '準備中...',
			'common.me' => '我',
			'common.required' => '必填',
			'common.member_prefix' => '成員',
			'common.no_record' => '尚無紀錄',
			'common.today' => '今天',
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
			's10_home_task_list.title' => '任務列表',
			's10_home_task_list.tab.in_progress' => '進行中',
			's10_home_task_list.tab.completed' => '已完成',
			's10_home_task_list.empty.in_progress' => '目前沒有進行中的任務',
			's10_home_task_list.empty.completed' => '沒有已完成的任務',
			's10_home_task_list.buttons.add_task' => '新增任務',
			's10_home_task_list.buttons.join_task' => '加入任務',
			's10_home_task_list.date_tbd' => '日期未定',
			's10_home_task_list.label.settlement' => '已結算',
			's11_invite_confirm.title' => '加入任務',
			's11_invite_confirm.subtitle' => '受邀加入以下任務',
			's11_invite_confirm.buttons.join' => '加入',
			's11_invite_confirm.buttons.back_task_list' => '回任務列表',
			's11_invite_confirm.label.select_ghost' => '選擇要繼承的成員',
			's11_invite_confirm.label.prepaid' => '已代墊',
			's11_invite_confirm.label.expense' => '應分攤',
			's12_task_close_notice.title' => '結束任務確認',
			's12_task_close_notice.content' => '結束任務後，所有紀錄與設定將被鎖定。系統將進入唯讀模式，將無法新增或編輯任何資料。',
			's12_task_close_notice.buttons.close_task' => '結束任務',
			's13_task_dashboard.title' => '任務總覽',
			's13_task_dashboard.buttons.add' => '新增',
			's13_task_dashboard.tab.group' => '群組',
			's13_task_dashboard.tab.personal' => '個人',
			's13_task_dashboard.label.total_expense' => '總費用',
			's13_task_dashboard.label.total_prepay' => '總預收',
			's13_task_dashboard.label.total_expense_personal' => '總費用',
			's13_task_dashboard.label.total_prepay_personal' => '總預收（含代墊）',
			's13_task_dashboard.empty.records' => '尚無紀錄',
			's13_task_dashboard.empty.personal_records' => '尚無紀錄',
			's13_task_dashboard.daily_expense_label' => '支出',
			's13_task_dashboard.dialog_balance_detail' => '收支幣別明細',
			's13_task_dashboard.section.expense' => '支出明細',
			's13_task_dashboard.section.prepay' => '預收明細',
			's13_task_dashboard.section.prepay_balance' => '預收餘額',
			's13_task_dashboard.section.no_data' => '無資料',
			's14_task_settings.title' => '任務設定',
			's14_task_settings.section.task_name' => '任務名稱',
			's14_task_settings.section.task_period' => '任務期間',
			's14_task_settings.section.settlement' => '結算設定',
			's14_task_settings.section.other' => '其他設定',
			's14_task_settings.menu.invite' => '發送邀請',
			's14_task_settings.menu.member_settings' => '成員設定',
			's14_task_settings.menu.history' => '歷史紀錄',
			's14_task_settings.menu.close_task' => '結束任務',
			's15_record_edit.title.add' => '新增紀錄',
			's15_record_edit.title.edit' => '編輯紀錄',
			's15_record_edit.buttons.add_item' => '新增細項',
			's15_record_edit.section.split' => '分攤資訊',
			's15_record_edit.section.items' => '細項分拆',
			's15_record_edit.val.prepay' => '預收',
			's15_record_edit.val.member_paid' => ({required Object name}) => '${name} 代墊',
			's15_record_edit.val.split_details' => '細項分拆',
			's15_record_edit.val.split_summary' => ({required Object amount, required Object method}) => '總計 ${amount} 由 ${method} 分攤',
			's15_record_edit.val.converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			's15_record_edit.val.split_remaining' => '剩餘金額',
			's15_record_edit.val.mock_note' => '細項說明',
			's15_record_edit.tab.expense' => '費用',
			's15_record_edit.tab.prepay' => '預收',
			's15_record_edit.base_card' => '剩餘金額',
			's15_record_edit.type_prepay' => '預收款',
			's15_record_edit.payer_multiple' => '多人',
			's15_record_edit.rate_dialog.title' => '匯率來源',
			's15_record_edit.rate_dialog.content' => '匯率資料來自 Open Exchange Rates（免費版），僅供參考。實際匯率請依換匯水單為準。',
			's15_record_edit.label.rate_with_base' => ({required Object base, required Object target}) => '匯率（1 ${base} = ? ${target}）',
			's15_record_edit.hint.category.food' => '晚餐',
			's15_record_edit.hint.category.transport' => '車費',
			's15_record_edit.hint.category.shopping' => '紀念品',
			's15_record_edit.hint.category.entertainment' => '門票',
			's15_record_edit.hint.category.accommodation' => '住宿費',
			's15_record_edit.hint.category.others' => '其他費用',
			's15_record_edit.hint.item' => ({required Object category}) => '例：${category}',
			's15_record_edit.hint.memo' => '例：備註事項',
			's16_task_create_edit.title' => '新增任務',
			's16_task_create_edit.section.task_name' => '任務名稱',
			's16_task_create_edit.section.task_period' => '任務期間',
			's16_task_create_edit.section.settlement' => '結算設定',
			's16_task_create_edit.label.name_counter' => ({required Object current, required Object max}) => '${current}/${max}',
			's16_task_create_edit.hint.name' => '例：東京五日遊',
			's17_task_locked.buttons.notify_members' => '通知成員',
			's17_task_locked.buttons.view_payment_info' => '隊長收退款帳戶',
			's17_task_locked.section.pending' => '待處理',
			's17_task_locked.section.cleared' => '已處理',
			's17_task_locked.retention_notice' => ({required Object days}) => '資料將於 ${days} 天後自動刪除。請在期間內下載任務紀錄',
			's17_task_locked.remainder_absorbed_by' => ({required Object name}) => '由 ${name} 承擔',
			's17_task_locked.export.report_info' => '報表資訊',
			's17_task_locked.export.task_name' => '任務名稱',
			's17_task_locked.export.export_time' => '報表製作時間',
			's17_task_locked.export.base_currency' => '結算幣別',
			's17_task_locked.export.settlement_summary' => '結算總表',
			's17_task_locked.export.member' => '成員',
			's17_task_locked.export.role' => '角色',
			's17_task_locked.export.net_amount' => '淨額',
			's17_task_locked.export.status' => '狀態',
			's17_task_locked.export.receiver' => '可退',
			's17_task_locked.export.payer' => '應付',
			's17_task_locked.export.cleared' => '已處理',
			's17_task_locked.export.pending' => '未處理',
			's17_task_locked.export.fund_analysis' => '資金與零頭',
			's17_task_locked.export.total_expense' => '總費用',
			's17_task_locked.export.total_prepay' => '總預收',
			's17_task_locked.export.remainder_buffer' => '零頭總額',
			's17_task_locked.export.remainder_absorbed_by' => '零頭得主',
			's17_task_locked.export.transaction_details' => '交易流水帳',
			's17_task_locked.export.date' => '日期',
			's17_task_locked.export.title' => '標題',
			's17_task_locked.export.type' => '類型',
			's17_task_locked.export.original_amount' => '原始金額',
			's17_task_locked.export.currency' => '幣別',
			's17_task_locked.export.rate' => '匯率',
			's17_task_locked.export.base_amount' => '結算幣別金額',
			's17_task_locked.export.net_remainder' => '零頭',
			's17_task_locked.export.pool' => '預收款',
			's17_task_locked.export.mixed' => '混合支付',
			's18_task_join.title' => '加入任務',
			's18_task_join.tabs.input' => '輸入',
			's18_task_join.tabs.scan' => '掃描',
			's18_task_join.label.input' => '邀請碼',
			's18_task_join.hint.input' => '請輸入 8 碼邀請碼',
			's18_task_join.content.scan' => '請將行動條碼放入框內即可自動掃描',
			's30_settlement_confirm.title' => '結算確認',
			's30_settlement_confirm.buttons.set_payment_info' => '收款設定',
			's30_settlement_confirm.steps.confirm_amount' => '確認金額',
			's30_settlement_confirm.steps.payment_info' => '收款設定',
			's30_settlement_confirm.warning.random_reveal' => '零頭歸屬將於下一步結算完成後揭曉。',
			's30_settlement_confirm.list_item.merged_label' => '合併',
			's30_settlement_confirm.list_item.includes' => '包含：',
			's30_settlement_confirm.list_item.principal' => '本金',
			's30_settlement_confirm.list_item.random_remainder' => '隨機零頭',
			's30_settlement_confirm.list_item.remainder' => '零頭',
			's31_settlement_payment_info.title' => '收款資訊',
			's31_settlement_payment_info.setup_instruction' => '收款資訊僅供本次結算使用。預設資料加密儲存於本機。',
			's31_settlement_payment_info.sync_save' => '設為預設收款資訊（僅儲存於本機）',
			's31_settlement_payment_info.sync_update' => '同步更新預設收款資訊',
			's31_settlement_payment_info.buttons.prev_step' => '上一步',
			's32_settlement_result.title' => '結算成功',
			's32_settlement_result.content' => '帳目已確認。請通知成員完成付款。',
			's32_settlement_result.waiting_reveal' => '等待揭曉...',
			's32_settlement_result.remainder_winner_prefix' => '零頭歸屬：',
			's32_settlement_result.remainder_winner_total' => ({required Object winnerName, required Object prefix, required Object total}) => '${winnerName}總金額為：${prefix}${total}',
			's32_settlement_result.total_label' => '本次結算總額',
			's32_settlement_result.buttons.share' => '發送結算通知',
			's32_settlement_result.buttons.back_task_dashboard' => '返回任務',
			's50_onboarding_consent.title' => '歡迎使用 Iron Split',
			's50_onboarding_consent.buttons.start' => '開始',
			's50_onboarding_consent.content.prefix' => '讓分帳變得簡單。\n\n我是艾隆・魯斯特，負責記帳與分攤。\n無論是旅行、聚餐、共同生活，支出將被清楚紀錄，分攤方式皆有明確規則。\n\n分帳，本該清楚。\n\n點擊「開始」即表示同意我們的 ',
			's50_onboarding_consent.content.suffix' => '。',
			's51_onboarding_name.title' => '名稱設定',
			's51_onboarding_name.content' => '請輸入顯示名稱。',
			's51_onboarding_name.label' => '顯示名稱',
			's51_onboarding_name.hint' => '輸入暱稱',
			's51_onboarding_name.counter' => ({required Object current, required Object max}) => '${current}/${max}',
			's52_task_settings_log.title' => '活動紀錄',
			's52_task_settings_log.buttons.export_csv' => '匯出 CSV',
			's52_task_settings_log.empty_log' => '目前沒有任何活動紀錄',
			's52_task_settings_log.export_file_prefix' => '活動紀錄',
			's52_task_settings_log.csv_header.time' => '時間',
			's52_task_settings_log.csv_header.user' => '操作者',
			's52_task_settings_log.csv_header.action' => '動作',
			's52_task_settings_log.csv_header.details' => '內容',
			's52_task_settings_log.type.prepay' => '預收',
			's52_task_settings_log.type.expense' => '支出',
			's52_task_settings_log.payment_type.prepay' => '預收款支付',
			's52_task_settings_log.payment_type.single_suffix' => '代墊',
			's52_task_settings_log.payment_type.multiple' => '多人代墊',
			's52_task_settings_log.unit.members' => '人',
			's52_task_settings_log.unit.items' => '細項',
			's53_task_settings_members.title' => '成員管理',
			's53_task_settings_members.buttons.add_member' => '新增成員',
			's53_task_settings_members.label.default_ratio' => '預設比例',
			's53_task_settings_members.member_default_name' => '成員',
			's53_task_settings_members.member_name' => '成員名稱',
			's54_task_settings_invite.title' => '任務邀請',
			's54_task_settings_invite.buttons.share' => '分享',
			's54_task_settings_invite.buttons.regenerate' => '重新產生',
			's54_task_settings_invite.label.expires_in' => '有效期限',
			's54_task_settings_invite.label.invite_expired' => '邀請碼已過期',
			's70_system_settings.title' => '系統設定',
			's70_system_settings.section.basic' => '基本設定',
			's70_system_settings.section.legal' => '相關條款',
			's70_system_settings.section.account' => '帳號設定',
			's70_system_settings.menu.user_name' => '顯示名稱',
			's70_system_settings.menu.language' => '顯示語言',
			's70_system_settings.menu.theme' => '外觀主題',
			's70_system_settings.menu.terms' => '服務條款',
			's70_system_settings.menu.privacy' => '隱私政策',
			's70_system_settings.menu.payment_info' => '收款帳戶設定',
			's70_system_settings.menu.delete_account' => '刪除帳號',
			's72_terms_update.title' => ({required Object type}) => '${type}更新',
			's72_terms_update.content' => ({required Object type}) => '我們更新了${type}，請閱讀並同意以繼續使用。',
			's74_delete_account_notice.title' => '刪除帳號確認',
			's74_delete_account_notice.content' => '此動作無法復原，個人資料將被刪除，隊長權限將會自動移轉至其他成員，但在共用帳本中的紀錄將會保留（轉為未連結狀態）。',
			's74_delete_account_notice.buttons.delete_account' => '刪除帳號',
			'd01_member_role_intro.title' => '本次角色',
			'd01_member_role_intro.buttons.reroll' => '換個動物',
			'd01_member_role_intro.buttons.enter' => '進入任務',
			'd01_member_role_intro.content' => ({required Object avatar}) => '本次任務的專屬頭像${avatar}。\n分帳紀錄將以 ${avatar} 代表。',
			'd01_member_role_intro.reroll.empty' => '機會已用完',
			'd02_invite_result.title' => '加入失敗',
			'd03_task_create_confirm.title' => '任務設定確認',
			'd03_task_create_confirm.buttons.back_edit' => '返回編輯',
			'd04_common_unsaved_confirm.title' => '尚未儲存',
			'd04_common_unsaved_confirm.content' => '變更將不會被儲存，確定要離開嗎？',
			'd05_date_jump_no_result.title' => '無紀錄',
			'd05_date_jump_no_result.content' => '此日期無紀錄。是否新增？',
			'd06_settlement_confirm.title' => '結算確認',
			'd06_settlement_confirm.content' => '結算後任務將立即鎖定，無法新增、刪除或編輯紀錄。\n請確認帳目已核對無誤。',
			'd08_task_closed_confirm.title' => '結束任務確認',
			'd08_task_closed_confirm.content' => '此操作無法復原。所有資料將被永久鎖定。\n\n確定要繼續嗎？',
			'd09_task_settings_currency_confirm.title' => '變更結算幣別',
			'd09_task_settings_currency_confirm.content' => '變更幣別將會重置所有匯率設定，這可能會影響目前的帳目金額。確定要變更嗎？',
			'd10_record_delete_confirm.title' => '刪除紀錄確認',
			'd10_record_delete_confirm.content' => ({required Object title, required Object amount}) => '確定要刪除 ${title}（${amount}）嗎？',
			'd11_random_result.title' => '零頭得主',
			'd11_random_result.skip' => '略過',
			'd12_logout_confirm.title' => '登出確認',
			'd12_logout_confirm.content' => '若不同意更新後的條款，將無法繼續使用本服務。\n帳號將會登出。',
			'd12_logout_confirm.buttons.logout' => '確認登出',
			'd13_delete_account_confirm.title' => '刪除帳號確認',
			'd13_delete_account_confirm.content' => '此操作無法復原。所有資料將被永久刪除。\n\n確定要繼續嗎？',
			'd14_date_select.title' => '選擇日期',
			'b02_split_expense_edit.title' => '編輯細項',
			'b02_split_expense_edit.buttons.confirm_split' => '確認分拆',
			'b02_split_expense_edit.item_name_empty' => '項目名稱尚未輸入',
			'b02_split_expense_edit.hint.sub_item' => '例：子項目',
			'b03_split_method_edit.title' => '分攤方式設定',
			'b03_split_method_edit.buttons.adjust_weight' => '調整權重',
			'b03_split_method_edit.label.total' => ({required Object current, required Object target}) => '${current} / ${target}',
			'b03_split_method_edit.mismatch' => '金額不符',
			'b04_payment_merge.title' => '合併成員款項',
			'b04_payment_merge.label.head_member' => '代表',
			'b04_payment_merge.label.merge_amount' => '合併總額',
			'b07_payment_method_edit.title' => '資金來源設定',
			'b07_payment_method_edit.prepay_balance' => ({required Object amount}) => '預收款餘額：${amount}',
			'b07_payment_method_edit.payer_member' => '代墊成員',
			'b07_payment_method_edit.label.amount' => '支付金額',
			'b07_payment_method_edit.label.total_expense' => '費用總額',
			'b07_payment_method_edit.label.prepay' => '預收款支付',
			'b07_payment_method_edit.label.total_advance' => '代墊總計',
			'b07_payment_method_edit.status.not_enough' => '餘額不足',
			'b07_payment_method_edit.status.balanced' => '金額吻合',
			'b07_payment_method_edit.status.remaining' => ({required Object amount}) => '差額 ${amount}',
			'success.saved' => '已成功儲存。',
			'success.deleted' => '已成功刪除。',
			'success.copied' => '已複製到剪貼簿',
			'error.title' => '錯誤',
			'error.unknown' => ({required Object error}) => '發生未知錯誤：${error}',
			'error.dialog.task_full.title' => '任務已滿',
			'error.dialog.task_full.content' => ({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。',
			'error.dialog.expired_code.title' => '邀請碼已過期',
			'error.dialog.expired_code.content' => ({required Object minutes}) => '此邀請連結已失效（有效時間 ${minutes} 分鐘）。請隊長重新產生。',
			'error.dialog.invalid_code.title' => '連結無效',
			'error.dialog.invalid_code.content' => '無效的邀請連結，請確認是否正確或已被刪除。',
			'error.dialog.auth_required.title' => '需要登入',
			'error.dialog.auth_required.content' => '請先登入後再加入任務。',
			'error.dialog.already_in_task.title' => '已是成員',
			'error.dialog.already_in_task.content' => '已加入此任務。',
			'error.dialog.unknown.title' => '發生錯誤',
			'error.dialog.unknown.content' => '發生未預期的錯誤，請稍後再試。',
			'error.dialog.delete_failed.title' => '刪除失敗',
			'error.dialog.delete_failed.content' => '刪除失敗，請稍後再試。',
			'error.dialog.member_delete_failed.title' => '無法刪除成員',
			'error.dialog.member_delete_failed.content' => '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。',
			'error.dialog.data_conflict.title' => '帳目已變動',
			'error.dialog.data_conflict.content' => '檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。',
			'error.message.unknown' => '發生未知錯誤。',
			'error.message.invalid_amount' => '金額無效。',
			'error.message.required' => '此欄位為必填。',
			'error.message.empty' => ({required Object key}) => '請輸入${key}。',
			'error.message.format' => '格式錯誤。',
			'error.message.zero' => ({required Object key}) => '${key}不可為 0。',
			'error.message.amount_not_enough' => '剩餘金額不足。',
			'error.message.amount_mismatch' => '金額不符。',
			'error.message.prepay_is_used' => '此筆款項已被使用或預收款不足，無法更動。',
			'error.message.data_is_used' => '此成員尚有相關的記帳紀錄或款項未結清。請先修改或刪除相關紀錄後再試。',
			'error.message.permission_denied' => '權限不足，無法執行此操作。',
			'error.message.network_error' => '網路連線失敗，請檢查網路連線。',
			'error.message.data_not_found' => '找不到相關資料。',
			'error.message.enter_first' => ({required Object key}) => '請先輸入${key}。',
			'error.message.export_failed' => '無法產生報表，請檢查儲存空間或稍後重試。',
			'error.message.save_failed' => '儲存失敗，請稍後再試。',
			'error.message.delete_failed' => '刪除失敗，請稍後再試。',
			'error.message.task_close_failed' => '任務結束失敗，請稍後再試。',
			'error.message.rate_fetch_failed' => '匯率取得失敗。',
			'error.message.length_exceeded' => ({required Object max}) => '最多 ${max} 個字。',
			'error.message.invalid_char' => '包含無效字元。',
			'error.message.invalid_code' => '邀請碼無效，請確認連結是否正確。',
			'error.message.expired_code' => ({required Object expiry_minutes}) => '邀請連結已過期（超過 ${expiry_minutes} 分鐘），請隊長重新分享。',
			'error.message.task_full' => ({required Object limit}) => '任務人數已滿（上限${limit}人）。',
			'error.message.auth_required' => '登入狀態異常，請重新啟動 App。',
			'error.message.init_failed' => '載入失敗，請稍後再試。',
			'error.message.unauthorized' => '帳號未登入，請重新登入。',
			'error.message.task_locked' => '任務已進入結算狀態，無法修改資料。',
			'error.message.timeout' => '伺服器回應逾時，請稍後再試。',
			'error.message.quota_exceeded' => '系統流量達到上限，請稍後再試。',
			'error.message.join_failed' => '加入任務失敗，請稍後再試。',
			'error.message.invite_create_failed' => '無法產生邀請碼，請稍後再試。',
			'error.message.data_conflict' => '檢視期間，其他成員更新了帳目。為了確保結算正確，請返回上一頁重新整理。',
			'error.message.task_status_error' => '此任務狀態異常（可能已被結算），請刷新頁面。',
			'error.message.settlement_failed' => '系統錯誤，結算失敗，請稍後再試。',
			'error.message.share_failed' => '分享失敗，請稍後再試。',
			'error.message.login_failed' => '登入失敗，請稍後再試。',
			'error.message.logout_failed' => '登出失敗，請稍後再試。',
			'error.message.scan_failed' => '掃描失敗，請稍後再試。',
			'error.message.invalid_qr_code' => '無效的行動條碼。',
			'error.message.camera_permission_denied' => '請於系統設定中開啟相機權限。',
			_ => null,
		};
	}
}
