# ironsplit

## IronSplit 開發指南

### 環境執行與打包

- 測試環境執行：`flutter run --flavor dev -t lib/main.dart`
- 測試環境 iOS 打包：`flutter build ipa --flavor dev -t lib/main.dart`

### 工具指令

- 更新語系檔 (Slang)：`dart run slang`
- 更新 App Icon：`sh update_flavor.sh dev` (或執行 flutter_launcher_icons 指令)
