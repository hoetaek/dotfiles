#!/bin/zsh

# dotfiles 경로 설정
export DOTFILES="$HOME/dotfiles"

# Homebrew 환경 설정 (M1/M2 Mac 지원)
if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ============================================
# Oh My Zsh 설정
# ============================================
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="agnoster"

# Set list of plugins to load
plugins=(git zsh-autosuggestions web-search sudo copybuffer
         dirhistory history poetry)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================
# Dotfiles 모듈들 로드
# ============================================
if [[ -f "$DOTFILES/zsh/exports.zsh" ]]; then
    source "$DOTFILES/zsh/exports.zsh"
fi

if [[ -f "$DOTFILES/zsh/aliases.zsh" ]]; then
    source "$DOTFILES/zsh/aliases.zsh"
fi

if [[ -f "$DOTFILES/zsh/functions.zsh" ]]; then
    source "$DOTFILES/zsh/functions.zsh"
fi

if [[ -f "$DOTFILES/zsh/laravel.zsh" ]]; then
    source "$DOTFILES/zsh/laravel.zsh"
fi

if [[ -f "$DOTFILES/zsh/github.zsh" ]]; then
    source "$DOTFILES/zsh/github.zsh"
fi

# fzf 설정
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
fi

# fzf 사용자 정의 키바인딩
export FZF_DEFAULT_OPTS="
  --bind 'j:down,k:up,ctrl-j:preview-down,ctrl-k:preview-up'
  --bind 'ctrl-d:half-page-down,ctrl-u:half-page-up'
  --bind 'g:first,G:last'
  --bind 'ctrl-f:page-down,ctrl-b:page-up'
"

# autojump 설정
if [[ $(uname -m) == 'arm64' ]]; then
    [ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
else
    [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
fi

# 로컬 설정 (Git에 올리지 않는 머신별 설정)
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# ============================================
# 추가 히스토리 설정 (Oh My Zsh 기본 설정 보완)
# ============================================
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS