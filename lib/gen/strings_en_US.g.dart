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
	@override late final _TranslationsS30SettlementConfirmEnUs S30_settlement_confirm = _TranslationsS30SettlementConfirmEnUs._(_root);
	@override late final _TranslationsS31SettlementPaymentInfoEnUs S31_settlement_payment_info = _TranslationsS31SettlementPaymentInfoEnUs._(_root);
	@override late final _TranslationsS32SettlementResultEnUs S32_settlement_result = _TranslationsS32SettlementResultEnUs._(_root);
	@override late final _TranslationsS50OnboardingConsentEnUs S50_Onboarding_Consent = _TranslationsS50OnboardingConsentEnUs._(_root);
	@override late final _TranslationsS51OnboardingNameEnUs S51_Onboarding_Name = _TranslationsS51OnboardingNameEnUs._(_root);
	@override late final _TranslationsS52TaskSettingsLogEnUs S52_TaskSettings_Log = _TranslationsS52TaskSettingsLogEnUs._(_root);
	@override late final _TranslationsS53TaskSettingsMembersEnUs S53_TaskSettings_Members = _TranslationsS53TaskSettingsMembersEnUs._(_root);
	@override late final _TranslationsS70SystemSettingsEnUs S70_System_Settings = _TranslationsS70SystemSettingsEnUs._(_root);
	@override late final _TranslationsS72TermsUpdateEnUs S72_TermsUpdate = _TranslationsS72TermsUpdateEnUs._(_root);
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
	@override late final _TranslationsB02SplitExpenseEditEnUs B02_SplitExpense_Edit = _TranslationsB02SplitExpenseEditEnUs._(_root);
	@override late final _TranslationsB03SplitMethodEditEnUs B03_SplitMethod_Edit = _TranslationsB03SplitMethodEditEnUs._(_root);
	@override late final _TranslationsB04PaymentMergeEnUs B04_payment_merge = _TranslationsB04PaymentMergeEnUs._(_root);
	@override late final _TranslationsB06PaymentInfoDetailEnUs B06_payment_info_detail = _TranslationsB06PaymentInfoDetailEnUs._(_root);
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
	@override late final _TranslationsCommonErrorEnUs error = _TranslationsCommonErrorEnUs._(_root);
	@override late final _TranslationsCommonCategoryEnUs category = _TranslationsCommonCategoryEnUs._(_root);
	@override late final _TranslationsCommonCurrencyEnUs currency = _TranslationsCommonCurrencyEnUs._(_root);
	@override late final _TranslationsCommonPaymentInfoEnUs payment_info = _TranslationsCommonPaymentInfoEnUs._(_root);
	@override late final _TranslationsCommonPaymentStatusEnUs payment_status = _TranslationsCommonPaymentStatusEnUs._(_root);
	@override late final _TranslationsCommonAvatarEnUs avatar = _TranslationsCommonAvatarEnUs._(_root);
	@override late final _TranslationsCommonRemainderRuleEnUs remainder_rule = _TranslationsCommonRemainderRuleEnUs._(_root);
	@override late final _TranslationsCommonSplitMethodEnUs split_method = _TranslationsCommonSplitMethodEnUs._(_root);
	@override late final _TranslationsCommonLanguageEnUs language = _TranslationsCommonLanguageEnUs._(_root);
	@override late final _TranslationsCommonTermsEnUs terms = _TranslationsCommonTermsEnUs._(_root);
	@override late final _TranslationsCommonShareEnUs share = _TranslationsCommonShareEnUs._(_root);
	@override String error_prefix({required Object message}) => 'Error: ${message}';
	@override String get please_login => 'Please Login';
	@override String get loading => 'Loading...';
	@override String get me => 'Me';
	@override String get required => 'Required';
	@override String get member_prefix => 'Member';
	@override String get no_record => 'No Record';
	@override String get today => 'Today';
	@override String get untitled => 'Untitled';
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
	@override String get title => 'My Tasks';
	@override String get tab_in_progress => 'Active';
	@override String get tab_completed => 'Finished';
	@override String get mascot_preparing => 'Iron Rooster preparing...';
	@override String get empty_in_progress => 'No active tasks';
	@override String get empty_completed => 'No finished tasks';
	@override String get date_tbd => 'Date TBD';
	@override String get delete_confirm_title => 'Delete Task';
	@override String get delete_confirm_content => 'Are you sure you want to delete this task?';
	@override String get label_settlement => 'Settlement';
}

// Path: S11_Invite_Confirm
class _TranslationsS11InviteConfirmEnUs extends TranslationsS11InviteConfirmZhTw {
	_TranslationsS11InviteConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Join Task';
	@override String get subtitle => 'You are invited to join:';
	@override late final _TranslationsS11InviteConfirmButtonsEnUs buttons = _TranslationsS11InviteConfirmButtonsEnUs._(_root);
	@override String get loading_invite => 'Loading invite...';
	@override String get join_failed_title => 'Oops! Cannot join task';
	@override String get identity_match_title => 'Are you one of these members?';
	@override String get identity_match_desc => 'This task has pre-created members. If you are one of them, tap to link account; otherwise, join as new.';
	@override String get status_linking => 'Joining by linking account';
	@override String get status_new_member => 'Joining as new member';
	@override String error_join_failed({required Object message}) => 'Join failed: ${message}';
	@override String error_generic({required Object message}) => 'Error: ${message}';
	@override String get label_select_ghost => 'Select Member to Inherit';
	@override String get label_prepaid => 'Prepaid';
	@override String get label_expense => 'Expense';
}

// Path: S12_TaskClose_Notice
class _TranslationsS12TaskCloseNoticeEnUs extends TranslationsS12TaskCloseNoticeZhTw {
	_TranslationsS12TaskCloseNoticeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Close Task';
	@override late final _TranslationsS12TaskCloseNoticeButtonsEnUs buttons = _TranslationsS12TaskCloseNoticeButtonsEnUs._(_root);
	@override String get content => 'Closing this task will lock all records and settings. You will enter Read-Only mode and cannot add or edit any data.';
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
	@override String get daily_expense_label => 'Exp';
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
	@override String get base_card_title => 'Remaining Amount (Base)';
	@override String get type_income_title => 'Advance Payment';
	@override String get base_card_title_expense => 'Remaining Amount (Base)';
	@override String get base_card_title_income => 'Source of Funds (Payer)';
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
	@override late final _TranslationsS16TaskCreateEditButtonsEnUs buttons = _TranslationsS16TaskCreateEditButtonsEnUs._(_root);
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
	@override String retention_notice({required Object days}) => 'Data will be deleted after ${days} days. Please download your records in time.';
	@override String label_remainder_absorbed_by({required Object name}) => 'absorbed by ${name}';
	@override String get section_pending => 'Pending';
	@override String get section_cleared => 'Cleared';
	@override String get member_payment_status_pay => 'To Pay';
	@override String get member_payment_status_receive => 'To Receive';
	@override String get dialog_mark_cleared_title => 'Mark as Cleared';
	@override String dialog_mark_cleared_content({required Object name}) => 'Mark ${name} as cleared?';
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
	@override String get label_payable => 'To Pay';
	@override String get label_refund => 'Refund';
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
	@override String get title => 'Settlement Successful';
	@override String get content => 'Settlement is complete and the task is locked. Please notify members to check the final details.';
	@override String get waiting_reveal => 'Revealing result...';
	@override String get remainder_winner_prefix => 'Remainder goes to:';
	@override String remainder_winner_total({required Object winnerName, required Object prefix, required Object total}) => '\$${winnerName}\'s result change to \$${prefix} \$${total}';
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
	@override String login_failed({required Object message}) => 'Login Failed: ${message}';
}

