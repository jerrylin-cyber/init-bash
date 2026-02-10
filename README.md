# init-bash

跨平台 Shell 環境初始化腳本，用於統一 macOS 與 Linux 的終端機設定。

## 專案簡介（Project Overview）

此專案提供可重複安裝的 Shell 環境初始化流程，重點功能如下：

- 偵測作業系統與 Shell 類型，選擇對應 RC 檔案
- 產生並載入使用者設定檔 $HOME/.init-work.sh
- 提供常用 aliases 與實用函數
- 設定預設編輯器、語系、顏色、歷史紀錄與 PATH
- 互動式 Shell 啟動時顯示歡迎訊息與常用指令

## 系統結構（System Architecture）

```
init-bash/
├── init.sh                      # 安裝腳本（偵測系統與寫入 RC 檔）
├── init-work.sh                 # 設定檔範本（複製到 ~/.init-work.sh）
├── install.sh                   # 遠端安裝腳本（下載 init-work.sh 並寫入 RC）
├── check-bash.sh                # Bash 環境檢查工具（POSIX sh）
├── README.md                    # 說明文件
└── .github/
    ├── copilot-instructions.md  # AI 輔助開發指引
    └── instructions/
        └── copilot-readme.instructions.md  # README 生成指令
```

### 執行流程

1. `init.sh` 偵測作業系統與 Shell 類型
2. 複製 `init-work.sh` 到 $HOME/.init-work.sh
3. 將 `source "$HOME/.init-work.sh"` 寫入 RC 檔案
4. 重新載入 RC 檔案套用設定

## 安裝與啟動（Installation & Getting Started）

### 系統需求

- 作業系統：macOS 或 Linux
- Shell：bash、zsh、fish、ksh、tcsh/csh

### 檢查 Bash 環境

```bash
sh check-bash.sh
```

### 方法一：Git Clone

```bash
git clone https://github.com/jerrylin-cyber/init-bash.git
cd init-bash
bash init.sh
source ~/.zshrc
```

### 方法二：遠端安裝

```bash
curl -fsSL https://raw.githubusercontent.com/jerrylin-cyber/init-bash/refs/heads/main/install.sh | bash
source ~/.zshrc
```

### 環境變數

本專案沒有 `.env` 或 `.env.example`。

## 使用方法（Usage）

### 常用指令

```bash
# 重新安裝（本機）
bash init.sh

# 只下載設定檔並寫入 RC（遠端）
curl -fsSL https://raw.githubusercontent.com/jerrylin-cyber/init-bash/refs/heads/main/install.sh | bash

# 檢查 Bash 環境
sh check-bash.sh
```

### Aliases（節錄）

| 類型 | Alias | 對應指令 |
|------|-------|----------|
| 導航 | `cd..` / `s` | `cd ..` |
| 導航 | `p` | `cd -` |
| 檔案 | `cp` / `mv` / `rm` | `cp -i` / `mv -i` / `rm -i` |
| 目錄 | `md` / `rd` | `mkdir` / `rmdir` |
| 列表 | `ls` | macOS：`ls -F -G`；Linux：`ls -F --show-control-chars --color=auto` |
| 其他 | `df` / `du` / `grep` | `df -h` / `du -h` / `grep --color` |
| Git | `gexclude` | `git_exclude` |
| Git | `gskip` / `gunskip` | `git_skip_worktree` / `git_unskip_worktree` |

### 實用函數

```bash
# 建立目錄並進入
mkcd my-folder

# 萬用解壓縮
extract archive.tar.gz

# 備份檔案
backup important.txt

# 將檔案加入本地 exclude
gexclude .env.local

# 忽略/恢復追蹤檔案變更
gskip package-lock.json
gunskip package-lock.json
```

### 環境變數（節錄）

| 變數 | 值 | 說明 |
|------|-----|------|
| `EDITOR` / `VISUAL` | `nano` | 預設編輯器 |
| `LANG` / `LC_ALL` | `en_US.UTF-8` | 語言設定 |
| `HISTSIZE` | `10000` | 記憶體中的歷史筆數 |
| `HISTFILESIZE` | `20000` | 歷史檔案筆數 |
| `HISTCONTROL` | `ignoreboth:erasedups` | 忽略重複與空格開頭的指令 |
| `HISTTIMEFORMAT` | `%F %T ` | 歷史時間格式 |
| `CLICOLOR` | `1` | macOS 終端機顏色 |
| `LSCOLORS` / `LS_COLORS` | 見 [init-work.sh](init-work.sh) | 目錄顏色設定 |
| `umask` | `022` | 檔案權限遮罩 |

## 測試（Testing）

### 自動化測試

此專案未提供自動化測試腳本。

### 手動測試

```bash
# 逐行顯示 init.sh 的執行流程
bash -x init.sh

# 檢查 aliases
alias ll
alias rm

# 檢查環境變數
echo $EDITOR
echo $HISTSIZE
echo $LC_ALL

# 檢查函數
type mkcd
type extract
type gexclude

# 檢查產出的設定檔
cat ~/.init-work.sh
```

## 使用情境（Scenarios/Examples）

### 在新機器初始化 Shell 環境

```bash
git clone https://github.com/jerrylin-cyber/init-bash.git
cd init-bash
bash init.sh
source ~/.zshrc
```

### 只套用設定檔到現有環境

```bash
curl -fsSL https://raw.githubusercontent.com/jerrylin-cyber/init-bash/refs/heads/main/install.sh | bash
source ~/.zshrc
```

## 錯誤排除（Troubleshooting）

### 找不到 init-work.sh

```
錯誤：找不到 /path/to/init-work.sh
```

解法：確認 [init.sh](init.sh) 與 [init-work.sh](init-work.sh) 位於同一目錄。

### 不支援的作業系統

```
錯誤：不支援的作業系統 (Windows_NT)
```

解法：僅支援 macOS 與 Linux，Windows 請使用 WSL。

### 未知的 Shell

```
警告：未知的 shell (dash)
```

解法：手動將 `source "$HOME/.init-work.sh"` 加入對應 RC 檔案。

### 遠端安裝缺少 curl 或 wget

```
錯誤：需要 curl 或 wget
```

解法：安裝 curl 或 wget 後重新執行 [install.sh](install.sh)。

## 授權條款（License）

MIT License，詳見 [LICENSE](LICENSE)。
