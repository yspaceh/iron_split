# Iron Split Project Bible（專案聖經）

> **單一真相來源（Single Source of Truth）**
> **版本**：v2.2 (Full Restoration & Schema Update)

---

## 1. 專案目標（MVP）

- **交付形式**：iOS TestFlight 封閉測試
- **系統需求**：iOS 15.0+ (因應 Firebase 最新 SDK 限制)
- **截止日**：2026/02/14
- **開發方式**：AI 協作開發（ChatGPT + Gemini Pro / Gemini CLI）
- **技術**：Flutter（Material 3）+ Firebase（Anonymous Auth / Firestore / Cloud Functions v2）
- **支援語言**：中 / 日 / 英（後端回傳 Code，前端實作完整 i18n）
- **核心價值**：由 App 扮演中立黑臉，解決旅遊/聚餐「算錢尷尬」
- **資料保留政策**：任務結算後資料只保留 30 天（到期清除）

---

## 2. 品牌核心與角色設定（Brand & Character）

### 2.1 專案名稱與理念

- **Iron Split**（アイアンスプリット）
- 核心理念：解決「算錢很尷尬」的社交痛點，讓 App 成為「中立的黑臉」。

### 2.2 吉祥物：Iron Rooster（艾隆・魯斯特）

- **形象**：英國鄉村農場的公雞騎士（Old English Game），帶「唐吉訶德」氣質
- **視覺方向**：簡潔、單純、不遊戲感；適合 finance app 的可信任感
- **主色**：酒紅色系 `#9C393F`

---

## 3. 名詞、角色與權限（Terminology & Permissions）

### 3.1 名詞

- **任務（Task）**：一次旅遊/聚餐的共同記帳單位
- **隊長（Captain）**：任務建立者；擁有部分管理權限
- **成員（Member）**：加入任務的人；結算前可共同編輯
- **結算（Settlement）**：生成最終結果並鎖定任務為唯讀

### 3.2 權限

- **所有成員（結算前）**：
  - 新增/編輯/刪除「費用」「預收」
  - 變更匯率、參與成員
- **隊長限定**：
  - 刪除任務
  - 刪除成員：**僅能刪除「沒有任何費用/預收掛勾」的成員**
  - 結算（Final Confirm）

### 3.3 結算後（鎖定）

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
  - ## 每人有 1 次重抽機會（第二次即鎖定）
- **動物**：
- Holstein Friesian (Dairy Cow) — 荷斯登乳牛
- Horse (Chestnut coat) — 栗色馬
- Domestic Goat — 家山羊
- Suffolk Sheep — 薩福克羊（黑臉羊）
- Domestic Pig — 家豬
- Border Collie — 邊境牧羊犬
- European Badger — 歐洲獾
- European Hare — 歐洲野兔
- Red Fox — 赤狐
- Donkey — 驢
- European Hedgehog — 歐洲刺蝟
- Red Squirrel — 紅松鼠
- Roe Deer — 狍鹿
- Mallard — 綠頭鴨
- House Mouse — 家鼠
- Barn Owl — 倉鴞
- European Robin — 歐亞知更鳥
- Eurasian Otter — 歐亞水獺
- Stoat — 白鼬

---

## 5. MVP 功能範圍（核心邏輯 Updated）

### 5.1 Onboarding / 初始設定

- ToS 同意（p1）
- 輸入顯示名稱（p2）
- 未完成初始設定者：點 deep link 時必須先走完 p1 → p2 才能進入任務確認/加入流程

### 5.2 邀請加入（Invite Flow）— Universal Link

> 核心：**多人共用邀請碼**、**名額限制**、**加入順序制**

- **格式**：`https://iron-split.app/join?code=XXXXXXXX` (Universal Link)
- **Web Fallback**：
  - 已安裝 App：直接開啟 App 導向 `S11_Invite.Confirm`。
  - 未安裝 App：開啟 Landing Page 引導下載 App；安裝後 S00 還原流程。
- **規則**：邀請碼為「多人共用」，先到先加入；名額滿時顯示 `TASK_FULL`。

### 5.3 任務建立

- 欄位：任務名稱、期間（日期）、結算幣別、餘額處理方式。
- 結算前：任務內資料為「可回溯更新」。

### 5.4 記錄（費用/預收）新增 / 編輯 / 刪除

- 記錄欄位：日期、標題、原幣金額+幣別、付款人、參與成員、匯率（必要時）、備註（可選）。
- 主畫面點卡片 → 進入編輯畫面 (S15)。

### 5.5 多幣別與匯率 (Logic Updated)

