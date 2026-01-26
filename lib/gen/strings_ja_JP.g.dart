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
	@override late final _TranslationsCategoryJaJp category = _TranslationsCategoryJaJp._(_root);
	@override late final _TranslationsCommonJaJp common = _TranslationsCommonJaJp._(_root);
	@override late final _TranslationsDialogJaJp dialog = _TranslationsDialogJaJp._(_root);
	@override late final _TranslationsS50OnboardingConsentJaJp S50_Onboarding_Consent = _TranslationsS50OnboardingConsentJaJp._(_root);
	@override late final _TranslationsS51OnboardingNameJaJp S51_Onboarding_Name = _TranslationsS51OnboardingNameJaJp._(_root);
	@override late final _TranslationsS10HomeTaskListJaJp S10_Home_TaskList = _TranslationsS10HomeTaskListJaJp._(_root);
	@override late final _TranslationsS11InviteConfirmJaJp S11_Invite_Confirm = _TranslationsS11InviteConfirmJaJp._(_root);
	@override late final _TranslationsS13TaskDashboardJaJp S13_Task_Dashboard = _TranslationsS13TaskDashboardJaJp._(_root);
	@override late final _TranslationsS15RecordEditJaJp S15_Record_Edit = _TranslationsS15RecordEditJaJp._(_root);
	@override late final _TranslationsS16TaskCreateEditJaJp S16_TaskCreate_Edit = _TranslationsS16TaskCreateEditJaJp._(_root);
	@override late final _TranslationsS71SystemSettingsTosJaJp S71_SystemSettings_Tos = _TranslationsS71SystemSettingsTosJaJp._(_root);
	@override late final _TranslationsD01MemberRoleIntroJaJp D01_MemberRole_Intro = _TranslationsD01MemberRoleIntroJaJp._(_root);
	@override late final _TranslationsD02InviteResultJaJp D02_Invite_Result = _TranslationsD02InviteResultJaJp._(_root);
	@override late final _TranslationsD03TaskCreateConfirmJaJp D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmJaJp._(_root);
	@override late final _TranslationsD05DateJumpNoResultJaJp D05_DateJump_NoResult = _TranslationsD05DateJumpNoResultJaJp._(_root);
	@override late final _TranslationsD10RecordDeleteConfirmJaJp D10_RecordDelete_Confirm = _TranslationsD10RecordDeleteConfirmJaJp._(_root);
	@override late final _TranslationsB02SplitExpenseEditJaJp B02_SplitExpense_Edit = _TranslationsB02SplitExpenseEditJaJp._(_root);
	@override late final _TranslationsB03SplitMethodEditJaJp B03_SplitMethod_Edit = _TranslationsB03SplitMethodEditJaJp._(_root);
	@override late final _TranslationsB07PaymentMethodEditJaJp B07_PaymentMethod_Edit = _TranslationsB07PaymentMethodEditJaJp._(_root);
	@override late final _TranslationsErrorJaJp error = _TranslationsErrorJaJp._(_root);
}

// Path: category
class _TranslationsCategoryJaJp extends TranslationsCategoryZhTw {
	_TranslationsCategoryJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get food => '食事';
	@override String get transport => '交通';
	@override String get shopping => '買い物';
	@override String get entertainment => 'エンタメ';
	@override String get accommodation => '宿泊';
	@override String get others => 'その他';
}

// Path: common
class _TranslationsCommonJaJp extends TranslationsCommonZhTw {
	_TranslationsCommonJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

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
	@override String get no_record => '記録なし';
	@override String get today => '今日';
	@override String get untitled => '無題';
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
	@override String get content_prefix => '開始することで、';
	@override String get terms_link => '利用規約';
	@override String get and => ' と ';
	@override String get privacy_link => 'プライバシーポリシー';
	@override String get content_suffix => ' に同意したものとみなされます。';
	@override String get agree_btn => 'はじめる';
	@override String login_failed({required Object message}) => 'ログイン失敗: ${message}';
}

// Path: S51_Onboarding_Name
class _TranslationsS51OnboardingNameJaJp extends TranslationsS51OnboardingNameZhTw {
	_TranslationsS51OnboardingNameJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

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
}

// Path: S11_Invite_Confirm
class _TranslationsS11InviteConfirmJaJp extends TranslationsS11InviteConfirmZhTw {
	_TranslationsS11InviteConfirmJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

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
	@override String get label_select_ghost => '引き継ぐメンバーを選択';
	@override String get label_prepaid => '立替';
	@override String get label_expense => '支出';
}

