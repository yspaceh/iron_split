///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsJaJp extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJaJp({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.jaJp,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja-JP>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsJaJp _root = this; // ignore: unused_field

	@override 
	TranslationsJaJp $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJaJp(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonJaJp common = _TranslationsCommonJaJp._(_root);
	@override late final _TranslationsLogActionJaJp log_action = _TranslationsLogActionJaJp._(_root);
	@override late final _TranslationsS10HomeTaskListJaJp s10_home_task_list = _TranslationsS10HomeTaskListJaJp._(_root);
	@override late final _TranslationsS11InviteConfirmJaJp s11_invite_confirm = _TranslationsS11InviteConfirmJaJp._(_root);
	@override late final _TranslationsS12TaskCloseNoticeJaJp s12_task_close_notice = _TranslationsS12TaskCloseNoticeJaJp._(_root);
	@override late final _TranslationsS13TaskDashboardJaJp s13_task_dashboard = _TranslationsS13TaskDashboardJaJp._(_root);
	@override late final _TranslationsS14TaskSettingsJaJp s14_task_settings = _TranslationsS14TaskSettingsJaJp._(_root);
	@override late final _TranslationsS15RecordEditJaJp s15_record_edit = _TranslationsS15RecordEditJaJp._(_root);
	@override late final _TranslationsS16TaskCreateEditJaJp s16_task_create_edit = _TranslationsS16TaskCreateEditJaJp._(_root);
	@override late final _TranslationsS17TaskLockedJaJp s17_task_locked = _TranslationsS17TaskLockedJaJp._(_root);
	@override late final _TranslationsS18TaskJoinJaJp s18_task_join = _TranslationsS18TaskJoinJaJp._(_root);
	@override late final _TranslationsS30SettlementConfirmJaJp s30_settlement_confirm = _TranslationsS30SettlementConfirmJaJp._(_root);
	@override late final _TranslationsS31SettlementPaymentInfoJaJp s31_settlement_payment_info = _TranslationsS31SettlementPaymentInfoJaJp._(_root);
	@override late final _TranslationsS32SettlementResultJaJp s32_settlement_result = _TranslationsS32SettlementResultJaJp._(_root);
	@override late final _TranslationsS50OnboardingConsentJaJp s50_onboarding_consent = _TranslationsS50OnboardingConsentJaJp._(_root);
	@override late final _TranslationsS51OnboardingNameJaJp s51_onboarding_name = _TranslationsS51OnboardingNameJaJp._(_root);
	@override late final _TranslationsS52TaskSettingsLogJaJp s52_task_settings_log = _TranslationsS52TaskSettingsLogJaJp._(_root);
	@override late final _TranslationsS53TaskSettingsMembersJaJp s53_task_settings_members = _TranslationsS53TaskSettingsMembersJaJp._(_root);
	@override late final _TranslationsS54TaskSettingsInviteJaJp s54_task_settings_invite = _TranslationsS54TaskSettingsInviteJaJp._(_root);
	@override late final _TranslationsS70SystemSettingsJaJp s70_system_settings = _TranslationsS70SystemSettingsJaJp._(_root);
	@override late final _TranslationsS72TermsUpdateJaJp s72_terms_update = _TranslationsS72TermsUpdateJaJp._(_root);
	@override late final _TranslationsS74DeleteAccountNoticeJaJp s74_delete_account_notice = _TranslationsS74DeleteAccountNoticeJaJp._(_root);
	@override late final _TranslationsD01MemberRoleIntroJaJp d01_member_role_intro = _TranslationsD01MemberRoleIntroJaJp._(_root);
	@override late final _TranslationsD02InviteResultJaJp d02_invite_result = _TranslationsD02InviteResultJaJp._(_root);
	@override late final _TranslationsD03TaskCreateConfirmJaJp d03_task_create_confirm = _TranslationsD03TaskCreateConfirmJaJp._(_root);
	@override late final _TranslationsD04CommonUnsavedConfirmJaJp d04_common_unsaved_confirm = _TranslationsD04CommonUnsavedConfirmJaJp._(_root);
	@override late final _TranslationsD05DateJumpNoResultJaJp d05_date_jump_no_result = _TranslationsD05DateJumpNoResultJaJp._(_root);
	@override late final _TranslationsD06SettlementConfirmJaJp d06_settlement_confirm = _TranslationsD06SettlementConfirmJaJp._(_root);
	@override late final _TranslationsD08TaskClosedConfirmJaJp d08_task_closed_confirm = _TranslationsD08TaskClosedConfirmJaJp._(_root);
	@override late final _TranslationsD09TaskSettingsCurrencyConfirmJaJp d09_task_settings_currency_confirm = _TranslationsD09TaskSettingsCurrencyConfirmJaJp._(_root);
	@override late final _TranslationsD10RecordDeleteConfirmJaJp d10_record_delete_confirm = _TranslationsD10RecordDeleteConfirmJaJp._(_root);
	@override late final _TranslationsD11RandomResultJaJp d11_random_result = _TranslationsD11RandomResultJaJp._(_root);
	@override late final _TranslationsD12LogoutConfirmJaJp d12_logout_confirm = _TranslationsD12LogoutConfirmJaJp._(_root);
	@override late final _TranslationsD13DeleteAccountConfirmJaJp d13_delete_account_confirm = _TranslationsD13DeleteAccountConfirmJaJp._(_root);
	@override late final _TranslationsD14DateSelectJaJp d14_date_select = _TranslationsD14DateSelectJaJp._(_root);
	@override late final _TranslationsB02SplitExpenseEditJaJp b02_split_expense_edit = _TranslationsB02SplitExpenseEditJaJp._(_root);
	@override late final _TranslationsB03SplitMethodEditJaJp b03_split_method_edit = _TranslationsB03SplitMethodEditJaJp._(_root);
	@override late final _TranslationsB04PaymentMergeJaJp b04_payment_merge = _TranslationsB04PaymentMergeJaJp._(_root);
	@override late final _TranslationsB07PaymentMethodEditJaJp b07_payment_method_edit = _TranslationsB07PaymentMethodEditJaJp._(_root);
	@override late final _TranslationsSuccessJaJp success = _TranslationsSuccessJaJp._(_root);
	@override late final _TranslationsErrorJaJp error = _TranslationsErrorJaJp._(_root);
}

// Path: common
class _TranslationsCommonJaJp extends TranslationsCommonZhTw {
	_TranslationsCommonJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonButtonsJaJp buttons = _TranslationsCommonButtonsJaJp._(_root);
	@override late final _TranslationsCommonLabelJaJp label = _TranslationsCommonLabelJaJp._(_root);
	@override late final _TranslationsCommonCategoryJaJp category = _TranslationsCommonCategoryJaJp._(_root);
	@override late final _TranslationsCommonCurrencyJaJp currency = _TranslationsCommonCurrencyJaJp._(_root);
	@override late final _TranslationsCommonAvatarJaJp avatar = _TranslationsCommonAvatarJaJp._(_root);
	@override late final _TranslationsCommonRemainderRuleJaJp remainder_rule = _TranslationsCommonRemainderRuleJaJp._(_root);
	@override late final _TranslationsCommonSplitMethodJaJp split_method = _TranslationsCommonSplitMethodJaJp._(_root);
	@override late final _TranslationsCommonPaymentMethodJaJp payment_method = _TranslationsCommonPaymentMethodJaJp._(_root);
	@override late final _TranslationsCommonLanguageJaJp language = _TranslationsCommonLanguageJaJp._(_root);
	@override late final _TranslationsCommonThemeJaJp theme = _TranslationsCommonThemeJaJp._(_root);
	@override late final _TranslationsCommonDisplayJaJp display = _TranslationsCommonDisplayJaJp._(_root);
	@override late final _TranslationsCommonPaymentInfoJaJp payment_info = _TranslationsCommonPaymentInfoJaJp._(_root);
	@override late final _TranslationsCommonPaymentStatusJaJp payment_status = _TranslationsCommonPaymentStatusJaJp._(_root);
	@override late final _TranslationsCommonTermsJaJp terms = _TranslationsCommonTermsJaJp._(_root);
	@override late final _TranslationsCommonShareJaJp share = _TranslationsCommonShareJaJp._(_root);
	@override String get preparing => '準備中...';
	@override String get me => '自分';
	@override String get required => '必須';
	@override String get member_prefix => 'メンバー';
	@override String get no_record => '記録なし';
	@override String get today => '今日';
}

// Path: log_action
class _TranslationsLogActionJaJp extends TranslationsLogActionZhTw {
	_TranslationsLogActionJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get create_task => 'タスク作成';
	@override String get update_settings => '設定更新';
	@override String get add_member => 'メンバー追加';
	@override String get remove_member => 'メンバー削除';
	@override String get create_record => '記録追加';
	@override String get update_record => '記録編集';
	@override String get delete_record => '記録削除';
	@override String get settle_up => '精算実行';
	@override String get unknown => '不明な操作';
	@override String get close_task => 'タスク終了';
}

// Path: s10_home_task_list
class _TranslationsS10HomeTaskListJaJp extends TranslationsS10HomeTaskListZhTw {
	_TranslationsS10HomeTaskListJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク一覧';
	@override late final _TranslationsS10HomeTaskListTabJaJp tab = _TranslationsS10HomeTaskListTabJaJp._(_root);
	@override late final _TranslationsS10HomeTaskListEmptyJaJp empty = _TranslationsS10HomeTaskListEmptyJaJp._(_root);
	@override late final _TranslationsS10HomeTaskListButtonsJaJp buttons = _TranslationsS10HomeTaskListButtonsJaJp._(_root);
	@override String get date_tbd => '日付未定';
	@override late final _TranslationsS10HomeTaskListLabelJaJp label = _TranslationsS10HomeTaskListLabelJaJp._(_root);
}

// Path: s11_invite_confirm
class _TranslationsS11InviteConfirmJaJp extends TranslationsS11InviteConfirmZhTw {
	_TranslationsS11InviteConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク参加';
	@override String get subtitle => '以下のタスクへの招待';
	@override late final _TranslationsS11InviteConfirmButtonsJaJp buttons = _TranslationsS11InviteConfirmButtonsJaJp._(_root);
	@override late final _TranslationsS11InviteConfirmLabelJaJp label = _TranslationsS11InviteConfirmLabelJaJp._(_root);
}

// Path: s12_task_close_notice
class _TranslationsS12TaskCloseNoticeJaJp extends TranslationsS12TaskCloseNoticeZhTw {
	_TranslationsS12TaskCloseNoticeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク終了';
	@override late final _TranslationsS12TaskCloseNoticeButtonsJaJp buttons = _TranslationsS12TaskCloseNoticeButtonsJaJp._(_root);
	@override String get content => 'このタスクを終了すると、すべての記録および設定がロックされます。読み取り専用モードに移行し、データの追加や編集はできなくなります。';
}

// Path: s13_task_dashboard
class _TranslationsS13TaskDashboardJaJp extends TranslationsS13TaskDashboardZhTw {
	_TranslationsS13TaskDashboardJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'ダッシュボード';
	@override late final _TranslationsS13TaskDashboardButtonsJaJp buttons = _TranslationsS13TaskDashboardButtonsJaJp._(_root);
	@override late final _TranslationsS13TaskDashboardTabJaJp tab = _TranslationsS13TaskDashboardTabJaJp._(_root);
	@override late final _TranslationsS13TaskDashboardLabelJaJp label = _TranslationsS13TaskDashboardLabelJaJp._(_root);
	@override late final _TranslationsS13TaskDashboardEmptyJaJp empty = _TranslationsS13TaskDashboardEmptyJaJp._(_root);
	@override String get daily_expense_label => '支出';
	@override String get dialog_balance_detail => '通貨別収支明細';
	@override late final _TranslationsS13TaskDashboardSectionJaJp section = _TranslationsS13TaskDashboardSectionJaJp._(_root);
}

// Path: s14_task_settings
class _TranslationsS14TaskSettingsJaJp extends TranslationsS14TaskSettingsZhTw {
	_TranslationsS14TaskSettingsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク設定';
	@override late final _TranslationsS14TaskSettingsSectionJaJp section = _TranslationsS14TaskSettingsSectionJaJp._(_root);
	@override late final _TranslationsS14TaskSettingsMenuJaJp menu = _TranslationsS14TaskSettingsMenuJaJp._(_root);
}

