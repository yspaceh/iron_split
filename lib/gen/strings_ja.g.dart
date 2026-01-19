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
	@override late final _TranslationsS00OnboardingConsentJa S00_Onboarding_Consent = _TranslationsS00OnboardingConsentJa._(_root);
	@override late final _TranslationsS01OnboardingNameJa S01_Onboarding_Name = _TranslationsS01OnboardingNameJa._(_root);
	@override late final _TranslationsS04InviteConfirmJa S04_Invite_Confirm = _TranslationsS04InviteConfirmJa._(_root);
	@override late final _TranslationsS05TaskCreateFormJa S05_TaskCreate_Form = _TranslationsS05TaskCreateFormJa._(_root);
	@override late final _TranslationsD01InviteJoinSuccessJa D01_InviteJoin_Success = _TranslationsD01InviteJoinSuccessJa._(_root);
	@override late final _TranslationsD02InviteJoinErrorJa D02_InviteJoin_Error = _TranslationsD02InviteJoinErrorJa._(_root);
	@override late final _TranslationsD03TaskCreateConfirmJa D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmJa._(_root);
	@override late final _TranslationsS19SettingsTosJa S19_Settings_Tos = _TranslationsS19SettingsTosJa._(_root);
	@override late final _TranslationsErrorJa error = _TranslationsErrorJa._(_root);
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