- **策略**：混合模式 (Local List + Remote Rate)。
- **幣別清單**：使用本地白名單 (`CurrencyConstants`)，包含約 20 種常用旅遊貨幣（如 TWD, JPY, USD, KRW...），確保選單開啟無延遲。
- **匯率來源**：使用 **Frankfurter API** (Open Source / ECB Data)。
  - **安全性**：前端直接呼叫 (Client-side)，無 API Key 外洩風險。
  - **錯誤處理**：若 API 請求失敗（網路問題或服務中斷），系統將靜默處理並回傳 null，UI 應自動退化為「允許使用者手動輸入匯率」的狀態，不阻擋流程。
- **匯率鎖定原則**：
  - 建立/編輯時，系統抓取當下匯率（或使用者手動輸入）。
  - 寫入 DB 後，該筆記錄的 `exchangeRate` 即**鎖定**。
  - 除非使用者手動進入編輯頁並修改，否則不隨市場波動，確保該筆消費的成本恆定。

### 5.6 餘額（Remainder）策略 (Logic Updated)

> 原則：結算前不要把餘額預先灌進個人帳；保留在 `remainderBuffer`，結算時才套用規則。

1. **餘數轉盤 (Random)**：每筆結算餘額進餘額罐；結算時系統隨機挑 1 人負擔。
2. **指定成員 (Member)**：由特定成員（如隊長）概括承受。
3. **輪流 (Order)**：每筆餘額按加入順序輪流分攤到成員。

### 5.7 結算流程

- 結算按下後：進入結算預覽 -> 支付確認 -> 結果頁。
- 結算完成後：任務鎖定唯讀、開始 30 天倒數（到期清除）。

### 5.8 匯出（PDF）

- 由 App 端產生 PDF。
- 內容：結算結果 + 詳細明細。

---

## 6. Deep Link（多 Intent，集中處理）

### 6.1 Intent 列表

- `JoinTaskIntent(code)`
- `OpenSettlementIntent(taskId)` (隊長限定)

### 6.2 套件與隔離策略

- 使用 `app_links`，但封裝於 `DeepLinkService`。
- Dedupe 規則：800ms 內相同 URI 去重。

---

## 7. Firebase / Backend 核心策略（MVP）

### 7.1 Firebase 服務

- Authentication：Anonymous（取得 uid）
- Firestore：任務資料、記錄、邀請碼/邀請狀態
- Cloud Functions v2：處理邀請碼與加入（原子性）

### 7.2 Cloud Functions v2（邀請）

- `createInviteCode`, `previewInviteCode`, `joinByInviteCode`。
- 使用 Firestore Transaction 確保名額控制原子性。

### 7.3 Security / 隔離

- Firestore Rules：確保不同任務資料隔離。

---

## 7.4 Firestore Data Model (Schema v2.0 Updated)

### Collection: `tasks`

| Field           | Type   | Description                       |
| :-------------- | :----- | :-------------------------------- |
| name            | string | 任務名稱                          |
| captainUid      | string | 隊長 UID                          |
| baseCurrency    | string | 結算基準幣別                      |
| balanceRule     | string | `random` / `order` / `member`     |
| remainderBuffer | number | **暫存零頭** (累積除不盡的小數位) |
| totalPool       | number | **公款總額** (預收 - 公款支出)    |
| status          | string | `active`, `settled`, `closed`     |
| members         | map    | `{uid: {role, avatar...}}`        |

### Sub-collection: `tasks/{taskId}/records` (New)

| Field        | Type      | Description                              |
| :----------- | :-------- | :--------------------------------------- |
| type         | string    | `expense` (支出) 或 `prepay` (預收/入金) |
| amount       | number    | 原幣金額                                 |
| currency     | string    | 原幣幣別                                 |
| exchangeRate | number    | **鎖定匯率**                             |
| payerType    | string    | `member` (代墊) 或 `pool` (公款支出)     |
| payerId      | string    | 付款人 UID                               |
| splitMethod  | string    | `even`, `exact`, `percent`, `share`      |
| splitDetails | map       | `{uid: amount}`                          |
| date         | timestamp | 消費日期                                 |
| createdAt    | timestamp | 建立時間（server timestamp）             |

> 註：`date` 在資料庫中以 timestamp 儲存，僅作為排序與一致性用途；
> 畫面顯示時一律格式化為 `YYYY/MM/DD`，不呈現時區概念，亦不作為時區換算依據。
> 補充：同一天多筆記錄排序：先以 `date`（顯示用日期）分組，再以 `createdAt` 做穩定排序。

### Sub-collection: `tasks/{taskId}/settlements` (New)