// Path: s15_record_edit
class _TranslationsS15RecordEditJaJp extends TranslationsS15RecordEditZhTw {
	_TranslationsS15RecordEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsS15RecordEditTitleJaJp title = _TranslationsS15RecordEditTitleJaJp._(_root);
	@override late final _TranslationsS15RecordEditButtonsJaJp buttons = _TranslationsS15RecordEditButtonsJaJp._(_root);
	@override late final _TranslationsS15RecordEditSectionJaJp section = _TranslationsS15RecordEditSectionJaJp._(_root);
	@override late final _TranslationsS15RecordEditValJaJp val = _TranslationsS15RecordEditValJaJp._(_root);
	@override late final _TranslationsS15RecordEditTabJaJp tab = _TranslationsS15RecordEditTabJaJp._(_root);
	@override String get base_card => '残額';
	@override String get type_prepay => '前受金';
	@override String get payer_multiple => '複数人';
	@override late final _TranslationsS15RecordEditRateDialogJaJp rate_dialog = _TranslationsS15RecordEditRateDialogJaJp._(_root);
	@override late final _TranslationsS15RecordEditLabelJaJp label = _TranslationsS15RecordEditLabelJaJp._(_root);
	@override late final _TranslationsS15RecordEditHintJaJp hint = _TranslationsS15RecordEditHintJaJp._(_root);
}

// Path: s16_task_create_edit
class _TranslationsS16TaskCreateEditJaJp extends TranslationsS16TaskCreateEditZhTw {
	_TranslationsS16TaskCreateEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク作成';
	@override late final _TranslationsS16TaskCreateEditSectionJaJp section = _TranslationsS16TaskCreateEditSectionJaJp._(_root);
	@override late final _TranslationsS16TaskCreateEditLabelJaJp label = _TranslationsS16TaskCreateEditLabelJaJp._(_root);
	@override late final _TranslationsS16TaskCreateEditHintJaJp hint = _TranslationsS16TaskCreateEditHintJaJp._(_root);
}

// Path: s17_task_locked
class _TranslationsS17TaskLockedJaJp extends TranslationsS17TaskLockedZhTw {
	_TranslationsS17TaskLockedJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsS17TaskLockedButtonsJaJp buttons = _TranslationsS17TaskLockedButtonsJaJp._(_root);
	@override late final _TranslationsS17TaskLockedSectionJaJp section = _TranslationsS17TaskLockedSectionJaJp._(_root);
	@override String retention_notice({required Object days}) => '${days} 日後にデータは自動削除されます。期間内にダウンロードしてください。';
	@override String remainder_absorbed_by({required Object name}) => '${name} が負担';
	@override late final _TranslationsS17TaskLockedExportJaJp export = _TranslationsS17TaskLockedExportJaJp._(_root);
}

// Path: s18_task_join
class _TranslationsS18TaskJoinJaJp extends TranslationsS18TaskJoinZhTw {
	_TranslationsS18TaskJoinJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク参加';
	@override late final _TranslationsS18TaskJoinTabsJaJp tabs = _TranslationsS18TaskJoinTabsJaJp._(_root);
	@override late final _TranslationsS18TaskJoinLabelJaJp label = _TranslationsS18TaskJoinLabelJaJp._(_root);
	@override late final _TranslationsS18TaskJoinHintJaJp hint = _TranslationsS18TaskJoinHintJaJp._(_root);
	@override late final _TranslationsS18TaskJoinContentJaJp content = _TranslationsS18TaskJoinContentJaJp._(_root);
}

// Path: s30_settlement_confirm
class _TranslationsS30SettlementConfirmJaJp extends TranslationsS30SettlementConfirmZhTw {
	_TranslationsS30SettlementConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '精算確認';
	@override late final _TranslationsS30SettlementConfirmButtonsJaJp buttons = _TranslationsS30SettlementConfirmButtonsJaJp._(_root);
	@override late final _TranslationsS30SettlementConfirmStepsJaJp steps = _TranslationsS30SettlementConfirmStepsJaJp._(_root);
	@override late final _TranslationsS30SettlementConfirmWarningJaJp warning = _TranslationsS30SettlementConfirmWarningJaJp._(_root);
	@override late final _TranslationsS30SettlementConfirmListItemJaJp list_item = _TranslationsS30SettlementConfirmListItemJaJp._(_root);
}

// Path: s31_settlement_payment_info
class _TranslationsS31SettlementPaymentInfoJaJp extends TranslationsS31SettlementPaymentInfoZhTw {
	_TranslationsS31SettlementPaymentInfoJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '受取情報';
	@override String get setup_instruction => '今回の精算のみに使用されます。デフォルト情報は端末内に暗号化保存されます。';
	@override String get sync_save => 'デフォルトの受取情報として保存（端末内）';
	@override String get sync_update => 'デフォルト受取情報を更新';
	@override late final _TranslationsS31SettlementPaymentInfoButtonsJaJp buttons = _TranslationsS31SettlementPaymentInfoButtonsJaJp._(_root);
}

// Path: s32_settlement_result
class _TranslationsS32SettlementResultJaJp extends TranslationsS32SettlementResultZhTw {
	_TranslationsS32SettlementResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '精算完了';
	@override String get content => 'すべての記録が確定しました。メンバーに結果を共有し、支払いを進めてください。';
	@override String get waiting_reveal => '結果を確認中...';
	@override String get remainder_winner_prefix => '端数の受取先：';
	@override String remainder_winner_total({required Object winnerName, required Object prefix, required Object total}) => '${winnerName} の最終金額 ${prefix}${total}';
	@override String get total_label => '今回の精算合計額';
	@override late final _TranslationsS32SettlementResultButtonsJaJp buttons = _TranslationsS32SettlementResultButtonsJaJp._(_root);
}

// Path: s50_onboarding_consent
class _TranslationsS50OnboardingConsentJaJp extends TranslationsS50OnboardingConsentZhTw {
	_TranslationsS50OnboardingConsentJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'Iron Split へようこそ';
	@override late final _TranslationsS50OnboardingConsentButtonsJaJp buttons = _TranslationsS50OnboardingConsentButtonsJaJp._(_root);
	@override late final _TranslationsS50OnboardingConsentContentJaJp content = _TranslationsS50OnboardingConsentContentJaJp._(_root);
}

// Path: s51_onboarding_name
class _TranslationsS51OnboardingNameJaJp extends TranslationsS51OnboardingNameZhTw {
	_TranslationsS51OnboardingNameJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '名前設定';
	@override String get content => 'アプリ内で表示する名前を入力（1–10文字）';
	@override String get hint => 'ニックネームを入力';
	@override String counter({required Object current, required Object max}) => '${current}/${max}';
}

// Path: s52_task_settings_log
class _TranslationsS52TaskSettingsLogJaJp extends TranslationsS52TaskSettingsLogZhTw {
	_TranslationsS52TaskSettingsLogJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '活動履歴';
	@override late final _TranslationsS52TaskSettingsLogButtonsJaJp buttons = _TranslationsS52TaskSettingsLogButtonsJaJp._(_root);
	@override String get empty_log => '活動履歴はありません';
	@override String get export_file_prefix => '活動履歴';
	@override late final _TranslationsS52TaskSettingsLogCsvHeaderJaJp csv_header = _TranslationsS52TaskSettingsLogCsvHeaderJaJp._(_root);
	@override late final _TranslationsS52TaskSettingsLogTypeJaJp type = _TranslationsS52TaskSettingsLogTypeJaJp._(_root);
	@override late final _TranslationsS52TaskSettingsLogPaymentTypeJaJp payment_type = _TranslationsS52TaskSettingsLogPaymentTypeJaJp._(_root);
	@override late final _TranslationsS52TaskSettingsLogUnitJaJp unit = _TranslationsS52TaskSettingsLogUnitJaJp._(_root);
}

// Path: s53_task_settings_members
class _TranslationsS53TaskSettingsMembersJaJp extends TranslationsS53TaskSettingsMembersZhTw {
	_TranslationsS53TaskSettingsMembersJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'メンバー管理';
	@override late final _TranslationsS53TaskSettingsMembersButtonsJaJp buttons = _TranslationsS53TaskSettingsMembersButtonsJaJp._(_root);
	@override late final _TranslationsS53TaskSettingsMembersLabelJaJp label = _TranslationsS53TaskSettingsMembersLabelJaJp._(_root);
	@override String get member_default_name => 'メンバー';
	@override String get member_name => 'メンバー名';
}

// Path: s54_task_settings_invite
class _TranslationsS54TaskSettingsInviteJaJp extends TranslationsS54TaskSettingsInviteZhTw {
	_TranslationsS54TaskSettingsInviteJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク招待';
	@override late final _TranslationsS54TaskSettingsInviteButtonsJaJp buttons = _TranslationsS54TaskSettingsInviteButtonsJaJp._(_root);
	@override late final _TranslationsS54TaskSettingsInviteLabelJaJp label = _TranslationsS54TaskSettingsInviteLabelJaJp._(_root);
}

// Path: s70_system_settings
class _TranslationsS70SystemSettingsJaJp extends TranslationsS70SystemSettingsZhTw {
	_TranslationsS70SystemSettingsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'システム設定';
	@override late final _TranslationsS70SystemSettingsSectionJaJp section = _TranslationsS70SystemSettingsSectionJaJp._(_root);
	@override late final _TranslationsS70SystemSettingsMenuJaJp menu = _TranslationsS70SystemSettingsMenuJaJp._(_root);
}

// Path: s72_terms_update
class _TranslationsS72TermsUpdateJaJp extends TranslationsS72TermsUpdateZhTw {
	_TranslationsS72TermsUpdateJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String title({required Object type}) => '${type}更新';
	@override String content({required Object type}) => '${type} を更新しました。続けてご利用いただくには、内容をご確認のうえ同意してください。';
}

// Path: s74_delete_account_notice
class _TranslationsS74DeleteAccountNoticeJaJp extends TranslationsS74DeleteAccountNoticeZhTw {
	_TranslationsS74DeleteAccountNoticeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'アカウント削除確認';
	@override String get content => 'この操作は元に戻せません。個人情報は削除されます。リーダー権限は自動的に他のメンバーへ移行されますが、共有帳簿内の記録は保持されます（未リンク状態になります）。';
	@override late final _TranslationsS74DeleteAccountNoticeButtonsJaJp buttons = _TranslationsS74DeleteAccountNoticeButtonsJaJp._(_root);
}

// Path: d01_member_role_intro
class _TranslationsD01MemberRoleIntroJaJp extends TranslationsD01MemberRoleIntroZhTw {
	_TranslationsD01MemberRoleIntroJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '今回のキャラクター';
	@override late final _TranslationsD01MemberRoleIntroButtonsJaJp buttons = _TranslationsD01MemberRoleIntroButtonsJaJp._(_root);
	@override String content({required Object avatar}) => '今回のタスクでのアイコン${avatar}です。\n記録には${avatar}が表示されます。';
	@override late final _TranslationsD01MemberRoleIntroRerollJaJp reroll = _TranslationsD01MemberRoleIntroRerollJaJp._(_root);
}

// Path: d02_invite_result
class _TranslationsD02InviteResultJaJp extends TranslationsD02InviteResultZhTw {
	_TranslationsD02InviteResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '参加失敗';
}

// Path: d03_task_create_confirm
class _TranslationsD03TaskCreateConfirmJaJp extends TranslationsD03TaskCreateConfirmZhTw {
	_TranslationsD03TaskCreateConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '設定の確認';
	@override late final _TranslationsD03TaskCreateConfirmButtonsJaJp buttons = _TranslationsD03TaskCreateConfirmButtonsJaJp._(_root);
}

// Path: d04_common_unsaved_confirm
class _TranslationsD04CommonUnsavedConfirmJaJp extends TranslationsD04CommonUnsavedConfirmZhTw {
	_TranslationsD04CommonUnsavedConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '未保存の変更';
	@override String get content => '変更内容は保存されません。';
}

// Path: d05_date_jump_no_result
class _TranslationsD05DateJumpNoResultJaJp extends TranslationsD05DateJumpNoResultZhTw {
	_TranslationsD05DateJumpNoResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '記録なし';
	@override String get content => 'この日付の記録は見つかりませんでした。追加しますか？';
}

// Path: d06_settlement_confirm
class _TranslationsD06SettlementConfirmJaJp extends TranslationsD06SettlementConfirmZhTw {
	_TranslationsD06SettlementConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '精算確認';
	@override String get content => '精算を行うとタスクはロックされ、記録の追加・削除・編集ができなくなります。\n内容をご確認ください。';
}

// Path: d08_task_closed_confirm
class _TranslationsD08TaskClosedConfirmJaJp extends TranslationsD08TaskClosedConfirmZhTw {
	_TranslationsD08TaskClosedConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク終了確認';
	@override String get content => 'この操作は取り消すことができません。すべてのデータは永久にロックされます。\n\n続行してもよろしいですか？';
}

// Path: d09_task_settings_currency_confirm
class _TranslationsD09TaskSettingsCurrencyConfirmJaJp extends TranslationsD09TaskSettingsCurrencyConfirmZhTw {
	_TranslationsD09TaskSettingsCurrencyConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '決済通貨変更';
	@override String get content => '通貨を変更すると、すべての為替レート設定がリセットされます。現在の収支に影響する可能性があります。よろしいですか？';
}

