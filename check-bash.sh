#!/bin/sh

# =============================================================================
# 檢查系統是否支援 bash
# 使用純 POSIX sh 語法，確保任何系統都能執行
# =============================================================================

echo "========================================"
echo "  Bash 環境檢查"
echo "========================================"
echo ""

# 檢查 bash 是否存在
BASH_PATH=""

if command -v bash >/dev/null 2>&1; then
    BASH_PATH="$(command -v bash)"
    echo "[✓] 找到 bash: $BASH_PATH"
else
    echo "[✗] 系統未安裝 bash"
    echo ""
    echo "請先安裝 bash："
    echo "  macOS:  brew install bash"
    echo "  Debian: sudo apt install bash"
    echo "  RHEL:   sudo yum install bash"
    exit 1
fi

# 檢查 bash 版本
BASH_VERSION_OUTPUT="$("$BASH_PATH" --version 2>/dev/null | head -n 1)"
echo "[i] 版本: $BASH_VERSION_OUTPUT"

# 取得版本號
BASH_MAJOR="$("$BASH_PATH" -c 'echo ${BASH_VERSINFO[0]}' 2>/dev/null)"
BASH_MINOR="$("$BASH_PATH" -c 'echo ${BASH_VERSINFO[1]}' 2>/dev/null)"

if [ -n "$BASH_MAJOR" ]; then
    echo "[i] 主版本: $BASH_MAJOR.$BASH_MINOR"
    
    # 檢查版本是否足夠（建議 4.0+）
    if [ "$BASH_MAJOR" -ge 4 ]; then
        echo "[✓] Bash 版本符合需求 (>= 4.0)"
    else
        echo "[!] 警告: Bash 版本較舊，建議升級到 4.0+"
    fi
fi

# 檢查當前 shell
echo ""
echo "當前環境："
echo "  SHELL=$SHELL"
echo "  目前執行的 shell: $(ps -p $$ -o comm=)"

# 檢查常見路徑
echo ""
echo "Bash 路徑檢查："
for path in /bin/bash /usr/bin/bash /usr/local/bin/bash /opt/homebrew/bin/bash; do
    if [ -x "$path" ]; then
        version="$("$path" --version 2>/dev/null | head -n 1 | sed 's/.*version //' | cut -d' ' -f1)"
        echo "  [✓] $path ($version)"
    else
        echo "  [ ] $path (不存在)"
    fi
done

echo ""
echo "========================================"
echo "  檢查完成"
echo "========================================"

# -----------------------------------------------------------------------------
# 建議與參考指令
# -----------------------------------------------------------------------------
echo ""
echo "========================================"
echo "  建議與參考指令"
echo "========================================"

# 根據檢查結果提供建議
if [ -z "$BASH_PATH" ]; then
    echo ""
    echo "[安裝 Bash]"
    echo "  macOS:       brew install bash"
    echo "  Debian/Ubuntu: sudo apt update && sudo apt install bash"
    echo "  RHEL/CentOS:   sudo yum install bash"
    echo "  Fedora:        sudo dnf install bash"
    echo "  Alpine:        apk add bash"
    echo "  Arch:          sudo pacman -S bash"
elif [ -n "$BASH_MAJOR" ] && [ "$BASH_MAJOR" -lt 4 ]; then
    echo ""
    printf "[升級 Bash（目前版本 %s.%s，建議 4.0+）]\n" "$BASH_MAJOR" "$BASH_MINOR"
    echo ""
    echo "  macOS（內建 3.2 因授權限制）："
    echo "    brew install bash"
    echo "    # 安裝後路徑: /opt/homebrew/bin/bash (Apple Silicon)"
    echo "    #           /usr/local/bin/bash (Intel)"
    echo ""
    echo "  Debian/Ubuntu："
    echo "    sudo apt update && sudo apt install --only-upgrade bash"
    echo ""
    echo "  RHEL/CentOS："
    echo "    sudo yum update bash"
    echo ""
    echo "  Fedora："
    echo "    sudo dnf upgrade bash"
fi

# 路徑相關建議
echo ""
echo "[檢查 Bash 路徑]"
echo "  查看 bash 位置:    which bash"
echo "  查看所有 bash:     type -a bash"
echo "  查看 PATH 變數:    echo \$PATH"
echo "  搜尋 bash 執行檔:  find /usr -name 'bash' 2>/dev/null"

# 設定新版 bash 為預設
echo ""
echo "[設定新版 Bash 為預設 Shell]"
echo "  1. 將新版 bash 加入允許清單："
echo "     sudo sh -c 'echo /opt/homebrew/bin/bash >> /etc/shells'"
echo ""
echo "  2. 變更預設 shell："
echo "     chsh -s /opt/homebrew/bin/bash"
echo ""
echo "  3. 驗證："
echo "     echo \$BASH_VERSION"

# init-bash 相關
echo ""
echo "[執行 init-bash 安裝]"
echo "  bash init.sh          # 使用系統 bash"
echo "  /opt/homebrew/bin/bash init.sh  # 指定新版 bash"
