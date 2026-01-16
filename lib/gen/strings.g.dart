/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 3
/// Strings: 171 (57 per locale)
///
/// Built on 2026-01-16 at 10:10 UTC

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
	String get content_prefix => '歡迎使用 Iron Split，在開始算錢任務之前，請先同意我們的 ';
	String get content_suffix => '。我們僅使用匿名帳號，資料將於任務結算 30 天後清除。';
	String get agree_btn => '同意並開始使用';
}

// Path: S01_Onboarding_Name
class _StringsS01OnboardingNameZh {
	_StringsS01OnboardingNameZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => '你是誰？';
	String get hint => '輸入你的顯示名稱';
	String get next_btn => '下一步';
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
	String get title => '建立新任務';
	String get field_name_label => '任務名稱';
	String get field_name_hint => '例如：東京五日遊';
	String get field_name_error => '請輸入任務名稱';
	String get action_create => '建立並邀請成員';
	String get creating => '建立中...';
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
	String get title => '邀請成員';
	String get share_btn => '分享邀請連結';
	String share_subject({required Object taskName}) => '邀請加入 \$${taskName}';
	String share_text({required Object taskName, required Object inviteCode, required Object link}) => '快來加入我的 Iron Split 任務「\$${taskName}」！\n邀請碼：\$${inviteCode}\n連結：\$${link}';
	String get copy_toast => '已複製邀請碼';
	String expires_hint({required Object time}) => '有效至 \$${time}（15分鐘）';
	String get done_btn => '完成';
	String error_create_failed({required Object message}) => '產生失敗：\$${message}';
	String get debug_switch_user => '切換身分測試加入';
	String get debug_switched => '已切換新身分';
	String debug_switch_fail({required Object message}) => '切換失敗：\$${message}';
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
	@override String get content_prefix => 'Welcome to Iron Split. Before starting, please agree to our ';
	@override String get content_suffix => '. We use anonymous accounts, and data is cleared 30 days after settlement.';
	@override String get agree_btn => 'Agree and Start';
}

// Path: S01_Onboarding_Name
class _StringsS01OnboardingNameEn implements _StringsS01OnboardingNameZh {
	_StringsS01OnboardingNameEn._(this._root);

	@override final _StringsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Who are you?';
	@override String get hint => 'Enter your display name';
	@override String get next_btn => 'Next';
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
	@override String get title => 'Create New Task';
	@override String get field_name_label => 'Task Name';
	@override String get field_name_hint => 'e.g. Tokyo Trip';
	@override String get field_name_error => 'Please enter task name';
	@override String get action_create => 'Create & Invite';
	@override String get creating => 'Creating...';
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
	@override String get title => 'Invite Members';
	@override String get share_btn => 'Share Invite Link';
	@override String share_subject({required Object taskName}) => 'Join \$${taskName}';
	@override String share_text({required Object taskName, required Object inviteCode, required Object link}) => 'Join my Iron Split task "\$${taskName}"!\nCode: \$${inviteCode}\nLink: \$${link}';
	@override String get copy_toast => 'Invite code copied';
	@override String expires_hint({required Object time}) => 'Valid until \$${time} (15 mins)';
	@override String get done_btn => 'Done';
	@override String error_create_failed({required Object message}) => 'Failed to generate: \$${message}';
	@override String get debug_switch_user => 'Switch Identity (Test)';
	@override String get debug_switched => 'Switched to new identity';
	@override String debug_switch_fail({required Object message}) => 'Switch failed: \$${message}';
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
	@override String get content_prefix => 'Iron Split へようこそ。タスクを開始する前に、';
	@override String get content_suffix => 'に同意してください。本アプリは匿名アカウントを使用し、データは結算から30日後に削除されます。';
	@override String get agree_btn => '同意して開始';
}

// Path: S01_Onboarding_Name
class _StringsS01OnboardingNameJa implements _StringsS01OnboardingNameZh {
	_StringsS01OnboardingNameJa._(this._root);