// Path: S51_Onboarding_Name
class _TranslationsS51OnboardingNameEnUs extends TranslationsS51OnboardingNameZhTw {
	_TranslationsS51OnboardingNameEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Set Display Name';
	@override late final _TranslationsS51OnboardingNameButtonsEnUs buttons = _TranslationsS51OnboardingNameButtonsEnUs._(_root);
	@override String get description => 'Please enter your display name.';
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
	@override String get export_file_prefix => 'Activity_Log';
	@override late final _TranslationsS52TaskSettingsLogCsvHeaderEnUs csv_header = _TranslationsS52TaskSettingsLogCsvHeaderEnUs._(_root);
	@override String get type_income => 'Income';
	@override String get type_expense => 'Expense';
	@override String get label_payment => 'Payment';
	@override String get payment_income => 'Advance';
	@override String get payment_pool => 'Paid from Pool';
	@override String get payment_single_suffix => ' paid';
	@override String get payment_multiple => 'Multiple Payers';
	@override String get unit_members => 'ppl';
	@override String get unit_items => 'items';
}

// Path: S53_TaskSettings_Members
class _TranslationsS53TaskSettingsMembersEnUs extends TranslationsS53TaskSettingsMembersZhTw {
	_TranslationsS53TaskSettingsMembersEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Member Management';
	@override late final _TranslationsS53TaskSettingsMembersButtonsEnUs buttons = _TranslationsS53TaskSettingsMembersButtonsEnUs._(_root);
	@override String get label_default_ratio => 'Default Ratio';
	@override String get member_default_name => 'Member';
	@override String get member_name => 'Member Name';
}

// Path: S70_System_Settings
class _TranslationsS70SystemSettingsEnUs extends TranslationsS70SystemSettingsZhTw {
	_TranslationsS70SystemSettingsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'System Settings';
	@override late final _TranslationsS70SystemSettingsMenuEnUs menu = _TranslationsS70SystemSettingsMenuEnUs._(_root);
}

// Path: S72_TermsUpdate
class _TranslationsS72TermsUpdateEnUs extends TranslationsS72TermsUpdateZhTw {
	_TranslationsS72TermsUpdateEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String title({required Object type}) => '${type} Updated';
	@override String description({required Object type}) => 'We have updated the ${type}. Please review and accept it to continue using the app.';
	@override late final _TranslationsS72TermsUpdateButtonsEnUs buttons = _TranslationsS72TermsUpdateButtonsEnUs._(_root);
}

// Path: D01_MemberRole_Intro
class _TranslationsD01MemberRoleIntroEnUs extends TranslationsD01MemberRoleIntroZhTw {
	_TranslationsD01MemberRoleIntroEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Your Character';
	@override late final _TranslationsD01MemberRoleIntroButtonsEnUs buttons = _TranslationsD01MemberRoleIntroButtonsEnUs._(_root);
	@override late final _TranslationsD01MemberRoleIntroDescriptionEnUs description = _TranslationsD01MemberRoleIntroDescriptionEnUs._(_root);
}

// Path: D02_Invite_Result
class _TranslationsD02InviteResultEnUs extends TranslationsD02InviteResultZhTw {
	_TranslationsD02InviteResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Join Failed';
	@override late final _TranslationsD02InviteResultButtonsEnUs buttons = _TranslationsD02InviteResultButtonsEnUs._(_root);
	@override String get error_INVALID_CODE => 'Invalid invite code. Please check if the link is correct.';
	@override String get error_EXPIRED_CODE => 'Invite link expired (over 15 mins). Please ask the captain to share again.';
	@override String get error_TASK_FULL => 'Task is full (max 15 members). Cannot join.';
	@override String get error_AUTH_REQUIRED => 'Authentication failed. Please restart the App.';
	@override String get error_UNKNOWN => 'Unknown error. Please try again later.';
}

// Path: D03_TaskCreate_Confirm
class _TranslationsD03TaskCreateConfirmEnUs extends TranslationsD03TaskCreateConfirmZhTw {
	_TranslationsD03TaskCreateConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirm Settings';
	@override late final _TranslationsD03TaskCreateConfirmButtonsEnUs buttons = _TranslationsD03TaskCreateConfirmButtonsEnUs._(_root);
	@override String get label_name => 'Name';
	@override String get label_period => 'Period';
	@override String get label_currency => 'Currency';
	@override String get label_members => 'Members';
	@override String get creating_task => 'Creating task...';
	@override String get preparing_share => 'Preparing invite...';
}

// Path: D04_CommonUnsaved_Confirm
class _TranslationsD04CommonUnsavedConfirmEnUs extends TranslationsD04CommonUnsavedConfirmZhTw {
	_TranslationsD04CommonUnsavedConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Unsaved Changes?';
	@override String get content => 'Changes you made will not be saved.';
}

// Path: D05_DateJump_NoResult
class _TranslationsD05DateJumpNoResultEnUs extends TranslationsD05DateJumpNoResultZhTw {
	_TranslationsD05DateJumpNoResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'No Record';
	@override late final _TranslationsD05DateJumpNoResultButtonsEnUs buttons = _TranslationsD05DateJumpNoResultButtonsEnUs._(_root);
	@override String get content => 'No record found for this date. Would you like to add one?';
}

// Path: D06_settlement_confirm
class _TranslationsD06SettlementConfirmEnUs extends TranslationsD06SettlementConfirmZhTw {
	_TranslationsD06SettlementConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirm Settlement';
	@override String get warning_text => 'The task will be locked upon settlement. You will not be able to add, delete, or edit any records.\nPlease ensure all details are correct.';
	@override late final _TranslationsD06SettlementConfirmButtonsEnUs buttons = _TranslationsD06SettlementConfirmButtonsEnUs._(_root);
}

// Path: D08_TaskClosed_Confirm
class _TranslationsD08TaskClosedConfirmEnUs extends TranslationsD08TaskClosedConfirmZhTw {
	_TranslationsD08TaskClosedConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirm Close';
	@override late final _TranslationsD08TaskClosedConfirmButtonsEnUs buttons = _TranslationsD08TaskClosedConfirmButtonsEnUs._(_root);
	@override String get content => 'This action cannot be undone. All data will be locked permanently.\n\nAre you sure you want to proceed?';
}

// Path: D09_TaskSettings_CurrencyConfirm
class _TranslationsD09TaskSettingsCurrencyConfirmEnUs extends TranslationsD09TaskSettingsCurrencyConfirmZhTw {
	_TranslationsD09TaskSettingsCurrencyConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Change Base Currency?';
	@override String get content => 'Changing currency will reset all exchange rates. This may affect current balances. Are you sure?';
}

// Path: D10_RecordDelete_Confirm
class _TranslationsD10RecordDeleteConfirmEnUs extends TranslationsD10RecordDeleteConfirmZhTw {
	_TranslationsD10RecordDeleteConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get delete_record_title => 'Delete Record?';
	@override String delete_record_content({required Object title, required Object amount}) => 'Are you sure you want to delete ${title} (${amount})?';
	@override String get deleted_success => 'Record deleted';
}

// Path: D11_random_result
class _TranslationsD11RandomResultEnUs extends TranslationsD11RandomResultZhTw {
	_TranslationsD11RandomResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Remainder Roulette Winner';
	@override String get skip => 'Skip';
	@override String get winner_reveal => 'It\'s you!';
	@override late final _TranslationsD11RandomResultButtonsEnUs buttons = _TranslationsD11RandomResultButtonsEnUs._(_root);
}

// Path: D12_logout_confirm
class _TranslationsD12LogoutConfirmEnUs extends TranslationsD12LogoutConfirmZhTw {
	_TranslationsD12LogoutConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirm Logout';
	@override String get description => 'If you do not agree to the updated terms, you will not be able to continue using this service.\nYou will be logged out. If you are using an anonymous account, your data may not be recoverable after logging out.';
	@override late final _TranslationsD12LogoutConfirmButtonsEnUs buttons = _TranslationsD12LogoutConfirmButtonsEnUs._(_root);
}

