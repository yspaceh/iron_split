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
	@override late final _TranslationsCategoryEnUs category = _TranslationsCategoryEnUs._(_root);
	@override late final _TranslationsCommonEnUs common = _TranslationsCommonEnUs._(_root);
	@override late final _TranslationsCurrencyEnUs currency = _TranslationsCurrencyEnUs._(_root);
	@override late final _TranslationsRemainderRuleEnUs remainder_rule = _TranslationsRemainderRuleEnUs._(_root);
	@override late final _TranslationsLogActionEnUs log_action = _TranslationsLogActionEnUs._(_root);
	@override late final _TranslationsDialogEnUs dialog = _TranslationsDialogEnUs._(_root);
	@override late final _TranslationsS10HomeTaskListEnUs S10_Home_TaskList = _TranslationsS10HomeTaskListEnUs._(_root);
	@override late final _TranslationsS11InviteConfirmEnUs S11_Invite_Confirm = _TranslationsS11InviteConfirmEnUs._(_root);
	@override late final _TranslationsS12TaskCloseNoticeEnUs S12_TaskClose_Notice = _TranslationsS12TaskCloseNoticeEnUs._(_root);
	@override late final _TranslationsS13TaskDashboardEnUs S13_Task_Dashboard = _TranslationsS13TaskDashboardEnUs._(_root);
	@override late final _TranslationsS14TaskSettingsEnUs S14_Task_Settings = _TranslationsS14TaskSettingsEnUs._(_root);
	@override late final _TranslationsS15RecordEditEnUs S15_Record_Edit = _TranslationsS15RecordEditEnUs._(_root);
	@override late final _TranslationsS16TaskCreateEditEnUs S16_TaskCreate_Edit = _TranslationsS16TaskCreateEditEnUs._(_root);
	@override late final _TranslationsS17TaskLockedEnUs S17_Task_Locked = _TranslationsS17TaskLockedEnUs._(_root);
	@override late final _TranslationsS50OnboardingConsentEnUs S50_Onboarding_Consent = _TranslationsS50OnboardingConsentEnUs._(_root);
	@override late final _TranslationsS51OnboardingNameEnUs S51_Onboarding_Name = _TranslationsS51OnboardingNameEnUs._(_root);
	@override late final _TranslationsS52TaskSettingsLogEnUs S52_TaskSettings_Log = _TranslationsS52TaskSettingsLogEnUs._(_root);
	@override late final _TranslationsS53TaskSettingsMembersEnUs S53_TaskSettings_Members = _TranslationsS53TaskSettingsMembersEnUs._(_root);
	@override late final _TranslationsS71SystemSettingsTosEnUs S71_SystemSettings_Tos = _TranslationsS71SystemSettingsTosEnUs._(_root);
	@override late final _TranslationsD01MemberRoleIntroEnUs D01_MemberRole_Intro = _TranslationsD01MemberRoleIntroEnUs._(_root);
	@override late final _TranslationsD02InviteResultEnUs D02_Invite_Result = _TranslationsD02InviteResultEnUs._(_root);
	@override late final _TranslationsD03TaskCreateConfirmEnUs D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmEnUs._(_root);
	@override late final _TranslationsD05DateJumpNoResultEnUs D05_DateJump_NoResult = _TranslationsD05DateJumpNoResultEnUs._(_root);
	@override late final _TranslationsD08TaskClosedConfirmEnUs D08_TaskClosed_Confirm = _TranslationsD08TaskClosedConfirmEnUs._(_root);
	@override late final _TranslationsD09TaskSettingsCurrencyConfirmEnUs D09_TaskSettings_CurrencyConfirm = _TranslationsD09TaskSettingsCurrencyConfirmEnUs._(_root);
	@override late final _TranslationsD10RecordDeleteConfirmEnUs D10_RecordDelete_Confirm = _TranslationsD10RecordDeleteConfirmEnUs._(_root);
	@override late final _TranslationsB02SplitExpenseEditEnUs B02_SplitExpense_Edit = _TranslationsB02SplitExpenseEditEnUs._(_root);
	@override late final _TranslationsB03SplitMethodEditEnUs B03_SplitMethod_Edit = _TranslationsB03SplitMethodEditEnUs._(_root);
	@override late final _TranslationsB07PaymentMethodEditEnUs B07_PaymentMethod_Edit = _TranslationsB07PaymentMethodEditEnUs._(_root);
	@override late final _TranslationsErrorEnUs error = _TranslationsErrorEnUs._(_root);
}

// Path: category
class _TranslationsCategoryEnUs extends TranslationsCategoryZhTw {
	_TranslationsCategoryEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get food => 'Food';
	@override String get transport => 'Transport';
	@override String get shopping => 'Shopping';
	@override String get entertainment => 'Entertainment';
	@override String get accommodation => 'Accommodation';
	@override String get others => 'Others';
}

// Path: common
class _TranslationsCommonEnUs extends TranslationsCommonZhTw {
	_TranslationsCommonEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancel';
	@override String get delete => 'Delete';
	@override String get confirm => 'Confirm';
	@override String get back => 'Back';
	@override String get save => 'Save';
	@override String error_prefix({required Object message}) => 'Error: ${message}';
	@override String get please_login => 'Please Login';
	@override String get loading => 'Loading...';
	@override String get edit => 'Edit';
	@override String get close => 'Close';
	@override String get me => 'Me';
	@override String get required => 'Required';
	@override String get discard => 'Discard';
	@override String get keep_editing => 'Keep Editing';
	@override String get member_prefix => 'Member';
	@override String get no_record => 'No Record';
	@override String get today => 'Today';
	@override String get untitled => 'Untitled';
}

