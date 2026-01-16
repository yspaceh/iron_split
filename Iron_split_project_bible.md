> 單一真相來源（Single Source of Truth）：之後你跟 ChatGPT / Gemini CLI 溝通都以這份為準。
>
> 更新原則：只在最下方「變更紀錄」新增一筆（append-only），避免 AI 記憶漂移。

---

# Iron Split Project Bible（專案聖經）

## 1. 專案目標（MVP）

- **交付形式**：iOS TestFlight 封閉測試
- **截止日**：2026/02/14
- **開發方式**：AI 協作開發（ChatGPT + Gemini Pro / Gemini CLI）
- **技術**：Flutter（Material 3）+ Firebase（Anonymous Auth / Firestore / Cloud Functions v2）
- **支援語言**：中 / 日 / 英（後端回傳 Code，前端實作完整 i18n）
- **核心價值**：由 App 扮演中立黑臉，解決旅遊/聚餐「算錢尷尬」
- **資料保留政策**：任務結算後資料只保留 30 天（到期清除）

---

## 2. 品牌核心與角色設定（Brand & Character）

### 1.1 專案名稱與理念
- **Iron Split**（アイアンスプリット）
- 核心理念：解決「算錢很尷尬」的社交痛點，讓 App 成為「中立的黑臉」。

### 1.2 吉祥物：Iron Rooster（艾隆・魯斯特）
- **形象**：英國鄉村農場的公雞騎士（Old English Game），帶「唐吉訶德」氣質
- **視覺方向**：簡潔、單純、不遊戲感；適合 finance app 的可信任感
- **主色**：酒紅色系 `#9C393F`

---

## 3. 名詞、角色與權限（Terminology & Permissions）

### 2.1 名詞
- **任務（Task）**：一次旅遊/聚餐的共同記帳單位
- **隊長（Captain）**：任務建立者；擁有部分管理權限
- **成員（Member）**：加入任務的人；結算前可共同編輯
- **結算（Settlement）**：生成最終結果並鎖定任務為唯讀

### 2.2 權限
- **所有成員（結算前）**：
  - 新增/編輯/刪除「費用」「預收」
  - 變更匯率、參與成員
- **隊長限定**：
  - 刪除任務
  - 刪除成員：**僅能刪除「沒有任何費用/預收掛勾」的成員**
  - 結算（Final Confirm）

### 2.3 結算後（鎖定）
- 任務進入唯讀：不可再新增/編輯/刪除任何記錄
- 隊員回到主畫面時顯示 Dialog：
  - 「隊長已結算，資料不可再編輯」
  - 「請於 30 天內下載資料」
- 隊長回到主畫面：不再額外提示（避免打擾）

---

## 4. 成員頭像系統（Avatar System）

- **人數限制**：單一任務上限 15 人
- **視覺主題**：英國鄉村農場動物（大頭 icon）
- **分配機制**：
  - 加入時隨機分配「不重複」頭像
  - 每人有 1 次重抽機會（第二次即鎖定）

---

## 5. MVP 功能範圍（以 wireframe 為準）

### 4.1 Onboarding / 初始設定
- ToS 同意（p1）
- 輸入顯示名稱（p2）
- 未完成初始設定者：點 deep link 時必須先走完 p1 → p2 才能進入任務確認/加入流程

### 4.2 邀請加入（Invite Flow）— Deep link + Share sheet + QR

> 核心：**多人共用邀請碼**、**名額限制**、**加入順序制**、**已加入者不受 TTL 影響**

#### A) 分享方式
- 隊長使用手機內建 **Share sheet** 分享到 LINE / Email
- QR Code：同一個 deep link 的 QR 形式

#### B) Deep link 規格（Join）
- 格式：`iron-split://join?code=XXXXXXXX`
- code 規格：**8 位大寫英數**（可讀、可貼到聊天中不恐怖）
- TTL：**15 分鐘**
  - **僅對「尚未加入任務的人」有效**
  - 已加入成員再次點連結：**直接打開該任務**（即使已過期也不擋）
  - 隊長點自己的分享連結：**只打開任務，不扣名額**