// Path: B02_SplitExpense_Edit
class _TranslationsB02SplitExpenseEditEnUs extends TranslationsB02SplitExpenseEditZhTw {
	_TranslationsB02SplitExpenseEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Edit Sub Item';
	@override late final _TranslationsB02SplitExpenseEditButtonsEnUs buttons = _TranslationsB02SplitExpenseEditButtonsEnUs._(_root);
	@override late final _TranslationsB02SplitExpenseEditLabelEnUs label = _TranslationsB02SplitExpenseEditLabelEnUs._(_root);
	@override String get item_name_empty => 'Parent item name is empty';
	@override late final _TranslationsB02SplitExpenseEditHintEnUs hint = _TranslationsB02SplitExpenseEditHintEnUs._(_root);
}

// Path: B03_SplitMethod_Edit
class _TranslationsB03SplitMethodEditEnUs extends TranslationsB03SplitMethodEditZhTw {
	_TranslationsB03SplitMethodEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Choose Split Method';
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
	@override late final _TranslationsB04PaymentMergeButtonsEnUs buttons = _TranslationsB04PaymentMergeButtonsEnUs._(_root);
}

// Path: B06_payment_info_detail
class _TranslationsB06PaymentInfoDetailEnUs extends TranslationsB06PaymentInfoDetailZhTw {
	_TranslationsB06PaymentInfoDetailEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get label_copied => 'Copied to clipboard';
	@override late final _TranslationsB06PaymentInfoDetailButtonsEnUs buttons = _TranslationsB06PaymentInfoDetailButtonsEnUs._(_root);
}

// Path: B07_PaymentMethod_Edit
class _TranslationsB07PaymentMethodEditEnUs extends TranslationsB07PaymentMethodEditZhTw {
	_TranslationsB07PaymentMethodEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Select Funding Source';
	@override String get type_member => 'Member Advance';
	@override String get type_prepay => 'Public Fund';
	@override String get type_mixed => 'Mixed Payment';
	@override String prepay_balance({required Object amount}) => 'Fund Balance: ${amount}';
	@override String get err_balance_not_enough => 'Insufficient Balance';
	@override String get section_payer => 'Payer';
	@override String get label_amount => 'Payment Amount';
	@override String get total_label => 'Total Amount';
	@override String get total_prepay => 'Public Fund';
	@override String get total_advance => 'Total Advance';
	@override String get status_balanced => 'Balanced';
	@override String status_remaining({required Object amount}) => 'Remaining: ${amount}';
	@override String get msg_auto_fill_prepay => 'Public fund balance auto-filled';
}

// Path: success
class _TranslationsSuccessEnUs extends TranslationsSuccessZhTw {
	_TranslationsSuccessEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get saved => 'Saved successfully';
}

// Path: error
class _TranslationsErrorEnUs extends TranslationsErrorZhTw {
	_TranslationsErrorEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorDialogEnUs dialog = _TranslationsErrorDialogEnUs._(_root);
	@override late final _TranslationsErrorSettlementEnUs settlement = _TranslationsErrorSettlementEnUs._(_root);
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
	@override String get discard => 'Discard';
	@override String get keep_editing => 'Keep Editing';
	@override String get refresh => 'Refresh';
	@override String get ok => 'OK';
	@override String get retry => 'Retry';
}

// Path: common.error
class _TranslationsCommonErrorEnUs extends TranslationsCommonErrorZhTw {
	_TranslationsCommonErrorEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Error';
	@override String unknown({required Object error}) => 'Unknown error: ${error}';
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
	@override late final _TranslationsCommonPaymentInfoDescriptionEnUs description = _TranslationsCommonPaymentInfoDescriptionEnUs._(_root);
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
	@override String get receivable => 'Receivable';
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
	@override late final _TranslationsCommonRemainderRuleDescriptionEnUs description = _TranslationsCommonRemainderRuleDescriptionEnUs._(_root);
	@override String message_remainder({required Object amount}) => 'Remaining amount ${amount} will be stored in the leftover pot, distributed at settlement.';
	@override String message_zero_balance({required Object amount}) => 'Remaining amount ${amount} has been automatically offset against payment differences.';
}

