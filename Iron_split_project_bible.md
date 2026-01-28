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
- Cat — 貓

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

## 5.9 核心計算邏輯與幣別標準 (Calculation & Currency Standards)

為了確保多幣別分帳的公平性，並解決匯率換算產生的浮點數誤差，系統必須嚴格遵守以下「錨定總額」與「格式化顯示」標準。

### 5.9.1 幣別顯示標準 (Currency Formatting)

針對不同國家的貨幣習慣，UI 顯示層必須動態調整小數點精度。

- **無小數點貨幣 (Zero-decimal Currencies)**：
  - **定義**：TWD (新台幣), JPY (日圓), KRW (韓元), VND (越南盾), IDR (印尼盾), HUF (匈牙利福林)。
  - **顯示規則**：強制顯示為整數，小數部分四捨五入。
  - **格式**：`#,##0` (例: `TWD 1,235`)。
- **標準貨幣 (Standard Currencies)**：
  - **定義**：USD, EUR, CNY, GBP 等其他貨幣。
  - **顯示規則**：保留兩位小數。
  - **格式**：`#,##0.00` (例: `USD 10.50`)。

### 5.9.2 匯率換算與分攤演算法 (The "Anchor" Algorithm)

當消費幣別與結算幣別不同時，**嚴禁**「先分攤原幣金額，再各自換算」，這會導致總額因四捨五入而飄移。必須採用 **「先換算鎖定總額，再進行分攤」** 的流程。

#### 計算三步驟：

1. **錨定總額 (Anchor the Total)**：
   - 先將整筆消費換算為結算幣別（Base Currency），並進行整數化處理（針對無小數點幣別）。
   - **公式**：`BaseTotal = Round( 原幣金額 * 匯率 )`
   - _目的：確立這筆消費在結算幣別下的「絕對成本」，此數字不可再變動。_

2. **無條件捨去分攤 (Floor Split)**：
   - 計算每位成員應負擔的金額，採用無條件捨去（Floor）以避免超收。
   - **公式**：`MemberAmount = Floor( BaseTotal / 分攤人數 )`

3. **餘額歸罐 (Buffer the Remainder)**：
   - 將「總額」與「所有人分攤總和」的差額，全數歸入餘額緩衝區。
   - **公式**：`Remainder = BaseTotal - Sum( MemberAmounts )`
   - **處理原則**：此餘額**不應**在當下隨機分配給某成員，必須累積至 `remainderBuffer`，待最終結算時統一處理。

#### 範例說明 (Example Case)：

- **情境**：消費 **1,000 JPY**，匯率 **0.211**，結算幣別 **TWD**，**3人**平分。
- **錯誤做法**：1000/3 = 333.33 JPY -> 換算 70.33 TWD -> 總和 210.99 TWD (帳不平)。
- **正確流程 (Iron Split Standard)**：
  1. **Step 1 (Anchor)**: `1,000 * 0.211 = 211 TWD` (鎖定總花費為 211 元)。
  2. **Step 2 (Split)**: `211 / 3 = 70.33...` -> 取 `70` (每人付 70)。
  3. **Step 3 (Buffer)**: `211 - (70 * 3) = 1` -> **1 元** 進入餘額罐。

### 5.9.3 公款水位與庫存計算 (Pool Balance & Inventory)

系統需同時維護「總資產價值」與「物理庫存」兩種觀點：

1.  **分幣別物理庫存 (Physical Inventory)**：
    - **定義**：計算公款包中實際持有的各國貨幣現金。
    - **用途**：S15 記帳時的支付能力檢查 (Smart Picker)、S13 餘額明細 Dialog。
    - **公式**：`Sum(Income Original Amount) - Sum(Expense Prepay Portion Original Amount)` (依幣別分組)。
    - **混合支付處理**：若 `payerType == 'mixed'`，僅扣除 `paymentDetails['prepayAmount']` 指定的金額。

