# Copilot Instructions for init-bash

## 專案概述

這是一個跨平台的 Shell 環境初始化腳本，用於統一 macOS 和 Linux 的終端機設定。

## 架構模式

### 模組化函數設計
腳本採用獨立函數模式，每個設定功能封裝在獨立函數中：
```bash
detect_os()        # 偵測作業系統
detect_shell()     # 偵測 Shell 類型
setup_aliases()    # 設定 aliases
setup_*()          # 其他設定函數
```

### 執行順序很重要
`main()` 函數中的呼叫順序有依賴關係：
1. `detect_os` 必須最先執行（設定 `$OS_TYPE`）
2. `detect_shell` 必須在 `detect_os` 之後（使用 `$OS_TYPE` 判斷 RC 文件）
3. 其他 `setup_*` 函數依賴 `$OS_TYPE` 和 `$CURRENT_SHELL`

### 全域變數
- `OS_TYPE`: `"macos"` 或 `"linux"`
- `CURRENT_SHELL`: `"bash"`, `"zsh"`, `"fish"` 等
- `RC_FILE`: 對應的配置文件路徑
- `SCRIPT_PATH`: 腳本的絕對路徑

## 編碼慣例

### 跨平台相容性
- macOS 和 Linux 的指令參數不同時，使用 `if [[ "$OS_TYPE" == "macos" ]]` 分支
- 例如：`ls -G` (macOS) vs `ls --color=auto` (Linux)

### 安全檢查模式
- 檔案/目錄存在檢查：`[[ -f "$FILE" ]]`, `[[ -d "$DIR" ]]`
- 變數非空檢查：`[[ -n "$VAR" ]]`, `[[ -z "$VAR" ]]`
- PATH 加入前先檢查目錄存在

### 使用者回饋
- 每個 `setup_*` 函數結尾用 `echo` 輸出完成訊息
- 錯誤訊息以「錯誤：」或「警告：」開頭

## 新增功能指南

新增設定功能時：
1. 建立獨立的 `setup_功能名稱()` 函數
2. 在函數內處理 macOS/Linux 差異
3. 函數結尾輸出完成訊息
4. 在 `main()` 中適當位置呼叫
5. 更新 README.md 文件

## 測試方式

```bash
# 測試執行（不會修改 RC 文件）
bash -x init.sh

# 正式執行
source init.sh
```
