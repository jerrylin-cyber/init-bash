#!/bin/bash
#
# init-bash 快速安裝腳本
# 使用方式：
#   curl -fsSL https://raw.githubusercontent.com/[username]/init-bash/main/install.sh | bash
#   或
#   wget -qO- https://raw.githubusercontent.com/[username]/init-bash/main/install.sh | bash
#

set -e

REPO_URL="https://raw.githubusercontent.com/jerrylin-cyber/init-bash/refs/heads/main/init.sh"
DEST_FILE="$HOME/.init.sh"

echo "========================================"
echo "  init-bash 安裝程式"
echo "========================================"
echo

# 下載 init.sh
echo "正在下載 init.sh..."
if command -v curl &> /dev/null; then
    curl -fsSL "$REPO_URL" -o "$DEST_FILE"
elif command -v wget &> /dev/null; then
    wget -qO "$DEST_FILE" "$REPO_URL"
else
    echo "錯誤：需要 curl 或 wget"
    exit 1
fi

echo "已下載至 $DEST_FILE"

# 偵測 Shell
detect_rc_file() {
    local shell_name
    shell_name=$(basename "$SHELL")
    
    case "$shell_name" in
        bash)
            if [[ "$(uname -s)" == "Darwin" ]]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        zsh)
            echo "$HOME/.zshrc"
            ;;
        fish)
            echo "$HOME/.config/fish/config.fish"
            ;;
        ksh)
            echo "$HOME/.kshrc"
            ;;
        tcsh|csh)
            echo "$HOME/.tcshrc"
            ;;
        *)
            echo "$HOME/.profile"
            ;;
    esac
}

RC_FILE=$(detect_rc_file)
SOURCE_LINE="source \"$DEST_FILE\""

# 檢查是否已經設定
if [[ -f "$RC_FILE" ]] && grep -qF "$DEST_FILE" "$RC_FILE"; then
    echo "已經在 $RC_FILE 中設定過了"
else
    echo "" >> "$RC_FILE"
    echo "# Shell 環境初始化腳本" >> "$RC_FILE"
    echo "$SOURCE_LINE" >> "$RC_FILE"
    echo "已將設定加入 $RC_FILE"
fi

echo
echo "========================================"
echo "  安裝完成！"
echo "========================================"
echo
echo "請執行以下指令來套用設定："
echo "  source $RC_FILE"
echo
echo "或者重新開啟終端機"