#### C) 多人共用 + 名額規則
- 邀請碼為「多人共用」：隊長分享到群組後，所有人使用同一組 code 加入同一個任務
- 加入順序制：先到先加入
- 若名額已滿：
  - 顯示錯誤（TASK_FULL 專用文案）
  - **停留在錯誤畫面**（不自動跳轉）
  - 引導「請私訊隊長」

#### D) 受邀者流程（未加入者）
1. 開啟連結 → 若未完成初始設定：ToS（p1）→ 顯示名稱（p2）
2. 進入 **確認邀請（p7）**（顯示任務基本資訊）
3. 加入成功 → 進入任務主畫面

#### E) 錯誤 UI 與錯誤代碼
- token/code 無效或過期：共用 p10 UI
  - `INVALID_CODE` / `EXPIRED_CODE`
- 名額已滿：仍使用錯誤頁（p10）但文案依 code 顯示
  - `TASK_FULL`
- 其他（例如需要登入/匿名 auth 尚未完成）
  - `AUTH_REQUIRED`

---

### 4.3 任務建立
- 欄位：任務名稱、期間（日期）、結算幣別、餘額處理方式
- 結算前：任務內資料為「可回溯更新」

### 4.4 記錄（費用/預收）新增 / 編輯 / 刪除
- 記錄欄位：日期、標題、原幣金額+幣別、付款人、參與成員、匯率（必要時）、備註（可選）
- 主畫面點卡片 → 進入與新增很類似的編輯畫面
- 編輯模式底部提供刪除入口（p19/p25）
- 刪除失敗：顯示「刪除失敗 dialog」

### 4.5 多幣別與匯率
- 任務有結算幣別（baseCurrency）
- 記錄可用任意 ISO 幣別輸入
- 幣別 icon 行為：點選→開啟 selector list（全域一致）
- 匯率顯示在輸入框中，使用者可手動修改
- 匯率抓取失敗：
  - 顯示提示文案
  - 或使用任務內前一筆同幣別匯率（若存在）作為預填建議

### 4.6 餘額（Remainder）策略（使用者可選）
> 原則：結算前不要把餘額預先灌進個人帳；保留在費用層/餘額罐，結算時才套用規則

1. **餘數轉盤**：每筆結算餘額進餘額罐；結算時隨機挑 1 人負擔
2. **我來請客**：每筆結算餘額進餘額罐；由自願的 1 名成員負擔
3. **平均分攤（輪流）**：每筆餘額按加入順序輪流分攤到成員
   - 順序固定：以加入任務順序，之後不再變更

### 4.7 結算流程（wireframe p33 起）
- 結算按下後：p33 → p36 → p37 → p38 → p39（回到主畫面但下方區域變換）
- 結算完成後：任務鎖定唯讀、開始 30 天倒數（到期清除）

### 4.8 匯出（PDF）
- 由 App 端產生 PDF（以透明度為核心）
- 格式：
  - 第 1 頁：結算結果（每人應付/應收；已套用餘額規則後的最終值）
  - 後續頁：全部明細（以「輸入的費用/預收」為主：日期、標題、金額、匯率、參與成員）
- PDF 不包含「收款方式」資料（收款方式只用於分享/請款）

---

## 6. Deep Link（多 Intent，集中處理）

### 5.1 Intent 列表
- `JoinTaskIntent(code)`：`iron-split://join?code=XXXXXXXX`
- `OpenSettlementIntent(taskId)`：`iron-split://settlement?taskId=TASK_ID`
  - **隊長分享限定**
  - 非隊長開啟：MVP 規則 = 開啟該任務主畫面（或顯示權限提示；先選一個固定策略）

### 5.2 套件與隔離策略
- 為了穩定監聽 deep link（冷啟動 initial link + 熱啟動 stream），採用 `app_links`
- 但必須做「可替換」封裝：
  - 建立 `DeepLinkService`（介面/抽象層）
  - 只有 `DeepLinkService` 可以 import `app_links`
  - UI / Router 只接收 `DeepLinkIntent`（不直接碰 app_links）

