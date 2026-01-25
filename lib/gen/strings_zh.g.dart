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
	late final TranslationsCategoryZh category = TranslationsCategoryZh._(_root);
	late final TranslationsCommonZh common = TranslationsCommonZh._(_root);
	late final TranslationsDialogZh dialog = TranslationsDialogZh._(_root);
	late final TranslationsS50OnboardingConsentZh S50_Onboarding_Consent = TranslationsS50OnboardingConsentZh._(_root);
	late final TranslationsS51OnboardingNameZh S51_Onboarding_Name = TranslationsS51OnboardingNameZh._(_root);
	late final TranslationsS10HomeTaskListZh S10_Home_TaskList = TranslationsS10HomeTaskListZh._(_root);
	late final TranslationsS11InviteConfirmZh S11_Invite_Confirm = TranslationsS11InviteConfirmZh._(_root);
	late final TranslationsS13TaskDashboardZh S13_Task_Dashboard = TranslationsS13TaskDashboardZh._(_root);
	late final TranslationsS15RecordEditZh S15_Record_Edit = TranslationsS15RecordEditZh._(_root);
	late final TranslationsS16TaskCreateEditZh S16_TaskCreate_Edit = TranslationsS16TaskCreateEditZh._(_root);
	late final TranslationsS71SystemSettingsTosZh S71_SystemSettings_Tos = TranslationsS71SystemSettingsTosZh._(_root);
	late final TranslationsD01MemberRoleIntroZh D01_MemberRole_Intro = TranslationsD01MemberRoleIntroZh._(_root);
	late final TranslationsD02InviteResultZh D02_Invite_Result = TranslationsD02InviteResultZh._(_root);
	late final TranslationsD03TaskCreateConfirmZh D03_TaskCreate_Confirm = TranslationsD03TaskCreateConfirmZh._(_root);
	late final TranslationsD05DateJumpNoResultZh D05_DateJump_NoResult = TranslationsD05DateJumpNoResultZh._(_root);
	late final TranslationsD10RecordDeleteConfirmZh D10_RecordDelete_Confirm = TranslationsD10RecordDeleteConfirmZh._(_root);
	late final TranslationsB02SplitExpenseEditZh B02_SplitExpense_Edit = TranslationsB02SplitExpenseEditZh._(_root);
	late final TranslationsB03SplitMethodEditZh B03_SplitMethod_Edit = TranslationsB03SplitMethodEditZh._(_root);
	late final TranslationsB07PaymentMethodEditZh B07_PaymentMethod_Edit = TranslationsB07PaymentMethodEditZh._(_root);
	late final TranslationsErrorZh error = TranslationsErrorZh._(_root);
}

// Path: category
class TranslationsCategoryZh {
	TranslationsCategoryZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '飲食'
	String get food => '飲食';

	/// zh: '交通'
	String get transport => '交通';

	/// zh: '購物'
	String get shopping => '購物';

	/// zh: '娛樂'
	String get entertainment => '娛樂';

	/// zh: '住宿'
	String get accommodation => '住宿';

	/// zh: '其他'
	String get others => '其他';
}

// Path: common
class TranslationsCommonZh {
	TranslationsCommonZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '取消'
	String get cancel => '取消';

	/// zh: '刪除'
	String get delete => '刪除';

	/// zh: '確認'
	String get confirm => '確認';

	/// zh: '返回'
	String get back => '返回';

	/// zh: '保存'
	String get save => '保存';

	/// zh: '錯誤: {message}'
	String error_prefix({required Object message}) => '錯誤: ${message}';

	/// zh: '請先登入'
	String get please_login => '請先登入';

	/// zh: '讀取中...'
	String get loading => '讀取中...';

	/// zh: '編輯'
	String get edit => '編輯';

	/// zh: '關閉'
	String get close => '關閉';

	/// zh: '我'
	String get me => '我';

	/// zh: '必填'
	String get required => '必填';

	/// zh: '放棄變更'
	String get discard => '放棄變更';

	/// zh: '繼續編輯'
	String get keep_editing => '繼續編輯';

	/// zh: '成員'
	String get member_prefix => '成員';

	/// zh: '無紀錄'
	String get no_record => '無紀錄';
}

// Path: dialog
class TranslationsDialogZh {
	TranslationsDialogZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '尚未儲存'
	String get unsaved_changes_title => '尚未儲存';

