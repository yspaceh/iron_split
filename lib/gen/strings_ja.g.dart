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
class TranslationsJa with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCategoryJa category = _TranslationsCategoryJa._(_root);
	@override late final _TranslationsCommonJa common = _TranslationsCommonJa._(_root);
	@override late final _TranslationsDialogJa dialog = _TranslationsDialogJa._(_root);
	@override late final _TranslationsS50OnboardingConsentJa S50_Onboarding_Consent = _TranslationsS50OnboardingConsentJa._(_root);
	@override late final _TranslationsS51OnboardingNameJa S51_Onboarding_Name = _TranslationsS51OnboardingNameJa._(_root);
	@override late final _TranslationsS10HomeTaskListJa S10_Home_TaskList = _TranslationsS10HomeTaskListJa._(_root);
	@override late final _TranslationsS11InviteConfirmJa S11_Invite_Confirm = _TranslationsS11InviteConfirmJa._(_root);
	@override late final _TranslationsS13TaskDashboardJa S13_Task_Dashboard = _TranslationsS13TaskDashboardJa._(_root);
	@override late final _TranslationsS15RecordEditJa S15_Record_Edit = _TranslationsS15RecordEditJa._(_root);
	@override late final _TranslationsS16TaskCreateEditJa S16_TaskCreate_Edit = _TranslationsS16TaskCreateEditJa._(_root);
	@override late final _TranslationsS71SystemSettingsTosJa S71_SystemSettings_Tos = _TranslationsS71SystemSettingsTosJa._(_root);
	@override late final _TranslationsD01MemberRoleIntroJa D01_MemberRole_Intro = _TranslationsD01MemberRoleIntroJa._(_root);
	@override late final _TranslationsD02InviteResultJa D02_Invite_Result = _TranslationsD02InviteResultJa._(_root);
	@override late final _TranslationsD03TaskCreateConfirmJa D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmJa._(_root);
	@override late final _TranslationsD10RecordDeleteConfirmJa D10_RecordDelete_Confirm = _TranslationsD10RecordDeleteConfirmJa._(_root);
	@override late final _TranslationsB02SplitExpenseEditJa B02_SplitExpense_Edit = _TranslationsB02SplitExpenseEditJa._(_root);
	@override late final _TranslationsB03SplitMethodEditJa B03_SplitMethod_Edit = _TranslationsB03SplitMethodEditJa._(_root);
	@override late final _TranslationsB07PaymentMethodEditJa B07_PaymentMethod_Edit = _TranslationsB07PaymentMethodEditJa._(_root);
	@override late final _TranslationsErrorJa error = _TranslationsErrorJa._(_root);
}

// Path: category
class _TranslationsCategoryJa implements TranslationsCategoryZh {
	_TranslationsCategoryJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get food => '食事';
	@override String get transport => '交通';
	@override String get shopping => '買い物';
	@override String get entertainment => 'エンタメ';
	@override String get accommodation => '宿泊';
	@override String get others => 'その他';
}

// Path: common
class _TranslationsCommonJa implements TranslationsCommonZh {
	_TranslationsCommonJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'キャンセル';
	@override String get delete => '削除';
	@override String get confirm => '確認';
	@override String get back => '戻る';
	@override String get save => '保存';
	@override String error_prefix({required Object message}) => 'エラー: ${message}';
	@override String get please_login => 'ログインしてください';
	@override String get loading => '読み込み中...';
	@override String get edit => '編集';
	@override String get close => '閉じる';
	@override String get me => '自分';
	@override String get required => '必須';
	@override String get discard => '破棄';
	@override String get keep_editing => '編集を続ける';
	@override String get member_prefix => 'メンバー';
}

// Path: dialog
class _TranslationsDialogJa implements TranslationsDialogZh {
	_TranslationsDialogJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get unsaved_changes_title => '未保存の変更';
	@override String get unsaved_changes_content => '変更内容は保存されません。';
}