// Path: S04_Invite_Confirm
class _TranslationsS04InviteConfirmJa implements TranslationsS04InviteConfirmZh {
	_TranslationsS04InviteConfirmJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タスクに参加';
	@override String get subtitle => '以下のタスクに招待されました：';
	@override String get loading_invite => '招待状を読み込んでいます...';
	@override String get join_failed_title => 'おっと！参加できません';
	@override String get identity_match_title => 'あなたはこのメンバーですか？';
	@override String get identity_match_desc => 'このタスクには既定のメンバーリストがあります。該当する場合は名前を選択して連携してください。該当しない場合は、そのまま参加してください。';
	@override String get status_linking => '「アカウント連携」で参加します';
	@override String get status_new_member => '「新規メンバー」として参加します';
	@override String get action_confirm => '参加';
	@override String get action_cancel => 'キャンセル';
	@override String get action_home => 'ホームへ戻る';
	@override String error_join_failed({required Object message}) => '参加失敗：\$${message}';
	@override String error_generic({required Object message}) => 'エラーが発生しました：\$${message}';
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

// Path: D01_InviteJoin_Success
class _TranslationsD01InviteJoinSuccessJa implements TranslationsD01InviteJoinSuccessZh {
	_TranslationsD01InviteJoinSuccessJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '参加完了！';
	@override String get assigned_avatar => 'あなたの動物アイコンは：';
	@override String get avatar_note => '※アイコンの引き直しは1回のみ可能です。';
	@override String get action_continue => '記録を開始';
}

// Path: D02_InviteJoin_Error
class _TranslationsD02InviteJoinErrorJa implements TranslationsD02InviteJoinErrorZh {
	_TranslationsD02InviteJoinErrorJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '参加できません';
	@override String get message => 'リンクが無効、期限切れ、または定員に達しています。';
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
	@override String get title => '定員に達しました';
	@override String message({required Object limit}) => 'このタスクは上限の ${limit} 名に達しています。リーダーに連絡してください。';
}

// Path: error.expiredCode
class _TranslationsErrorExpiredCodeJa implements TranslationsErrorExpiredCodeZh {
	_TranslationsErrorExpiredCodeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '招待リンクの期限切れ';
	@override String message({required Object minutes}) => 'リンクの有効期限（${minutes}分）が切れています。リーダーに再発行を依頼してください。';
}

// Path: error.invalidCode
class _TranslationsErrorInvalidCodeJa implements TranslationsErrorInvalidCodeZh {
	_TranslationsErrorInvalidCodeJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '無効なリンク';
	@override String get message => '招待リンクが無効です。正しいか削除されていないか確認してください。';
}

// Path: error.authRequired
class _TranslationsErrorAuthRequiredJa implements TranslationsErrorAuthRequiredZh {
	_TranslationsErrorAuthRequiredJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログインが必要です';
	@override String get message => 'タスクに参加するにはログインが必要です。';
}

// Path: error.alreadyInTask
class _TranslationsErrorAlreadyInTaskJa implements TranslationsErrorAlreadyInTaskZh {
	_TranslationsErrorAlreadyInTaskJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '既に参加済み';
	@override String get message => 'あなたは既にこのタスクのメンバーです。';
}

// Path: error.unknown
class _TranslationsErrorUnknownJa implements TranslationsErrorUnknownZh {
	_TranslationsErrorUnknownJa._(this._root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エラー';
	@override String get message => '予期しないエラーが発生しました。後でもう一度お試しください。';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'S00_Onboarding_Consent.title' => 'Iron Split へようこそ',
			'S00_Onboarding_Consent.content_prefix' => '開始することで、',
			'S00_Onboarding_Consent.terms_link' => '利用規約',
			'S00_Onboarding_Consent.and' => ' と ',
			'S00_Onboarding_Consent.privacy_link' => 'プライバシーポリシー',
			'S00_Onboarding_Consent.content_suffix' => ' に同意したものとみなされます。',
			'S00_Onboarding_Consent.agree_btn' => 'はじめる',
			'S01_Onboarding_Name.title' => '名前設定',
			'S01_Onboarding_Name.description' => 'アプリ内で表示する名前を入力してください（1-10文字）。',
			'S01_Onboarding_Name.field_hint' => 'ニックネームを入力',
			'S01_Onboarding_Name.field_counter' => ({required Object current}) => '\$${current}/10',
			'S01_Onboarding_Name.error_empty' => '名前を入力してください',
			'S01_Onboarding_Name.error_too_long' => '10文字以内で入力してください',
			'S01_Onboarding_Name.error_invalid_char' => '無効な文字が含まれています',
			'S01_Onboarding_Name.action_next' => '設定',
			'S04_Invite_Confirm.title' => 'タスクに参加',
			'S04_Invite_Confirm.subtitle' => '以下のタスクに招待されました：',
			'S04_Invite_Confirm.loading_invite' => '招待状を読み込んでいます...',
			'S04_Invite_Confirm.join_failed_title' => 'おっと！参加できません',
			'S04_Invite_Confirm.identity_match_title' => 'あなたはこのメンバーですか？',
			'S04_Invite_Confirm.identity_match_desc' => 'このタスクには既定のメンバーリストがあります。該当する場合は名前を選択して連携してください。該当しない場合は、そのまま参加してください。',
			'S04_Invite_Confirm.status_linking' => '「アカウント連携」で参加します',
			'S04_Invite_Confirm.status_new_member' => '「新規メンバー」として参加します',
			'S04_Invite_Confirm.action_confirm' => '参加',
			'S04_Invite_Confirm.action_cancel' => 'キャンセル',
			'S04_Invite_Confirm.action_home' => 'ホームへ戻る',
			'S04_Invite_Confirm.error_join_failed' => ({required Object message}) => '参加失敗：\$${message}',
			'S04_Invite_Confirm.error_generic' => ({required Object message}) => 'エラーが発生しました：\$${message}',
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
			'D01_InviteJoin_Success.title' => '参加完了！',
			'D01_InviteJoin_Success.assigned_avatar' => 'あなたの動物アイコンは：',
			'D01_InviteJoin_Success.avatar_note' => '※アイコンの引き直しは1回のみ可能です。',
			'D01_InviteJoin_Success.action_continue' => '記録を開始',
			'D02_InviteJoin_Error.title' => '参加できません',
			'D02_InviteJoin_Error.message' => 'リンクが無効、期限切れ、または定員に達しています。',
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
			'S19_Settings_Tos.title' => '利用規約',
			'error.taskFull.title' => '定員に達しました',
			'error.taskFull.message' => ({required Object limit}) => 'このタスクは上限の ${limit} 名に達しています。リーダーに連絡してください。',
			'error.expiredCode.title' => '招待リンクの期限切れ',
			'error.expiredCode.message' => ({required Object minutes}) => 'リンクの有効期限（${minutes}分）が切れています。リーダーに再発行を依頼してください。',
			'error.invalidCode.title' => '無効なリンク',
			'error.invalidCode.message' => '招待リンクが無効です。正しいか削除されていないか確認してください。',
			'error.authRequired.title' => 'ログインが必要です',
			'error.authRequired.message' => 'タスクに参加するにはログインが必要です。',
			'error.alreadyInTask.title' => '既に参加済み',
			'error.alreadyInTask.message' => 'あなたは既にこのタスクのメンバーです。',
			'error.unknown.title' => 'エラー',
			'error.unknown.message' => '予期しないエラーが発生しました。後でもう一度お試しください。',
			_ => null,
		};
	}
}