// Path: currency
class _TranslationsCurrencyEnUs extends TranslationsCurrencyZhTw {
	_TranslationsCurrencyEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

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

// Path: remainder_rule
class _TranslationsRemainderRuleEnUs extends TranslationsRemainderRuleZhTw {
	_TranslationsRemainderRuleEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Remainder Rule';
	@override String get rule_random => 'Random';
	@override String get rule_order => 'Order';
	@override String get rule_member => 'Member';
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

// Path: dialog
class _TranslationsDialogEnUs extends TranslationsDialogZhTw {
	_TranslationsDialogEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get unsaved_changes_title => 'Unsaved Changes?';
	@override String get unsaved_changes_content => 'Changes you made will not be saved.';
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
}

// Path: S11_Invite_Confirm
class _TranslationsS11InviteConfirmEnUs extends TranslationsS11InviteConfirmZhTw {
	_TranslationsS11InviteConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Join Task';
	@override String get subtitle => 'You are invited to join:';
	@override String get loading_invite => 'Loading invite...';
	@override String get join_failed_title => 'Oops! Cannot join task';
	@override String get identity_match_title => 'Are you one of these members?';
	@override String get identity_match_desc => 'This task has pre-created members. If you are one of them, tap to link account; otherwise, join as new.';
	@override String get status_linking => 'Joining by linking account';
	@override String get status_new_member => 'Joining as new member';
	@override String get action_confirm => 'Join';
	@override String get action_cancel => 'Cancel';
	@override String get action_home => 'Home';
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
	@override String get content => 'Closing this task will lock all records and settings. You will enter Read-Only mode and cannot add or edit any data.';
	@override String get action_close => 'Close Task';
}

// Path: S13_Task_Dashboard
class _TranslationsS13TaskDashboardEnUs extends TranslationsS13TaskDashboardZhTw {
	_TranslationsS13TaskDashboardEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title_active => 'Dashboard';
	@override String get tab_group => 'Group';
	@override String get tab_personal => 'Personal';
	@override String get label_prepay_balance => 'Pool Balance';
	@override String get label_my_balance => 'My Balance';
	@override String label_remainder({required Object amount}) => 'Buffer: ${amount}';
	@override String get label_balance => 'Balance';
	@override String get label_total_expense => 'Total Expense';
	@override String get label_total_prepay => 'Total Pre-collected';
	@override String get label_remainder_pot => 'Remainder Pot';
	@override String get fab_record => 'Record';
	@override String get empty_records => 'No records';
	@override String get settlement_button => 'Settlement';
	@override String get nav_to_record => 'Navigating to record page...';
	@override String get daily_expense_label => 'Exp';
	@override String get dialog_balance_detail => 'Balance Details';
	@override String get section_expense => 'Expense Details';
	@override String get section_income => 'Income Details';
	@override String get daily_stats_title => 'Daily Total Expense';
	@override String get personal_daily_total => 'Personal Daily Total Expense';
	@override String get personal_to_receive => 'To Receive';
	@override String get personal_to_pay => 'To Pay';
	@override String get personal_empty_desc => 'No records related to you on this day';
	@override String get total_amount_label => 'Total Bill';
}

// Path: S14_Task_Settings
class _TranslationsS14TaskSettingsEnUs extends TranslationsS14TaskSettingsZhTw {
	_TranslationsS14TaskSettingsEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Settings';
	@override String get menu_member_settings => 'Member Settings';
	@override String get menu_history => 'History';
	@override String get menu_end_task => 'End Task';
	@override String get section_remainder => 'Remainder';
}

// Path: S15_Record_Edit
class _TranslationsS15RecordEditEnUs extends TranslationsS15RecordEditZhTw {
	_TranslationsS15RecordEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title_create => 'Add Expense';
	@override String get title_edit => 'Edit Record';
	@override String get section_split => 'Split Info';
	@override String get label_date => 'Date';
	@override String get label_title => 'Item Name';
	@override String get hint_title => 'What is this for?';
	@override String get label_payment_method => 'Paid By';
	@override String get val_prepay => 'Prepay';
	@override String val_member_paid({required Object name}) => 'Paid by ${name}';
	@override String get label_amount => 'Amount';
	@override String label_rate({required Object base, required Object target}) => 'Rate (1 ${base} = ? ${target})';
	@override String get label_memo => 'Memo';
	@override String get hint_memo => 'Add a note...';
	@override String get action_save => 'Save';
	@override String get val_split_details => 'Split Details';
	@override String val_split_summary({required Object amount, required Object method}) => 'Total ${amount} split by ${method}';
	@override String get info_rate_source => 'Rate Source';
	@override String get msg_rate_source => 'Exchange rates are provided by Open Exchange Rates (Free Tier) for reference only. Please refer to your actual exchange receipt.';
	@override String get btn_close => 'Close';
	@override String val_converted_amount({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}';
	@override String get val_split_remaining => 'Remaining Amount';
	@override String get err_amount_not_enough => 'Insufficient remaining amount';
	@override String get val_mock_note => 'Item Note';
	@override String get tab_expense => 'Expense';
	@override String get tab_income => 'Income';
	@override String get msg_income_developing => 'Income feature coming soon...';
	@override String get msg_not_implemented => 'Feature not implemented yet';
	@override String get err_input_amount => 'Please enter amount first';
	@override String get section_items => 'Itemized Splits';
	@override String get add_item => 'Add Item';
	@override String get base_card_title => 'Remaining Balance (Base)';
	@override String get type_income_title => 'Income';
	@override String get base_card_title_expense => 'Remaining (Base)';
	@override String get base_card_title_income => 'Contributors (Source)';
	@override String get payer_multiple => 'Multiple Payers';
}

// Path: S16_TaskCreate_Edit
class _TranslationsS16TaskCreateEditEnUs extends TranslationsS16TaskCreateEditZhTw {
	_TranslationsS16TaskCreateEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'New Task';
	@override String get section_name => 'Task Name';
	@override String get section_period => 'Period';
	@override String get section_settings => 'Settings';
	@override String get field_name_hint => 'e.g. Tokyo Trip';
	@override String field_name_counter({required Object current}) => '${current}/20';
	@override String get field_start_date => 'Start Date';
	@override String get field_end_date => 'End Date';
	@override String get field_currency => 'Currency';
	@override String get field_member_count => 'Members';
	@override String get action_save => 'Save';
	@override String get picker_done => 'Done';
	@override String get error_name_empty => 'Please enter task name';
	@override String get label_name => 'Task Name';
	@override String get label_date => 'Date';
	@override String get label_currency => 'Currency';
}

// Path: S17_Task_Locked
class _TranslationsS17TaskLockedEnUs extends TranslationsS17TaskLockedZhTw {
	_TranslationsS17TaskLockedEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get retention_notice => 'Data will be retained for 30 days. Please download your records.';
	@override String get action_download => 'Download Records';
	@override String get action_notify_members => 'Notify Members';
	@override String label_remainder_absorbed_by({required Object amount, required Object name}) => 'Remainder ${amount} absorbed by ${name}';
	@override String get action_view_payment_details => 'View Payment Details';
	@override String get section_pending => 'Pending';
	@override String get section_cleared => 'Cleared';
	@override String get member_payment_status_pay => 'To Pay';
	@override String get member_payment_status_receive => 'To Receive';
	@override String get dialog_mark_cleared_title => 'Mark as Cleared';
	@override String dialog_mark_cleared_content({required Object name}) => 'Mark ${name} as cleared?';
}

// Path: S50_Onboarding_Consent
class _TranslationsS50OnboardingConsentEnUs extends TranslationsS50OnboardingConsentZhTw {
	_TranslationsS50OnboardingConsentEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Welcome to Iron Split';
	@override String get content_prefix => 'By clicking Start, you agree to our ';
	@override String get terms_link => 'Terms of Service';
	@override String get and => ' and ';
	@override String get privacy_link => 'Privacy Policy';
	@override String get content_suffix => '. We use anonymous login to protect your privacy.';
	@override String get agree_btn => 'Start';
	@override String login_failed({required Object message}) => 'Login Failed: ${message}';
}

// Path: S51_Onboarding_Name
class _TranslationsS51OnboardingNameEnUs extends TranslationsS51OnboardingNameZhTw {
	_TranslationsS51OnboardingNameEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Set Display Name';
	@override String get description => 'Please enter your display name (1-10 chars).';
	@override String get field_hint => 'Enter nickname';
	@override String field_counter({required Object current}) => '${current}/10';
	@override String get error_empty => 'Name cannot be empty';
	@override String get error_too_long => 'Max 10 characters';
	@override String get error_invalid_char => 'Invalid characters';
	@override String get action_next => 'Set';
}

// Path: S52_TaskSettings_Log
class _TranslationsS52TaskSettingsLogEnUs extends TranslationsS52TaskSettingsLogZhTw {
	_TranslationsS52TaskSettingsLogEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Activity Log';
	@override String get empty_log => 'No activity logs found';
	@override String get action_export_csv => 'Export CSV';
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
	@override String get action_add => 'Add Member';
	@override String get action_invite => 'Invite';
	@override String get label_default_ratio => 'Default Ratio';
	@override String get dialog_delete_error_title => 'Member Deletion Error';
	@override String get dialog_delete_error_content => 'This member still has related expense records or unsettled payments. Please modify or delete the relevant records and try again.';
	@override String get member_default_name => 'Member';
	@override String get member_name => 'Member Name';
}

// Path: S71_SystemSettings_Tos
class _TranslationsS71SystemSettingsTosEnUs extends TranslationsS71SystemSettingsTosZhTw {
	_TranslationsS71SystemSettingsTosEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terms of Service';
}

// Path: D01_MemberRole_Intro
class _TranslationsD01MemberRoleIntroEnUs extends TranslationsD01MemberRoleIntroZhTw {
	_TranslationsD01MemberRoleIntroEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Your Character';
	@override String get action_reroll => 'Change Animal';
	@override String get action_enter => 'Enter Task';
	@override String get desc_reroll_left => '1 chance left';
	@override String get desc_reroll_empty => 'No chances left';
	@override String get dialog_content => 'This is your exclusive avatar for this task. It will represent you in all split records!';
}

// Path: D02_Invite_Result
class _TranslationsD02InviteResultEnUs extends TranslationsD02InviteResultZhTw {
	_TranslationsD02InviteResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Join Failed';
	@override String get action_back => 'Back to Home';
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
	@override String get label_name => 'Name';
	@override String get label_period => 'Period';
	@override String get label_currency => 'Currency';
	@override String get label_members => 'Members';
	@override String get action_confirm => 'Confirm';
	@override String get action_back => 'Edit';
	@override String get creating_task => 'Creating task...';
	@override String get preparing_share => 'Preparing invite...';
	@override String get share_subject => 'Join Iron Split Task';
	@override String share_message({required Object taskName, required Object code, required Object link}) => 'Join my Iron Split task "${taskName}"!\nCode: ${code}\nLink: ${link}';
}

// Path: D05_DateJump_NoResult
class _TranslationsD05DateJumpNoResultEnUs extends TranslationsD05DateJumpNoResultZhTw {
	_TranslationsD05DateJumpNoResultEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'No Record';
	@override String get content => 'No record found for this date. Would you like to add one?';
	@override String get action_cancel => 'Back';
	@override String get action_add => 'Add Record';
}

// Path: D08_TaskClosed_Confirm
class _TranslationsD08TaskClosedConfirmEnUs extends TranslationsD08TaskClosedConfirmZhTw {
	_TranslationsD08TaskClosedConfirmEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Confirm Close';
	@override String get content => 'This action cannot be undone. All data will be locked permanently.\n\nAre you sure you want to proceed?';
	@override String get action_confirm => 'Confirm';
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

// Path: B02_SplitExpense_Edit
class _TranslationsB02SplitExpenseEditEnUs extends TranslationsB02SplitExpenseEditZhTw {
	_TranslationsB02SplitExpenseEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Edit Item';
	@override String get name_label => 'Item Name';
	@override String get amount_label => 'Amount';
	@override String get split_button_prefix => 'Split by';
	@override String get hint_memo => 'Memo';
	@override String get section_members => 'Members';
	@override String label_remainder({required Object amount}) => 'Remaining: ${amount}';
	@override String label_total({required Object current, required Object target}) => 'Total: ${current}/${target}';
	@override String get error_total_mismatch => 'Total mismatch';
	@override String get error_percent_mismatch => 'Total must be 100%';
	@override String get action_save => 'Confirm Split';
	@override String get hint_amount => 'Amount';
	@override String get hint_percent => '%';
}

// Path: B03_SplitMethod_Edit
class _TranslationsB03SplitMethodEditEnUs extends TranslationsB03SplitMethodEditZhTw {
	_TranslationsB03SplitMethodEditEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Choose Split Method';
	@override String get method_even => 'Even';
	@override String get method_percent => 'By Percentage';
	@override String get method_exact => 'Exact Amount';
	@override String get desc_even => 'Selected members split equally, leftover goes to pot';
	@override String get desc_percent => 'Distribute by percentage';
	@override String get desc_exact => 'Enter specific amounts, total must match';
	@override String msg_leftover_pot({required Object amount}) => 'Leftover ${amount} will go to pot (distributed at settlement)';
	@override String get label_weight => 'Weight';
	@override String error_total_mismatch({required Object diff}) => 'Total mismatch (difference ${diff})';
	@override String get btn_adjust_weight => 'Adjust Weight';
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

// Path: error
class _TranslationsErrorEnUs extends TranslationsErrorZhTw {
	_TranslationsErrorEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override late final _TranslationsErrorTaskFullEnUs taskFull = _TranslationsErrorTaskFullEnUs._(_root);
	@override late final _TranslationsErrorExpiredCodeEnUs expiredCode = _TranslationsErrorExpiredCodeEnUs._(_root);
	@override late final _TranslationsErrorInvalidCodeEnUs invalidCode = _TranslationsErrorInvalidCodeEnUs._(_root);
	@override late final _TranslationsErrorAuthRequiredEnUs authRequired = _TranslationsErrorAuthRequiredEnUs._(_root);
	@override late final _TranslationsErrorAlreadyInTaskEnUs alreadyInTask = _TranslationsErrorAlreadyInTaskEnUs._(_root);
	@override late final _TranslationsErrorUnknownEnUs unknown = _TranslationsErrorUnknownEnUs._(_root);
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

// Path: error.taskFull
class _TranslationsErrorTaskFullEnUs extends TranslationsErrorTaskFullZhTw {
	_TranslationsErrorTaskFullEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Task Full';
	@override String message({required Object limit}) => 'Task member limit (${limit}) reached. Please contact captain.';
}

// Path: error.expiredCode
class _TranslationsErrorExpiredCodeEnUs extends TranslationsErrorExpiredCodeZhTw {
	_TranslationsErrorExpiredCodeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invite Expired';
	@override String message({required Object minutes}) => 'Invite link expired (${minutes} mins). Please ask captain for a new one.';
}

// Path: error.invalidCode
class _TranslationsErrorInvalidCodeEnUs extends TranslationsErrorInvalidCodeZhTw {
	_TranslationsErrorInvalidCodeEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invalid Link';
	@override String get message => 'Invalid invite link.';
}

// Path: error.authRequired
class _TranslationsErrorAuthRequiredEnUs extends TranslationsErrorAuthRequiredZhTw {
	_TranslationsErrorAuthRequiredEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Login Required';
	@override String get message => 'Please login to join task.';
}

// Path: error.alreadyInTask
class _TranslationsErrorAlreadyInTaskEnUs extends TranslationsErrorAlreadyInTaskZhTw {
	_TranslationsErrorAlreadyInTaskEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Already Member';
	@override String get message => 'You are already in this task.';
}

// Path: error.unknown
class _TranslationsErrorUnknownEnUs extends TranslationsErrorUnknownZhTw {
	_TranslationsErrorUnknownEnUs._(TranslationsEnUs root) : this._root = root, super.internal(root);

