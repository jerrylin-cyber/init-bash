# init-bash

Shell 環境初始化腳本，支援 macOS 和 Linux 系統。

## 功能特色

- 🖥️ **作業系統偵測** - 自動識別 macOS / Linux，不支援的系統會提示退出
- 🐚 **Shell 偵測** - 支援 bash、zsh、fish、ksh、tcsh/csh
- 📝 **常用 Aliases** - 預設常見的指令縮寫
- ✏️ **預設編輯器** - 設定 nano 為終端機編輯器
- 📜 **歷史紀錄** - 優化指令歷史設定
- 📂 **PATH 設定** - 自動加入常用路徑
- 🌐 **語言編碼** - 設定 UTF-8 編碼
- 🔒 **安全性** - 設定適當的 umask
- 🎨 **終端機顏色** - 啟用 ls 顏色顯示
- 🛠️ **實用函數** - 提供常用的 shell 函數
- ⚙️ **自動配置** - 自動加入對應的 RC 文件並重新載入

## 快速開始

```bash
# 下載
git clone https://github.com/jerrywusa/init-bash.git
cd init-bash

# 執行（首次使用）
source init.sh
```

執行後會自動：
1. 偵測你的作業系統和 Shell 類型
2. 設定所有 aliases 和環境變數
3. 將設定加入對應的配置文件（`~/.bashrc`、`~/.zshrc` 等）
4. 重新載入配置，立即生效

## 專案結構

```
init-bash/
├── init.sh          # 主要初始化腳本
├── README.md        # 說明文件
└── .github/
    └── copilot-instructions.md  # AI 輔助開發指引
```

## Aliases 列表

### 導航
| Alias | 指令 | 說明 |
|-------|------|------|
| `cd..` | `cd ..` | 上一層目錄 |
| `s` | `cd ..` | 上一層目錄 |
| `p` | `cd -` | 前一個目錄 |

### 檔案操作（安全模式）
| Alias | 指令 | 說明 |
|-------|------|------|
| `cp` | `cp -i` | 複製前確認 |
| `mv` | `mv -i` | 移動前確認 |
| `rm` | `rm -i` | 刪除前確認 |

### 目錄操作
| Alias | 指令 | 說明 |
|-------|------|------|
| `md` | `mkdir` | 建立目錄 |
| `rd` | `rmdir` | 刪除目錄 |

### ls 系列
| Alias | 指令 | 說明 |
|-------|------|------|
| `ls` | `ls -F --color` | 彩色顯示 |
| `l` | `ls` | 列出檔案 |
| `la` | `ls -a` | 顯示隱藏檔 |
| `ll` | `ls -l` | 詳細列表 |
| `lm` | `ls -l \| more` | 分頁顯示 |
| `lsd` | `ls -d */` | 只列目錄 |
| `d` | `ls` | 列出檔案 |

### 其他工具
| Alias | 指令 | 說明 |
|-------|------|------|
| `df` | `df -h` | 人類可讀的磁碟空間 |
| `du` | `du -h` | 人類可讀的目錄大小 |
| `grep` | `grep --color` | 彩色搜尋結果 |

## 實用函數

### `mkcd <directory>`
建立目錄並進入：
```bash
mkcd my-new-folder
```

### `extract <file>`
萬用解壓縮，支援格式：
- `.tar.gz`, `.tar.bz2`, `.tar.xz`, `.tar`
- `.gz`, `.bz2`, `.zip`, `.rar`, `.7z`, `.Z`

```bash
extract archive.tar.gz
```

### `backup <file>`
備份檔案（加上時間戳記）：
```bash
backup important.txt
# 產生 important.txt.bak.20260109_143052
```

## 環境設定

| 設定 | 值 | 說明 |
|------|-----|------|
| `EDITOR` | `nano` | 預設編輯器 |
| `VISUAL` | `nano` | 視覺編輯器 |
| `HISTSIZE` | `10000` | 記憶體中的歷史筆數 |
| `HISTFILESIZE` | `20000` | 歷史檔案筆數 |
| `HISTCONTROL` | `ignoreboth:erasedups` | 忽略重複與空格開頭 |
| `LANG` | `en_US.UTF-8` | 語言設定 |
| `umask` | `022` | 檔案權限遮罩 |

## 支援的 Shell

| Shell | 配置文件 |
|-------|---------|
| bash | `~/.bashrc` (Linux) / `~/.bash_profile` (macOS) |
| zsh | `~/.zshrc` |
| fish | `~/.config/fish/config.fish` |
| ksh | `~/.kshrc` |
| tcsh/csh | `~/.tcshrc` 或 `~/.cshrc` |

## 授權

MIT License