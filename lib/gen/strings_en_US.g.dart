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
class TranslationsEnUs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEnUs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.enUs,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en-US>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsEnUs _root = this; // ignore: unused_field

	@override 
	TranslationsEnUs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEnUs(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonEnUs common = _TranslationsCommonEnUs._(_root);
	@override late final _TranslationsLogActionEnUs log_action = _TranslationsLogActionEnUs._(_root);
	@override late final _TranslationsS10HomeTaskListEnUs S10_Home_TaskList = _TranslationsS10HomeTaskListEnUs._(_root);
	@override late final _TranslationsS11InviteConfirmEnUs S11_Invite_Confirm = _TranslationsS11InviteConfirmEnUs._(_root);
	@override late final _TranslationsS12TaskCloseNoticeEnUs S12_TaskClose_Notice = _TranslationsS12TaskCloseNoticeEnUs._(_root);
	@override late final _TranslationsS13TaskDashboardEnUs S13_Task_Dashboard = _TranslationsS13TaskDashboardEnUs._(_root);
	@override late final _TranslationsS14TaskSettingsEnUs S14_Task_Settings = _TranslationsS14TaskSettingsEnUs._(_root);
	@override late final _TranslationsS15RecordEditEnUs S15_Record_Edit = _TranslationsS15RecordEditEnUs._(_root);
	@override late final _TranslationsS16TaskCreateEditEnUs S16_TaskCreate_Edit = _TranslationsS16TaskCreateEditEnUs._(_root);
	@override late final _TranslationsS17TaskLockedEnUs S17_Task_Locked = _TranslationsS17TaskLockedEnUs._(_root);
	@override late final _TranslationsS18TaskJoinEnUs S18_Task_Join = _TranslationsS18TaskJoinEnUs._(_root);
	@override late final _TranslationsS30SettlementConfirmEnUs S30_settlement_confirm = _TranslationsS30SettlementConfirmEnUs._(_root);
	@override late final _TranslationsS31SettlementPaymentInfoEnUs S31_settlement_payment_info = _TranslationsS31SettlementPaymentInfoEnUs._(_root);
	@override late final _TranslationsS32SettlementResultEnUs S32_settlement_result = _TranslationsS32SettlementResultEnUs._(_root);
	@override late final _TranslationsS50OnboardingConsentEnUs S50_Onboarding_Consent = _TranslationsS50OnboardingConsentEnUs._(_root);
	@override late final _TranslationsS51OnboardingNameEnUs S51_Onboarding_Name = _TranslationsS51OnboardingNameEnUs._(_root);
	@override late final _TranslationsS52TaskSettingsLogEnUs S52_TaskSettings_Log = _TranslationsS52TaskSettingsLogEnUs._(_root);
	@override late final _TranslationsS53TaskSettingsMembersEnUs S53_TaskSettings_Members = _TranslationsS53TaskSettingsMembersEnUs._(_root);
	@override late final _TranslationsS54TaskSettingsInviteEnUs S54_TaskSettings_Invite = _TranslationsS54TaskSettingsInviteEnUs._(_root);
	@override late final _TranslationsS70SystemSettingsEnUs S70_System_Settings = _TranslationsS70SystemSettingsEnUs._(_root);
	@override late final _TranslationsS72TermsUpdateEnUs S72_TermsUpdate = _TranslationsS72TermsUpdateEnUs._(_root);
	@override late final _TranslationsS74DeleteAccountNoticeEnUs S74_DeleteAccount_Notice = _TranslationsS74DeleteAccountNoticeEnUs._(_root);
	@override late final _TranslationsD01MemberRoleIntroEnUs D01_MemberRole_Intro = _TranslationsD01MemberRoleIntroEnUs._(_root);
	@override late final _TranslationsD02InviteResultEnUs D02_Invite_Result = _TranslationsD02InviteResultEnUs._(_root);
	@override late final _TranslationsD03TaskCreateConfirmEnUs D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmEnUs._(_root);
	@override late final _TranslationsD04CommonUnsavedConfirmEnUs D04_CommonUnsaved_Confirm = _TranslationsD04CommonUnsavedConfirmEnUs._(_root);
	@override late final _TranslationsD05DateJumpNoResultEnUs D05_DateJump_NoResult = _TranslationsD05DateJumpNoResultEnUs._(_root);
	@override late final _TranslationsD06SettlementConfirmEnUs D06_settlement_confirm = _TranslationsD06SettlementConfirmEnUs._(_root);
	@override late final _TranslationsD08TaskClosedConfirmEnUs D08_TaskClosed_Confirm = _TranslationsD08TaskClosedConfirmEnUs._(_root);
	@override late final _TranslationsD09TaskSettingsCurrencyConfirmEnUs D09_TaskSettings_CurrencyConfirm = _TranslationsD09TaskSettingsCurrencyConfirmEnUs._(_root);
	@override late final _TranslationsD10RecordDeleteConfirmEnUs D10_RecordDelete_Confirm = _TranslationsD10RecordDeleteConfirmEnUs._(_root);
	@override late final _TranslationsD11RandomResultEnUs D11_random_result = _TranslationsD11RandomResultEnUs._(_root);
	@override late final _TranslationsD12LogoutConfirmEnUs D12_logout_confirm = _TranslationsD12LogoutConfirmEnUs._(_root);
	@override late final _TranslationsD13DeleteAccountConfirmEnUs D13_DeleteAccount_Confirm = _TranslationsD13DeleteAccountConfirmEnUs._(_root);
	@override late final _TranslationsD14DateSelectEnUs D14_Date_Select = _TranslationsD14DateSelectEnUs._(_root);
	@override late final _TranslationsB02SplitExpenseEditEnUs B02_SplitExpense_Edit = _TranslationsB02SplitExpenseEditEnUs._(_root);
	@override late final _TranslationsB03SplitMethodEditEnUs B03_SplitMethod_Edit = _TranslationsB03SplitMethodEditEnUs._(_root);
	@override late final _TranslationsB04PaymentMergeEnUs B04_payment_merge = _TranslationsB04PaymentMergeEnUs._(_root);
	@override late final _TranslationsB07PaymentMethodEditEnUs B07_PaymentMethod_Edit = _TranslationsB07PaymentMethodEditEnUs._(_root);
	@override late final _TranslationsSuccessEnUs success = _TranslationsSuccessEnUs._(_root);
	@override late final _TranslationsErrorEnUs error = _TranslationsErrorEnUs._(_root);
}

// Path: common
class _TranslationsCommonEnUs extends TranslationsCommonZhTw {
	_TranslationsCommonEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonButtonsEnUs buttons = _TranslationsCommonButtonsEnUs._(_root);
	@override late final _TranslationsCommonLabelEnUs label = _TranslationsCommonLabelEnUs._(_root);
	@override late final _TranslationsCommonCategoryEnUs category = _TranslationsCommonCategoryEnUs._(_root);
	@override late final _TranslationsCommonCurrencyEnUs currency = _TranslationsCommonCurrencyEnUs._(_root);
	@override late final _TranslationsCommonPaymentInfoEnUs payment_info = _TranslationsCommonPaymentInfoEnUs._(_root);
	@override late final _TranslationsCommonPaymentStatusEnUs payment_status = _TranslationsCommonPaymentStatusEnUs._(_root);
	@override late final _TranslationsCommonAvatarEnUs avatar = _TranslationsCommonAvatarEnUs._(_root);
	@override late final _TranslationsCommonRemainderRuleEnUs remainder_rule = _TranslationsCommonRemainderRuleEnUs._(_root);
	@override late final _TranslationsCommonSplitMethodEnUs split_method = _TranslationsCommonSplitMethodEnUs._(_root);
	@override late final _TranslationsCommonPaymentMethodEnUs payment_method = _TranslationsCommonPaymentMethodEnUs._(_root);
	@override late final _TranslationsCommonLanguageEnUs language = _TranslationsCommonLanguageEnUs._(_root);
	@override late final _TranslationsCommonThemeEnUs theme = _TranslationsCommonThemeEnUs._(_root);
	@override late final _TranslationsCommonDisplayEnUs display = _TranslationsCommonDisplayEnUs._(_root);
	@override late final _TranslationsCommonTermsEnUs terms = _TranslationsCommonTermsEnUs._(_root);
	@override late final _TranslationsCommonShareEnUs share = _TranslationsCommonShareEnUs._(_root);
	@override String get preparing => 'Preparing...';
	@override String get me => 'Me';
	@override String get required => 'Required';
	@override String get member_prefix => 'Member';
	@override String get no_record => 'No Record';
	@override String get today => 'Today';
}

// Path: log_action
class _TranslationsLogActionEnUs extends TranslationsLogActionZhTw {
	_TranslationsLogActionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get create_task => 'Create Task';
	@override String get update_settings => 'Update Settings';
	@override String get add_member => 'Add Member';
	@override String get remove_member => 'Remove Member';
	@override String get create_record => 'Create Record';
	@override String get update_record => 'Edit Record';
	@override String get delete_record => 'Delete Record';
	@override String get settle_up => 'Settle Up';
	@override String get unknown => 'Unknown Action';
	@override String get close_task => 'Close Task';
}

// Path: S10_Home_TaskList
class _TranslationsS10HomeTaskListEnUs extends TranslationsS10HomeTaskListZhTw {
	_TranslationsS10HomeTaskListEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task List';
	@override late final _TranslationsS10HomeTaskListTabEnUs tab = _TranslationsS10HomeTaskListTabEnUs._(_root);
	@override late final _TranslationsS10HomeTaskListEmptyEnUs empty = _TranslationsS10HomeTaskListEmptyEnUs._(_root);
	@override late final _TranslationsS10HomeTaskListButtonsEnUs buttons = _TranslationsS10HomeTaskListButtonsEnUs._(_root);
	@override String get date_tbd => 'Date TBD';
	@override late final _TranslationsS10HomeTaskListLabelEnUs label = _TranslationsS10HomeTaskListLabelEnUs._(_root);
}

// Path: S11_Invite_Confirm
class _TranslationsS11InviteConfirmEnUs extends TranslationsS11InviteConfirmZhTw {
	_TranslationsS11InviteConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Join Task';
	@override String get subtitle => 'Invitation to join:';
	@override late final _TranslationsS11InviteConfirmButtonsEnUs buttons = _TranslationsS11InviteConfirmButtonsEnUs._(_root);
	@override late final _TranslationsS11InviteConfirmLabelEnUs label = _TranslationsS11InviteConfirmLabelEnUs._(_root);
}

// Path: S12_TaskClose_Notice
class _TranslationsS12TaskCloseNoticeEnUs extends TranslationsS12TaskCloseNoticeZhTw {
	_TranslationsS12TaskCloseNoticeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Close Task';
	@override late final _TranslationsS12TaskCloseNoticeButtonsEnUs buttons = _TranslationsS12TaskCloseNoticeButtonsEnUs._(_root);
	@override String get content => 'Closing this task will lock all records and settings. The task will enter read-only mode, and no data can be added or edited.';
}

// Path: S13_Task_Dashboard
class _TranslationsS13TaskDashboardEnUs extends TranslationsS13TaskDashboardZhTw {
	_TranslationsS13TaskDashboardEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dashboard';
	@override late final _TranslationsS13TaskDashboardButtonsEnUs buttons = _TranslationsS13TaskDashboardButtonsEnUs._(_root);
	@override late final _TranslationsS13TaskDashboardTabEnUs tab = _TranslationsS13TaskDashboardTabEnUs._(_root);
	@override late final _TranslationsS13TaskDashboardLabelEnUs label = _TranslationsS13TaskDashboardLabelEnUs._(_root);
	@override late final _TranslationsS13TaskDashboardEmptyEnUs empty = _TranslationsS13TaskDashboardEmptyEnUs._(_root);
	@override String get daily_expense_label => 'Expense';
	@override String get dialog_balance_detail => 'Balance Details';
	@override late final _TranslationsS13TaskDashboardSectionEnUs section = _TranslationsS13TaskDashboardSectionEnUs._(_root);
}

// Path: S14_Task_Settings
class _TranslationsS14TaskSettingsEnUs extends TranslationsS14TaskSettingsZhTw {
	_TranslationsS14TaskSettingsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Settings';
	@override late final _TranslationsS14TaskSettingsSectionEnUs section = _TranslationsS14TaskSettingsSectionEnUs._(_root);
	@override late final _TranslationsS14TaskSettingsMenuEnUs menu = _TranslationsS14TaskSettingsMenuEnUs._(_root);
}

