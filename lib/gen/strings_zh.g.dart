///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsZh = Translations; // ignore: unused_element
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
		    locale: AppLocale.zh,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsS00OnboardingConsentZh S00_Onboarding_Consent = TranslationsS00OnboardingConsentZh._(_root);
	late final TranslationsS01OnboardingNameZh S01_Onboarding_Name = TranslationsS01OnboardingNameZh._(_root);
	late final TranslationsS04InviteConfirmZh S04_Invite_Confirm = TranslationsS04InviteConfirmZh._(_root);
	late final TranslationsS05TaskCreateFormZh S05_TaskCreate_Form = TranslationsS05TaskCreateFormZh._(_root);
	late final TranslationsD01InviteJoinSuccessZh D01_InviteJoin_Success = TranslationsD01InviteJoinSuccessZh._(_root);
	late final TranslationsD02InviteJoinErrorZh D02_InviteJoin_Error = TranslationsD02InviteJoinErrorZh._(_root);
	late final TranslationsD03TaskCreateConfirmZh D03_TaskCreate_Confirm = TranslationsD03TaskCreateConfirmZh._(_root);
	late final TranslationsS19SettingsTosZh S19_Settings_Tos = TranslationsS19SettingsTosZh._(_root);
	late final TranslationsErrorZh error = TranslationsErrorZh._(_root);
}

// Path: S00_Onboarding_Consent
class TranslationsS00OnboardingConsentZh {
	TranslationsS00OnboardingConsentZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '歡迎使用 Iron Split'
	String get title => '歡迎使用 Iron Split';

	/// zh: '歡迎使用 Iron Split。點擊開始即代表您同意我們的 '
	String get content_prefix => '歡迎使用 Iron Split。點擊開始即代表您同意我們的 ';

	/// zh: '服務條款'
	String get terms_link => '服務條款';

	/// zh: ' 與 '
	String get and => ' 與 ';

	/// zh: '隱私政策'
	String get privacy_link => '隱私政策';

	/// zh: '。我們採用匿名登入，保障您的隱私。'
	String get content_suffix => '。我們採用匿名登入，保障您的隱私。';

	/// zh: '開始使用'
	String get agree_btn => '開始使用';
}

// Path: S01_Onboarding_Name
class TranslationsS01OnboardingNameZh {
	TranslationsS01OnboardingNameZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '名稱設定'
	String get title => '名稱設定';

	/// zh: '請輸入您在 App 內的顯示名稱（1-10 個字）。'
	String get description => '請輸入您在 App 內的顯示名稱（1-10 個字）。';

	/// zh: '輸入暱稱'
	String get field_hint => '輸入暱稱';

	/// zh: '${current}/10'
	String field_counter({required Object current}) => '\$${current}/10';

	/// zh: '名稱不能為空'
	String get error_empty => '名稱不能為空';

	/// zh: '最多 10 個字'
	String get error_too_long => '最多 10 個字';

	/// zh: '包含無效字元'
	String get error_invalid_char => '包含無效字元';

	/// zh: '設定完成'
	String get action_next => '設定完成';
}

// Path: S04_Invite_Confirm
class TranslationsS04InviteConfirmZh {
	TranslationsS04InviteConfirmZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '加入任務'
	String get title => '加入任務';

	/// zh: '您受邀加入以下任務：'
	String get subtitle => '您受邀加入以下任務：';

	/// zh: '正在讀取邀請函...'
	String get loading_invite => '正在讀取邀請函...';

	/// zh: '哎呀！無法加入任務'
	String get join_failed_title => '哎呀！無法加入任務';

	/// zh: '請問您是以下成員嗎？'
	String get identity_match_title => '請問您是以下成員嗎？';

	/// zh: '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。'
	String get identity_match_desc => '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。';

	/// zh: '將以「連結帳號」方式加入'
	String get status_linking => '將以「連結帳號」方式加入';

	/// zh: '將以「新成員」身分加入'
	String get status_new_member => '將以「新成員」身分加入';