2.  **總資產價值 (Total Value in Base)**：
    - **定義**：將所有外幣庫存按「該筆交易當下匯率」換算回結算幣別後的總價值。
    - **用途**：S13 Dashboard 主視覺餘額 (Big Number)。
    - **公式**：
      - Income: `originalAmount * exchangeRate`
      - Expense (Prepay): `originalAmount * exchangeRate`
      - Expense (Mixed): `paymentDetails['prepayAmount'] * exchangeRate`
    - **注意**：成員代墊 (`member` or `mixed.memberAdvance`) **不減少** 公款水位。

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

## 7.4 Firestore Data Model (Schema v2.5 Privacy First)

### Collection: `users` (Global Settings)

| Field           | Type   | Description                            |
| :-------------- | :----- | :------------------------------------- |
| email           | string | 使用者 Email                           |
| displayName     | string | 顯示名稱                               |
| photoUrl        | string | 頭像 URL                               |
| defaultCurrency | string | 預設偏好幣別 (e.g., "TWD")             |
| language        | string | 介面語言 (`system`, `zh`, `ja`, `en`)  |
| currentTaskId   | string | 上次開啟的任務 ID (App 開啟時自動導航) |

### Collection: `tasks`

| Field           | Type      | Description                                 |
| :-------------- | :-------- | :------------------------------------------ |
| title           | string    | 任務名稱                                    |
| coverEmoji      | string    | 封面 Emoji                                  |
| date            | timestamp | 任務日期                                    |
| status          | string    | `active`, `settled`, `archived`             |
| baseCurrency    | string    | 結算基準幣別 (S14 設定)                     |
| prepayBalance   | number    | **公費池餘額** (取代 totalPool，即時計算用) |
| balanceRule     | string    | `random` / `order` / `member`               |
| remainderBuffer | number    | **暫存零頭** (累積除不盡的小數位)           |
| members         | list/map  | 成員資料 `{id, name, avatar, isLinked...}`  |
| createdBy       | string    | 建立者 UID                                  |
| createdAt       | timestamp | 建立時間                                    |

### Sub-collection: `tasks/{taskId}/records` (MVP Core)

| Field           | Type      | Description                                              |
| :-------------- | :-------- | :------------------------------------------------------- |
| type            | string    | `expense` (支出) 或 `income` (預收/入金)                 |
| title           | string    | 消費標題                                                 |
| categoryIndex   | number    | 類別索引值                                               |
| amount          | number    | 原幣金額                                                 |
| currency        | string    | 原幣幣別代碼 (DB存 `currency`, Model轉為 `currencyCode`) |
| exchangeRate    | number    | **鎖定匯率** (對 Base Currency)                          |
| memo            | string    | 備註                                                     |
| receiptImageUrl | string    | 收據照片 URL (MVP 存證功能)                              |
| payerType       | string    | `prepay` (公費), `member` (代墊), `mixed` (混合)         |
| payerId         | string    | 付款者 UID (單人代墊時使用)                              |
| paymentDetails  | map       | 混合支付結構 (見下方定義)                                |
| splitMethod     | string    | `even`, `percent`, `exact`                               |
| splitMemberIds  | array     | 參與分攤的成員 ID 列表                                   |
| splitDetails    | map       | 詳細數據 `{uid: weight/amount}`                          |
| date            | timestamp | 消費日期 (顯示用)                                        |
| createdBy       | string    | 建立者 UID                                               |
| createdAt       | timestamp | 建立時間 (Server Timestamp)                              |

**`paymentDetails` 結構定義 (Mixed Payment):**
{
"usePrepay": boolean,
"prepayAmount": number, // 使用公款的原幣金額
"useAdvance": boolean,
"memberAdvance": { // 成員代墊明細 (UID: Amount)
"uid_A": number,
"uid_B": number
}
}

### Sub-collection: `tasks/{taskId}/settlements` (S30 Logic)

