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
	@override late final _TranslationsCommonJa common = _TranslationsCommonJa._(_root);
	@override late final _TranslationsS00OnboardingConsentJa S00_Onboarding_Consent = _TranslationsS00OnboardingConsentJa._(_root);
	@override late final _TranslationsS01OnboardingNameJa S01_Onboarding_Name = _TranslationsS01OnboardingNameJa._(_root);
	@override late final _TranslationsS02HomeTaskListJa S02_Home_TaskList = _TranslationsS02HomeTaskListJa._(_root);
	@override late final _TranslationsS04InviteConfirmJa S04_Invite_Confirm = _TranslationsS04InviteConfirmJa._(_root);
	@override late final _TranslationsS05TaskCreateFormJa S05_TaskCreate_Form = _TranslationsS05TaskCreateFormJa._(_root);
	@override late final _TranslationsS06TaskDashboardMainJa S06_TaskDashboard_Main = _TranslationsS06TaskDashboardMainJa._(_root);
	@override late final _TranslationsD01InviteJoinSuccessJa D01_InviteJoin_Success = _TranslationsD01InviteJoinSuccessJa._(_root);
	@override late final _TranslationsD01MemberRoleIntroJa D01_MemberRole_Intro = _TranslationsD01MemberRoleIntroJa._(_root);
	@override late final _TranslationsD02InviteJoinErrorJa D02_InviteJoin_Error = _TranslationsD02InviteJoinErrorJa._(_root);
	@override late final _TranslationsD03TaskCreateConfirmJa D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmJa._(_root);
	@override late final _TranslationsD04CommonUnsavedChangesJa D04_Common_UnsavedChanges = _TranslationsD04CommonUnsavedChangesJa._(_root);
	@override late final _TranslationsS19SettingsTosJa S19_Settings_Tos = _TranslationsS19SettingsTosJa._(_root);
	@override late final _TranslationsErrorJa error = _TranslationsErrorJa._(_root);
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
	@override String error_prefix({required Object message}) => 'エラー: \$${message}';
	@override String get please_login => 'ログインしてください';
}

// Path: S00_Onboarding_Consent
class _TranslationsS00OnboardingConsentJa implements TranslationsS00OnboardingConsentZh {
	_TranslationsS00OnboardingConsentJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'Iron Split へようこそ';
	@override String get content_prefix => '開始することで、';
	@override String get terms_link => '利用規約';
	@override String get and => ' と ';
	@override String get privacy_link => 'プライバシーポリシー';
	@override String get content_suffix => ' に同意したものとみなされます。';
	@override String get agree_btn => 'はじめる';
	@override String login_failed({required Object message}) => 'ログイン失敗: \$${message}';
}

// Path: S01_Onboarding_Name
class _TranslationsS01OnboardingNameJa implements TranslationsS01OnboardingNameZh {
	_TranslationsS01OnboardingNameJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '名前設定';
	@override String get description => 'アプリ内で表示する名前を入力してください（1-10文字）。';
	@override String get field_hint => 'ニックネームを入力';
	@override String field_counter({required Object current}) => '\$${current}/10';
	@override String get error_empty => '名前を入力してください';
	@override String get error_too_long => '10文字以内で入力してください';
	@override String get error_invalid_char => '無効な文字が含まれています';
	@override String get action_next => '設定';
}