// Path: S15_Record_Edit
class _TranslationsS15RecordEditEnUs extends TranslationsS15RecordEditZhTw {
	_TranslationsS15RecordEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsS15RecordEditTitleEnUs title = _TranslationsS15RecordEditTitleEnUs._(_root);
	@override late final _TranslationsS15RecordEditButtonsEnUs buttons = _TranslationsS15RecordEditButtonsEnUs._(_root);
	@override late final _TranslationsS15RecordEditSectionEnUs section = _TranslationsS15RecordEditSectionEnUs._(_root);
	@override late final _TranslationsS15RecordEditValEnUs val = _TranslationsS15RecordEditValEnUs._(_root);
	@override late final _TranslationsS15RecordEditTabEnUs tab = _TranslationsS15RecordEditTabEnUs._(_root);
	@override String get base_card => 'Remaining Amount';
	@override String get type_prepay => 'Prepaid';
	@override String get payer_multiple => 'Multiple';
	@override late final _TranslationsS15RecordEditRateDialogEnUs rate_dialog = _TranslationsS15RecordEditRateDialogEnUs._(_root);
	@override late final _TranslationsS15RecordEditLabelEnUs label = _TranslationsS15RecordEditLabelEnUs._(_root);
	@override late final _TranslationsS15RecordEditHintEnUs hint = _TranslationsS15RecordEditHintEnUs._(_root);
}

// Path: S16_TaskCreate_Edit
class _TranslationsS16TaskCreateEditEnUs extends TranslationsS16TaskCreateEditZhTw {
	_TranslationsS16TaskCreateEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'New Task';
	@override late final _TranslationsS16TaskCreateEditSectionEnUs section = _TranslationsS16TaskCreateEditSectionEnUs._(_root);
	@override late final _TranslationsS16TaskCreateEditLabelEnUs label = _TranslationsS16TaskCreateEditLabelEnUs._(_root);
	@override late final _TranslationsS16TaskCreateEditHintEnUs hint = _TranslationsS16TaskCreateEditHintEnUs._(_root);
}

// Path: S17_Task_Locked
class _TranslationsS17TaskLockedEnUs extends TranslationsS17TaskLockedZhTw {
	_TranslationsS17TaskLockedEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsS17TaskLockedButtonsEnUs buttons = _TranslationsS17TaskLockedButtonsEnUs._(_root);
	@override late final _TranslationsS17TaskLockedSectionEnUs section = _TranslationsS17TaskLockedSectionEnUs._(_root);
	@override String retention_notice({required Object days}) => 'Data will be deleted in ${days} days. Download data before deletion.';
	@override String remainder_absorbed_by({required Object name}) => 'Absorbed by ${name}';
	@override late final _TranslationsS17TaskLockedExportEnUs export = _TranslationsS17TaskLockedExportEnUs._(_root);
}

// Path: S18_Task_Join
class _TranslationsS18TaskJoinEnUs extends TranslationsS18TaskJoinZhTw {
	_TranslationsS18TaskJoinEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Join Task';
	@override late final _TranslationsS18TaskJoinTabsEnUs tabs = _TranslationsS18TaskJoinTabsEnUs._(_root);
	@override late final _TranslationsS18TaskJoinLabelEnUs label = _TranslationsS18TaskJoinLabelEnUs._(_root);
	@override late final _TranslationsS18TaskJoinHintEnUs hint = _TranslationsS18TaskJoinHintEnUs._(_root);
	@override late final _TranslationsS18TaskJoinContentEnUs content = _TranslationsS18TaskJoinContentEnUs._(_root);
}

// Path: S30_settlement_confirm
class _TranslationsS30SettlementConfirmEnUs extends TranslationsS30SettlementConfirmZhTw {
	_TranslationsS30SettlementConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirm Settlement';
	@override late final _TranslationsS30SettlementConfirmButtonsEnUs buttons = _TranslationsS30SettlementConfirmButtonsEnUs._(_root);
	@override late final _TranslationsS30SettlementConfirmStepsEnUs steps = _TranslationsS30SettlementConfirmStepsEnUs._(_root);
	@override late final _TranslationsS30SettlementConfirmWarningEnUs warning = _TranslationsS30SettlementConfirmWarningEnUs._(_root);
	@override late final _TranslationsS30SettlementConfirmListItemEnUs list_item = _TranslationsS30SettlementConfirmListItemEnUs._(_root);
}

// Path: S31_settlement_payment_info
class _TranslationsS31SettlementPaymentInfoEnUs extends TranslationsS31SettlementPaymentInfoZhTw {
	_TranslationsS31SettlementPaymentInfoEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Payment Information';
	@override String get setup_instruction => 'Used for this settlement only. Default data is encrypted and stored locally.';
	@override String get sync_save => 'Save as default payment information (stored on this device)';
	@override String get sync_update => 'Sync and update my default payment information';
	@override late final _TranslationsS31SettlementPaymentInfoButtonsEnUs buttons = _TranslationsS31SettlementPaymentInfoButtonsEnUs._(_root);
}

// Path: S32_settlement_result
class _TranslationsS32SettlementResultEnUs extends TranslationsS32SettlementResultZhTw {
	_TranslationsS32SettlementResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Settlement Complete';
	@override String get content => 'All records are finalized. Please notify members to complete payment.';
	@override String get waiting_reveal => 'Revealing result...';
	@override String get remainder_winner_prefix => 'Remainder recipient:';
	@override String remainder_winner_total({required Object winnerName, required Object prefix, required Object total}) => '${winnerName}\'s final amount: ${prefix}${total}';
	@override String get total_label => 'Total Settlement Amount';
	@override late final _TranslationsS32SettlementResultButtonsEnUs buttons = _TranslationsS32SettlementResultButtonsEnUs._(_root);
}

// Path: S50_Onboarding_Consent
class _TranslationsS50OnboardingConsentEnUs extends TranslationsS50OnboardingConsentZhTw {
	_TranslationsS50OnboardingConsentEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Welcome to Iron Split';
	@override late final _TranslationsS50OnboardingConsentButtonsEnUs buttons = _TranslationsS50OnboardingConsentButtonsEnUs._(_root);
	@override late final _TranslationsS50OnboardingConsentContentEnUs content = _TranslationsS50OnboardingConsentContentEnUs._(_root);
}

// Path: S51_Onboarding_Name
class _TranslationsS51OnboardingNameEnUs extends TranslationsS51OnboardingNameZhTw {
	_TranslationsS51OnboardingNameEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Set Your Name';
	@override String get content => 'Enter display name.';
	@override String get hint => 'Enter nickname';
	@override String counter({required Object current, required Object max}) => '${current}/${max}';
}

// Path: S52_TaskSettings_Log
class _TranslationsS52TaskSettingsLogEnUs extends TranslationsS52TaskSettingsLogZhTw {
	_TranslationsS52TaskSettingsLogEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Activity Log';
	@override late final _TranslationsS52TaskSettingsLogButtonsEnUs buttons = _TranslationsS52TaskSettingsLogButtonsEnUs._(_root);
	@override String get empty_log => 'No activity logs found';
	@override String get export_file_prefix => 'ActivityLog';
	@override late final _TranslationsS52TaskSettingsLogCsvHeaderEnUs csv_header = _TranslationsS52TaskSettingsLogCsvHeaderEnUs._(_root);
	@override late final _TranslationsS52TaskSettingsLogTypeEnUs type = _TranslationsS52TaskSettingsLogTypeEnUs._(_root);
	@override late final _TranslationsS52TaskSettingsLogPaymentTypeEnUs payment_type = _TranslationsS52TaskSettingsLogPaymentTypeEnUs._(_root);
	@override late final _TranslationsS52TaskSettingsLogUnitEnUs unit = _TranslationsS52TaskSettingsLogUnitEnUs._(_root);
}

// Path: S53_TaskSettings_Members
class _TranslationsS53TaskSettingsMembersEnUs extends TranslationsS53TaskSettingsMembersZhTw {
	_TranslationsS53TaskSettingsMembersEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Member Management';
	@override late final _TranslationsS53TaskSettingsMembersButtonsEnUs buttons = _TranslationsS53TaskSettingsMembersButtonsEnUs._(_root);
	@override late final _TranslationsS53TaskSettingsMembersLabelEnUs label = _TranslationsS53TaskSettingsMembersLabelEnUs._(_root);
	@override String get member_default_name => 'Member';
	@override String get member_name => 'Member Name';
}

// Path: S54_TaskSettings_Invite
class _TranslationsS54TaskSettingsInviteEnUs extends TranslationsS54TaskSettingsInviteZhTw {
	_TranslationsS54TaskSettingsInviteEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Invite';
	@override late final _TranslationsS54TaskSettingsInviteButtonsEnUs buttons = _TranslationsS54TaskSettingsInviteButtonsEnUs._(_root);
	@override late final _TranslationsS54TaskSettingsInviteLabelEnUs label = _TranslationsS54TaskSettingsInviteLabelEnUs._(_root);
}

// Path: S70_System_Settings
class _TranslationsS70SystemSettingsEnUs extends TranslationsS70SystemSettingsZhTw {
	_TranslationsS70SystemSettingsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Settings';
	@override late final _TranslationsS70SystemSettingsSectionEnUs section = _TranslationsS70SystemSettingsSectionEnUs._(_root);
	@override late final _TranslationsS70SystemSettingsMenuEnUs menu = _TranslationsS70SystemSettingsMenuEnUs._(_root);
}

// Path: S72_TermsUpdate
class _TranslationsS72TermsUpdateEnUs extends TranslationsS72TermsUpdateZhTw {
	_TranslationsS72TermsUpdateEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String title({required Object type}) => '${type} Updated';
	@override String content({required Object type}) => 'We have updated the ${type}. Please review and accept it to continue using the app.';
}

// Path: S74_DeleteAccount_Notice
class _TranslationsS74DeleteAccountNoticeEnUs extends TranslationsS74DeleteAccountNoticeZhTw {
	_TranslationsS74DeleteAccountNoticeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Delete Account';
	@override String get content => 'This action cannot be undone. Your personal data will be deleted. Leader privileges will be automatically transferred to another member, while records in shared ledgers will remain (as unlinked entries).';
	@override late final _TranslationsS74DeleteAccountNoticeButtonsEnUs buttons = _TranslationsS74DeleteAccountNoticeButtonsEnUs._(_root);
}

// Path: D01_MemberRole_Intro
class _TranslationsD01MemberRoleIntroEnUs extends TranslationsD01MemberRoleIntroZhTw {
	_TranslationsD01MemberRoleIntroEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Your Character';
	@override late final _TranslationsD01MemberRoleIntroButtonsEnUs buttons = _TranslationsD01MemberRoleIntroButtonsEnUs._(_root);
	@override String content({required Object avatar}) => 'This is your avatar ${avatar} for this task.\n${avatar} will represent you in all records.';
	@override late final _TranslationsD01MemberRoleIntroRerollEnUs reroll = _TranslationsD01MemberRoleIntroRerollEnUs._(_root);
}

// Path: D02_Invite_Result
class _TranslationsD02InviteResultEnUs extends TranslationsD02InviteResultZhTw {
	_TranslationsD02InviteResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Join Failed';
}

// Path: D03_TaskCreate_Confirm
class _TranslationsD03TaskCreateConfirmEnUs extends TranslationsD03TaskCreateConfirmZhTw {
	_TranslationsD03TaskCreateConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Create Task';
	@override late final _TranslationsD03TaskCreateConfirmButtonsEnUs buttons = _TranslationsD03TaskCreateConfirmButtonsEnUs._(_root);
}

// Path: D04_CommonUnsaved_Confirm
class _TranslationsD04CommonUnsavedConfirmEnUs extends TranslationsD04CommonUnsavedConfirmZhTw {
	_TranslationsD04CommonUnsavedConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Unsaved Changes';
	@override String get content => 'Changes you made will not be saved.';
}

// Path: D05_DateJump_NoResult
class _TranslationsD05DateJumpNoResultEnUs extends TranslationsD05DateJumpNoResultZhTw {
	_TranslationsD05DateJumpNoResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'No Record';
	@override String get content => 'No record found for this date. Add one?';
}

// Path: D06_settlement_confirm
class _TranslationsD06SettlementConfirmEnUs extends TranslationsD06SettlementConfirmZhTw {
	_TranslationsD06SettlementConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Settlement';
	@override String get content => 'The task will be locked upon settlement. Records cannot be added, deleted, or edited after settlement.\nPlease ensure all details are correct.';
}

// Path: D08_TaskClosed_Confirm
class _TranslationsD08TaskClosedConfirmEnUs extends TranslationsD08TaskClosedConfirmZhTw {
	_TranslationsD08TaskClosedConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Close Task';
	@override String get content => 'This action cannot be undone. All data will be locked permanently.\n\nAre you sure you want to proceed?';
}

// Path: D09_TaskSettings_CurrencyConfirm
class _TranslationsD09TaskSettingsCurrencyConfirmEnUs extends TranslationsD09TaskSettingsCurrencyConfirmZhTw {
	_TranslationsD09TaskSettingsCurrencyConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Change Base Currency';
	@override String get content => 'Changing currency will reset all exchange rates. This may affect current balances. Are you sure?';
}

// Path: D10_RecordDelete_Confirm
class _TranslationsD10RecordDeleteConfirmEnUs extends TranslationsD10RecordDeleteConfirmZhTw {
	_TranslationsD10RecordDeleteConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Delete Record';
	@override String content({required Object title, required Object amount}) => 'Are you sure you want to delete ${title} (${amount})?';
}