### 5.3 Dedupe 規則（必做）
- 800ms 內相同 URI 去重，避免 Android/Router 情況下重複觸發導覽

---

## 7. Firebase / Backend 核心策略（MVP）

### 6.1 Firebase 服務
- Authentication：Anonymous（取得 uid）
- Firestore：任務資料、記錄、邀請碼/邀請狀態
- Cloud Functions v2：處理邀請碼與加入（原子性）

### 6.2 Cloud Functions v2（邀請）
- functions：
  - `createInviteCode`
  - `previewInviteCode`
  - `joinByInviteCode`
- 原子化控管：使用 Firestore Transaction
  - 檢查名額 → 加入成員 → 更新計數 必須同一個 transaction
- i18n 策略：後端只回傳 Error Code（不回傳文字），前端依語言顯示文案

### 6.3 Security / 隔離（High-level）
- Security Rules：確保不同任務資料隔離（A 任務成員不可讀 B 任務）
- 個資：顯示名為使用者自訂；不依賴真實姓名

---

## 8. 設計系統（Material 3 + Brand Tokens）

### 7.1 色彩（v1）
- Primary：`#9C393F`（酒紅）
- OnSurface（文字主色）：`#35343A`
- Background（light）：`#FFFBFF`

### 7.2 兩顆橫排按鈕（左次右主）
- 右側：主按鈕（Filled Primary）
- 左側：次按鈕（Tonal / Outlined）
- 原則：避免再增加一個「很強的 Secondary 色」讓畫面變花

### 7.3 字體（建議）
- Latin：Inter（或平台系統字）
- 日文：Noto Sans JP（或平台系統字）
- 繁中：Noto Sans TC（或平台系統字）

---

## 9. 里程碑（到 2026/02/14）

- W1：Firebase schema + anonymous auth + Invite Flow 跑通（deep link + join）
- W2：主畫面（日期分段 + date nav）+ 新增/編輯費用/預收 + 即時同步
- W3：多幣別匯率處理 + Dashboard 計算 cache
- W4：結算流程 + 結算後鎖定 + PDF 匯出
- Buffer：bugfix / TestFlight / 文案與 onboarding

---

## 10. 技術命名規範 (Technical Naming Conventions)

- Git / Flutter 專案 / Dart package：`iron_split`（snake_case）
- Firebase Project ID：`iron-split`（kebab-case，平台限制）
- iOS Bundle ID：`com.ironsplit.app`
- 類別：`UpperCamelCase`（例：`IronSplitApp`）
- 檔案：`snake_case.dart`（例：`deep_link_service.dart`）
- 變數/函式：`lowerCamelCase`

---

## 11. 錯誤代碼（Error Codes）
- `TASK_FULL`
- `EXPIRED_CODE`
- `INVALID_CODE`
- `AUTH_REQUIRED`

---

## 12. 正式環境切換清單 (Production Readiness Checklist)

> 為了確保 2026/02/14 封測時的安全性與專業度，從「測試模式」切換至「正式環境」時必須完成以下查核。

### 11.1 安全與權限
- [ ] **Firestore 安全規則切換**：將原本的 `allow read, write: if true` 修改為符合聖經規範的「匿名登入驗證與任務隔離」規則。
- [ ] **開啟 Firebase App Check**：在 Firebase 控制台啟用 App Check，確保只有經認證的 iOS App 才能呼叫後端 API。
- [ ] **限制 API 金鑰**：前往 Google Cloud 控制台，將 API Key 限制為僅能由 `com.ironsplit.app` 的 Bundle ID 使用。

### 11.2 資料與環境
- [ ] **清空測試數據**：在 TestFlight 上架前，手動刪除 Firestore 中所有測試用的任務（Tasks）與成員（Members）數據。
- [ ] **驗證 Firebase 區域**：確認資料庫位於 `asia-northeast1 (Tokyo)` 以確保日本境內連線速度。
- [ ] **檢查 30 天刪除邏輯**：確認結算後觸發 `deleteAt` 的 Cloud Functions 或 TTL 腳本已正確部署。

