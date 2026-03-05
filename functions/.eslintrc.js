module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
    "plugin:@typescript-eslint/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["tsconfig.json", "tsconfig.dev.json"],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
    "/generated/**/*", // Ignore generated files.
  ],
  plugins: [
    "@typescript-eslint",
    "import",
  ],
  rules: {
    // 1. 關閉一行不能超過 80 字的嚴格限制 (現代螢幕通常設為 120 或直接關閉)
    "max-len": "off",

    // 2. 關閉強制 JSDoc 格式 (TypeScript 已經有型別，不需要 JSDoc 再寫一次)
    "valid-jsdoc": "off",

    // 3. 允許使用 any 型別 (在處理 Firestore 不定資料時經常需要)
    "@typescript-eslint/no-explicit-any": "off",

    // 4. 允許使用 ! 驚嘆號來斷言非空值
    "@typescript-eslint/no-non-null-assertion": "off",

    // 5. 處理未使用變數：如果變數名稱開頭是底線 (例如 _ 或 _event) 就不報錯
    "@typescript-eslint/no-unused-vars": [
      "warn",
      {
        "argsIgnorePattern": "^_",
        "varsIgnorePattern": "^_",
        "caughtErrorsIgnorePattern": "^_",
      },
    ],

    // 關閉字串必須用雙引號的規定 (看你個人習慣，通常會關掉)
    "quotes": "off",

    // 關閉 ESLint 的 import 檢查，交給 TypeScript 負責就好
    "import/no-unresolved": "off",
  },
};
