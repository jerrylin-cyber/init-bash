# init-bash

跨平台 Shell 環境初始化腳本，統一 macOS 和 Linux 的終端機設定。

## 專案簡介

本專案提供 Shell 環境初始化工具，包含：

- 作業系統偵測（macOS / Linux）
- Shell 類型偵測（bash、zsh、fish、ksh、tcsh/csh）
- 常用指令 aliases 設定
- 預設編輯器設定（nano）
- 指令歷史紀錄最佳化
- PATH 路徑設定
- 語言編碼設定（UTF-8）
- 檔案權限遮罩設定（umask）
- 終端機顏色設定
- 實用 Shell 函數（mkcd、extract、backup）

## 系統結構

```
init-bash/
├── init.sh                      # 安裝腳本（執行一次）
├── init-work.sh                 # 設定檔範本（複製到 ~/.init-work.sh）
├── install.sh                   # 遠端一鍵安裝腳本
├── check-bash.sh                # Bash 環境檢查工具
├── README.md                    # 說明文件
└── .github/
    ├── copilot-instructions.md  # AI 輔助開發指引
    └── instructions/
        └── copilot-readme.instructions.md  # README 生成指令
```

### 架構說明

| 檔案 | 用途 |
|------|------|
| `init.sh` | 安裝腳本，偵測系統並複製設定檔 |
| `init-work.sh` | 實際設定內容，會被複製到 `~/.init-work.sh` |
| `install.sh` | 遠端安裝腳本，可透過 curl/wget 執行 |
| `check-bash.sh` | 檢查系統 Bash 環境（使用純 POSIX sh 撰寫） |

執行 `init.sh` 後：
1. 偵測作業系統（macOS / Linux）
2. 偵測 Shell 類型
3. 複製 `init-work.sh` → `~/.init-work.sh`
4. 在 RC 檔案中加入 `source ~/.init-work.sh`

## 安裝與啟動

### 系統需求

- 作業系統：macOS 或 Linux
- Shell：bash、zsh、fish、ksh、tcsh/csh

### 檢查 Bash 環境

安裝前可先檢查系統的 Bash 環境：

```bash
sh check-bash.sh
```

輸出範例：

```
========================================
  Bash 環境檢查
========================================

[✓] 找到 bash: /bin/bash
[i] 版本: GNU bash, version 3.2.57(1)-release (arm64-apple-darwin24)
[i] 主版本: 3.2
[!] 警告: Bash 版本較舊，建議升級到 4.0+

當前環境：
  SHELL=/bin/zsh
  目前執行的 shell: sh

Bash 路徑檢查：
  [✓] /bin/bash (3.2.57(1)-release)
  [ ] /usr/bin/bash (不存在)
  [ ] /usr/local/bin/bash (不存在)
  [ ] /opt/homebrew/bin/bash (不存在)

========================================
  檢查完成
========================================
```

### 方法一：Git Clone

```bash
git clone https://github.com/jerrywusa/init-bash.git
cd init-bash
bash init.sh
source ~/.zshrc  # 或對應的 RC 檔案
```

### 方法二：遠端安裝

```bash
curl -fsSL https://raw.githubusercontent.com/jerrywusa/init-bash/main/install.sh | bash
source ~/.zshrc  # 或對應的 RC 檔案
```

## 使用方法

### 更新設定

修改 `init-work.sh` 後，重新執行安裝：

```bash
cd init-bash
bash init.sh
source ~/.zshrc
```

### Aliases 列表

#### 導航

| Alias | 對應指令 | 說明 |
|-------|----------|------|
| `cd..` | `cd ..` | 上一層目錄 |
| `s` | `cd ..` | 上一層目錄 |
| `p` | `cd -` | 前一個目錄 |

#### 檔案操作（安全模式）

| Alias | 對應指令 | 說明 |
|-------|----------|------|
| `cp` | `cp -i` | 複製前確認 |
| `mv` | `mv -i` | 移動前確認 |
| `rm` | `rm -i` | 刪除前確認 |

#### 目錄操作

| Alias | 對應指令 | 說明 |
|-------|----------|------|
| `md` | `mkdir` | 建立目錄 |
| `rd` | `rmdir` | 刪除目錄 |

#### ls 系列

| Alias | 對應指令 | 說明 |
|-------|----------|------|
| `ls` | `ls -F --color` | 彩色顯示（Linux）/ `ls -F -G`（macOS） |
| `l` | `ls` | 列出檔案 |
| `la` | `ls -a` | 顯示隱藏檔 |
| `ll` | `ls -l` | 詳細列表 |
| `lm` | `ls -l \| more` | 分頁顯示 |
| `lsd` | `ls -d */` | 只列目錄 |
| `d` | `ls` | 列出檔案 |

#### 其他工具

| Alias | 對應指令 | 說明 |
|-------|----------|------|
| `df` | `df -h` | 磁碟空間（人類可讀格式） |
| `du` | `du -h` | 目錄大小（人類可讀格式） |
| `grep` | `grep --color` | 搜尋結果標色 |

### 實用函數

#### mkcd

建立目錄並進入：

```bash
mkcd my-new-folder
```

#### extract

萬用解壓縮，支援格式：`.tar.gz`、`.tar.bz2`、`.tar.xz`、`.tar`、`.gz`、`.bz2`、`.zip`、`.rar`、`.7z`、`.Z`

```bash
extract archive.tar.gz
```

#### backup

備份檔案，自動加上時間戳記：

```bash
backup important.txt
# 產生 important.txt.bak.20260109_143052
```

### 環境變數

| 變數 | 值 | 說明 |
|------|-----|------|
| `EDITOR` | `nano` | 預設編輯器 |
| `VISUAL` | `nano` | 視覺編輯器 |
| `HISTSIZE` | `10000` | 記憶體中的歷史筆數 |
| `HISTFILESIZE` | `20000` | 歷史檔案筆數 |
| `HISTCONTROL` | `ignoreboth:erasedups` | 忽略重複與空格開頭的指令 |
| `LANG` | `en_US.UTF-8` | 語言設定 |
| `umask` | `022` | 檔案權限遮罩 |

## 測試

### 測試安裝腳本

```bash
bash -x init.sh
```

此指令會顯示每行執行的指令。

### 驗證設定

安裝後可使用以下指令驗證：

```bash
# 檢查 aliases
alias ll
alias rm

# 檢查環境變數
echo $EDITOR
echo $HISTSIZE

# 檢查函數
type mkcd
type extract

# 檢查設定檔
cat ~/.init-work.sh
```

## 支援的 Shell

| Shell | 配置檔 |
|-------|--------|
| bash | `~/.bashrc`（Linux）/ `~/.bash_profile`（macOS） |
| zsh | `~/.zshrc` |
| fish | `~/.config/fish/config.fish` |
| ksh | `~/.kshrc` |
| tcsh/csh | `~/.tcshrc` 或 `~/.cshrc` |

## 錯誤排除

### 找不到 init-work.sh

```
錯誤：找不到 /path/to/init-work.sh
```

解法：確保 `init.sh` 和 `init-work.sh` 在同一目錄下。

### 不支援的作業系統

```
錯誤：不支援的作業系統 (Windows_NT)
```

解法：本腳本僅支援 macOS 和 Linux，Windows 使用者請改用 WSL。

### 未知的 Shell

```
警告：未知的 shell (dash)
```

解法：手動將 `source ~/.init-work.sh` 加入對應的 shell 配置檔。

## 授權條款

MIT License
