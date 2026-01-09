#!/usr/bin/env bash

# =============================================================================
# Shell 環境初始化安裝腳本
# 支援系統：macOS / Linux
# 
# 此腳本會：
# 1. 偵測作業系統和 Shell 類型
# 2. 將 init-work.sh 複製到 ~/.init-work.sh
# 3. 在 RC 檔案中加入 source 命令
# =============================================================================

set -e

echo "========================================"
echo "  Shell 環境初始化安裝"
echo "========================================"
echo ""

# -----------------------------------------------------------------------------
# 取得腳本所在目錄
# -----------------------------------------------------------------------------
get_script_dir() {
    local source="${BASH_SOURCE[0]:-$0}"
    while [[ -L "$source" ]]; do
        local dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ "$source" != /* ]] && source="$dir/$source"
    done
    cd -P "$(dirname "$source")" && pwd
}

SCRIPT_DIR="$(get_script_dir)"
WORK_SCRIPT="$SCRIPT_DIR/init-work.sh"

# 檢查 init-work.sh 是否存在
if [[ ! -f "$WORK_SCRIPT" ]]; then
    echo "錯誤：找不到 $WORK_SCRIPT"
    exit 1
fi

# -----------------------------------------------------------------------------
# 偵測作業系統
# -----------------------------------------------------------------------------
case "$(uname -s)" in
    Darwin)
        echo "偵測到 macOS 系統"
        OS_TYPE="macos"
        ;;
    Linux)
        echo "偵測到 Linux 系統"
        OS_TYPE="linux"
        ;;
    *)
        echo "錯誤：不支援的作業系統 ($(uname -s))"
        exit 1
        ;;
esac

# -----------------------------------------------------------------------------
# 偵測 Shell 類型並決定 RC 檔案
# -----------------------------------------------------------------------------
CURRENT_SHELL="$(basename "$SHELL")"

case "$CURRENT_SHELL" in
    bash)
        if [[ "$OS_TYPE" == "macos" ]]; then
            RC_FILE="$HOME/.bash_profile"
            [[ ! -f "$RC_FILE" ]] && RC_FILE="$HOME/.bashrc"
        else
            RC_FILE="$HOME/.bashrc"
        fi
        echo "偵測到 Bash shell"
        ;;
    zsh)
        RC_FILE="$HOME/.zshrc"
        echo "偵測到 Zsh shell"
        ;;
    fish)
        RC_FILE="$HOME/.config/fish/config.fish"
        echo "偵測到 Fish shell"
        ;;
    ksh)
        RC_FILE="$HOME/.kshrc"
        echo "偵測到 Korn shell"
        ;;
    tcsh|csh)
        RC_FILE="$HOME/.tcshrc"
        [[ ! -f "$RC_FILE" ]] && RC_FILE="$HOME/.cshrc"
        echo "偵測到 C shell"
        ;;
    *)
        echo "警告：未知的 shell ($CURRENT_SHELL)"
        RC_FILE="$HOME/.profile"
        ;;
esac

# -----------------------------------------------------------------------------
# 複製 init-work.sh 到家目錄
# -----------------------------------------------------------------------------
DEST_FILE="$HOME/.init-work.sh"

if [[ -f "$DEST_FILE" ]]; then
    echo "更新 $DEST_FILE ..."
else
    echo "建立 $DEST_FILE ..."
fi

cp "$WORK_SCRIPT" "$DEST_FILE"
echo "已複製設定檔到 $DEST_FILE"

# -----------------------------------------------------------------------------
# 設定 RC 檔案
# -----------------------------------------------------------------------------
SOURCE_LINE="source \"$DEST_FILE\""

# 確保 RC 檔案存在
[[ ! -f "$RC_FILE" ]] && touch "$RC_FILE"

# 檢查是否已經設定過
if grep -qF ".init-work.sh" "$RC_FILE" 2>/dev/null; then
    echo "配置已存在於 $RC_FILE，無需重複加入"
else
    # 移除舊的設定（如果有）
    if grep -qF ".init.sh" "$RC_FILE" 2>/dev/null; then
        cp "$RC_FILE" "$RC_FILE.bak"
        grep -v ".init.sh" "$RC_FILE.bak" | grep -v "Shell 環境初始化腳本" > "$RC_FILE"
        echo "已移除舊的設定"
    fi
    
    # 加入新設定
    echo "" >> "$RC_FILE"
    echo "# Shell 環境初始化腳本" >> "$RC_FILE"
    echo "$SOURCE_LINE" >> "$RC_FILE"
    echo "已將設定加入 $RC_FILE"
fi

echo ""
echo "========================================"
echo "  安裝完成！"
echo "========================================"
echo ""
echo "請執行以下指令來套用設定："
echo "  source $RC_FILE"
echo ""
echo "或者重新開啟終端機"