### 11.3 品牌與 UI
- [ ] **吉祥物 Asset 檢查**：確認所有艾隆・魯斯特（Iron Rooster）相關圖片已正確放置於生產環境路徑。
- [ ] **版本號更新**：確認 `pubspec.yaml` 與 Xcode 內的 Version/Build 已從 1.0.0+1 更新為正確的發布版本。

---

## 13. 開發工具/建置備註（MVP 實務）

### 12.1 Node / Functions
- Functions runtime：Node 20（engines.node = 20）
- Functions 目錄可 `npm run lint` / `npm run build` 通過即視為基本健康

### 12.2 deploy 前置檢查（目前的已知狀況）
- 你遇到過：`firebase deploy --only functions` 時 predeploy 觸發 npm lint 可能出現 `Cannot read properties of undefined (reading 'stdin')`
- **MVP workaround（可接受）**：
  1) 先在 `functions/` 內手動執行：`npm run lint`、`npm run build`
  2) `firebase deploy --only functions`
  3) `firebase.json` 的 `predeploy` 若會導致 deploy 阻塞，可暫時設為空陣列（等 CI 或環境穩定再恢復）
- 原則：MVP 先確保可 deploy + 可測試；之後再回頭把 predeploy 固化成「穩定可重現」

---


---

## 14. 檔案/資料夾管理規則（AI 協作前提）

> 目的：避免 Gemini / ChatGPT 亂放檔案、亂拆層級，讓「檔案放哪裡」變成可驗收的規則。

### 13.1 專案目錄總則（Feature-first）
- `core/`：**跨所有功能共用**、且**不含業務狀態**的基礎能力（例：router/theme/error/通用 services）。
- `features/<feature>/`：**每個功能一個模組**，所有與該功能相關的狀態、UI、資料存取都必須放在該模組內。
- 禁止新增「大雜燴」資料夾：`utils/`, `helpers/`, `common/`（除非內容明確可歸到 `core/` 或某個 feature）。

**推薦目錄：**
```txt
lib/
├── core/
│   ├── router/            # GoRouter / routes
│   ├── theme/             # Material 3 theme + brand tokens
│   ├── error/             # AppError / ErrorCode / ErrorTranslator（後端 code → 前端文案 key）
│   ├── services/          # 跨功能 service：deeplink listener, analytics, remote_config 等
│   └── di/                # 依賴注入（若需要）
├── features/
│   ├── invite/
│   │   ├── presentation/  # pages/widgets
│   │   ├── application/   # Bloc/Cubit/Notifier/Provider（狀態只放這裡）
│   │   ├── domain/        # entities/usecases/repository interface（可選）
│   │   └── data/          # repository impl / firebase datasource / local store(shared_prefs)
│   ├── task/
│   ├── expense/
│   └── settlement/
├── l10n/                  # ARB（或 slang translations 原始檔）
└── gen/                   # （可選）若生成碼要放 lib/ 下；否則使用工具預設生成路徑
```

### 13.2 狀態管理（Provider/Bloc）放置規則（嚴格）
- **任何狀態物件（Bloc/Cubit/ChangeNotifier/StateNotifier/Provider）一律放在：**  
  `features/<feature>/application/`
- `core/` **禁止**放任何「特定功能」的狀態（例如 invite 的 pending code）。
- 例：邀請流程的「中斷恢復 pending deep link」：
  - `features/invite/application/pending_invite_cubit.dart`（記憶體狀態）
  - `features/invite/data/pending_invite_local_store.dart`（SharedPreferences 落盤保險，含 TTL & 一次性清除）

### 13.3 外部系統整合（Firebase / app_links）放置規則
- `app_links` 只能被 `core/services/deep_link_service.dart` import（UI/Router 不可直接碰）。  
  UI / Router 只接收 `DeepLinkIntent`。參照 Deep Link 隔離策略。  
