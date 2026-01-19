/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 3
/// Strings: 225 (75 per locale)
///
/// Built on 2026-01-19 at 13:21 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.zh;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.zh) // set locale
/// - Locale locale = AppLocale.zh.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.zh) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	zh(languageCode: 'zh', build: Translations.build),
	en(languageCode: 'en', build: _StringsEn.build),
	ja(languageCode: 'ja', build: _StringsJa.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
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

	// Translations
	late final _StringsS00OnboardingConsentZh S00_Onboarding_Consent = _StringsS00OnboardingConsentZh._(_root);
	late final _StringsS01OnboardingNameZh S01_Onboarding_Name = _StringsS01OnboardingNameZh._(_root);
	late final _StringsS04InviteConfirmZh S04_Invite_Confirm = _StringsS04InviteConfirmZh._(_root);
	late final _StringsS05TaskCreateFormZh S05_TaskCreate_Form = _StringsS05TaskCreateFormZh._(_root);
	late final _StringsD01InviteJoinSuccessZh D01_InviteJoin_Success = _StringsD01InviteJoinSuccessZh._(_root);
	late final _StringsD02InviteJoinErrorZh D02_InviteJoin_Error = _StringsD02InviteJoinErrorZh._(_root);
	late final _StringsD03TaskCreateConfirmZh D03_TaskCreate_Confirm = _StringsD03TaskCreateConfirmZh._(_root);
	late final _StringsS19SettingsTosZh S19_Settings_Tos = _StringsS19SettingsTosZh._(_root);
	late final _StringsErrorZh error = _StringsErrorZh._(_root);
}

// Path: S00_Onboarding_Consent
class _StringsS00OnboardingConsentZh {
	_StringsS00OnboardingConsentZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '歡迎使用 Iron Split';
	String get content_prefix => '歡迎使用 Iron Split。點擊開始即代表您同意我們的 ';
	String get terms_link => '服務條款';
	String get and => ' 與 ';
	String get privacy_link => '隱私政策';
	String get content_suffix => '。我們採用匿名登入，保障您的隱私。';
	String get agree_btn => '開始使用';
}

// Path: S01_Onboarding_Name
class _StringsS01OnboardingNameZh {
	_StringsS01OnboardingNameZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '名稱設定';
	String get description => '請輸入您在 App 內的顯示名稱（1-10 個字）。';
	String get field_hint => '輸入暱稱';
	String field_counter({required Object current}) => '\$${current}/10';
	String get error_empty => '名稱不能為空';
	String get error_too_long => '最多 10 個字';
	String get error_invalid_char => '包含無效字元';
	String get action_next => '設定完成';
}

// Path: S04_Invite_Confirm
class _StringsS04InviteConfirmZh {
	_StringsS04InviteConfirmZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '加入任務';
	String get subtitle => '您受邀加入以下任務：';
	String get loading_invite => '正在讀取邀請函...';
	String get join_failed_title => '哎呀！無法加入任務';
	String get identity_match_title => '請問您是以下成員嗎？';
	String get identity_match_desc => '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。';
	String get status_linking => '將以「連結帳號」方式加入';
	String get status_new_member => '將以「新成員」身分加入';
	String get action_confirm => '加入';
	String get action_cancel => '取消';
	String get action_home => '回首頁';
	String error_join_failed({required Object message}) => '加入失敗：\$${message}';
	String error_generic({required Object message}) => '發生錯誤：\$${message}';
}

// Path: S05_TaskCreate_Form
class _StringsS05TaskCreateFormZh {
	_StringsS05TaskCreateFormZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '新增任務';
	String get section_name => '任務名稱';
	String get section_period => '任務期間';
	String get section_settings => '結算設定';
	String get field_name_hint => '例如：東京五日遊';
	String field_name_counter({required Object current}) => '\$${current}/20';
	String get field_start_date => '開始日期';
	String get field_end_date => '結束日期';
	String get field_currency => '結算幣別';
	String get field_member_count => '參加人數';
	String get action_save => '保存';
	String get picker_done => '確定';
	String get error_name_empty => '請輸入任務名稱';
	String get currency_twd => '新台幣 (TWD)';
	String get currency_jpy => '日圓 (JPY)';
	String get currency_usd => '美金 (USD)';
}

// Path: D01_InviteJoin_Success
class _StringsD01InviteJoinSuccessZh {
	_StringsD01InviteJoinSuccessZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '成功加入任務！';
	String get assigned_avatar => '你的隨機分配頭像為：';
	String get avatar_note => '註：頭像僅能重抽一次。';
	String get action_continue => '開始記帳';
}

// Path: D02_InviteJoin_Error
class _StringsD02InviteJoinErrorZh {
	_StringsD02InviteJoinErrorZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '無法加入任務';
	String get message => '連結無效、已過期或任務人數已達上限。';
	String get action_close => '關閉';
}