// Path: d10_record_delete_confirm
class _TranslationsD10RecordDeleteConfirmJaJp extends TranslationsD10RecordDeleteConfirmZhTw {
	_TranslationsD10RecordDeleteConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '記録削除確認';
	@override String content({required Object title, required Object amount}) => '${title} （${amount}）を削除してもよろしいですか？';
}

// Path: d11_random_result
class _TranslationsD11RandomResultJaJp extends TranslationsD11RandomResultZhTw {
	_TranslationsD11RandomResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '当選者';
	@override String get skip => 'スキップ';
}

// Path: d12_logout_confirm
class _TranslationsD12LogoutConfirmJaJp extends TranslationsD12LogoutConfirmZhTw {
	_TranslationsD12LogoutConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログアウト確認';
	@override String get content => '更新後の規約に同意しない場合、本サービスを継続して利用することはできません。\nログアウトされます。';
	@override late final _TranslationsD12LogoutConfirmButtonsJaJp buttons = _TranslationsD12LogoutConfirmButtonsJaJp._(_root);
}

// Path: d13_delete_account_confirm
class _TranslationsD13DeleteAccountConfirmJaJp extends TranslationsD13DeleteAccountConfirmZhTw {
	_TranslationsD13DeleteAccountConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'アカウント削除確認';
	@override String get content => 'この操作は取り消すことができません。すべてのデータは永久に削除されます。\n\n続行してもよろしいですか？';
}

// Path: d14_date_select
class _TranslationsD14DateSelectJaJp extends TranslationsD14DateSelectZhTw {
	_TranslationsD14DateSelectJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '日付の選択';
}

// Path: b02_split_expense_edit
class _TranslationsB02SplitExpenseEditJaJp extends TranslationsB02SplitExpenseEditZhTw {
	_TranslationsB02SplitExpenseEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '明細編集';
	@override late final _TranslationsB02SplitExpenseEditButtonsJaJp buttons = _TranslationsB02SplitExpenseEditButtonsJaJp._(_root);
	@override String get item_name_empty => '親項目名を入力してください';
	@override late final _TranslationsB02SplitExpenseEditHintJaJp hint = _TranslationsB02SplitExpenseEditHintJaJp._(_root);
}

// Path: b03_split_method_edit
class _TranslationsB03SplitMethodEditJaJp extends TranslationsB03SplitMethodEditZhTw {
	_TranslationsB03SplitMethodEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '割り勘方法';
	@override late final _TranslationsB03SplitMethodEditButtonsJaJp buttons = _TranslationsB03SplitMethodEditButtonsJaJp._(_root);
	@override late final _TranslationsB03SplitMethodEditLabelJaJp label = _TranslationsB03SplitMethodEditLabelJaJp._(_root);
	@override String get mismatch => '一致しません';
}

// Path: b04_payment_merge
class _TranslationsB04PaymentMergeJaJp extends TranslationsB04PaymentMergeZhTw {
	_TranslationsB04PaymentMergeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '支払い統合';
	@override late final _TranslationsB04PaymentMergeLabelJaJp label = _TranslationsB04PaymentMergeLabelJaJp._(_root);
}

// Path: b07_payment_method_edit
class _TranslationsB07PaymentMethodEditJaJp extends TranslationsB07PaymentMethodEditZhTw {
	_TranslationsB07PaymentMethodEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '資金源を選択';
	@override String prepay_balance({required Object amount}) => '前受金残高：${amount}';
	@override String get payer_member => '支払者';
	@override late final _TranslationsB07PaymentMethodEditLabelJaJp label = _TranslationsB07PaymentMethodEditLabelJaJp._(_root);
	@override late final _TranslationsB07PaymentMethodEditStatusJaJp status = _TranslationsB07PaymentMethodEditStatusJaJp._(_root);
}

// Path: success
class _TranslationsSuccessJaJp extends TranslationsSuccessZhTw {
	_TranslationsSuccessJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get saved => '保存しました。';
	@override String get deleted => '削除しました。';
	@override String get copied => 'コピーしました';
}

// Path: error
class _TranslationsErrorJaJp extends TranslationsErrorZhTw {
	_TranslationsErrorJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'エラー';
	@override String unknown({required Object error}) => '不明なエラー：${error}';
	@override late final _TranslationsErrorDialogJaJp dialog = _TranslationsErrorDialogJaJp._(_root);
	@override late final _TranslationsErrorMessageJaJp message = _TranslationsErrorMessageJaJp._(_root);
}

// Path: common.buttons
class _TranslationsCommonButtonsJaJp extends TranslationsCommonButtonsZhTw {
	_TranslationsCommonButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get delete => '削除';
	@override String get confirm => '確認';
	@override String get back => '戻る';
	@override String get save => '保存';
	@override String get edit => '編集';
	@override String get close => '閉じる';
	@override String get download => 'ダウンロード';
	@override String get settlement => '精算';
	@override String get discard => '破棄';
	@override String get keep_editing => '編集を続行';
	@override String get refresh => '更新';
	@override String get ok => 'OK';
	@override String get retry => 'リトライ';
	@override String get done => '完了';
	@override String get agree => '同意';
	@override String get decline => '拒否';
	@override String get add_record => '追加';
	@override String get copy => 'コピー';
}

// Path: common.label
class _TranslationsCommonLabelJaJp extends TranslationsCommonLabelZhTw {
	_TranslationsCommonLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get task_name => 'タスク名';
	@override String get item_name => '項目名';
	@override String get sub_item => '子項目名';
	@override String get amount => '金額';
	@override String get date => '日付';
	@override String get currency => '通貨';
	@override String get split_method => '負担設定';
	@override String get start_date => '開始日';
	@override String get end_date => '終了日';
	@override String get member_count => '参加人数';
	@override String get period => '期間';
	@override String get payment_method => '支払方法';
	@override String get rate => '為替レート';
	@override String get memo => 'メモ';
}

// Path: common.category
class _TranslationsCommonCategoryJaJp extends TranslationsCommonCategoryZhTw {
	_TranslationsCommonCategoryJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get food => '食事';
	@override String get transport => '交通';
	@override String get shopping => '買い物';
	@override String get entertainment => 'エンタメ';
	@override String get accommodation => '宿泊';
	@override String get others => 'その他';
}

// Path: common.currency
class _TranslationsCommonCurrencyJaJp extends TranslationsCommonCurrencyZhTw {
	_TranslationsCommonCurrencyJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get twd => '新台湾ドル';
	@override String get jpy => '日本円';
	@override String get usd => 'USドル';
	@override String get eur => 'ユーロ';
	@override String get krw => '韓国ウォン';
	@override String get cny => '人民元';
	@override String get gbp => '英ポンド';
	@override String get cad => 'カナダドル';
	@override String get aud => 'オーストラリアドル';
	@override String get chf => 'スイスフラン';
	@override String get dkk => 'デンマーククローネ';
	@override String get hkd => '香港ドル';
	@override String get nok => 'ノルウェークローネ';
	@override String get nzd => 'ニュージーランドドル';
	@override String get sgd => 'シンガポールドル';
	@override String get thb => 'タイバーツ';
	@override String get zar => '南アフリカランド';
	@override String get rub => 'ロシアルーブル';
	@override String get vnd => 'ベトナムドン';
	@override String get idr => 'インドネシアルピア';
	@override String get myr => 'マレーシアリンギット';
	@override String get php => 'フィリピンペソ';
	@override String get mop => 'マカオパタカ';
	@override String get sek => 'スウェーデンクローナ';
	@override String get aed => 'UAEディルハム';
	@override String get sar => 'サウジアラビアリヤル';
	@override String get try_ => 'トルコリラ';
	@override String get inr => 'インドルピー';
}

// Path: common.avatar
class _TranslationsCommonAvatarJaJp extends TranslationsCommonAvatarZhTw {
	_TranslationsCommonAvatarJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get cow => 'ホルスタイン牛';
	@override String get pig => 'ブタ';
	@override String get deer => 'ノロジカ';
	@override String get horse => '馬';
	@override String get sheep => 'サフォーク種のヒツジ';
	@override String get goat => 'ヤギ';
	@override String get duck => 'マガモ';
	@override String get stoat => 'オコジョ';
	@override String get rabbit => 'ヨーロッパノウサギ';
	@override String get mouse => 'ハツカネズミ';
	@override String get cat => 'キジトラのイエネコ';
	@override String get dog => 'ボーダー・コリー';
	@override String get otter => 'ユーラシアカワウソ';
	@override String get owl => 'メンフクロウ';
	@override String get fox => 'アカギツネ';
	@override String get hedgehog => 'ヨーロッパハリネズミ';
	@override String get donkey => 'ロバ';
	@override String get squirrel => 'ユーラシアアカリス';
	@override String get badger => 'ヨーロッパアナグマ';
	@override String get robin => 'ヨーロッパコマドリ';
}

// Path: common.remainder_rule
class _TranslationsCommonRemainderRuleJaJp extends TranslationsCommonRemainderRuleZhTw {
	_TranslationsCommonRemainderRuleJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '端数処理';
	@override late final _TranslationsCommonRemainderRuleRuleJaJp rule = _TranslationsCommonRemainderRuleRuleJaJp._(_root);
	@override late final _TranslationsCommonRemainderRuleContentJaJp content = _TranslationsCommonRemainderRuleContentJaJp._(_root);
	@override late final _TranslationsCommonRemainderRuleMessageJaJp message = _TranslationsCommonRemainderRuleMessageJaJp._(_root);
}

// Path: common.split_method
class _TranslationsCommonSplitMethodJaJp extends TranslationsCommonSplitMethodZhTw {
	_TranslationsCommonSplitMethodJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get even => '均等';
	@override String get percent => '比例';
	@override String get exact => '實額';
}

// Path: common.payment_method
class _TranslationsCommonPaymentMethodJaJp extends TranslationsCommonPaymentMethodZhTw {
	_TranslationsCommonPaymentMethodJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get member => 'メンバー立替';
	@override String get prepay => '前受金払い';
	@override String get mixed => '混合支払';
}

// Path: common.language
class _TranslationsCommonLanguageJaJp extends TranslationsCommonLanguageZhTw {
	_TranslationsCommonLanguageJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '言語設定';
	@override String get zh_TW => '繁体字中国語';
	@override String get en_US => '英語';
	@override String get jp_JP => '日本語';
}

// Path: common.theme
class _TranslationsCommonThemeJaJp extends TranslationsCommonThemeZhTw {
	_TranslationsCommonThemeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'テーマ設定';
	@override String get system => 'システム設定';
	@override String get light => 'ライトモード';
	@override String get dark => 'ダークモード';
}

// Path: common.display
class _TranslationsCommonDisplayJaJp extends TranslationsCommonDisplayZhTw {
	_TranslationsCommonDisplayJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '表示設定';
	@override String get system => 'システム設定';
	@override String get enlarged => '拡大表示';
	@override String get standard => '標準表示';
}

// Path: common.payment_info
class _TranslationsCommonPaymentInfoJaJp extends TranslationsCommonPaymentInfoZhTw {
	_TranslationsCommonPaymentInfoJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonPaymentInfoModeJaJp mode = _TranslationsCommonPaymentInfoModeJaJp._(_root);
	@override late final _TranslationsCommonPaymentInfoContentJaJp content = _TranslationsCommonPaymentInfoContentJaJp._(_root);
	@override late final _TranslationsCommonPaymentInfoTypeJaJp type = _TranslationsCommonPaymentInfoTypeJaJp._(_root);
	@override late final _TranslationsCommonPaymentInfoLabelJaJp label = _TranslationsCommonPaymentInfoLabelJaJp._(_root);
	@override late final _TranslationsCommonPaymentInfoHintJaJp hint = _TranslationsCommonPaymentInfoHintJaJp._(_root);
}

// Path: common.payment_status
class _TranslationsCommonPaymentStatusJaJp extends TranslationsCommonPaymentStatusZhTw {
	_TranslationsCommonPaymentStatusJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get payable => '支払';
	@override String get refund => '返金';
}

// Path: common.terms
class _TranslationsCommonTermsJaJp extends TranslationsCommonTermsZhTw {
	_TranslationsCommonTermsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonTermsLabelJaJp label = _TranslationsCommonTermsLabelJaJp._(_root);
	@override String get and => 'と';
}

// Path: common.share
class _TranslationsCommonShareJaJp extends TranslationsCommonShareZhTw {
	_TranslationsCommonShareJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonShareInviteJaJp invite = _TranslationsCommonShareInviteJaJp._(_root);
	@override late final _TranslationsCommonShareSettlementJaJp settlement = _TranslationsCommonShareSettlementJaJp._(_root);
}

// Path: s10_home_task_list.tab
class _TranslationsS10HomeTaskListTabJaJp extends TranslationsS10HomeTaskListTabZhTw {
	_TranslationsS10HomeTaskListTabJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get in_progress => '進行中';
	@override String get completed => '完了済';
}