- Firebase 初始化（Auth/Firestore/Functions client）可放 `core/services/firebase/`（跨功能共用），
  **但**「資料存取與 repository」必須放回各 feature 的 `data/`（避免 services 變肥）。
- 800ms dedupe 規則屬於 `DeepLinkService` 的責任。

### 13.4 i18n 文案放置規則
- 後端回傳 Error Code（不回文字），前端負責翻譯（本地化字串）。  
- `core/error/` 放「ErrorCode enum + mapping（code → 文案 key）」；  
  各 feature 需要的 UI 文案 key 放在 i18n 來源（`l10n/` 或 slang translations）。

### 13.5 生成檔（generated）規則
- 生成檔 **不得手改**，也不應被當成主要編輯對象。
- 優先使用工具預設生成路徑；若要放在 `lib/` 下，統一用 `lib/gen/`，避免 `lib/generated/` 分散。

### 13.6 檔名與層級命名（可驗收）
- 檔名一律 `snake_case.dart`（已在命名規範定義）。
- 同一個 feature 內：
  - Page：`*_page.dart`
  - Widget：`*_widget.dart`
  - Bloc/Cubit：`*_bloc.dart` / `*_cubit.dart`
  - Repository：`*_repository.dart`
  - Datasource/Store：`*_data_source.dart` / `*_local_store.dart`

### 13.7 AI 協作驗收規則（防亂放檔案）
- 任何 PR/改動若新增檔案，必須同時回答：
  1) 這個檔案屬於哪個 feature（或 core）？  
  2) 為何不能放在其他層？  
  3) 是否違反 13.2（狀態放置）或 13.3（外部整合隔離）？
- 若無法回答 → 視為「放錯位置」，必須移動後才能合併。



---

## 15. App 入口與畫面命名（vLatest）

> 目標：避免 AI（Gemini / ChatGPT / Figma AI）因為舊命名、重複編號、或把系統層畫面混入業務畫面而產生混亂。**本章節為最新唯一有效版本**；任何舊的/重複的/已推翻的畫面命名，視為移除。

### 15.1 兩層架構（非常重要）
- **System 層（非業務畫面）**：負責 `/` 根路由的初始化與分流（Gatekeeper）。
  - 命名採 **標籤式**：`S_System.*`（不使用 `NN` 數字，不占用業務編號空間）
  - 不屬於 S00～Sxx 業務 Page Key 清單（避免重編與誤解）
- **Business 層（業務畫面）**：使用 Page Key（`S/D/B + NN`）作為穩定 ID（Single Source of Truth）。

### 15.2 System Gatekeeper（根路由 `/`）
- **Page Key**：`S_System.Bootstrap`
- **職責**：
  - 全域初始化（local storage / secure storage / remote config 等）
  - 狀態判斷（是否同意 TOS、是否已設定使用者名稱）
  - Deep Link（邀請連結）解析與中斷恢復
  - 分流到正確的業務畫面（下方決策樹）
- **限制**：
  - 不承載業務 UI（不出現可操作表單/按鈕/清單）
  - 不參與業務畫面編號（不重編、不插入 S00～）
  - 若在 Figma 存在：僅作為「技術占位」Frame，需標註 `System-only / Non-navigable`

**分流決策樹（v1）**
```text
IF launched_from_invite_link:
    IF tos_not_accepted:
        → S00_Onboarding.Consent
    ELSE IF name_not_set:
        → S01_Onboarding.Name
    ELSE:
        → S04_Invite.Confirm
ELSE (normal app launch):
    IF tos_not_accepted:
        → S00_Onboarding.Consent
    ELSE IF name_not_set:
        → S01_Onboarding.Name
    ELSE:
        → S02_Home.TaskList
```

### 15.3 Business Page Key（S / D / B）
- `S` = **Screen**（完整頁面 / route）
- `D` = **Dialog**（彈窗）
- `B` = **BottomSheet**（底部抽屜）