| Field           | Type      | Description                       |
| :-------------- | :-------- | :-------------------------------- |
| transferActions | array     | `[{from: B, to: A, amount: 100}]` |
| closedAt        | timestamp | 結算時間                          |

### 7.5 外部 API

- **Exchange Rate**: [Frankfurter API](https://api.frankfurter.app) (HTTPS, No Auth)

---

## 8. 設計系統（Material 3 + Brand Tokens）

### 8.1 色彩（v1）

- Primary：`#9C393F`（酒紅）
- OnSurface（文字主色）：`#35343A`
- Background（light）：`#FFFBFF`

### 8.2 兩顆橫排按鈕（左次右主）

- 右側：主按鈕（Filled Primary）
- 左側：次按鈕（Tonal / Outlined）

### 8.3 字體（建議）

- Latin: Inter
- CJK: Noto Sans JP/TC

---

## 9. 里程碑（到 2026/02/14）

- W1：Invite Flow 跑通。
- W2：主畫面 (S13) + 記帳 (S15) + 即時同步。
- W3：多幣別 + 匯率鎖定 + Dashboard Cache。
- W4：結算流程 + PDF 匯出。

---

## 10. 技術命名規範 (Technical Naming Conventions)

- Git / Flutter 專案：`iron_split`
- Firebase Project ID：`iron-split`
- 類別：`UpperCamelCase`
- 檔案：`snake_case.dart`

---

## 11. 錯誤代碼（Error Codes）

- `TASK_FULL`, `EXPIRED_CODE`, `INVALID_CODE`, `AUTH_REQUIRED`

---

## 12. 正式環境切換清單 (Production Readiness Checklist)

- [ ] Firestore 安全規則切換 (Auth required)。
- [ ] 開啟 Firebase App Check。
- [ ] 限制 API 金鑰 (Bundle ID)。
- [ ] 清空測試數據。
- [ ] 驗證 Firebase 區域 (Tokyo)。
- [ ] 檢查 30 天刪除邏輯。

---

## 13. 開發工具/建置備註（MVP 實務）

- Functions runtime：Node 20。
- 若 `predeploy` lint 失敗，可暫時繞過以確保 deploy，之後再修。

---

## 14. 檔案/資料夾管理規則（AI 協作前提）

### 14.1 專案目錄總則（Feature-first）

```text
lib/
├── core/           # router, theme, error, services
├── features/
│   ├── invite/     # S11
│   ├── task/       # S10, S16, S13, S15
│   └── settlement/ # S30-S32
├── l10n/           # slang translations
└── gen/            # generated files
```

### 14.2 狀態管理放置規則

- 狀態物件 (Bloc/Provider) 一律放 `features/<feature>/application/`。
- 禁止在 `core/` 放業務狀態。

### 14.3 外部系統整合放置規則

- `app_links` 只能被 `core/services/deep_link_service.dart` import。
- Firebase 初始化放 `core/services/firebase/`。

### 14.4 i18n 文案放置規則

- 後端只回 Error Code。
- 前端 `l10n/` 定義翻譯。

### 14.5 檔名與層級命名

- `*_page.dart`, `*_widget.dart`, `*_repository.dart`。

---

## 15. App 入口與畫面命名（vLatest / CSV SoT）

### 15.1 PageKey

- **唯一真實來源**：PageSpec CSV。
- AI 協作時以 PageKey 為溝通代碼。
- 畫面型態以 PageKey 前綴 S/B/D 為唯一依據；類型欄位僅供人類閱讀，若衝突以 PageKey 為準。

### 15.2 System Gatekeeper (`S00_System.Bootstrap`)

- 根路由 `/`，負責分流：
  - Invite Link -> `S11_Invite.Confirm` (or S50_Onboarding.Consent/S51_Onboarding.Name)
  - Normal -> `S10_Home.TaskList`

### 15.3 Page Key 列表 (Refactored)

> 以下為代表性範例，非完整列表；實際以 CSV 為準

**Prefix**: `S` (Screen), `D` (Dialog), `B` (Bottom Sheet)

- **System**: `S00_System.Bootstrap`, `S50_Onboarding.Consent`, `S51_Onboarding.Name`
- **Task Loop**:
  - `S10_Home.TaskList` (首頁)
  - `S16_TaskCreate.Edit` (建立)
  - `S13_Task.Dashboard` (主頁 - Date Grouping)
  - `D03_TaskCreate.Confirm`
- **Record**:
  - `S15_Record.Edit` (記帳表單)
  - `B02_SplitExpense.Edit` (細項)
  - `B03_SplitMethod.Edit`
  - `B07_PaymentMethod.Edit`
- **Invite**: `S11_Invite.Confirm`
- **Settlement**:
  - `S30_Settlement.Confirm`
  - `S31_Settlement.PaymentInfo`
  - `S32_Settlement.Result`

### 15.4 狀態語意

- 狀態一律放在 Variants (`mode=active|settled`, `state=pending|cleared`)，不包含在 Page Key 中。

---

## 16. M3 UI Blocks

- **Navigation**: `NavigationListItem`, `ChevronIcon`
- **Segmented**: `SegmentedButton`
- **Text**: `HeadlineMedium` (Amount), `BodyLarge`
- **Keyboard**: `NumericKeyboard`

---

## 17. Page Spec（Single Source of Truth）

- **PageSpec 的唯一真實來源：Notion / CSV**。
- 查詢詳細 Layout / Interaction 請查閱 CSV。

## 變更紀錄（append-only）

- 2026-01-21: 依最新 CSV（SoT）更新命名與 Schema。
  - Refactor: 確認 S10/S13/S15/S16 頁面體系。
  - Schema Update: 定義 Firestore Schema v2.0 (`remainderBuffer`, `totalPool`, `records` v2)。
  - Logic Update: S15 匯率鎖定、餘額分配規則更新。
- 2026-01-21: 依最新 CSV（SoT）更新「15–17 章」命名與 PageSpec 維護策略。
  - Gatekeeper PageKey 修正為 `S00_System.Bootstrap`。
  - 分流決策樹改為語意版（實際 PageKey 以 CSV 為準），並補上目前 CSV 示例鍵名。
  - 明確宣告：AI 只相信 PageKey；「類型」欄位僅輔助閱讀。
  - 第 17 章改為 SoT 說明，不再維護內嵌 PageSpec 表格（避免不同步）。
- 2026-01-19: UI 優化與架構升級。
  - Dependency Upgrade: 升級 GoRouter v17, Firebase v12+，iOS Deployment Target 提升至 15.0。
  - S05 UI Polish: 採用 Section Card 版面，人數改為 Inline Stepper，優化鍵盤 UX。
  - S02 UI Polish: 實作 Fixed Header (動畫+切換器) 與 Scrollable Body 分離架構。
  - D03 Logic: 完成 Share Sheet 原生分享整合。
- 2026-01-17: 完成任務建立與邀請核心流程實作 (S04, S05, D03)。
- 2026-01-16: 同步更新至 vLatest：引入 `S_System.Bootstrap` 作為 `/` 根路由 Gatekeeper（不占用業務編號），並以最新 PageSpec 決策定案邀請流程（`S04_Invite.Confirm` 為 Screen、`D01_MemberRole.Intro`、`D02_InviteJoin.Error`、`S19_Settings.Tos`），同時統一 M3 UI Blocks（含 NavigationListItem/Keyboard）。「⚠️ 已由 vLatest/CSV 重編取代，請以最新 CSV PageKey 為準」
- 2026-01-15: 依最新 Notion PageSpec/CSV 重建「畫面命名（Page Key）與 UI Blocks（vLatest）」章節，移除舊/重複命名，並統一 `SegmentedButton`、新增 NavigationListItem（右側 > 導覽列）與 Keyboard options，降低 AI 混淆。
- 2026-01-15: 新增「畫面命名與規格鍵（Page Key / Screen Naming）」與「M3 UI Blocks（Text/Link、Keyboard）」規則，作為 wireframe / Notion / Figma / AI 協作的單一命名基準。
- 2026-01-15: 新增「檔案/資料夾管理規則（AI 協作前提）」：定義 core vs features、Provider/Bloc 放置、SharedPreferences 落盤策略、generated 檔案規則，避免 AI 亂放檔案。
- 2026-01-15: 補回「正式環境切換清單 (Production Readiness Checklist)」，避免後續遺漏上線前安全/權限/資料清理項目；同時保留 functions deploy 的 MVP workaround。
- 2026-01-15: 【核心開發】後端與導航架構定案。Cloud Functions v2 以 transaction 保證加入原子性；DeepLinkService 封裝 app_links + 800ms dedupe；後端回傳 code、前端 i18n 翻譯策略；邀請碼規則確定為「多人共用 + 名額限制 + TTL 只對未加入者」；結算也將使用 deep link（隊長分享限定）。
- 2026-01-14: 新增「正式環境切換清單」、命名補充、整理主畫面日期導覽列錨點規則、結算流程 p33→p39。
- 2026-01-14: 定案使用 snake_case (iron_split) 作為開發基準。
- 2026-01-13: 建立 vNext（整合 2026/02/14 封測規格）。