// Path: common.split_method
class _TranslationsCommonSplitMethodEnUs extends TranslationsCommonSplitMethodZhTw {
	_TranslationsCommonSplitMethodEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get even => 'Even';
	@override String get percent => 'By Percentage';
	@override String get exact => 'Exact Amount';
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

// Path: S11_Invite_Confirm.buttons
class _TranslationsS11InviteConfirmButtonsEnUs extends TranslationsS11InviteConfirmButtonsZhTw {
	_TranslationsS11InviteConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Join';
	@override String get cancel => 'Cancel';
	@override String get home => 'Home';
}

// Path: S12_TaskClose_Notice.buttons
class _TranslationsS12TaskCloseNoticeButtonsEnUs extends TranslationsS12TaskCloseNoticeButtonsZhTw {
	_TranslationsS12TaskCloseNoticeButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get close => 'Close Task';
}

// Path: S13_Task_Dashboard.buttons
class _TranslationsS13TaskDashboardButtonsEnUs extends TranslationsS13TaskDashboardButtonsZhTw {
	_TranslationsS13TaskDashboardButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get record => 'Add record';
	@override String get settlement => 'Settlement';
	@override String get download => 'Download Records';
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
	@override String get total_prepay => 'Total Advance';
	@override String get total_expense_personal => 'Total Expense';
	@override String get total_prepay_personal => 'Total Advance (incl. Reimbursed)';
}

// Path: S13_Task_Dashboard.empty
class _TranslationsS13TaskDashboardEmptyEnUs extends TranslationsS13TaskDashboardEmptyZhTw {
	_TranslationsS13TaskDashboardEmptyEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get records => 'No records';
	@override String get personal_records => 'No records related to you on this day';
}

// Path: S13_Task_Dashboard.section
class _TranslationsS13TaskDashboardSectionEnUs extends TranslationsS13TaskDashboardSectionZhTw {
	_TranslationsS13TaskDashboardSectionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get expense => 'Expense Details';
	@override String get income => 'Income Details';
	@override String get prepay_balance => 'Advance Balance';
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
	@override String get save => 'Save Record';
	@override String get close => 'Close';
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
	@override String get prepay => 'Advance';
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
	@override String get income => 'Advance';
}

// Path: S15_Record_Edit.rate_dialog
class _TranslationsS15RecordEditRateDialogEnUs extends TranslationsS15RecordEditRateDialogZhTw {
	_TranslationsS15RecordEditRateDialogEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Exchange Rate Source';
	@override String get message => 'Exchange rate data is provided by Open Exchange Rates (free plan) for reference only. Please refer to your exchange receipt for the actual rate.';
}

// Path: S15_Record_Edit.label
class _TranslationsS15RecordEditLabelEnUs extends TranslationsS15RecordEditLabelZhTw {
	_TranslationsS15RecordEditLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get date => 'Date';
	@override String get title => 'Item Name';
	@override String get payment_method => 'Payment Method';
	@override String get amount => 'Amount';
	@override String rate_with_base({required Object base, required Object target}) => 'Exchange Rate (1 ${base} = ? ${target})';
	@override String get rate => 'Exchange Rate';
	@override String get memo => 'Memo';
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

// Path: S16_TaskCreate_Edit.buttons
class _TranslationsS16TaskCreateEditButtonsEnUs extends TranslationsS16TaskCreateEditButtonsZhTw {
	_TranslationsS16TaskCreateEditButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get save => 'Save';
	@override String get done => 'Done';
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
	@override String get name => 'Task name';
	@override String name_counter({required Object current, required Object max}) => '${current}/${max}';
	@override String get start_date => 'Start Date';
	@override String get end_date => 'End Date';
	@override String get currency => 'Currency';
	@override String get member_count => 'Members';
	@override String get date => 'Date';
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
	@override String get download => 'Download Records';
	@override String get notify_members => 'Notify Members';
	@override String get view_payment_details => 'View Payment Details';
}

// Path: S30_settlement_confirm.buttons
class _TranslationsS30SettlementConfirmButtonsEnUs extends TranslationsS30SettlementConfirmButtonsZhTw {
	_TranslationsS30SettlementConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get next => 'Payment Info';
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
	@override String get random_reveal => 'Remainder will be revealed after settlement!';
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
	@override String get settle => 'Settle';
	@override String get prev_step => 'Previous Step';
}

// Path: S32_settlement_result.buttons
class _TranslationsS32SettlementResultButtonsEnUs extends TranslationsS32SettlementResultButtonsZhTw {
	_TranslationsS32SettlementResultButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get share => 'Send Settlement Notification';
	@override String get back => 'Back to Task';
}

// Path: S50_Onboarding_Consent.buttons
class _TranslationsS50OnboardingConsentButtonsEnUs extends TranslationsS50OnboardingConsentButtonsZhTw {
	_TranslationsS50OnboardingConsentButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get agree => 'Start';
}

// Path: S50_Onboarding_Consent.content
class _TranslationsS50OnboardingConsentContentEnUs extends TranslationsS50OnboardingConsentContentZhTw {
	_TranslationsS50OnboardingConsentContentEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get prefix => 'By clicking Start, you agree to our ';
	@override String get suffix => '. We use anonymous login to protect your privacy.';
}

// Path: S51_Onboarding_Name.buttons
class _TranslationsS51OnboardingNameButtonsEnUs extends TranslationsS51OnboardingNameButtonsZhTw {
	_TranslationsS51OnboardingNameButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get next => 'Set';
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

// Path: S53_TaskSettings_Members.buttons
class _TranslationsS53TaskSettingsMembersButtonsEnUs extends TranslationsS53TaskSettingsMembersButtonsZhTw {
	_TranslationsS53TaskSettingsMembersButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get add => 'Add Member';
	@override String get invite => 'Invite';
}

// Path: S70_System_Settings.menu
class _TranslationsS70SystemSettingsMenuEnUs extends TranslationsS70SystemSettingsMenuZhTw {
	_TranslationsS70SystemSettingsMenuEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get user_name => 'Display Name';
	@override String get language => 'Display Language';
	@override String get terms => 'Terms of Service';
	@override String get privacy => 'Privacy Policy';
	@override String get payment_info => 'Payment Information Settings';
}

// Path: S72_TermsUpdate.buttons
class _TranslationsS72TermsUpdateButtonsEnUs extends TranslationsS72TermsUpdateButtonsZhTw {
	_TranslationsS72TermsUpdateButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get agree => 'Accept';
	@override String get decline => 'Decline';
}

// Path: D01_MemberRole_Intro.buttons
class _TranslationsD01MemberRoleIntroButtonsEnUs extends TranslationsD01MemberRoleIntroButtonsZhTw {
	_TranslationsD01MemberRoleIntroButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get reroll => 'Change Animal';
	@override String get enter => 'Enter Task';
}

// Path: D01_MemberRole_Intro.description
class _TranslationsD01MemberRoleIntroDescriptionEnUs extends TranslationsD01MemberRoleIntroDescriptionZhTw {
	_TranslationsD01MemberRoleIntroDescriptionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String content({required Object avatar}) => 'This is your exclusive avatar ${avatar} for this task. \n${avatar} will represent you in all split records!';
	@override String get reroll_left => '1 chance left';
	@override String get reroll_empty => 'No chances left';
}

// Path: D02_Invite_Result.buttons
class _TranslationsD02InviteResultButtonsEnUs extends TranslationsD02InviteResultButtonsZhTw {
	_TranslationsD02InviteResultButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get back => 'Back to Home';
}

// Path: D03_TaskCreate_Confirm.buttons
class _TranslationsD03TaskCreateConfirmButtonsEnUs extends TranslationsD03TaskCreateConfirmButtonsZhTw {
	_TranslationsD03TaskCreateConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Confirm';
	@override String get back => 'Edit';
}

// Path: D05_DateJump_NoResult.buttons
class _TranslationsD05DateJumpNoResultButtonsEnUs extends TranslationsD05DateJumpNoResultButtonsZhTw {
	_TranslationsD05DateJumpNoResultButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Back';
	@override String get add => 'Add Record';
}

// Path: D06_settlement_confirm.buttons
class _TranslationsD06SettlementConfirmButtonsEnUs extends TranslationsD06SettlementConfirmButtonsZhTw {
	_TranslationsD06SettlementConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Settle';
}

// Path: D08_TaskClosed_Confirm.buttons
class _TranslationsD08TaskClosedConfirmButtonsEnUs extends TranslationsD08TaskClosedConfirmButtonsZhTw {
	_TranslationsD08TaskClosedConfirmButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Confirm';
}

// Path: D11_random_result.buttons
class _TranslationsD11RandomResultButtonsEnUs extends TranslationsD11RandomResultButtonsZhTw {
	_TranslationsD11RandomResultButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get close => 'OK';
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
	@override String get save => 'Confirm Split';
}

// Path: B02_SplitExpense_Edit.label
class _TranslationsB02SplitExpenseEditLabelEnUs extends TranslationsB02SplitExpenseEditLabelZhTw {
	_TranslationsB02SplitExpenseEditLabelEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get sub_item => 'Sub Item Name';
	@override String get split_method => 'Split Method';
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

// Path: B04_payment_merge.buttons
class _TranslationsB04PaymentMergeButtonsEnUs extends TranslationsB04PaymentMergeButtonsZhTw {
	_TranslationsB04PaymentMergeButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancel';
	@override String get confirm => 'Merge';
}

// Path: B06_payment_info_detail.buttons
class _TranslationsB06PaymentInfoDetailButtonsEnUs extends TranslationsB06PaymentInfoDetailButtonsZhTw {
	_TranslationsB06PaymentInfoDetailButtonsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get copy => 'Copy';
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

// Path: error.settlement
class _TranslationsErrorSettlementEnUs extends TranslationsErrorSettlementZhTw {
	_TranslationsErrorSettlementEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get status_invalid => 'The task status is invalid (may be already settled). Please refresh.';
	@override String get permission_denied => 'Only the creator can execute settlement.';
	@override String get transaction_failed => 'System error. Settlement failed. Please try again later.';
}

// Path: error.message
class _TranslationsErrorMessageEnUs extends TranslationsErrorMessageZhTw {
	_TranslationsErrorMessageEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get unknown => 'An unexpected error occurred';
	@override String get invalid_amount => 'Invalid amount';
	@override String get required => 'This field is required';
	@override String empty({required Object key}) => 'Please enter ${key}';
	@override String get format => 'Invalid format';
	@override String zero({required Object key}) => '${key} cannot be 0';
	@override String get amount_not_enough => 'Insufficient remaining amount';
	@override String get amount_mismatch => 'Amount mismatch';
	@override String get income_is_used => 'This amount has already been used';
	@override String get permission_denied => 'Permission denied';
	@override String get network_error => 'Network error. Please try again later';
	@override String get data_not_found => 'Data not found. Please try again later';
	@override String get load_failed => 'Load failed. Please try again later';
	@override String enter_first({required Object key}) => 'Please enter ${key} first';
	@override String get save_failed => 'Save failed. Please try again later';
	@override String get delete_failed => 'Exchange rate update failed';
	@override String get rate_fetch_failed => 'Failed to fetch exchange rate';
	@override String length_exceeded({required Object max}) => 'Max ${max} characters';
	@override String get invalid_char => 'Invalid characters';
}

// Path: common.payment_info.mode
class _TranslationsCommonPaymentInfoModeEnUs extends TranslationsCommonPaymentInfoModeZhTw {
	_TranslationsCommonPaymentInfoModeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get private => 'Contact me directly';
	@override String get public => 'Share payment details';
}

// Path: common.payment_info.description
class _TranslationsCommonPaymentInfoDescriptionEnUs extends TranslationsCommonPaymentInfoDescriptionZhTw {
	_TranslationsCommonPaymentInfoDescriptionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get private => 'Details are hidden. Members should contact you directly';
	@override String get public => 'Payment details will be shown to members';
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

// Path: common.remainder_rule.description
class _TranslationsCommonRemainderRuleDescriptionEnUs extends TranslationsCommonRemainderRuleDescriptionZhTw {
	_TranslationsCommonRemainderRuleDescriptionEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String remainder({required Object amount}) => 'Remainders ${amount} caused by exchange rate conversions or split rounding.';
	@override String get random => 'The system will randomly select one lucky person to absorb the remainder.';
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
	@override String message({required Object taskName, required Object code, required Object link}) => 'Join my Iron Split task "${taskName}"!\nCode: ${code}\nLink: ${link}';
}

// Path: common.share.settlement
class _TranslationsCommonShareSettlementEnUs extends TranslationsCommonShareSettlementZhTw {
	_TranslationsCommonShareSettlementEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get subject => 'Check Iron Split Task Settlement';
	@override String message({required Object taskName, required Object link}) => 'Settlement completed!\nPlease open the Iron Split app to check your "${taskName}" payment amount.\nLink：${link}';
}

// Path: S15_Record_Edit.hint.category
class _TranslationsS15RecordEditHintCategoryEnUs extends TranslationsS15RecordEditHintCategoryZhTw {
	_TranslationsS15RecordEditHintCategoryEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get food => 'Dinner';
	@override String get transport => 'Transportation';
	@override String get shopping => 'Souvenirs';
	@override String get entertainment => 'Movie tickets';
	@override String get accommodation => 'Accommodation';
	@override String get others => 'Other expenses';
}

// Path: error.dialog.task_full
class _TranslationsErrorDialogTaskFullEnUs extends TranslationsErrorDialogTaskFullZhTw {
	_TranslationsErrorDialogTaskFullEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Full';
	@override String message({required Object limit}) => 'Task member limit (${limit}) reached. Please contact captain.';
}

// Path: error.dialog.expired_code
class _TranslationsErrorDialogExpiredCodeEnUs extends TranslationsErrorDialogExpiredCodeZhTw {
	_TranslationsErrorDialogExpiredCodeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invite Expired';
	@override String message({required Object minutes}) => 'Invite link expired (${minutes} mins). Please ask captain for a new one.';
}

// Path: error.dialog.invalid_code
class _TranslationsErrorDialogInvalidCodeEnUs extends TranslationsErrorDialogInvalidCodeZhTw {
	_TranslationsErrorDialogInvalidCodeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invalid Link';
	@override String get message => 'Invalid invite link.';
}

// Path: error.dialog.auth_required
class _TranslationsErrorDialogAuthRequiredEnUs extends TranslationsErrorDialogAuthRequiredZhTw {
	_TranslationsErrorDialogAuthRequiredEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Login Required';
	@override String get message => 'Please login to join task.';
}

// Path: error.dialog.already_in_task
class _TranslationsErrorDialogAlreadyInTaskEnUs extends TranslationsErrorDialogAlreadyInTaskZhTw {
	_TranslationsErrorDialogAlreadyInTaskEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Already Member';
	@override String get message => 'You are already in this task.';
}

// Path: error.dialog.unknown
class _TranslationsErrorDialogUnknownEnUs extends TranslationsErrorDialogUnknownZhTw {
	_TranslationsErrorDialogUnknownEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Error';
	@override String get message => 'An unexpected error occurred.';
}

// Path: error.dialog.delete_failed
class _TranslationsErrorDialogDeleteFailedEnUs extends TranslationsErrorDialogDeleteFailedZhTw {
	_TranslationsErrorDialogDeleteFailedEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Delete Failed';
	@override String get message => 'Deleted failed. Please try again later.';
}

// Path: error.dialog.member_delete_failed
class _TranslationsErrorDialogMemberDeleteFailedEnUs extends TranslationsErrorDialogMemberDeleteFailedZhTw {
	_TranslationsErrorDialogMemberDeleteFailedEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Member Deletion Error';
	@override String get message => 'This member still has related expense records or unsettled payments. Please modify or delete the relevant records and try again.';
}

// Path: error.dialog.data_conflict
class _TranslationsErrorDialogDataConflictEnUs extends TranslationsErrorDialogDataConflictZhTw {
	_TranslationsErrorDialogDataConflictEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Data Changed';
	@override String get message => 'Other members updated the records while you were viewing. Please go back and refresh to ensure accuracy.';
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
			'common.buttons.discard' => 'Discard',
			'common.buttons.keep_editing' => 'Keep Editing',
			'common.buttons.refresh' => 'Refresh',
			'common.buttons.ok' => 'OK',
			'common.buttons.retry' => 'Retry',
			'common.error.title' => 'Error',
			'common.error.unknown' => ({required Object error}) => 'Unknown error: ${error}',
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
			'common.payment_info.description.private' => 'Details are hidden. Members should contact you directly',
			'common.payment_info.description.public' => 'Payment details will be shown to members',
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
			'common.payment_status.receivable' => 'Receivable',
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
			'common.remainder_rule.description.remainder' => ({required Object amount}) => 'Remainders ${amount} caused by exchange rate conversions or split rounding.',
			'common.remainder_rule.description.random' => 'The system will randomly select one lucky person to absorb the remainder.',
			'common.remainder_rule.description.order' => 'Distributes the remainder sequentially based on the order members joined.',
			'common.remainder_rule.description.member' => 'Select a specific member to always absorb the remainder.',
			'common.remainder_rule.message_remainder' => ({required Object amount}) => 'Remaining amount ${amount} will be stored in the leftover pot, distributed at settlement.',
			'common.remainder_rule.message_zero_balance' => ({required Object amount}) => 'Remaining amount ${amount} has been automatically offset against payment differences.',
			'common.split_method.even' => 'Even',
			'common.split_method.percent' => 'By Percentage',
			'common.split_method.exact' => 'Exact Amount',
			'common.language.title' => 'Language Settings',
			'common.language.zh_TW' => 'Traditional Chinese',
			'common.language.en_US' => 'English',
			'common.language.jp_JP' => 'Japanese',
			'common.terms.label.terms' => 'Terms of Service',
			'common.terms.label.privacy' => 'Privacy Policy',
			'common.terms.label.both' => 'Legal Terms',
			'common.terms.and' => ' and ',
			'common.share.invite.subject' => 'Join Iron Split Task',
			'common.share.invite.message' => ({required Object taskName, required Object code, required Object link}) => 'Join my Iron Split task "${taskName}"!\nCode: ${code}\nLink: ${link}',
			'common.share.settlement.subject' => 'Check Iron Split Task Settlement',
			'common.share.settlement.message' => ({required Object taskName, required Object link}) => 'Settlement completed!\nPlease open the Iron Split app to check your "${taskName}" payment amount.\nLink：${link}',
			'common.error_prefix' => ({required Object message}) => 'Error: ${message}',
			'common.please_login' => 'Please Login',
			'common.loading' => 'Loading...',
			'common.me' => 'Me',
			'common.required' => 'Required',
			'common.member_prefix' => 'Member',
			'common.no_record' => 'No Record',
			'common.today' => 'Today',
			'common.untitled' => 'Untitled',
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
			'S10_Home_TaskList.title' => 'My Tasks',
			'S10_Home_TaskList.tab_in_progress' => 'Active',
			'S10_Home_TaskList.tab_completed' => 'Finished',
			'S10_Home_TaskList.mascot_preparing' => 'Iron Rooster preparing...',
			'S10_Home_TaskList.empty_in_progress' => 'No active tasks',
			'S10_Home_TaskList.empty_completed' => 'No finished tasks',
			'S10_Home_TaskList.date_tbd' => 'Date TBD',
			'S10_Home_TaskList.delete_confirm_title' => 'Delete Task',
			'S10_Home_TaskList.delete_confirm_content' => 'Are you sure you want to delete this task?',
			'S10_Home_TaskList.label_settlement' => 'Settlement',
			'S11_Invite_Confirm.title' => 'Join Task',
			'S11_Invite_Confirm.subtitle' => 'You are invited to join:',
			'S11_Invite_Confirm.buttons.confirm' => 'Join',
			'S11_Invite_Confirm.buttons.cancel' => 'Cancel',
			'S11_Invite_Confirm.buttons.home' => 'Home',
			'S11_Invite_Confirm.loading_invite' => 'Loading invite...',
			'S11_Invite_Confirm.join_failed_title' => 'Oops! Cannot join task',
			'S11_Invite_Confirm.identity_match_title' => 'Are you one of these members?',
			'S11_Invite_Confirm.identity_match_desc' => 'This task has pre-created members. If you are one of them, tap to link account; otherwise, join as new.',
			'S11_Invite_Confirm.status_linking' => 'Joining by linking account',
			'S11_Invite_Confirm.status_new_member' => 'Joining as new member',
			'S11_Invite_Confirm.error_join_failed' => ({required Object message}) => 'Join failed: ${message}',
			'S11_Invite_Confirm.error_generic' => ({required Object message}) => 'Error: ${message}',
			'S11_Invite_Confirm.label_select_ghost' => 'Select Member to Inherit',
			'S11_Invite_Confirm.label_prepaid' => 'Prepaid',
			'S11_Invite_Confirm.label_expense' => 'Expense',
			'S12_TaskClose_Notice.title' => 'Close Task',
			'S12_TaskClose_Notice.buttons.close' => 'Close Task',
			'S12_TaskClose_Notice.content' => 'Closing this task will lock all records and settings. You will enter Read-Only mode and cannot add or edit any data.',
			'S13_Task_Dashboard.title' => 'Dashboard',
			'S13_Task_Dashboard.buttons.record' => 'Add record',
			'S13_Task_Dashboard.buttons.settlement' => 'Settlement',
			'S13_Task_Dashboard.buttons.download' => 'Download Records',
			'S13_Task_Dashboard.buttons.add' => 'Add',
			'S13_Task_Dashboard.tab.group' => 'Group',
			'S13_Task_Dashboard.tab.personal' => 'Personal',
			'S13_Task_Dashboard.label.total_expense' => 'Total Expense',
			'S13_Task_Dashboard.label.total_prepay' => 'Total Advance',
			'S13_Task_Dashboard.label.total_expense_personal' => 'Total Expense',
			'S13_Task_Dashboard.label.total_prepay_personal' => 'Total Advance (incl. Reimbursed)',
			'S13_Task_Dashboard.empty.records' => 'No records',
			'S13_Task_Dashboard.empty.personal_records' => 'No records related to you on this day',
			'S13_Task_Dashboard.daily_expense_label' => 'Exp',
			'S13_Task_Dashboard.dialog_balance_detail' => 'Balance Details',
			'S13_Task_Dashboard.section.expense' => 'Expense Details',
			'S13_Task_Dashboard.section.income' => 'Income Details',
			'S13_Task_Dashboard.section.prepay_balance' => 'Advance Balance',
			'S13_Task_Dashboard.section.no_data' => 'No data',
			'S14_Task_Settings.title' => 'Task Settings',
			'S14_Task_Settings.section.task_name' => 'Task Name',
			'S14_Task_Settings.section.task_period' => 'Task Period',
			'S14_Task_Settings.section.settlement' => 'Settlement Settings',
			'S14_Task_Settings.section.other' => 'Other Settings',
			'S14_Task_Settings.menu.member_settings' => 'Member Settings',
			'S14_Task_Settings.menu.history' => 'History',
			'S14_Task_Settings.menu.close_task' => 'End Task',
			'S15_Record_Edit.title.add' => 'Add Record',
			'S15_Record_Edit.title.edit' => 'Edit Record',
			'S15_Record_Edit.buttons.save' => 'Save Record',
			'S15_Record_Edit.buttons.close' => 'Close',
			'S15_Record_Edit.buttons.add_item' => 'Add Item',
			'S15_Record_Edit.section.split' => 'Split Information',
			'S15_Record_Edit.section.items' => 'Itemized Split',
			'S15_Record_Edit.val.prepay' => 'Advance',
			'S15_Record_Edit.val.member_paid' => ({required Object name}) => '${name} paid',
			'S15_Record_Edit.val.split_details' => 'Itemized Split',
			'S15_Record_Edit.val.split_summary' => ({required Object amount, required Object method}) => 'Total ${amount} split by ${method}',
			'S15_Record_Edit.val.converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			'S15_Record_Edit.val.split_remaining' => 'Remaining Amount',
			'S15_Record_Edit.val.mock_note' => 'Item description',
			'S15_Record_Edit.tab.expense' => 'Expense',
			'S15_Record_Edit.tab.income' => 'Advance',
			'S15_Record_Edit.base_card_title' => 'Remaining Amount (Base)',
			'S15_Record_Edit.type_income_title' => 'Advance Payment',
			'S15_Record_Edit.base_card_title_expense' => 'Remaining Amount (Base)',
			'S15_Record_Edit.base_card_title_income' => 'Source of Funds (Payer)',
			'S15_Record_Edit.payer_multiple' => 'Multiple',
			'S15_Record_Edit.rate_dialog.title' => 'Exchange Rate Source',
			'S15_Record_Edit.rate_dialog.message' => 'Exchange rate data is provided by Open Exchange Rates (free plan) for reference only. Please refer to your exchange receipt for the actual rate.',
			'S15_Record_Edit.label.date' => 'Date',
			'S15_Record_Edit.label.title' => 'Item Name',
			'S15_Record_Edit.label.payment_method' => 'Payment Method',
			'S15_Record_Edit.label.amount' => 'Amount',
			'S15_Record_Edit.label.rate_with_base' => ({required Object base, required Object target}) => 'Exchange Rate (1 ${base} = ? ${target})',
			'S15_Record_Edit.label.rate' => 'Exchange Rate',
			'S15_Record_Edit.label.memo' => 'Memo',
			'S15_Record_Edit.hint.category.food' => 'Dinner',
			'S15_Record_Edit.hint.category.transport' => 'Transportation',
			'S15_Record_Edit.hint.category.shopping' => 'Souvenirs',
			'S15_Record_Edit.hint.category.entertainment' => 'Movie tickets',
			'S15_Record_Edit.hint.category.accommodation' => 'Accommodation',
			'S15_Record_Edit.hint.category.others' => 'Other expenses',
			'S15_Record_Edit.hint.item' => ({required Object category}) => 'e.g. ${category}',
			'S15_Record_Edit.hint.memo' => 'e.g. Notes',
			'S16_TaskCreate_Edit.title' => 'New Task',
			'S16_TaskCreate_Edit.buttons.save' => 'Save',
			'S16_TaskCreate_Edit.buttons.done' => 'Done',
			'S16_TaskCreate_Edit.section.task_name' => 'Task Name',
			'S16_TaskCreate_Edit.section.task_period' => 'Task Period',
			'S16_TaskCreate_Edit.section.settlement' => 'Settlement Settings',
			'S16_TaskCreate_Edit.label.name' => 'Task name',
			'S16_TaskCreate_Edit.label.name_counter' => ({required Object current, required Object max}) => '${current}/${max}',
			'S16_TaskCreate_Edit.label.start_date' => 'Start Date',
			'S16_TaskCreate_Edit.label.end_date' => 'End Date',
			'S16_TaskCreate_Edit.label.currency' => 'Currency',
			'S16_TaskCreate_Edit.label.member_count' => 'Members',
			'S16_TaskCreate_Edit.label.date' => 'Date',
			'S16_TaskCreate_Edit.hint.name' => 'e.g. Tokyo Trip',
			'S17_Task_Locked.buttons.download' => 'Download Records',
			'S17_Task_Locked.buttons.notify_members' => 'Notify Members',
			'S17_Task_Locked.buttons.view_payment_details' => 'View Payment Details',
			'S17_Task_Locked.retention_notice' => ({required Object days}) => 'Data will be deleted after ${days} days. Please download your records in time.',
			'S17_Task_Locked.label_remainder_absorbed_by' => ({required Object name}) => 'absorbed by ${name}',
			'S17_Task_Locked.section_pending' => 'Pending',
			'S17_Task_Locked.section_cleared' => 'Cleared',
			'S17_Task_Locked.member_payment_status_pay' => 'To Pay',
			'S17_Task_Locked.member_payment_status_receive' => 'To Receive',
			'S17_Task_Locked.dialog_mark_cleared_title' => 'Mark as Cleared',
			'S17_Task_Locked.dialog_mark_cleared_content' => ({required Object name}) => 'Mark ${name} as cleared?',
			'S30_settlement_confirm.title' => 'Confirm Settlement',
			'S30_settlement_confirm.buttons.next' => 'Payment Info',
			'S30_settlement_confirm.steps.confirm_amount' => 'Confirm Amount',
			'S30_settlement_confirm.steps.payment_info' => 'Payment Info',
			'S30_settlement_confirm.warning.random_reveal' => 'Remainder will be revealed after settlement!',
			'S30_settlement_confirm.label_payable' => 'To Pay',
			'S30_settlement_confirm.label_refund' => 'Refund',
			'S30_settlement_confirm.list_item.merged_label' => 'Representative',
			'S30_settlement_confirm.list_item.includes' => 'Includes:',
			'S30_settlement_confirm.list_item.principal' => 'Principal',
			'S30_settlement_confirm.list_item.random_remainder' => 'Random Remainder',
			'S30_settlement_confirm.list_item.remainder' => 'Remainder',
			'S31_settlement_payment_info.title' => 'Payment Information',
			'S31_settlement_payment_info.setup_instruction' => 'Used for this settlement only. Default data is encrypted and stored locally.',
			'S31_settlement_payment_info.sync_save' => 'Save as default payment information (stored on this device)',
			'S31_settlement_payment_info.sync_update' => 'Sync and update my default payment information',
			'S31_settlement_payment_info.buttons.settle' => 'Settle',
			'S31_settlement_payment_info.buttons.prev_step' => 'Previous Step',
			'S32_settlement_result.title' => 'Settlement Successful',
			'S32_settlement_result.content' => 'Settlement is complete and the task is locked. Please notify members to check the final details.',
			'S32_settlement_result.waiting_reveal' => 'Revealing result...',
			'S32_settlement_result.remainder_winner_prefix' => 'Remainder goes to:',
			'S32_settlement_result.remainder_winner_total' => ({required Object winnerName, required Object prefix, required Object total}) => '\$${winnerName}\'s result change to \$${prefix} \$${total}',
			'S32_settlement_result.total_label' => 'Total Settlement Amount',
			'S32_settlement_result.buttons.share' => 'Send Settlement Notification',
			'S32_settlement_result.buttons.back' => 'Back to Task',
			'S50_Onboarding_Consent.title' => 'Welcome to Iron Split',
			'S50_Onboarding_Consent.buttons.agree' => 'Start',
			'S50_Onboarding_Consent.content.prefix' => 'By clicking Start, you agree to our ',
			'S50_Onboarding_Consent.content.suffix' => '. We use anonymous login to protect your privacy.',
			'S50_Onboarding_Consent.login_failed' => ({required Object message}) => 'Login Failed: ${message}',
			'S51_Onboarding_Name.title' => 'Set Display Name',
			'S51_Onboarding_Name.buttons.next' => 'Set',
			'S51_Onboarding_Name.description' => 'Please enter your display name.',
			'S51_Onboarding_Name.hint' => 'Enter nickname',
			'S51_Onboarding_Name.counter' => ({required Object current, required Object max}) => '${current}/${max}',
			'S52_TaskSettings_Log.title' => 'Activity Log',
			'S52_TaskSettings_Log.buttons.export_csv' => 'Export CSV',
			'S52_TaskSettings_Log.empty_log' => 'No activity logs found',
			'S52_TaskSettings_Log.export_file_prefix' => 'Activity_Log',
			'S52_TaskSettings_Log.csv_header.time' => 'Time',
			'S52_TaskSettings_Log.csv_header.user' => 'User',
			'S52_TaskSettings_Log.csv_header.action' => 'Action',
			'S52_TaskSettings_Log.csv_header.details' => 'Details',
			'S52_TaskSettings_Log.type_income' => 'Income',
			'S52_TaskSettings_Log.type_expense' => 'Expense',
			'S52_TaskSettings_Log.label_payment' => 'Payment',
			'S52_TaskSettings_Log.payment_income' => 'Advance',
			'S52_TaskSettings_Log.payment_pool' => 'Paid from Pool',
			'S52_TaskSettings_Log.payment_single_suffix' => ' paid',
			'S52_TaskSettings_Log.payment_multiple' => 'Multiple Payers',
			'S52_TaskSettings_Log.unit_members' => 'ppl',
			'S52_TaskSettings_Log.unit_items' => 'items',
			'S53_TaskSettings_Members.title' => 'Member Management',
			'S53_TaskSettings_Members.buttons.add' => 'Add Member',
			'S53_TaskSettings_Members.buttons.invite' => 'Invite',
			'S53_TaskSettings_Members.label_default_ratio' => 'Default Ratio',
			'S53_TaskSettings_Members.member_default_name' => 'Member',
			'S53_TaskSettings_Members.member_name' => 'Member Name',
			'S70_System_Settings.title' => 'System Settings',
			'S70_System_Settings.menu.user_name' => 'Display Name',
			'S70_System_Settings.menu.language' => 'Display Language',
			'S70_System_Settings.menu.terms' => 'Terms of Service',
			'S70_System_Settings.menu.privacy' => 'Privacy Policy',
			'S70_System_Settings.menu.payment_info' => 'Payment Information Settings',
			'S72_TermsUpdate.title' => ({required Object type}) => '${type} Updated',
			'S72_TermsUpdate.description' => ({required Object type}) => 'We have updated the ${type}. Please review and accept it to continue using the app.',
			'S72_TermsUpdate.buttons.agree' => 'Accept',
			'S72_TermsUpdate.buttons.decline' => 'Decline',
			'D01_MemberRole_Intro.title' => 'Your Character',
			'D01_MemberRole_Intro.buttons.reroll' => 'Change Animal',
			'D01_MemberRole_Intro.buttons.enter' => 'Enter Task',
			'D01_MemberRole_Intro.description.content' => ({required Object avatar}) => 'This is your exclusive avatar ${avatar} for this task. \n${avatar} will represent you in all split records!',
			'D01_MemberRole_Intro.description.reroll_left' => '1 chance left',
			'D01_MemberRole_Intro.description.reroll_empty' => 'No chances left',
			'D02_Invite_Result.title' => 'Join Failed',
			'D02_Invite_Result.buttons.back' => 'Back to Home',
			'D02_Invite_Result.error_INVALID_CODE' => 'Invalid invite code. Please check if the link is correct.',
			'D02_Invite_Result.error_EXPIRED_CODE' => 'Invite link expired (over 15 mins). Please ask the captain to share again.',
			'D02_Invite_Result.error_TASK_FULL' => 'Task is full (max 15 members). Cannot join.',
			'D02_Invite_Result.error_AUTH_REQUIRED' => 'Authentication failed. Please restart the App.',
			'D02_Invite_Result.error_UNKNOWN' => 'Unknown error. Please try again later.',
			'D03_TaskCreate_Confirm.title' => 'Confirm Settings',
			'D03_TaskCreate_Confirm.buttons.confirm' => 'Confirm',
			'D03_TaskCreate_Confirm.buttons.back' => 'Edit',
			'D03_TaskCreate_Confirm.label_name' => 'Name',
			'D03_TaskCreate_Confirm.label_period' => 'Period',
			'D03_TaskCreate_Confirm.label_currency' => 'Currency',
			'D03_TaskCreate_Confirm.label_members' => 'Members',
			'D03_TaskCreate_Confirm.creating_task' => 'Creating task...',
			'D03_TaskCreate_Confirm.preparing_share' => 'Preparing invite...',
			'D04_CommonUnsaved_Confirm.title' => 'Unsaved Changes?',
			'D04_CommonUnsaved_Confirm.content' => 'Changes you made will not be saved.',
			'D05_DateJump_NoResult.title' => 'No Record',
			'D05_DateJump_NoResult.buttons.cancel' => 'Back',
			'D05_DateJump_NoResult.buttons.add' => 'Add Record',
			'D05_DateJump_NoResult.content' => 'No record found for this date. Would you like to add one?',
			'D06_settlement_confirm.title' => 'Confirm Settlement',
			'D06_settlement_confirm.warning_text' => 'The task will be locked upon settlement. You will not be able to add, delete, or edit any records.\nPlease ensure all details are correct.',
			'D06_settlement_confirm.buttons.confirm' => 'Settle',
			'D08_TaskClosed_Confirm.title' => 'Confirm Close',
			'D08_TaskClosed_Confirm.buttons.confirm' => 'Confirm',
			'D08_TaskClosed_Confirm.content' => 'This action cannot be undone. All data will be locked permanently.\n\nAre you sure you want to proceed?',
			'D09_TaskSettings_CurrencyConfirm.title' => 'Change Base Currency?',
			'D09_TaskSettings_CurrencyConfirm.content' => 'Changing currency will reset all exchange rates. This may affect current balances. Are you sure?',
			'D10_RecordDelete_Confirm.delete_record_title' => 'Delete Record?',
			'D10_RecordDelete_Confirm.delete_record_content' => ({required Object title, required Object amount}) => 'Are you sure you want to delete ${title} (${amount})?',
			'D10_RecordDelete_Confirm.deleted_success' => 'Record deleted',
			'D11_random_result.title' => 'Remainder Roulette Winner',
			'D11_random_result.skip' => 'Skip',
			'D11_random_result.winner_reveal' => 'It\'s you!',
			'D11_random_result.buttons.close' => 'OK',
			'D12_logout_confirm.title' => 'Confirm Logout',
			'D12_logout_confirm.description' => 'If you do not agree to the updated terms, you will not be able to continue using this service.\nYou will be logged out. If you are using an anonymous account, your data may not be recoverable after logging out.',
			'D12_logout_confirm.buttons.logout' => 'Log out',
			'B02_SplitExpense_Edit.title' => 'Edit Sub Item',
			'B02_SplitExpense_Edit.buttons.save' => 'Confirm Split',
			'B02_SplitExpense_Edit.label.sub_item' => 'Sub Item Name',
			'B02_SplitExpense_Edit.label.split_method' => 'Split Method',
			'B02_SplitExpense_Edit.item_name_empty' => 'Parent item name is empty',
			'B02_SplitExpense_Edit.hint.sub_item' => 'e.g. Sub-item',
			'B03_SplitMethod_Edit.title' => 'Choose Split Method',
			'B03_SplitMethod_Edit.buttons.adjust_weight' => 'Adjust Weight',
			'B03_SplitMethod_Edit.label.total' => ({required Object current, required Object target}) => 'Total: ${current}/${target}',
			'B03_SplitMethod_Edit.mismatch' => 'Mismatch',
			'B04_payment_merge.title' => 'Merge Member Payments',
			'B04_payment_merge.label.head_member' => 'Representative',
			'B04_payment_merge.label.merge_amount' => 'Total Amount',
			'B04_payment_merge.buttons.cancel' => 'Cancel',
			'B04_payment_merge.buttons.confirm' => 'Merge',
			'B06_payment_info_detail.label_copied' => 'Copied to clipboard',
			'B06_payment_info_detail.buttons.copy' => 'Copy',
			'B07_PaymentMethod_Edit.title' => 'Select Funding Source',
			'B07_PaymentMethod_Edit.type_member' => 'Member Advance',
			'B07_PaymentMethod_Edit.type_prepay' => 'Public Fund',
			'B07_PaymentMethod_Edit.type_mixed' => 'Mixed Payment',
			'B07_PaymentMethod_Edit.prepay_balance' => ({required Object amount}) => 'Fund Balance: ${amount}',
			'B07_PaymentMethod_Edit.err_balance_not_enough' => 'Insufficient Balance',
			'B07_PaymentMethod_Edit.section_payer' => 'Payer',
			'B07_PaymentMethod_Edit.label_amount' => 'Payment Amount',
			'B07_PaymentMethod_Edit.total_label' => 'Total Amount',
			'B07_PaymentMethod_Edit.total_prepay' => 'Public Fund',
			'B07_PaymentMethod_Edit.total_advance' => 'Total Advance',
			'B07_PaymentMethod_Edit.status_balanced' => 'Balanced',
			'B07_PaymentMethod_Edit.status_remaining' => ({required Object amount}) => 'Remaining: ${amount}',
			'B07_PaymentMethod_Edit.msg_auto_fill_prepay' => 'Public fund balance auto-filled',
			'success.saved' => 'Saved successfully',
			'error.dialog.task_full.title' => 'Task Full',
			'error.dialog.task_full.message' => ({required Object limit}) => 'Task member limit (${limit}) reached. Please contact captain.',
			'error.dialog.expired_code.title' => 'Invite Expired',
			'error.dialog.expired_code.message' => ({required Object minutes}) => 'Invite link expired (${minutes} mins). Please ask captain for a new one.',
			'error.dialog.invalid_code.title' => 'Invalid Link',
			'error.dialog.invalid_code.message' => 'Invalid invite link.',
			'error.dialog.auth_required.title' => 'Login Required',
			'error.dialog.auth_required.message' => 'Please login to join task.',
			'error.dialog.already_in_task.title' => 'Already Member',
			'error.dialog.already_in_task.message' => 'You are already in this task.',
			'error.dialog.unknown.title' => 'Error',
			'error.dialog.unknown.message' => 'An unexpected error occurred.',
			'error.dialog.delete_failed.title' => 'Delete Failed',
			'error.dialog.delete_failed.message' => 'Deleted failed. Please try again later.',
			'error.dialog.member_delete_failed.title' => 'Member Deletion Error',
			'error.dialog.member_delete_failed.message' => 'This member still has related expense records or unsettled payments. Please modify or delete the relevant records and try again.',
			'error.dialog.data_conflict.title' => 'Data Changed',
			'error.dialog.data_conflict.message' => 'Other members updated the records while you were viewing. Please go back and refresh to ensure accuracy.',
			'error.settlement.status_invalid' => 'The task status is invalid (may be already settled). Please refresh.',
			'error.settlement.permission_denied' => 'Only the creator can execute settlement.',
			'error.settlement.transaction_failed' => 'System error. Settlement failed. Please try again later.',
			'error.message.unknown' => 'An unexpected error occurred',
			'error.message.invalid_amount' => 'Invalid amount',
			'error.message.required' => 'This field is required',
			'error.message.empty' => ({required Object key}) => 'Please enter ${key}',
			'error.message.format' => 'Invalid format',
			'error.message.zero' => ({required Object key}) => '${key} cannot be 0',
			'error.message.amount_not_enough' => 'Insufficient remaining amount',
			'error.message.amount_mismatch' => 'Amount mismatch',
			'error.message.income_is_used' => 'This amount has already been used',
			'error.message.permission_denied' => 'Permission denied',
			'error.message.network_error' => 'Network error. Please try again later',
			'error.message.data_not_found' => 'Data not found. Please try again later',
			'error.message.load_failed' => 'Load failed. Please try again later',
			'error.message.enter_first' => ({required Object key}) => 'Please enter ${key} first',
			'error.message.save_failed' => 'Save failed. Please try again later',
			'error.message.delete_failed' => 'Exchange rate update failed',
			'error.message.rate_fetch_failed' => 'Failed to fetch exchange rate',
			'error.message.length_exceeded' => ({required Object max}) => 'Max ${max} characters',
			'error.message.invalid_char' => 'Invalid characters',
			_ => null,
		};
	}
}
