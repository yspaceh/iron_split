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
	@override late final _TranslationsDialogJaJp dialog = _TranslationsDialogJaJp._(_root);
	@override late final _TranslationsS50OnboardingConsentJaJp S50_Onboarding_Consent = _TranslationsS50OnboardingConsentJaJp._(_root);
	@override late final _TranslationsS51OnboardingNameJaJp S51_Onboarding_Name = _TranslationsS51OnboardingNameJaJp._(_root);
	@override late final _TranslationsS10HomeTaskListJaJp S10_Home_TaskList = _TranslationsS10HomeTaskListJaJp._(_root);
	@override late final _TranslationsS11InviteConfirmJaJp S11_Invite_Confirm = _TranslationsS11InviteConfirmJaJp._(_root);
	@override late final _TranslationsS12TaskCloseNoticeJaJp S12_TaskClose_Notice = _TranslationsS12TaskCloseNoticeJaJp._(_root);
	@override late final _TranslationsS13TaskDashboardJaJp S13_Task_Dashboard = _TranslationsS13TaskDashboardJaJp._(_root);
	@override late final _TranslationsS14TaskSettingsJaJp S14_Task_Settings = _TranslationsS14TaskSettingsJaJp._(_root);
	@override late final _TranslationsS15RecordEditJaJp S15_Record_Edit = _TranslationsS15RecordEditJaJp._(_root);
	@override late final _TranslationsS16TaskCreateEditJaJp S16_TaskCreate_Edit = _TranslationsS16TaskCreateEditJaJp._(_root);
	@override late final _TranslationsS17TaskLockedJaJp S17_Task_Locked = _TranslationsS17TaskLockedJaJp._(_root);
	@override late final _TranslationsS30SettlementConfirmJaJp S30_settlement_confirm = _TranslationsS30SettlementConfirmJaJp._(_root);
	@override late final _TranslationsS31SettlementPaymentInfoJaJp S31_settlement_payment_info = _TranslationsS31SettlementPaymentInfoJaJp._(_root);
	@override late final _TranslationsS32SettlementResultJaJp S32_settlement_result = _TranslationsS32SettlementResultJaJp._(_root);
	@override late final _TranslationsS52TaskSettingsLogJaJp S52_TaskSettings_Log = _TranslationsS52TaskSettingsLogJaJp._(_root);
	@override late final _TranslationsS53TaskSettingsMembersJaJp S53_TaskSettings_Members = _TranslationsS53TaskSettingsMembersJaJp._(_root);
	@override late final _TranslationsS71SystemSettingsTosJaJp S71_SystemSettings_Tos = _TranslationsS71SystemSettingsTosJaJp._(_root);
	@override late final _TranslationsD01MemberRoleIntroJaJp D01_MemberRole_Intro = _TranslationsD01MemberRoleIntroJaJp._(_root);
	@override late final _TranslationsD02InviteResultJaJp D02_Invite_Result = _TranslationsD02InviteResultJaJp._(_root);
	@override late final _TranslationsD03TaskCreateConfirmJaJp D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmJaJp._(_root);
	@override late final _TranslationsD05DateJumpNoResultJaJp D05_DateJump_NoResult = _TranslationsD05DateJumpNoResultJaJp._(_root);
	@override late final _TranslationsD06SettlementConfirmJaJp D06_settlement_confirm = _TranslationsD06SettlementConfirmJaJp._(_root);
	@override late final _TranslationsD08TaskClosedConfirmJaJp D08_TaskClosed_Confirm = _TranslationsD08TaskClosedConfirmJaJp._(_root);
	@override late final _TranslationsD09TaskSettingsCurrencyConfirmJaJp D09_TaskSettings_CurrencyConfirm = _TranslationsD09TaskSettingsCurrencyConfirmJaJp._(_root);
	@override late final _TranslationsD10RecordDeleteConfirmJaJp D10_RecordDelete_Confirm = _TranslationsD10RecordDeleteConfirmJaJp._(_root);
	@override late final _TranslationsD11RandomResultJaJp D11_random_result = _TranslationsD11RandomResultJaJp._(_root);
	@override late final _TranslationsB02SplitExpenseEditJaJp B02_SplitExpense_Edit = _TranslationsB02SplitExpenseEditJaJp._(_root);
	@override late final _TranslationsB03SplitMethodEditJaJp B03_SplitMethod_Edit = _TranslationsB03SplitMethodEditJaJp._(_root);
	@override late final _TranslationsB04PaymentMergeJaJp B04_payment_merge = _TranslationsB04PaymentMergeJaJp._(_root);
	@override late final _TranslationsB06PaymentInfoDetailJaJp B06_payment_info_detail = _TranslationsB06PaymentInfoDetailJaJp._(_root);
	@override late final _TranslationsB07PaymentMethodEditJaJp B07_PaymentMethod_Edit = _TranslationsB07PaymentMethodEditJaJp._(_root);
	@override late final _TranslationsErrorJaJp error = _TranslationsErrorJaJp._(_root);
}