	/// zh: '加入'
	String get action_confirm => '加入';

	/// zh: '取消'
	String get action_cancel => '取消';

	/// zh: '回首頁'
	String get action_home => '回首頁';

	/// zh: '加入失敗：${message}'
	String error_join_failed({required Object message}) => '加入失敗：\$${message}';

	/// zh: '發生錯誤：${message}'
	String error_generic({required Object message}) => '發生錯誤：\$${message}';
}

// Path: S05_TaskCreate_Form
class TranslationsS05TaskCreateFormZh {
	TranslationsS05TaskCreateFormZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '新增任務'
	String get title => '新增任務';

	/// zh: '任務名稱'
	String get section_name => '任務名稱';

	/// zh: '任務期間'
	String get section_period => '任務期間';

	/// zh: '結算設定'
	String get section_settings => '結算設定';

	/// zh: '例如：東京五日遊'
	String get field_name_hint => '例如：東京五日遊';

	/// zh: '${current}/20'
	String field_name_counter({required Object current}) => '\$${current}/20';

	/// zh: '開始日期'
	String get field_start_date => '開始日期';

	/// zh: '結束日期'
	String get field_end_date => '結束日期';

	/// zh: '結算幣別'
	String get field_currency => '結算幣別';

	/// zh: '參加人數'
	String get field_member_count => '參加人數';

	/// zh: '保存'
	String get action_save => '保存';

	/// zh: '確定'
	String get picker_done => '確定';

	/// zh: '請輸入任務名稱'
	String get error_name_empty => '請輸入任務名稱';

	/// zh: '新台幣 (TWD)'
	String get currency_twd => '新台幣 (TWD)';

	/// zh: '日圓 (JPY)'
	String get currency_jpy => '日圓 (JPY)';

	/// zh: '美金 (USD)'
	String get currency_usd => '美金 (USD)';
}

// Path: D01_InviteJoin_Success
class TranslationsD01InviteJoinSuccessZh {
	TranslationsD01InviteJoinSuccessZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '成功加入任務！'
	String get title => '成功加入任務！';

	/// zh: '你的隨機分配頭像為：'
	String get assigned_avatar => '你的隨機分配頭像為：';

	/// zh: '註：頭像僅能重抽一次。'
	String get avatar_note => '註：頭像僅能重抽一次。';

	/// zh: '開始記帳'
	String get action_continue => '開始記帳';
}

// Path: D02_InviteJoin_Error
class TranslationsD02InviteJoinErrorZh {
	TranslationsD02InviteJoinErrorZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '無法加入任務'
	String get title => '無法加入任務';

	/// zh: '連結無效、已過期或任務人數已達上限。'
	String get message => '連結無效、已過期或任務人數已達上限。';

	/// zh: '關閉'
	String get action_close => '關閉';
}

// Path: D03_TaskCreate_Confirm
class TranslationsD03TaskCreateConfirmZh {
	TranslationsD03TaskCreateConfirmZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '確認任務設定'
	String get title => '確認任務設定';

	/// zh: '任務名稱'
	String get label_name => '任務名稱';

	/// zh: '期間'
	String get label_period => '期間';

	/// zh: '幣別'
	String get label_currency => '幣別';

	/// zh: '人數'
	String get label_members => '人數';

	/// zh: '確認'
	String get action_confirm => '確認';

	/// zh: '返回編輯'
	String get action_back => '返回編輯';

	/// zh: '正在建立任務...'
	String get creating_task => '正在建立任務...';

	/// zh: '準備邀請函...'
	String get preparing_share => '準備邀請函...';

	/// zh: '邀請加入 Iron Split 任務'
	String get share_subject => '邀請加入 Iron Split 任務';