// Path: S50_Onboarding_Consent
class _TranslationsS50OnboardingConsentJa implements TranslationsS50OnboardingConsentZh {
	_TranslationsS50OnboardingConsentJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Iron Split へようこそ';
	@override String get content_prefix => '開始することで、';
	@override String get terms_link => '利用規約';
	@override String get and => ' と ';
	@override String get privacy_link => 'プライバシーポリシー';
	@override String get content_suffix => ' に同意したものとみなされます。';
	@override String get agree_btn => 'はじめる';
	@override String login_failed({required Object message}) => 'ログイン失敗: ${message}';
}

// Path: S51_Onboarding_Name
class _TranslationsS51OnboardingNameJa implements TranslationsS51OnboardingNameZh {
	_TranslationsS51OnboardingNameJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '名前設定';
	@override String get description => 'アプリ内で表示する名前を入力してください（1-10文字）。';
	@override String get field_hint => 'ニックネームを入力';
	@override String field_counter({required Object current}) => '${current}/10';
	@override String get error_empty => '名前を入力してください';
	@override String get error_too_long => '10文字以内で入力してください';
	@override String get error_invalid_char => '無効な文字が含まれています';
	@override String get action_next => '設定';
}

// Path: S10_Home_TaskList
class _TranslationsS10HomeTaskListJa implements TranslationsS10HomeTaskListZh {
	_TranslationsS10HomeTaskListJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

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
}

// Path: S11_Invite_Confirm
class _TranslationsS11InviteConfirmJa implements TranslationsS11InviteConfirmZh {
	_TranslationsS11InviteConfirmJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスクに参加';
	@override String get subtitle => '以下のタスクに招待されました：';
	@override String get loading_invite => '招待状を読み込み中...';
	@override String get join_failed_title => 'タスクに参加できません';
	@override String get identity_match_title => 'あなたは以下のメンバーですか？';
	@override String get identity_match_desc => 'このタスクには事前に作成されたメンバーがいます。もしあなたがいれば、名前を選択してアカウントを連携してください。そうでなければ、新規に参加してください。';
	@override String get status_linking => '「アカウント連携」で参加します';
	@override String get status_new_member => '「新規メンバー」として参加します';
	@override String get action_confirm => '参加';
	@override String get action_cancel => 'キャンセル';
	@override String get action_home => 'ホームへ';
	@override String error_join_failed({required Object message}) => '参加失敗: ${message}';
	@override String error_generic({required Object message}) => 'エラー: ${message}';
}

// Path: S13_Task_Dashboard
class _TranslationsS13TaskDashboardJa implements TranslationsS13TaskDashboardZh {
	_TranslationsS13TaskDashboardJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ダッシュボード';
	@override String get tab_group => 'グループ';
	@override String get tab_personal => '個人';
	@override String get label_prepay_balance => 'プール残高';
	@override String get label_my_balance => '私の収支';
	@override String label_remainder({required Object amount}) => '端数: ${amount}';
	@override String get fab_record => '記録';
	@override String get empty_records => '記録がありません';
	@override String get rule_random => 'ランダム';
	@override String get rule_order => '順番';
	@override String get rule_member => '指定';
	@override String get settlement_button => '精算';
	@override String get nav_to_record => '記録ページへ移動します...';
	@override String get daily_expense_label => '支出';
}

// Path: S15_Record_Edit
class _TranslationsS15RecordEditJa implements TranslationsS15RecordEditZh {
	_TranslationsS15RecordEditJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title_create => '記録を追加';
	@override String get title_edit => '記録を編集';
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
	@override String get action_save => '保存';
	@override String get val_split_details => '詳細を編集';
	@override String val_split_summary({required Object amount, required Object method}) => '計 ${amount} を${method}で割り勘';
	@override String get method_even => '均等';
	@override String get method_exact => '金額指定';
	@override String get method_percent => '割合 (%)';
	@override String get info_rate_source => 'レートの提供元';
	@override String get msg_rate_source => '為替レートはOpen Exchange Rates (無料版) を参照しています。正確なレートは両替レシート等をご確認ください。';
	@override String get btn_close => '閉じる';
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
}

