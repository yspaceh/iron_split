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
	@override late final _TranslationsCategoryEn category = _TranslationsCategoryEn._(_root);
	@override late final _TranslationsCommonEn common = _TranslationsCommonEn._(_root);
	@override late final _TranslationsS50OnboardingConsentEn S50_Onboarding_Consent = _TranslationsS50OnboardingConsentEn._(_root);
	@override late final _TranslationsS51OnboardingNameEn S51_Onboarding_Name = _TranslationsS51OnboardingNameEn._(_root);
	@override late final _TranslationsS10HomeTaskListEn S10_Home_TaskList = _TranslationsS10HomeTaskListEn._(_root);
	@override late final _TranslationsS11InviteConfirmEn S11_Invite_Confirm = _TranslationsS11InviteConfirmEn._(_root);
	@override late final _TranslationsS13TaskDashboardEn S13_Task_Dashboard = _TranslationsS13TaskDashboardEn._(_root);
	@override late final _TranslationsS15RecordEditEn S15_Record_Edit = _TranslationsS15RecordEditEn._(_root);
	@override late final _TranslationsS16TaskCreateEditEn S16_TaskCreate_Edit = _TranslationsS16TaskCreateEditEn._(_root);
	@override late final _TranslationsS71SystemSettingsTosEn S71_SystemSettings_Tos = _TranslationsS71SystemSettingsTosEn._(_root);
	@override late final _TranslationsD01MemberRoleIntroEn D01_MemberRole_Intro = _TranslationsD01MemberRoleIntroEn._(_root);
	@override late final _TranslationsD02InviteResultEn D02_Invite_Result = _TranslationsD02InviteResultEn._(_root);
	@override late final _TranslationsD03TaskCreateConfirmEn D03_TaskCreate_Confirm = _TranslationsD03TaskCreateConfirmEn._(_root);
	@override late final _TranslationsD04TaskCreateNoticeEn D04_TaskCreate_Notice = _TranslationsD04TaskCreateNoticeEn._(_root);
	@override late final _TranslationsD10RecordDeleteConfirmEn D10_RecordDelete_Confirm = _TranslationsD10RecordDeleteConfirmEn._(_root);
	@override late final _TranslationsB02SplitExpenseEditEn B02_SplitExpense_Edit = _TranslationsB02SplitExpenseEditEn._(_root);
	@override late final _TranslationsB03SplitMethodEditEn B03_SplitMethod_Edit = _TranslationsB03SplitMethodEditEn._(_root);
	@override late final _TranslationsB07PaymentMethodEditEn B07_PaymentMethod_Edit = _TranslationsB07PaymentMethodEditEn._(_root);
	@override late final _TranslationsErrorEn error = _TranslationsErrorEn._(_root);
}

// Path: category
class _TranslationsCategoryEn implements TranslationsCategoryZh {
	_TranslationsCategoryEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get food => 'Food';
	@override String get transport => 'Transport';
	@override String get shopping => 'Shopping';
	@override String get entertainment => 'Entertainment';
	@override String get accommodation => 'Accommodation';
	@override String get others => 'Others';
}

// Path: common
class _TranslationsCommonEn implements TranslationsCommonZh {
	_TranslationsCommonEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
}