| Field           | Type      | Description                                               |
| :-------------- | :-------- | :-------------------------------------------------------- |
| closedAt        | timestamp | 結算鎖定時間                                              |
| transferActions | array     | `[{from: B, to: A, amount: 100, status}]`                 |
| status          | string    | 匯款狀態 `pending` / `paid`                               |
| receiverInfos   | map       | 暫存收款資訊 (MVP Privacy)                                |
|                 |           | `{ "uid_A": "Bank Code 822...", "uid_B": "PayPay Link" }` |

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

## 15.5 記帳與餘額顯示規範 (Record & Balance UX)

1.  **S13 Dashboard - 餘額顯示**：
    - 主數字顯示 **「公款總價值 (Cash on Hand)」**，而非會計淨額。
    - 點擊餘額區域，彈出 `Dialog` 顯示 **「分幣別庫存明細」** (e.g., JPY 20,000, TWD 500)。

2.  **S15 Record Edit - 智慧支付選單 (Smart Picker)**：
    - 當使用者切換「消費幣別」時，支付方式選單應動態排序。
    - **優先顯示**：與消費幣別相同的公款餘額 (e.g., 選 JPY 時顯示 `公款 JPY (¥30,000)` )。
    - **次要顯示**：其他幣別的公款餘額。
    - **檢查機制**：若輸入金額 > 該幣別公款餘額，應顯示紅色錯誤提示，並阻擋儲存 (僅限純公款支付模式)。

3.  **M3 Safe Area 規範 (Edge-to-Edge)**：
    - 所有 Bottom Sheet (B02, B03, B07) 的底部 Action/Summary 區塊，必須加上 `MediaQuery.padding.bottom`。
    - 背景色需延伸至螢幕最底端，內容則避開 Home Indicator，確保原生手勢操作流暢。

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

---

## 待確認規格 (Pending Definitions)

1.  **混合支付的結算邏輯 (Settlement for Mixed Payments)**：
    - 需補完 S30 結算公式：`Credit = (PayerType == 'member' ? Total : 0) + (PayerType == 'mixed' ? memberAdvance[uid] : 0)`。
2.  **多幣別餘額的匯率波動處理**：
    - 需定義「換匯 (Transfer/Exchange)」行為：目前的 Record Model 是否足以表達「使用 USD 公款換取 JPY 公款」的損益紀錄？(MVP 暫定為一收一支)。
3.  **Firestore 索引 (Indexes)**：
    - 需建立 `firestore.indexes.json`，特別是針對 `tasks/{id}/records` 的 `date` (desc) + `member` 複合查詢。

## 變更紀錄（append-only）

- **2026-01-28: 多幣別公款水位與混合支付邏輯修正 (v2.3)**
  - **Logic Update (Calculator)**:
    - 確立「公款水位 (Cash on Hand)」與「會計淨值 (Net Balance)」分離原則。
    - 修正 `calculatePersonalCredit`: 納入 Expense 中的成員代墊 (Member Advance) 貢獻。
    - 修正 `calculatePoolBalanceByBaseCurrency`: 支援 `mixed` 支付，精確扣除混合支付中的公款部分。
    - 新增 `calculatePoolBalancesByOriginalCurrency`: 計算分幣別的物理庫存 (用於 S15 Smart Picker)。
  - **Model Update**: `RecordModel` 新增 `originalAmount`, `originalCurrencyCode`, `amountInBase` Getters；資料庫讀寫維持 `currency` 欄位以相容舊資料。
  - **UI Update**:
    - S13: 餘額改為顯示「公款總價值」，並支援點擊查看分幣別庫存明細 (Breakdown Dialog)。
    - S15: 實作 Smart Picker，支付選單優先顯示當前幣別餘額。
    - B0X: 修正 BottomSheet Safe Area (Edge-to-Edge) 與小數點輸入限制。
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
