#!/bin/bash

# =============================================================================
# Shell 環境初始化腳本
# 支援系統：macOS / Linux
# =============================================================================

# -----------------------------------------------------------------------------
# 1. 偵測作業系統
# -----------------------------------------------------------------------------
detect_os() {
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
            echo "此腳本僅支援 macOS 和 Linux 系統"
            exit 1
            ;;
    esac
}

# -----------------------------------------------------------------------------
# 2. 偵測 Shell 類型
# -----------------------------------------------------------------------------
detect_shell() {
    # 取得腳本的絕對路徑
    SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    SOURCE_LINE="source \"$SCRIPT_PATH\""
    
    # 偵測當前使用的 shell
    CURRENT_SHELL="$(basename "$SHELL")"
    
    case "$CURRENT_SHELL" in
        bash)
            # macOS 優先使用 .bash_profile，Linux 優先使用 .bashrc
            if [[ "$OS_TYPE" == "macos" ]]; then
                if [[ -f "$HOME/.bash_profile" ]]; then
                    RC_FILE="$HOME/.bash_profile"
                else
                    RC_FILE="$HOME/.bashrc"
                fi
            else
                RC_FILE="$HOME/.bashrc"
            fi
            echo "偵測到使用 Bash shell"
            ;;
        zsh)
            RC_FILE="$HOME/.zshrc"
            echo "偵測到使用 Zsh shell"
            ;;
        fish)
            RC_FILE="$HOME/.config/fish/config.fish"
            # fish 的 source 語法不同
            SOURCE_LINE="source \"$SCRIPT_PATH\""
            echo "偵測到使用 Fish shell"
            echo "注意：部分 alias 語法可能與 Fish 不相容"
            ;;
        ksh)
            RC_FILE="$HOME/.kshrc"
            echo "偵測到使用 Korn shell"
            ;;
        tcsh|csh)
            RC_FILE="$HOME/.tcshrc"
            if [[ ! -f "$RC_FILE" ]]; then
                RC_FILE="$HOME/.cshrc"
            fi
            echo "偵測到使用 C shell"
            echo "注意：部分語法可能與 C shell 不相容"
            ;;
        *)
            echo "警告：未知的 shell ($CURRENT_SHELL)，跳過自動配置"
            RC_FILE=""
            ;;
    esac
}

# -----------------------------------------------------------------------------
# 3. 設定常用 aliases
# -----------------------------------------------------------------------------
setup_aliases() {
    # 導航相關
    alias cd..='cd ..'
    alias s='cd ..'
    alias p='cd -'

    # 檔案操作（加上安全確認）
    alias cp='cp -i'
    alias mv='mv -i'
    alias rm='rm -i'

    # 目錄操作
    alias md='mkdir'
    alias rd='rmdir'

    # ls 相關
    if [[ "$OS_TYPE" == "macos" ]]; then
        # macOS 使用不同的 ls 參數
        alias ls='ls -F -G'
        alias l='ls'
        alias la='ls -a'
        alias ll='ls -l'
        alias lm='ls -l | more'
        alias lsd='ls -d */'
        alias d='ls'
    else
        # Linux 版本
        alias ls='ls -F --show-control-chars --color=auto'
        alias l='ls'
        alias la='ls -a'
        alias ll='ls -l'
        alias lm='ls -l | more'
        alias lsd='ls -d */'
        alias d='ls'
    fi

    # 其他工具
    alias df='df -h'
    alias du='du -h'
    alias grep='grep --color'

    # KDE 相關（僅 Linux）
    if [[ "$OS_TYPE" == "linux" ]]; then
        alias kde='xinit /usr/bin/startkde'
        # mc wrapper（如果存在）
        if [[ -f /usr/share/mc/bin/mc-wrapper.sh ]]; then
            alias mc='. /usr/share/mc/bin/mc-wrapper.sh'
        fi
    fi

    echo "已設定常用 aliases"
}

# -----------------------------------------------------------------------------
# 4. 設定預設編輯器為 nano
# -----------------------------------------------------------------------------
setup_editor() {
    export EDITOR=nano
    export VISUAL=nano
    echo "已設定預設編輯器為 nano"
}

# -----------------------------------------------------------------------------
# 5. 設定歷史紀錄
# -----------------------------------------------------------------------------
setup_history() {
    # 歷史紀錄大小
    export HISTSIZE=10000
    export HISTFILESIZE=20000
    
    # 忽略重複指令和以空格開頭的指令
    export HISTCONTROL=ignoreboth:erasedups
    
    # 加入時間戳記
    export HISTTIMEFORMAT="%F %T "
    
    # bash: 即時寫入歷史紀錄
    if [[ "$CURRENT_SHELL" == "bash" ]]; then
        shopt -s histappend
    fi
    
    echo "已設定歷史紀錄"
}