	@override final _StringsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'お名前は？';
	@override String get hint => '表示名を入力してください';
	@override String get next_btn => '次へ';
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
	@override String get title => '新規タスク作成';
	@override String get field_name_label => 'タスク名';
	@override String get field_name_hint => '例：東京5日間の旅';
	@override String get field_name_error => 'タスク名を入力してください';
	@override String get action_create => '作成して招待';
	@override String get creating => '作成中...';
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
	@override String get title => 'メンバーを招待';
	@override String get share_btn => '招待リンクを共有';
	@override String share_subject({required Object taskName}) => '\$${taskName} に参加';
	@override String share_text({required Object taskName, required Object inviteCode, required Object link}) => 'Iron Split タスク「\$${taskName}」に参加しよう！\n招待コード：\$${inviteCode}\nリンク：\$${link}';
	@override String get copy_toast => '招待コードをコピーしました';
	@override String expires_hint({required Object time}) => '有効期限：\$${time}（15分）';
	@override String get done_btn => '完了';
	@override String error_create_failed({required Object message}) => '生成失敗：\$${message}';
	@override String get debug_switch_user => 'ID切替（テスト用）';
	@override String get debug_switched => '新しいIDに切り替えました';
	@override String debug_switch_fail({required Object message}) => '切替失敗：\$${message}';
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
			case 'S00_Onboarding_Consent.content_prefix': return '歡迎使用 Iron Split，在開始算錢任務之前，請先同意我們的 ';
			case 'S00_Onboarding_Consent.content_suffix': return '。我們僅使用匿名帳號，資料將於任務結算 30 天後清除。';
			case 'S00_Onboarding_Consent.agree_btn': return '同意並開始使用';
			case 'S01_Onboarding_Name.title': return '你是誰？';
			case 'S01_Onboarding_Name.hint': return '輸入你的顯示名稱';
			case 'S01_Onboarding_Name.next_btn': return '下一步';
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
			case 'S05_TaskCreate_Form.title': return '建立新任務';
			case 'S05_TaskCreate_Form.field_name_label': return '任務名稱';
			case 'S05_TaskCreate_Form.field_name_hint': return '例如：東京五日遊';
			case 'S05_TaskCreate_Form.field_name_error': return '請輸入任務名稱';
			case 'S05_TaskCreate_Form.action_create': return '建立並邀請成員';
			case 'S05_TaskCreate_Form.creating': return '建立中...';
			case 'D01_InviteJoin_Success.title': return '成功加入任務！';
			case 'D01_InviteJoin_Success.assigned_avatar': return '你的隨機分配頭像為：';
			case 'D01_InviteJoin_Success.avatar_note': return '註：頭像僅能重抽一次。';
			case 'D01_InviteJoin_Success.action_continue': return '開始記帳';
			case 'D02_InviteJoin_Error.title': return '無法加入任務';
			case 'D02_InviteJoin_Error.message': return '連結無效、已過期或任務人數已達上限。';
			case 'D02_InviteJoin_Error.action_close': return '關閉';
			case 'D03_TaskCreate_Confirm.title': return '邀請成員';
			case 'D03_TaskCreate_Confirm.share_btn': return '分享邀請連結';
			case 'D03_TaskCreate_Confirm.share_subject': return ({required Object taskName}) => '邀請加入 \$${taskName}';
			case 'D03_TaskCreate_Confirm.share_text': return ({required Object taskName, required Object inviteCode, required Object link}) => '快來加入我的 Iron Split 任務「\$${taskName}」！\n邀請碼：\$${inviteCode}\n連結：\$${link}';
			case 'D03_TaskCreate_Confirm.copy_toast': return '已複製邀請碼';
			case 'D03_TaskCreate_Confirm.expires_hint': return ({required Object time}) => '有效至 \$${time}（15分鐘）';
			case 'D03_TaskCreate_Confirm.done_btn': return '完成';
			case 'D03_TaskCreate_Confirm.error_create_failed': return ({required Object message}) => '產生失敗：\$${message}';
			case 'D03_TaskCreate_Confirm.debug_switch_user': return '切換身分測試加入';
			case 'D03_TaskCreate_Confirm.debug_switched': return '已切換新身分';
			case 'D03_TaskCreate_Confirm.debug_switch_fail': return ({required Object message}) => '切換失敗：\$${message}';
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
			case 'S00_Onboarding_Consent.content_prefix': return 'Welcome to Iron Split. Before starting, please agree to our ';
			case 'S00_Onboarding_Consent.content_suffix': return '. We use anonymous accounts, and data is cleared 30 days after settlement.';
			case 'S00_Onboarding_Consent.agree_btn': return 'Agree and Start';
			case 'S01_Onboarding_Name.title': return 'Who are you?';
			case 'S01_Onboarding_Name.hint': return 'Enter your display name';
			case 'S01_Onboarding_Name.next_btn': return 'Next';
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
			case 'S05_TaskCreate_Form.title': return 'Create New Task';
			case 'S05_TaskCreate_Form.field_name_label': return 'Task Name';
			case 'S05_TaskCreate_Form.field_name_hint': return 'e.g. Tokyo Trip';
			case 'S05_TaskCreate_Form.field_name_error': return 'Please enter task name';
			case 'S05_TaskCreate_Form.action_create': return 'Create & Invite';
			case 'S05_TaskCreate_Form.creating': return 'Creating...';
			case 'D01_InviteJoin_Success.title': return 'Task Joined!';
			case 'D01_InviteJoin_Success.assigned_avatar': return 'Your assigned animal avatar is:';
			case 'D01_InviteJoin_Success.avatar_note': return 'Note: You can redraw your avatar only once.';
			case 'D01_InviteJoin_Success.action_continue': return 'Start Tracking';
			case 'D02_InviteJoin_Error.title': return 'Cannot Join Task';
			case 'D02_InviteJoin_Error.message': return 'The link is invalid, expired, or the task is full.';
			case 'D02_InviteJoin_Error.action_close': return 'Close';
			case 'D03_TaskCreate_Confirm.title': return 'Invite Members';
			case 'D03_TaskCreate_Confirm.share_btn': return 'Share Invite Link';
			case 'D03_TaskCreate_Confirm.share_subject': return ({required Object taskName}) => 'Join \$${taskName}';
			case 'D03_TaskCreate_Confirm.share_text': return ({required Object taskName, required Object inviteCode, required Object link}) => 'Join my Iron Split task "\$${taskName}"!\nCode: \$${inviteCode}\nLink: \$${link}';
			case 'D03_TaskCreate_Confirm.copy_toast': return 'Invite code copied';
			case 'D03_TaskCreate_Confirm.expires_hint': return ({required Object time}) => 'Valid until \$${time} (15 mins)';
			case 'D03_TaskCreate_Confirm.done_btn': return 'Done';
			case 'D03_TaskCreate_Confirm.error_create_failed': return ({required Object message}) => 'Failed to generate: \$${message}';
			case 'D03_TaskCreate_Confirm.debug_switch_user': return 'Switch Identity (Test)';
			case 'D03_TaskCreate_Confirm.debug_switched': return 'Switched to new identity';
			case 'D03_TaskCreate_Confirm.debug_switch_fail': return ({required Object message}) => 'Switch failed: \$${message}';
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
			case 'S00_Onboarding_Consent.content_prefix': return 'Iron Split へようこそ。タスクを開始する前に、';
			case 'S00_Onboarding_Consent.content_suffix': return 'に同意してください。本アプリは匿名アカウントを使用し、データは結算から30日後に削除されます。';
			case 'S00_Onboarding_Consent.agree_btn': return '同意して開始';
			case 'S01_Onboarding_Name.title': return 'お名前は？';
			case 'S01_Onboarding_Name.hint': return '表示名を入力してください';
			case 'S01_Onboarding_Name.next_btn': return '次へ';
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
			case 'S05_TaskCreate_Form.title': return '新規タスク作成';
			case 'S05_TaskCreate_Form.field_name_label': return 'タスク名';
			case 'S05_TaskCreate_Form.field_name_hint': return '例：東京5日間の旅';
			case 'S05_TaskCreate_Form.field_name_error': return 'タスク名を入力してください';
			case 'S05_TaskCreate_Form.action_create': return '作成して招待';
			case 'S05_TaskCreate_Form.creating': return '作成中...';
			case 'D01_InviteJoin_Success.title': return '参加完了！';
			case 'D01_InviteJoin_Success.assigned_avatar': return 'あなたの動物アイコンは：';
			case 'D01_InviteJoin_Success.avatar_note': return '※アイコンの引き直しは1回のみ可能です。';
			case 'D01_InviteJoin_Success.action_continue': return '記録を開始';
			case 'D02_InviteJoin_Error.title': return '参加できません';
			case 'D02_InviteJoin_Error.message': return 'リンクが無効、期限切れ、または定員に達しています。';
			case 'D02_InviteJoin_Error.action_close': return '閉じる';
			case 'D03_TaskCreate_Confirm.title': return 'メンバーを招待';
			case 'D03_TaskCreate_Confirm.share_btn': return '招待リンクを共有';
			case 'D03_TaskCreate_Confirm.share_subject': return ({required Object taskName}) => '\$${taskName} に参加';
			case 'D03_TaskCreate_Confirm.share_text': return ({required Object taskName, required Object inviteCode, required Object link}) => 'Iron Split タスク「\$${taskName}」に参加しよう！\n招待コード：\$${inviteCode}\nリンク：\$${link}';
			case 'D03_TaskCreate_Confirm.copy_toast': return '招待コードをコピーしました';
			case 'D03_TaskCreate_Confirm.expires_hint': return ({required Object time}) => '有効期限：\$${time}（15分）';
			case 'D03_TaskCreate_Confirm.done_btn': return '完了';
			case 'D03_TaskCreate_Confirm.error_create_failed': return ({required Object message}) => '生成失敗：\$${message}';
			case 'D03_TaskCreate_Confirm.debug_switch_user': return 'ID切替（テスト用）';
			case 'D03_TaskCreate_Confirm.debug_switched': return '新しいIDに切り替えました';
			case 'D03_TaskCreate_Confirm.debug_switch_fail': return ({required Object message}) => '切替失敗：\$${message}';
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
