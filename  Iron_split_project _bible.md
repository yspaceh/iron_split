> 單一真相來源（Single Source of Truth）：之後你跟 ChatGPT / Gemini CLI 溝通都以這份為準。
>
> 更新原則：只在最下方「變更紀錄」新增一筆（append-only），避免 AI 記憶漂移。

---

# Iron Split Project Bible（專案聖經）

## 0. 專案目標（MVP）

- **交付形式**：iOS TestFlight 封閉測試
- **截止日**：2026/02/14
- **開發方式**：AI 協作開發（ChatGPT + Gemini Pro / Gemini CLI）
- **技術**：Flutter（Material 3）+ Firebase（Anonymous Auth / Firestore / Cloud Functions v2）
- **支援語言**：中 / 日 / 英（後端回傳 Code，前端實作完整 i18n）
- **核心價值**：由 App 扮演中立黑臉，解決旅遊/聚餐「算錢尷尬」
- **資料保留政策**：任務結算後資料只保留 30 天（到期清除）

---

## 1. 品牌核心與角色設定（Brand & Character）

### 1.1 專案名稱與理念
- **Iron Split**（アイアンスプリット）
- 核心理念：解決「算錢很尷尬」的社交痛點，讓 App 成為「中立的黑臉」。

### 1.2 吉祥物：Iron Rooster（艾隆・魯斯特）
- **形象**：英國鄉村農場的公雞騎士（Old English Game），帶「唐吉訶德」氣質
- **視覺方向**：簡潔、單純、不遊戲感；適合 finance app 的可信任感
- **主色**：酒紅色系 `#9C393F`

---

## 2. 名詞、角色與權限（Terminology & Permissions）

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

## 3. 成員頭像系統（Avatar System）

- **人數限制**：單一任務上限 15 人
- **視覺主題**：英國鄉村農場動物（大頭 icon）
- **分配機制**：
  - 加入時隨機分配「不重複」頭像
  - 每人有 1 次重抽機會（第二次即鎖定）

---

## 4. MVP 功能範圍（以 wireframe 為準）

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

## 5. Deep Link（多 Intent，集中處理）

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

## 6. Firebase / Backend 核心策略（MVP）

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

## 7. 設計系統（Material 3 + Brand Tokens）

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

## 8. 里程碑（到 2026/02/14）

- W1：Firebase schema + anonymous auth + Invite Flow 跑通（deep link + join）
- W2：主畫面（日期分段 + date nav）+ 新增/編輯費用/預收 + 即時同步
- W3：多幣別匯率處理 + Dashboard 計算 cache
- W4：結算流程 + 結算後鎖定 + PDF 匯出
- Buffer：bugfix / TestFlight / 文案與 onboarding

---

## 9. 技術命名規範 (Technical Naming Conventions)

- Git / Flutter 專案 / Dart package：`iron_split`（snake_case）
- Firebase Project ID：`iron-split`（kebab-case，平台限制）
- iOS Bundle ID：`com.ironsplit.app`
- 類別：`UpperCamelCase`（例：`IronSplitApp`）
- 檔案：`snake_case.dart`（例：`deep_link_service.dart`）
- 變數/函式：`lowerCamelCase`

---

## 10. 錯誤代碼（Error Codes）
- `TASK_FULL`
- `EXPIRED_CODE`
- `INVALID_CODE`
- `AUTH_REQUIRED`

---

## 11. 正式環境切換清單 (Production Readiness Checklist)

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

## 12. 開發工具/建置備註（MVP 實務）

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

## 變更紀錄（append-only）
- 2026-01-15: 補回「正式環境切換清單 (Production Readiness Checklist)」，避免後續遺漏上線前安全/權限/資料清理項目；同時保留 functions deploy 的 MVP workaround。
- 2026-01-15: 【核心開發】後端與導航架構定案。Cloud Functions v2 以 transaction 保證加入原子性；DeepLinkService 封裝 app_links + 800ms dedupe；後端回傳 code、前端 i18n 翻譯策略；邀請碼規則確定為「多人共用 + 名額限制 + TTL 只對未加入者」；結算也將使用 deep link（隊長分享限定）。
- 2026-01-14: 新增「正式環境切換清單」、命名補充、整理主畫面日期導覽列錨點規則、結算流程 p33→p39。
- 2026-01-14: 定案使用 snake_case (iron_split) 作為開發基準。
- 2026-01-13: 建立 vNext（整合 2026/02/14 封測規格）。

---

## 最後編輯
- Last edited: 2026-01-15 (JST)