// Path: S13_Task_Dashboard
class _TranslationsS13TaskDashboardJaJp extends TranslationsS13TaskDashboardZhTw {
	_TranslationsS13TaskDashboardJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => 'ダッシュボード';
	@override String get tab_group => 'グループ';
	@override String get tab_personal => '個人';
	@override String get label_prepay_balance => 'プール残高';
	@override String get label_my_balance => '私の収支';
	@override String label_remainder({required Object amount}) => '端数: ${amount}';
	@override String get label_balance => '残高';
	@override String get label_total_expense => '総費用';
	@override String get label_total_prepay => '総預り金';
	@override String get label_remainder_pot => '端数ポット';
	@override String get fab_record => '記録';
	@override String get empty_records => '記録がありません';
	@override String get rule_random => 'ランダム';
	@override String get rule_order => '順番';
	@override String get rule_member => '指定';
	@override String get settlement_button => '精算';
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
}

// Path: S15_Record_Edit
class _TranslationsS15RecordEditJaJp extends TranslationsS15RecordEditZhTw {
	_TranslationsS15RecordEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

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
class _TranslationsS16TaskCreateEditJaJp extends TranslationsS16TaskCreateEditZhTw {
	_TranslationsS16TaskCreateEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

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
	@override String get action_reroll => '動物を変える';
	@override String get action_enter => 'タスクへ進む';
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
	@override String get action_back => 'ホームへ戻る';
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
	@override String get label_name => 'タスク名';
	@override String get label_period => '期間';
	@override String get label_currency => '通貨';
	@override String get label_members => '人数';
	@override String get action_confirm => '確認';
	@override String get action_back => '編集に戻る';
	@override String get creating_task => '作成中...';
	@override String get preparing_share => '招待を準備中...';
	@override String get share_subject => 'Iron Split タスク招待';
	@override String share_message({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「${taskName}」に参加しよう！\n招待コード：${code}\n連結：${link}';
}

// Path: D05_DateJump_NoResult
class _TranslationsD05DateJumpNoResultJaJp extends TranslationsD05DateJumpNoResultZhTw {
	_TranslationsD05DateJumpNoResultJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

	// Translations
	@override String get title => '記録なし';
	@override String get content => 'この日付の記録は見つかりませんでした。追加しますか？';
	@override String get action_cancel => '戻る';
	@override String get action_add => '記録を追加';
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

// Path: B02_SplitExpense_Edit
class _TranslationsB02SplitExpenseEditJaJp extends TranslationsB02SplitExpenseEditZhTw {
	_TranslationsB02SplitExpenseEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

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
class _TranslationsB03SplitMethodEditJaJp extends TranslationsB03SplitMethodEditZhTw {
	_TranslationsB03SplitMethodEditJaJp._(TranslationsJaJp root) : this._root = root, super.internal(root);

	final TranslationsJaJp _root; // ignore: unused_field

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
	@override String get title => 'リンク無効';
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

/// The flat map containing all translations for locale <ja-JP>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJaJp {
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
			'common.no_record' => '記録なし',
			'common.today' => '今日',
			'common.untitled' => '無題',
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
			'S11_Invite_Confirm.label_select_ghost' => '引き継ぐメンバーを選択',
			'S11_Invite_Confirm.label_prepaid' => '立替',
			'S11_Invite_Confirm.label_expense' => '支出',
			'S13_Task_Dashboard.title' => 'ダッシュボード',
			'S13_Task_Dashboard.tab_group' => 'グループ',
			'S13_Task_Dashboard.tab_personal' => '個人',
			'S13_Task_Dashboard.label_prepay_balance' => 'プール残高',
			'S13_Task_Dashboard.label_my_balance' => '私の収支',
			'S13_Task_Dashboard.label_remainder' => ({required Object amount}) => '端数: ${amount}',
			'S13_Task_Dashboard.label_balance' => '残高',
			'S13_Task_Dashboard.label_total_expense' => '総費用',
			'S13_Task_Dashboard.label_total_prepay' => '総預り金',
			'S13_Task_Dashboard.label_remainder_pot' => '端数ポット',
			'S13_Task_Dashboard.fab_record' => '記録',
			'S13_Task_Dashboard.empty_records' => '記録がありません',
			'S13_Task_Dashboard.rule_random' => 'ランダム',
			'S13_Task_Dashboard.rule_order' => '順番',
			'S13_Task_Dashboard.rule_member' => '指定',
			'S13_Task_Dashboard.settlement_button' => '精算',
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
			'D03_TaskCreate_Confirm.share_message' => ({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「${taskName}」に参加しよう！\n招待コード：${code}\n連結：${link}',
			'D05_DateJump_NoResult.title' => '記録なし',
			'D05_DateJump_NoResult.content' => 'この日付の記録は見つかりませんでした。追加しますか？',
			'D05_DateJump_NoResult.action_cancel' => '戻る',
			'D05_DateJump_NoResult.action_add' => '記録を追加',
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