// Path: common
class _TranslationsCommonJaJp extends TranslationsCommonZhTw {
	_TranslationsCommonJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonButtonsJaJp buttons = _TranslationsCommonButtonsJaJp._(_root);
	@override late final _TranslationsCommonErrorJaJp error = _TranslationsCommonErrorJaJp._(_root);
	@override late final _TranslationsCommonCategoryJaJp category = _TranslationsCommonCategoryJaJp._(_root);
	@override late final _TranslationsCommonCurrencyJaJp currency = _TranslationsCommonCurrencyJaJp._(_root);
	@override late final _TranslationsCommonRemainderRuleJaJp remainder_rule = _TranslationsCommonRemainderRuleJaJp._(_root);
	@override late final _TranslationsCommonPaymentInfoJaJp payment_info = _TranslationsCommonPaymentInfoJaJp._(_root);
	@override late final _TranslationsCommonShareJaJp share = _TranslationsCommonShareJaJp._(_root);
	@override String error_prefix({required Object message}) => 'エラー: ${message}';
	@override String get please_login => 'ログインしてください';
	@override String get loading => '読み込み中...';
	@override String get me => '自分';
	@override String get required => '必須';
	@override String get member_prefix => 'メンバー';
	@override String get no_record => '記録なし';
	@override String get today => '今日';
	@override String get untitled => '無題';
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

// Path: dialog
class _TranslationsDialogJaJp extends TranslationsDialogZhTw {
	_TranslationsDialogJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get unsaved_changes_title => '未保存の変更';
	@override String get unsaved_changes_content => '変更内容は保存されません。';
}

// Path: S50_Onboarding_Consent
class _TranslationsS50OnboardingConsentJaJp extends TranslationsS50OnboardingConsentZhTw {
	_TranslationsS50OnboardingConsentJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'Iron Split へようこそ';
	@override late final _TranslationsS50OnboardingConsentButtonsJaJp buttons = _TranslationsS50OnboardingConsentButtonsJaJp._(_root);
	@override String get content_prefix => '開始することで、';
	@override String get terms_link => '利用規約';
	@override String get and => ' と ';
	@override String get privacy_link => 'プライバシーポリシー';
	@override String get content_suffix => ' に同意したものとみなされます。';
	@override String login_failed({required Object message}) => 'ログイン失敗: ${message}';
}

// Path: S51_Onboarding_Name
class _TranslationsS51OnboardingNameJaJp extends TranslationsS51OnboardingNameZhTw {
	_TranslationsS51OnboardingNameJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '名前設定';
	@override late final _TranslationsS51OnboardingNameButtonsJaJp buttons = _TranslationsS51OnboardingNameButtonsJaJp._(_root);
	@override String get description => 'アプリ内で表示する名前を入力してください（1-10文字）。';
	@override String get field_hint => 'ニックネームを入力';
	@override String field_counter({required Object current}) => '${current}/10';
	@override String get error_empty => '名前を入力してください';
	@override String get error_too_long => '10文字以内で入力してください';
	@override String get error_invalid_char => '無効な文字が含まれています';
}

// Path: S10_Home_TaskList
class _TranslationsS10HomeTaskListJaJp extends TranslationsS10HomeTaskListZhTw {
	_TranslationsS10HomeTaskListJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'マイタスク';
	@override String get tab_in_progress => '進行中';
	@override String get tab_completed => '完了済';
	@override String get mascot_preparing => '鉄の雄鶏、準備中...';
	@override String get empty_in_progress => '進行中のタスクはありません';
	@override String get empty_completed => '完了したタスクはありません';
	@override String get date_tbd => '日付未定';
	@override String get delete_confirm_title => '削除の確認';
	@override String get delete_confirm_content => 'このタスクを削除してもよろしいですか？';
	@override String get label_settlement => '精算済み';
}

// Path: S11_Invite_Confirm
class _TranslationsS11InviteConfirmJaJp extends TranslationsS11InviteConfirmZhTw {
	_TranslationsS11InviteConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスクに参加';
	@override String get subtitle => '以下のタスクに招待されました：';
	@override late final _TranslationsS11InviteConfirmButtonsJaJp buttons = _TranslationsS11InviteConfirmButtonsJaJp._(_root);
	@override String get loading_invite => '招待状を読み込み中...';
	@override String get join_failed_title => 'タスクに参加できません';
	@override String get identity_match_title => 'あなたは以下のメンバーですか？';
	@override String get identity_match_desc => 'このタスクには事前に作成されたメンバーがいます。もしあなたがいれば、名前を選択してアカウントを連携してください。そうでなければ、新規に参加してください。';
	@override String get status_linking => '「アカウント連携」で参加します';
	@override String get status_new_member => '「新規メンバー」として参加します';
	@override String error_join_failed({required Object message}) => '参加失敗: ${message}';
	@override String error_generic({required Object message}) => 'エラー: ${message}';
	@override String get label_select_ghost => '引き継ぐメンバーを選択';
	@override String get label_prepaid => '立替';
	@override String get label_expense => '支出';
}

// Path: S12_TaskClose_Notice
class _TranslationsS12TaskCloseNoticeJaJp extends TranslationsS12TaskCloseNoticeZhTw {
	_TranslationsS12TaskCloseNoticeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク終了';
	@override late final _TranslationsS12TaskCloseNoticeButtonsJaJp buttons = _TranslationsS12TaskCloseNoticeButtonsJaJp._(_root);
	@override String get content => 'このタスクをクローズすると、すべての記録および設定がロックされます。読み取り専用モードに移行し、データの追加や編集はできなくなります。';
}

// Path: S13_Task_Dashboard
class _TranslationsS13TaskDashboardJaJp extends TranslationsS13TaskDashboardZhTw {
	_TranslationsS13TaskDashboardJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title_active => 'ダッシュボード';
	@override late final _TranslationsS13TaskDashboardButtonsJaJp buttons = _TranslationsS13TaskDashboardButtonsJaJp._(_root);
	@override String get tab_group => 'グループ';
	@override String get tab_personal => '個人';
	@override String get label_prepay_balance => 'プール残高';
	@override String get label_my_balance => '私の収支';
	@override String label_remainder({required Object amount}) => '端数: ${amount}';
	@override String get label_balance => '残高';
	@override String get label_total_expense => '総費用';
	@override String get label_total_prepay => '総預り金';
	@override String get label_remainder_pot => '端数ポット';
	@override String get empty_records => '記録がありません';
	@override String get nav_to_record => '記録ページへ移動します...';
	@override String get daily_expense_label => '支出';
	@override String get dialog_balance_detail => '通貨別内訳';
	@override String get section_expense => '支払い通貨';
	@override String get section_income => '預り金通貨';
	@override String get daily_stats_title => '本日の支出';
	@override String get personal_daily_total => '本日の個人支出';
	@override String get personal_to_receive => '受取';
	@override String get personal_to_pay => '支払';
	@override String get personal_empty_desc => 'この日のあなたに関連する記録はありません';
	@override String get total_amount_label => '合計金額';
}

// Path: S14_Task_Settings
class _TranslationsS14TaskSettingsJaJp extends TranslationsS14TaskSettingsZhTw {
	_TranslationsS14TaskSettingsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク設定';
	@override String get menu_member_settings => 'メンバー設定';
	@override String get menu_history => '履歴';
	@override String get menu_end_task => 'タスク終了';
	@override String get section_remainder => '残高';
}

// Path: S15_Record_Edit
class _TranslationsS15RecordEditJaJp extends TranslationsS15RecordEditZhTw {
	_TranslationsS15RecordEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title_create => '記録を追加';
	@override String get title_edit => '記録を編集';
	@override late final _TranslationsS15RecordEditButtonsJaJp buttons = _TranslationsS15RecordEditButtonsJaJp._(_root);
	@override String get section_split => '割り勘情報';
	@override String get label_date => '日付';
	@override String get label_title => '項目名';
	@override String get hint_title => '何に使いましたか？';
	@override String get label_payment_method => '支払方法';
	@override String get val_prepay => '前受金 (Prepay)';
	@override String val_member_paid({required Object name}) => '${name} が立替';
	@override String get label_amount => '金額';
	@override String label_rate({required Object base, required Object target}) => 'レート (1 ${base} = ? ${target})';
	@override String get label_memo => 'メモ';
	@override String get hint_memo => '備考を入力...';
	@override String get val_split_details => '詳細を編集';
	@override String val_split_summary({required Object amount, required Object method}) => '計 ${amount} を${method}で割り勘';
	@override String get info_rate_source => 'レートの提供元';
	@override String get msg_rate_source => '為替レートはOpen Exchange Rates (無料版) を参照しています。正確なレートは両替レシート等をご確認ください。';
	@override String val_converted_amount({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}';
	@override String get val_split_remaining => '残り金額';
	@override String get err_amount_not_enough => '残り金額不足';
	@override String get val_mock_note => '項目メモ';
	@override String get tab_expense => '支出';
	@override String get tab_income => '受取';
	@override String get msg_income_developing => '受取機能は開発中です...';
	@override String get msg_not_implemented => 'この機能はまだ実装されていません';
	@override String get err_input_amount => '先に金額を入力してください';
	@override String get section_items => '詳細内訳';
	@override String get add_item => '明細追加';
	@override String get base_card_title => '残額 (Base)';
	@override String get type_income_title => '預り金';
	@override String get base_card_title_expense => '残額 (Base)';
	@override String get base_card_title_income => '資金提供者';
	@override String get payer_multiple => '複数人';
	@override String msg_leftover_pot({required Object amount}) => '残り ${amount} は残高罐に保存されます（決算時に分配）';
}

// Path: S16_TaskCreate_Edit
class _TranslationsS16TaskCreateEditJaJp extends TranslationsS16TaskCreateEditZhTw {
	_TranslationsS16TaskCreateEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク作成';
	@override late final _TranslationsS16TaskCreateEditButtonsJaJp buttons = _TranslationsS16TaskCreateEditButtonsJaJp._(_root);
	@override String get section_name => 'タスク名';
	@override String get section_period => '期間';
	@override String get section_settings => '設定';
	@override String get field_name_hint => '例：東京5日間の旅';
	@override String field_name_counter({required Object current}) => '${current}/20';
	@override String get field_start_date => '開始日';
	@override String get field_end_date => '終了日';
	@override String get field_currency => '通貨';
	@override String get field_member_count => '参加人数';
	@override String get error_name_empty => 'タスク名を入力してください';
	@override String get label_name => 'タスク名';
	@override String get label_date => '日付';
	@override String get label_currency => '通貨';
}

// Path: S17_Task_Locked
class _TranslationsS17TaskLockedJaJp extends TranslationsS17TaskLockedZhTw {
	_TranslationsS17TaskLockedJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsS17TaskLockedButtonsJaJp buttons = _TranslationsS17TaskLockedButtonsJaJp._(_root);
	@override String retention_notice({required Object days}) => '${days} 日後にデータは自動削除されます。期間内にダウンロードしてください。';
	@override String label_remainder_absorbed_by({required Object name}) => 'は ${name} が負担';
	@override String get section_pending => '未完了';
	@override String get section_cleared => '完了';
	@override String get member_payment_status_pay => '支払';
	@override String get member_payment_status_receive => '受取';
	@override String get dialog_mark_cleared_title => '完了確認';
	@override String dialog_mark_cleared_content({required Object name}) => '${name} を完了としてマークしますか？';
}

// Path: S30_settlement_confirm
class _TranslationsS30SettlementConfirmJaJp extends TranslationsS30SettlementConfirmZhTw {
	_TranslationsS30SettlementConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '精算確認';
	@override late final _TranslationsS30SettlementConfirmButtonsJaJp buttons = _TranslationsS30SettlementConfirmButtonsJaJp._(_root);
	@override late final _TranslationsS30SettlementConfirmStepsJaJp steps = _TranslationsS30SettlementConfirmStepsJaJp._(_root);
	@override late final _TranslationsS30SettlementConfirmWarningJaJp warning = _TranslationsS30SettlementConfirmWarningJaJp._(_root);
	@override String get label_payable => '支払';
	@override String get label_refund => '返金';
	@override late final _TranslationsS30SettlementConfirmListItemJaJp list_item = _TranslationsS30SettlementConfirmListItemJaJp._(_root);
}

// Path: S31_settlement_payment_info
class _TranslationsS31SettlementPaymentInfoJaJp extends TranslationsS31SettlementPaymentInfoZhTw {
	_TranslationsS31SettlementPaymentInfoJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '受取情報';
	@override String get setup_instruction => '今回の精算のみに使用されます。デフォルト情報は端末内に暗号化保存されます。';
	@override String get sync_save => 'デフォルトの受取情報として保存（端末内）';
	@override String get sync_update => '自分のデフォルト受取情報を同期更新';
	@override late final _TranslationsS31SettlementPaymentInfoButtonsJaJp buttons = _TranslationsS31SettlementPaymentInfoButtonsJaJp._(_root);
}

// Path: S32_settlement_result
class _TranslationsS32SettlementResultJaJp extends TranslationsS32SettlementResultZhTw {
	_TranslationsS32SettlementResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '精算完了';
	@override String get content => 'すべての記録が確定しました。メンバーに結果を共有し、支払いを進めてください。';
	@override String get waiting_reveal => '結果を確認中...';
	@override String get remainder_winner_prefix => '残額の受取先：';
	@override String remainder_winner_total({required Object winnerName, required Object prefix, required Object total}) => '\$${winnerName}さんは\$${prefix} \$${total}になります。';
	@override String get total_label => '今回の精算合計額';
	@override late final _TranslationsS32SettlementResultButtonsJaJp buttons = _TranslationsS32SettlementResultButtonsJaJp._(_root);
}

// Path: S52_TaskSettings_Log
class _TranslationsS52TaskSettingsLogJaJp extends TranslationsS52TaskSettingsLogZhTw {
	_TranslationsS52TaskSettingsLogJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '活動履歴';
	@override late final _TranslationsS52TaskSettingsLogButtonsJaJp buttons = _TranslationsS52TaskSettingsLogButtonsJaJp._(_root);
	@override String get empty_log => '活動履歴はありません';
	@override String get export_file_prefix => '活動履歴';
	@override late final _TranslationsS52TaskSettingsLogCsvHeaderJaJp csv_header = _TranslationsS52TaskSettingsLogCsvHeaderJaJp._(_root);
	@override String get type_income => '収入';
	@override String get type_expense => '支出';
	@override String get label_payment => '支払';
	@override String get payment_income => '前受金';
	@override String get payment_pool => '共益費払';
	@override String get payment_single_suffix => '立替';
	@override String get payment_multiple => '複数立替';
	@override String get unit_members => '名';
	@override String get unit_items => '項目';
}

// Path: S53_TaskSettings_Members
class _TranslationsS53TaskSettingsMembersJaJp extends TranslationsS53TaskSettingsMembersZhTw {
	_TranslationsS53TaskSettingsMembersJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'メンバー管理';
	@override late final _TranslationsS53TaskSettingsMembersButtonsJaJp buttons = _TranslationsS53TaskSettingsMembersButtonsJaJp._(_root);
	@override String get label_default_ratio => 'デフォルト比率';
	@override String get dialog_delete_error_title => 'メンバー削除エラー';
	@override String get dialog_delete_error_content => 'このメンバーには、関連する記帳記録、または未精算の金額があります。該当する記録を修正または削除してから、再度お試しください。';
	@override String get member_default_name => 'メンバー';
	@override String get member_name => 'メンバー名';
}

// Path: S71_SystemSettings_Tos
class _TranslationsS71SystemSettingsTosJaJp extends TranslationsS71SystemSettingsTosZhTw {
	_TranslationsS71SystemSettingsTosJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '利用規約';
}

// Path: D01_MemberRole_Intro
class _TranslationsD01MemberRoleIntroJaJp extends TranslationsD01MemberRoleIntroZhTw {
	_TranslationsD01MemberRoleIntroJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'あなたのキャラクター';
	@override late final _TranslationsD01MemberRoleIntroButtonsJaJp buttons = _TranslationsD01MemberRoleIntroButtonsJaJp._(_root);
	@override String get desc_reroll_left => 'あと1回変更可';
	@override String get desc_reroll_empty => '変更不可';
	@override String get dialog_content => 'これが今回のタスクでのあなたのアイコンです。割り勘の記録にはこの動物が表示されますよ！';
}

// Path: D02_Invite_Result
class _TranslationsD02InviteResultJaJp extends TranslationsD02InviteResultZhTw {
	_TranslationsD02InviteResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '参加失敗';
	@override late final _TranslationsD02InviteResultButtonsJaJp buttons = _TranslationsD02InviteResultButtonsJaJp._(_root);
	@override String get error_INVALID_CODE => '招待コードが無効です。リンクが正しいか確認してください。';
	@override String get error_EXPIRED_CODE => '招待リンクの期限（15分）が切れています。リーダーに再送を依頼してください。';
	@override String get error_TASK_FULL => '定員オーバーです（上限15名）。参加できません。';
	@override String get error_AUTH_REQUIRED => '認証に失敗しました。アプリを再起動してください。';
	@override String get error_UNKNOWN => '不明なエラーが発生しました。後ほどお試しください。';
}

// Path: D03_TaskCreate_Confirm
class _TranslationsD03TaskCreateConfirmJaJp extends TranslationsD03TaskCreateConfirmZhTw {
	_TranslationsD03TaskCreateConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '設定の確認';
	@override late final _TranslationsD03TaskCreateConfirmButtonsJaJp buttons = _TranslationsD03TaskCreateConfirmButtonsJaJp._(_root);
	@override String get label_name => 'タスク名';
	@override String get label_period => '期間';
	@override String get label_currency => '通貨';
	@override String get label_members => '人数';
	@override String get creating_task => '作成中...';
	@override String get preparing_share => '招待を準備中...';
}

// Path: D05_DateJump_NoResult
class _TranslationsD05DateJumpNoResultJaJp extends TranslationsD05DateJumpNoResultZhTw {
	_TranslationsD05DateJumpNoResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '記録なし';
	@override late final _TranslationsD05DateJumpNoResultButtonsJaJp buttons = _TranslationsD05DateJumpNoResultButtonsJaJp._(_root);
	@override String get content => 'この日付の記録は見つかりませんでした。追加しますか？';
}

// Path: D06_settlement_confirm
class _TranslationsD06SettlementConfirmJaJp extends TranslationsD06SettlementConfirmZhTw {
	_TranslationsD06SettlementConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '清算の確認';
	@override String get warning_text => '清算を行うとタスクはロックされ、記録の追加・削除・編集ができなくなります。\nすべての内容が正しいことを確認してください。';
	@override late final _TranslationsD06SettlementConfirmButtonsJaJp buttons = _TranslationsD06SettlementConfirmButtonsJaJp._(_root);
}

// Path: D08_TaskClosed_Confirm
class _TranslationsD08TaskClosedConfirmJaJp extends TranslationsD08TaskClosedConfirmZhTw {
	_TranslationsD08TaskClosedConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク終了確認';
	@override late final _TranslationsD08TaskClosedConfirmButtonsJaJp buttons = _TranslationsD08TaskClosedConfirmButtonsJaJp._(_root);
	@override String get content => 'この操作は取り消すことができません。すべてのデータは永久にロックされます。\n\n続行してもよろしいですか？';
}

// Path: D09_TaskSettings_CurrencyConfirm
class _TranslationsD09TaskSettingsCurrencyConfirmJaJp extends TranslationsD09TaskSettingsCurrencyConfirmZhTw {
	_TranslationsD09TaskSettingsCurrencyConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '決済通貨を変更しますか？';
	@override String get content => '通貨を変更すると、すべての為替レート設定がリセットされます。現在の収支に影響する可能性があります。よろしいですか？';
}

// Path: D10_RecordDelete_Confirm
class _TranslationsD10RecordDeleteConfirmJaJp extends TranslationsD10RecordDeleteConfirmZhTw {
	_TranslationsD10RecordDeleteConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get delete_record_title => '記録を削除？';
	@override String delete_record_content({required Object title, required Object amount}) => '${title} (${amount}) を削除してもよろしいですか？';
	@override String get deleted_success => '記録を削除しました';
}

// Path: D11_random_result
class _TranslationsD11RandomResultJaJp extends TranslationsD11RandomResultZhTw {
	_TranslationsD11RandomResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '残額ルーレット当選者';
	@override String get skip => 'スキップ';
	@override String get winner_reveal => 'あなたです！';
	@override late final _TranslationsD11RandomResultButtonsJaJp buttons = _TranslationsD11RandomResultButtonsJaJp._(_root);
}

// Path: B02_SplitExpense_Edit
class _TranslationsB02SplitExpenseEditJaJp extends TranslationsB02SplitExpenseEditZhTw {
	_TranslationsB02SplitExpenseEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '明細編集';
	@override late final _TranslationsB02SplitExpenseEditButtonsJaJp buttons = _TranslationsB02SplitExpenseEditButtonsJaJp._(_root);
	@override String get name_label => '項目名';
	@override String get amount_label => '金額';
	@override String get split_button_prefix => '負担設定';
	@override String get hint_memo => 'メモ';
	@override String get section_members => 'メンバー配分';
	@override String label_remainder({required Object amount}) => '残り: ${amount}';
	@override String label_total({required Object current, required Object target}) => '合計: ${current}/${target}';
	@override String get error_total_mismatch => '合計金額が一致しません';
	@override String get error_percent_mismatch => '合計は100%である必要があります';
	@override String get hint_amount => '金額';
	@override String get hint_percent => '%';
}

// Path: B03_SplitMethod_Edit
class _TranslationsB03SplitMethodEditJaJp extends TranslationsB03SplitMethodEditZhTw {
	_TranslationsB03SplitMethodEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '割り勘方法を選択';
	@override late final _TranslationsB03SplitMethodEditButtonsJaJp buttons = _TranslationsB03SplitMethodEditButtonsJaJp._(_root);
	@override String get method_even => '均等分攤';
	@override String get method_percent => '割合分攤';
	@override String get method_exact => '金額指定';
	@override String get desc_even => '選択したメンバーで均等割';
	@override String get desc_percent => 'パーセンテージで配分';
	@override String get desc_exact => '金額を手動で入力';
	@override String get label_weight => '比例';
	@override String get error_total_mismatch => '一致しません';
}

// Path: B04_payment_merge
class _TranslationsB04PaymentMergeJaJp extends TranslationsB04PaymentMergeZhTw {
	_TranslationsB04PaymentMergeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'メンバー支払いの統合';
	@override String get description => 'メンバーを代表者の下に統合します。支払いと返金が合算され、代表者とのやり取りだけで済みます。';
	@override String get section_head => '代表メンバー';
	@override String get section_candidates => '統合するメンバーを選択';
	@override String get status_payable => '支払';
	@override String get status_receivable => '受取';
	@override late final _TranslationsB04PaymentMergeButtonsJaJp buttons = _TranslationsB04PaymentMergeButtonsJaJp._(_root);
}

// Path: B06_payment_info_detail
class _TranslationsB06PaymentInfoDetailJaJp extends TranslationsB06PaymentInfoDetailZhTw {
	_TranslationsB06PaymentInfoDetailJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get label_copied => 'コピーしました';
	@override late final _TranslationsB06PaymentInfoDetailButtonsJaJp buttons = _TranslationsB06PaymentInfoDetailButtonsJaJp._(_root);
}

// Path: B07_PaymentMethod_Edit
class _TranslationsB07PaymentMethodEditJaJp extends TranslationsB07PaymentMethodEditZhTw {
	_TranslationsB07PaymentMethodEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '資金源を選択';
	@override String get type_member => 'メンバー立替';
	@override String get type_prepay => '公費払い';
	@override String get type_mixed => '混合支払';
	@override String prepay_balance({required Object amount}) => '公費残高: ${amount}';
	@override String get err_balance_not_enough => '残高不足';
	@override String get section_payer => '支払者';
	@override String get label_amount => '支払金額';
	@override String get total_label => '合計金額';
	@override String get total_prepay => '公費払い';
	@override String get total_advance => '立替合計';
	@override String get status_balanced => '一致';
	@override String status_remaining({required Object amount}) => '残り: ${amount}';
	@override String get msg_auto_fill_prepay => '公費残高を自動入力しました';
}

// Path: error
class _TranslationsErrorJaJp extends TranslationsErrorZhTw {
	_TranslationsErrorJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorTaskFullJaJp taskFull = _TranslationsErrorTaskFullJaJp._(_root);
	@override late final _TranslationsErrorExpiredCodeJaJp expiredCode = _TranslationsErrorExpiredCodeJaJp._(_root);
	@override late final _TranslationsErrorInvalidCodeJaJp invalidCode = _TranslationsErrorInvalidCodeJaJp._(_root);
	@override late final _TranslationsErrorAuthRequiredJaJp authRequired = _TranslationsErrorAuthRequiredJaJp._(_root);
	@override late final _TranslationsErrorAlreadyInTaskJaJp alreadyInTask = _TranslationsErrorAlreadyInTaskJaJp._(_root);
	@override late final _TranslationsErrorUnknownJaJp unknown = _TranslationsErrorUnknownJaJp._(_root);
	@override late final _TranslationsErrorSettlementJaJp settlement = _TranslationsErrorSettlementJaJp._(_root);
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
	@override String get discard => '破棄';
	@override String get keep_editing => '編集を続ける';
	@override String get refresh => '更新';
	@override String get ok => 'OK';
}

// Path: common.error
class _TranslationsCommonErrorJaJp extends TranslationsCommonErrorZhTw {
	_TranslationsCommonErrorJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'エラー';
	@override String unknown({required Object error}) => '不明なエラー: ${error}';
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

// Path: common.remainder_rule
class _TranslationsCommonRemainderRuleJaJp extends TranslationsCommonRemainderRuleZhTw {
	_TranslationsCommonRemainderRuleJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '端数処理';
	@override String get rule_random => 'ランダム';
	@override String get rule_order => '順番';
	@override String get rule_member => '指定';
}

// Path: common.payment_info
class _TranslationsCommonPaymentInfoJaJp extends TranslationsCommonPaymentInfoZhTw {
	_TranslationsCommonPaymentInfoJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get method_label => '受取方法';
	@override String get mode_private => '直接連絡してもらう';
	@override String get mode_private_desc => '詳細情報は表示せず、メンバーが直接あなたに連絡します';
	@override String get mode_public => '受取情報を提供する';
	@override String get mode_public_desc => '銀行口座情報または支払いリンクを表示します';
	@override String get type_cash => '現金';
	@override String get type_bank => '銀行振込';
	@override String get type_apps => 'その他の支払いアプリ';
	@override String get bank_name_hint => '銀行コード / 銀行名';
	@override String get bank_account_hint => '口座番号';
	@override String get app_name => 'アプリ名（例：LinePay）';
	@override String get app_link => 'リンク / ID';
}

// Path: common.share
class _TranslationsCommonShareJaJp extends TranslationsCommonShareZhTw {
	_TranslationsCommonShareJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonShareInviteJaJp invite = _TranslationsCommonShareInviteJaJp._(_root);
	@override late final _TranslationsCommonShareSettlementJaJp settlement = _TranslationsCommonShareSettlementJaJp._(_root);
}

// Path: S50_Onboarding_Consent.buttons
class _TranslationsS50OnboardingConsentButtonsJaJp extends TranslationsS50OnboardingConsentButtonsZhTw {
	_TranslationsS50OnboardingConsentButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get agree => 'はじめる';
}

// Path: S51_Onboarding_Name.buttons
class _TranslationsS51OnboardingNameButtonsJaJp extends TranslationsS51OnboardingNameButtonsZhTw {
	_TranslationsS51OnboardingNameButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get next => '設定';
}

// Path: S11_Invite_Confirm.buttons
class _TranslationsS11InviteConfirmButtonsJaJp extends TranslationsS11InviteConfirmButtonsZhTw {
	_TranslationsS11InviteConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get confirm => '参加';
	@override String get cancel => 'キャンセル';
	@override String get home => 'ホームへ';
}

// Path: S12_TaskClose_Notice.buttons
class _TranslationsS12TaskCloseNoticeButtonsJaJp extends TranslationsS12TaskCloseNoticeButtonsZhTw {
	_TranslationsS12TaskCloseNoticeButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get close => 'タスク終了';
}

// Path: S13_Task_Dashboard.buttons
class _TranslationsS13TaskDashboardButtonsJaJp extends TranslationsS13TaskDashboardButtonsZhTw {
	_TranslationsS13TaskDashboardButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get record => '記録';
	@override String get settlement => '精算';
}

// Path: S15_Record_Edit.buttons
class _TranslationsS15RecordEditButtonsJaJp extends TranslationsS15RecordEditButtonsZhTw {
	_TranslationsS15RecordEditButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get save => '保存';
	@override String get close => '閉じる';
}

// Path: S16_TaskCreate_Edit.buttons
class _TranslationsS16TaskCreateEditButtonsJaJp extends TranslationsS16TaskCreateEditButtonsZhTw {
	_TranslationsS16TaskCreateEditButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get save => '保存';
	@override String get done => '完了';
}

// Path: S17_Task_Locked.buttons
class _TranslationsS17TaskLockedButtonsJaJp extends TranslationsS17TaskLockedButtonsZhTw {
	_TranslationsS17TaskLockedButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get download => '記録をダウンロード';
	@override String get notify_members => 'メンバーに通知';
	@override String get view_payment_details => '支払/受取口座を確認';
}

// Path: S30_settlement_confirm.buttons
class _TranslationsS30SettlementConfirmButtonsJaJp extends TranslationsS30SettlementConfirmButtonsZhTw {
	_TranslationsS30SettlementConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get next => '受取設定';
}

// Path: S30_settlement_confirm.steps
class _TranslationsS30SettlementConfirmStepsJaJp extends TranslationsS30SettlementConfirmStepsZhTw {
	_TranslationsS30SettlementConfirmStepsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get confirm_amount => '金額確認';
	@override String get payment_info => '受取設定';
}

// Path: S30_settlement_confirm.warning
class _TranslationsS30SettlementConfirmWarningJaJp extends TranslationsS30SettlementConfirmWarningZhTw {
	_TranslationsS30SettlementConfirmWarningJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get random_reveal => '端数は決済確定後に公開されます！';
}

// Path: S30_settlement_confirm.list_item
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

// Path: S31_settlement_payment_info.buttons
class _TranslationsS31SettlementPaymentInfoButtonsJaJp extends TranslationsS31SettlementPaymentInfoButtonsZhTw {
	_TranslationsS31SettlementPaymentInfoButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get settle => '精算する';
	@override String get prev_step => '前のステップに戻る';
}

// Path: S32_settlement_result.buttons
class _TranslationsS32SettlementResultButtonsJaJp extends TranslationsS32SettlementResultButtonsZhTw {
	_TranslationsS32SettlementResultButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get share => '精算通知を送信';
	@override String get back => 'タスクに戻る';
}

// Path: S52_TaskSettings_Log.buttons
class _TranslationsS52TaskSettingsLogButtonsJaJp extends TranslationsS52TaskSettingsLogButtonsZhTw {
	_TranslationsS52TaskSettingsLogButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get export_csv => 'CSVエクスポート';
}

// Path: S52_TaskSettings_Log.csv_header
class _TranslationsS52TaskSettingsLogCsvHeaderJaJp extends TranslationsS52TaskSettingsLogCsvHeaderZhTw {
	_TranslationsS52TaskSettingsLogCsvHeaderJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get time => '日時';
	@override String get user => '操作者';
	@override String get action => '操作';
	@override String get details => '詳細';
}

// Path: S53_TaskSettings_Members.buttons
class _TranslationsS53TaskSettingsMembersButtonsJaJp extends TranslationsS53TaskSettingsMembersButtonsZhTw {
	_TranslationsS53TaskSettingsMembersButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get add => 'メンバー追加';
	@override String get invite => '招待送信';
}

// Path: D01_MemberRole_Intro.buttons
class _TranslationsD01MemberRoleIntroButtonsJaJp extends TranslationsD01MemberRoleIntroButtonsZhTw {
	_TranslationsD01MemberRoleIntroButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get reroll => '動物を変える';
	@override String get enter => 'タスクへ進む';
}

// Path: D02_Invite_Result.buttons
class _TranslationsD02InviteResultButtonsJaJp extends TranslationsD02InviteResultButtonsZhTw {
	_TranslationsD02InviteResultButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get back => 'ホームへ戻る';
}

// Path: D03_TaskCreate_Confirm.buttons
class _TranslationsD03TaskCreateConfirmButtonsJaJp extends TranslationsD03TaskCreateConfirmButtonsZhTw {
	_TranslationsD03TaskCreateConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get confirm => '確認';
	@override String get back => '編集に戻る';
}

// Path: D05_DateJump_NoResult.buttons
class _TranslationsD05DateJumpNoResultButtonsJaJp extends TranslationsD05DateJumpNoResultButtonsZhTw {
	_TranslationsD05DateJumpNoResultButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get cancel => '戻る';
	@override String get add => '記録を追加';
}

// Path: D06_settlement_confirm.buttons
class _TranslationsD06SettlementConfirmButtonsJaJp extends TranslationsD06SettlementConfirmButtonsZhTw {
	_TranslationsD06SettlementConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get confirm => '清算する';
}

// Path: D08_TaskClosed_Confirm.buttons
class _TranslationsD08TaskClosedConfirmButtonsJaJp extends TranslationsD08TaskClosedConfirmButtonsZhTw {
	_TranslationsD08TaskClosedConfirmButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get confirm => '確認';
}

// Path: D11_random_result.buttons
class _TranslationsD11RandomResultButtonsJaJp extends TranslationsD11RandomResultButtonsZhTw {
	_TranslationsD11RandomResultButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get close => 'OK';
}

// Path: B02_SplitExpense_Edit.buttons
class _TranslationsB02SplitExpenseEditButtonsJaJp extends TranslationsB02SplitExpenseEditButtonsZhTw {
	_TranslationsB02SplitExpenseEditButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get save => '決定';
}

// Path: B03_SplitMethod_Edit.buttons
class _TranslationsB03SplitMethodEditButtonsJaJp extends TranslationsB03SplitMethodEditButtonsZhTw {
	_TranslationsB03SplitMethodEditButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get adjust_weight => '比率を調整';
}

// Path: B04_payment_merge.buttons
class _TranslationsB04PaymentMergeButtonsJaJp extends TranslationsB04PaymentMergeButtonsZhTw {
	_TranslationsB04PaymentMergeButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get confirm => '統合';
}

// Path: B06_payment_info_detail.buttons
class _TranslationsB06PaymentInfoDetailButtonsJaJp extends TranslationsB06PaymentInfoDetailButtonsZhTw {
	_TranslationsB06PaymentInfoDetailButtonsJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get copy => 'コピー';
}

// Path: error.taskFull
class _TranslationsErrorTaskFullJaJp extends TranslationsErrorTaskFullZhTw {
	_TranslationsErrorTaskFullJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク満員';
	@override String message({required Object limit}) => 'メンバー数が上限 ${limit} 人に達しています。隊長に連絡してください。';
}

// Path: error.expiredCode
class _TranslationsErrorExpiredCodeJaJp extends TranslationsErrorExpiredCodeZhTw {
	_TranslationsErrorExpiredCodeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '招待コード期限切れ';
	@override String message({required Object minutes}) => 'この招待リンクは無効です（期限 ${minutes} 分）。隊長に再発行を依頼してください。';
}

// Path: error.invalidCode
class _TranslationsErrorInvalidCodeJaJp extends TranslationsErrorInvalidCodeZhTw {
	_TranslationsErrorInvalidCodeJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invalid Link';
	@override String get message => '無効な招待リンクです。';
}

// Path: error.authRequired
class _TranslationsErrorAuthRequiredJaJp extends TranslationsErrorAuthRequiredZhTw {
	_TranslationsErrorAuthRequiredJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログインが必要';
	@override String get message => 'タスクに参加するにはログインしてください。';
}

// Path: error.alreadyInTask
class _TranslationsErrorAlreadyInTaskJaJp extends TranslationsErrorAlreadyInTaskZhTw {
	_TranslationsErrorAlreadyInTaskJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '既に参加済';
	@override String get message => '既にこのタスクのメンバーです。';
}

// Path: error.unknown
class _TranslationsErrorUnknownJaJp extends TranslationsErrorUnknownZhTw {
	_TranslationsErrorUnknownJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'エラー';
	@override String get message => '予期せぬエラーが発生しました。';
}

// Path: error.settlement
class _TranslationsErrorSettlementJaJp extends TranslationsErrorSettlementZhTw {
	_TranslationsErrorSettlementJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorSettlementDataConflictJaJp data_conflict = _TranslationsErrorSettlementDataConflictJaJp._(_root);
	@override String get status_invalid => 'タスクの状態が無効です（既に精算済みの可能性があります）。更新してください。';
	@override String get permission_denied => '精算を実行できるのは作成者のみです。';
	@override String get transaction_failed => 'システムエラーが発生しました。後でもう一度お試しください。';
}

// Path: common.share.invite
class _TranslationsCommonShareInviteJaJp extends TranslationsCommonShareInviteZhTw {
	_TranslationsCommonShareInviteJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get subject => 'Iron Split タスク招待';
	@override String message({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「${taskName}」に参加しよう！\n招待コード：${code}\n連結：${link}';
}

// Path: common.share.settlement
class _TranslationsCommonShareSettlementJaJp extends TranslationsCommonShareSettlementZhTw {
	_TranslationsCommonShareSettlementJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get subject => 'Iron Split タスク精算通知';
	@override String message({required Object taskName, required Object link}) => '精算が完了しました！\nIton Splitアプリを開いて「${taskName}」支払い金額をご確認ください。\nリンク：${link}';
}

// Path: error.settlement.data_conflict
class _TranslationsErrorSettlementDataConflictJaJp extends TranslationsErrorSettlementDataConflictZhTw {
	_TranslationsErrorSettlementDataConflictJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'データ更新あり';
	@override String get message => '閲覧中に他のメンバーが記録を更新しました。正確性を保つため、前のページに戻って更新してください。';
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
			'common.buttons.discard' => '破棄',
			'common.buttons.keep_editing' => '編集を続ける',
			'common.buttons.refresh' => '更新',
			'common.buttons.ok' => 'OK',
			'common.error.title' => 'エラー',
			'common.error.unknown' => ({required Object error}) => '不明なエラー: ${error}',
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
			'common.remainder_rule.title' => '端数処理',
			'common.remainder_rule.rule_random' => 'ランダム',
			'common.remainder_rule.rule_order' => '順番',
			'common.remainder_rule.rule_member' => '指定',
			'common.payment_info.method_label' => '受取方法',
			'common.payment_info.mode_private' => '直接連絡してもらう',
			'common.payment_info.mode_private_desc' => '詳細情報は表示せず、メンバーが直接あなたに連絡します',
			'common.payment_info.mode_public' => '受取情報を提供する',
			'common.payment_info.mode_public_desc' => '銀行口座情報または支払いリンクを表示します',
			'common.payment_info.type_cash' => '現金',
			'common.payment_info.type_bank' => '銀行振込',
			'common.payment_info.type_apps' => 'その他の支払いアプリ',
			'common.payment_info.bank_name_hint' => '銀行コード / 銀行名',
			'common.payment_info.bank_account_hint' => '口座番号',
			'common.payment_info.app_name' => 'アプリ名（例：LinePay）',
			'common.payment_info.app_link' => 'リンク / ID',
			'common.share.invite.subject' => 'Iron Split タスク招待',
			'common.share.invite.message' => ({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「${taskName}」に参加しよう！\n招待コード：${code}\n連結：${link}',
			'common.share.settlement.subject' => 'Iron Split タスク精算通知',
			'common.share.settlement.message' => ({required Object taskName, required Object link}) => '精算が完了しました！\nIton Splitアプリを開いて「${taskName}」支払い金額をご確認ください。\nリンク：${link}',
			'common.error_prefix' => ({required Object message}) => 'エラー: ${message}',
			'common.please_login' => 'ログインしてください',
			'common.loading' => '読み込み中...',
			'common.me' => '自分',
			'common.required' => '必須',
			'common.member_prefix' => 'メンバー',
			'common.no_record' => '記録なし',
			'common.today' => '今日',
			'common.untitled' => '無題',
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
			'dialog.unsaved_changes_title' => '未保存の変更',
			'dialog.unsaved_changes_content' => '変更内容は保存されません。',
			'S50_Onboarding_Consent.title' => 'Iron Split へようこそ',
			'S50_Onboarding_Consent.buttons.agree' => 'はじめる',
			'S50_Onboarding_Consent.content_prefix' => '開始することで、',
			'S50_Onboarding_Consent.terms_link' => '利用規約',
			'S50_Onboarding_Consent.and' => ' と ',
			'S50_Onboarding_Consent.privacy_link' => 'プライバシーポリシー',
			'S50_Onboarding_Consent.content_suffix' => ' に同意したものとみなされます。',
			'S50_Onboarding_Consent.login_failed' => ({required Object message}) => 'ログイン失敗: ${message}',
			'S51_Onboarding_Name.title' => '名前設定',
			'S51_Onboarding_Name.buttons.next' => '設定',
			'S51_Onboarding_Name.description' => 'アプリ内で表示する名前を入力してください（1-10文字）。',
			'S51_Onboarding_Name.field_hint' => 'ニックネームを入力',
			'S51_Onboarding_Name.field_counter' => ({required Object current}) => '${current}/10',
			'S51_Onboarding_Name.error_empty' => '名前を入力してください',
			'S51_Onboarding_Name.error_too_long' => '10文字以内で入力してください',
			'S51_Onboarding_Name.error_invalid_char' => '無効な文字が含まれています',
			'S10_Home_TaskList.title' => 'マイタスク',
			'S10_Home_TaskList.tab_in_progress' => '進行中',
			'S10_Home_TaskList.tab_completed' => '完了済',
			'S10_Home_TaskList.mascot_preparing' => '鉄の雄鶏、準備中...',
			'S10_Home_TaskList.empty_in_progress' => '進行中のタスクはありません',
			'S10_Home_TaskList.empty_completed' => '完了したタスクはありません',
			'S10_Home_TaskList.date_tbd' => '日付未定',
			'S10_Home_TaskList.delete_confirm_title' => '削除の確認',
			'S10_Home_TaskList.delete_confirm_content' => 'このタスクを削除してもよろしいですか？',
			'S10_Home_TaskList.label_settlement' => '精算済み',
			'S11_Invite_Confirm.title' => 'タスクに参加',
			'S11_Invite_Confirm.subtitle' => '以下のタスクに招待されました：',
			'S11_Invite_Confirm.buttons.confirm' => '参加',
			'S11_Invite_Confirm.buttons.cancel' => 'キャンセル',
			'S11_Invite_Confirm.buttons.home' => 'ホームへ',
			'S11_Invite_Confirm.loading_invite' => '招待状を読み込み中...',
			'S11_Invite_Confirm.join_failed_title' => 'タスクに参加できません',
			'S11_Invite_Confirm.identity_match_title' => 'あなたは以下のメンバーですか？',
			'S11_Invite_Confirm.identity_match_desc' => 'このタスクには事前に作成されたメンバーがいます。もしあなたがいれば、名前を選択してアカウントを連携してください。そうでなければ、新規に参加してください。',
			'S11_Invite_Confirm.status_linking' => '「アカウント連携」で参加します',
			'S11_Invite_Confirm.status_new_member' => '「新規メンバー」として参加します',
			'S11_Invite_Confirm.error_join_failed' => ({required Object message}) => '参加失敗: ${message}',
			'S11_Invite_Confirm.error_generic' => ({required Object message}) => 'エラー: ${message}',
			'S11_Invite_Confirm.label_select_ghost' => '引き継ぐメンバーを選択',
			'S11_Invite_Confirm.label_prepaid' => '立替',
			'S11_Invite_Confirm.label_expense' => '支出',
			'S12_TaskClose_Notice.title' => 'タスク終了',
			'S12_TaskClose_Notice.buttons.close' => 'タスク終了',
			'S12_TaskClose_Notice.content' => 'このタスクをクローズすると、すべての記録および設定がロックされます。読み取り専用モードに移行し、データの追加や編集はできなくなります。',
			'S13_Task_Dashboard.title_active' => 'ダッシュボード',
			'S13_Task_Dashboard.buttons.record' => '記録',
			'S13_Task_Dashboard.buttons.settlement' => '精算',
			'S13_Task_Dashboard.tab_group' => 'グループ',
			'S13_Task_Dashboard.tab_personal' => '個人',
			'S13_Task_Dashboard.label_prepay_balance' => 'プール残高',
			'S13_Task_Dashboard.label_my_balance' => '私の収支',
			'S13_Task_Dashboard.label_remainder' => ({required Object amount}) => '端数: ${amount}',
			'S13_Task_Dashboard.label_balance' => '残高',
			'S13_Task_Dashboard.label_total_expense' => '総費用',
			'S13_Task_Dashboard.label_total_prepay' => '総預り金',
			'S13_Task_Dashboard.label_remainder_pot' => '端数ポット',
			'S13_Task_Dashboard.empty_records' => '記録がありません',
			'S13_Task_Dashboard.nav_to_record' => '記録ページへ移動します...',
			'S13_Task_Dashboard.daily_expense_label' => '支出',
			'S13_Task_Dashboard.dialog_balance_detail' => '通貨別内訳',
			'S13_Task_Dashboard.section_expense' => '支払い通貨',
			'S13_Task_Dashboard.section_income' => '預り金通貨',
			'S13_Task_Dashboard.daily_stats_title' => '本日の支出',
			'S13_Task_Dashboard.personal_daily_total' => '本日の個人支出',
			'S13_Task_Dashboard.personal_to_receive' => '受取',
			'S13_Task_Dashboard.personal_to_pay' => '支払',
			'S13_Task_Dashboard.personal_empty_desc' => 'この日のあなたに関連する記録はありません',
			'S13_Task_Dashboard.total_amount_label' => '合計金額',
			'S14_Task_Settings.title' => 'タスク設定',
			'S14_Task_Settings.menu_member_settings' => 'メンバー設定',
			'S14_Task_Settings.menu_history' => '履歴',
			'S14_Task_Settings.menu_end_task' => 'タスク終了',
			'S14_Task_Settings.section_remainder' => '残高',
			'S15_Record_Edit.title_create' => '記録を追加',
			'S15_Record_Edit.title_edit' => '記録を編集',
			'S15_Record_Edit.buttons.save' => '保存',
			'S15_Record_Edit.buttons.close' => '閉じる',
			'S15_Record_Edit.section_split' => '割り勘情報',
			'S15_Record_Edit.label_date' => '日付',
			'S15_Record_Edit.label_title' => '項目名',
			'S15_Record_Edit.hint_title' => '何に使いましたか？',
			'S15_Record_Edit.label_payment_method' => '支払方法',
			'S15_Record_Edit.val_prepay' => '前受金 (Prepay)',
			'S15_Record_Edit.val_member_paid' => ({required Object name}) => '${name} が立替',
			'S15_Record_Edit.label_amount' => '金額',
			'S15_Record_Edit.label_rate' => ({required Object base, required Object target}) => 'レート (1 ${base} = ? ${target})',
			'S15_Record_Edit.label_memo' => 'メモ',
			'S15_Record_Edit.hint_memo' => '備考を入力...',
			'S15_Record_Edit.val_split_details' => '詳細を編集',
			'S15_Record_Edit.val_split_summary' => ({required Object amount, required Object method}) => '計 ${amount} を${method}で割り勘',
			'S15_Record_Edit.info_rate_source' => 'レートの提供元',
			'S15_Record_Edit.msg_rate_source' => '為替レートはOpen Exchange Rates (無料版) を参照しています。正確なレートは両替レシート等をご確認ください。',
			'S15_Record_Edit.val_converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			'S15_Record_Edit.val_split_remaining' => '残り金額',
			'S15_Record_Edit.err_amount_not_enough' => '残り金額不足',
			'S15_Record_Edit.val_mock_note' => '項目メモ',
			'S15_Record_Edit.tab_expense' => '支出',
			'S15_Record_Edit.tab_income' => '受取',
			'S15_Record_Edit.msg_income_developing' => '受取機能は開発中です...',
			'S15_Record_Edit.msg_not_implemented' => 'この機能はまだ実装されていません',
			'S15_Record_Edit.err_input_amount' => '先に金額を入力してください',
			'S15_Record_Edit.section_items' => '詳細内訳',
			'S15_Record_Edit.add_item' => '明細追加',
			'S15_Record_Edit.base_card_title' => '残額 (Base)',
			'S15_Record_Edit.type_income_title' => '預り金',
			'S15_Record_Edit.base_card_title_expense' => '残額 (Base)',
			'S15_Record_Edit.base_card_title_income' => '資金提供者',
			'S15_Record_Edit.payer_multiple' => '複数人',
			'S15_Record_Edit.msg_leftover_pot' => ({required Object amount}) => '残り ${amount} は残高罐に保存されます（決算時に分配）',
			'S16_TaskCreate_Edit.title' => 'タスク作成',
			'S16_TaskCreate_Edit.buttons.save' => '保存',
			'S16_TaskCreate_Edit.buttons.done' => '完了',
			'S16_TaskCreate_Edit.section_name' => 'タスク名',
			'S16_TaskCreate_Edit.section_period' => '期間',
			'S16_TaskCreate_Edit.section_settings' => '設定',
			'S16_TaskCreate_Edit.field_name_hint' => '例：東京5日間の旅',
			'S16_TaskCreate_Edit.field_name_counter' => ({required Object current}) => '${current}/20',
			'S16_TaskCreate_Edit.field_start_date' => '開始日',
			'S16_TaskCreate_Edit.field_end_date' => '終了日',
			'S16_TaskCreate_Edit.field_currency' => '通貨',
			'S16_TaskCreate_Edit.field_member_count' => '参加人数',
			'S16_TaskCreate_Edit.error_name_empty' => 'タスク名を入力してください',
			'S16_TaskCreate_Edit.label_name' => 'タスク名',
			'S16_TaskCreate_Edit.label_date' => '日付',
			'S16_TaskCreate_Edit.label_currency' => '通貨',
			'S17_Task_Locked.buttons.download' => '記録をダウンロード',
			'S17_Task_Locked.buttons.notify_members' => 'メンバーに通知',
			'S17_Task_Locked.buttons.view_payment_details' => '支払/受取口座を確認',
			'S17_Task_Locked.retention_notice' => ({required Object days}) => '${days} 日後にデータは自動削除されます。期間内にダウンロードしてください。',
			'S17_Task_Locked.label_remainder_absorbed_by' => ({required Object name}) => 'は ${name} が負担',
			'S17_Task_Locked.section_pending' => '未完了',
			'S17_Task_Locked.section_cleared' => '完了',
			'S17_Task_Locked.member_payment_status_pay' => '支払',
			'S17_Task_Locked.member_payment_status_receive' => '受取',
			'S17_Task_Locked.dialog_mark_cleared_title' => '完了確認',
			'S17_Task_Locked.dialog_mark_cleared_content' => ({required Object name}) => '${name} を完了としてマークしますか？',
			'S30_settlement_confirm.title' => '精算確認',
			'S30_settlement_confirm.buttons.next' => '受取設定',
			'S30_settlement_confirm.steps.confirm_amount' => '金額確認',
			'S30_settlement_confirm.steps.payment_info' => '受取設定',
			'S30_settlement_confirm.warning.random_reveal' => '端数は決済確定後に公開されます！',
			'S30_settlement_confirm.label_payable' => '支払',
			'S30_settlement_confirm.label_refund' => '返金',
			'S30_settlement_confirm.list_item.merged_label' => '代表メンバー',
			'S30_settlement_confirm.list_item.includes' => '内訳：',
			'S30_settlement_confirm.list_item.principal' => '元金',
			'S30_settlement_confirm.list_item.random_remainder' => 'ランダム端数',
			'S30_settlement_confirm.list_item.remainder' => '端数',
			'S31_settlement_payment_info.title' => '受取情報',
			'S31_settlement_payment_info.setup_instruction' => '今回の精算のみに使用されます。デフォルト情報は端末内に暗号化保存されます。',
			'S31_settlement_payment_info.sync_save' => 'デフォルトの受取情報として保存（端末内）',
			'S31_settlement_payment_info.sync_update' => '自分のデフォルト受取情報を同期更新',
			'S31_settlement_payment_info.buttons.settle' => '精算する',
			'S31_settlement_payment_info.buttons.prev_step' => '前のステップに戻る',
			'S32_settlement_result.title' => '精算完了',
			'S32_settlement_result.content' => 'すべての記録が確定しました。メンバーに結果を共有し、支払いを進めてください。',
			'S32_settlement_result.waiting_reveal' => '結果を確認中...',
			'S32_settlement_result.remainder_winner_prefix' => '残額の受取先：',
			'S32_settlement_result.remainder_winner_total' => ({required Object winnerName, required Object prefix, required Object total}) => '\$${winnerName}さんは\$${prefix} \$${total}になります。',
			'S32_settlement_result.total_label' => '今回の精算合計額',
			'S32_settlement_result.buttons.share' => '精算通知を送信',
			'S32_settlement_result.buttons.back' => 'タスクに戻る',
			'S52_TaskSettings_Log.title' => '活動履歴',
			'S52_TaskSettings_Log.buttons.export_csv' => 'CSVエクスポート',
			'S52_TaskSettings_Log.empty_log' => '活動履歴はありません',
			'S52_TaskSettings_Log.export_file_prefix' => '活動履歴',
			'S52_TaskSettings_Log.csv_header.time' => '日時',
			'S52_TaskSettings_Log.csv_header.user' => '操作者',
			'S52_TaskSettings_Log.csv_header.action' => '操作',
			'S52_TaskSettings_Log.csv_header.details' => '詳細',
			'S52_TaskSettings_Log.type_income' => '収入',
			'S52_TaskSettings_Log.type_expense' => '支出',
			'S52_TaskSettings_Log.label_payment' => '支払',
			'S52_TaskSettings_Log.payment_income' => '前受金',
			'S52_TaskSettings_Log.payment_pool' => '共益費払',
			'S52_TaskSettings_Log.payment_single_suffix' => '立替',
			'S52_TaskSettings_Log.payment_multiple' => '複数立替',
			'S52_TaskSettings_Log.unit_members' => '名',
			'S52_TaskSettings_Log.unit_items' => '項目',
			'S53_TaskSettings_Members.title' => 'メンバー管理',
			'S53_TaskSettings_Members.buttons.add' => 'メンバー追加',
			'S53_TaskSettings_Members.buttons.invite' => '招待送信',
			'S53_TaskSettings_Members.label_default_ratio' => 'デフォルト比率',
			'S53_TaskSettings_Members.dialog_delete_error_title' => 'メンバー削除エラー',
			'S53_TaskSettings_Members.dialog_delete_error_content' => 'このメンバーには、関連する記帳記録、または未精算の金額があります。該当する記録を修正または削除してから、再度お試しください。',
			'S53_TaskSettings_Members.member_default_name' => 'メンバー',
			'S53_TaskSettings_Members.member_name' => 'メンバー名',
			'S71_SystemSettings_Tos.title' => '利用規約',
			'D01_MemberRole_Intro.title' => 'あなたのキャラクター',
			'D01_MemberRole_Intro.buttons.reroll' => '動物を変える',
			'D01_MemberRole_Intro.buttons.enter' => 'タスクへ進む',
			'D01_MemberRole_Intro.desc_reroll_left' => 'あと1回変更可',
			'D01_MemberRole_Intro.desc_reroll_empty' => '変更不可',
			'D01_MemberRole_Intro.dialog_content' => 'これが今回のタスクでのあなたのアイコンです。割り勘の記録にはこの動物が表示されますよ！',
			'D02_Invite_Result.title' => '参加失敗',
			'D02_Invite_Result.buttons.back' => 'ホームへ戻る',
			'D02_Invite_Result.error_INVALID_CODE' => '招待コードが無効です。リンクが正しいか確認してください。',
			'D02_Invite_Result.error_EXPIRED_CODE' => '招待リンクの期限（15分）が切れています。リーダーに再送を依頼してください。',
			'D02_Invite_Result.error_TASK_FULL' => '定員オーバーです（上限15名）。参加できません。',
			'D02_Invite_Result.error_AUTH_REQUIRED' => '認証に失敗しました。アプリを再起動してください。',
			'D02_Invite_Result.error_UNKNOWN' => '不明なエラーが発生しました。後ほどお試しください。',
			'D03_TaskCreate_Confirm.title' => '設定の確認',
			'D03_TaskCreate_Confirm.buttons.confirm' => '確認',
			'D03_TaskCreate_Confirm.buttons.back' => '編集に戻る',
			'D03_TaskCreate_Confirm.label_name' => 'タスク名',
			'D03_TaskCreate_Confirm.label_period' => '期間',
			'D03_TaskCreate_Confirm.label_currency' => '通貨',
			'D03_TaskCreate_Confirm.label_members' => '人数',
			'D03_TaskCreate_Confirm.creating_task' => '作成中...',
			'D03_TaskCreate_Confirm.preparing_share' => '招待を準備中...',
			'D05_DateJump_NoResult.title' => '記録なし',
			'D05_DateJump_NoResult.buttons.cancel' => '戻る',
			'D05_DateJump_NoResult.buttons.add' => '記録を追加',
			'D05_DateJump_NoResult.content' => 'この日付の記録は見つかりませんでした。追加しますか？',
			'D06_settlement_confirm.title' => '清算の確認',
			'D06_settlement_confirm.warning_text' => '清算を行うとタスクはロックされ、記録の追加・削除・編集ができなくなります。\nすべての内容が正しいことを確認してください。',
			'D06_settlement_confirm.buttons.confirm' => '清算する',
			'D08_TaskClosed_Confirm.title' => 'タスク終了確認',
			'D08_TaskClosed_Confirm.buttons.confirm' => '確認',
			'D08_TaskClosed_Confirm.content' => 'この操作は取り消すことができません。すべてのデータは永久にロックされます。\n\n続行してもよろしいですか？',
			'D09_TaskSettings_CurrencyConfirm.title' => '決済通貨を変更しますか？',
			'D09_TaskSettings_CurrencyConfirm.content' => '通貨を変更すると、すべての為替レート設定がリセットされます。現在の収支に影響する可能性があります。よろしいですか？',
			'D10_RecordDelete_Confirm.delete_record_title' => '記録を削除？',
			'D10_RecordDelete_Confirm.delete_record_content' => ({required Object title, required Object amount}) => '${title} (${amount}) を削除してもよろしいですか？',
			'D10_RecordDelete_Confirm.deleted_success' => '記録を削除しました',
			'D11_random_result.title' => '残額ルーレット当選者',
			'D11_random_result.skip' => 'スキップ',
			'D11_random_result.winner_reveal' => 'あなたです！',
			'D11_random_result.buttons.close' => 'OK',
			'B02_SplitExpense_Edit.title' => '明細編集',
			'B02_SplitExpense_Edit.buttons.save' => '決定',
			'B02_SplitExpense_Edit.name_label' => '項目名',
			'B02_SplitExpense_Edit.amount_label' => '金額',
			'B02_SplitExpense_Edit.split_button_prefix' => '負担設定',
			'B02_SplitExpense_Edit.hint_memo' => 'メモ',
			'B02_SplitExpense_Edit.section_members' => 'メンバー配分',
			'B02_SplitExpense_Edit.label_remainder' => ({required Object amount}) => '残り: ${amount}',
			'B02_SplitExpense_Edit.label_total' => ({required Object current, required Object target}) => '合計: ${current}/${target}',
			'B02_SplitExpense_Edit.error_total_mismatch' => '合計金額が一致しません',
			'B02_SplitExpense_Edit.error_percent_mismatch' => '合計は100%である必要があります',
			'B02_SplitExpense_Edit.hint_amount' => '金額',
			'B02_SplitExpense_Edit.hint_percent' => '%',
			'B03_SplitMethod_Edit.title' => '割り勘方法を選択',
			'B03_SplitMethod_Edit.buttons.adjust_weight' => '比率を調整',
			'B03_SplitMethod_Edit.method_even' => '均等分攤',
			'B03_SplitMethod_Edit.method_percent' => '割合分攤',
			'B03_SplitMethod_Edit.method_exact' => '金額指定',
			'B03_SplitMethod_Edit.desc_even' => '選択したメンバーで均等割',
			'B03_SplitMethod_Edit.desc_percent' => 'パーセンテージで配分',
			'B03_SplitMethod_Edit.desc_exact' => '金額を手動で入力',
			'B03_SplitMethod_Edit.label_weight' => '比例',
			'B03_SplitMethod_Edit.error_total_mismatch' => '一致しません',
			'B04_payment_merge.title' => 'メンバー支払いの統合',
			'B04_payment_merge.description' => 'メンバーを代表者の下に統合します。支払いと返金が合算され、代表者とのやり取りだけで済みます。',
			'B04_payment_merge.section_head' => '代表メンバー',
			'B04_payment_merge.section_candidates' => '統合するメンバーを選択',
			'B04_payment_merge.status_payable' => '支払',
			'B04_payment_merge.status_receivable' => '受取',
			'B04_payment_merge.buttons.cancel' => 'キャンセル',
			'B04_payment_merge.buttons.confirm' => '統合',
			'B06_payment_info_detail.label_copied' => 'コピーしました',
			'B06_payment_info_detail.buttons.copy' => 'コピー',
			'B07_PaymentMethod_Edit.title' => '資金源を選択',
			'B07_PaymentMethod_Edit.type_member' => 'メンバー立替',
			'B07_PaymentMethod_Edit.type_prepay' => '公費払い',
			'B07_PaymentMethod_Edit.type_mixed' => '混合支払',
			'B07_PaymentMethod_Edit.prepay_balance' => ({required Object amount}) => '公費残高: ${amount}',
			'B07_PaymentMethod_Edit.err_balance_not_enough' => '残高不足',
			'B07_PaymentMethod_Edit.section_payer' => '支払者',
			'B07_PaymentMethod_Edit.label_amount' => '支払金額',
			'B07_PaymentMethod_Edit.total_label' => '合計金額',
			'B07_PaymentMethod_Edit.total_prepay' => '公費払い',
			'B07_PaymentMethod_Edit.total_advance' => '立替合計',
			'B07_PaymentMethod_Edit.status_balanced' => '一致',
			'B07_PaymentMethod_Edit.status_remaining' => ({required Object amount}) => '残り: ${amount}',
			'B07_PaymentMethod_Edit.msg_auto_fill_prepay' => '公費残高を自動入力しました',
			'error.taskFull.title' => 'タスク満員',
			'error.taskFull.message' => ({required Object limit}) => 'メンバー数が上限 ${limit} 人に達しています。隊長に連絡してください。',
			'error.expiredCode.title' => '招待コード期限切れ',
			'error.expiredCode.message' => ({required Object minutes}) => 'この招待リンクは無効です（期限 ${minutes} 分）。隊長に再発行を依頼してください。',
			'error.invalidCode.title' => 'Invalid Link',
			'error.invalidCode.message' => '無効な招待リンクです。',
			'error.authRequired.title' => 'ログインが必要',
			'error.authRequired.message' => 'タスクに参加するにはログインしてください。',
			'error.alreadyInTask.title' => '既に参加済',
			'error.alreadyInTask.message' => '既にこのタスクのメンバーです。',
			'error.unknown.title' => 'エラー',
			'error.unknown.message' => '予期せぬエラーが発生しました。',
			'error.settlement.data_conflict.title' => 'データ更新あり',
			'error.settlement.data_conflict.message' => '閲覧中に他のメンバーが記録を更新しました。正確性を保つため、前のページに戻って更新してください。',
			'error.settlement.status_invalid' => 'タスクの状態が無効です（既に精算済みの可能性があります）。更新してください。',
			'error.settlement.permission_denied' => '精算を実行できるのは作成者のみです。',
			'error.settlement.transaction_failed' => 'システムエラーが発生しました。後でもう一度お試しください。',
			_ => null,
		};
	}
}