// Path: s10_home_task_list.empty
class _TranslationsS10HomeTaskListEmptyJaJp extends TranslationsS10HomeTaskListEmptyZhTw {
	_TranslationsS10HomeTaskListEmptyJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get in_progress => '進行中のタスクはありません';
	@override String get completed => '完了したタスクはありません';
}

// Path: s10_home_task_list.buttons
class _TranslationsS10HomeTaskListButtonsJaJp extends TranslationsS10HomeTaskListButtonsZhTw {
	_TranslationsS10HomeTaskListButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get add_task => 'タスク追加';
	@override String get join_task => 'タスク参加';
}

// Path: s10_home_task_list.label
class _TranslationsS10HomeTaskListLabelJaJp extends TranslationsS10HomeTaskListLabelZhTw {
	_TranslationsS10HomeTaskListLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get settlement => '精算済み';
}

// Path: s11_invite_confirm.buttons
class _TranslationsS11InviteConfirmButtonsJaJp extends TranslationsS11InviteConfirmButtonsZhTw {
	_TranslationsS11InviteConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get join => '参加';
	@override String get back_task_list => 'タスク一覧へ';
}

// Path: s11_invite_confirm.label
class _TranslationsS11InviteConfirmLabelJaJp extends TranslationsS11InviteConfirmLabelZhTw {
	_TranslationsS11InviteConfirmLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get select_ghost => '引き継ぐメンバーを選択';
	@override String get prepaid => '前受金';
	@override String get expense => '支出';
}

// Path: s12_task_close_notice.buttons
class _TranslationsS12TaskCloseNoticeButtonsJaJp extends TranslationsS12TaskCloseNoticeButtonsZhTw {
	_TranslationsS12TaskCloseNoticeButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get close_task => 'タスク終了';
}

// Path: s13_task_dashboard.buttons
class _TranslationsS13TaskDashboardButtonsJaJp extends TranslationsS13TaskDashboardButtonsZhTw {
	_TranslationsS13TaskDashboardButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get add => '追加';
}

// Path: s13_task_dashboard.tab
class _TranslationsS13TaskDashboardTabJaJp extends TranslationsS13TaskDashboardTabZhTw {
	_TranslationsS13TaskDashboardTabJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get group => 'グループ';
	@override String get personal => '個人';
}

// Path: s13_task_dashboard.label
class _TranslationsS13TaskDashboardLabelJaJp extends TranslationsS13TaskDashboardLabelZhTw {
	_TranslationsS13TaskDashboardLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get total_expense => '総費用';
	@override String get total_prepay => '総前受金';
	@override String get total_expense_personal => '総費用';
	@override String get total_prepay_personal => '総前受金（立替含）';
}

// Path: s13_task_dashboard.empty
class _TranslationsS13TaskDashboardEmptyJaJp extends TranslationsS13TaskDashboardEmptyZhTw {
	_TranslationsS13TaskDashboardEmptyJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get records => '該当なし';
	@override String get personal_records => '該当なし';
}

// Path: s13_task_dashboard.section
class _TranslationsS13TaskDashboardSectionJaJp extends TranslationsS13TaskDashboardSectionZhTw {
	_TranslationsS13TaskDashboardSectionJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get expense => '支払い通貨';
	@override String get prepay => '前受金通貨';
	@override String get prepay_balance => '前受金残高';
	@override String get no_data => 'データなし';
}

// Path: s14_task_settings.section
class _TranslationsS14TaskSettingsSectionJaJp extends TranslationsS14TaskSettingsSectionZhTw {
	_TranslationsS14TaskSettingsSectionJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get task_name => 'タスク名';
	@override String get task_period => 'タスク期間';
	@override String get settlement => '精算設定';
	@override String get other => 'その他設定';
}

// Path: s14_task_settings.menu
class _TranslationsS14TaskSettingsMenuJaJp extends TranslationsS14TaskSettingsMenuZhTw {
	_TranslationsS14TaskSettingsMenuJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get invite => '招待送信';
	@override String get member_settings => 'メンバー設定';
	@override String get history => '履歴';
	@override String get close_task => 'タスク終了';
}

// Path: s15_record_edit.title
class _TranslationsS15RecordEditTitleJaJp extends TranslationsS15RecordEditTitleZhTw {
	_TranslationsS15RecordEditTitleJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get add => '記録追加';
	@override String get edit => '記録編集';
}

// Path: s15_record_edit.buttons
class _TranslationsS15RecordEditButtonsJaJp extends TranslationsS15RecordEditButtonsZhTw {
	_TranslationsS15RecordEditButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get add_item => '内訳を追加';
}

// Path: s15_record_edit.section
class _TranslationsS15RecordEditSectionJaJp extends TranslationsS15RecordEditSectionZhTw {
	_TranslationsS15RecordEditSectionJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get split => '分担情報';
	@override String get items => '内訳分割';
}

