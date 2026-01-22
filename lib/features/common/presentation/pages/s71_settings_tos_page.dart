import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S71_Settings.Tos
/// 描述：服務條款與隱私權政策頁面。
/// 職責：顯示法律文件供使用者審閱。
class S71SettingsTosPage extends StatelessWidget {
  const S71SettingsTosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 獲取主題色彩與文字樣式
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        // 標題來自 i18n
        title: Text(t.S71_SystemSettings_Tos.title),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        // 驗收點：從 S00 進入時應顯示返回鍵以回到同意流程
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: [MVP] 串接後端 API 取得正式法律文本或改用 WebView
            Text(
              "最後更新日期：2026-01-15",
              style:
                  textTheme.labelMedium?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              title: "1. 服務簡介",
              content:
                  "Iron Split（以下簡稱「本服務」）提供匿名記帳與費用分攤管理功能。本服務旨在協助使用者管理暫時性的共同開銷任務。",
            ),

            _buildSection(
              context,
              title: "2. 匿名帳號規範",
              content:
                  "本服務採用匿名登入機制（Firebase Anonymous Auth）。使用者無需提供真實姓名或電子郵件即可開始使用。請注意，更換裝置或清除 App 快取後，若無綁定社交帳號，資料可能無法找回。",
            ),

            _buildSection(
              context,
              title: "3. 資料保存與清除",
              content:
                  "為了保護個人隱私，本服務僅保存活躍任務資料。所有任務資料將於任務「結算完成」後的 30 天內自動從伺服器端清除。",
            ),

            _buildSection(
              context,
              title: "4. 免責聲明",
              content: "本服務僅作為計算輔助工具，對於因使用本服務所產生之任何金錢糾紛或計算錯誤，開發團隊不負擔任何法律賠償責任。",
            ),

            const SizedBox(height: 48),
            Center(
              child: Text(
                "© 2026 Iron Split Team",
                style:
                    textTheme.labelSmall?.copyWith(color: colorScheme.outline),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// 建立條款區塊的輔助組件
  Widget _buildSection(BuildContext context,
      {required String title, required String content}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