	/// zh: '變更將不會被儲存，確定要離開嗎？'
	String get unsaved_changes_content => '變更將不會被儲存，確定要離開嗎？';
}

// Path: S50_Onboarding_Consent
class TranslationsS50OnboardingConsentZh {
	TranslationsS50OnboardingConsentZh._(this._root);

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

	/// zh: '登入失敗: {message}'
	String login_failed({required Object message}) => '登入失敗: ${message}';
}

// Path: S51_Onboarding_Name
class TranslationsS51OnboardingNameZh {
	TranslationsS51OnboardingNameZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '名稱設定'
	String get title => '名稱設定';

	/// zh: '請輸入您在 App 內的顯示名稱（1-10 個字）。'
	String get description => '請輸入您在 App 內的顯示名稱（1-10 個字）。';

	/// zh: '輸入暱稱'
	String get field_hint => '輸入暱稱';

	/// zh: '{current}/10'
	String field_counter({required Object current}) => '${current}/10';

	/// zh: '名稱不能為空'
	String get error_empty => '名稱不能為空';

	/// zh: '最多 10 個字'
	String get error_too_long => '最多 10 個字';

	/// zh: '包含無效字元'
	String get error_invalid_char => '包含無效字元';

	/// zh: '設定完成'
	String get action_next => '設定完成';
}

// Path: S10_Home_TaskList
class TranslationsS10HomeTaskListZh {
	TranslationsS10HomeTaskListZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '我的任務'
	String get title => '我的任務';

	/// zh: '進行中'
	String get tab_in_progress => '進行中';

	/// zh: '已完成'
	String get tab_completed => '已完成';

	/// zh: '鐵公雞準備中...'
	String get mascot_preparing => '鐵公雞準備中...';

	/// zh: '目前沒有進行中的任務'
	String get empty_in_progress => '目前沒有進行中的任務';

	/// zh: '沒有已完成的任務'
	String get empty_completed => '沒有已完成的任務';

	/// zh: '日期未定'
	String get date_tbd => '日期未定';

	/// zh: '確認刪除'
	String get delete_confirm_title => '確認刪除';

	/// zh: '確定要刪除這個任務嗎？'
	String get delete_confirm_content => '確定要刪除這個任務嗎？';
}

// Path: S11_Invite_Confirm
class TranslationsS11InviteConfirmZh {
	TranslationsS11InviteConfirmZh._(this._root);

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

	/// zh: '加入失敗：{message}'
	String error_join_failed({required Object message}) => '加入失敗：${message}';

	/// zh: '發生錯誤：{message}'
	String error_generic({required Object message}) => '發生錯誤：${message}';

	/// zh: '選擇要繼承的成員'
	String get label_select_ghost => '選擇要繼承的成員';

	/// zh: '已墊付'
	String get label_prepaid => '已墊付';

	/// zh: '應分攤'
	String get label_expense => '應分攤';
}

// Path: S13_Task_Dashboard
class TranslationsS13TaskDashboardZh {
	TranslationsS13TaskDashboardZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '任務主頁'
	String get title => '任務主頁';

	/// zh: '大家'
	String get tab_group => '大家';

	/// zh: '個人'
	String get tab_personal => '個人';

	/// zh: '公款餘額 (Pool)'
	String get label_prepay_balance => '公款餘額 (Pool)';

	/// zh: '我的收支'
	String get label_my_balance => '我的收支';

	/// zh: '暫存零頭: {amount}'
	String label_remainder({required Object amount}) => '暫存零頭: ${amount}';

	/// zh: '記一筆'
	String get fab_record => '記一筆';

	/// zh: '還沒有任何紀錄'
	String get empty_records => '還沒有任何紀錄';

	/// zh: '隨機'
	String get rule_random => '隨機';

	/// zh: '順序'
	String get rule_order => '順序';

	/// zh: '指定'
	String get rule_member => '指定';

	/// zh: '結算'
	String get settlement_button => '結算';

	/// zh: '準備前往記帳頁面...'
	String get nav_to_record => '準備前往記帳頁面...';

	/// zh: '支出'
	String get daily_expense_label => '支出';
}

// Path: S15_Record_Edit
class TranslationsS15RecordEditZh {
	TranslationsS15RecordEditZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '記一筆'
	String get title_create => '記一筆';

