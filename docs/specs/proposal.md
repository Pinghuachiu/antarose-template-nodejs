# OpenSpec Proposal: Node.js 全棧專案模板（極簡版）

**專案名稱**: antarose-template-nodejs
**提案日期**: 2025-10-24
**提案人**: CTO
**系統架構師**: Leo
**狀態**: 待審核

---

## 1. 提案摘要

建立一個**極簡的 Node.js 全棧專案模板**，前後端完全獨立，易於理解和擴展。

### 核心目標

1. **極度簡潔**: 最少必要功能，無過度設計
2. **前後端獨立**: 各自的 package.json，可分別使用
3. **開箱即用**: 展示基礎架構與最佳實踐
4. **易於擴展**: 清晰的文件指引後續擴展

---

## 2. 架構設計

### 專案結構（方案 B: 分離但同 Repo）

```
antarose-template-nodejs/
├── frontend/                    # Next.js 前端（獨立專案）
│   ├── app/
│   │   ├── page.tsx            # 首頁
│   │   ├── about/page.tsx      # 關於頁面
│   │   └── layout.tsx
│   ├── components/
│   │   └── ui/                 # shadcn/ui 組件
│   ├── lib/
│   │   └── utils.ts
│   ├── public/
│   ├── .eslintrc.js
│   ├── .prettierrc
│   ├── tailwind.config.ts
│   ├── next.config.js
│   ├── tsconfig.json
│   └── package.json            ← 前端獨立依賴
│
├── backend/                     # Express 後端（獨立專案）
│   ├── src/
│   │   ├── routes/
│   │   │   └── hello.ts        # 簡單範例路由
│   │   ├── middlewares/
│   │   │   ├── error-handler.ts
│   │   │   └── logger.ts
│   │   └── index.ts            # Express 入口
│   ├── .eslintrc.js
│   ├── tsconfig.json
│   └── package.json            ← 後端獨立依賴
│
├── docs/                        # 文件目錄
│   ├── specs/                   # OpenSpec 文件
│   ├── guides/                  # 開發指南
│   └── extensions/              # 擴展指南
│
├── .gitignore
└── README.md                    # 專案說明（如何分別啟動前後端）
```

**關鍵特點**:
- ✅ 前後端各自有 `package.json`
- ✅ 各自 `npm install` 或 `pnpm install`
- ✅ 沒有 `pnpm-workspace.yaml`（不使用 Monorepo）
- ✅ 沒有共享程式碼套件（`packages/`）

---

## 3. 技術棧選型

### 前端技術棧

| 技術 | 版本 | 用途 |
|------|------|------|
| **Next.js** | 15 (App Router) | React 框架 |
| **React** | 19 | UI 函式庫 |
| **TypeScript** | 5.x | 型別安全 |
| **Tailwind CSS** | 4 | CSS 框架 |
| **shadcn/ui** | Latest | UI 組件庫 |
| **Lucide React** | Latest | 圖示庫 |
| **ESLint + Prettier** | Latest | 程式碼品質 |

### 後端技術棧

| 技術 | 版本 | 用途 |
|------|------|------|
| **Node.js** | 20 LTS | 執行環境 |
| **Express** | 4.x | Web 框架 |
| **TypeScript** | 5.x | 型別安全 |
| **Zod** | Latest | 資料驗證（可選） |
| **ESLint + Prettier** | Latest | 程式碼品質 |

### ❌ 不包含（標記為擴展指南）

- 資料庫（PostgreSQL/Prisma）→ 擴展指南
- 認證系統（NextAuth.js）→ 擴展指南
- ORM/Database → 擴展指南
- Redis 快取 → 擴展指南
- 測試框架 → 擴展指南

---

## 4. 功能範圍

### 前端功能

#### ✅ 包含
1. **Next.js App Router 基礎**
   - Root Layout
   - 首頁（SSG）
   - About 頁面（SSG）
   - Error Boundary
   - 404 頁面

2. **Tailwind CSS + shadcn/ui**
   - 基礎組件（Button, Card, Input）
   - Tailwind 配置
   - Dark mode 配置（可選）

3. **開發工具**
   - TypeScript strict mode
   - ESLint + Prettier
   - 基本頁面範例

#### ❌ 不包含
- 登入/註冊頁面
- Dashboard
- 認證整合
- API 呼叫範例（暫不需要）

---

### 後端功能

#### ✅ 包含
1. **Express 基礎架構**
   - TypeScript 配置
   - 基本資料夾結構（routes, middlewares）
   - Health Check 端點（`/health`）
   - 簡單範例端點（`/api/hello`）

2. **中介層**
   - CORS
   - Body Parser
   - Error Handler
   - 簡單的 Logger

3. **開發工具**
   - TypeScript
   - ESLint + Prettier
   - nodemon（開發模式）

#### ❌ 不包含
- 資料庫連線（Prisma）
- 認證系統
- User CRUD API
- Redis

---

## 5. 實作時程

### Phase 1: 模板核心（唯一實作）

**預估時間**: 3-5 個工作天

#### Day 1-2: 前端基礎
- **Task 1**: Next.js + TypeScript 設定（0.5 天）
- **Task 2**: Tailwind + shadcn/ui 整合（1 天）
- **Task 3**: 基本頁面（首頁、About）（0.5 天）

#### Day 3-4: 後端基礎
- **Task 4**: Express + TypeScript 設定（0.5 天）
- **Task 5**: 基礎中介層 + 範例 API（0.5 天）
- **Task 6**: 錯誤處理（0.5 天）

#### Day 5: 整理與文件
- **Task 7**: 整合測試（前端可呼叫後端）（0.5 天）
- **Task 8**: README + 文件整理（0.5 天）

**總計**: 5 天（極簡版）

---

## 6. 啟動方式

### 分別啟動（各自獨立）

#### 啟動前端
```bash
cd frontend
npm install          # 或 pnpm install
npm run dev          # http://localhost:3000
```

#### 啟動後端
```bash
cd backend
npm install          # 或 pnpm install
npm run dev          # http://localhost:4000
```

**不需要 root `package.json`，不需要 workspace 配置！**

---

## 7. 驗收標準

### 前端驗收
- ✅ `cd frontend && npm run dev` 可啟動
- ✅ 可訪問 `/`, `/about`
- ✅ shadcn/ui 組件正常運作
- ✅ Tailwind CSS 正常
- ✅ TypeScript 無錯誤

### 後端驗收
- ✅ `cd backend && npm run dev` 可啟動
- ✅ `/health` 端點回傳 200 OK
- ✅ `/api/hello` 端點正常運作
- ✅ TypeScript 無錯誤
- ✅ 錯誤處理正常

### 整合驗收
- ✅ 前端可呼叫後端 API（CORS 正確設定）
- ✅ README 說明如何分別啟動
- ✅ 文件清晰

---

## 8. 任務分配

| 任務 | 負責人 | 時間 |
|------|--------|------|
| Task 1-3: 前端基礎 | Waylon + Lisa | 2 天 |
| Task 4-6: 後端基礎 | Costa + Chris | 1.5 天 |
| Task 7-8: 整合 + 文件 | Costa + Waylon | 1 天 |

**總計**: 3-4 位團隊成員，4.5 天

---

**簽核**:

- [ ] CTO 審核通過
- [ ] 確認方案 B（分離但同 Repo）

**版本**: 3.0.0 (極簡版 - 方案 B)
**最後更新**: 2025-10-24