# -----------------------------------------------------------------------------
# 6. 設定 PATH
# -----------------------------------------------------------------------------
setup_path() {
    # 加入常用的個人執行檔路徑
    [[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
    
    # macOS: Homebrew 路徑
    if [[ "$OS_TYPE" == "macos" ]]; then
        [[ -d "/opt/homebrew/bin" ]] && export PATH="/opt/homebrew/bin:$PATH"
        [[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:$PATH"
    fi
    
    echo "已設定 PATH"
}

# -----------------------------------------------------------------------------
# 7. 設定語言與編碼
# -----------------------------------------------------------------------------
setup_locale() {
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    echo "已設定語言編碼為 UTF-8"
}

# -----------------------------------------------------------------------------
# 8. 設定安全性 (umask)
# -----------------------------------------------------------------------------
setup_security() {
    # 022: 檔案預設 644, 目錄預設 755
    umask 022
    echo "已設定 umask 為 022"
}

# -----------------------------------------------------------------------------
# 9. 設定顏色
# -----------------------------------------------------------------------------
setup_colors() {
    # 啟用顏色支援
    export CLICOLOR=1
    
    if [[ "$OS_TYPE" == "macos" ]]; then
        export LSCOLORS="GxFxCxDxBxegedabagaced"
    else
        export LS_COLORS="di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43"
    fi
    
    echo "已設定終端機顏色"
}

# -----------------------------------------------------------------------------
# 10. 設定實用函數
# -----------------------------------------------------------------------------
setup_functions() {
    # mkcd: 建立目錄並進入
    mkcd() {
        mkdir -p "$1" && cd "$1"
    }
    
    # extract: 萬用解壓縮
    extract() {
        if [[ -f "$1" ]]; then
            case "$1" in
                *.tar.bz2)   tar xjf "$1"     ;;
                *.tar.gz)    tar xzf "$1"     ;;
                *.tar.xz)    tar xJf "$1"     ;;
                *.bz2)       bunzip2 "$1"     ;;
                *.rar)       unrar x "$1"     ;;
                *.gz)        gunzip "$1"      ;;
                *.tar)       tar xf "$1"      ;;
                *.tbz2)      tar xjf "$1"     ;;
                *.tgz)       tar xzf "$1"     ;;
                *.zip)       unzip "$1"       ;;
                *.Z)         uncompress "$1"  ;;
                *.7z)        7z x "$1"        ;;
                *)           echo "無法解壓縮 '$1'" ;;
            esac
        else
            echo "'$1' 不是有效的檔案"
        fi
    }
    
    # backup: 備份檔案
    backup() {
        cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
    }
    
    echo "已設定實用函數 (mkcd, extract, backup)"
}

# -----------------------------------------------------------------------------
# 11. 加入配置文件並重新載入
# -----------------------------------------------------------------------------
setup_shell_config() {
    # 如果沒有偵測到有效的 RC 文件，跳過
    if [[ -z "$RC_FILE" ]]; then
        return 1
    fi
    
    # 檢查配置文件是否存在，不存在則建立
    if [[ ! -f "$RC_FILE" ]]; then
        touch "$RC_FILE"
        echo "已建立 $RC_FILE"
    fi
    
    # 檢查是否已經加入過 source 命令
    if grep -qF "$SCRIPT_PATH" "$RC_FILE" 2>/dev/null; then
        echo "配置已存在於 $RC_FILE，無需重複加入"
    else
        # 加入 source 命令
        echo "" >> "$RC_FILE"
        echo "# Shell 環境初始化腳本" >> "$RC_FILE"
        echo "$SOURCE_LINE" >> "$RC_FILE"
        echo "已將設定加入 $RC_FILE"
    fi
    
    # 重新讀取配置文件
    echo "正在重新載入 $RC_FILE ..."
    source "$RC_FILE"
    echo "配置已重新載入"
}

# -----------------------------------------------------------------------------
# 主程式
# -----------------------------------------------------------------------------
main() {
    echo "========================================"
    echo "  Shell 環境初始化腳本"
    echo "========================================"
    echo ""

    # 執行各項設定
    detect_os
    detect_shell
    setup_aliases
    setup_editor
    setup_history
    setup_path
    setup_locale
    setup_security
    setup_colors
    setup_functions
    setup_shell_config

    echo ""
    echo "========================================"
    echo "  初始化完成！"
    echo "========================================"
}

# 執行主程式
main