// Path: S50_Onboarding_Consent
class _TranslationsS50OnboardingConsentEn implements TranslationsS50OnboardingConsentZh {
	_TranslationsS50OnboardingConsentEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
class _TranslationsS51OnboardingNameEn implements TranslationsS51OnboardingNameZh {
	_TranslationsS51OnboardingNameEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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

// Path: S10_Home_TaskList
class _TranslationsS10HomeTaskListEn implements TranslationsS10HomeTaskListZh {
	_TranslationsS10HomeTaskListEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
class _TranslationsS11InviteConfirmEn implements TranslationsS11InviteConfirmZh {
	_TranslationsS11InviteConfirmEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
}

// Path: S13_Task_Dashboard
class _TranslationsS13TaskDashboardEn implements TranslationsS13TaskDashboardZh {
	_TranslationsS13TaskDashboardEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Dashboard';
	@override String get tab_group => 'Group';
	@override String get tab_personal => 'Personal';
	@override String get label_prepay_balance => 'Pool Balance';
	@override String get label_my_balance => 'My Balance';
	@override String label_remainder({required Object amount}) => 'Buffer: ${amount}';
	@override String get fab_record => 'Record';
	@override String get empty_records => 'No records yet';
	@override String get rule_random => 'Random';
	@override String get rule_order => 'Order';
	@override String get rule_member => 'Member';
	@override String get settlement_button => 'Settlement';
	@override String get nav_to_record => 'Navigating to record page...';
	@override String get daily_expense_label => 'Exp';
}

// Path: S15_Record_Edit
class _TranslationsS15RecordEditEn implements TranslationsS15RecordEditZh {
	_TranslationsS15RecordEditEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
	@override String get method_even => 'Even';
	@override String get method_exact => 'Exact Amount';
	@override String get method_percent => 'By Percentage';
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
}

// Path: S16_TaskCreate_Edit
class _TranslationsS16TaskCreateEditEn implements TranslationsS16TaskCreateEditZh {
	_TranslationsS16TaskCreateEditEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
	@override String get currency_twd => 'TWD';
	@override String get currency_jpy => 'JPY';
	@override String get currency_usd => 'USD';
}

// Path: S71_SystemSettings_Tos
class _TranslationsS71SystemSettingsTosEn implements TranslationsS71SystemSettingsTosZh {
	_TranslationsS71SystemSettingsTosEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Terms of Service';
}

// Path: D01_MemberRole_Intro
class _TranslationsD01MemberRoleIntroEn implements TranslationsD01MemberRoleIntroZh {
	_TranslationsD01MemberRoleIntroEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Your Character';
	@override String get action_reroll => 'Change Animal';
	@override String get action_enter => 'Enter Task';
	@override String get desc_reroll_left => '1 chance left';
	@override String get desc_reroll_empty => 'No chances left';
	@override String get dialog_content => 'This is your exclusive avatar for this task. It will represent you in all split records!';
}

// Path: D02_Invite_Result
class _TranslationsD02InviteResultEn implements TranslationsD02InviteResultZh {
	_TranslationsD02InviteResultEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
	@override String share_message({required Object taskName, required Object code, required Object link}) => 'Join my Iron Split task "${taskName}"!\nCode: ${code}\nLink: ${link}';
}

// Path: D04_TaskCreate_Notice
class _TranslationsD04TaskCreateNoticeEn implements TranslationsD04TaskCreateNoticeZh {
	_TranslationsD04TaskCreateNoticeEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Unsaved Changes';
	@override String get content => 'Current settings will be discarded. Are you sure you want to leave?';
	@override String get action_leave => 'Discard';
	@override String get action_stay => 'Keep Editing';
}

// Path: D10_RecordDelete_Confirm
class _TranslationsD10RecordDeleteConfirmEn implements TranslationsD10RecordDeleteConfirmZh {
	_TranslationsD10RecordDeleteConfirmEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get delete_record_title => 'Delete Record?';
	@override String delete_record_content({required Object title, required Object amount}) => 'Are you sure you want to delete ${title} (${amount})?';
	@override String get deleted_success => 'Record deleted';
}

// Path: B02_SplitExpense_Edit
class _TranslationsB02SplitExpenseEditEn implements TranslationsB02SplitExpenseEditZh {
	_TranslationsB02SplitExpenseEditEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
	@override String get title_add => 'Add Item';
	@override String get title_edit => 'Edit Item';
	@override String get err_input_amount_first => 'Please enter amount first';
	@override String split_status({required Object count}) => '${count} people';
}

// Path: B03_SplitMethod_Edit
class _TranslationsB03SplitMethodEditEn implements TranslationsB03SplitMethodEditZh {
	_TranslationsB03SplitMethodEditEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
class _TranslationsB07PaymentMethodEditEn implements TranslationsB07PaymentMethodEditZh {
	_TranslationsB07PaymentMethodEditEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

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
	@override String message({required Object limit}) => 'Task member limit (${limit}) reached. Please contact captain.';
}

// Path: error.expiredCode
class _TranslationsErrorExpiredCodeEn implements TranslationsErrorExpiredCodeZh {
	_TranslationsErrorExpiredCodeEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invite Expired';
	@override String message({required Object minutes}) => 'Invite link expired (${minutes} mins). Please ask captain for a new one.';
}

// Path: error.invalidCode
class _TranslationsErrorInvalidCodeEn implements TranslationsErrorInvalidCodeZh {
	_TranslationsErrorInvalidCodeEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Invalid Link';
	@override String get message => 'Invalid invite link.';
}

// Path: error.authRequired
class _TranslationsErrorAuthRequiredEn implements TranslationsErrorAuthRequiredZh {
	_TranslationsErrorAuthRequiredEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Login Required';
	@override String get message => 'Please login to join task.';
}

// Path: error.alreadyInTask
class _TranslationsErrorAlreadyInTaskEn implements TranslationsErrorAlreadyInTaskZh {
	_TranslationsErrorAlreadyInTaskEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Already Member';
	@override String get message => 'You are already in this task.';
}

// Path: error.unknown
class _TranslationsErrorUnknownEn implements TranslationsErrorUnknownZh {
	_TranslationsErrorUnknownEn._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Error';
	@override String get message => 'An unexpected error occurred.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
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
			'S13_Task_Dashboard.title' => 'Dashboard',
			'S13_Task_Dashboard.tab_group' => 'Group',
			'S13_Task_Dashboard.tab_personal' => 'Personal',
			'S13_Task_Dashboard.label_prepay_balance' => 'Pool Balance',
			'S13_Task_Dashboard.label_my_balance' => 'My Balance',
			'S13_Task_Dashboard.label_remainder' => ({required Object amount}) => 'Buffer: ${amount}',
			'S13_Task_Dashboard.fab_record' => 'Record',
			'S13_Task_Dashboard.empty_records' => 'No records yet',
			'S13_Task_Dashboard.rule_random' => 'Random',
			'S13_Task_Dashboard.rule_order' => 'Order',
			'S13_Task_Dashboard.rule_member' => 'Member',
			'S13_Task_Dashboard.settlement_button' => 'Settlement',
			'S13_Task_Dashboard.nav_to_record' => 'Navigating to record page...',
			'S13_Task_Dashboard.daily_expense_label' => 'Exp',
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
			'S15_Record_Edit.method_even' => 'Even',
			'S15_Record_Edit.method_exact' => 'Exact Amount',
			'S15_Record_Edit.method_percent' => 'By Percentage',
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
			'S16_TaskCreate_Edit.currency_twd' => 'TWD',
			'S16_TaskCreate_Edit.currency_jpy' => 'JPY',
			'S16_TaskCreate_Edit.currency_usd' => 'USD',
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
			'D04_TaskCreate_Notice.title' => 'Unsaved Changes',
			'D04_TaskCreate_Notice.content' => 'Current settings will be discarded. Are you sure you want to leave?',
			'D04_TaskCreate_Notice.action_leave' => 'Discard',
			'D04_TaskCreate_Notice.action_stay' => 'Keep Editing',
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
			'B02_SplitExpense_Edit.title_add' => 'Add Item',
			'B02_SplitExpense_Edit.title_edit' => 'Edit Item',
			'B02_SplitExpense_Edit.err_input_amount_first' => 'Please enter amount first',
			'B02_SplitExpense_Edit.split_status' => ({required Object count}) => '${count} people',
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