// Path: s15_record_edit.val
class _TranslationsS15RecordEditValJaJp extends TranslationsS15RecordEditValZhTw {
	_TranslationsS15RecordEditValJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get prepay => '前受金';
	@override String member_paid({required Object name}) => '${name} が立替';
	@override String get split_details => '内訳分割';
	@override String split_summary({required Object amount, required Object method}) => '合計 ${amount} を ${method} で分担';
	@override String converted_amount({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}';
	@override String get split_remaining => '残額';
	@override String get mock_note => '内訳の説明';
}

// Path: s15_record_edit.tab
class _TranslationsS15RecordEditTabJaJp extends TranslationsS15RecordEditTabZhTw {
	_TranslationsS15RecordEditTabJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get expense => '費用';
	@override String get prepay => '前受金';
}

// Path: s15_record_edit.rate_dialog
class _TranslationsS15RecordEditRateDialogJaJp extends TranslationsS15RecordEditRateDialogZhTw {
	_TranslationsS15RecordEditRateDialogJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '為替レートの出典';
	@override String get content => '為替レートは Open Exchange Rates（無料版）を参照しています。参考値としてご利用ください。実際の為替レートは両替明細をご確認ください。';
}

// Path: s15_record_edit.label
class _TranslationsS15RecordEditLabelJaJp extends TranslationsS15RecordEditLabelZhTw {
	_TranslationsS15RecordEditLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String rate_with_base({required Object base, required Object target}) => '為替レート（1 ${base} = ? ${target}）';
}

// Path: s15_record_edit.hint
class _TranslationsS15RecordEditHintJaJp extends TranslationsS15RecordEditHintZhTw {
	_TranslationsS15RecordEditHintJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsS15RecordEditHintCategoryJaJp category = _TranslationsS15RecordEditHintCategoryJaJp._(_root);
	@override String item({required Object category}) => '例：${category}';
	@override String get memo => '例：補足事項';
}

// Path: s16_task_create_edit.section
class _TranslationsS16TaskCreateEditSectionJaJp extends TranslationsS16TaskCreateEditSectionZhTw {
	_TranslationsS16TaskCreateEditSectionJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get task_name => 'タスク名';
	@override String get task_period => 'タスク期間';
	@override String get settlement => '精算設定';
}

// Path: s16_task_create_edit.label
class _TranslationsS16TaskCreateEditLabelJaJp extends TranslationsS16TaskCreateEditLabelZhTw {
	_TranslationsS16TaskCreateEditLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String name_counter({required Object current, required Object max}) => '${current}/${max}';
}

// Path: s16_task_create_edit.hint
class _TranslationsS16TaskCreateEditHintJaJp extends TranslationsS16TaskCreateEditHintZhTw {
	_TranslationsS16TaskCreateEditHintJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get name => '例：東京5日間の旅';
}

// Path: s17_task_locked.buttons
class _TranslationsS17TaskLockedButtonsJaJp extends TranslationsS17TaskLockedButtonsZhTw {
	_TranslationsS17TaskLockedButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get notify_members => 'メンバーに通知';
	@override String get view_payment_info => '受取口座確認';
}

// Path: s17_task_locked.section
class _TranslationsS17TaskLockedSectionJaJp extends TranslationsS17TaskLockedSectionZhTw {
	_TranslationsS17TaskLockedSectionJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get pending => '未完了';
	@override String get cleared => '完了';
}

// Path: s17_task_locked.export
class _TranslationsS17TaskLockedExportJaJp extends TranslationsS17TaskLockedExportZhTw {
	_TranslationsS17TaskLockedExportJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get report_info => 'レポート情報';
	@override String get task_name => 'タスク名';
	@override String get export_time => 'レポート作成日時';
	@override String get base_currency => '基準通貨';
	@override String get settlement_summary => '精算サマリー';
	@override String get member => 'メンバー';
	@override String get role => '役割';
	@override String get net_amount => '純額';
	@override String get status => 'ステータス';
	@override String get receiver => '返金対象';
	@override String get payer => '支払対象';
	@override String get cleared => '処理済み';
	@override String get pending => '未処理';
	@override String get fund_analysis => '資金および端数';
	@override String get total_expense => '総支出';
	@override String get total_prepay => '総前受金';
	@override String get remainder_buffer => '端数合計';
	@override String get remainder_absorbed_by => '端数受取人';
	@override String get transaction_details => '取引明細';
	@override String get date => '日付';
	@override String get title => 'タイトル';
	@override String get type => '種別';
	@override String get original_amount => '原通貨金額';
	@override String get currency => '通貨';
	@override String get rate => '為替レート';
	@override String get base_amount => '基準通貨金額';
	@override String get net_remainder => '端数';
	@override String get pool => '前受金';
	@override String get mixed => '混合支払い';
}

// Path: s18_task_join.tabs
class _TranslationsS18TaskJoinTabsJaJp extends TranslationsS18TaskJoinTabsZhTw {
	_TranslationsS18TaskJoinTabsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get input => '入力';
	@override String get scan => 'スキャン';
}

// Path: s18_task_join.label
class _TranslationsS18TaskJoinLabelJaJp extends TranslationsS18TaskJoinLabelZhTw {
	_TranslationsS18TaskJoinLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get input => '招待コード';
}

// Path: s18_task_join.hint
class _TranslationsS18TaskJoinHintJaJp extends TranslationsS18TaskJoinHintZhTw {
	_TranslationsS18TaskJoinHintJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get input => '招待コード（8桁）を入力';
}

// Path: s18_task_join.content
class _TranslationsS18TaskJoinContentJaJp extends TranslationsS18TaskJoinContentZhTw {
	_TranslationsS18TaskJoinContentJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get scan => 'QRコードを枠内に配置すると自動的にスキャンされます';
}

// Path: s30_settlement_confirm.buttons
class _TranslationsS30SettlementConfirmButtonsJaJp extends TranslationsS30SettlementConfirmButtonsZhTw {
	_TranslationsS30SettlementConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get set_payment_info => '受取設定';
}

// Path: s30_settlement_confirm.steps
class _TranslationsS30SettlementConfirmStepsJaJp extends TranslationsS30SettlementConfirmStepsZhTw {
	_TranslationsS30SettlementConfirmStepsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get confirm_amount => '金額確認';
	@override String get payment_info => '受取設定';
}

// Path: s30_settlement_confirm.warning
class _TranslationsS30SettlementConfirmWarningJaJp extends TranslationsS30SettlementConfirmWarningZhTw {
	_TranslationsS30SettlementConfirmWarningJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get random_reveal => '端数は決済確定後に公開されます。';
}

// Path: s30_settlement_confirm.list_item
class _TranslationsS30SettlementConfirmListItemJaJp extends TranslationsS30SettlementConfirmListItemZhTw {
	_TranslationsS30SettlementConfirmListItemJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get merged_label => '代表メンバー';
	@override String get includes => '内訳：';
	@override String get principal => '元金';
	@override String get random_remainder => 'ランダム端数';
	@override String get remainder => '端数';
}

// Path: s31_settlement_payment_info.buttons
class _TranslationsS31SettlementPaymentInfoButtonsJaJp extends TranslationsS31SettlementPaymentInfoButtonsZhTw {
	_TranslationsS31SettlementPaymentInfoButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get prev_step => '前へ戻る';
}

// Path: s32_settlement_result.buttons
class _TranslationsS32SettlementResultButtonsJaJp extends TranslationsS32SettlementResultButtonsZhTw {
	_TranslationsS32SettlementResultButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get share => '通知送信';
	@override String get back_task_dashboard => 'タスクに戻る';
}

// Path: s50_onboarding_consent.buttons
class _TranslationsS50OnboardingConsentButtonsJaJp extends TranslationsS50OnboardingConsentButtonsZhTw {
	_TranslationsS50OnboardingConsentButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get start => 'はじめる';
}

// Path: s50_onboarding_consent.content
class _TranslationsS50OnboardingConsentContentJaJp extends TranslationsS50OnboardingConsentContentZhTw {
	_TranslationsS50OnboardingConsentContentJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get prefix => '分帳を、よりシンプルに。\n\n私はアイロン・ルースト。ここで記帳と分担を管理します。\n旅行、食事、共同生活など、すべての支出は明確に記録され、分担方法には明確なルールがあります。\n\n分帳は、本来わかりやすいものです。\n\n「はじめる」を押すことで、';
	@override String get suffix => ' に同意したものとみなされます。';
}

// Path: s52_task_settings_log.buttons
class _TranslationsS52TaskSettingsLogButtonsJaJp extends TranslationsS52TaskSettingsLogButtonsZhTw {
	_TranslationsS52TaskSettingsLogButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get export_csv => 'CSV出力';
}

// Path: s52_task_settings_log.csv_header
class _TranslationsS52TaskSettingsLogCsvHeaderJaJp extends TranslationsS52TaskSettingsLogCsvHeaderZhTw {
	_TranslationsS52TaskSettingsLogCsvHeaderJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get time => '日時';
	@override String get user => '操作者';
	@override String get action => '操作';
	@override String get details => '詳細';
}

// Path: s52_task_settings_log.type
class _TranslationsS52TaskSettingsLogTypeJaJp extends TranslationsS52TaskSettingsLogTypeZhTw {
	_TranslationsS52TaskSettingsLogTypeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get prepay => '収入';
	@override String get expense => '支出';
}

// Path: s52_task_settings_log.payment_type
class _TranslationsS52TaskSettingsLogPaymentTypeJaJp extends TranslationsS52TaskSettingsLogPaymentTypeZhTw {
	_TranslationsS52TaskSettingsLogPaymentTypeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get prepay => '前受金';
	@override String get single_suffix => '立替';
	@override String get multiple => '複数立替';
}

// Path: s52_task_settings_log.unit
class _TranslationsS52TaskSettingsLogUnitJaJp extends TranslationsS52TaskSettingsLogUnitZhTw {
	_TranslationsS52TaskSettingsLogUnitJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get members => '名';
	@override String get items => '項目';
}

// Path: s53_task_settings_members.buttons
class _TranslationsS53TaskSettingsMembersButtonsJaJp extends TranslationsS53TaskSettingsMembersButtonsZhTw {
	_TranslationsS53TaskSettingsMembersButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get add_member => 'メンバー追加';
}

// Path: s53_task_settings_members.label
class _TranslationsS53TaskSettingsMembersLabelJaJp extends TranslationsS53TaskSettingsMembersLabelZhTw {
	_TranslationsS53TaskSettingsMembersLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get default_ratio => 'デフォルト比率';
}

// Path: s54_task_settings_invite.buttons
class _TranslationsS54TaskSettingsInviteButtonsJaJp extends TranslationsS54TaskSettingsInviteButtonsZhTw {
	_TranslationsS54TaskSettingsInviteButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get share => '共有';
	@override String get regenerate => '再生成';
}

// Path: s54_task_settings_invite.label
class _TranslationsS54TaskSettingsInviteLabelJaJp extends TranslationsS54TaskSettingsInviteLabelZhTw {
	_TranslationsS54TaskSettingsInviteLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get expires_in => '有效期限';
	@override String get invite_expired => '有効期限が切れました';
}

// Path: s70_system_settings.section
class _TranslationsS70SystemSettingsSectionJaJp extends TranslationsS70SystemSettingsSectionZhTw {
	_TranslationsS70SystemSettingsSectionJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get basic => '基本設定';
	@override String get legal => '関連規約';
	@override String get account => 'アカウント設定';
}

// Path: s70_system_settings.menu
class _TranslationsS70SystemSettingsMenuJaJp extends TranslationsS70SystemSettingsMenuZhTw {
	_TranslationsS70SystemSettingsMenuJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get user_name => '表示名前';
	@override String get language => '表示言語';
	@override String get theme => 'テーマ';
	@override String get terms => '利用規約';
	@override String get privacy => 'プライバシーポリシー';
	@override String get payment_info => '支払/受取口座設定';
	@override String get delete_account => 'アカウント削除';
}

// Path: s74_delete_account_notice.buttons
class _TranslationsS74DeleteAccountNoticeButtonsJaJp extends TranslationsS74DeleteAccountNoticeButtonsZhTw {
	_TranslationsS74DeleteAccountNoticeButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get delete_account => 'アカウント削除';
}

// Path: d01_member_role_intro.buttons
class _TranslationsD01MemberRoleIntroButtonsJaJp extends TranslationsD01MemberRoleIntroButtonsZhTw {
	_TranslationsD01MemberRoleIntroButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get reroll => '動物を変える';
	@override String get enter => 'タスクへ進む';
}

// Path: d01_member_role_intro.reroll
class _TranslationsD01MemberRoleIntroRerollJaJp extends TranslationsD01MemberRoleIntroRerollZhTw {
	_TranslationsD01MemberRoleIntroRerollJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get empty => '変更不可';
}

// Path: d03_task_create_confirm.buttons
class _TranslationsD03TaskCreateConfirmButtonsJaJp extends TranslationsD03TaskCreateConfirmButtonsZhTw {
	_TranslationsD03TaskCreateConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get back_edit => '編集に戻る';
}

// Path: d12_logout_confirm.buttons
class _TranslationsD12LogoutConfirmButtonsJaJp extends TranslationsD12LogoutConfirmButtonsZhTw {
	_TranslationsD12LogoutConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get logout => 'ログアウト';
}

// Path: b02_split_expense_edit.buttons
class _TranslationsB02SplitExpenseEditButtonsJaJp extends TranslationsB02SplitExpenseEditButtonsZhTw {
	_TranslationsB02SplitExpenseEditButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get confirm_split => '決定';
}

// Path: b02_split_expense_edit.hint
class _TranslationsB02SplitExpenseEditHintJaJp extends TranslationsB02SplitExpenseEditHintZhTw {
	_TranslationsB02SplitExpenseEditHintJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get sub_item => '例：内訳';
}

// Path: b03_split_method_edit.buttons
class _TranslationsB03SplitMethodEditButtonsJaJp extends TranslationsB03SplitMethodEditButtonsZhTw {
	_TranslationsB03SplitMethodEditButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get adjust_weight => '比率調整';
}

// Path: b03_split_method_edit.label
class _TranslationsB03SplitMethodEditLabelJaJp extends TranslationsB03SplitMethodEditLabelZhTw {
	_TranslationsB03SplitMethodEditLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String total({required Object current, required Object target}) => '${current} / ${target}';
}

// Path: b04_payment_merge.label
class _TranslationsB04PaymentMergeLabelJaJp extends TranslationsB04PaymentMergeLabelZhTw {
	_TranslationsB04PaymentMergeLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get head_member => '代表メンバー';
	@override String get merge_amount => '統合金額';
}

// Path: b07_payment_method_edit.label
class _TranslationsB07PaymentMethodEditLabelJaJp extends TranslationsB07PaymentMethodEditLabelZhTw {
	_TranslationsB07PaymentMethodEditLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get amount => '支払金額';
	@override String get total_expense => '合計金額';
	@override String get prepay => '前受金払い';
	@override String get total_advance => '立替合計';
}

// Path: b07_payment_method_edit.status
class _TranslationsB07PaymentMethodEditStatusJaJp extends TranslationsB07PaymentMethodEditStatusZhTw {
	_TranslationsB07PaymentMethodEditStatusJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get not_enough => '残高不足';
	@override String get balanced => '一致';
	@override String remaining({required Object amount}) => '残り ${amount}';
}

// Path: error.dialog
class _TranslationsErrorDialogJaJp extends TranslationsErrorDialogZhTw {
	_TranslationsErrorDialogJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorDialogTaskFullJaJp task_full = _TranslationsErrorDialogTaskFullJaJp._(_root);
	@override late final _TranslationsErrorDialogExpiredCodeJaJp expired_code = _TranslationsErrorDialogExpiredCodeJaJp._(_root);
	@override late final _TranslationsErrorDialogInvalidCodeJaJp invalid_code = _TranslationsErrorDialogInvalidCodeJaJp._(_root);
	@override late final _TranslationsErrorDialogAuthRequiredJaJp auth_required = _TranslationsErrorDialogAuthRequiredJaJp._(_root);
	@override late final _TranslationsErrorDialogAlreadyInTaskJaJp already_in_task = _TranslationsErrorDialogAlreadyInTaskJaJp._(_root);
	@override late final _TranslationsErrorDialogUnknownJaJp unknown = _TranslationsErrorDialogUnknownJaJp._(_root);
	@override late final _TranslationsErrorDialogDeleteFailedJaJp delete_failed = _TranslationsErrorDialogDeleteFailedJaJp._(_root);
	@override late final _TranslationsErrorDialogMemberDeleteFailedJaJp member_delete_failed = _TranslationsErrorDialogMemberDeleteFailedJaJp._(_root);
	@override late final _TranslationsErrorDialogDataConflictJaJp data_conflict = _TranslationsErrorDialogDataConflictJaJp._(_root);
}

// Path: error.message
class _TranslationsErrorMessageJaJp extends TranslationsErrorMessageZhTw {
	_TranslationsErrorMessageJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get unknown => '予期せぬエラーが発生しました。';
	@override String get invalid_amount => '金額が無効です。';
	@override String get required => '必須項目です。';
	@override String empty({required Object key}) => '${key}を入力してください。';
	@override String get format => '形式が正しくありません。';
	@override String zero({required Object key}) => '${key}は0にできません。';
	@override String get amount_not_enough => '残額が不足しています。';
	@override String get amount_mismatch => '金額が一致しません。';
	@override String get prepay_is_used => 'この金額は既に使用されているか、残高が不足しています。';
	@override String get data_is_used => 'このメンバーには、関連する記帳記録、または未精算の金額があります。該当する記録を修正または削除してから、再度お試しください。';
	@override String get permission_denied => '権限がありません。';
	@override String get network_error => 'ネットワーク接続に失敗しました。通信状況をご確認ください。';
	@override String get data_not_found => 'データが見つかりませんでした。もう一度お試しください。';
	@override String enter_first({required Object key}) => '${key}を先に入力してください。';
	@override String get export_failed => 'レポートの作成に失敗しました。空き容量を確認するか、後でもう一度お試しください。';
	@override String get save_failed => '保存に失敗しました。もう一度お試しください。';
	@override String get delete_failed => '削除に失敗しました。もう一度お試しください。';
	@override String get task_close_failed => 'タスク終了に失敗しました。しばらくしてから再試行してください。';
	@override String get rate_fetch_failed => '為替レートの取得に失敗しました。';
	@override String length_exceeded({required Object max}) => '${max}文字以内で入力してください。';
	@override String get invalid_char => '無効な文字が含まれています。';
	@override String get invalid_code => '招待コードが無効です。リンクが正しいか確認してください。';
	@override String expired_code({required Object expiry_minutes}) => '招待リンクの期限（${expiry_minutes}分）が切れています。リーダーに再送を依頼してください。';
	@override String task_full({required Object limit}) => '定員オーバーです（上限${limit}名）。';
	@override String get auth_required => '認証に失敗しました。アプリを再起動してください。';
	@override String get init_failed => '読み込みに失敗しました。もう一度お試しください。';
	@override String get unauthorized => 'ログインしていません。再度ログインしてください。';
	@override String get task_locked => '精算済みのため、データを変更できません。';
	@override String get timeout => 'タイムアウトしました。後でもう一度お試しください。';
	@override String get quota_exceeded => '利用制限に達しました。しばらく経ってからお試しください。';
	@override String get join_failed => 'タスクに参加できませんでした。しばらく経ってからお試しください。';
	@override String get invite_create_failed => '招待コードを作成できませんでした。しばらく経ってからお試しください。';
	@override String get data_conflict => '閲覧中に他のメンバーが記録を更新しました。正確性を保つため、前のページに戻って更新してください。';
	@override String get task_status_error => 'タスクの状態が無効です（既に精算済みの可能性があります）。更新してください。';
	@override String get settlement_failed => 'システムエラーが発生しました。後でもう一度お試しください。';
	@override String get share_failed => 'シェアが失敗しました。後でもう一度お試しください。';
	@override String get login_failed => 'ログインが失敗しました。後でもう一度お試しください。';
	@override String get logout_failed => 'ログアウトが失敗しました。後でもう一度お試しください。';
	@override String get scan_failed => 'スキャンが失敗しました。後でもう一度お試しください。';
	@override String get invalid_qr_code => '無効なQRコードです。';
	@override String get camera_permission_denied => '設定からカメラの権限を有効にしてください。';
}

// Path: common.remainder_rule.rule
class _TranslationsCommonRemainderRuleRuleJaJp extends TranslationsCommonRemainderRuleRuleZhTw {
	_TranslationsCommonRemainderRuleRuleJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get random => 'ランダム';
	@override String get order => '順番';
	@override String get member => '指定';
}

// Path: common.remainder_rule.content
class _TranslationsCommonRemainderRuleContentJaJp extends TranslationsCommonRemainderRuleContentZhTw {
	_TranslationsCommonRemainderRuleContentJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String remainder({required Object amount}) => '端数 ${amount} は、為替レートの換算や割り勘の計算で生じる差額です。';
	@override String get random => '端数を負担する一人を、システムがランダムに選びます。';
	@override String get order => 'メンバーの参加順に、端数がなくなるまで順番に配分します。';
	@override String get member => '特定のメンバーを指定し、常にその人が端数を負担するようにします。';
}

// Path: common.remainder_rule.message
class _TranslationsCommonRemainderRuleMessageJaJp extends TranslationsCommonRemainderRuleMessageZhTw {
	_TranslationsCommonRemainderRuleMessageJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String remainder({required Object amount}) => '端数 ${amount} は一時的に保存され、精算時に分配されます。';
	@override String zero_balance({required Object amount}) => '端数 ${amount} は支払い差額と自動的に相殺されました。';
}

// Path: common.payment_info.mode
class _TranslationsCommonPaymentInfoModeJaJp extends TranslationsCommonPaymentInfoModeZhTw {
	_TranslationsCommonPaymentInfoModeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get private => '個別連絡';
	@override String get public => '支払い情報を共有';
}

// Path: common.payment_info.content
class _TranslationsCommonPaymentInfoContentJaJp extends TranslationsCommonPaymentInfoContentZhTw {
	_TranslationsCommonPaymentInfoContentJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get private => '詳細は表示されません。メンバーから直接連絡してもらいます';
	@override String get public => '支払い情報をメンバーに表示します';
}

// Path: common.payment_info.type
class _TranslationsCommonPaymentInfoTypeJaJp extends TranslationsCommonPaymentInfoTypeZhTw {
	_TranslationsCommonPaymentInfoTypeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get cash => '現金';
	@override String get bank => '銀行振込';
	@override String get apps => '決済アプリ';
}

// Path: common.payment_info.label
class _TranslationsCommonPaymentInfoLabelJaJp extends TranslationsCommonPaymentInfoLabelZhTw {
	_TranslationsCommonPaymentInfoLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get bank_name => '銀行コード / 銀行名';
	@override String get bank_account => '口座番号';
	@override String get app_name => 'アプリ名';
	@override String get app_link => 'リンク / ID';
}

// Path: common.payment_info.hint
class _TranslationsCommonPaymentInfoHintJaJp extends TranslationsCommonPaymentInfoHintZhTw {
	_TranslationsCommonPaymentInfoHintJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get bank_name => '例：0001-みずほ銀行';
	@override String get bank_account => '例：1234567';
	@override String get app_name => '例：PayPay';
	@override String get app_link => '例：paypay-id-123';
}

// Path: common.terms.label
class _TranslationsCommonTermsLabelJaJp extends TranslationsCommonTermsLabelZhTw {
	_TranslationsCommonTermsLabelJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get terms => '利用規約';
	@override String get privacy => 'プライバシーポリシー';
	@override String get both => '法的条項';
}

// Path: common.share.invite
class _TranslationsCommonShareInviteJaJp extends TranslationsCommonShareInviteZhTw {
	_TranslationsCommonShareInviteJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get subject => 'Iron Split タスク招待';
	@override String content({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「${taskName}」への招待です。\n招待コード：${code}\nリンク：${link}';
}

// Path: common.share.settlement
class _TranslationsCommonShareSettlementJaJp extends TranslationsCommonShareSettlementZhTw {
	_TranslationsCommonShareSettlementJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get subject => 'Iron Split タスク精算通知';
	@override String content({required Object taskName, required Object link}) => '精算が完了しました。\nIron Split アプリを開き、「${taskName}」の支払金額をご確認ください。\nリンク：${link}';
}

// Path: s15_record_edit.hint.category
class _TranslationsS15RecordEditHintCategoryJaJp extends TranslationsS15RecordEditHintCategoryZhTw {
	_TranslationsS15RecordEditHintCategoryJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get food => '夕食';
	@override String get transport => '交通費';
	@override String get shopping => 'お土産';
	@override String get entertainment => 'チケット';
	@override String get accommodation => '宿泊費';
	@override String get others => 'その他費用';
}

// Path: error.dialog.task_full
class _TranslationsErrorDialogTaskFullJaJp extends TranslationsErrorDialogTaskFullZhTw {
	_TranslationsErrorDialogTaskFullJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク満員';
	@override String content({required Object limit}) => 'メンバー数が上限 ${limit} 人に達しています。リーダーへ連絡してください。';
}

// Path: error.dialog.expired_code
class _TranslationsErrorDialogExpiredCodeJaJp extends TranslationsErrorDialogExpiredCodeZhTw {
	_TranslationsErrorDialogExpiredCodeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '招待コード期限切れ';
	@override String content({required Object minutes}) => 'この招待リンクは無効です（期限 ${minutes} 分）。リーダーに再発行を依頼してください。';
}

// Path: error.dialog.invalid_code
class _TranslationsErrorDialogInvalidCodeJaJp extends TranslationsErrorDialogInvalidCodeZhTw {
	_TranslationsErrorDialogInvalidCodeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '無効な招待リンク';
	@override String get content => '無効な招待リンクです。';
}

// Path: error.dialog.auth_required
class _TranslationsErrorDialogAuthRequiredJaJp extends TranslationsErrorDialogAuthRequiredZhTw {
	_TranslationsErrorDialogAuthRequiredJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログインが必要';
	@override String get content => 'タスク参加にはログインが必要です。';
}

// Path: error.dialog.already_in_task
class _TranslationsErrorDialogAlreadyInTaskJaJp extends TranslationsErrorDialogAlreadyInTaskZhTw {
	_TranslationsErrorDialogAlreadyInTaskJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '既に参加済';
	@override String get content => '既にこのタスクのメンバーです。';
}

// Path: error.dialog.unknown
class _TranslationsErrorDialogUnknownJaJp extends TranslationsErrorDialogUnknownZhTw {
	_TranslationsErrorDialogUnknownJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'エラー';
	@override String get content => '予期せぬエラーが発生しました。';
}

// Path: error.dialog.delete_failed
class _TranslationsErrorDialogDeleteFailedJaJp extends TranslationsErrorDialogDeleteFailedZhTw {
	_TranslationsErrorDialogDeleteFailedJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '削除失敗';
	@override String get content => '削除に失敗しました。後でもう一度お試しください。';
}

// Path: error.dialog.member_delete_failed
class _TranslationsErrorDialogMemberDeleteFailedJaJp extends TranslationsErrorDialogMemberDeleteFailedZhTw {
	_TranslationsErrorDialogMemberDeleteFailedJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'メンバー削除エラー';
	@override String get content => 'このメンバーには、関連する記帳記録、または未精算の金額があります。該当する記録を修正または削除してから、再度お試しください。';
}

// Path: error.dialog.data_conflict
class _TranslationsErrorDialogDataConflictJaJp extends TranslationsErrorDialogDataConflictZhTw {
	_TranslationsErrorDialogDataConflictJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'データ更新あり';
	@override String get content => '閲覧中に他のメンバーが記録を更新しました。正確性を保つため、前のページに戻って更新してください。';
}

/// The flat map containing all translations for locale <ja-JP>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJaJp {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.buttons.cancel' => 'キャンセル',
			'common.buttons.delete' => '削除',
			'common.buttons.confirm' => '確認',
			'common.buttons.back' => '戻る',
			'common.buttons.save' => '保存',
			'common.buttons.edit' => '編集',
			'common.buttons.close' => '閉じる',
			'common.buttons.download' => 'ダウンロード',
			'common.buttons.settlement' => '精算',
			'common.buttons.discard' => '破棄',
			'common.buttons.keep_editing' => '編集を続行',
			'common.buttons.refresh' => '更新',
			'common.buttons.ok' => 'OK',
			'common.buttons.retry' => 'リトライ',
			'common.buttons.done' => '完了',
			'common.buttons.agree' => '同意',
			'common.buttons.decline' => '拒否',
			'common.buttons.add_record' => '追加',
			'common.buttons.copy' => 'コピー',
			'common.label.task_name' => 'タスク名',
			'common.label.item_name' => '項目名',
			'common.label.sub_item' => '子項目名',
			'common.label.amount' => '金額',
			'common.label.date' => '日付',
			'common.label.currency' => '通貨',
			'common.label.split_method' => '負担設定',
			'common.label.start_date' => '開始日',
			'common.label.end_date' => '終了日',
			'common.label.member_count' => '参加人数',
			'common.label.period' => '期間',
			'common.label.payment_method' => '支払方法',
			'common.label.rate' => '為替レート',
			'common.label.memo' => 'メモ',
			'common.category.food' => '食事',
			'common.category.transport' => '交通',
			'common.category.shopping' => '買い物',
			'common.category.entertainment' => 'エンタメ',
			'common.category.accommodation' => '宿泊',
			'common.category.others' => 'その他',
			'common.currency.twd' => '新台湾ドル',
			'common.currency.jpy' => '日本円',
			'common.currency.usd' => 'USドル',
			'common.currency.eur' => 'ユーロ',
			'common.currency.krw' => '韓国ウォン',
			'common.currency.cny' => '人民元',
			'common.currency.gbp' => '英ポンド',
			'common.currency.cad' => 'カナダドル',
			'common.currency.aud' => 'オーストラリアドル',
			'common.currency.chf' => 'スイスフラン',
			'common.currency.dkk' => 'デンマーククローネ',
			'common.currency.hkd' => '香港ドル',
			'common.currency.nok' => 'ノルウェークローネ',
			'common.currency.nzd' => 'ニュージーランドドル',
			'common.currency.sgd' => 'シンガポールドル',
			'common.currency.thb' => 'タイバーツ',
			'common.currency.zar' => '南アフリカランド',
			'common.currency.rub' => 'ロシアルーブル',
			'common.currency.vnd' => 'ベトナムドン',
			'common.currency.idr' => 'インドネシアルピア',
			'common.currency.myr' => 'マレーシアリンギット',
			'common.currency.php' => 'フィリピンペソ',
			'common.currency.mop' => 'マカオパタカ',
			'common.currency.sek' => 'スウェーデンクローナ',
			'common.currency.aed' => 'UAEディルハム',
			'common.currency.sar' => 'サウジアラビアリヤル',
			'common.currency.try_' => 'トルコリラ',
			'common.currency.inr' => 'インドルピー',
			'common.avatar.cow' => 'ホルスタイン牛',
			'common.avatar.pig' => 'ブタ',
			'common.avatar.deer' => 'ノロジカ',
			'common.avatar.horse' => '馬',
			'common.avatar.sheep' => 'サフォーク種のヒツジ',
			'common.avatar.goat' => 'ヤギ',
			'common.avatar.duck' => 'マガモ',
			'common.avatar.stoat' => 'オコジョ',
			'common.avatar.rabbit' => 'ヨーロッパノウサギ',
			'common.avatar.mouse' => 'ハツカネズミ',
			'common.avatar.cat' => 'キジトラのイエネコ',
			'common.avatar.dog' => 'ボーダー・コリー',
			'common.avatar.otter' => 'ユーラシアカワウソ',
			'common.avatar.owl' => 'メンフクロウ',
			'common.avatar.fox' => 'アカギツネ',
			'common.avatar.hedgehog' => 'ヨーロッパハリネズミ',
			'common.avatar.donkey' => 'ロバ',
			'common.avatar.squirrel' => 'ユーラシアアカリス',
			'common.avatar.badger' => 'ヨーロッパアナグマ',
			'common.avatar.robin' => 'ヨーロッパコマドリ',
			'common.remainder_rule.title' => '端数処理',
			'common.remainder_rule.rule.random' => 'ランダム',
			'common.remainder_rule.rule.order' => '順番',
			'common.remainder_rule.rule.member' => '指定',
			'common.remainder_rule.content.remainder' => ({required Object amount}) => '端数 ${amount} は、為替レートの換算や割り勘の計算で生じる差額です。',
			'common.remainder_rule.content.random' => '端数を負担する一人を、システムがランダムに選びます。',
			'common.remainder_rule.content.order' => 'メンバーの参加順に、端数がなくなるまで順番に配分します。',
			'common.remainder_rule.content.member' => '特定のメンバーを指定し、常にその人が端数を負担するようにします。',
			'common.remainder_rule.message.remainder' => ({required Object amount}) => '端数 ${amount} は一時的に保存され、精算時に分配されます。',
			'common.remainder_rule.message.zero_balance' => ({required Object amount}) => '端数 ${amount} は支払い差額と自動的に相殺されました。',
			'common.split_method.even' => '均等',
			'common.split_method.percent' => '比例',
			'common.split_method.exact' => '實額',
			'common.payment_method.member' => 'メンバー立替',
			'common.payment_method.prepay' => '前受金払い',
			'common.payment_method.mixed' => '混合支払',
			'common.language.title' => '言語設定',
			'common.language.zh_TW' => '繁体字中国語',
			'common.language.en_US' => '英語',
			'common.language.jp_JP' => '日本語',
			'common.theme.title' => 'テーマ設定',
			'common.theme.system' => 'システム設定',
			'common.theme.light' => 'ライトモード',
			'common.theme.dark' => 'ダークモード',
			'common.display.title' => '表示設定',
			'common.display.system' => 'システム設定',
			'common.display.enlarged' => '拡大表示',
			'common.display.standard' => '標準表示',
			'common.payment_info.mode.private' => '個別連絡',
			'common.payment_info.mode.public' => '支払い情報を共有',
			'common.payment_info.content.private' => '詳細は表示されません。メンバーから直接連絡してもらいます',
			'common.payment_info.content.public' => '支払い情報をメンバーに表示します',
			'common.payment_info.type.cash' => '現金',
			'common.payment_info.type.bank' => '銀行振込',
			'common.payment_info.type.apps' => '決済アプリ',
			'common.payment_info.label.bank_name' => '銀行コード / 銀行名',
			'common.payment_info.label.bank_account' => '口座番号',
			'common.payment_info.label.app_name' => 'アプリ名',
			'common.payment_info.label.app_link' => 'リンク / ID',
			'common.payment_info.hint.bank_name' => '例：0001-みずほ銀行',
			'common.payment_info.hint.bank_account' => '例：1234567',
			'common.payment_info.hint.app_name' => '例：PayPay',
			'common.payment_info.hint.app_link' => '例：paypay-id-123',
			'common.payment_status.payable' => '支払',
			'common.payment_status.refund' => '返金',
			'common.terms.label.terms' => '利用規約',
			'common.terms.label.privacy' => 'プライバシーポリシー',
			'common.terms.label.both' => '法的条項',
			'common.terms.and' => 'と',
			'common.share.invite.subject' => 'Iron Split タスク招待',
			'common.share.invite.content' => ({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「${taskName}」への招待です。\n招待コード：${code}\nリンク：${link}',
			'common.share.settlement.subject' => 'Iron Split タスク精算通知',
			'common.share.settlement.content' => ({required Object taskName, required Object link}) => '精算が完了しました。\nIron Split アプリを開き、「${taskName}」の支払金額をご確認ください。\nリンク：${link}',
			'common.preparing' => '準備中...',
			'common.me' => '自分',
			'common.required' => '必須',
			'common.member_prefix' => 'メンバー',
			'common.no_record' => '記録なし',
			'common.today' => '今日',
			'log_action.create_task' => 'タスク作成',
			'log_action.update_settings' => '設定更新',
			'log_action.add_member' => 'メンバー追加',
			'log_action.remove_member' => 'メンバー削除',
			'log_action.create_record' => '記録追加',
			'log_action.update_record' => '記録編集',
			'log_action.delete_record' => '記録削除',
			'log_action.settle_up' => '精算実行',
			'log_action.unknown' => '不明な操作',
			'log_action.close_task' => 'タスク終了',
			's10_home_task_list.title' => 'タスク一覧',
			's10_home_task_list.tab.in_progress' => '進行中',
			's10_home_task_list.tab.completed' => '完了済',
			's10_home_task_list.empty.in_progress' => '進行中のタスクはありません',
			's10_home_task_list.empty.completed' => '完了したタスクはありません',
			's10_home_task_list.buttons.add_task' => 'タスク追加',
			's10_home_task_list.buttons.join_task' => 'タスク参加',
			's10_home_task_list.date_tbd' => '日付未定',
			's10_home_task_list.label.settlement' => '精算済み',
			's11_invite_confirm.title' => 'タスク参加',
			's11_invite_confirm.subtitle' => '以下のタスクへの招待',
			's11_invite_confirm.buttons.join' => '参加',
			's11_invite_confirm.buttons.back_task_list' => 'タスク一覧へ',
			's11_invite_confirm.label.select_ghost' => '引き継ぐメンバーを選択',
			's11_invite_confirm.label.prepaid' => '前受金',
			's11_invite_confirm.label.expense' => '支出',
			's12_task_close_notice.title' => 'タスク終了',
			's12_task_close_notice.buttons.close_task' => 'タスク終了',
			's12_task_close_notice.content' => 'このタスクを終了すると、すべての記録および設定がロックされます。読み取り専用モードに移行し、データの追加や編集はできなくなります。',
			's13_task_dashboard.title' => 'ダッシュボード',
			's13_task_dashboard.buttons.add' => '追加',
			's13_task_dashboard.tab.group' => 'グループ',
			's13_task_dashboard.tab.personal' => '個人',
			's13_task_dashboard.label.total_expense' => '総費用',
			's13_task_dashboard.label.total_prepay' => '総前受金',
			's13_task_dashboard.label.total_expense_personal' => '総費用',
			's13_task_dashboard.label.total_prepay_personal' => '総前受金（立替含）',
			's13_task_dashboard.empty.records' => '該当なし',
			's13_task_dashboard.empty.personal_records' => '該当なし',
			's13_task_dashboard.daily_expense_label' => '支出',
			's13_task_dashboard.dialog_balance_detail' => '通貨別収支明細',
			's13_task_dashboard.section.expense' => '支払い通貨',
			's13_task_dashboard.section.prepay' => '前受金通貨',
			's13_task_dashboard.section.prepay_balance' => '前受金残高',
			's13_task_dashboard.section.no_data' => 'データなし',
			's14_task_settings.title' => 'タスク設定',
			's14_task_settings.section.task_name' => 'タスク名',
			's14_task_settings.section.task_period' => 'タスク期間',
			's14_task_settings.section.settlement' => '精算設定',
			's14_task_settings.section.other' => 'その他設定',
			's14_task_settings.menu.invite' => '招待送信',
			's14_task_settings.menu.member_settings' => 'メンバー設定',
			's14_task_settings.menu.history' => '履歴',
			's14_task_settings.menu.close_task' => 'タスク終了',
			's15_record_edit.title.add' => '記録追加',
			's15_record_edit.title.edit' => '記録編集',
			's15_record_edit.buttons.add_item' => '内訳を追加',
			's15_record_edit.section.split' => '分担情報',
			's15_record_edit.section.items' => '内訳分割',
			's15_record_edit.val.prepay' => '前受金',
			's15_record_edit.val.member_paid' => ({required Object name}) => '${name} が立替',
			's15_record_edit.val.split_details' => '内訳分割',
			's15_record_edit.val.split_summary' => ({required Object amount, required Object method}) => '合計 ${amount} を ${method} で分担',
			's15_record_edit.val.converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			's15_record_edit.val.split_remaining' => '残額',
			's15_record_edit.val.mock_note' => '内訳の説明',
			's15_record_edit.tab.expense' => '費用',
			's15_record_edit.tab.prepay' => '前受金',
			's15_record_edit.base_card' => '残額',
			's15_record_edit.type_prepay' => '前受金',
			's15_record_edit.payer_multiple' => '複数人',
			's15_record_edit.rate_dialog.title' => '為替レートの出典',
			's15_record_edit.rate_dialog.content' => '為替レートは Open Exchange Rates（無料版）を参照しています。参考値としてご利用ください。実際の為替レートは両替明細をご確認ください。',
			's15_record_edit.label.rate_with_base' => ({required Object base, required Object target}) => '為替レート（1 ${base} = ? ${target}）',
			's15_record_edit.hint.category.food' => '夕食',
			's15_record_edit.hint.category.transport' => '交通費',
			's15_record_edit.hint.category.shopping' => 'お土産',
			's15_record_edit.hint.category.entertainment' => 'チケット',
			's15_record_edit.hint.category.accommodation' => '宿泊費',
			's15_record_edit.hint.category.others' => 'その他費用',
			's15_record_edit.hint.item' => ({required Object category}) => '例：${category}',
			's15_record_edit.hint.memo' => '例：補足事項',
			's16_task_create_edit.title' => 'タスク作成',
			's16_task_create_edit.section.task_name' => 'タスク名',
			's16_task_create_edit.section.task_period' => 'タスク期間',
			's16_task_create_edit.section.settlement' => '精算設定',
			's16_task_create_edit.label.name_counter' => ({required Object current, required Object max}) => '${current}/${max}',
			's16_task_create_edit.hint.name' => '例：東京5日間の旅',
			's17_task_locked.buttons.notify_members' => 'メンバーに通知',
			's17_task_locked.buttons.view_payment_info' => '受取口座確認',
			's17_task_locked.section.pending' => '未完了',
			's17_task_locked.section.cleared' => '完了',
			's17_task_locked.retention_notice' => ({required Object days}) => '${days} 日後にデータは自動削除されます。期間内にダウンロードしてください。',
			's17_task_locked.remainder_absorbed_by' => ({required Object name}) => '${name} が負担',
			's17_task_locked.export.report_info' => 'レポート情報',
			's17_task_locked.export.task_name' => 'タスク名',
			's17_task_locked.export.export_time' => 'レポート作成日時',
			's17_task_locked.export.base_currency' => '基準通貨',
			's17_task_locked.export.settlement_summary' => '精算サマリー',
			's17_task_locked.export.member' => 'メンバー',
			's17_task_locked.export.role' => '役割',
			's17_task_locked.export.net_amount' => '純額',
			's17_task_locked.export.status' => 'ステータス',
			's17_task_locked.export.receiver' => '返金対象',
			's17_task_locked.export.payer' => '支払対象',
			's17_task_locked.export.cleared' => '処理済み',
			's17_task_locked.export.pending' => '未処理',
			's17_task_locked.export.fund_analysis' => '資金および端数',
			's17_task_locked.export.total_expense' => '総支出',
			's17_task_locked.export.total_prepay' => '総前受金',
			's17_task_locked.export.remainder_buffer' => '端数合計',
			's17_task_locked.export.remainder_absorbed_by' => '端数受取人',
			's17_task_locked.export.transaction_details' => '取引明細',
			's17_task_locked.export.date' => '日付',
			's17_task_locked.export.title' => 'タイトル',
			's17_task_locked.export.type' => '種別',
			's17_task_locked.export.original_amount' => '原通貨金額',
			's17_task_locked.export.currency' => '通貨',
			's17_task_locked.export.rate' => '為替レート',
			's17_task_locked.export.base_amount' => '基準通貨金額',
			's17_task_locked.export.net_remainder' => '端数',
			's17_task_locked.export.pool' => '前受金',
			's17_task_locked.export.mixed' => '混合支払い',
			's18_task_join.title' => 'タスク参加',
			's18_task_join.tabs.input' => '入力',
			's18_task_join.tabs.scan' => 'スキャン',
			's18_task_join.label.input' => '招待コード',
			's18_task_join.hint.input' => '招待コード（8桁）を入力',
			's18_task_join.content.scan' => 'QRコードを枠内に配置すると自動的にスキャンされます',
			's30_settlement_confirm.title' => '精算確認',
			's30_settlement_confirm.buttons.set_payment_info' => '受取設定',
			's30_settlement_confirm.steps.confirm_amount' => '金額確認',
			's30_settlement_confirm.steps.payment_info' => '受取設定',
			's30_settlement_confirm.warning.random_reveal' => '端数は決済確定後に公開されます。',
			's30_settlement_confirm.list_item.merged_label' => '代表メンバー',
			's30_settlement_confirm.list_item.includes' => '内訳：',
			's30_settlement_confirm.list_item.principal' => '元金',
			's30_settlement_confirm.list_item.random_remainder' => 'ランダム端数',
			's30_settlement_confirm.list_item.remainder' => '端数',
			's31_settlement_payment_info.title' => '受取情報',
			's31_settlement_payment_info.setup_instruction' => '今回の精算のみに使用されます。デフォルト情報は端末内に暗号化保存されます。',
			's31_settlement_payment_info.sync_save' => 'デフォルトの受取情報として保存（端末内）',
			's31_settlement_payment_info.sync_update' => 'デフォルト受取情報を更新',
			's31_settlement_payment_info.buttons.prev_step' => '前へ戻る',
			's32_settlement_result.title' => '精算完了',
			's32_settlement_result.content' => 'すべての記録が確定しました。メンバーに結果を共有し、支払いを進めてください。',
			's32_settlement_result.waiting_reveal' => '結果を確認中...',
			's32_settlement_result.remainder_winner_prefix' => '端数の受取先：',
			's32_settlement_result.remainder_winner_total' => ({required Object winnerName, required Object prefix, required Object total}) => '${winnerName} の最終金額 ${prefix}${total}',
			's32_settlement_result.total_label' => '今回の精算合計額',
			's32_settlement_result.buttons.share' => '通知送信',
			's32_settlement_result.buttons.back_task_dashboard' => 'タスクに戻る',
			's50_onboarding_consent.title' => 'Iron Split へようこそ',
			's50_onboarding_consent.buttons.start' => 'はじめる',
			's50_onboarding_consent.content.prefix' => '分帳を、よりシンプルに。\n\n私はアイロン・ルースト。ここで記帳と分担を管理します。\n旅行、食事、共同生活など、すべての支出は明確に記録され、分担方法には明確なルールがあります。\n\n分帳は、本来わかりやすいものです。\n\n「はじめる」を押すことで、',
			's50_onboarding_consent.content.suffix' => ' に同意したものとみなされます。',
			's51_onboarding_name.title' => '名前設定',
			's51_onboarding_name.content' => 'アプリ内で表示する名前を入力（1–10文字）',
			's51_onboarding_name.hint' => 'ニックネームを入力',
			's51_onboarding_name.counter' => ({required Object current, required Object max}) => '${current}/${max}',
			's52_task_settings_log.title' => '活動履歴',
			's52_task_settings_log.buttons.export_csv' => 'CSV出力',
			's52_task_settings_log.empty_log' => '活動履歴はありません',
			's52_task_settings_log.export_file_prefix' => '活動履歴',
			's52_task_settings_log.csv_header.time' => '日時',
			's52_task_settings_log.csv_header.user' => '操作者',
			's52_task_settings_log.csv_header.action' => '操作',
			's52_task_settings_log.csv_header.details' => '詳細',
			's52_task_settings_log.type.prepay' => '収入',
			's52_task_settings_log.type.expense' => '支出',
			's52_task_settings_log.payment_type.prepay' => '前受金',
			's52_task_settings_log.payment_type.single_suffix' => '立替',
			's52_task_settings_log.payment_type.multiple' => '複数立替',
			's52_task_settings_log.unit.members' => '名',
			's52_task_settings_log.unit.items' => '項目',
			's53_task_settings_members.title' => 'メンバー管理',
			's53_task_settings_members.buttons.add_member' => 'メンバー追加',
			's53_task_settings_members.label.default_ratio' => 'デフォルト比率',
			's53_task_settings_members.member_default_name' => 'メンバー',
			's53_task_settings_members.member_name' => 'メンバー名',
			's54_task_settings_invite.title' => 'タスク招待',
			's54_task_settings_invite.buttons.share' => '共有',
			's54_task_settings_invite.buttons.regenerate' => '再生成',
			's54_task_settings_invite.label.expires_in' => '有效期限',
			's54_task_settings_invite.label.invite_expired' => '有効期限が切れました',
			's70_system_settings.title' => 'システム設定',
			's70_system_settings.section.basic' => '基本設定',
			's70_system_settings.section.legal' => '関連規約',
			's70_system_settings.section.account' => 'アカウント設定',
			's70_system_settings.menu.user_name' => '表示名前',
			's70_system_settings.menu.language' => '表示言語',
			's70_system_settings.menu.theme' => 'テーマ',
			's70_system_settings.menu.terms' => '利用規約',
			's70_system_settings.menu.privacy' => 'プライバシーポリシー',
			's70_system_settings.menu.payment_info' => '支払/受取口座設定',
			's70_system_settings.menu.delete_account' => 'アカウント削除',
			's72_terms_update.title' => ({required Object type}) => '${type}更新',
			's72_terms_update.content' => ({required Object type}) => '${type} を更新しました。続けてご利用いただくには、内容をご確認のうえ同意してください。',
			's74_delete_account_notice.title' => 'アカウント削除確認',
			's74_delete_account_notice.content' => 'この操作は元に戻せません。個人情報は削除されます。リーダー権限は自動的に他のメンバーへ移行されますが、共有帳簿内の記録は保持されます（未リンク状態になります）。',
			's74_delete_account_notice.buttons.delete_account' => 'アカウント削除',
			'd01_member_role_intro.title' => '今回のキャラクター',
			'd01_member_role_intro.buttons.reroll' => '動物を変える',
			'd01_member_role_intro.buttons.enter' => 'タスクへ進む',
			'd01_member_role_intro.content' => ({required Object avatar}) => '今回のタスクでのアイコン${avatar}です。\n記録には${avatar}が表示されます。',
			'd01_member_role_intro.reroll.empty' => '変更不可',
			'd02_invite_result.title' => '参加失敗',
			'd03_task_create_confirm.title' => '設定の確認',
			'd03_task_create_confirm.buttons.back_edit' => '編集に戻る',
			'd04_common_unsaved_confirm.title' => '未保存の変更',
			'd04_common_unsaved_confirm.content' => '変更内容は保存されません。',
			'd05_date_jump_no_result.title' => '記録なし',
			'd05_date_jump_no_result.content' => 'この日付の記録は見つかりませんでした。追加しますか？',
			'd06_settlement_confirm.title' => '精算確認',
			'd06_settlement_confirm.content' => '精算を行うとタスクはロックされ、記録の追加・削除・編集ができなくなります。\n内容をご確認ください。',
			'd08_task_closed_confirm.title' => 'タスク終了確認',
			'd08_task_closed_confirm.content' => 'この操作は取り消すことができません。すべてのデータは永久にロックされます。\n\n続行してもよろしいですか？',
			'd09_task_settings_currency_confirm.title' => '決済通貨変更',
			'd09_task_settings_currency_confirm.content' => '通貨を変更すると、すべての為替レート設定がリセットされます。現在の収支に影響する可能性があります。よろしいですか？',
			'd10_record_delete_confirm.title' => '記録削除確認',
			'd10_record_delete_confirm.content' => ({required Object title, required Object amount}) => '${title} （${amount}）を削除してもよろしいですか？',
			'd11_random_result.title' => '当選者',
			'd11_random_result.skip' => 'スキップ',
			'd12_logout_confirm.title' => 'ログアウト確認',
			'd12_logout_confirm.content' => '更新後の規約に同意しない場合、本サービスを継続して利用することはできません。\nログアウトされます。',
			'd12_logout_confirm.buttons.logout' => 'ログアウト',
			'd13_delete_account_confirm.title' => 'アカウント削除確認',
			'd13_delete_account_confirm.content' => 'この操作は取り消すことができません。すべてのデータは永久に削除されます。\n\n続行してもよろしいですか？',
			'd14_date_select.title' => '日付の選択',
			'b02_split_expense_edit.title' => '明細編集',
			'b02_split_expense_edit.buttons.confirm_split' => '決定',
			'b02_split_expense_edit.item_name_empty' => '親項目名を入力してください',
			'b02_split_expense_edit.hint.sub_item' => '例：内訳',
			'b03_split_method_edit.title' => '割り勘方法',
			'b03_split_method_edit.buttons.adjust_weight' => '比率調整',
			'b03_split_method_edit.label.total' => ({required Object current, required Object target}) => '${current} / ${target}',
			'b03_split_method_edit.mismatch' => '一致しません',
			'b04_payment_merge.title' => '支払い統合',
			'b04_payment_merge.label.head_member' => '代表メンバー',
			'b04_payment_merge.label.merge_amount' => '統合金額',
			'b07_payment_method_edit.title' => '資金源を選択',
			'b07_payment_method_edit.prepay_balance' => ({required Object amount}) => '前受金残高：${amount}',
			'b07_payment_method_edit.payer_member' => '支払者',
			'b07_payment_method_edit.label.amount' => '支払金額',
			'b07_payment_method_edit.label.total_expense' => '合計金額',
			'b07_payment_method_edit.label.prepay' => '前受金払い',
			'b07_payment_method_edit.label.total_advance' => '立替合計',
			'b07_payment_method_edit.status.not_enough' => '残高不足',
			'b07_payment_method_edit.status.balanced' => '一致',
			'b07_payment_method_edit.status.remaining' => ({required Object amount}) => '残り ${amount}',
			'success.saved' => '保存しました。',
			'success.deleted' => '削除しました。',
			'success.copied' => 'コピーしました',
			'error.title' => 'エラー',
			'error.unknown' => ({required Object error}) => '不明なエラー：${error}',
			'error.dialog.task_full.title' => 'タスク満員',
			'error.dialog.task_full.content' => ({required Object limit}) => 'メンバー数が上限 ${limit} 人に達しています。リーダーへ連絡してください。',
			'error.dialog.expired_code.title' => '招待コード期限切れ',
			'error.dialog.expired_code.content' => ({required Object minutes}) => 'この招待リンクは無効です（期限 ${minutes} 分）。リーダーに再発行を依頼してください。',
			'error.dialog.invalid_code.title' => '無効な招待リンク',
			'error.dialog.invalid_code.content' => '無効な招待リンクです。',
			'error.dialog.auth_required.title' => 'ログインが必要',
			'error.dialog.auth_required.content' => 'タスク参加にはログインが必要です。',
			'error.dialog.already_in_task.title' => '既に参加済',
			'error.dialog.already_in_task.content' => '既にこのタスクのメンバーです。',
			'error.dialog.unknown.title' => 'エラー',
			'error.dialog.unknown.content' => '予期せぬエラーが発生しました。',
			'error.dialog.delete_failed.title' => '削除失敗',
			'error.dialog.delete_failed.content' => '削除に失敗しました。後でもう一度お試しください。',
			'error.dialog.member_delete_failed.title' => 'メンバー削除エラー',
			'error.dialog.member_delete_failed.content' => 'このメンバーには、関連する記帳記録、または未精算の金額があります。該当する記録を修正または削除してから、再度お試しください。',
			'error.dialog.data_conflict.title' => 'データ更新あり',
			'error.dialog.data_conflict.content' => '閲覧中に他のメンバーが記録を更新しました。正確性を保つため、前のページに戻って更新してください。',
			'error.message.unknown' => '予期せぬエラーが発生しました。',
			'error.message.invalid_amount' => '金額が無効です。',
			'error.message.required' => '必須項目です。',
			'error.message.empty' => ({required Object key}) => '${key}を入力してください。',
			'error.message.format' => '形式が正しくありません。',
			'error.message.zero' => ({required Object key}) => '${key}は0にできません。',
			'error.message.amount_not_enough' => '残額が不足しています。',
			'error.message.amount_mismatch' => '金額が一致しません。',
			'error.message.prepay_is_used' => 'この金額は既に使用されているか、残高が不足しています。',
			'error.message.data_is_used' => 'このメンバーには、関連する記帳記録、または未精算の金額があります。該当する記録を修正または削除してから、再度お試しください。',
			'error.message.permission_denied' => '権限がありません。',
			'error.message.network_error' => 'ネットワーク接続に失敗しました。通信状況をご確認ください。',
			'error.message.data_not_found' => 'データが見つかりませんでした。もう一度お試しください。',
			'error.message.enter_first' => ({required Object key}) => '${key}を先に入力してください。',
			'error.message.export_failed' => 'レポートの作成に失敗しました。空き容量を確認するか、後でもう一度お試しください。',
			'error.message.save_failed' => '保存に失敗しました。もう一度お試しください。',
			'error.message.delete_failed' => '削除に失敗しました。もう一度お試しください。',
			'error.message.task_close_failed' => 'タスク終了に失敗しました。しばらくしてから再試行してください。',
			'error.message.rate_fetch_failed' => '為替レートの取得に失敗しました。',
			'error.message.length_exceeded' => ({required Object max}) => '${max}文字以内で入力してください。',
			'error.message.invalid_char' => '無効な文字が含まれています。',
			'error.message.invalid_code' => '招待コードが無効です。リンクが正しいか確認してください。',
			'error.message.expired_code' => ({required Object expiry_minutes}) => '招待リンクの期限（${expiry_minutes}分）が切れています。リーダーに再送を依頼してください。',
			'error.message.task_full' => ({required Object limit}) => '定員オーバーです（上限${limit}名）。',
			'error.message.auth_required' => '認証に失敗しました。アプリを再起動してください。',
			'error.message.init_failed' => '読み込みに失敗しました。もう一度お試しください。',
			'error.message.unauthorized' => 'ログインしていません。再度ログインしてください。',
			'error.message.task_locked' => '精算済みのため、データを変更できません。',
			'error.message.timeout' => 'タイムアウトしました。後でもう一度お試しください。',
			'error.message.quota_exceeded' => '利用制限に達しました。しばらく経ってからお試しください。',
			'error.message.join_failed' => 'タスクに参加できませんでした。しばらく経ってからお試しください。',
			'error.message.invite_create_failed' => '招待コードを作成できませんでした。しばらく経ってからお試しください。',
			'error.message.data_conflict' => '閲覧中に他のメンバーが記録を更新しました。正確性を保つため、前のページに戻って更新してください。',
			'error.message.task_status_error' => 'タスクの状態が無効です（既に精算済みの可能性があります）。更新してください。',
			'error.message.settlement_failed' => 'システムエラーが発生しました。後でもう一度お試しください。',
			'error.message.share_failed' => 'シェアが失敗しました。後でもう一度お試しください。',
			'error.message.login_failed' => 'ログインが失敗しました。後でもう一度お試しください。',
			'error.message.logout_failed' => 'ログアウトが失敗しました。後でもう一度お試しください。',
			'error.message.scan_failed' => 'スキャンが失敗しました。後でもう一度お試しください。',
			'error.message.invalid_qr_code' => '無効なQRコードです。',
			'error.message.camera_permission_denied' => '設定からカメラの権限を有効にしてください。',
			_ => null,
		};
	}
}