// Path: D03_TaskCreate_Confirm
class _StringsD03TaskCreateConfirmZh {
	_StringsD03TaskCreateConfirmZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '確認任務設定';
	String get label_name => '任務名稱';
	String get label_period => '期間';
	String get label_currency => '幣別';
	String get label_members => '人數';
	String get action_confirm => '確認';
	String get action_back => '返回編輯';
	String get creating_task => '正在建立任務...';
	String get preparing_share => '準備邀請函...';
	String get share_subject => '邀請加入 Iron Split 任務';
	String share_message({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「\$${taskName}」！\n邀請碼：\$${code}\n連結：\$${link}';
}

// Path: S19_Settings_Tos
class _StringsS19SettingsTosZh {
	_StringsS19SettingsTosZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '服務條款';
}

// Path: error
class _StringsErrorZh {
	_StringsErrorZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final _StringsErrorTaskFullZh taskFull = _StringsErrorTaskFullZh._(_root);
	late final _StringsErrorExpiredCodeZh expiredCode = _StringsErrorExpiredCodeZh._(_root);
	late final _StringsErrorInvalidCodeZh invalidCode = _StringsErrorInvalidCodeZh._(_root);
	late final _StringsErrorAuthRequiredZh authRequired = _StringsErrorAuthRequiredZh._(_root);
	late final _StringsErrorAlreadyInTaskZh alreadyInTask = _StringsErrorAlreadyInTaskZh._(_root);
	late final _StringsErrorUnknownZh unknown = _StringsErrorUnknownZh._(_root);
}

// Path: error.taskFull
class _StringsErrorTaskFullZh {
	_StringsErrorTaskFullZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '任務已滿';
	String message({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。';
}

// Path: error.expiredCode
class _StringsErrorExpiredCodeZh {
	_StringsErrorExpiredCodeZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '邀請碼已過期';
	String message({required Object minutes}) => '此邀請連結已失效（時限 ${minutes} 分鐘）。請請隊長重新產生。';
}

// Path: error.invalidCode
class _StringsErrorInvalidCodeZh {
	_StringsErrorInvalidCodeZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '連結無效';
	String get message => '無效的邀請連結，請確認是否正確或已被刪除。';
}

// Path: error.authRequired
class _StringsErrorAuthRequiredZh {
	_StringsErrorAuthRequiredZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '需要登入';
	String get message => '請先登入後再加入任務。';
}

// Path: error.alreadyInTask
class _StringsErrorAlreadyInTaskZh {
	_StringsErrorAlreadyInTaskZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '您已是成員';
	String get message => '您已經在這個任務中了。';
}

// Path: error.unknown
class _StringsErrorUnknownZh {
	_StringsErrorUnknownZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '發生錯誤';
	String get message => '發生未預期的錯誤，請稍後再試。';
}

// Path: <root>
class _StringsEn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsS00OnboardingConsentEn S00_Onboarding_Consent = _StringsS00OnboardingConsentEn._(_root);
	@override late final _StringsS01OnboardingNameEn S01_Onboarding_Name = _StringsS01OnboardingNameEn._(_root);
	@override late final _StringsS04InviteConfirmEn S04_Invite_Confirm = _StringsS04InviteConfirmEn._(_root);
	@override late final _StringsS05TaskCreateFormEn S05_TaskCreate_Form = _StringsS05TaskCreateFormEn._(_root);
	@override late final _StringsD01InviteJoinSuccessEn D01_InviteJoin_Success = _StringsD01InviteJoinSuccessEn._(_root);
	@override late final _StringsD02InviteJoinErrorEn D02_InviteJoin_Error = _StringsD02InviteJoinErrorEn._(_root);
	@override late final _StringsD03TaskCreateConfirmEn D03_TaskCreate_Confirm = _StringsD03TaskCreateConfirmEn._(_root);
	@override late final _StringsS19SettingsTosEn S19_Settings_Tos = _StringsS19SettingsTosEn._(_root);
	@override late final _StringsErrorEn error = _StringsErrorEn._(_root);
}

// Path: S00_Onboarding_Consent
class _StringsS00OnboardingConsentEn implements _StringsS00OnboardingConsentZh {
	_StringsS00OnboardingConsentEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Welcome to Iron Split';
	@override String get content_prefix => 'By clicking Start, you agree to our ';
	@override String get terms_link => 'Terms of Service';
	@override String get and => ' and ';
	@override String get privacy_link => 'Privacy Policy';
	@override String get content_suffix => '. We use anonymous login to protect your privacy.';
	@override String get agree_btn => 'Start';
}

// Path: S01_Onboarding_Name
class _StringsS01OnboardingNameEn implements _StringsS01OnboardingNameZh {
	_StringsS01OnboardingNameEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Set Display Name';
	@override String get description => 'Please enter your display name (1-10 chars).';
	@override String get field_hint => 'Enter nickname';
	@override String field_counter({required Object current}) => '\$${current}/10';
	@override String get error_empty => 'Name cannot be empty';
	@override String get error_too_long => 'Max 10 characters';
	@override String get error_invalid_char => 'Invalid characters';
	@override String get action_next => 'Set';
}

// Path: S04_Invite_Confirm
class _StringsS04InviteConfirmEn implements _StringsS04InviteConfirmZh {
	_StringsS04InviteConfirmEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Join Task';
	@override String get subtitle => 'You are invited to join:';
	@override String get loading_invite => 'Loading invitation...';
	@override String get join_failed_title => 'Oops! Cannot join task';
	@override String get identity_match_title => 'Are you one of these members?';
	@override String get identity_match_desc => 'This task has pre-existing members. If you are one of them, tap the name to link; otherwise, join as a new member.';
	@override String get status_linking => 'Joining by linking account';
	@override String get status_new_member => 'Joining as a new member';
	@override String get action_confirm => 'Join';
	@override String get action_cancel => 'Cancel';
	@override String get action_home => 'Back to Home';
	@override String error_join_failed({required Object message}) => 'Join failed: \$${message}';
	@override String error_generic({required Object message}) => 'Error: \$${message}';
}

// Path: S05_TaskCreate_Form
class _StringsS05TaskCreateFormEn implements _StringsS05TaskCreateFormZh {
	_StringsS05TaskCreateFormEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'New Task';
	@override String get section_name => 'Task Name';
	@override String get section_period => 'Period';
	@override String get section_settings => 'Settings';
	@override String get field_name_hint => 'e.g. Tokyo Trip';
	@override String field_name_counter({required Object current}) => '\$${current}/20';
	@override String get field_start_date => 'Start Date';
	@override String get field_end_date => 'End Date';
	@override String get field_currency => 'Currency';
	@override String get field_member_count => 'Members';
	@override String get action_save => 'Save';
	@override String get picker_done => 'Done';
	@override String get error_name_empty => 'Please enter task name';
	@override String get currency_twd => 'TWD';
	@override String get currency_jpy => 'JPY';
	@override String get currency_usd => 'USD';
}

// Path: D01_InviteJoin_Success
class _StringsD01InviteJoinSuccessEn implements _StringsD01InviteJoinSuccessZh {
	_StringsD01InviteJoinSuccessEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Joined!';
	@override String get assigned_avatar => 'Your assigned animal avatar is:';
	@override String get avatar_note => 'Note: You can redraw your avatar only once.';
	@override String get action_continue => 'Start Tracking';
}

// Path: D02_InviteJoin_Error
class _StringsD02InviteJoinErrorEn implements _StringsD02InviteJoinErrorZh {
	_StringsD02InviteJoinErrorEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cannot Join Task';
	@override String get message => 'The link is invalid, expired, or the task is full.';
	@override String get action_close => 'Close';
}

// Path: D03_TaskCreate_Confirm
class _StringsD03TaskCreateConfirmEn implements _StringsD03TaskCreateConfirmZh {
	_StringsD03TaskCreateConfirmEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirm Settings';
	@override String get label_name => 'Name';
	@override String get label_period => 'Period';
	@override String get label_currency => 'Currency';
	@override String get label_members => 'Members';
	@override String get action_confirm => 'Confirm';
	@override String get action_back => 'Edit';
	@override String get creating_task => 'Creating task...';
	@override String get preparing_share => 'Preparing invite...';
	@override String get share_subject => 'Join Iron Split Task';
	@override String share_message({required Object taskName, required Object code, required Object link}) => 'Join my Iron Split task "\$${taskName}"!\nCode: \$${code}\nLink: \$${link}';
}

// Path: S19_Settings_Tos
class _StringsS19SettingsTosEn implements _StringsS19SettingsTosZh {
	_StringsS19SettingsTosEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terms of Service';
}

// Path: error
class _StringsErrorEn implements _StringsErrorZh {
	_StringsErrorEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override late final _StringsErrorTaskFullEn taskFull = _StringsErrorTaskFullEn._(_root);
	@override late final _StringsErrorExpiredCodeEn expiredCode = _StringsErrorExpiredCodeEn._(_root);
	@override late final _StringsErrorInvalidCodeEn invalidCode = _StringsErrorInvalidCodeEn._(_root);
	@override late final _StringsErrorAuthRequiredEn authRequired = _StringsErrorAuthRequiredEn._(_root);
	@override late final _StringsErrorAlreadyInTaskEn alreadyInTask = _StringsErrorAlreadyInTaskEn._(_root);
	@override late final _StringsErrorUnknownEn unknown = _StringsErrorUnknownEn._(_root);
}

// Path: error.taskFull
class _StringsErrorTaskFullEn implements _StringsErrorTaskFullZh {
	_StringsErrorTaskFullEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Full';
	@override String message({required Object limit}) => 'This task has reached its limit of ${limit} members. Please contact the captain.';
}

// Path: error.expiredCode
class _StringsErrorExpiredCodeEn implements _StringsErrorExpiredCodeZh {
	_StringsErrorExpiredCodeEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invite Expired';
	@override String message({required Object minutes}) => 'This link has expired (${minutes} min TTL). Please request a new one from the captain.';
}

// Path: error.invalidCode
class _StringsErrorInvalidCodeEn implements _StringsErrorInvalidCodeZh {
	_StringsErrorInvalidCodeEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invalid Code';
	@override String get message => 'Invalid invite link. Please check if it\'s correct or has been deleted.';
}

// Path: error.authRequired
class _StringsErrorAuthRequiredEn implements _StringsErrorAuthRequiredZh {
	_StringsErrorAuthRequiredEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Auth Required';
	@override String get message => 'Please log in to join the task.';
}

// Path: error.alreadyInTask
class _StringsErrorAlreadyInTaskEn implements _StringsErrorAlreadyInTaskZh {
	_StringsErrorAlreadyInTaskEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Already a Member';
	@override String get message => 'You are already a member of this task.';
}

// Path: error.unknown
class _StringsErrorUnknownEn implements _StringsErrorUnknownZh {
	_StringsErrorUnknownEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Error';
	@override String get message => 'An unexpected error occurred. Please try again later.';
}

// Path: <root>
class _StringsJa implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsJa.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
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

	@override late final _StringsJa _root = this; // ignore: unused_field

	// Translations
	@override late final _StringsS00OnboardingConsentJa S00_Onboarding_Consent = _StringsS00OnboardingConsentJa._(_root);
	@override late final _StringsS01OnboardingNameJa S01_Onboarding_Name = _StringsS01OnboardingNameJa._(_root);
	@override late final _StringsS04InviteConfirmJa S04_Invite_Confirm = _StringsS04InviteConfirmJa._(_root);
	@override late final _StringsS05TaskCreateFormJa S05_TaskCreate_Form = _StringsS05TaskCreateFormJa._(_root);
	@override late final _StringsD01InviteJoinSuccessJa D01_InviteJoin_Success = _StringsD01InviteJoinSuccessJa._(_root);
	@override late final _StringsD02InviteJoinErrorJa D02_InviteJoin_Error = _StringsD02InviteJoinErrorJa._(_root);
	@override late final _StringsD03TaskCreateConfirmJa D03_TaskCreate_Confirm = _StringsD03TaskCreateConfirmJa._(_root);
	@override late final _StringsS19SettingsTosJa S19_Settings_Tos = _StringsS19SettingsTosJa._(_root);
	@override late final _StringsErrorJa error = _StringsErrorJa._(_root);
}

// Path: S00_Onboarding_Consent
class _StringsS00OnboardingConsentJa implements _StringsS00OnboardingConsentZh {
	_StringsS00OnboardingConsentJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

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
class _StringsS01OnboardingNameJa implements _StringsS01OnboardingNameZh {
	_StringsS01OnboardingNameJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

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
class _StringsS04InviteConfirmJa implements _StringsS04InviteConfirmZh {
	_StringsS04InviteConfirmJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

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
class _StringsS05TaskCreateFormJa implements _StringsS05TaskCreateFormZh {
	_StringsS05TaskCreateFormJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

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
class _StringsD01InviteJoinSuccessJa implements _StringsD01InviteJoinSuccessZh {
	_StringsD01InviteJoinSuccessJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '参加完了！';
	@override String get assigned_avatar => 'あなたの動物アイコンは：';
	@override String get avatar_note => '※アイコンの引き直しは1回のみ可能です。';
	@override String get action_continue => '記録を開始';
}

// Path: D02_InviteJoin_Error
class _StringsD02InviteJoinErrorJa implements _StringsD02InviteJoinErrorZh {
	_StringsD02InviteJoinErrorJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '参加できません';
	@override String get message => 'リンクが無効、期限切れ、または定員に達しています。';
	@override String get action_close => '閉じる';
}

// Path: D03_TaskCreate_Confirm
class _StringsD03TaskCreateConfirmJa implements _StringsD03TaskCreateConfirmZh {
	_StringsD03TaskCreateConfirmJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

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
class _StringsS19SettingsTosJa implements _StringsS19SettingsTosZh {
	_StringsS19SettingsTosJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '利用規約';
}

// Path: error
class _StringsErrorJa implements _StringsErrorZh {
	_StringsErrorJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override late final _StringsErrorTaskFullJa taskFull = _StringsErrorTaskFullJa._(_root);
	@override late final _StringsErrorExpiredCodeJa expiredCode = _StringsErrorExpiredCodeJa._(_root);
	@override late final _StringsErrorInvalidCodeJa invalidCode = _StringsErrorInvalidCodeJa._(_root);
	@override late final _StringsErrorAuthRequiredJa authRequired = _StringsErrorAuthRequiredJa._(_root);
	@override late final _StringsErrorAlreadyInTaskJa alreadyInTask = _StringsErrorAlreadyInTaskJa._(_root);
	@override late final _StringsErrorUnknownJa unknown = _StringsErrorUnknownJa._(_root);
}

// Path: error.taskFull
class _StringsErrorTaskFullJa implements _StringsErrorTaskFullZh {
	_StringsErrorTaskFullJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '定員に達しました';
	@override String message({required Object limit}) => 'このタスクは上限の ${limit} 名に達しています。リーダーに連絡してください。';
}

// Path: error.expiredCode
class _StringsErrorExpiredCodeJa implements _StringsErrorExpiredCodeZh {
	_StringsErrorExpiredCodeJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '招待リンクの期限切れ';
	@override String message({required Object minutes}) => 'リンクの有効期限（${minutes}分）が切れています。リーダーに再発行を依頼してください。';
}

// Path: error.invalidCode
class _StringsErrorInvalidCodeJa implements _StringsErrorInvalidCodeZh {
	_StringsErrorInvalidCodeJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '無効なリンク';
	@override String get message => '招待リンクが無効です。正しいか削除されていないか確認してください。';
}

// Path: error.authRequired
class _StringsErrorAuthRequiredJa implements _StringsErrorAuthRequiredZh {
	_StringsErrorAuthRequiredJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ログインが必要です';
	@override String get message => 'タスクに参加するにはログインが必要です。';
}

// Path: error.alreadyInTask
class _StringsErrorAlreadyInTaskJa implements _StringsErrorAlreadyInTaskZh {
	_StringsErrorAlreadyInTaskJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '既に参加済み';
	@override String get message => 'あなたは既にこのタスクのメンバーです。';
}

// Path: error.unknown
class _StringsErrorUnknownJa implements _StringsErrorUnknownZh {
	_StringsErrorUnknownJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エラー';
	@override String get message => '予期しないエラーが発生しました。後でもう一度お試しください。';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'S00_Onboarding_Consent.title': return '歡迎使用 Iron Split';
			case 'S00_Onboarding_Consent.content_prefix': return '歡迎使用 Iron Split。點擊開始即代表您同意我們的 ';
			case 'S00_Onboarding_Consent.terms_link': return '服務條款';
			case 'S00_Onboarding_Consent.and': return ' 與 ';
			case 'S00_Onboarding_Consent.privacy_link': return '隱私政策';
			case 'S00_Onboarding_Consent.content_suffix': return '。我們採用匿名登入，保障您的隱私。';
			case 'S00_Onboarding_Consent.agree_btn': return '開始使用';
			case 'S01_Onboarding_Name.title': return '名稱設定';
			case 'S01_Onboarding_Name.description': return '請輸入您在 App 內的顯示名稱（1-10 個字）。';
			case 'S01_Onboarding_Name.field_hint': return '輸入暱稱';
			case 'S01_Onboarding_Name.field_counter': return ({required Object current}) => '\$${current}/10';
			case 'S01_Onboarding_Name.error_empty': return '名稱不能為空';
			case 'S01_Onboarding_Name.error_too_long': return '最多 10 個字';
			case 'S01_Onboarding_Name.error_invalid_char': return '包含無效字元';
			case 'S01_Onboarding_Name.action_next': return '設定完成';
			case 'S04_Invite_Confirm.title': return '加入任務';
			case 'S04_Invite_Confirm.subtitle': return '您受邀加入以下任務：';
			case 'S04_Invite_Confirm.loading_invite': return '正在讀取邀請函...';
			case 'S04_Invite_Confirm.join_failed_title': return '哎呀！無法加入任務';
			case 'S04_Invite_Confirm.identity_match_title': return '請問您是以下成員嗎？';
			case 'S04_Invite_Confirm.identity_match_desc': return '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。';
			case 'S04_Invite_Confirm.status_linking': return '將以「連結帳號」方式加入';
			case 'S04_Invite_Confirm.status_new_member': return '將以「新成員」身分加入';
			case 'S04_Invite_Confirm.action_confirm': return '加入';
			case 'S04_Invite_Confirm.action_cancel': return '取消';
			case 'S04_Invite_Confirm.action_home': return '回首頁';
			case 'S04_Invite_Confirm.error_join_failed': return ({required Object message}) => '加入失敗：\$${message}';
			case 'S04_Invite_Confirm.error_generic': return ({required Object message}) => '發生錯誤：\$${message}';
			case 'S05_TaskCreate_Form.title': return '新增任務';
			case 'S05_TaskCreate_Form.section_name': return '任務名稱';
			case 'S05_TaskCreate_Form.section_period': return '任務期間';
			case 'S05_TaskCreate_Form.section_settings': return '結算設定';
			case 'S05_TaskCreate_Form.field_name_hint': return '例如：東京五日遊';
			case 'S05_TaskCreate_Form.field_name_counter': return ({required Object current}) => '\$${current}/20';
			case 'S05_TaskCreate_Form.field_start_date': return '開始日期';
			case 'S05_TaskCreate_Form.field_end_date': return '結束日期';
			case 'S05_TaskCreate_Form.field_currency': return '結算幣別';
			case 'S05_TaskCreate_Form.field_member_count': return '參加人數';
			case 'S05_TaskCreate_Form.action_save': return '保存';
			case 'S05_TaskCreate_Form.picker_done': return '確定';
			case 'S05_TaskCreate_Form.error_name_empty': return '請輸入任務名稱';
			case 'S05_TaskCreate_Form.currency_twd': return '新台幣 (TWD)';
			case 'S05_TaskCreate_Form.currency_jpy': return '日圓 (JPY)';
			case 'S05_TaskCreate_Form.currency_usd': return '美金 (USD)';
			case 'D01_InviteJoin_Success.title': return '成功加入任務！';
			case 'D01_InviteJoin_Success.assigned_avatar': return '你的隨機分配頭像為：';
			case 'D01_InviteJoin_Success.avatar_note': return '註：頭像僅能重抽一次。';
			case 'D01_InviteJoin_Success.action_continue': return '開始記帳';
			case 'D02_InviteJoin_Error.title': return '無法加入任務';
			case 'D02_InviteJoin_Error.message': return '連結無效、已過期或任務人數已達上限。';
			case 'D02_InviteJoin_Error.action_close': return '關閉';
			case 'D03_TaskCreate_Confirm.title': return '確認任務設定';
			case 'D03_TaskCreate_Confirm.label_name': return '任務名稱';
			case 'D03_TaskCreate_Confirm.label_period': return '期間';
			case 'D03_TaskCreate_Confirm.label_currency': return '幣別';
			case 'D03_TaskCreate_Confirm.label_members': return '人數';
			case 'D03_TaskCreate_Confirm.action_confirm': return '確認';
			case 'D03_TaskCreate_Confirm.action_back': return '返回編輯';
			case 'D03_TaskCreate_Confirm.creating_task': return '正在建立任務...';
			case 'D03_TaskCreate_Confirm.preparing_share': return '準備邀請函...';
			case 'D03_TaskCreate_Confirm.share_subject': return '邀請加入 Iron Split 任務';
			case 'D03_TaskCreate_Confirm.share_message': return ({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「\$${taskName}」！\n邀請碼：\$${code}\n連結：\$${link}';
			case 'S19_Settings_Tos.title': return '服務條款';
			case 'error.taskFull.title': return '任務已滿';
			case 'error.taskFull.message': return ({required Object limit}) => '此任務成員數已達上限 ${limit} 人，請聯繫隊長。';
			case 'error.expiredCode.title': return '邀請碼已過期';
			case 'error.expiredCode.message': return ({required Object minutes}) => '此邀請連結已失效（時限 ${minutes} 分鐘）。請請隊長重新產生。';
			case 'error.invalidCode.title': return '連結無效';
			case 'error.invalidCode.message': return '無效的邀請連結，請確認是否正確或已被刪除。';
			case 'error.authRequired.title': return '需要登入';
			case 'error.authRequired.message': return '請先登入後再加入任務。';
			case 'error.alreadyInTask.title': return '您已是成員';
			case 'error.alreadyInTask.message': return '您已經在這個任務中了。';
			case 'error.unknown.title': return '發生錯誤';
			case 'error.unknown.message': return '發生未預期的錯誤，請稍後再試。';
			default: return null;
		}
	}
}

extension on _StringsEn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'S00_Onboarding_Consent.title': return 'Welcome to Iron Split';
			case 'S00_Onboarding_Consent.content_prefix': return 'By clicking Start, you agree to our ';
			case 'S00_Onboarding_Consent.terms_link': return 'Terms of Service';
			case 'S00_Onboarding_Consent.and': return ' and ';
			case 'S00_Onboarding_Consent.privacy_link': return 'Privacy Policy';
			case 'S00_Onboarding_Consent.content_suffix': return '. We use anonymous login to protect your privacy.';
			case 'S00_Onboarding_Consent.agree_btn': return 'Start';
			case 'S01_Onboarding_Name.title': return 'Set Display Name';
			case 'S01_Onboarding_Name.description': return 'Please enter your display name (1-10 chars).';
			case 'S01_Onboarding_Name.field_hint': return 'Enter nickname';
			case 'S01_Onboarding_Name.field_counter': return ({required Object current}) => '\$${current}/10';
			case 'S01_Onboarding_Name.error_empty': return 'Name cannot be empty';
			case 'S01_Onboarding_Name.error_too_long': return 'Max 10 characters';
			case 'S01_Onboarding_Name.error_invalid_char': return 'Invalid characters';
			case 'S01_Onboarding_Name.action_next': return 'Set';
			case 'S04_Invite_Confirm.title': return 'Join Task';
			case 'S04_Invite_Confirm.subtitle': return 'You are invited to join:';
			case 'S04_Invite_Confirm.loading_invite': return 'Loading invitation...';
			case 'S04_Invite_Confirm.join_failed_title': return 'Oops! Cannot join task';
			case 'S04_Invite_Confirm.identity_match_title': return 'Are you one of these members?';
			case 'S04_Invite_Confirm.identity_match_desc': return 'This task has pre-existing members. If you are one of them, tap the name to link; otherwise, join as a new member.';
			case 'S04_Invite_Confirm.status_linking': return 'Joining by linking account';
			case 'S04_Invite_Confirm.status_new_member': return 'Joining as a new member';
			case 'S04_Invite_Confirm.action_confirm': return 'Join';
			case 'S04_Invite_Confirm.action_cancel': return 'Cancel';
			case 'S04_Invite_Confirm.action_home': return 'Back to Home';
			case 'S04_Invite_Confirm.error_join_failed': return ({required Object message}) => 'Join failed: \$${message}';
			case 'S04_Invite_Confirm.error_generic': return ({required Object message}) => 'Error: \$${message}';
			case 'S05_TaskCreate_Form.title': return 'New Task';
			case 'S05_TaskCreate_Form.section_name': return 'Task Name';
			case 'S05_TaskCreate_Form.section_period': return 'Period';
			case 'S05_TaskCreate_Form.section_settings': return 'Settings';
			case 'S05_TaskCreate_Form.field_name_hint': return 'e.g. Tokyo Trip';
			case 'S05_TaskCreate_Form.field_name_counter': return ({required Object current}) => '\$${current}/20';
			case 'S05_TaskCreate_Form.field_start_date': return 'Start Date';
			case 'S05_TaskCreate_Form.field_end_date': return 'End Date';
			case 'S05_TaskCreate_Form.field_currency': return 'Currency';
			case 'S05_TaskCreate_Form.field_member_count': return 'Members';
			case 'S05_TaskCreate_Form.action_save': return 'Save';
			case 'S05_TaskCreate_Form.picker_done': return 'Done';
			case 'S05_TaskCreate_Form.error_name_empty': return 'Please enter task name';
			case 'S05_TaskCreate_Form.currency_twd': return 'TWD';
			case 'S05_TaskCreate_Form.currency_jpy': return 'JPY';
			case 'S05_TaskCreate_Form.currency_usd': return 'USD';
			case 'D01_InviteJoin_Success.title': return 'Task Joined!';
			case 'D01_InviteJoin_Success.assigned_avatar': return 'Your assigned animal avatar is:';
			case 'D01_InviteJoin_Success.avatar_note': return 'Note: You can redraw your avatar only once.';
			case 'D01_InviteJoin_Success.action_continue': return 'Start Tracking';
			case 'D02_InviteJoin_Error.title': return 'Cannot Join Task';
			case 'D02_InviteJoin_Error.message': return 'The link is invalid, expired, or the task is full.';
			case 'D02_InviteJoin_Error.action_close': return 'Close';
			case 'D03_TaskCreate_Confirm.title': return 'Confirm Settings';
			case 'D03_TaskCreate_Confirm.label_name': return 'Name';
			case 'D03_TaskCreate_Confirm.label_period': return 'Period';
			case 'D03_TaskCreate_Confirm.label_currency': return 'Currency';
			case 'D03_TaskCreate_Confirm.label_members': return 'Members';
			case 'D03_TaskCreate_Confirm.action_confirm': return 'Confirm';
			case 'D03_TaskCreate_Confirm.action_back': return 'Edit';
			case 'D03_TaskCreate_Confirm.creating_task': return 'Creating task...';
			case 'D03_TaskCreate_Confirm.preparing_share': return 'Preparing invite...';
			case 'D03_TaskCreate_Confirm.share_subject': return 'Join Iron Split Task';
			case 'D03_TaskCreate_Confirm.share_message': return ({required Object taskName, required Object code, required Object link}) => 'Join my Iron Split task "\$${taskName}"!\nCode: \$${code}\nLink: \$${link}';
			case 'S19_Settings_Tos.title': return 'Terms of Service';
			case 'error.taskFull.title': return 'Task Full';
			case 'error.taskFull.message': return ({required Object limit}) => 'This task has reached its limit of ${limit} members. Please contact the captain.';
			case 'error.expiredCode.title': return 'Invite Expired';
			case 'error.expiredCode.message': return ({required Object minutes}) => 'This link has expired (${minutes} min TTL). Please request a new one from the captain.';
			case 'error.invalidCode.title': return 'Invalid Code';
			case 'error.invalidCode.message': return 'Invalid invite link. Please check if it\'s correct or has been deleted.';
			case 'error.authRequired.title': return 'Auth Required';
			case 'error.authRequired.message': return 'Please log in to join the task.';
			case 'error.alreadyInTask.title': return 'Already a Member';
			case 'error.alreadyInTask.message': return 'You are already a member of this task.';
			case 'error.unknown.title': return 'Error';
			case 'error.unknown.message': return 'An unexpected error occurred. Please try again later.';
			default: return null;
		}
	}
}

extension on _StringsJa {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'S00_Onboarding_Consent.title': return 'Iron Split へようこそ';
			case 'S00_Onboarding_Consent.content_prefix': return '開始することで、';
			case 'S00_Onboarding_Consent.terms_link': return '利用規約';
			case 'S00_Onboarding_Consent.and': return ' と ';
			case 'S00_Onboarding_Consent.privacy_link': return 'プライバシーポリシー';
			case 'S00_Onboarding_Consent.content_suffix': return ' に同意したものとみなされます。';
			case 'S00_Onboarding_Consent.agree_btn': return 'はじめる';
			case 'S01_Onboarding_Name.title': return '名前設定';
			case 'S01_Onboarding_Name.description': return 'アプリ内で表示する名前を入力してください（1-10文字）。';
			case 'S01_Onboarding_Name.field_hint': return 'ニックネームを入力';
			case 'S01_Onboarding_Name.field_counter': return ({required Object current}) => '\$${current}/10';
			case 'S01_Onboarding_Name.error_empty': return '名前を入力してください';
			case 'S01_Onboarding_Name.error_too_long': return '10文字以内で入力してください';
			case 'S01_Onboarding_Name.error_invalid_char': return '無効な文字が含まれています';
			case 'S01_Onboarding_Name.action_next': return '設定';
			case 'S04_Invite_Confirm.title': return 'タスクに参加';
			case 'S04_Invite_Confirm.subtitle': return '以下のタスクに招待されました：';
			case 'S04_Invite_Confirm.loading_invite': return '招待状を読み込んでいます...';
			case 'S04_Invite_Confirm.join_failed_title': return 'おっと！参加できません';
			case 'S04_Invite_Confirm.identity_match_title': return 'あなたはこのメンバーですか？';
			case 'S04_Invite_Confirm.identity_match_desc': return 'このタスクには既定のメンバーリストがあります。該当する場合は名前を選択して連携してください。該当しない場合は、そのまま参加してください。';
			case 'S04_Invite_Confirm.status_linking': return '「アカウント連携」で参加します';
			case 'S04_Invite_Confirm.status_new_member': return '「新規メンバー」として参加します';
			case 'S04_Invite_Confirm.action_confirm': return '参加';
			case 'S04_Invite_Confirm.action_cancel': return 'キャンセル';
			case 'S04_Invite_Confirm.action_home': return 'ホームへ戻る';
			case 'S04_Invite_Confirm.error_join_failed': return ({required Object message}) => '参加失敗：\$${message}';
			case 'S04_Invite_Confirm.error_generic': return ({required Object message}) => 'エラーが発生しました：\$${message}';
			case 'S05_TaskCreate_Form.title': return 'タスク作成';
			case 'S05_TaskCreate_Form.section_name': return 'タスク名';
			case 'S05_TaskCreate_Form.section_period': return '期間';
			case 'S05_TaskCreate_Form.section_settings': return '設定';
			case 'S05_TaskCreate_Form.field_name_hint': return '例：東京5日間の旅';
			case 'S05_TaskCreate_Form.field_name_counter': return ({required Object current}) => '\$${current}/20';
			case 'S05_TaskCreate_Form.field_start_date': return '開始日';
			case 'S05_TaskCreate_Form.field_end_date': return '終了日';
			case 'S05_TaskCreate_Form.field_currency': return '通貨';
			case 'S05_TaskCreate_Form.field_member_count': return '参加人数';
			case 'S05_TaskCreate_Form.action_save': return '保存';
			case 'S05_TaskCreate_Form.picker_done': return '完了';
			case 'S05_TaskCreate_Form.error_name_empty': return 'タスク名を入力してください';
			case 'S05_TaskCreate_Form.currency_twd': return '台湾ドル (TWD)';
			case 'S05_TaskCreate_Form.currency_jpy': return '日本円 (JPY)';
			case 'S05_TaskCreate_Form.currency_usd': return '米ドル (USD)';
			case 'D01_InviteJoin_Success.title': return '参加完了！';
			case 'D01_InviteJoin_Success.assigned_avatar': return 'あなたの動物アイコンは：';
			case 'D01_InviteJoin_Success.avatar_note': return '※アイコンの引き直しは1回のみ可能です。';
			case 'D01_InviteJoin_Success.action_continue': return '記録を開始';
			case 'D02_InviteJoin_Error.title': return '参加できません';
			case 'D02_InviteJoin_Error.message': return 'リンクが無効、期限切れ、または定員に達しています。';
			case 'D02_InviteJoin_Error.action_close': return '閉じる';
			case 'D03_TaskCreate_Confirm.title': return '設定の確認';
			case 'D03_TaskCreate_Confirm.label_name': return 'タスク名';
			case 'D03_TaskCreate_Confirm.label_period': return '期間';
			case 'D03_TaskCreate_Confirm.label_currency': return '通貨';
			case 'D03_TaskCreate_Confirm.label_members': return '人数';
			case 'D03_TaskCreate_Confirm.action_confirm': return '確認';
			case 'D03_TaskCreate_Confirm.action_back': return '編集に戻る';
			case 'D03_TaskCreate_Confirm.creating_task': return '作成中...';
			case 'D03_TaskCreate_Confirm.preparing_share': return '招待を準備中...';
			case 'D03_TaskCreate_Confirm.share_subject': return 'Iron Split タスク招待';
			case 'D03_TaskCreate_Confirm.share_message': return ({required Object taskName, required Object code, required Object link}) => 'Iron Split タスク「\$${taskName}」に参加しよう！\n招待コード：\$${code}\nリンク：\$${link}';
			case 'S19_Settings_Tos.title': return '利用規約';
			case 'error.taskFull.title': return '定員に達しました';
			case 'error.taskFull.message': return ({required Object limit}) => 'このタスクは上限の ${limit} 名に達しています。リーダーに連絡してください。';
			case 'error.expiredCode.title': return '招待リンクの期限切れ';
			case 'error.expiredCode.message': return ({required Object minutes}) => 'リンクの有効期限（${minutes}分）が切れています。リーダーに再発行を依頼してください。';
			case 'error.invalidCode.title': return '無効なリンク';
			case 'error.invalidCode.message': return '招待リンクが無効です。正しいか削除されていないか確認してください。';
			case 'error.authRequired.title': return 'ログインが必要です';
			case 'error.authRequired.message': return 'タスクに参加するにはログインが必要です。';
			case 'error.alreadyInTask.title': return '既に参加済み';
			case 'error.alreadyInTask.message': return 'あなたは既にこのタスクのメンバーです。';
			case 'error.unknown.title': return 'エラー';
			case 'error.unknown.message': return '予期しないエラーが発生しました。後でもう一度お試しください。';
			default: return null;
		}
	}
}
