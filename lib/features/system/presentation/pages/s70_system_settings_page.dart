import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_language_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/features/common/presentation/widgets/nav_title.dart';
import 'package:iron_split/features/common/presentation/widgets/section_wrapper.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s70_system_settings_vm.dart';

/// S70_System.Settings
class S70SystemSettingsPage extends StatelessWidget {
  const S70SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 提供 VM
    return ChangeNotifierProvider(
      create: (context) => S70SystemSettingsViewModel(
        onboardingService: context.read<OnboardingService>(),
        // 假設我們可以從 UserRepo 或 OnboardingService 拿到初始名稱，
        // 如果 VM 內部會自己 init loading，這裡傳空字串也可以
        initialName: '',
      ), // VM 內部建構子已包含 _init() 呼叫
      child: const _S70Content(),
    );
  }
}

class _S70Content extends StatefulWidget {
  const _S70Content();

  @override
  State<_S70Content> createState() => _S70ContentState();
}

class _S70ContentState extends State<_S70Content> {
  // 2. 建立 FocusNode
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 3. 綁定監聽器：焦點失去時自動儲存
    final vm = context.read<S70SystemSettingsViewModel>();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        vm.updateName();
      }
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S70SystemSettingsViewModel>();

    // 簡單的 Loading 狀態處理
    if (vm.isLoading && vm.nameController.text.isEmpty) {
      // 只有在初始載入且沒資料時才顯示全頁 Loading
      // 避免 updateName 時畫面閃爍
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S14_Task_Settings.title), // 或 t.S70_System_Settings.title
      ),
      // 點擊空白處收起鍵盤 (這會觸發 FocusNode 的 listener -> updateName)
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            SectionWrapper(
              title: t.S14_Task_Settings.section.task_name,
              children: [
                // 4. 將 FocusNode 綁定到 Input
                Focus(
                  focusNode: _nameFocusNode,
                  child: TaskNameInput(
                    controller: vm.nameController,
                    label: t.S70_System_Settings.menu.user_name,
                    hint: t.S51_Onboarding_Name.hint,
                    maxLength: 20,
                  ),
                ),
                if (vm.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
                const SizedBox(height: 16),

                // 5. 語言設定
                TaskLanguageInput(
                  language: vm.currentLocale,
                  onLanguageChanged: (newLocale) =>
                      vm.updateLanguage(newLocale),
                ),
                const SizedBox(height: 16),

                // 6. 收款資料
                NavTile(
                  title: t.S70_System_Settings.menu.payment_info,
                  onTap: () async {
                    await context.pushNamed('payment_settings_page');
                    vm.refreshPaymentInfo();
                  },
                ),
                const SizedBox(height: 16),

                // 7. 法律條款
                NavTile(
                  title: t.S70_System_Settings.menu.terms,
                  onTap: () {
                    context.pushNamed(
                      'S71',
                      extra: {'isTerms': true},
                    );
                  },
                ),
                const SizedBox(height: 8),
                NavTile(
                  title: t.S70_System_Settings.menu.privacy,
                  onTap: () {
                    context.pushNamed(
                      'S71',
                      extra: {'isTerms': false},
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