命名格式（固定）
```text
<Prefix><NN>_<Feature>.<Page>
```

> `NN` 是 **穩定 ID**，不是流程順序；定案後不重編。

### 15.4 邀請流程（今天定案的關鍵）
- 邀請確認（wireframe p7–p8）為 **Screen**：`S04_Invite.Confirm`（不是 Dialog）
- 加入成功 Dialog（成員看到自己在任務中的頭像）：`D01_InviteJoin.Success`
- 加入失敗 Dialog：`D02_InviteJoin.Error`
  - **v1 不拆 invalid/ended**（之後觀察使用者錯誤再拆）
- TOS 不讓使用者離開 App：以 **Screen + WebView** 實作：`S19_Settings.Tos`

### 15.5 Figma / 檔案命名（強制）
- Figma Frame 名稱：**必須等於 Page Key**
- 匯出檔名（PNG）：`<Page Key>__shared__v1.png`
- 禁止使用：`p7`、`p10`、`invite_screen` 這種無語意命名

---

## 16. M3 UI Blocks（Notion options：vLatest）

> 原則：不要寫「顯示文字/顯示連結」用途描述；要寫「元件型態 + 可互動性」。

### Navigation（設定頁常見右側 `>`）
```text
NavigationList
NavigationListItem
ChevronIcon
```

### Segmented（M3 正名）
```text
SegmentedButton
```

### Text / Link
```text
Text
BodyText
CaptionText
LabelText
HelperText
ErrorText
InfoText
KeyValueText
ListText
RichText
MarkdownText
InlineLink
TextLink
StandaloneLink
```

### Keyboard
```text
Keyboard
SystemKeyboard
NumericKeyboard
CustomKeyboard
```

---

## 變更紀錄（append-only）
- 2026-01-16: 同步更新至 vLatest：引入 `S_System.Bootstrap` 作為 `/` 根路由 Gatekeeper（不占用業務編號），並以最新 PageSpec 決策定案邀請流程（`S04_Invite.Confirm` 為 Screen、`D01_InviteJoin.Success`、`D02_InviteJoin.Error`、`S19_Settings.Tos`），同時統一 M3 UI Blocks（含 NavigationListItem/Keyboard）。
- 2026-01-15: 依最新 Notion PageSpec/CSV 重建「畫面命名（Page Key）與 UI Blocks（vLatest）」章節，移除舊/重複命名，並統一 `SegmentedButton`、新增 NavigationListItem（右側 > 導覽列）與 Keyboard options，降低 AI 混淆。
- 2026-01-15: 新增「畫面命名與規格鍵（Page Key / Screen Naming）」與「M3 UI Blocks（Text/Link、Keyboard）」規則，作為 wireframe / Notion / Figma / AI 協作的單一命名基準。
- 2026-01-15: 新增「檔案/資料夾管理規則（AI 協作前提）」：定義 core vs features、Provider/Bloc 放置、SharedPreferences 落盤策略、generated 檔案規則，避免 AI 亂放檔案。
- 2026-01-15: 補回「正式環境切換清單 (Production Readiness Checklist)」，避免後續遺漏上線前安全/權限/資料清理項目；同時保留 functions deploy 的 MVP workaround。
- 2026-01-15: 【核心開發】後端與導航架構定案。Cloud Functions v2 以 transaction 保證加入原子性；DeepLinkService 封裝 app_links + 800ms dedupe；後端回傳 code、前端 i18n 翻譯策略；邀請碼規則確定為「多人共用 + 名額限制 + TTL 只對未加入者」；結算也將使用 deep link（隊長分享限定）。
- 2026-01-14: 新增「正式環境切換清單」、命名補充、整理主畫面日期導覽列錨點規則、結算流程 p33→p39。
- 2026-01-14: 定案使用 snake_case (iron_split) 作為開發基準。
- 2026-01-13: 建立 vNext（整合 2026/02/14 封測規格）。

---

## 最後編輯
- Last edited: 2026-01-15 (JST)
