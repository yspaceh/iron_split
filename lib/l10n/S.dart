import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'S_en.dart';
import 'S_ja.dart';
import 'S_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/S.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh')
  ];

  /// No description provided for @error_TASK_FULL_title.
  ///
  /// In zh, this message translates to:
  /// **'名額已滿'**
  String get error_TASK_FULL_title;

  /// No description provided for @error_TASK_FULL_message.
  ///
  /// In zh, this message translates to:
  /// **'此任務已達 {limit} 人上限，請私訊隊長協助。'**
  String error_TASK_FULL_message(int limit);

  /// No description provided for @error_EXPIRED_CODE_title.
  ///
  /// In zh, this message translates to:
  /// **'邀請碼已過期'**
  String get error_EXPIRED_CODE_title;

  /// No description provided for @error_EXPIRED_CODE_message.
  ///
  /// In zh, this message translates to:
  /// **'邀請連結已失效（有效時間 {minutes} 分鐘），請向隊長索取新連結。'**
  String error_EXPIRED_CODE_message(int minutes);

  /// No description provided for @error_INVALID_CODE_title.
  ///
  /// In zh, this message translates to:
  /// **'邀請碼無效'**
  String get error_INVALID_CODE_title;

  /// No description provided for @error_INVALID_CODE_message.
  ///
  /// In zh, this message translates to:
  /// **'無效的邀請連結，請確認連結是否正確或已遭刪除。'**
  String get error_INVALID_CODE_message;

  /// No description provided for @error_AUTH_REQUIRED_title.
  ///
  /// In zh, this message translates to:
  /// **'需要登入'**
  String get error_AUTH_REQUIRED_title;

  /// No description provided for @error_AUTH_REQUIRED_message.
  ///
  /// In zh, this message translates to:
  /// **'請先完成匿名登入以加入任務。'**
  String get error_AUTH_REQUIRED_message;

  /// No description provided for @error_UNKNOWN_title.
  ///
  /// In zh, this message translates to:
  /// **'發生錯誤'**
  String get error_UNKNOWN_title;

  /// No description provided for @error_UNKNOWN_message.
  ///
  /// In zh, this message translates to:
  /// **'請再試一次，或聯絡隊長協助。代碼：{code}'**
  String error_UNKNOWN_message(string code);

  /// No description provided for @action_confirm.
  ///
  /// In zh, this message translates to:
  /// **'確認'**
  String get action_confirm;

  /// No description provided for @action_retry.
  ///
  /// In zh, this message translates to:
  /// **'重試'**
  String get action_retry;

  /// No description provided for @action_back_home.
  ///
  /// In zh, this message translates to:
  /// **'回首頁'**
  String get action_back_home;

  /// No description provided for @p7_invite_subtitle.
  ///
  /// In zh, this message translates to:
  /// **'您受邀加入以下任務'**
  String get p7_invite_subtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