	/// zh: '編輯紀錄'
	String get title_edit => '編輯紀錄';

	/// zh: '分攤資訊'
	String get section_split => '分攤資訊';

	/// zh: '日期'
	String get label_date => '日期';

	/// zh: '項目名稱'
	String get label_title => '項目名稱';

	/// zh: '輸入消費項目 (如：晚餐)'
	String get hint_title => '輸入消費項目 (如：晚餐)';

	/// zh: '支付方式'
	String get label_payment_method => '支付方式';

	/// zh: '預收'
	String get val_prepay => '預收';

	/// zh: '{name} 先付'
	String val_member_paid({required Object name}) => '${name} 先付';

	/// zh: '金額'
	String get label_amount => '金額';

	/// zh: '匯率 (1 {base} = ? {target})'
	String label_rate({required Object base, required Object target}) => '匯率 (1 ${base} = ? ${target})';

	/// zh: '備註'
	String get label_memo => '備註';

	/// zh: '輸入備註...'
	String get hint_memo => '輸入備註...';

	/// zh: '儲存紀錄'
	String get action_save => '儲存紀錄';

	/// zh: '細項分拆'
	String get val_split_details => '細項分拆';

	/// zh: '總計 {amount} 由 {method} 分攤'
	String val_split_summary({required Object amount, required Object method}) => '總計 ${amount} 由 ${method} 分攤';

	/// zh: '平均分攤'
	String get method_even => '平均分攤';

	/// zh: '金額分攤'
	String get method_exact => '金額分攤';

	/// zh: '比例分攤'
	String get method_percent => '比例分攤';

	/// zh: '匯率來源'
	String get info_rate_source => '匯率來源';

	/// zh: '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。'
	String get msg_rate_source => '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。';

	/// zh: '關閉'
	String get btn_close => '關閉';

	/// zh: '≈ {base}{symbol} {amount}'
	String val_converted_amount({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}';

	/// zh: '剩餘金額'
	String get val_split_remaining => '剩餘金額';

	/// zh: '剩餘金額不足'
	String get err_amount_not_enough => '剩餘金額不足';

	/// zh: '細項說明'
	String get val_mock_note => '細項說明';

	/// zh: '支出'
	String get tab_expense => '支出';

	/// zh: '預收'
	String get tab_income => '預收';

	/// zh: '預收功能開發中...'
	String get msg_income_developing => '預收功能開發中...';

	/// zh: '此功能尚未實作'
	String get msg_not_implemented => '此功能尚未實作';

	/// zh: '請先輸入金額'
	String get err_input_amount => '請先輸入金額';

	/// zh: '細項分拆'
	String get section_items => '細項分拆';

	/// zh: '新增細項'
	String get add_item => '新增細項';

	/// zh: '剩餘金額 (Base)'
	String get base_card_title => '剩餘金額 (Base)';

	/// zh: '預收款'
	String get type_income_title => '預收款';

	/// zh: '剩餘金額 (Base)'
	String get base_card_title_expense => '剩餘金額 (Base)';

	/// zh: '資金來源 (入金者)'
	String get base_card_title_income => '資金來源 (入金者)';
}

// Path: S16_TaskCreate_Edit
class TranslationsS16TaskCreateEditZh {
	TranslationsS16TaskCreateEditZh._(this._root);

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

	/// zh: '{current}/20'
	String field_name_counter({required Object current}) => '${current}/20';

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

// Path: S71_SystemSettings_Tos
class TranslationsS71SystemSettingsTosZh {
	TranslationsS71SystemSettingsTosZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '服務條款'
	String get title => '服務條款';
}

// Path: D01_MemberRole_Intro
class TranslationsD01MemberRoleIntroZh {
	TranslationsD01MemberRoleIntroZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '你的角色是...'
	String get title => '你的角色是...';

	/// zh: '換個動物'
	String get action_reroll => '換個動物';

	/// zh: '進入任務'
	String get action_enter => '進入任務';

	/// zh: '還有 1 次機會'
	String get desc_reroll_left => '還有 1 次機會';

	/// zh: '機會已用完'
	String get desc_reroll_empty => '機會已用完';

