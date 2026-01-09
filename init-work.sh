#!/usr/bin/env bash

# =============================================================================
# Shell 環境設定檔
# 支援系統：macOS / Linux
# 此檔案由 init.sh 複製到 ~/.init-work.sh 並自動載入
# =============================================================================

# 防止重複載入
[[ -n "$_INIT_WORK_LOADED" ]] && return 0
export _INIT_WORK_LOADED=1

# -----------------------------------------------------------------------------
# 偵測作業系統
# -----------------------------------------------------------------------------
case "$(uname -s)" in
    Darwin) OS_TYPE="macos" ;;
    Linux)  OS_TYPE="linux" ;;
    *)      OS_TYPE="unknown" ;;
esac

# -----------------------------------------------------------------------------
# 常用 Aliases
# -----------------------------------------------------------------------------

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
    alias ls='ls -F -G'
else
    alias ls='ls -F --show-control-chars --color=auto'
fi
alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lm='ls -l | more'
alias lsd='ls -d */'
alias d='ls'

# 其他工具
alias df='df -h'
alias du='du -h'
alias grep='grep --color'

# Linux 專用
if [[ "$OS_TYPE" == "linux" ]]; then
    alias kde='xinit /usr/bin/startkde'
    [[ -f /usr/share/mc/bin/mc-wrapper.sh ]] && alias mc='. /usr/share/mc/bin/mc-wrapper.sh'
fi

# -----------------------------------------------------------------------------
# 環境變數
# -----------------------------------------------------------------------------

# 預設編輯器
export EDITOR=nano
export VISUAL=nano

# 語言編碼
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# 歷史紀錄
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%F %T "

# bash 即時寫入歷史紀錄
[[ "$(basename "$SHELL")" == "bash" ]] && shopt -s histappend 2>/dev/null

# 顏色
export CLICOLOR=1
if [[ "$OS_TYPE" == "macos" ]]; then
    export LSCOLORS="GxFxCxDxBxegedabagaced"
else
    export LS_COLORS="di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43"
fi

# -----------------------------------------------------------------------------
# PATH 設定
# -----------------------------------------------------------------------------
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

if [[ "$OS_TYPE" == "macos" ]]; then
    [[ -d "/opt/homebrew/bin" ]] && export PATH="/opt/homebrew/bin:$PATH"
    [[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:$PATH"
fi

# -----------------------------------------------------------------------------
# 安全性
# -----------------------------------------------------------------------------
umask 022

# -----------------------------------------------------------------------------
# 實用函數
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# 歡迎訊息
# -----------------------------------------------------------------------------
show_welcome() {
    echo ""
    echo "========================================"
    echo "  為什麼程式設計師總是分不清萬聖節和聖誕節？"
    echo "  因為 Oct 31 = Dec 25"
    echo "  系統: $OS_TYPE | Shell: $(basename "$SHELL")"
    echo "========================================"
    echo ""
    echo "常用 Aliases："
    echo "  ll, la, l    - 列出檔案"
    echo "  s, p         - 上一層/前一個目錄"
    echo "  md, rd       - 建立/刪除目錄"
    echo "  cp, mv, rm   - 檔案操作（安全模式）"
    echo ""
    echo "實用函數："
    echo "  mkcd <dir>   - 建立目錄並進入"
    echo "  extract <file> - 萬用解壓縮"
    echo "  backup <file>  - 備份檔案（加時間戳記）"
    echo ""
    echo "輸入 'alias' 查看所有 aliases"
    echo "========================================"
    echo ""
}

# 只在互動式 shell 顯示歡迎訊息
[[ $- == *i* ]] && show_welcome
