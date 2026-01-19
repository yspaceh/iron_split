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
class TranslationsEn with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsS00OnboardingConsentEn S00_Onboarding_Consent = _TranslationsS00OnboardingConsentEn._(_root);
	@override late final _TranslationsS01OnboardingNameEn S01_Onboarding_Name = _TranslationsS01OnboardingNameEn._(_root);
	@override late final _TranslationsS04InviteConfirmEn S04_Invite_Confirm = _TranslationsS04InviteConfirmEn._(_root);
	@override late final _TranslationsS05TaskCreateFormEn S05_TaskCreate_Form = _TranslationsS05TaskCreateFormEn._(_root);
	@override late final _TranslationsD01InviteJoinSuccessEn D01_InviteJoin_Success = _TranslationsD01InviteJoinSuccessEn._(_root);
	@override late final _TranslationsD02InviteJoinErrorEn D02_InviteJoin_Error = _TranslationsD02InviteJoinErrorEn._(_root);
	@override late final _TranslationsD03TaskCreateConfirmEn D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmEn._(_root);
	@override late final _TranslationsS19SettingsTosEn S19_Settings_Tos = _TranslationsS19SettingsTosEn._(_root);
	@override late final _TranslationsErrorEn error = _TranslationsErrorEn._(_root);
}