	/// zh: '這是你在本次任務中的專屬頭像。所有分帳紀錄都會使用這個動物代表你喔！'
	String get dialog_content => '這是你在本次任務中的專屬頭像。所有分帳紀錄都會使用這個動物代表你喔！';
}

// Path: D02_Invite_Result
class TranslationsD02InviteResultZh {
	TranslationsD02InviteResultZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '加入失敗'
	String get title => '加入失敗';

	/// zh: '回首頁'
	String get action_back => '回首頁';

	/// zh: '邀請碼無效，請確認連結是否正確。'
	String get error_INVALID_CODE => '邀請碼無效，請確認連結是否正確。';

	/// zh: '邀請連結已過期 (超過 15 分鐘)，請請隊長重新分享。'
	String get error_EXPIRED_CODE => '邀請連結已過期 (超過 15 分鐘)，請請隊長重新分享。';

	/// zh: '任務人數已滿 (上限 15 人)，無法加入。'
	String get error_TASK_FULL => '任務人數已滿 (上限 15 人)，無法加入。';

	/// zh: '身分驗證失敗，請重新啟動 App。'
	String get error_AUTH_REQUIRED => '身分驗證失敗，請重新啟動 App。';

	/// zh: '發生未知錯誤，請稍後再試。'
	String get error_UNKNOWN => '發生未知錯誤，請稍後再試。';
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