// Path: S16_TaskCreate_Edit
class _TranslationsS16TaskCreateEditJa implements TranslationsS16TaskCreateEditZh {
	_TranslationsS16TaskCreateEditJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク作成';
	@override String get section_name => 'タスク名';
	@override String get section_period => '期間';
	@override String get section_settings => '設定';
	@override String get field_name_hint => '例：東京5日間の旅';
	@override String field_name_counter({required Object current}) => '${current}/20';
	@override String get field_start_date => '開始日';
	@override String get field_end_date => '終了日';
	@override String get field_currency => '通貨';
	@override String get field_member_count => '参加人数';
	@override String get action_save => '保存';
	@override String get picker_done => '完了';
	@override String get error_name_empty => 'タスク名を入力してください';
	@override String get currency_twd => '台湾ドル (TWD)';
	@override String get currency_jpy => '日本円 (JPY)';
	@override String get currency_usd => '米ドル (USD)';
}

// Path: S71_SystemSettings_Tos
class _TranslationsS71SystemSettingsTosJa implements TranslationsS71SystemSettingsTosZh {
	_TranslationsS71SystemSettingsTosJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '利用規約';
}

// Path: D01_MemberRole_Intro
class _TranslationsD01MemberRoleIntroJa implements TranslationsD01MemberRoleIntroZh {
	_TranslationsD01MemberRoleIntroJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'あなたのキャラクター';
	@override String get action_reroll => '動物を変える';
	@override String get action_enter => 'タスクへ進む';
	@override String get desc_reroll_left => 'あと1回変更可';
	@override String get desc_reroll_empty => '変更不可';
	@override String get dialog_content => 'これが今回のタスクでのあなたのアイコンです。割り勘の記録にはこの動物が表示されますよ！';
}

// Path: D02_Invite_Result
class _TranslationsD02InviteResultJa implements TranslationsD02InviteResultZh {
	_TranslationsD02InviteResultJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '参加失敗';
	@override String get action_back => 'ホームへ戻る';
	@override String get error_INVALID_CODE => '招待コードが無効です。リンクが正しいか確認してください。';
	@override String get error_EXPIRED_CODE => '招待リンクの期限（15分）が切れています。リーダーに再送を依頼してください。';
	@override String get error_TASK_FULL => '定員オーバーです（上限15名）。参加できません。';
	@override String get error_AUTH_REQUIRED => '認証に失敗しました。アプリを再起動してください。';
	@override String get error_UNKNOWN => '不明なエラーが発生しました。後ほどお試しください。';
}