// Path: S02_Home_TaskList
class _TranslationsS02HomeTaskListJa implements TranslationsS02HomeTaskListZh {
	_TranslationsS02HomeTaskListJa._(this._root);

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

// Path: S04_Invite_Confirm
class _TranslationsS04InviteConfirmJa implements TranslationsS04InviteConfirmZh {
	_TranslationsS04InviteConfirmJa._(this._root);

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
	@override String error_join_failed({required Object message}) => '参加失敗: \$${message}';
	@override String error_generic({required Object message}) => 'エラー: \$${message}';
}

// Path: S05_TaskCreate_Form
class _TranslationsS05TaskCreateFormJa implements TranslationsS05TaskCreateFormZh {
	_TranslationsS05TaskCreateFormJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスク作成';
	@override String get section_name => 'タスク名';
	@override String get section_period => '期間';
	@override String get section_settings => '設定';
	@override String get field_name_hint => '例：東京5日間の旅';
	@override String field_name_counter({required Object current}) => '\$${current}/20';
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

// Path: S06_TaskDashboard_Main
class _TranslationsS06TaskDashboardMainJa implements TranslationsS06TaskDashboardMainZh {
	_TranslationsS06TaskDashboardMainJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスクホーム';
	@override String get error_member_not_found => 'メンバーが見つかりません';
	@override String welcome_message({required Object name}) => 'ようこそ, \$${name}';
	@override String role_label({required Object role}) => '役割: \$${role}';
	@override String avatar_label({required Object avatar}) => 'アバター: \$${avatar}';
	@override String get placeholder_content => 'ここにダッシュボードが表示されます...';
}

// Path: D01_InviteJoin_Success
class _TranslationsD01InviteJoinSuccessJa implements TranslationsD01InviteJoinSuccessZh {
	_TranslationsD01InviteJoinSuccessJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '参加しました！';
	@override String get assigned_avatar => '割り当てられたアバター：';
	@override String get avatar_note => '注：アバターのリロールは1回のみです。';
	@override String get action_continue => 'はじめる';
}

// Path: D01_MemberRole_Intro
class _TranslationsD01MemberRoleIntroJa implements TranslationsD01MemberRoleIntroZh {
	_TranslationsD01MemberRoleIntroJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get action_reroll => 'リロールする';
	@override String error_reroll_failed({required Object message}) => 'リロール失敗: \$${message}';
}

// Path: D02_InviteJoin_Error
class _TranslationsD02InviteJoinErrorJa implements TranslationsD02InviteJoinErrorZh {
	_TranslationsD02InviteJoinErrorJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '参加できません';
	@override String get message => 'リンクが無効、期限切れ、または満員です。';
	@override String get action_close => '閉じる';
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
	@override String share_message({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「\$${taskName}」に参加しよう！\n招待コード：\$${code}\nリンク：\$${link}';
}

// Path: D04_Common_UnsavedChanges
class _TranslationsD04CommonUnsavedChangesJa implements TranslationsD04CommonUnsavedChangesZh {
	_TranslationsD04CommonUnsavedChangesJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '設定は完了していません';
	@override String get content => '現在の設定は破棄されます。本当に移動しますか？';
	@override String get action_leave => 'ホームへ戻る';
	@override String get action_stay => '編集を続ける';
}

// Path: S19_Settings_Tos
class _TranslationsS19SettingsTosJa implements TranslationsS19SettingsTosZh {
	_TranslationsS19SettingsTosJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '利用規約';
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
			'common.cancel' => 'キャンセル',
			'common.delete' => '削除',
			'common.confirm' => '確認',
			'common.back' => '戻る',
			'common.save' => '保存',
			'common.error_prefix' => ({required Object message}) => 'エラー: \$${message}',
			'common.please_login' => 'ログインしてください',
			'S00_Onboarding_Consent.title' => 'Iron Split へようこそ',
			'S00_Onboarding_Consent.content_prefix' => '開始することで、',
			'S00_Onboarding_Consent.terms_link' => '利用規約',
			'S00_Onboarding_Consent.and' => ' と ',
			'S00_Onboarding_Consent.privacy_link' => 'プライバシーポリシー',
			'S00_Onboarding_Consent.content_suffix' => ' に同意したものとみなされます。',
			'S00_Onboarding_Consent.agree_btn' => 'はじめる',
			'S00_Onboarding_Consent.login_failed' => ({required Object message}) => 'ログイン失敗: \$${message}',
			'S01_Onboarding_Name.title' => '名前設定',
			'S01_Onboarding_Name.description' => 'アプリ内で表示する名前を入力してください（1-10文字）。',
			'S01_Onboarding_Name.field_hint' => 'ニックネームを入力',
			'S01_Onboarding_Name.field_counter' => ({required Object current}) => '\$${current}/10',
			'S01_Onboarding_Name.error_empty' => '名前を入力してください',
			'S01_Onboarding_Name.error_too_long' => '10文字以内で入力してください',
			'S01_Onboarding_Name.error_invalid_char' => '無効な文字が含まれています',
			'S01_Onboarding_Name.action_next' => '設定',
			'S02_Home_TaskList.title' => 'マイタスク',
			'S02_Home_TaskList.tab_in_progress' => '進行中',
			'S02_Home_TaskList.tab_completed' => '完了済',
			'S02_Home_TaskList.mascot_preparing' => '鉄の雄鶏、準備中...',
			'S02_Home_TaskList.empty_in_progress' => '進行中のタスクはありません',
			'S02_Home_TaskList.empty_completed' => '完了したタスクはありません',
			'S02_Home_TaskList.date_tbd' => '日付未定',
			'S02_Home_TaskList.delete_confirm_title' => '削除の確認',
			'S02_Home_TaskList.delete_confirm_content' => 'このタスクを削除してもよろしいですか？',
			'S04_Invite_Confirm.title' => 'タスクに参加',
			'S04_Invite_Confirm.subtitle' => '以下のタスクに招待されました：',
			'S04_Invite_Confirm.loading_invite' => '招待状を読み込み中...',
			'S04_Invite_Confirm.join_failed_title' => 'タスクに参加できません',
			'S04_Invite_Confirm.identity_match_title' => 'あなたは以下のメンバーですか？',
			'S04_Invite_Confirm.identity_match_desc' => 'このタスクには事前に作成されたメンバーがいます。もしあなたがいれば、名前を選択してアカウントを連携してください。そうでなければ、新規に参加してください。',
			'S04_Invite_Confirm.status_linking' => '「アカウント連携」で参加します',
			'S04_Invite_Confirm.status_new_member' => '「新規メンバー」として参加します',
			'S04_Invite_Confirm.action_confirm' => '参加',
			'S04_Invite_Confirm.action_cancel' => 'キャンセル',
			'S04_Invite_Confirm.action_home' => 'ホームへ',
			'S04_Invite_Confirm.error_join_failed' => ({required Object message}) => '参加失敗: \$${message}',
			'S04_Invite_Confirm.error_generic' => ({required Object message}) => 'エラー: \$${message}',
			'S05_TaskCreate_Form.title' => 'タスク作成',
			'S05_TaskCreate_Form.section_name' => 'タスク名',
			'S05_TaskCreate_Form.section_period' => '期間',
			'S05_TaskCreate_Form.section_settings' => '設定',
			'S05_TaskCreate_Form.field_name_hint' => '例：東京5日間の旅',
			'S05_TaskCreate_Form.field_name_counter' => ({required Object current}) => '\$${current}/20',
			'S05_TaskCreate_Form.field_start_date' => '開始日',
			'S05_TaskCreate_Form.field_end_date' => '終了日',
			'S05_TaskCreate_Form.field_currency' => '通貨',
			'S05_TaskCreate_Form.field_member_count' => '参加人数',
			'S05_TaskCreate_Form.action_save' => '保存',
			'S05_TaskCreate_Form.picker_done' => '完了',
			'S05_TaskCreate_Form.error_name_empty' => 'タスク名を入力してください',
			'S05_TaskCreate_Form.currency_twd' => '台湾ドル (TWD)',
			'S05_TaskCreate_Form.currency_jpy' => '日本円 (JPY)',
			'S05_TaskCreate_Form.currency_usd' => '米ドル (USD)',
			'S06_TaskDashboard_Main.title' => 'タスクホーム',
			'S06_TaskDashboard_Main.error_member_not_found' => 'メンバーが見つかりません',
			'S06_TaskDashboard_Main.welcome_message' => ({required Object name}) => 'ようこそ, \$${name}',
			'S06_TaskDashboard_Main.role_label' => ({required Object role}) => '役割: \$${role}',
			'S06_TaskDashboard_Main.avatar_label' => ({required Object avatar}) => 'アバター: \$${avatar}',
			'S06_TaskDashboard_Main.placeholder_content' => 'ここにダッシュボードが表示されます...',
			'D01_InviteJoin_Success.title' => '参加しました！',
			'D01_InviteJoin_Success.assigned_avatar' => '割り当てられたアバター：',
			'D01_InviteJoin_Success.avatar_note' => '注：アバターのリロールは1回のみです。',
			'D01_InviteJoin_Success.action_continue' => 'はじめる',
			'D01_MemberRole_Intro.action_reroll' => 'リロールする',
			'D01_MemberRole_Intro.error_reroll_failed' => ({required Object message}) => 'リロール失敗: \$${message}',
			'D02_InviteJoin_Error.title' => '参加できません',
			'D02_InviteJoin_Error.message' => 'リンクが無効、期限切れ、または満員です。',
			'D02_InviteJoin_Error.action_close' => '閉じる',
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
			'D03_TaskCreate_Confirm.share_message' => ({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「\$${taskName}」に参加しよう！\n招待コード：\$${code}\nリンク：\$${link}',
			'D04_Common_UnsavedChanges.title' => '設定は完了していません',
			'D04_Common_UnsavedChanges.content' => '現在の設定は破棄されます。本当に移動しますか？',
			'D04_Common_UnsavedChanges.action_leave' => 'ホームへ戻る',
			'D04_Common_UnsavedChanges.action_stay' => '編集を続ける',
			'S19_Settings_Tos.title' => '利用規約',
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