// Path: D11_random_result
class _TranslationsD11RandomResultEnUs extends TranslationsD11RandomResultZhTw {
	_TranslationsD11RandomResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Remainder Result';
	@override String get skip => 'Skip';
}

// Path: D12_logout_confirm
class _TranslationsD12LogoutConfirmEnUs extends TranslationsD12LogoutConfirmZhTw {
	_TranslationsD12LogoutConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Log Out';
	@override String get content => 'If you do not agree to the updated terms, you will not be able to continue using this app.\nLogout will proceed.';
	@override late final _TranslationsD12LogoutConfirmButtonsEnUs buttons = _TranslationsD12LogoutConfirmButtonsEnUs._(_root);
}

// Path: D13_DeleteAccount_Confirm
class _TranslationsD13DeleteAccountConfirmEnUs extends TranslationsD13DeleteAccountConfirmZhTw {
	_TranslationsD13DeleteAccountConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Delete Account';
	@override String get content => 'This action cannot be undone. All data will be deleted permanently.\n\nAre you sure you want to proceed?';
}

// Path: D14_Date_Select
class _TranslationsD14DateSelectEnUs extends TranslationsD14DateSelectZhTw {
	_TranslationsD14DateSelectEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Select Date';
}

// Path: B02_SplitExpense_Edit
class _TranslationsB02SplitExpenseEditEnUs extends TranslationsB02SplitExpenseEditZhTw {
	_TranslationsB02SplitExpenseEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Edit Sub Item';
	@override late final _TranslationsB02SplitExpenseEditButtonsEnUs buttons = _TranslationsB02SplitExpenseEditButtonsEnUs._(_root);
	@override String get item_name_empty => 'Parent item name is empty';
	@override late final _TranslationsB02SplitExpenseEditHintEnUs hint = _TranslationsB02SplitExpenseEditHintEnUs._(_root);
}

// Path: B03_SplitMethod_Edit
class _TranslationsB03SplitMethodEditEnUs extends TranslationsB03SplitMethodEditZhTw {
	_TranslationsB03SplitMethodEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Split Method';
	@override late final _TranslationsB03SplitMethodEditButtonsEnUs buttons = _TranslationsB03SplitMethodEditButtonsEnUs._(_root);
	@override late final _TranslationsB03SplitMethodEditLabelEnUs label = _TranslationsB03SplitMethodEditLabelEnUs._(_root);
	@override String get mismatch => 'Mismatch';
}

// Path: B04_payment_merge
class _TranslationsB04PaymentMergeEnUs extends TranslationsB04PaymentMergeZhTw {
	_TranslationsB04PaymentMergeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Merge Member Payments';
	@override late final _TranslationsB04PaymentMergeLabelEnUs label = _TranslationsB04PaymentMergeLabelEnUs._(_root);
}

// Path: B07_PaymentMethod_Edit
class _TranslationsB07PaymentMethodEditEnUs extends TranslationsB07PaymentMethodEditZhTw {
	_TranslationsB07PaymentMethodEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Funding Source';
	@override String prepay_balance({required Object amount}) => 'Prepaid Balance: ${amount}';
	@override String get payer_member => 'Payer';
	@override late final _TranslationsB07PaymentMethodEditLabelEnUs label = _TranslationsB07PaymentMethodEditLabelEnUs._(_root);
	@override late final _TranslationsB07PaymentMethodEditStatusEnUs status = _TranslationsB07PaymentMethodEditStatusEnUs._(_root);
}

// Path: success
class _TranslationsSuccessEnUs extends TranslationsSuccessZhTw {
	_TranslationsSuccessEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get saved => 'Saved';
	@override String get deleted => 'Deleted';
	@override String get copied => 'Copied';
}

// Path: error
class _TranslationsErrorEnUs extends TranslationsErrorZhTw {
	_TranslationsErrorEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Error';
	@override String unknown({required Object error}) => 'Unknown error: ${error}';
	@override late final _TranslationsErrorDialogEnUs dialog = _TranslationsErrorDialogEnUs._(_root);
	@override late final _TranslationsErrorMessageEnUs message = _TranslationsErrorMessageEnUs._(_root);
}

// Path: common.buttons
class _TranslationsCommonButtonsEnUs extends TranslationsCommonButtonsZhTw {
	_TranslationsCommonButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
	@override String get confirm => 'Confirm';
	@override String get back => 'Back';
	@override String get save => 'Save';
	@override String get edit => 'Edit';
	@override String get close => 'Close';
	@override String get download => 'Download';
	@override String get settlement => 'Settle';
	@override String get discard => 'Discard';
	@override String get keep_editing => 'Keep Editing';
	@override String get refresh => 'Refresh';
	@override String get ok => 'OK';
	@override String get retry => 'Retry';
	@override String get done => 'Done';
	@override String get agree => 'Agree';
	@override String get decline => 'Decline';
	@override String get add_record => 'Add';
	@override String get copy => 'Copy';
}

// Path: common.label
class _TranslationsCommonLabelEnUs extends TranslationsCommonLabelZhTw {
	_TranslationsCommonLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get task_name => 'Task name';
	@override String get item_name => 'Item Name';
	@override String get sub_item => 'Sub Item Name';
	@override String get amount => 'Amount';
	@override String get date => 'Date';
	@override String get currency => 'Currency';
	@override String get split_method => 'Split Method';
	@override String get start_date => 'Start Date';
	@override String get end_date => 'End Date';
	@override String get member_count => 'Members';
	@override String get payment_method => 'Payment Method';
	@override String get rate => 'Exchange Rate';
	@override String get memo => 'Memo';
}

// Path: common.category
class _TranslationsCommonCategoryEnUs extends TranslationsCommonCategoryZhTw {
	_TranslationsCommonCategoryEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get food => 'Food';
	@override String get transport => 'Transport';
	@override String get shopping => 'Shopping';
	@override String get entertainment => 'Entertainment';
	@override String get accommodation => 'Accommodation';
	@override String get others => 'Others';
}

// Path: common.currency
class _TranslationsCommonCurrencyEnUs extends TranslationsCommonCurrencyZhTw {
	_TranslationsCommonCurrencyEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get twd => 'New Taiwan Dollar';
	@override String get jpy => 'Japanese Yen';
	@override String get usd => 'US Dollar';
	@override String get eur => 'Euro';
	@override String get krw => 'South Korean Won';
	@override String get cny => 'Chinese Yuan';
	@override String get gbp => 'British Pound';
	@override String get cad => 'Canadian Dollar';
	@override String get aud => 'Australian Dollar';
	@override String get chf => 'Swiss Franc';
	@override String get dkk => 'Danish Krone';
	@override String get hkd => 'Hong Kong Dollar';
	@override String get nok => 'Norwegian Krone';
	@override String get nzd => 'New Zealand Dollar';
	@override String get sgd => 'Singapore Dollar';
	@override String get thb => 'Thai Baht';
	@override String get zar => 'South African Rand';
	@override String get rub => 'Russian Ruble';
	@override String get vnd => 'Vietnamese Dong';
	@override String get idr => 'Indonesian Rupiah';
	@override String get myr => 'Malaysian Ringgit';
	@override String get php => 'Philippine Peso';
	@override String get mop => 'Macanese Pataca';
	@override String get sek => 'Swedish Krone';
	@override String get aed => 'UAE Dirham';
	@override String get sar => 'Saudi Riyal';
	@override String get try_ => 'Turkish Lira';
	@override String get inr => 'Indian Rupee';
}

// Path: common.payment_info
class _TranslationsCommonPaymentInfoEnUs extends TranslationsCommonPaymentInfoZhTw {
	_TranslationsCommonPaymentInfoEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonPaymentInfoModeEnUs mode = _TranslationsCommonPaymentInfoModeEnUs._(_root);
	@override late final _TranslationsCommonPaymentInfoContentEnUs content = _TranslationsCommonPaymentInfoContentEnUs._(_root);
	@override late final _TranslationsCommonPaymentInfoTypeEnUs type = _TranslationsCommonPaymentInfoTypeEnUs._(_root);
	@override late final _TranslationsCommonPaymentInfoLabelEnUs label = _TranslationsCommonPaymentInfoLabelEnUs._(_root);
	@override late final _TranslationsCommonPaymentInfoHintEnUs hint = _TranslationsCommonPaymentInfoHintEnUs._(_root);
}

// Path: common.payment_status
class _TranslationsCommonPaymentStatusEnUs extends TranslationsCommonPaymentStatusZhTw {
	_TranslationsCommonPaymentStatusEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get payable => 'Payable';
	@override String get refund => 'Refund';
}

// Path: common.avatar
class _TranslationsCommonAvatarEnUs extends TranslationsCommonAvatarZhTw {
	_TranslationsCommonAvatarEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get cow => 'Holstein Friesian';
	@override String get pig => 'Domestic pig';
	@override String get deer => 'Roe deer';
	@override String get horse => 'Chestnut horse';
	@override String get sheep => 'Suffolk sheep';
	@override String get goat => 'Domestic goat';
	@override String get duck => 'Mallard';
	@override String get stoat => 'Stoat';
	@override String get rabbit => 'European hare';
	@override String get mouse => 'House mouse';
	@override String get cat => 'Domestic tabby cat';
	@override String get dog => 'Border Collie';
	@override String get otter => 'Eurasian otter';
	@override String get owl => 'Barn owl';
	@override String get fox => 'Red fox';
	@override String get hedgehog => 'European hedgehog';
	@override String get donkey => 'Donkey';
	@override String get squirrel => 'Eurasian red squirrel';
	@override String get badger => 'European badger';
	@override String get robin => 'European robin';
}

// Path: common.remainder_rule
class _TranslationsCommonRemainderRuleEnUs extends TranslationsCommonRemainderRuleZhTw {
	_TranslationsCommonRemainderRuleEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Remainder Rule';
	@override late final _TranslationsCommonRemainderRuleRuleEnUs rule = _TranslationsCommonRemainderRuleRuleEnUs._(_root);
	@override late final _TranslationsCommonRemainderRuleContentEnUs content = _TranslationsCommonRemainderRuleContentEnUs._(_root);
	@override String message_remainder({required Object amount}) => 'Remainder ${amount} will be temporarily stored and distributed at settlement.';
	@override String message_zero_balance({required Object amount}) => 'Remaining amount ${amount} has been automatically offset against payment differences.';
}

// Path: common.split_method
class _TranslationsCommonSplitMethodEnUs extends TranslationsCommonSplitMethodZhTw {
	_TranslationsCommonSplitMethodEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get even => 'Equal';
	@override String get percent => 'Ratio';
	@override String get exact => 'Custom';
}

// Path: common.payment_method
class _TranslationsCommonPaymentMethodEnUs extends TranslationsCommonPaymentMethodZhTw {
	_TranslationsCommonPaymentMethodEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get member => 'Member Advance';
	@override String get prepay => 'Prepaid';
	@override String get mixed => 'Mixed Payment';
}

// Path: common.language
class _TranslationsCommonLanguageEnUs extends TranslationsCommonLanguageZhTw {
	_TranslationsCommonLanguageEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Language Settings';
	@override String get zh_TW => 'Traditional Chinese';
	@override String get en_US => 'English';
	@override String get jp_JP => 'Japanese';
}

// Path: common.theme
class _TranslationsCommonThemeEnUs extends TranslationsCommonThemeZhTw {
	_TranslationsCommonThemeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Theme Settings';
	@override String get system => 'System Default';
	@override String get light => 'Light Mode';
	@override String get dark => 'Dark Mode';
}

// Path: common.display
class _TranslationsCommonDisplayEnUs extends TranslationsCommonDisplayZhTw {
	_TranslationsCommonDisplayEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Display Settings';
	@override String get system => 'Follow System';
	@override String get enlarged => 'Enlarged';
	@override String get standard => 'Standard';
}

// Path: common.terms
class _TranslationsCommonTermsEnUs extends TranslationsCommonTermsZhTw {
	_TranslationsCommonTermsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonTermsLabelEnUs label = _TranslationsCommonTermsLabelEnUs._(_root);
	@override String get and => ' and ';
}

// Path: common.share
class _TranslationsCommonShareEnUs extends TranslationsCommonShareZhTw {
	_TranslationsCommonShareEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsCommonShareInviteEnUs invite = _TranslationsCommonShareInviteEnUs._(_root);
	@override late final _TranslationsCommonShareSettlementEnUs settlement = _TranslationsCommonShareSettlementEnUs._(_root);
}

// Path: S10_Home_TaskList.tab
class _TranslationsS10HomeTaskListTabEnUs extends TranslationsS10HomeTaskListTabZhTw {
	_TranslationsS10HomeTaskListTabEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get in_progress => 'Active';
	@override String get completed => 'Finished';
}

// Path: S10_Home_TaskList.empty
class _TranslationsS10HomeTaskListEmptyEnUs extends TranslationsS10HomeTaskListEmptyZhTw {
	_TranslationsS10HomeTaskListEmptyEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get in_progress => 'No active tasks';
	@override String get completed => 'No finished tasks';
}