	final TranslationsEnUs _root; // ignore: unused_field

	// Translations
	@override String get title => 'Error';
	@override String get message => 'An unexpected error occurred.';
}

/// The flat map containing all translations for locale <en-US>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEnUs {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'category.food' => 'Food',
			'category.transport' => 'Transport',
			'category.shopping' => 'Shopping',
			'category.entertainment' => 'Entertainment',
			'category.accommodation' => 'Accommodation',
			'category.others' => 'Others',
			'common.cancel' => 'Cancel',
			'common.delete' => 'Delete',
			'common.confirm' => 'Confirm',
			'common.back' => 'Back',
			'common.save' => 'Save',
			'common.error_prefix' => ({required Object message}) => 'Error: ${message}',
			'common.please_login' => 'Please Login',
			'common.loading' => 'Loading...',
			'common.edit' => 'Edit',
			'common.close' => 'Close',
			'common.me' => 'Me',
			'common.required' => 'Required',
			'common.discard' => 'Discard',
			'common.keep_editing' => 'Keep Editing',
			'common.member_prefix' => 'Member',
			'common.no_record' => 'No Record',
			'common.today' => 'Today',
			'common.untitled' => 'Untitled',
			'currency.twd' => 'New Taiwan Dollar',
			'currency.jpy' => 'Japanese Yen',
			'currency.usd' => 'US Dollar',
			'currency.eur' => 'Euro',
			'currency.krw' => 'South Korean Won',
			'currency.cny' => 'Chinese Yuan',
			'currency.gbp' => 'British Pound',
			'currency.cad' => 'Canadian Dollar',
			'currency.aud' => 'Australian Dollar',
			'currency.chf' => 'Swiss Franc',
			'currency.dkk' => 'Danish Krone',
			'currency.hkd' => 'Hong Kong Dollar',
			'currency.nok' => 'Norwegian Krone',
			'currency.nzd' => 'New Zealand Dollar',
			'currency.sgd' => 'Singapore Dollar',
			'currency.thb' => 'Thai Baht',
			'currency.zar' => 'South African Rand',
			'currency.rub' => 'Russian Ruble',
			'currency.vnd' => 'Vietnamese Dong',
			'currency.idr' => 'Indonesian Rupiah',
			'currency.myr' => 'Malaysian Ringgit',
			'currency.php' => 'Philippine Peso',
			'currency.mop' => 'Macanese Pataca',
			'currency.sek' => 'Swedish Krone',
			'currency.aed' => 'UAE Dirham',
			'currency.sar' => 'Saudi Riyal',
			'currency.try_' => 'Turkish Lira',
			'currency.inr' => 'Indian Rupee',
			'remainder_rule.title' => 'Remainder Rule',
			'remainder_rule.rule_random' => 'Random',
			'remainder_rule.rule_order' => 'Order',
			'remainder_rule.rule_member' => 'Member',
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
			'dialog.unsaved_changes_title' => 'Unsaved Changes?',
			'dialog.unsaved_changes_content' => 'Changes you made will not be saved.',
			'S10_Home_TaskList.title' => 'My Tasks',
			'S10_Home_TaskList.tab_in_progress' => 'Active',
			'S10_Home_TaskList.tab_completed' => 'Finished',
			'S10_Home_TaskList.mascot_preparing' => 'Iron Rooster preparing...',
			'S10_Home_TaskList.empty_in_progress' => 'No active tasks',
			'S10_Home_TaskList.empty_completed' => 'No finished tasks',
			'S10_Home_TaskList.date_tbd' => 'Date TBD',
			'S10_Home_TaskList.delete_confirm_title' => 'Delete Task',
			'S10_Home_TaskList.delete_confirm_content' => 'Are you sure you want to delete this task?',
			'S11_Invite_Confirm.title' => 'Join Task',
			'S11_Invite_Confirm.subtitle' => 'You are invited to join:',
			'S11_Invite_Confirm.loading_invite' => 'Loading invite...',
			'S11_Invite_Confirm.join_failed_title' => 'Oops! Cannot join task',
			'S11_Invite_Confirm.identity_match_title' => 'Are you one of these members?',
			'S11_Invite_Confirm.identity_match_desc' => 'This task has pre-created members. If you are one of them, tap to link account; otherwise, join as new.',
			'S11_Invite_Confirm.status_linking' => 'Joining by linking account',
			'S11_Invite_Confirm.status_new_member' => 'Joining as new member',
			'S11_Invite_Confirm.action_confirm' => 'Join',
			'S11_Invite_Confirm.action_cancel' => 'Cancel',
			'S11_Invite_Confirm.action_home' => 'Home',
			'S11_Invite_Confirm.error_join_failed' => ({required Object message}) => 'Join failed: ${message}',
			'S11_Invite_Confirm.error_generic' => ({required Object message}) => 'Error: ${message}',
			'S11_Invite_Confirm.label_select_ghost' => 'Select Member to Inherit',
			'S11_Invite_Confirm.label_prepaid' => 'Prepaid',
			'S11_Invite_Confirm.label_expense' => 'Expense',
			'S12_TaskClose_Notice.title' => 'Close Task',
			'S12_TaskClose_Notice.content' => 'Closing this task will lock all records and settings. You will enter Read-Only mode and cannot add or edit any data.',
			'S12_TaskClose_Notice.action_close' => 'Close Task',
			'S13_Task_Dashboard.title_active' => 'Dashboard',
			'S13_Task_Dashboard.tab_group' => 'Group',
			'S13_Task_Dashboard.tab_personal' => 'Personal',
			'S13_Task_Dashboard.label_prepay_balance' => 'Pool Balance',
			'S13_Task_Dashboard.label_my_balance' => 'My Balance',
			'S13_Task_Dashboard.label_remainder' => ({required Object amount}) => 'Buffer: ${amount}',
			'S13_Task_Dashboard.label_balance' => 'Balance',
			'S13_Task_Dashboard.label_total_expense' => 'Total Expense',
			'S13_Task_Dashboard.label_total_prepay' => 'Total Pre-collected',
			'S13_Task_Dashboard.label_remainder_pot' => 'Remainder Pot',
			'S13_Task_Dashboard.fab_record' => 'Record',
			'S13_Task_Dashboard.empty_records' => 'No records',
			'S13_Task_Dashboard.settlement_button' => 'Settlement',
			'S13_Task_Dashboard.nav_to_record' => 'Navigating to record page...',
			'S13_Task_Dashboard.daily_expense_label' => 'Exp',
			'S13_Task_Dashboard.dialog_balance_detail' => 'Balance Details',
			'S13_Task_Dashboard.section_expense' => 'Expense Details',
			'S13_Task_Dashboard.section_income' => 'Income Details',
			'S13_Task_Dashboard.daily_stats_title' => 'Daily Total Expense',
			'S13_Task_Dashboard.personal_daily_total' => 'Personal Daily Total Expense',
			'S13_Task_Dashboard.personal_to_receive' => 'To Receive',
			'S13_Task_Dashboard.personal_to_pay' => 'To Pay',
			'S13_Task_Dashboard.personal_empty_desc' => 'No records related to you on this day',
			'S13_Task_Dashboard.total_amount_label' => 'Total Bill',
			'S14_Task_Settings.title' => 'Task Settings',
			'S14_Task_Settings.menu_member_settings' => 'Member Settings',
			'S14_Task_Settings.menu_history' => 'History',
			'S14_Task_Settings.menu_end_task' => 'End Task',
			'S14_Task_Settings.section_remainder' => 'Remainder',
			'S15_Record_Edit.title_create' => 'Add Expense',
			'S15_Record_Edit.title_edit' => 'Edit Record',
			'S15_Record_Edit.section_split' => 'Split Info',
			'S15_Record_Edit.label_date' => 'Date',
			'S15_Record_Edit.label_title' => 'Item Name',
			'S15_Record_Edit.hint_title' => 'What is this for?',
			'S15_Record_Edit.label_payment_method' => 'Paid By',
			'S15_Record_Edit.val_prepay' => 'Prepay',
			'S15_Record_Edit.val_member_paid' => ({required Object name}) => 'Paid by ${name}',
			'S15_Record_Edit.label_amount' => 'Amount',
			'S15_Record_Edit.label_rate' => ({required Object base, required Object target}) => 'Rate (1 ${base} = ? ${target})',
			'S15_Record_Edit.label_memo' => 'Memo',
			'S15_Record_Edit.hint_memo' => 'Add a note...',
			'S15_Record_Edit.action_save' => 'Save',
			'S15_Record_Edit.val_split_details' => 'Split Details',
			'S15_Record_Edit.val_split_summary' => ({required Object amount, required Object method}) => 'Total ${amount} split by ${method}',
			'S15_Record_Edit.info_rate_source' => 'Rate Source',
			'S15_Record_Edit.msg_rate_source' => 'Exchange rates are provided by Open Exchange Rates (Free Tier) for reference only. Please refer to your actual exchange receipt.',
			'S15_Record_Edit.btn_close' => 'Close',
			'S15_Record_Edit.val_converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			'S15_Record_Edit.val_split_remaining' => 'Remaining Amount',
			'S15_Record_Edit.err_amount_not_enough' => 'Insufficient remaining amount',
			'S15_Record_Edit.val_mock_note' => 'Item Note',
			'S15_Record_Edit.tab_expense' => 'Expense',
			'S15_Record_Edit.tab_income' => 'Income',
			'S15_Record_Edit.msg_income_developing' => 'Income feature coming soon...',
			'S15_Record_Edit.msg_not_implemented' => 'Feature not implemented yet',
			'S15_Record_Edit.err_input_amount' => 'Please enter amount first',
			'S15_Record_Edit.section_items' => 'Itemized Splits',
			'S15_Record_Edit.add_item' => 'Add Item',
			'S15_Record_Edit.base_card_title' => 'Remaining Balance (Base)',
			'S15_Record_Edit.type_income_title' => 'Income',
			'S15_Record_Edit.base_card_title_expense' => 'Remaining (Base)',
			'S15_Record_Edit.base_card_title_income' => 'Contributors (Source)',
			'S15_Record_Edit.payer_multiple' => 'Multiple Payers',
			'S16_TaskCreate_Edit.title' => 'New Task',
			'S16_TaskCreate_Edit.section_name' => 'Task Name',
			'S16_TaskCreate_Edit.section_period' => 'Period',
			'S16_TaskCreate_Edit.section_settings' => 'Settings',
			'S16_TaskCreate_Edit.field_name_hint' => 'e.g. Tokyo Trip',
			'S16_TaskCreate_Edit.field_name_counter' => ({required Object current}) => '${current}/20',
			'S16_TaskCreate_Edit.field_start_date' => 'Start Date',
			'S16_TaskCreate_Edit.field_end_date' => 'End Date',
			'S16_TaskCreate_Edit.field_currency' => 'Currency',
			'S16_TaskCreate_Edit.field_member_count' => 'Members',
			'S16_TaskCreate_Edit.action_save' => 'Save',
			'S16_TaskCreate_Edit.picker_done' => 'Done',
			'S16_TaskCreate_Edit.error_name_empty' => 'Please enter task name',
			'S16_TaskCreate_Edit.label_name' => 'Task Name',
			'S16_TaskCreate_Edit.label_date' => 'Date',
			'S16_TaskCreate_Edit.label_currency' => 'Currency',
			'S17_Task_Locked.retention_notice' => 'Data will be retained for 30 days. Please download your records.',
			'S17_Task_Locked.action_download' => 'Download Records',
			'S17_Task_Locked.action_notify_members' => 'Notify Members',
			'S17_Task_Locked.label_remainder_absorbed_by' => ({required Object amount, required Object name}) => 'Remainder ${amount} absorbed by ${name}',
			'S17_Task_Locked.action_view_payment_details' => 'View Payment Details',
			'S17_Task_Locked.section_pending' => 'Pending',
			'S17_Task_Locked.section_cleared' => 'Cleared',
			'S17_Task_Locked.member_payment_status_pay' => 'To Pay',
			'S17_Task_Locked.member_payment_status_receive' => 'To Receive',
			'S17_Task_Locked.dialog_mark_cleared_title' => 'Mark as Cleared',
			'S17_Task_Locked.dialog_mark_cleared_content' => ({required Object name}) => 'Mark ${name} as cleared?',
			'S50_Onboarding_Consent.title' => 'Welcome to Iron Split',
			'S50_Onboarding_Consent.content_prefix' => 'By clicking Start, you agree to our ',
			'S50_Onboarding_Consent.terms_link' => 'Terms of Service',
			'S50_Onboarding_Consent.and' => ' and ',
			'S50_Onboarding_Consent.privacy_link' => 'Privacy Policy',
			'S50_Onboarding_Consent.content_suffix' => '. We use anonymous login to protect your privacy.',
			'S50_Onboarding_Consent.agree_btn' => 'Start',
			'S50_Onboarding_Consent.login_failed' => ({required Object message}) => 'Login Failed: ${message}',
			'S51_Onboarding_Name.title' => 'Set Display Name',
			'S51_Onboarding_Name.description' => 'Please enter your display name (1-10 chars).',
			'S51_Onboarding_Name.field_hint' => 'Enter nickname',
			'S51_Onboarding_Name.field_counter' => ({required Object current}) => '${current}/10',
			'S51_Onboarding_Name.error_empty' => 'Name cannot be empty',
			'S51_Onboarding_Name.error_too_long' => 'Max 10 characters',
			'S51_Onboarding_Name.error_invalid_char' => 'Invalid characters',
			'S51_Onboarding_Name.action_next' => 'Set',
			'S52_TaskSettings_Log.title' => 'Activity Log',
			'S52_TaskSettings_Log.empty_log' => 'No activity logs found',
			'S52_TaskSettings_Log.action_export_csv' => 'Export CSV',
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
			'S53_TaskSettings_Members.action_add' => 'Add Member',
			'S53_TaskSettings_Members.action_invite' => 'Invite',
			'S53_TaskSettings_Members.label_default_ratio' => 'Default Ratio',
			'S53_TaskSettings_Members.dialog_delete_error_title' => 'Member Deletion Error',
			'S53_TaskSettings_Members.dialog_delete_error_content' => 'This member still has related expense records or unsettled payments. Please modify or delete the relevant records and try again.',
			'S53_TaskSettings_Members.member_default_name' => 'Member',
			'S53_TaskSettings_Members.member_name' => 'Member Name',
			'S71_SystemSettings_Tos.title' => 'Terms of Service',
			'D01_MemberRole_Intro.title' => 'Your Character',
			'D01_MemberRole_Intro.action_reroll' => 'Change Animal',
			'D01_MemberRole_Intro.action_enter' => 'Enter Task',
			'D01_MemberRole_Intro.desc_reroll_left' => '1 chance left',
			'D01_MemberRole_Intro.desc_reroll_empty' => 'No chances left',
			'D01_MemberRole_Intro.dialog_content' => 'This is your exclusive avatar for this task. It will represent you in all split records!',
			'D02_Invite_Result.title' => 'Join Failed',
			'D02_Invite_Result.action_back' => 'Back to Home',
			'D02_Invite_Result.error_INVALID_CODE' => 'Invalid invite code. Please check if the link is correct.',
			'D02_Invite_Result.error_EXPIRED_CODE' => 'Invite link expired (over 15 mins). Please ask the captain to share again.',
			'D02_Invite_Result.error_TASK_FULL' => 'Task is full (max 15 members). Cannot join.',
			'D02_Invite_Result.error_AUTH_REQUIRED' => 'Authentication failed. Please restart the App.',
			'D02_Invite_Result.error_UNKNOWN' => 'Unknown error. Please try again later.',
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
			'D03_TaskCreate_Confirm.share_message' => ({required Object taskName, required Object code, required Object link}) => 'Join my Iron Split task "${taskName}"!\nCode: ${code}\nLink: ${link}',
			'D05_DateJump_NoResult.title' => 'No Record',
			'D05_DateJump_NoResult.content' => 'No record found for this date. Would you like to add one?',
			'D05_DateJump_NoResult.action_cancel' => 'Back',
			'D05_DateJump_NoResult.action_add' => 'Add Record',
			'D08_TaskClosed_Confirm.title' => 'Confirm Close',
			'D08_TaskClosed_Confirm.content' => 'This action cannot be undone. All data will be locked permanently.\n\nAre you sure you want to proceed?',
			'D08_TaskClosed_Confirm.action_confirm' => 'Confirm',
			'D09_TaskSettings_CurrencyConfirm.title' => 'Change Base Currency?',
			'D09_TaskSettings_CurrencyConfirm.content' => 'Changing currency will reset all exchange rates. This may affect current balances. Are you sure?',
			'D10_RecordDelete_Confirm.delete_record_title' => 'Delete Record?',
			'D10_RecordDelete_Confirm.delete_record_content' => ({required Object title, required Object amount}) => 'Are you sure you want to delete ${title} (${amount})?',
			'D10_RecordDelete_Confirm.deleted_success' => 'Record deleted',
			'B02_SplitExpense_Edit.title' => 'Edit Item',
			'B02_SplitExpense_Edit.name_label' => 'Item Name',
			'B02_SplitExpense_Edit.amount_label' => 'Amount',
			'B02_SplitExpense_Edit.split_button_prefix' => 'Split by',
			'B02_SplitExpense_Edit.hint_memo' => 'Memo',
			'B02_SplitExpense_Edit.section_members' => 'Members',
			'B02_SplitExpense_Edit.label_remainder' => ({required Object amount}) => 'Remaining: ${amount}',
			'B02_SplitExpense_Edit.label_total' => ({required Object current, required Object target}) => 'Total: ${current}/${target}',
			'B02_SplitExpense_Edit.error_total_mismatch' => 'Total mismatch',
			'B02_SplitExpense_Edit.error_percent_mismatch' => 'Total must be 100%',
			'B02_SplitExpense_Edit.action_save' => 'Confirm Split',
			'B02_SplitExpense_Edit.hint_amount' => 'Amount',
			'B02_SplitExpense_Edit.hint_percent' => '%',
			'B03_SplitMethod_Edit.title' => 'Choose Split Method',
			'B03_SplitMethod_Edit.method_even' => 'Even',
			'B03_SplitMethod_Edit.method_percent' => 'By Percentage',
			'B03_SplitMethod_Edit.method_exact' => 'Exact Amount',
			'B03_SplitMethod_Edit.desc_even' => 'Selected members split equally, leftover goes to pot',
			'B03_SplitMethod_Edit.desc_percent' => 'Distribute by percentage',
			'B03_SplitMethod_Edit.desc_exact' => 'Enter specific amounts, total must match',
			'B03_SplitMethod_Edit.msg_leftover_pot' => ({required Object amount}) => 'Leftover ${amount} will go to pot (distributed at settlement)',
			'B03_SplitMethod_Edit.label_weight' => 'Weight',
			'B03_SplitMethod_Edit.error_total_mismatch' => ({required Object diff}) => 'Total mismatch (difference ${diff})',
			'B03_SplitMethod_Edit.btn_adjust_weight' => 'Adjust Weight',
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
			'error.taskFull.title' => 'Task Full',
			'error.taskFull.message' => ({required Object limit}) => 'Task member limit (${limit}) reached. Please contact captain.',
			'error.expiredCode.title' => 'Invite Expired',
			'error.expiredCode.message' => ({required Object minutes}) => 'Invite link expired (${minutes} mins). Please ask captain for a new one.',
			'error.invalidCode.title' => 'Invalid Link',
			'error.invalidCode.message' => 'Invalid invite link.',
			'error.authRequired.title' => 'Login Required',
			'error.authRequired.message' => 'Please login to join task.',
			'error.alreadyInTask.title' => 'Already Member',
			'error.alreadyInTask.message' => 'You are already in this task.',
			'error.unknown.title' => 'Error',
			'error.unknown.message' => 'An unexpected error occurred.',
			_ => null,
		};
	}
}