	/// zh: '快來加入我的 Iron Split 任務「{taskName}」！ 邀請碼：{code} 連結：{link}'
	String share_message({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「${taskName}」！\n邀請碼：${code}\n連結：${link}';
}

// Path: D05_DateJump_NoResult
class TranslationsD05DateJumpNoResultZh {
	TranslationsD05DateJumpNoResultZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '無紀錄'
	String get title => '無紀錄';

	/// zh: '找不到此日期的紀錄，要新增一筆嗎？'
	String get content => '找不到此日期的紀錄，要新增一筆嗎？';

	/// zh: '返回'
	String get action_cancel => '返回';

	/// zh: '新增紀錄'
	String get action_add => '新增紀錄';
}

// Path: D10_RecordDelete_Confirm
class TranslationsD10RecordDeleteConfirmZh {
	TranslationsD10RecordDeleteConfirmZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '刪除紀錄？'
	String get delete_record_title => '刪除紀錄？';

	/// zh: '確定要刪除 {title} ({amount}) 嗎？'
	String delete_record_content({required Object title, required Object amount}) => '確定要刪除 ${title} (${amount}) 嗎？';

	/// zh: '紀錄已刪除'
	String get deleted_success => '紀錄已刪除';
}

// Path: B02_SplitExpense_Edit
class TranslationsB02SplitExpenseEditZh {
	TranslationsB02SplitExpenseEditZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '編輯細項'
	String get title => '編輯細項';

	/// zh: '項目名稱'
	String get name_label => '項目名稱';

	/// zh: '金額'
	String get amount_label => '金額';

	/// zh: '分攤設定'
	String get split_button_prefix => '分攤設定';

	/// zh: '備註'
	String get hint_memo => '備註';

	/// zh: '成員分配'
	String get section_members => '成員分配';

	/// zh: '剩餘: {amount}'
	String label_remainder({required Object amount}) => '剩餘: ${amount}';

	/// zh: '總計: {current}/{target}'
	String label_total({required Object current, required Object target}) => '總計: ${current}/${target}';

	/// zh: '總金額不符'
	String get error_total_mismatch => '總金額不符';

	/// zh: '總比例必須為 100%'
	String get error_percent_mismatch => '總比例必須為 100%';

	/// zh: '確認分拆'
	String get action_save => '確認分拆';

	/// zh: '金額'
	String get hint_amount => '金額';

	/// zh: '%'
	String get hint_percent => '%';
}

// Path: B03_SplitMethod_Edit
class TranslationsB03SplitMethodEditZh {
	TranslationsB03SplitMethodEditZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '選擇分攤方式'
	String get title => '選擇分攤方式';

	/// zh: '平均分攤'
	String get method_even => '平均分攤';

	/// zh: '比例分攤'
	String get method_percent => '比例分攤';

	/// zh: '指定金額'
	String get method_exact => '指定金額';

	/// zh: '選定成員平分，餘額存入餘額罐'
	String get desc_even => '選定成員平分，餘額存入餘額罐';

	/// zh: '依設定比例分配'
	String get desc_percent => '依設定比例分配';

	/// zh: '手動輸入金額，總額需吻合'
	String get desc_exact => '手動輸入金額，總額需吻合';

	/// zh: '餘額 {amount} 將存入餘額罐 (結算時分配)'
	String msg_leftover_pot({required Object amount}) => '餘額 ${amount} 將存入餘額罐 (結算時分配)';

	/// zh: '比例'
	String get label_weight => '比例';

	/// zh: '總金額不符 (差額 {diff})'
	String error_total_mismatch({required Object diff}) => '總金額不符 (差額 ${diff})';

	/// zh: '調整權重'
	String get btn_adjust_weight => '調整權重';
}

// Path: B07_PaymentMethod_Edit
class TranslationsB07PaymentMethodEditZh {
	TranslationsB07PaymentMethodEditZh._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// zh: '選擇資金來源'
	String get title => '選擇資金來源';

	/// zh: '成員墊付'
	String get type_member => '成員墊付';

	/// zh: '公款支付'
	String get type_prepay => '公款支付';

	/// zh: '混合支付'
	String get type_mixed => '混合支付';

	/// zh: '公款餘額: {amount}'
	String prepay_balance({required Object amount}) => '公款餘額: ${amount}';

	/// zh: '餘額不足'
	String get err_balance_not_enough => '餘額不足';

	/// zh: '墊付成員'
	String get section_payer => '墊付成員';

	/// zh: '支付金額'
	String get label_amount => '支付金額';

	/// zh: '費用總額'
	String get total_label => '費用總額';

	/// zh: '公款支付'
	String get total_prepay => '公款支付';

	/// zh: '墊付總計'
	String get total_advance => '墊付總計';

	/// zh: '金額吻合'
	String get status_balanced => '金額吻合';

	/// zh: '尚差 {amount}'
	String status_remaining({required Object amount}) => '尚差 ${amount}';

	/// zh: '已自動填入公款餘額'
	String get msg_auto_fill_prepay => '已自動填入公款餘額';
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
			'category.food' => '飲食',
			'category.transport' => '交通',
			'category.shopping' => '購物',
			'category.entertainment' => '娛樂',
			'category.accommodation' => '住宿',
			'category.others' => '其他',
			'common.cancel' => '取消',
			'common.delete' => '刪除',
			'common.confirm' => '確認',
			'common.back' => '返回',
			'common.save' => '保存',
			'common.error_prefix' => ({required Object message}) => '錯誤: ${message}',
			'common.please_login' => '請先登入',
			'common.loading' => '讀取中...',
			'common.edit' => '編輯',
			'common.close' => '關閉',
			'common.me' => '我',
			'common.required' => '必填',
			'common.discard' => '放棄變更',
			'common.keep_editing' => '繼續編輯',
			'common.member_prefix' => '成員',
			'common.no_record' => '無紀錄',
			'dialog.unsaved_changes_title' => '尚未儲存',
			'dialog.unsaved_changes_content' => '變更將不會被儲存，確定要離開嗎？',
			'S50_Onboarding_Consent.title' => '歡迎使用 Iron Split',
			'S50_Onboarding_Consent.content_prefix' => '歡迎使用 Iron Split。點擊開始即代表您同意我們的 ',
			'S50_Onboarding_Consent.terms_link' => '服務條款',
			'S50_Onboarding_Consent.and' => ' 與 ',
			'S50_Onboarding_Consent.privacy_link' => '隱私政策',
			'S50_Onboarding_Consent.content_suffix' => '。我們採用匿名登入，保障您的隱私。',
			'S50_Onboarding_Consent.agree_btn' => '開始使用',
			'S50_Onboarding_Consent.login_failed' => ({required Object message}) => '登入失敗: ${message}',
			'S51_Onboarding_Name.title' => '名稱設定',
			'S51_Onboarding_Name.description' => '請輸入您在 App 內的顯示名稱（1-10 個字）。',
			'S51_Onboarding_Name.field_hint' => '輸入暱稱',
			'S51_Onboarding_Name.field_counter' => ({required Object current}) => '${current}/10',
			'S51_Onboarding_Name.error_empty' => '名稱不能為空',
			'S51_Onboarding_Name.error_too_long' => '最多 10 個字',
			'S51_Onboarding_Name.error_invalid_char' => '包含無效字元',
			'S51_Onboarding_Name.action_next' => '設定完成',
			'S10_Home_TaskList.title' => '我的任務',
			'S10_Home_TaskList.tab_in_progress' => '進行中',
			'S10_Home_TaskList.tab_completed' => '已完成',
			'S10_Home_TaskList.mascot_preparing' => '鐵公雞準備中...',
			'S10_Home_TaskList.empty_in_progress' => '目前沒有進行中的任務',
			'S10_Home_TaskList.empty_completed' => '沒有已完成的任務',
			'S10_Home_TaskList.date_tbd' => '日期未定',
			'S10_Home_TaskList.delete_confirm_title' => '確認刪除',
			'S10_Home_TaskList.delete_confirm_content' => '確定要刪除這個任務嗎？',
			'S11_Invite_Confirm.title' => '加入任務',
			'S11_Invite_Confirm.subtitle' => '您受邀加入以下任務：',
			'S11_Invite_Confirm.loading_invite' => '正在讀取邀請函...',
			'S11_Invite_Confirm.join_failed_title' => '哎呀！無法加入任務',
			'S11_Invite_Confirm.identity_match_title' => '請問您是以下成員嗎？',
			'S11_Invite_Confirm.identity_match_desc' => '此任務已預先建立了部分成員名單。若您是其中一位，請點選該名字以連結帳號；若都不是，請直接加入。',
			'S11_Invite_Confirm.status_linking' => '將以「連結帳號」方式加入',
			'S11_Invite_Confirm.status_new_member' => '將以「新成員」身分加入',
			'S11_Invite_Confirm.action_confirm' => '加入',
			'S11_Invite_Confirm.action_cancel' => '取消',
			'S11_Invite_Confirm.action_home' => '回首頁',
			'S11_Invite_Confirm.error_join_failed' => ({required Object message}) => '加入失敗：${message}',
			'S11_Invite_Confirm.error_generic' => ({required Object message}) => '發生錯誤：${message}',
			'S11_Invite_Confirm.label_select_ghost' => '選擇要繼承的成員',
			'S11_Invite_Confirm.label_prepaid' => '已墊付',
			'S11_Invite_Confirm.label_expense' => '應分攤',
			'S13_Task_Dashboard.title' => '任務主頁',
			'S13_Task_Dashboard.tab_group' => '大家',
			'S13_Task_Dashboard.tab_personal' => '個人',
			'S13_Task_Dashboard.label_prepay_balance' => '公款餘額 (Pool)',
			'S13_Task_Dashboard.label_my_balance' => '我的收支',
			'S13_Task_Dashboard.label_remainder' => ({required Object amount}) => '暫存零頭: ${amount}',
			'S13_Task_Dashboard.fab_record' => '記一筆',
			'S13_Task_Dashboard.empty_records' => '還沒有任何紀錄',
			'S13_Task_Dashboard.rule_random' => '隨機',
			'S13_Task_Dashboard.rule_order' => '順序',
			'S13_Task_Dashboard.rule_member' => '指定',
			'S13_Task_Dashboard.settlement_button' => '結算',
			'S13_Task_Dashboard.nav_to_record' => '準備前往記帳頁面...',
			'S13_Task_Dashboard.daily_expense_label' => '支出',
			'S15_Record_Edit.title_create' => '記一筆',
			'S15_Record_Edit.title_edit' => '編輯紀錄',
			'S15_Record_Edit.section_split' => '分攤資訊',
			'S15_Record_Edit.label_date' => '日期',
			'S15_Record_Edit.label_title' => '項目名稱',
			'S15_Record_Edit.hint_title' => '輸入消費項目 (如：晚餐)',
			'S15_Record_Edit.label_payment_method' => '支付方式',
			'S15_Record_Edit.val_prepay' => '預收',
			'S15_Record_Edit.val_member_paid' => ({required Object name}) => '${name} 先付',
			'S15_Record_Edit.label_amount' => '金額',
			'S15_Record_Edit.label_rate' => ({required Object base, required Object target}) => '匯率 (1 ${base} = ? ${target})',
			'S15_Record_Edit.label_memo' => '備註',
			'S15_Record_Edit.hint_memo' => '輸入備註...',
			'S15_Record_Edit.action_save' => '儲存紀錄',
			'S15_Record_Edit.val_split_details' => '細項分拆',
			'S15_Record_Edit.val_split_summary' => ({required Object amount, required Object method}) => '總計 ${amount} 由 ${method} 分攤',
			'S15_Record_Edit.method_even' => '平均分攤',
			'S15_Record_Edit.method_exact' => '金額分攤',
			'S15_Record_Edit.method_percent' => '比例分攤',
			'S15_Record_Edit.info_rate_source' => '匯率來源',
			'S15_Record_Edit.msg_rate_source' => '匯率資料來自 Open Exchange Rates (免費版)，僅供參考。實際匯率請依您的換匯水單為準。',
			'S15_Record_Edit.btn_close' => '關閉',
			'S15_Record_Edit.val_converted_amount' => ({required Object base, required Object symbol, required Object amount}) => '≈ ${base}${symbol} ${amount}',
			'S15_Record_Edit.val_split_remaining' => '剩餘金額',
			'S15_Record_Edit.err_amount_not_enough' => '剩餘金額不足',
			'S15_Record_Edit.val_mock_note' => '細項說明',
			'S15_Record_Edit.tab_expense' => '支出',
			'S15_Record_Edit.tab_income' => '預收',
			'S15_Record_Edit.msg_income_developing' => '預收功能開發中...',
			'S15_Record_Edit.msg_not_implemented' => '此功能尚未實作',
			'S15_Record_Edit.err_input_amount' => '請先輸入金額',
			'S15_Record_Edit.section_items' => '細項分拆',
			'S15_Record_Edit.add_item' => '新增細項',
			'S15_Record_Edit.base_card_title' => '剩餘金額 (Base)',
			'S15_Record_Edit.type_income_title' => '預收款',
			'S15_Record_Edit.base_card_title_expense' => '剩餘金額 (Base)',
			'S15_Record_Edit.base_card_title_income' => '資金來源 (入金者)',
			'S16_TaskCreate_Edit.title' => '新增任務',
			'S16_TaskCreate_Edit.section_name' => '任務名稱',
			'S16_TaskCreate_Edit.section_period' => '任務期間',
			'S16_TaskCreate_Edit.section_settings' => '結算設定',
			'S16_TaskCreate_Edit.field_name_hint' => '例如：東京五日遊',
			'S16_TaskCreate_Edit.field_name_counter' => ({required Object current}) => '${current}/20',
			'S16_TaskCreate_Edit.field_start_date' => '開始日期',
			'S16_TaskCreate_Edit.field_end_date' => '結束日期',
			'S16_TaskCreate_Edit.field_currency' => '結算幣別',
			'S16_TaskCreate_Edit.field_member_count' => '參加人數',
			'S16_TaskCreate_Edit.action_save' => '保存',
			'S16_TaskCreate_Edit.picker_done' => '確定',
			'S16_TaskCreate_Edit.error_name_empty' => '請輸入任務名稱',
			'S16_TaskCreate_Edit.currency_twd' => '新台幣 (TWD)',
			'S16_TaskCreate_Edit.currency_jpy' => '日圓 (JPY)',
			'S16_TaskCreate_Edit.currency_usd' => '美金 (USD)',
			'S71_SystemSettings_Tos.title' => '服務條款',
			'D01_MemberRole_Intro.title' => '你的角色是...',
			'D01_MemberRole_Intro.action_reroll' => '換個動物',
			'D01_MemberRole_Intro.action_enter' => '進入任務',
			'D01_MemberRole_Intro.desc_reroll_left' => '還有 1 次機會',
			'D01_MemberRole_Intro.desc_reroll_empty' => '機會已用完',
			'D01_MemberRole_Intro.dialog_content' => '這是你在本次任務中的專屬頭像。所有分帳紀錄都會使用這個動物代表你喔！',
			'D02_Invite_Result.title' => '加入失敗',
			'D02_Invite_Result.action_back' => '回首頁',
			'D02_Invite_Result.error_INVALID_CODE' => '邀請碼無效，請確認連結是否正確。',
			'D02_Invite_Result.error_EXPIRED_CODE' => '邀請連結已過期 (超過 15 分鐘)，請請隊長重新分享。',
			'D02_Invite_Result.error_TASK_FULL' => '任務人數已滿 (上限 15 人)，無法加入。',
			'D02_Invite_Result.error_AUTH_REQUIRED' => '身分驗證失敗，請重新啟動 App。',
			'D02_Invite_Result.error_UNKNOWN' => '發生未知錯誤，請稍後再試。',
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
			'D03_TaskCreate_Confirm.share_message' => ({required Object taskName, required Object code, required Object link}) => '快來加入我的 Iron Split 任務「${taskName}」！\n邀請碼：${code}\n連結：${link}',
			'D05_DateJump_NoResult.title' => '無紀錄',
			'D05_DateJump_NoResult.content' => '找不到此日期的紀錄，要新增一筆嗎？',
			'D05_DateJump_NoResult.action_cancel' => '返回',
			'D05_DateJump_NoResult.action_add' => '新增紀錄',
			'D10_RecordDelete_Confirm.delete_record_title' => '刪除紀錄？',
			'D10_RecordDelete_Confirm.delete_record_content' => ({required Object title, required Object amount}) => '確定要刪除 ${title} (${amount}) 嗎？',
			'D10_RecordDelete_Confirm.deleted_success' => '紀錄已刪除',
			'B02_SplitExpense_Edit.title' => '編輯細項',
			'B02_SplitExpense_Edit.name_label' => '項目名稱',
			'B02_SplitExpense_Edit.amount_label' => '金額',
			'B02_SplitExpense_Edit.split_button_prefix' => '分攤設定',
			'B02_SplitExpense_Edit.hint_memo' => '備註',
			'B02_SplitExpense_Edit.section_members' => '成員分配',
			'B02_SplitExpense_Edit.label_remainder' => ({required Object amount}) => '剩餘: ${amount}',
			'B02_SplitExpense_Edit.label_total' => ({required Object current, required Object target}) => '總計: ${current}/${target}',
			'B02_SplitExpense_Edit.error_total_mismatch' => '總金額不符',
			'B02_SplitExpense_Edit.error_percent_mismatch' => '總比例必須為 100%',
			'B02_SplitExpense_Edit.action_save' => '確認分拆',
			'B02_SplitExpense_Edit.hint_amount' => '金額',
			'B02_SplitExpense_Edit.hint_percent' => '%',
			'B03_SplitMethod_Edit.title' => '選擇分攤方式',
			'B03_SplitMethod_Edit.method_even' => '平均分攤',
			'B03_SplitMethod_Edit.method_percent' => '比例分攤',
			'B03_SplitMethod_Edit.method_exact' => '指定金額',
			'B03_SplitMethod_Edit.desc_even' => '選定成員平分，餘額存入餘額罐',
			'B03_SplitMethod_Edit.desc_percent' => '依設定比例分配',
			'B03_SplitMethod_Edit.desc_exact' => '手動輸入金額，總額需吻合',
			'B03_SplitMethod_Edit.msg_leftover_pot' => ({required Object amount}) => '餘額 ${amount} 將存入餘額罐 (結算時分配)',
			'B03_SplitMethod_Edit.label_weight' => '比例',
			'B03_SplitMethod_Edit.error_total_mismatch' => ({required Object diff}) => '總金額不符 (差額 ${diff})',
			'B03_SplitMethod_Edit.btn_adjust_weight' => '調整權重',
			'B07_PaymentMethod_Edit.title' => '選擇資金來源',
			'B07_PaymentMethod_Edit.type_member' => '成員墊付',
			'B07_PaymentMethod_Edit.type_prepay' => '公款支付',
			'B07_PaymentMethod_Edit.type_mixed' => '混合支付',
			'B07_PaymentMethod_Edit.prepay_balance' => ({required Object amount}) => '公款餘額: ${amount}',
			'B07_PaymentMethod_Edit.err_balance_not_enough' => '餘額不足',
			'B07_PaymentMethod_Edit.section_payer' => '墊付成員',
			'B07_PaymentMethod_Edit.label_amount' => '支付金額',
			'B07_PaymentMethod_Edit.total_label' => '費用總額',
			'B07_PaymentMethod_Edit.total_prepay' => '公款支付',
			'B07_PaymentMethod_Edit.total_advance' => '墊付總計',
			'B07_PaymentMethod_Edit.status_balanced' => '金額吻合',
			'B07_PaymentMethod_Edit.status_remaining' => ({required Object amount}) => '尚差 ${amount}',
			'B07_PaymentMethod_Edit.msg_auto_fill_prepay' => '已自動填入公款餘額',
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