// Path: D03_TaskCreate_Confirm
class _TranslationsD03TaskCreateConfirmJa implements TranslationsD03TaskCreateConfirmZh {
	_TranslationsD03TaskCreateConfirmJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '設定の確認';
	@override String get label_name => 'タスク名';
	@override String get label_period => '期間';
	@override String get label_currency => '通貨';
	@override String get label_members => '人数';
	@override String get action_confirm => '確認';
	@override String get action_back => '編集に戻る';
	@override String get creating_task => '作成中...';
	@override String get preparing_share => '招待を準備中...';
	@override String get share_subject => 'Iron Split タスク招待';
	@override String share_message({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「${taskName}」に参加しよう！\n招待コード：${code}\nリンク：${link}';
}

// Path: D10_RecordDelete_Confirm
class _TranslationsD10RecordDeleteConfirmJa implements TranslationsD10RecordDeleteConfirmZh {
	_TranslationsD10RecordDeleteConfirmJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get delete_record_title => '記録を削除？';
	@override String delete_record_content({required Object title, required Object amount}) => '${title} (${amount}) を削除してもよろしいですか？';
	@override String get deleted_success => '記録を削除しました';
}

// Path: B02_SplitExpense_Edit
class _TranslationsB02SplitExpenseEditJa implements TranslationsB02SplitExpenseEditZh {
	_TranslationsB02SplitExpenseEditJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '明細編集';
	@override String get name_label => '項目名';
	@override String get amount_label => '金額';
	@override String get split_button_prefix => '負担設定';
	@override String get hint_memo => 'メモ';
	@override String get section_members => 'メンバー配分';
	@override String label_remainder({required Object amount}) => '残り: ${amount}';
	@override String label_total({required Object current, required Object target}) => '合計: ${current}/${target}';
	@override String get error_total_mismatch => '合計金額が一致しません';
	@override String get error_percent_mismatch => '合計は100%である必要があります';
	@override String get action_save => '決定';
	@override String get hint_amount => '金額';
	@override String get hint_percent => '%';
}

// Path: B03_SplitMethod_Edit
class _TranslationsB03SplitMethodEditJa implements TranslationsB03SplitMethodEditZh {
	_TranslationsB03SplitMethodEditJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '割り勘方法を選択';
	@override String get method_even => '均等分攤';
	@override String get method_percent => '割合分攤';
	@override String get method_exact => '金額指定';
	@override String get desc_even => '選択したメンバーで均等割';
	@override String get desc_percent => 'パーセンテージで配分';
	@override String get desc_exact => '金額を手動で入力';
	@override String msg_leftover_pot({required Object amount}) => '残り ${amount} は残高罐に保存されます（決算時に分配）';
	@override String get label_weight => '比例';
	@override String error_total_mismatch({required Object diff}) => '合計金額が一致しません (差額 ${diff})';
	@override String get btn_adjust_weight => '比率を調整';
}

// Path: B07_PaymentMethod_Edit
class _TranslationsB07PaymentMethodEditJa implements TranslationsB07PaymentMethodEditZh {
	_TranslationsB07PaymentMethodEditJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

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
class _TranslationsErrorJa implements TranslationsErrorZh {
	_TranslationsErrorJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorTaskFullJa taskFull = _TranslationsErrorTaskFullJa._(_root);
	@override late final _TranslationsErrorExpiredCodeJa expiredCode = _TranslationsErrorExpiredCodeJa._(_root);
	@override late final _TranslationsErrorInvalidCodeJa invalidCode = _TranslationsErrorInvalidCodeJa._(_root);
	@override late final _TranslationsErrorAuthRequiredJa authRequired = _TranslationsErrorAuthRequiredJa._(_root);
	@override late final _TranslationsErrorAlreadyInTaskJa alreadyInTask = _TranslationsErrorAlreadyInTaskJa._(_root);
	@override late final _TranslationsErrorUnknownJa unknown = _TranslationsErrorUnknownJa._(_root);
}

// Path: error.taskFull
class _TranslationsErrorTaskFullJa implements TranslationsErrorTaskFullZh {
	_TranslationsErrorTaskFullJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク満員';
	@override String message({required Object limit}) => 'メンバー数が上限 ${limit} 人に達しています。隊長に連絡してください。';
}

// Path: error.expiredCode
class _TranslationsErrorExpiredCodeJa implements TranslationsErrorExpiredCodeZh {
	_TranslationsErrorExpiredCodeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '招待コード期限切れ';
	@override String message({required Object minutes}) => 'この招待リンクは無効です（期限 ${minutes} 分）。隊長に再発行を依頼してください。';
}

// Path: error.invalidCode
class _TranslationsErrorInvalidCodeJa implements TranslationsErrorInvalidCodeZh {
	_TranslationsErrorInvalidCodeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'リンク無効';
	@override String get message => '無効な招待リンクです。';
}

// Path: error.authRequired
class _TranslationsErrorAuthRequiredJa implements TranslationsErrorAuthRequiredZh {
	_TranslationsErrorAuthRequiredJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログインが必要';
	@override String get message => 'タスクに参加するにはログインしてください。';
}

// Path: error.alreadyInTask
class _TranslationsErrorAlreadyInTaskJa implements TranslationsErrorAlreadyInTaskZh {
	_TranslationsErrorAlreadyInTaskJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '既に参加済';
	@override String get message => '既にこのタスクのメンバーです。';
}

// Path: error.unknown
class _TranslationsErrorUnknownJa implements TranslationsErrorUnknownZh {
	_TranslationsErrorUnknownJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エラー';
	@override String get message => '予期せぬエラーが発生しました。';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'category.food' => '食事',
			'category.transport' => '交通',
			'category.shopping' => '買い物',
			'category.entertainment' => 'エンタメ',
			'category.accommodation' => '宿泊',
			'category.others' => 'その他',
			'common.cancel' => 'キャンセル',
			'common.delete' => '削除',
			'common.confirm' => '確認',
			'common.back' => '戻る',
			'common.save' => '保存',
			'common.error_prefix' => ({required Object message}) => 'エラー: ${message}',
			'common.please_login' => 'ログインしてください',
			'common.loading' => '読み込み中...',
			'common.edit' => '編集',
			'common.close' => '閉じる',
			'common.me' => '自分',
			'common.required' => '必須',
			'common.discard' => '破棄',
			'common.keep_editing' => '編集を続ける',
			'common.member_prefix' => 'メンバー',
			'dialog.unsaved_changes_title' => '未保存の変更',
			'dialog.unsaved_changes_content' => '変更内容は保存されません。',
			'S50_Onboarding_Consent.title' => 'Iron Split へようこそ',
			'S50_Onboarding_Consent.content_prefix' => '開始することで、',
			'S50_Onboarding_Consent.terms_link' => '利用規約',
			'S50_Onboarding_Consent.and' => ' と ',
			'S50_Onboarding_Consent.privacy_link' => 'プライバシーポリシー',
			'S50_Onboarding_Consent.content_suffix' => ' に同意したものとみなされます。',
			'S50_Onboarding_Consent.agree_btn' => 'はじめる',
			'S50_Onboarding_Consent.login_failed' => ({required Object message}) => 'ログイン失敗: ${message}',
			'S51_Onboarding_Name.title' => '名前設定',
			'S51_Onboarding_Name.description' => 'アプリ内で表示する名前を入力してください（1-10文字）。',
			'S51_Onboarding_Name.field_hint' => 'ニックネームを入力',
			'S51_Onboarding_Name.field_counter' => ({required Object current}) => '${current}/10',
			'S51_Onboarding_Name.error_empty' => '名前を入力してください',
			'S51_Onboarding_Name.error_too_long' => '10文字以内で入力してください',
			'S51_Onboarding_Name.error_invalid_char' => '無効な文字が含まれています',
			'S51_Onboarding_Name.action_next' => '設定',
			'S10_Home_TaskList.title' => 'マイタスク',
			'S10_Home_TaskList.tab_in_progress' => '進行中',
			'S10_Home_TaskList.tab_completed' => '完了済',
			'S10_Home_TaskList.mascot_preparing' => '鉄の雄鶏、準備中...',
			'S10_Home_TaskList.empty_in_progress' => '進行中のタスクはありません',
			'S10_Home_TaskList.empty_completed' => '完了したタスクはありません',
			'S10_Home_TaskList.date_tbd' => '日付未定',
			'S10_Home_TaskList.delete_confirm_title' => '削除の確認',
			'S10_Home_TaskList.delete_confirm_content' => 'このタスクを削除してもよろしいですか？',
			'S11_Invite_Confirm.title' => 'タスクに参加',
			'S11_Invite_Confirm.subtitle' => '以下のタスクに招待されました：',
			'S11_Invite_Confirm.loading_invite' => '招待状を読み込み中...',
			'S11_Invite_Confirm.join_failed_title' => 'タスクに参加できません',
			'S11_Invite_Confirm.identity_match_title' => 'あなたは以下のメンバーですか？',
			'S11_Invite_Confirm.identity_match_desc' => 'このタスクには事前に作成されたメンバーがいます。もしあなたがいれば、名前を選択してアカウントを連携してください。そうでなければ、新規に参加してください。',
			'S11_Invite_Confirm.status_linking' => '「アカウント連携」で参加します',
			'S11_Invite_Confirm.status_new_member' => '「新規メンバー」として参加します',
			'S11_Invite_Confirm.action_confirm' => '参加',
			'S11_Invite_Confirm.action_cancel' => 'キャンセル',
			'S11_Invite_Confirm.action_home' => 'ホームへ',
			'S11_Invite_Confirm.error_join_failed' => ({required Object message}) => '参加失敗: ${message}',
			'S11_Invite_Confirm.error_generic' => ({required Object message}) => 'エラー: ${message}',
			'S13_Task_Dashboard.title' => 'ダッシュボード',
			'S13_Task_Dashboard.tab_group' => 'グループ',
			'S13_Task_Dashboard.tab_personal' => '個人',
			'S13_Task_Dashboard.label_prepay_balance' => 'プール残高',
			'S13_Task_Dashboard.label_my_balance' => '私の収支',
			'S13_Task_Dashboard.label_remainder' => ({required Object amount}) => '端数: ${amount}',
			'S13_Task_Dashboard.fab_record' => '記録',
			'S13_Task_Dashboard.empty_records' => '記録がありません',
			'S13_Task_Dashboard.rule_random' => 'ランダム',
			'S13_Task_Dashboard.rule_order' => '順番',
			'S13_Task_Dashboard.rule_member' => '指定',
			'S13_Task_Dashboard.settlement_button' => '精算',
			'S13_Task_Dashboard.nav_to_record' => '記録ページへ移動します...',
			'S13_Task_Dashboard.daily_expense_label' => '支出',
			'S15_Record_Edit.title_create' => '記録を追加',
			'S15_Record_Edit.title_edit' => '記録を編集',
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
			'S15_Record_Edit.action_save' => '保存',
			'S15_Record_Edit.val_split_details' => '詳細を編集',
			'S15_Record_Edit.val_split_summary' => ({required Object amount, required Object method}) => '計 ${amount} を${method}で割り勘',
			'S15_Record_Edit.method_even' => '均等',
			'S15_Record_Edit.method_exact' => '金額指定',
			'S15_Record_Edit.method_percent' => '割合 (%)',
			'S15_Record_Edit.info_rate_source' => 'レートの提供元',
			'S15_Record_Edit.msg_rate_source' => '為替レートはOpen Exchange Rates (無料版) を参照しています。正確なレートは両替レシート等をご確認ください。',
			'S15_Record_Edit.btn_close' => '閉じる',
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
			'S16_TaskCreate_Edit.title' => 'タスク作成',
			'S16_TaskCreate_Edit.section_name' => 'タスク名',
			'S16_TaskCreate_Edit.section_period' => '期間',
			'S16_TaskCreate_Edit.section_settings' => '設定',
			'S16_TaskCreate_Edit.field_name_hint' => '例：東京5日間の旅',
			'S16_TaskCreate_Edit.field_name_counter' => ({required Object current}) => '${current}/20',
			'S16_TaskCreate_Edit.field_start_date' => '開始日',
			'S16_TaskCreate_Edit.field_end_date' => '終了日',
			'S16_TaskCreate_Edit.field_currency' => '通貨',
			'S16_TaskCreate_Edit.field_member_count' => '参加人数',
			'S16_TaskCreate_Edit.action_save' => '保存',
			'S16_TaskCreate_Edit.picker_done' => '完了',
			'S16_TaskCreate_Edit.error_name_empty' => 'タスク名を入力してください',
			'S16_TaskCreate_Edit.currency_twd' => '台湾ドル (TWD)',
			'S16_TaskCreate_Edit.currency_jpy' => '日本円 (JPY)',
			'S16_TaskCreate_Edit.currency_usd' => '米ドル (USD)',
			'S71_SystemSettings_Tos.title' => '利用規約',
			'D01_MemberRole_Intro.title' => 'あなたのキャラクター',
			'D01_MemberRole_Intro.action_reroll' => '動物を変える',
			'D01_MemberRole_Intro.action_enter' => 'タスクへ進む',
			'D01_MemberRole_Intro.desc_reroll_left' => 'あと1回変更可',
			'D01_MemberRole_Intro.desc_reroll_empty' => '変更不可',
			'D01_MemberRole_Intro.dialog_content' => 'これが今回のタスクでのあなたのアイコンです。割り勘の記録にはこの動物が表示されますよ！',
			'D02_Invite_Result.title' => '参加失敗',
			'D02_Invite_Result.action_back' => 'ホームへ戻る',
			'D02_Invite_Result.error_INVALID_CODE' => '招待コードが無効です。リンクが正しいか確認してください。',
			'D02_Invite_Result.error_EXPIRED_CODE' => '招待リンクの期限（15分）が切れています。リーダーに再送を依頼してください。',
			'D02_Invite_Result.error_TASK_FULL' => '定員オーバーです（上限15名）。参加できません。',
			'D02_Invite_Result.error_AUTH_REQUIRED' => '認証に失敗しました。アプリを再起動してください。',
			'D02_Invite_Result.error_UNKNOWN' => '不明なエラーが発生しました。後ほどお試しください。',
			'D03_TaskCreate_Confirm.title' => '設定の確認',
			'D03_TaskCreate_Confirm.label_name' => 'タスク名',
			'D03_TaskCreate_Confirm.label_period' => '期間',
			'D03_TaskCreate_Confirm.label_currency' => '通貨',
			'D03_TaskCreate_Confirm.label_members' => '人数',
			'D03_TaskCreate_Confirm.action_confirm' => '確認',
			'D03_TaskCreate_Confirm.action_back' => '編集に戻る',
			'D03_TaskCreate_Confirm.creating_task' => '作成中...',
			'D03_TaskCreate_Confirm.preparing_share' => '招待を準備中...',
			'D03_TaskCreate_Confirm.share_subject' => 'Iron Split タスク招待',
			'D03_TaskCreate_Confirm.share_message' => ({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「${taskName}」に参加しよう！\n招待コード：${code}\nリンク：${link}',
			'D10_RecordDelete_Confirm.delete_record_title' => '記録を削除？',
			'D10_RecordDelete_Confirm.delete_record_content' => ({required Object title, required Object amount}) => '${title} (${amount}) を削除してもよろしいですか？',
			'D10_RecordDelete_Confirm.deleted_success' => '記録を削除しました',
			'B02_SplitExpense_Edit.title' => '明細編集',
			'B02_SplitExpense_Edit.name_label' => '項目名',
			'B02_SplitExpense_Edit.amount_label' => '金額',
			'B02_SplitExpense_Edit.split_button_prefix' => '負担設定',
			'B02_SplitExpense_Edit.hint_memo' => 'メモ',
			'B02_SplitExpense_Edit.section_members' => 'メンバー配分',
			'B02_SplitExpense_Edit.label_remainder' => ({required Object amount}) => '残り: ${amount}',
			'B02_SplitExpense_Edit.label_total' => ({required Object current, required Object target}) => '合計: ${current}/${target}',
			'B02_SplitExpense_Edit.error_total_mismatch' => '合計金額が一致しません',
			'B02_SplitExpense_Edit.error_percent_mismatch' => '合計は100%である必要があります',
			'B02_SplitExpense_Edit.action_save' => '決定',
			'B02_SplitExpense_Edit.hint_amount' => '金額',
			'B02_SplitExpense_Edit.hint_percent' => '%',
			'B03_SplitMethod_Edit.title' => '割り勘方法を選択',
			'B03_SplitMethod_Edit.method_even' => '均等分攤',
			'B03_SplitMethod_Edit.method_percent' => '割合分攤',
			'B03_SplitMethod_Edit.method_exact' => '金額指定',
			'B03_SplitMethod_Edit.desc_even' => '選択したメンバーで均等割',
			'B03_SplitMethod_Edit.desc_percent' => 'パーセンテージで配分',
			'B03_SplitMethod_Edit.desc_exact' => '金額を手動で入力',
			'B03_SplitMethod_Edit.msg_leftover_pot' => ({required Object amount}) => '残り ${amount} は残高罐に保存されます（決算時に分配）',
			'B03_SplitMethod_Edit.label_weight' => '比例',
			'B03_SplitMethod_Edit.error_total_mismatch' => ({required Object diff}) => '合計金額が一致しません (差額 ${diff})',
			'B03_SplitMethod_Edit.btn_adjust_weight' => '比率を調整',
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
			'error.invalidCode.title' => 'リンク無効',
			'error.invalidCode.message' => '無効な招待リンクです。',
			'error.authRequired.title' => 'ログインが必要',
			'error.authRequired.message' => 'タスクに参加するにはログインしてください。',
			'error.alreadyInTask.title' => '既に参加済',
			'error.alreadyInTask.message' => '既にこのタスクのメンバーです。',
			'error.unknown.title' => 'エラー',
			'error.unknown.message' => '予期せぬエラーが発生しました。',
			_ => null,
		};
	}
}