// Path: S00_Onboarding_Consent
class _TranslationsS00OnboardingConsentEn implements TranslationsS00OnboardingConsentZh {
	_TranslationsS00OnboardingConsentEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
class _TranslationsS01OnboardingNameEn implements TranslationsS01OnboardingNameZh {
	_TranslationsS01OnboardingNameEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
class _TranslationsS04InviteConfirmEn implements TranslationsS04InviteConfirmZh {
	_TranslationsS04InviteConfirmEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
class _TranslationsS05TaskCreateFormEn implements TranslationsS05TaskCreateFormZh {
	_TranslationsS05TaskCreateFormEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
class _TranslationsD01InviteJoinSuccessEn implements TranslationsD01InviteJoinSuccessZh {
	_TranslationsD01InviteJoinSuccessEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Joined!';
	@override String get assigned_avatar => 'Your assigned animal avatar is:';
	@override String get avatar_note => 'Note: You can redraw your avatar only once.';
	@override String get action_continue => 'Start Tracking';
}

// Path: D02_InviteJoin_Error
class _TranslationsD02InviteJoinErrorEn implements TranslationsD02InviteJoinErrorZh {
	_TranslationsD02InviteJoinErrorEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Cannot Join Task';
	@override String get message => 'The link is invalid, expired, or the task is full.';
	@override String get action_close => 'Close';
}

// Path: D03_TaskCreate_Confirm
class _TranslationsD03TaskCreateConfirmEn implements TranslationsD03TaskCreateConfirmZh {
	_TranslationsD03TaskCreateConfirmEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
class _TranslationsS19SettingsTosEn implements TranslationsS19SettingsTosZh {
	_TranslationsS19SettingsTosEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terms of Service';
}

// Path: error
class _TranslationsErrorEn implements TranslationsErrorZh {
	_TranslationsErrorEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorTaskFullEn taskFull = _TranslationsErrorTaskFullEn._(_root);
	@override late final _TranslationsErrorExpiredCodeEn expiredCode = _TranslationsErrorExpiredCodeEn._(_root);
	@override late final _TranslationsErrorInvalidCodeEn invalidCode = _TranslationsErrorInvalidCodeEn._(_root);
	@override late final _TranslationsErrorAuthRequiredEn authRequired = _TranslationsErrorAuthRequiredEn._(_root);
	@override late final _TranslationsErrorAlreadyInTaskEn alreadyInTask = _TranslationsErrorAlreadyInTaskEn._(_root);
	@override late final _TranslationsErrorUnknownEn unknown = _TranslationsErrorUnknownEn._(_root);
}

// Path: error.taskFull
class _TranslationsErrorTaskFullEn implements TranslationsErrorTaskFullZh {
	_TranslationsErrorTaskFullEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Full';
	@override String message({required Object limit}) => 'This task has reached its limit of ${limit} members. Please contact the captain.';
}

// Path: error.expiredCode
class _TranslationsErrorExpiredCodeEn implements TranslationsErrorExpiredCodeZh {
	_TranslationsErrorExpiredCodeEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invite Expired';
	@override String message({required Object minutes}) => 'This link has expired (${minutes} min TTL). Please request a new one from the captain.';
}

// Path: error.invalidCode
class _TranslationsErrorInvalidCodeEn implements TranslationsErrorInvalidCodeZh {
	_TranslationsErrorInvalidCodeEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invalid Code';
	@override String get message => 'Invalid invite link. Please check if it\'s correct or has been deleted.';
}

// Path: error.authRequired
class _TranslationsErrorAuthRequiredEn implements TranslationsErrorAuthRequiredZh {
	_TranslationsErrorAuthRequiredEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Auth Required';
	@override String get message => 'Please log in to join the task.';
}

// Path: error.alreadyInTask
class _TranslationsErrorAlreadyInTaskEn implements TranslationsErrorAlreadyInTaskZh {
	_TranslationsErrorAlreadyInTaskEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Already a Member';
	@override String get message => 'You are already a member of this task.';
}

// Path: error.unknown
class _TranslationsErrorUnknownEn implements TranslationsErrorUnknownZh {
	_TranslationsErrorUnknownEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Error';
	@override String get message => 'An unexpected error occurred. Please try again later.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'S00_Onboarding_Consent.title' => 'Welcome to Iron Split',
			'S00_Onboarding_Consent.content_prefix' => 'By clicking Start, you agree to our ',
			'S00_Onboarding_Consent.terms_link' => 'Terms of Service',
			'S00_Onboarding_Consent.and' => ' and ',
			'S00_Onboarding_Consent.privacy_link' => 'Privacy Policy',
			'S00_Onboarding_Consent.content_suffix' => '. We use anonymous login to protect your privacy.',
			'S00_Onboarding_Consent.agree_btn' => 'Start',
			'S01_Onboarding_Name.title' => 'Set Display Name',
			'S01_Onboarding_Name.description' => 'Please enter your display name (1-10 chars).',
			'S01_Onboarding_Name.field_hint' => 'Enter nickname',
			'S01_Onboarding_Name.field_counter' => ({required Object current}) => '\$${current}/10',
			'S01_Onboarding_Name.error_empty' => 'Name cannot be empty',
			'S01_Onboarding_Name.error_too_long' => 'Max 10 characters',
			'S01_Onboarding_Name.error_invalid_char' => 'Invalid characters',
			'S01_Onboarding_Name.action_next' => 'Set',
			'S04_Invite_Confirm.title' => 'Join Task',
			'S04_Invite_Confirm.subtitle' => 'You are invited to join:',
			'S04_Invite_Confirm.loading_invite' => 'Loading invitation...',
			'S04_Invite_Confirm.join_failed_title' => 'Oops! Cannot join task',
			'S04_Invite_Confirm.identity_match_title' => 'Are you one of these members?',
			'S04_Invite_Confirm.identity_match_desc' => 'This task has pre-existing members. If you are one of them, tap the name to link; otherwise, join as a new member.',
			'S04_Invite_Confirm.status_linking' => 'Joining by linking account',
			'S04_Invite_Confirm.status_new_member' => 'Joining as a new member',
			'S04_Invite_Confirm.action_confirm' => 'Join',
			'S04_Invite_Confirm.action_cancel' => 'Cancel',
			'S04_Invite_Confirm.action_home' => 'Back to Home',
			'S04_Invite_Confirm.error_join_failed' => ({required Object message}) => 'Join failed: \$${message}',
			'S04_Invite_Confirm.error_generic' => ({required Object message}) => 'Error: \$${message}',
			'S05_TaskCreate_Form.title' => 'New Task',
			'S05_TaskCreate_Form.section_name' => 'Task Name',
			'S05_TaskCreate_Form.section_period' => 'Period',
			'S05_TaskCreate_Form.section_settings' => 'Settings',
			'S05_TaskCreate_Form.field_name_hint' => 'e.g. Tokyo Trip',
			'S05_TaskCreate_Form.field_name_counter' => ({required Object current}) => '\$${current}/20',
			'S05_TaskCreate_Form.field_start_date' => 'Start Date',
			'S05_TaskCreate_Form.field_end_date' => 'End Date',
			'S05_TaskCreate_Form.field_currency' => 'Currency',
			'S05_TaskCreate_Form.field_member_count' => 'Members',
			'S05_TaskCreate_Form.action_save' => 'Save',
			'S05_TaskCreate_Form.picker_done' => 'Done',
			'S05_TaskCreate_Form.error_name_empty' => 'Please enter task name',
			'S05_TaskCreate_Form.currency_twd' => 'TWD',
			'S05_TaskCreate_Form.currency_jpy' => 'JPY',
			'S05_TaskCreate_Form.currency_usd' => 'USD',
			'D01_InviteJoin_Success.title' => 'Task Joined!',
			'D01_InviteJoin_Success.assigned_avatar' => 'Your assigned animal avatar is:',
			'D01_InviteJoin_Success.avatar_note' => 'Note: You can redraw your avatar only once.',
			'D01_InviteJoin_Success.action_continue' => 'Start Tracking',
			'D02_InviteJoin_Error.title' => 'Cannot Join Task',
			'D02_InviteJoin_Error.message' => 'The link is invalid, expired, or the task is full.',
			'D02_InviteJoin_Error.action_close' => 'Close',
			'D03_TaskCreate_Confirm.title' => 'Confirm Settings',
			'D03_TaskCreate_Confirm.label_name' => 'Name',
			'D03_TaskCreate_Confirm.label_period' => 'Period',
			'D03_TaskCreate_Confirm.label_currency' => 'Currency',
			'D03_TaskCreate_Confirm.label_members' => 'Members',
			'D03_TaskCreate_Confirm.action_confirm' => 'Confirm',
			'D03_TaskCreate_Confirm.action_back' => 'Edit',
			'D03_TaskCreate_Confirm.creating_task' => 'Creating task...',
			'D03_TaskCreate_Confirm.preparing_share' => 'Preparing invite...',
			'D03_TaskCreate_Confirm.share_subject' => 'Join Iron Split Task',
			'D03_TaskCreate_Confirm.share_message' => ({required Object taskName, required Object code, required Object link}) => 'Join my Iron Split task "\$${taskName}"!\nCode: \$${code}\nLink: \$${link}',
			'S19_Settings_Tos.title' => 'Terms of Service',
			'error.taskFull.title' => 'Task Full',
			'error.taskFull.message' => ({required Object limit}) => 'This task has reached its limit of ${limit} members. Please contact the captain.',
			'error.expiredCode.title' => 'Invite Expired',
			'error.expiredCode.message' => ({required Object minutes}) => 'This link has expired (${minutes} min TTL). Please request a new one from the captain.',
			'error.invalidCode.title' => 'Invalid Code',
			'error.invalidCode.message' => 'Invalid invite link. Please check if it\'s correct or has been deleted.',
			'error.authRequired.title' => 'Auth Required',
			'error.authRequired.message' => 'Please log in to join the task.',
			'error.alreadyInTask.title' => 'Already a Member',
			'error.alreadyInTask.message' => 'You are already a member of this task.',
			'error.unknown.title' => 'Error',
			'error.unknown.message' => 'An unexpected error occurred. Please try again later.',
			_ => null,
		};
	}
}