// Path: S10_Home_TaskList.buttons
class _TranslationsS10HomeTaskListButtonsEnUs extends TranslationsS10HomeTaskListButtonsZhTw {
	_TranslationsS10HomeTaskListButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get add_task => 'Add Task';
	@override String get join_task => 'Join Task';
}

// Path: S10_Home_TaskList.label
class _TranslationsS10HomeTaskListLabelEnUs extends TranslationsS10HomeTaskListLabelZhTw {
	_TranslationsS10HomeTaskListLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get settlement => 'Settlement';
}

// Path: S11_Invite_Confirm.buttons
class _TranslationsS11InviteConfirmButtonsEnUs extends TranslationsS11InviteConfirmButtonsZhTw {
	_TranslationsS11InviteConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get join => 'Join';
	@override String get back_task_list => 'Home';
}

// Path: S11_Invite_Confirm.label
class _TranslationsS11InviteConfirmLabelEnUs extends TranslationsS11InviteConfirmLabelZhTw {
	_TranslationsS11InviteConfirmLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get select_ghost => 'Select Member to Inherit';
	@override String get prepaid => 'Prepaid';
	@override String get expense => 'Expense';
}

// Path: S12_TaskClose_Notice.buttons
class _TranslationsS12TaskCloseNoticeButtonsEnUs extends TranslationsS12TaskCloseNoticeButtonsZhTw {
	_TranslationsS12TaskCloseNoticeButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get close_task => 'Close Task';
}

// Path: S13_Task_Dashboard.buttons
class _TranslationsS13TaskDashboardButtonsEnUs extends TranslationsS13TaskDashboardButtonsZhTw {
	_TranslationsS13TaskDashboardButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get add => 'Add';
}

// Path: S13_Task_Dashboard.tab
class _TranslationsS13TaskDashboardTabEnUs extends TranslationsS13TaskDashboardTabZhTw {
	_TranslationsS13TaskDashboardTabEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get group => 'Group';
	@override String get personal => 'Personal';
}

// Path: S13_Task_Dashboard.label
class _TranslationsS13TaskDashboardLabelEnUs extends TranslationsS13TaskDashboardLabelZhTw {
	_TranslationsS13TaskDashboardLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get total_expense => 'Total Expense';
	@override String get total_prepay => 'Total Prepaid';
	@override String get total_expense_personal => 'Total Expense';
	@override String get total_prepay_personal => 'Total Prepaid (incl. Reimbursed)';
}

// Path: S13_Task_Dashboard.empty
class _TranslationsS13TaskDashboardEmptyEnUs extends TranslationsS13TaskDashboardEmptyZhTw {
	_TranslationsS13TaskDashboardEmptyEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get records => 'No records';
	@override String get personal_records => 'No records';
}

// Path: S13_Task_Dashboard.section
class _TranslationsS13TaskDashboardSectionEnUs extends TranslationsS13TaskDashboardSectionZhTw {
	_TranslationsS13TaskDashboardSectionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get expense => 'Expense Details';
	@override String get prepay => 'Prepaid Details';
	@override String get prepay_balance => 'Prepaid Balance';
	@override String get no_data => 'No data';
}

// Path: S14_Task_Settings.section
class _TranslationsS14TaskSettingsSectionEnUs extends TranslationsS14TaskSettingsSectionZhTw {
	_TranslationsS14TaskSettingsSectionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get task_name => 'Task Name';
	@override String get task_period => 'Task Period';
	@override String get settlement => 'Settlement Settings';
	@override String get other => 'Other Settings';
}

// Path: S14_Task_Settings.menu
class _TranslationsS14TaskSettingsMenuEnUs extends TranslationsS14TaskSettingsMenuZhTw {
	_TranslationsS14TaskSettingsMenuEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get invite => 'Invite';
	@override String get member_settings => 'Member Settings';
	@override String get history => 'History';
	@override String get close_task => 'End Task';
}

// Path: S15_Record_Edit.title
class _TranslationsS15RecordEditTitleEnUs extends TranslationsS15RecordEditTitleZhTw {
	_TranslationsS15RecordEditTitleEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get add => 'Add Record';
	@override String get edit => 'Edit Record';
}

// Path: S15_Record_Edit.buttons
class _TranslationsS15RecordEditButtonsEnUs extends TranslationsS15RecordEditButtonsZhTw {
	_TranslationsS15RecordEditButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get add_item => 'Add Item';
}

// Path: S15_Record_Edit.section
class _TranslationsS15RecordEditSectionEnUs extends TranslationsS15RecordEditSectionZhTw {
	_TranslationsS15RecordEditSectionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get split => 'Split Information';
	@override String get items => 'Itemized Split';
}