	/// zh: '快來加入我的 Iron Split 任務「${taskName}」！ 邀請碼：${code} 連結：${link}'
	String share_message({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「\$${taskName}」！\n邀請碼：\$${code}\n連結：\$${link}';
}

// Path: S19_Settings_Tos
class TranslationsS19SettingsTosZh {
	TranslationsS19SettingsTosZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '服務條款'
	String get title => '服務條款';
}

// Path: error
class TranslationsErrorZh {
	TranslationsErrorZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsErrorTaskFullZh taskFull = TranslationsErrorTaskFullZh._(_root);
	late final TranslationsErrorExpiredCodeZh expiredCode = TranslationsErrorExpiredCodeZh._(_root);
	late final TranslationsErrorInvalidCodeZh invalidCode = TranslationsErrorInvalidCodeZh._(_root);
	late final TranslationsErrorAuthRequiredZh authRequired = TranslationsErrorAuthRequiredZh._(_root);
	late final TranslationsErrorAlreadyInTaskZh alreadyInTask = TranslationsErrorAlreadyInTaskZh._(_root);
	late final TranslationsErrorUnknownZh unknown = TranslationsErrorUnknownZh._(_root);
}

// Path: error.taskFull
class TranslationsErrorTaskFullZh {
	TranslationsErrorTaskFullZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '任務已滿'
	String get title => '任務已滿';

	/// zh: '此任務成員數已達上限 {limit} 人，請聯繫隊長。'
	String message({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。';
}

// Path: error.expiredCode
class TranslationsErrorExpiredCodeZh {
	TranslationsErrorExpiredCodeZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '邀請碼已過期'
	String get title => '邀請碼已過期';

	/// zh: '此邀請連結已失效（時限 {minutes} 分鐘）。請請隊長重新產生。'
	String message({required Object minutes}) => '此邀請連結已失效（時限 ${minutes} 分鐘）。請請隊長重新產生。';
}

// Path: error.invalidCode
class TranslationsErrorInvalidCodeZh {
	TranslationsErrorInvalidCodeZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '連結無效'
	String get title => '連結無效';

	/// zh: '無效的邀請連結，請確認是否正確或已被刪除。'
	String get message => '無效的邀請連結，請確認是否正確或已被刪除。';
}

// Path: error.authRequired
class TranslationsErrorAuthRequiredZh {
	TranslationsErrorAuthRequiredZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '需要登入'
	String get title => '需要登入';

	/// zh: '請先登入後再加入任務。'
	String get message => '請先登入後再加入任務。';
}

// Path: error.alreadyInTask
class TranslationsErrorAlreadyInTaskZh {
	TranslationsErrorAlreadyInTaskZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '您已是成員'
	String get title => '您已是成員';

	/// zh: '您已經在這個任務中了。'
	String get message => '您已經在這個任務中了。';
}

// Path: error.unknown
class TranslationsErrorUnknownZh {
	TranslationsErrorUnknownZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '發生錯誤'
	String get title => '發生錯誤';

	/// zh: '發生未預期的錯誤，請稍後再試。'
	String get message => '發生未預期的錯誤，請稍後再試。';
}

/// The flat map containing all translations for locale <zh>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'S00_Onboarding_Consent.title' => '歡迎使用 Iron Split',
			'S00_Onboarding_Consent.content_prefix' => '歡迎使用 Iron Split。點擊開始即代表您同意我們的 ',
			'S00_Onboarding_Consent.terms_link' => '服務條款',
			'S00_Onboarding_Consent.and' => ' 與 ',
			'S00_Onboarding_Consent.privacy_link' => '隱私政策',
			'S00_Onboarding_Consent.content_suffix' => '。我們採用匿名登入，保障您的隱私。',
			'S00_Onboarding_Consent.agree_btn' => '開始使用',
			'S01_Onboarding_Name.title' => '名稱設定',
			'S01_Onboarding_Name.description' => '請輸入您在 App 內的顯示名稱（1-10 個字）。',
			'S01_Onboarding_Name.field_hint' => '輸入暱稱',
			'S01_Onboarding_Name.field_counter' => ({required Object current}) => '\$${current}/10',
			'S01_Onboarding_Name.error_empty' => '名稱不能為空',
			'S01_Onboarding_Name.error_too_long' => '最多 10 個字',
			'S01_Onboarding_Name.error_invalid_char' => '包含無效字元',
			'S01_Onboarding_Name.action_next' => '設定完成',
			'S04_Invite_Confirm.title' => '加入任務',
			'S04_Invite_Confirm.subtitle' => '您受邀加入以下任務：',
			'S04_Invite_Confirm.loading_invite' => '正在讀取邀請函...',
			'S04_Invite_Confirm.join_failed_title' => '哎呀！無法加入任務',
			'S04_Invite_Confirm.identity_match_title' => '請問您是以下成員嗎？',
			'S04_Invite_Confirm.identity_match_desc' => '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。',
			'S04_Invite_Confirm.status_linking' => '將以「連結帳號」方式加入',
			'S04_Invite_Confirm.status_new_member' => '將以「新成員」身分加入',
			'S04_Invite_Confirm.action_confirm' => '加入',
			'S04_Invite_Confirm.action_cancel' => '取消',
			'S04_Invite_Confirm.action_home' => '回首頁',
			'S04_Invite_Confirm.error_join_failed' => ({required Object message}) => '加入失敗：\$${message}',
			'S04_Invite_Confirm.error_generic' => ({required Object message}) => '發生錯誤：\$${message}',
			'S05_TaskCreate_Form.title' => '新增任務',
			'S05_TaskCreate_Form.section_name' => '任務名稱',
			'S05_TaskCreate_Form.section_period' => '任務期間',
			'S05_TaskCreate_Form.section_settings' => '結算設定',
			'S05_TaskCreate_Form.field_name_hint' => '例如：東京五日遊',
			'S05_TaskCreate_Form.field_name_counter' => ({required Object current}) => '\$${current}/20',
			'S05_TaskCreate_Form.field_start_date' => '開始日期',
			'S05_TaskCreate_Form.field_end_date' => '結束日期',
			'S05_TaskCreate_Form.field_currency' => '結算幣別',
			'S05_TaskCreate_Form.field_member_count' => '參加人數',
			'S05_TaskCreate_Form.action_save' => '保存',
			'S05_TaskCreate_Form.picker_done' => '確定',
			'S05_TaskCreate_Form.error_name_empty' => '請輸入任務名稱',
			'S05_TaskCreate_Form.currency_twd' => '新台幣 (TWD)',
			'S05_TaskCreate_Form.currency_jpy' => '日圓 (JPY)',
			'S05_TaskCreate_Form.currency_usd' => '美金 (USD)',
			'D01_InviteJoin_Success.title' => '成功加入任務！',
			'D01_InviteJoin_Success.assigned_avatar' => '你的隨機分配頭像為：',
			'D01_InviteJoin_Success.avatar_note' => '註：頭像僅能重抽一次。',
			'D01_InviteJoin_Success.action_continue' => '開始記帳',
			'D02_InviteJoin_Error.title' => '無法加入任務',
			'D02_InviteJoin_Error.message' => '連結無效、已過期或任務人數已達上限。',
			'D02_InviteJoin_Error.action_close' => '關閉',
			'D03_TaskCreate_Confirm.title' => '確認任務設定',
			'D03_TaskCreate_Confirm.label_name' => '任務名稱',
			'D03_TaskCreate_Confirm.label_period' => '期間',
			'D03_TaskCreate_Confirm.label_currency' => '幣別',
			'D03_TaskCreate_Confirm.label_members' => '人數',
			'D03_TaskCreate_Confirm.action_confirm' => '確認',
			'D03_TaskCreate_Confirm.action_back' => '返回編輯',
			'D03_TaskCreate_Confirm.creating_task' => '正在建立任務...',
			'D03_TaskCreate_Confirm.preparing_share' => '準備邀請函...',
			'D03_TaskCreate_Confirm.share_subject' => '邀請加入 Iron Split 任務',
			'D03_TaskCreate_Confirm.share_message' => ({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「\$${taskName}」！\n邀請碼：\$${code}\n連結：\$${link}',
			'S19_Settings_Tos.title' => '服務條款',
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