// Path: S15_Record_Edit.val
class _TranslationsS15RecordEditValEnUs extends TranslationsS15RecordEditValZhTw {
	_TranslationsS15RecordEditValEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get prepay => 'Prepaid';
	@override String member_paid({required Object name}) => '${name} paid';
	@override String get split_details => 'Itemized Split';
	@override String split_summary({required Object amount, required Object method}) => 'Total ${amount} split by ${method}';
	@override String converted_amount({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}';
	@override String get split_remaining => 'Remaining Amount';
	@override String get mock_note => 'Item description';
}

// Path: S15_Record_Edit.tab
class _TranslationsS15RecordEditTabEnUs extends TranslationsS15RecordEditTabZhTw {
	_TranslationsS15RecordEditTabEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get expense => 'Expense';
	@override String get prepay => 'Prepaid';
}

// Path: S15_Record_Edit.rate_dialog
class _TranslationsS15RecordEditRateDialogEnUs extends TranslationsS15RecordEditRateDialogZhTw {
	_TranslationsS15RecordEditRateDialogEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Exchange Rate Source';
	@override String get content => 'Exchange rate data is provided by Open Exchange Rates (free plan) for reference only. Please refer to your exchange receipt for the actual rate.';
}

// Path: S15_Record_Edit.label
class _TranslationsS15RecordEditLabelEnUs extends TranslationsS15RecordEditLabelZhTw {
	_TranslationsS15RecordEditLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String rate_with_base({required Object base, required Object target}) => 'Exchange Rate (1 ${base} = ? ${target})';
}

// Path: S15_Record_Edit.hint
class _TranslationsS15RecordEditHintEnUs extends TranslationsS15RecordEditHintZhTw {
	_TranslationsS15RecordEditHintEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsS15RecordEditHintCategoryEnUs category = _TranslationsS15RecordEditHintCategoryEnUs._(_root);
	@override String item({required Object category}) => 'e.g. ${category}';
	@override String get memo => 'e.g. Notes';
}

// Path: S16_TaskCreate_Edit.section
class _TranslationsS16TaskCreateEditSectionEnUs extends TranslationsS16TaskCreateEditSectionZhTw {
	_TranslationsS16TaskCreateEditSectionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get task_name => 'Task Name';
	@override String get task_period => 'Task Period';
	@override String get settlement => 'Settlement Settings';
}

// Path: S16_TaskCreate_Edit.label
class _TranslationsS16TaskCreateEditLabelEnUs extends TranslationsS16TaskCreateEditLabelZhTw {
	_TranslationsS16TaskCreateEditLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String name_counter({required Object current, required Object max}) => '${current}/${max}';
}

// Path: S16_TaskCreate_Edit.hint
class _TranslationsS16TaskCreateEditHintEnUs extends TranslationsS16TaskCreateEditHintZhTw {
	_TranslationsS16TaskCreateEditHintEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get name => 'e.g. Tokyo Trip';
}

// Path: S17_Task_Locked.buttons
class _TranslationsS17TaskLockedButtonsEnUs extends TranslationsS17TaskLockedButtonsZhTw {
	_TranslationsS17TaskLockedButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get notify_members => 'Notify Members';
	@override String get view_payment_info => 'View Payment Details';
}

// Path: S17_Task_Locked.section
class _TranslationsS17TaskLockedSectionEnUs extends TranslationsS17TaskLockedSectionZhTw {
	_TranslationsS17TaskLockedSectionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get pending => 'Pending';
	@override String get cleared => 'Cleared';
}

// Path: S17_Task_Locked.export
class _TranslationsS17TaskLockedExportEnUs extends TranslationsS17TaskLockedExportZhTw {
	_TranslationsS17TaskLockedExportEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get report_info => 'Report Information';
	@override String get task_name => 'Task Name';
	@override String get export_time => 'Export Time';
	@override String get base_currency => 'Base Currency';
	@override String get settlement_summary => 'Settlement Summary';
	@override String get member => 'Member';
	@override String get role => 'Role';
	@override String get net_amount => 'Net Amount';
	@override String get status => 'Status';
	@override String get receiver => 'Receivable';
	@override String get payer => 'Payable';
	@override String get cleared => 'Cleared';
	@override String get pending => 'Pending';
	@override String get fund_analysis => 'Funds & Remainders';
	@override String get total_expense => 'Total Expense';
	@override String get total_prepay => 'Total Prepaid';
	@override String get remainder_buffer => 'Total Remainder';
	@override String get remainder_absorbed_by => 'Remainder Recipient';
	@override String get transaction_details => 'Transaction Details';
	@override String get date => 'Date';
	@override String get title => 'Title';
	@override String get type => 'Type';
	@override String get original_amount => 'Original Amount';
	@override String get currency => 'Currency';
	@override String get rate => 'Exchange Rate';
	@override String get base_amount => 'Base Currency Amount';
	@override String get net_remainder => 'Remainder';
	@override String get pool => 'Prepaid Pool';
	@override String get mixed => 'Mixed Payment';
}

// Path: S18_Task_Join.tabs
class _TranslationsS18TaskJoinTabsEnUs extends TranslationsS18TaskJoinTabsZhTw {
	_TranslationsS18TaskJoinTabsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get input => 'Enter Code';
	@override String get scan => 'Scan QR';
}

// Path: S18_Task_Join.label
class _TranslationsS18TaskJoinLabelEnUs extends TranslationsS18TaskJoinLabelZhTw {
	_TranslationsS18TaskJoinLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get input => 'Invite code';
}

// Path: S18_Task_Join.hint
class _TranslationsS18TaskJoinHintEnUs extends TranslationsS18TaskJoinHintZhTw {
	_TranslationsS18TaskJoinHintEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get input => 'Enter 8-digit invite code';
}

// Path: S18_Task_Join.content
class _TranslationsS18TaskJoinContentEnUs extends TranslationsS18TaskJoinContentZhTw {
	_TranslationsS18TaskJoinContentEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get scan => 'Frame the QR code to scan automatically';
}

// Path: S30_settlement_confirm.buttons
class _TranslationsS30SettlementConfirmButtonsEnUs extends TranslationsS30SettlementConfirmButtonsZhTw {
	_TranslationsS30SettlementConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get set_payment_info => 'Payment Info';
}

// Path: S30_settlement_confirm.steps
class _TranslationsS30SettlementConfirmStepsEnUs extends TranslationsS30SettlementConfirmStepsZhTw {
	_TranslationsS30SettlementConfirmStepsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get confirm_amount => 'Confirm Amount';
	@override String get payment_info => 'Payment Info';
}

// Path: S30_settlement_confirm.warning
class _TranslationsS30SettlementConfirmWarningEnUs extends TranslationsS30SettlementConfirmWarningZhTw {
	_TranslationsS30SettlementConfirmWarningEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get random_reveal => 'Remainder will be revealed after settlement.';
}

// Path: S30_settlement_confirm.list_item
class _TranslationsS30SettlementConfirmListItemEnUs extends TranslationsS30SettlementConfirmListItemZhTw {
	_TranslationsS30SettlementConfirmListItemEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get merged_label => 'Representative';
	@override String get includes => 'Includes:';
	@override String get principal => 'Principal';
	@override String get random_remainder => 'Random Remainder';
	@override String get remainder => 'Remainder';
}

// Path: S31_settlement_payment_info.buttons
class _TranslationsS31SettlementPaymentInfoButtonsEnUs extends TranslationsS31SettlementPaymentInfoButtonsZhTw {
	_TranslationsS31SettlementPaymentInfoButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get prev_step => 'Previous Step';
}

// Path: S32_settlement_result.buttons
class _TranslationsS32SettlementResultButtonsEnUs extends TranslationsS32SettlementResultButtonsZhTw {
	_TranslationsS32SettlementResultButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get share => 'Send Settlement Notification';
	@override String get back_task_dashboard => 'Back to Task';
}

// Path: S50_Onboarding_Consent.buttons
class _TranslationsS50OnboardingConsentButtonsEnUs extends TranslationsS50OnboardingConsentButtonsZhTw {
	_TranslationsS50OnboardingConsentButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get start => 'Start';
}

// Path: S50_Onboarding_Consent.content
class _TranslationsS50OnboardingConsentContentEnUs extends TranslationsS50OnboardingConsentContentZhTw {
	_TranslationsS50OnboardingConsentContentEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get prefix => 'Make splitting expenses simple.\n\nI’m Iron Rooster. I manage the records and splits here.\nWhether it’s travel, dining, or shared living, every expense is clearly recorded, and every split follows defined rules.\n\nSplitting expenses should be simple and clear.\n\nBy clicking Start, you agree to our ';
	@override String get suffix => '. We use anonymous login to protect your privacy.';
}

// Path: S52_TaskSettings_Log.buttons
class _TranslationsS52TaskSettingsLogButtonsEnUs extends TranslationsS52TaskSettingsLogButtonsZhTw {
	_TranslationsS52TaskSettingsLogButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get export_csv => 'Export CSV';
}

// Path: S52_TaskSettings_Log.csv_header
class _TranslationsS52TaskSettingsLogCsvHeaderEnUs extends TranslationsS52TaskSettingsLogCsvHeaderZhTw {
	_TranslationsS52TaskSettingsLogCsvHeaderEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get time => 'Time';
	@override String get user => 'User';
	@override String get action => 'Action';
	@override String get details => 'Details';
}

// Path: S52_TaskSettings_Log.type
class _TranslationsS52TaskSettingsLogTypeEnUs extends TranslationsS52TaskSettingsLogTypeZhTw {
	_TranslationsS52TaskSettingsLogTypeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get prepay => 'Prepaid';
	@override String get expense => 'Expense';
}

// Path: S52_TaskSettings_Log.payment_type
class _TranslationsS52TaskSettingsLogPaymentTypeEnUs extends TranslationsS52TaskSettingsLogPaymentTypeZhTw {
	_TranslationsS52TaskSettingsLogPaymentTypeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get prepay => 'Paid from Pool';
	@override String get single_suffix => 'paid';
	@override String get multiple => 'Multiple Payers';
}

// Path: S52_TaskSettings_Log.unit
class _TranslationsS52TaskSettingsLogUnitEnUs extends TranslationsS52TaskSettingsLogUnitZhTw {
	_TranslationsS52TaskSettingsLogUnitEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get members => 'members';
	@override String get items => 'items';
}

// Path: S53_TaskSettings_Members.buttons
class _TranslationsS53TaskSettingsMembersButtonsEnUs extends TranslationsS53TaskSettingsMembersButtonsZhTw {
	_TranslationsS53TaskSettingsMembersButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get add_member => 'Add Member';
}

// Path: S53_TaskSettings_Members.label
class _TranslationsS53TaskSettingsMembersLabelEnUs extends TranslationsS53TaskSettingsMembersLabelZhTw {
	_TranslationsS53TaskSettingsMembersLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get default_ratio => 'Default Ratio';
}

// Path: S54_TaskSettings_Invite.buttons
class _TranslationsS54TaskSettingsInviteButtonsEnUs extends TranslationsS54TaskSettingsInviteButtonsZhTw {
	_TranslationsS54TaskSettingsInviteButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get share => 'Share';
	@override String get regenerate => 'Regenerate';
}

// Path: S54_TaskSettings_Invite.label
class _TranslationsS54TaskSettingsInviteLabelEnUs extends TranslationsS54TaskSettingsInviteLabelZhTw {
	_TranslationsS54TaskSettingsInviteLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get expires_in => 'Expires in';
	@override String get invite_expired => 'Invite code has expired';
}

// Path: S70_System_Settings.section
class _TranslationsS70SystemSettingsSectionEnUs extends TranslationsS70SystemSettingsSectionZhTw {
	_TranslationsS70SystemSettingsSectionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get basic => 'General Settings';
	@override String get legal => 'Legal';
	@override String get account => 'Account Settings';
}

// Path: S70_System_Settings.menu
class _TranslationsS70SystemSettingsMenuEnUs extends TranslationsS70SystemSettingsMenuZhTw {
	_TranslationsS70SystemSettingsMenuEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get user_name => 'Display Name';
	@override String get language => 'Display Language';
	@override String get theme => 'Theme';
	@override String get terms => 'Terms of Service';
	@override String get privacy => 'Privacy Policy';
	@override String get payment_info => 'Payment Information Settings';
	@override String get delete_account => 'Delete Account';
}

// Path: S74_DeleteAccount_Notice.buttons
class _TranslationsS74DeleteAccountNoticeButtonsEnUs extends TranslationsS74DeleteAccountNoticeButtonsZhTw {
	_TranslationsS74DeleteAccountNoticeButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get delete_account => 'Delete Account';
}

// Path: D01_MemberRole_Intro.buttons
class _TranslationsD01MemberRoleIntroButtonsEnUs extends TranslationsD01MemberRoleIntroButtonsZhTw {
	_TranslationsD01MemberRoleIntroButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get reroll => 'Change Animal';
	@override String get enter => 'Enter Task';
}

// Path: D01_MemberRole_Intro.reroll
class _TranslationsD01MemberRoleIntroRerollEnUs extends TranslationsD01MemberRoleIntroRerollZhTw {
	_TranslationsD01MemberRoleIntroRerollEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get empty => 'No chances left';
}

// Path: D03_TaskCreate_Confirm.buttons
class _TranslationsD03TaskCreateConfirmButtonsEnUs extends TranslationsD03TaskCreateConfirmButtonsZhTw {
	_TranslationsD03TaskCreateConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get back_edit => 'Edit';
}

// Path: D12_logout_confirm.buttons
class _TranslationsD12LogoutConfirmButtonsEnUs extends TranslationsD12LogoutConfirmButtonsZhTw {
	_TranslationsD12LogoutConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get logout => 'Log out';
}

// Path: B02_SplitExpense_Edit.buttons
class _TranslationsB02SplitExpenseEditButtonsEnUs extends TranslationsB02SplitExpenseEditButtonsZhTw {
	_TranslationsB02SplitExpenseEditButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get confirm_split => 'Confirm Split';
}

// Path: B02_SplitExpense_Edit.hint
class _TranslationsB02SplitExpenseEditHintEnUs extends TranslationsB02SplitExpenseEditHintZhTw {
	_TranslationsB02SplitExpenseEditHintEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get sub_item => 'e.g. Sub-item';
}

// Path: B03_SplitMethod_Edit.buttons
class _TranslationsB03SplitMethodEditButtonsEnUs extends TranslationsB03SplitMethodEditButtonsZhTw {
	_TranslationsB03SplitMethodEditButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get adjust_weight => 'Adjust Weight';
}

// Path: B03_SplitMethod_Edit.label
class _TranslationsB03SplitMethodEditLabelEnUs extends TranslationsB03SplitMethodEditLabelZhTw {
	_TranslationsB03SplitMethodEditLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String total({required Object current, required Object target}) => 'Total: ${current}/${target}';
}

// Path: B04_payment_merge.label
class _TranslationsB04PaymentMergeLabelEnUs extends TranslationsB04PaymentMergeLabelZhTw {
	_TranslationsB04PaymentMergeLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get head_member => 'Representative';
	@override String get merge_amount => 'Total Amount';
}

// Path: B07_PaymentMethod_Edit.label
class _TranslationsB07PaymentMethodEditLabelEnUs extends TranslationsB07PaymentMethodEditLabelZhTw {
	_TranslationsB07PaymentMethodEditLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get amount => 'Payment Amount';
	@override String get total_expense => 'Total Amount';
	@override String get prepay => 'Prepaid';
	@override String get total_advance => 'Total Advance';
}

// Path: B07_PaymentMethod_Edit.status
class _TranslationsB07PaymentMethodEditStatusEnUs extends TranslationsB07PaymentMethodEditStatusZhTw {
	_TranslationsB07PaymentMethodEditStatusEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get not_enough => 'Insufficient Balance';
	@override String get balanced => 'Balanced';
	@override String remaining({required Object amount}) => 'Remaining: ${amount}';
}

// Path: error.dialog
class _TranslationsErrorDialogEnUs extends TranslationsErrorDialogZhTw {
	_TranslationsErrorDialogEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorDialogTaskFullEnUs task_full = _TranslationsErrorDialogTaskFullEnUs._(_root);
	@override late final _TranslationsErrorDialogExpiredCodeEnUs expired_code = _TranslationsErrorDialogExpiredCodeEnUs._(_root);
	@override late final _TranslationsErrorDialogInvalidCodeEnUs invalid_code = _TranslationsErrorDialogInvalidCodeEnUs._(_root);
	@override late final _TranslationsErrorDialogAuthRequiredEnUs auth_required = _TranslationsErrorDialogAuthRequiredEnUs._(_root);
	@override late final _TranslationsErrorDialogAlreadyInTaskEnUs already_in_task = _TranslationsErrorDialogAlreadyInTaskEnUs._(_root);
	@override late final _TranslationsErrorDialogUnknownEnUs unknown = _TranslationsErrorDialogUnknownEnUs._(_root);
	@override late final _TranslationsErrorDialogDeleteFailedEnUs delete_failed = _TranslationsErrorDialogDeleteFailedEnUs._(_root);
	@override late final _TranslationsErrorDialogMemberDeleteFailedEnUs member_delete_failed = _TranslationsErrorDialogMemberDeleteFailedEnUs._(_root);
	@override late final _TranslationsErrorDialogDataConflictEnUs data_conflict = _TranslationsErrorDialogDataConflictEnUs._(_root);
}

// Path: error.message
class _TranslationsErrorMessageEnUs extends TranslationsErrorMessageZhTw {
	_TranslationsErrorMessageEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get unknown => 'An unexpected error occurred.';
	@override String get invalid_amount => 'Invalid amount.';
	@override String get required => 'This field is required.';
	@override String empty({required Object key}) => 'Please enter ${key}.';
	@override String get format => 'Invalid format.';
	@override String zero({required Object key}) => '${key} cannot be 0.';
	@override String get amount_not_enough => 'Insufficient remaining amount.';
	@override String get amount_mismatch => 'Amount mismatch.';
	@override String get prepay_is_used => 'This amount has been used or the balance is insufficient.';
	@override String get data_is_used => 'This member still has related records or unsettled payments. Please update or delete them first.';
	@override String get permission_denied => 'Permission denied.';
	@override String get network_error => 'Network connection failed. Please check your internet connection.';
	@override String get data_not_found => 'Data not found. Please try again later.';
	@override String enter_first({required Object key}) => 'Please enter ${key} first.';
	@override String get export_failed => 'Failed to generate report. Please check your storage or try again later.';
	@override String get save_failed => 'Failed to save. Please try again.';
	@override String get delete_failed => 'Failed to delete. Please try again.';
	@override String get task_close_failed => 'Task close failed. Please try again later.';
	@override String get rate_fetch_failed => 'Failed to fetch exchange rate.';
	@override String length_exceeded({required Object max}) => 'Max ${max} characters.';
	@override String get invalid_char => 'Invalid characters.';
	@override String get invalid_code => 'Invalid invite code. Please check if the link is correct.';
	@override String expired_code({required Object expiry_minutes}) => 'Invite link expired (over ${expiry_minutes} minutes). Please ask the task leader to share again.';
	@override String task_full({required Object limit}) => 'Task is full (max ${limit} members).';
	@override String get auth_required => 'Authentication failed. Please restart the app.';
	@override String get init_failed => 'Loading failed. Please try again.';
	@override String get unauthorized => 'Not logged in. Log in again.';
	@override String get task_locked => 'This task is settled and locked. Data cannot be modified.';
	@override String get timeout => 'Server request timed out. Please try again later.';
	@override String get quota_exceeded => 'System quota exceeded. Please try again later.';
	@override String get join_failed => 'Failed to join the task. Please try again later.';
	@override String get invite_create_failed => 'Failed to create invite code. Please try again later.';
	@override String get data_conflict => 'Other members updated the records while you were viewing. Please go back and refresh to ensure accuracy.';
	@override String get task_status_error => 'The task status is invalid (may be already settled). Please refresh.';
	@override String get settlement_failed => 'System error. Settlement failed. Please try again later.';
	@override String get share_failed => 'Share failed. Please try again later.';
	@override String get login_failed => 'Login failed. Please try again later.';
	@override String get logout_failed => 'Logout failed. Please try again later.';
	@override String get scan_failed => 'Scan failed. Please try again later.';
	@override String get invalid_qr_code => 'Invalid QR code.';
	@override String get camera_permission_denied => 'Enable camera permission in system settings.';
}

// Path: common.payment_info.mode
class _TranslationsCommonPaymentInfoModeEnUs extends TranslationsCommonPaymentInfoModeZhTw {
	_TranslationsCommonPaymentInfoModeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get private => 'Contact me directly';
	@override String get public => 'Share payment details';
}

// Path: common.payment_info.content
class _TranslationsCommonPaymentInfoContentEnUs extends TranslationsCommonPaymentInfoContentZhTw {
	_TranslationsCommonPaymentInfoContentEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get private => 'Details are hidden. Contact directly for payment details.';
	@override String get public => 'Payment details will be shown to members.';
}

// Path: common.payment_info.type
class _TranslationsCommonPaymentInfoTypeEnUs extends TranslationsCommonPaymentInfoTypeZhTw {
	_TranslationsCommonPaymentInfoTypeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get cash => 'Cash';
	@override String get bank => 'Bank Transfer';
	@override String get apps => 'Payment Apps';
}

// Path: common.payment_info.label
class _TranslationsCommonPaymentInfoLabelEnUs extends TranslationsCommonPaymentInfoLabelZhTw {
	_TranslationsCommonPaymentInfoLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get bank_name => 'Bank name / code';
	@override String get bank_account => 'Account number';
	@override String get app_name => 'App name';
	@override String get app_link => 'Link / ID';
}

// Path: common.payment_info.hint
class _TranslationsCommonPaymentInfoHintEnUs extends TranslationsCommonPaymentInfoHintZhTw {
	_TranslationsCommonPaymentInfoHintEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get bank_name => 'e.g. Chase Bank';
	@override String get bank_account => 'e.g. 123456789';
	@override String get app_name => 'e.g. Venmo';
	@override String get app_link => 'e.g. venmo-username';
}

// Path: common.remainder_rule.rule
class _TranslationsCommonRemainderRuleRuleEnUs extends TranslationsCommonRemainderRuleRuleZhTw {
	_TranslationsCommonRemainderRuleRuleEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get random => 'Random';
	@override String get order => 'Order';
	@override String get member => 'Member';
}

// Path: common.remainder_rule.content
class _TranslationsCommonRemainderRuleContentEnUs extends TranslationsCommonRemainderRuleContentZhTw {
	_TranslationsCommonRemainderRuleContentEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String remainder({required Object amount}) => 'Remainder ${amount} may occur due to exchange rate conversion or rounding.';
	@override String get random => 'The system will randomly select one member to absorb the remainder.';
	@override String get order => 'Distributes the remainder sequentially based on the order members joined.';
	@override String get member => 'Select a specific member to always absorb the remainder.';
}

// Path: common.terms.label
class _TranslationsCommonTermsLabelEnUs extends TranslationsCommonTermsLabelZhTw {
	_TranslationsCommonTermsLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get terms => 'Terms of Service';
	@override String get privacy => 'Privacy Policy';
	@override String get both => 'Legal Terms';
}

// Path: common.share.invite
class _TranslationsCommonShareInviteEnUs extends TranslationsCommonShareInviteZhTw {
	_TranslationsCommonShareInviteEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get subject => 'Join Iron Split Task';
	@override String content({required Object taskName, required Object code, required Object link}) => 'Join Iron Split task "${taskName}".\nCode: ${code}\nLink: ${link}';
}

// Path: common.share.settlement
class _TranslationsCommonShareSettlementEnUs extends TranslationsCommonShareSettlementZhTw {
	_TranslationsCommonShareSettlementEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get subject => 'Check Iron Split Task Settlement';
	@override String content({required Object taskName, required Object link}) => 'Settlement completed.\nPlease open Iron Split to check your payment for "${taskName}".\nLink: ${link}';
}

// Path: S15_Record_Edit.hint.category
class _TranslationsS15RecordEditHintCategoryEnUs extends TranslationsS15RecordEditHintCategoryZhTw {
	_TranslationsS15RecordEditHintCategoryEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get food => 'Dinner';
	@override String get transport => 'Transportation';
	@override String get shopping => 'Souvenirs';
	@override String get entertainment => 'Tickets';
	@override String get accommodation => 'Accommodation';
	@override String get others => 'Other expenses';
}

// Path: error.dialog.task_full
class _TranslationsErrorDialogTaskFullEnUs extends TranslationsErrorDialogTaskFullZhTw {
	_TranslationsErrorDialogTaskFullEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Full';
	@override String content({required Object limit}) => 'Task member limit (${limit}) reached. Please contact the task leader.';
}

// Path: error.dialog.expired_code
class _TranslationsErrorDialogExpiredCodeEnUs extends TranslationsErrorDialogExpiredCodeZhTw {
	_TranslationsErrorDialogExpiredCodeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invite Expired';
	@override String content({required Object minutes}) => 'Invite link expired (${minutes} minutes). Please ask the task leader for a new one.';
}

// Path: error.dialog.invalid_code
class _TranslationsErrorDialogInvalidCodeEnUs extends TranslationsErrorDialogInvalidCodeZhTw {
	_TranslationsErrorDialogInvalidCodeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invalid Link';
	@override String get content => 'Invalid invite link.';
}

// Path: error.dialog.auth_required
class _TranslationsErrorDialogAuthRequiredEnUs extends TranslationsErrorDialogAuthRequiredZhTw {
	_TranslationsErrorDialogAuthRequiredEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Login Required';
	@override String get content => 'Please log in to join the task.';
}

// Path: error.dialog.already_in_task
class _TranslationsErrorDialogAlreadyInTaskEnUs extends TranslationsErrorDialogAlreadyInTaskZhTw {
	_TranslationsErrorDialogAlreadyInTaskEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Already Member';
	@override String get content => 'Already a member of this task.';
}

// Path: error.dialog.unknown
class _TranslationsErrorDialogUnknownEnUs extends TranslationsErrorDialogUnknownZhTw {
	_TranslationsErrorDialogUnknownEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Error';
	@override String get content => 'An unexpected error occurred.';
}

// Path: error.dialog.delete_failed
class _TranslationsErrorDialogDeleteFailedEnUs extends TranslationsErrorDialogDeleteFailedZhTw {
	_TranslationsErrorDialogDeleteFailedEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Delete Failed';
	@override String get content => 'Delete failed. Please try again later.';
}

// Path: error.dialog.member_delete_failed
class _TranslationsErrorDialogMemberDeleteFailedEnUs extends TranslationsErrorDialogMemberDeleteFailedZhTw {
	_TranslationsErrorDialogMemberDeleteFailedEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Member Deletion Error';
	@override String get content => 'This member still has related expense records or unsettled payments. Please modify or delete the relevant records and try again.';
}

// Path: error.dialog.data_conflict
class _TranslationsErrorDialogDataConflictEnUs extends TranslationsErrorDialogDataConflictZhTw {
	_TranslationsErrorDialogDataConflictEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Data Changed';
	@override String get content => 'Other members updated the records while you were viewing. Please go back and refresh to ensure accuracy.';
}

/// The flat map containing all translations for locale <en-US>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEnUs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.buttons.cancel' => 'Cancel',
			'common.buttons.delete' => 'Delete',
			'common.buttons.confirm' => 'Confirm',
			'common.buttons.back' => 'Back',
			'common.buttons.save' => 'Save',
			'common.buttons.edit' => 'Edit',
			'common.buttons.close' => 'Close',
			'common.buttons.download' => 'Download',
			'common.buttons.settlement' => 'Settle',
			'common.buttons.discard' => 'Discard',
			'common.buttons.keep_editing' => 'Keep Editing',
			'common.buttons.refresh' => 'Refresh',
			'common.buttons.ok' => 'OK',
			'common.buttons.retry' => 'Retry',
			'common.buttons.done' => 'Done',
			'common.buttons.agree' => 'Agree',
			'common.buttons.decline' => 'Decline',
			'common.buttons.add_record' => 'Add',
			'common.buttons.copy' => 'Copy',
			'common.label.task_name' => 'Task name',
			'common.label.item_name' => 'Item Name',
			'common.label.sub_item' => 'Sub Item Name',
			'common.label.amount' => 'Amount',
			'common.label.date' => 'Date',
			'common.label.currency' => 'Currency',
			'common.label.split_method' => 'Split Method',
			'common.label.start_date' => 'Start Date',
			'common.label.end_date' => 'End Date',
			'common.label.member_count' => 'Members',
			'common.label.payment_method' => 'Payment Method',
			'common.label.rate' => 'Exchange Rate',
			'common.label.memo' => 'Memo',
			'common.category.food' => 'Food',
			'common.category.transport' => 'Transport',
			'common.category.shopping' => 'Shopping',
			'common.category.entertainment' => 'Entertainment',
			'common.category.accommodation' => 'Accommodation',
			'common.category.others' => 'Others',
			'common.currency.twd' => 'New Taiwan Dollar',
			'common.currency.jpy' => 'Japanese Yen',
			'common.currency.usd' => 'US Dollar',
			'common.currency.eur' => 'Euro',
			'common.currency.krw' => 'South Korean Won',
			'common.currency.cny' => 'Chinese Yuan',
			'common.currency.gbp' => 'British Pound',
			'common.currency.cad' => 'Canadian Dollar',
			'common.currency.aud' => 'Australian Dollar',
			'common.currency.chf' => 'Swiss Franc',
			'common.currency.dkk' => 'Danish Krone',
			'common.currency.hkd' => 'Hong Kong Dollar',
			'common.currency.nok' => 'Norwegian Krone',
			'common.currency.nzd' => 'New Zealand Dollar',
			'common.currency.sgd' => 'Singapore Dollar',
			'common.currency.thb' => 'Thai Baht',
			'common.currency.zar' => 'South African Rand',
			'common.currency.rub' => 'Russian Ruble',
			'common.currency.vnd' => 'Vietnamese Dong',
			'common.currency.idr' => 'Indonesian Rupiah',
			'common.currency.myr' => 'Malaysian Ringgit',
			'common.currency.php' => 'Philippine Peso',
			'common.currency.mop' => 'Macanese Pataca',
			'common.currency.sek' => 'Swedish Krone',
			'common.currency.aed' => 'UAE Dirham',
			'common.currency.sar' => 'Saudi Riyal',
			'common.currency.try_' => 'Turkish Lira',
			'common.currency.inr' => 'Indian Rupee',
			'common.payment_info.mode.private' => 'Contact me directly',
			'common.payment_info.mode.public' => 'Share payment details',
			'common.payment_info.content.private' => 'Details are hidden. Contact directly for payment details.',
			'common.payment_info.content.public' => 'Payment details will be shown to members.',
			'common.payment_info.type.cash' => 'Cash',
			'common.payment_info.type.bank' => 'Bank Transfer',
			'common.payment_info.type.apps' => 'Payment Apps',
			'common.payment_info.label.bank_name' => 'Bank name / code',
			'common.payment_info.label.bank_account' => 'Account number',
			'common.payment_info.label.app_name' => 'App name',
			'common.payment_info.label.app_link' => 'Link / ID',
			'common.payment_info.hint.bank_name' => 'e.g. Chase Bank',
			'common.payment_info.hint.bank_account' => 'e.g. 123456789',
			'common.payment_info.hint.app_name' => 'e.g. Venmo',
			'common.payment_info.hint.app_link' => 'e.g. venmo-username',
			'common.payment_status.payable' => 'Payable',
			'common.payment_status.refund' => 'Refund',
			'common.avatar.cow' => 'Holstein Friesian',
			'common.avatar.pig' => 'Domestic pig',
			'common.avatar.deer' => 'Roe deer',
			'common.avatar.horse' => 'Chestnut horse',
			'common.avatar.sheep' => 'Suffolk sheep',
			'common.avatar.goat' => 'Domestic goat',
			'common.avatar.duck' => 'Mallard',
			'common.avatar.stoat' => 'Stoat',
			'common.avatar.rabbit' => 'European hare',
			'common.avatar.mouse' => 'House mouse',
			'common.avatar.cat' => 'Domestic tabby cat',
			'common.avatar.dog' => 'Border Collie',
			'common.avatar.otter' => 'Eurasian otter',
			'common.avatar.owl' => 'Barn owl',
			'common.avatar.fox' => 'Red fox',
			'common.avatar.hedgehog' => 'European hedgehog',
			'common.avatar.donkey' => 'Donkey',
			'common.avatar.squirrel' => 'Eurasian red squirrel',
			'common.avatar.badger' => 'European badger',
			'common.avatar.robin' => 'European robin',
			'common.remainder_rule.title' => 'Remainder Rule',
			'common.remainder_rule.rule.random' => 'Random',
			'common.remainder_rule.rule.order' => 'Order',
			'common.remainder_rule.rule.member' => 'Member',
			'common.remainder_rule.content.remainder' => ({required Object amount}) => 'Remainder ${amount} may occur due to exchange rate conversion or rounding.',
			'common.remainder_rule.content.random' => 'The system will randomly select one member to absorb the remainder.',
			'common.remainder_rule.content.order' => 'Distributes the remainder sequentially based on the order members joined.',
			'common.remainder_rule.content.member' => 'Select a specific member to always absorb the remainder.',
			'common.remainder_rule.message_remainder' => ({required Object amount}) => 'Remainder ${amount} will be temporarily stored and distributed at settlement.',
			'common.remainder_rule.message_zero_balance' => ({required Object amount}) => 'Remaining amount ${amount} has been automatically offset against payment differences.',
			'common.split_method.even' => 'Equal',
			'common.split_method.percent' => 'Ratio',
			'common.split_method.exact' => 'Custom',
			'common.payment_method.member' => 'Member Advance',
			'common.payment_method.prepay' => 'Prepaid',
			'common.payment_method.mixed' => 'Mixed Payment',
			'common.language.title' => 'Language Settings',
			'common.language.zh_TW' => 'Traditional Chinese',
			'common.language.en_US' => 'English',
			'common.language.jp_JP' => 'Japanese',
			'common.theme.title' => 'Theme Settings',
			'common.theme.system' => 'System Default',
			'common.theme.light' => 'Light Mode',
			'common.theme.dark' => 'Dark Mode',
			'common.display.title' => 'Display Settings',
			'common.display.system' => 'Follow System',
			'common.display.enlarged' => 'Enlarged',
			'common.display.standard' => 'Standard',
			'common.terms.label.terms' => 'Terms of Service',
			'common.terms.label.privacy' => 'Privacy Policy',
			'common.terms.label.both' => 'Legal Terms',
			'common.terms.and' => ' and ',
			'common.share.invite.subject' => 'Join Iron Split Task',
			'common.share.invite.content' => ({required Object taskName, required Object code, required Object link}) => 'Join Iron Split task "${taskName}".\nCode: ${code}\nLink: ${link}',
			'common.share.settlement.subject' => 'Check Iron Split Task Settlement',
			'common.share.settlement.content' => ({required Object taskName, required Object link}) => 'Settlement completed.\nPlease open Iron Split to check your payment for "${taskName}".\nLink: ${link}',
			'common.preparing' => 'Preparing...',
			'common.me' => 'Me',
			'common.required' => 'Required',
			'common.member_prefix' => 'Member',
			'common.no_record' => 'No Record',
			'common.today' => 'Today',
			'log_action.create_task' => 'Create Task',
			'log_action.update_settings' => 'Update Settings',
			'log_action.add_member' => 'Add Member',
			'log_action.remove_member' => 'Remove Member',
			'log_action.create_record' => 'Create Record',
			'log_action.update_record' => 'Edit Record',
			'log_action.delete_record' => 'Delete Record',
			'log_action.settle_up' => 'Settle Up',
			'log_action.unknown' => 'Unknown Action',
			'log_action.close_task' => 'Close Task',
			'S10_Home_TaskList.title' => 'Task List',
			'S10_Home_TaskList.tab.in_progress' => 'Active',
			'S10_Home_TaskList.tab.completed' => 'Finished',
			'S10_Home_TaskList.empty.in_progress' => 'No active tasks',
			'S10_Home_TaskList.empty.completed' => 'No finished tasks',
			'S10_Home_TaskList.buttons.add_task' => 'Add Task',
			'S10_Home_TaskList.buttons.join_task' => 'Join Task',
			'S10_Home_TaskList.date_tbd' => 'Date TBD',
			'S10_Home_TaskList.label.settlement' => 'Settlement',
			'S11_Invite_Confirm.title' => 'Join Task',
			'S11_Invite_Confirm.subtitle' => 'Invitation to join:',
			'S11_Invite_Confirm.buttons.join' => 'Join',
			'S11_Invite_Confirm.buttons.back_task_list' => 'Home',
			'S11_Invite_Confirm.label.select_ghost' => 'Select Member to Inherit',
			'S11_Invite_Confirm.label.prepaid' => 'Prepaid',
			'S11_Invite_Confirm.label.expense' => 'Expense',
			'S12_TaskClose_Notice.title' => 'Close Task',
			'S12_TaskClose_Notice.buttons.close_task' => 'Close Task',
			'S12_TaskClose_Notice.content' => 'Closing this task will lock all records and settings. The task will enter read-only mode, and no data can be added or edited.',
			'S13_Task_Dashboard.title' => 'Dashboard',
			'S13_Task_Dashboard.buttons.add' => 'Add',
			'S13_Task_Dashboard.tab.group' => 'Group',
			'S13_Task_Dashboard.tab.personal' => 'Personal',
			'S13_Task_Dashboard.label.total_expense' => 'Total Expense',
			'S13_Task_Dashboard.label.total_prepay' => 'Total Prepaid',
			'S13_Task_Dashboard.label.total_expense_personal' => 'Total Expense',
			'S13_Task_Dashboard.label.total_prepay_personal' => 'Total Prepaid (incl. Reimbursed)',
			'S13_Task_Dashboard.empty.records' => 'No records',
			'S13_Task_Dashboard.empty.personal_records' => 'No records',
			'S13_Task_Dashboard.daily_expense_label' => 'Expense',
			'S13_Task_Dashboard.dialog_balance_detail' => 'Balance Details',
			'S13_Task_Dashboard.section.expense' => 'Expense Details',
			'S13_Task_Dashboard.section.prepay' => 'Prepaid Details',
			'S13_Task_Dashboard.section.prepay_balance' => 'Prepaid Balance',
			'S13_Task_Dashboard.section.no_data' => 'No data',
			'S14_Task_Settings.title' => 'Task Settings',
			'S14_Task_Settings.section.task_name' => 'Task Name',
			'S14_Task_Settings.section.task_period' => 'Task Period',
			'S14_Task_Settings.section.settlement' => 'Settlement Settings',
			'S14_Task_Settings.section.other' => 'Other Settings',
			'S14_Task_Settings.menu.invite' => 'Invite',
			'S14_Task_Settings.menu.member_settings' => 'Member Settings',
			'S14_Task_Settings.menu.history' => 'History',
			'S14_Task_Settings.menu.close_task' => 'End Task',
			'S15_Record_Edit.title.add' => 'Add Record',
			'S15_Record_Edit.title.edit' => 'Edit Record',
			'S15_Record_Edit.buttons.add_item' => 'Add Item',
			'S15_Record_Edit.section.split' => 'Split Information',
			'S15_Record_Edit.section.items' => 'Itemized Split',
			'S15_Record_Edit.val.prepay' => 'Prepaid',
			'S15_Record_Edit.val.member_paid' => ({required Object name}) => '${name} paid',
			'S15_Record_Edit.val.split_details' => 'Itemized Split',
			'S15_Record_Edit.val.split_summary' => ({required Object amount, required Object method}) => 'Total ${amount} split by ${method}',
			'S15_Record_Edit.val.converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			'S15_Record_Edit.val.split_remaining' => 'Remaining Amount',
			'S15_Record_Edit.val.mock_note' => 'Item description',
			'S15_Record_Edit.tab.expense' => 'Expense',
			'S15_Record_Edit.tab.prepay' => 'Prepaid',
			'S15_Record_Edit.base_card' => 'Remaining Amount',
			'S15_Record_Edit.type_prepay' => 'Prepaid',
			'S15_Record_Edit.payer_multiple' => 'Multiple',
			'S15_Record_Edit.rate_dialog.title' => 'Exchange Rate Source',
			'S15_Record_Edit.rate_dialog.content' => 'Exchange rate data is provided by Open Exchange Rates (free plan) for reference only. Please refer to your exchange receipt for the actual rate.',
			'S15_Record_Edit.label.rate_with_base' => ({required Object base, required Object target}) => 'Exchange Rate (1 ${base} = ? ${target})',
			'S15_Record_Edit.hint.category.food' => 'Dinner',
			'S15_Record_Edit.hint.category.transport' => 'Transportation',
			'S15_Record_Edit.hint.category.shopping' => 'Souvenirs',
			'S15_Record_Edit.hint.category.entertainment' => 'Tickets',
			'S15_Record_Edit.hint.category.accommodation' => 'Accommodation',
			'S15_Record_Edit.hint.category.others' => 'Other expenses',
			'S15_Record_Edit.hint.item' => ({required Object category}) => 'e.g. ${category}',
			'S15_Record_Edit.hint.memo' => 'e.g. Notes',
			'S16_TaskCreate_Edit.title' => 'New Task',
			'S16_TaskCreate_Edit.section.task_name' => 'Task Name',
			'S16_TaskCreate_Edit.section.task_period' => 'Task Period',
			'S16_TaskCreate_Edit.section.settlement' => 'Settlement Settings',
			'S16_TaskCreate_Edit.label.name_counter' => ({required Object current, required Object max}) => '${current}/${max}',
			'S16_TaskCreate_Edit.hint.name' => 'e.g. Tokyo Trip',
			'S17_Task_Locked.buttons.notify_members' => 'Notify Members',
			'S17_Task_Locked.buttons.view_payment_info' => 'View Payment Details',
			'S17_Task_Locked.section.pending' => 'Pending',
			'S17_Task_Locked.section.cleared' => 'Cleared',
			'S17_Task_Locked.retention_notice' => ({required Object days}) => 'Data will be deleted in ${days} days. Download data before deletion.',
			'S17_Task_Locked.remainder_absorbed_by' => ({required Object name}) => 'Absorbed by ${name}',
			'S17_Task_Locked.export.report_info' => 'Report Information',
			'S17_Task_Locked.export.task_name' => 'Task Name',
			'S17_Task_Locked.export.export_time' => 'Export Time',
			'S17_Task_Locked.export.base_currency' => 'Base Currency',
			'S17_Task_Locked.export.settlement_summary' => 'Settlement Summary',
			'S17_Task_Locked.export.member' => 'Member',
			'S17_Task_Locked.export.role' => 'Role',
			'S17_Task_Locked.export.net_amount' => 'Net Amount',
			'S17_Task_Locked.export.status' => 'Status',
			'S17_Task_Locked.export.receiver' => 'Receivable',
			'S17_Task_Locked.export.payer' => 'Payable',
			'S17_Task_Locked.export.cleared' => 'Cleared',
			'S17_Task_Locked.export.pending' => 'Pending',
			'S17_Task_Locked.export.fund_analysis' => 'Funds & Remainders',
			'S17_Task_Locked.export.total_expense' => 'Total Expense',
			'S17_Task_Locked.export.total_prepay' => 'Total Prepaid',
			'S17_Task_Locked.export.remainder_buffer' => 'Total Remainder',
			'S17_Task_Locked.export.remainder_absorbed_by' => 'Remainder Recipient',
			'S17_Task_Locked.export.transaction_details' => 'Transaction Details',
			'S17_Task_Locked.export.date' => 'Date',
			'S17_Task_Locked.export.title' => 'Title',
			'S17_Task_Locked.export.type' => 'Type',
			'S17_Task_Locked.export.original_amount' => 'Original Amount',
			'S17_Task_Locked.export.currency' => 'Currency',
			'S17_Task_Locked.export.rate' => 'Exchange Rate',
			'S17_Task_Locked.export.base_amount' => 'Base Currency Amount',
			'S17_Task_Locked.export.net_remainder' => 'Remainder',
			'S17_Task_Locked.export.pool' => 'Prepaid Pool',
			'S17_Task_Locked.export.mixed' => 'Mixed Payment',
			'S18_Task_Join.title' => 'Join Task',
			'S18_Task_Join.tabs.input' => 'Enter Code',
			'S18_Task_Join.tabs.scan' => 'Scan QR',
			'S18_Task_Join.label.input' => 'Invite code',
			'S18_Task_Join.hint.input' => 'Enter 8-digit invite code',
			'S18_Task_Join.content.scan' => 'Frame the QR code to scan automatically',
			'S30_settlement_confirm.title' => 'Confirm Settlement',
			'S30_settlement_confirm.buttons.set_payment_info' => 'Payment Info',
			'S30_settlement_confirm.steps.confirm_amount' => 'Confirm Amount',
			'S30_settlement_confirm.steps.payment_info' => 'Payment Info',
			'S30_settlement_confirm.warning.random_reveal' => 'Remainder will be revealed after settlement.',
			'S30_settlement_confirm.list_item.merged_label' => 'Representative',
			'S30_settlement_confirm.list_item.includes' => 'Includes:',
			'S30_settlement_confirm.list_item.principal' => 'Principal',
			'S30_settlement_confirm.list_item.random_remainder' => 'Random Remainder',
			'S30_settlement_confirm.list_item.remainder' => 'Remainder',
			'S31_settlement_payment_info.title' => 'Payment Information',
			'S31_settlement_payment_info.setup_instruction' => 'Used for this settlement only. Default data is encrypted and stored locally.',
			'S31_settlement_payment_info.sync_save' => 'Save as default payment information (stored on this device)',
			'S31_settlement_payment_info.sync_update' => 'Sync and update my default payment information',
			'S31_settlement_payment_info.buttons.prev_step' => 'Previous Step',
			'S32_settlement_result.title' => 'Settlement Complete',
			'S32_settlement_result.content' => 'All records are finalized. Please notify members to complete payment.',
			'S32_settlement_result.waiting_reveal' => 'Revealing result...',
			'S32_settlement_result.remainder_winner_prefix' => 'Remainder recipient:',
			'S32_settlement_result.remainder_winner_total' => ({required Object winnerName, required Object prefix, required Object total}) => '${winnerName}\'s final amount: ${prefix}${total}',
			'S32_settlement_result.total_label' => 'Total Settlement Amount',
			'S32_settlement_result.buttons.share' => 'Send Settlement Notification',
			'S32_settlement_result.buttons.back_task_dashboard' => 'Back to Task',
			'S50_Onboarding_Consent.title' => 'Welcome to Iron Split',
			'S50_Onboarding_Consent.buttons.start' => 'Start',
			'S50_Onboarding_Consent.content.prefix' => 'Make splitting expenses simple.\n\nI’m Iron Rooster. I manage the records and splits here.\nWhether it’s travel, dining, or shared living, every expense is clearly recorded, and every split follows defined rules.\n\nSplitting expenses should be simple and clear.\n\nBy clicking Start, you agree to our ',
			'S50_Onboarding_Consent.content.suffix' => '. We use anonymous login to protect your privacy.',
			'S51_Onboarding_Name.title' => 'Set Your Name',
			'S51_Onboarding_Name.content' => 'Enter display name.',
			'S51_Onboarding_Name.hint' => 'Enter nickname',
			'S51_Onboarding_Name.counter' => ({required Object current, required Object max}) => '${current}/${max}',
			'S52_TaskSettings_Log.title' => 'Activity Log',
			'S52_TaskSettings_Log.buttons.export_csv' => 'Export CSV',
			'S52_TaskSettings_Log.empty_log' => 'No activity logs found',
			'S52_TaskSettings_Log.export_file_prefix' => 'ActivityLog',
			'S52_TaskSettings_Log.csv_header.time' => 'Time',
			'S52_TaskSettings_Log.csv_header.user' => 'User',
			'S52_TaskSettings_Log.csv_header.action' => 'Action',
			'S52_TaskSettings_Log.csv_header.details' => 'Details',
			'S52_TaskSettings_Log.type.prepay' => 'Prepaid',
			'S52_TaskSettings_Log.type.expense' => 'Expense',
			'S52_TaskSettings_Log.payment_type.prepay' => 'Paid from Pool',
			'S52_TaskSettings_Log.payment_type.single_suffix' => 'paid',
			'S52_TaskSettings_Log.payment_type.multiple' => 'Multiple Payers',
			'S52_TaskSettings_Log.unit.members' => 'members',
			'S52_TaskSettings_Log.unit.items' => 'items',
			'S53_TaskSettings_Members.title' => 'Member Management',
			'S53_TaskSettings_Members.buttons.add_member' => 'Add Member',
			'S53_TaskSettings_Members.label.default_ratio' => 'Default Ratio',
			'S53_TaskSettings_Members.member_default_name' => 'Member',
			'S53_TaskSettings_Members.member_name' => 'Member Name',
			'S54_TaskSettings_Invite.title' => 'Task Invite',
			'S54_TaskSettings_Invite.buttons.share' => 'Share',
			'S54_TaskSettings_Invite.buttons.regenerate' => 'Regenerate',
			'S54_TaskSettings_Invite.label.expires_in' => 'Expires in',
			'S54_TaskSettings_Invite.label.invite_expired' => 'Invite code has expired',
			'S70_System_Settings.title' => 'Settings',
			'S70_System_Settings.section.basic' => 'General Settings',
			'S70_System_Settings.section.legal' => 'Legal',
			'S70_System_Settings.section.account' => 'Account Settings',
			'S70_System_Settings.menu.user_name' => 'Display Name',
			'S70_System_Settings.menu.language' => 'Display Language',
			'S70_System_Settings.menu.theme' => 'Theme',
			'S70_System_Settings.menu.terms' => 'Terms of Service',
			'S70_System_Settings.menu.privacy' => 'Privacy Policy',
			'S70_System_Settings.menu.payment_info' => 'Payment Information Settings',
			'S70_System_Settings.menu.delete_account' => 'Delete Account',
			'S72_TermsUpdate.title' => ({required Object type}) => '${type} Updated',
			'S72_TermsUpdate.content' => ({required Object type}) => 'We have updated the ${type}. Please review and accept it to continue using the app.',
			'S74_DeleteAccount_Notice.title' => 'Delete Account',
			'S74_DeleteAccount_Notice.content' => 'This action cannot be undone. Your personal data will be deleted. Leader privileges will be automatically transferred to another member, while records in shared ledgers will remain (as unlinked entries).',
			'S74_DeleteAccount_Notice.buttons.delete_account' => 'Delete Account',
			'D01_MemberRole_Intro.title' => 'Your Character',
			'D01_MemberRole_Intro.buttons.reroll' => 'Change Animal',
			'D01_MemberRole_Intro.buttons.enter' => 'Enter Task',
			'D01_MemberRole_Intro.content' => ({required Object avatar}) => 'This is your avatar ${avatar} for this task.\n${avatar} will represent you in all records.',
			'D01_MemberRole_Intro.reroll.empty' => 'No chances left',
			'D02_Invite_Result.title' => 'Join Failed',
			'D03_TaskCreate_Confirm.title' => 'Create Task',
			'D03_TaskCreate_Confirm.buttons.back_edit' => 'Edit',
			'D04_CommonUnsaved_Confirm.title' => 'Unsaved Changes',
			'D04_CommonUnsaved_Confirm.content' => 'Changes you made will not be saved.',
			'D05_DateJump_NoResult.title' => 'No Record',
			'D05_DateJump_NoResult.content' => 'No record found for this date. Add one?',
			'D06_settlement_confirm.title' => 'Settlement',
			'D06_settlement_confirm.content' => 'The task will be locked upon settlement. Records cannot be added, deleted, or edited after settlement.\nPlease ensure all details are correct.',
			'D08_TaskClosed_Confirm.title' => 'Close Task',
			'D08_TaskClosed_Confirm.content' => 'This action cannot be undone. All data will be locked permanently.\n\nAre you sure you want to proceed?',
			'D09_TaskSettings_CurrencyConfirm.title' => 'Change Base Currency',
			'D09_TaskSettings_CurrencyConfirm.content' => 'Changing currency will reset all exchange rates. This may affect current balances. Are you sure?',
			'D10_RecordDelete_Confirm.title' => 'Delete Record',
			'D10_RecordDelete_Confirm.content' => ({required Object title, required Object amount}) => 'Are you sure you want to delete ${title} (${amount})?',
			'D11_random_result.title' => 'Remainder Result',
			'D11_random_result.skip' => 'Skip',
			'D12_logout_confirm.title' => 'Log Out',
			'D12_logout_confirm.content' => 'If you do not agree to the updated terms, you will not be able to continue using this app.\nLogout will proceed.',
			'D12_logout_confirm.buttons.logout' => 'Log out',
			'D13_DeleteAccount_Confirm.title' => 'Delete Account',
			'D13_DeleteAccount_Confirm.content' => 'This action cannot be undone. All data will be deleted permanently.\n\nAre you sure you want to proceed?',
			'D14_Date_Select.title' => 'Select Date',
			'B02_SplitExpense_Edit.title' => 'Edit Sub Item',
			'B02_SplitExpense_Edit.buttons.confirm_split' => 'Confirm Split',
			'B02_SplitExpense_Edit.item_name_empty' => 'Parent item name is empty',
			'B02_SplitExpense_Edit.hint.sub_item' => 'e.g. Sub-item',
			'B03_SplitMethod_Edit.title' => 'Split Method',
			'B03_SplitMethod_Edit.buttons.adjust_weight' => 'Adjust Weight',
			'B03_SplitMethod_Edit.label.total' => ({required Object current, required Object target}) => 'Total: ${current}/${target}',
			'B03_SplitMethod_Edit.mismatch' => 'Mismatch',
			'B04_payment_merge.title' => 'Merge Member Payments',
			'B04_payment_merge.label.head_member' => 'Representative',
			'B04_payment_merge.label.merge_amount' => 'Total Amount',
			'B07_PaymentMethod_Edit.title' => 'Funding Source',
			'B07_PaymentMethod_Edit.prepay_balance' => ({required Object amount}) => 'Prepaid Balance: ${amount}',
			'B07_PaymentMethod_Edit.payer_member' => 'Payer',
			'B07_PaymentMethod_Edit.label.amount' => 'Payment Amount',
			'B07_PaymentMethod_Edit.label.total_expense' => 'Total Amount',
			'B07_PaymentMethod_Edit.label.prepay' => 'Prepaid',
			'B07_PaymentMethod_Edit.label.total_advance' => 'Total Advance',
			'B07_PaymentMethod_Edit.status.not_enough' => 'Insufficient Balance',
			'B07_PaymentMethod_Edit.status.balanced' => 'Balanced',
			'B07_PaymentMethod_Edit.status.remaining' => ({required Object amount}) => 'Remaining: ${amount}',
			'success.saved' => 'Saved',
			'success.deleted' => 'Deleted',
			'success.copied' => 'Copied',
			'error.title' => 'Error',
			'error.unknown' => ({required Object error}) => 'Unknown error: ${error}',
			'error.dialog.task_full.title' => 'Task Full',
			'error.dialog.task_full.content' => ({required Object limit}) => 'Task member limit (${limit}) reached. Please contact the task leader.',
			'error.dialog.expired_code.title' => 'Invite Expired',
			'error.dialog.expired_code.content' => ({required Object minutes}) => 'Invite link expired (${minutes} minutes). Please ask the task leader for a new one.',
			'error.dialog.invalid_code.title' => 'Invalid Link',
			'error.dialog.invalid_code.content' => 'Invalid invite link.',
			'error.dialog.auth_required.title' => 'Login Required',
			'error.dialog.auth_required.content' => 'Please log in to join the task.',
			'error.dialog.already_in_task.title' => 'Already Member',
			'error.dialog.already_in_task.content' => 'Already a member of this task.',
			'error.dialog.unknown.title' => 'Error',
			'error.dialog.unknown.content' => 'An unexpected error occurred.',
			'error.dialog.delete_failed.title' => 'Delete Failed',
			'error.dialog.delete_failed.content' => 'Delete failed. Please try again later.',
			'error.dialog.member_delete_failed.title' => 'Member Deletion Error',
			'error.dialog.member_delete_failed.content' => 'This member still has related expense records or unsettled payments. Please modify or delete the relevant records and try again.',
			'error.dialog.data_conflict.title' => 'Data Changed',
			'error.dialog.data_conflict.content' => 'Other members updated the records while you were viewing. Please go back and refresh to ensure accuracy.',
			'error.message.unknown' => 'An unexpected error occurred.',
			'error.message.invalid_amount' => 'Invalid amount.',
			'error.message.required' => 'This field is required.',
			'error.message.empty' => ({required Object key}) => 'Please enter ${key}.',
			'error.message.format' => 'Invalid format.',
			'error.message.zero' => ({required Object key}) => '${key} cannot be 0.',
			'error.message.amount_not_enough' => 'Insufficient remaining amount.',
			'error.message.amount_mismatch' => 'Amount mismatch.',
			'error.message.prepay_is_used' => 'This amount has been used or the balance is insufficient.',
			'error.message.data_is_used' => 'This member still has related records or unsettled payments. Please update or delete them first.',
			'error.message.permission_denied' => 'Permission denied.',
			'error.message.network_error' => 'Network connection failed. Please check your internet connection.',
			'error.message.data_not_found' => 'Data not found. Please try again later.',
			'error.message.enter_first' => ({required Object key}) => 'Please enter ${key} first.',
			'error.message.export_failed' => 'Failed to generate report. Please check your storage or try again later.',
			'error.message.save_failed' => 'Failed to save. Please try again.',
			'error.message.delete_failed' => 'Failed to delete. Please try again.',
			'error.message.task_close_failed' => 'Task close failed. Please try again later.',
			'error.message.rate_fetch_failed' => 'Failed to fetch exchange rate.',
			'error.message.length_exceeded' => ({required Object max}) => 'Max ${max} characters.',
			'error.message.invalid_char' => 'Invalid characters.',
			'error.message.invalid_code' => 'Invalid invite code. Please check if the link is correct.',
			'error.message.expired_code' => ({required Object expiry_minutes}) => 'Invite link expired (over ${expiry_minutes} minutes). Please ask the task leader to share again.',
			'error.message.task_full' => ({required Object limit}) => 'Task is full (max ${limit} members).',
			'error.message.auth_required' => 'Authentication failed. Please restart the app.',
			'error.message.init_failed' => 'Loading failed. Please try again.',
			'error.message.unauthorized' => 'Not logged in. Log in again.',
			'error.message.task_locked' => 'This task is settled and locked. Data cannot be modified.',
			'error.message.timeout' => 'Server request timed out. Please try again later.',
			'error.message.quota_exceeded' => 'System quota exceeded. Please try again later.',
			'error.message.join_failed' => 'Failed to join the task. Please try again later.',
			'error.message.invite_create_failed' => 'Failed to create invite code. Please try again later.',
			'error.message.data_conflict' => 'Other members updated the records while you were viewing. Please go back and refresh to ensure accuracy.',
			'error.message.task_status_error' => 'The task status is invalid (may be already settled). Please refresh.',
			'error.message.settlement_failed' => 'System error. Settlement failed. Please try again later.',
			'error.message.share_failed' => 'Share failed. Please try again later.',
			'error.message.login_failed' => 'Login failed. Please try again later.',
			'error.message.logout_failed' => 'Logout failed. Please try again later.',
			'error.message.scan_failed' => 'Scan failed. Please try again later.',
			'error.message.invalid_qr_code' => 'Invalid QR code.',
			'error.message.camera_permission_denied' => 'Enable camera permission in system settings.',
			_ => null,
		};
	}
}
