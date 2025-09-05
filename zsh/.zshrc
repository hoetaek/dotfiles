#!/bin/zsh

# dotfiles 경로 설정
export DOTFILES="$HOME/dotfiles"

# Homebrew 환경 설정 (M1/M2 Mac 지원)
if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# 모듈들 순차 로드
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

# Homebrew zsh plugins 로드
if [[ -f $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -f $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# fzf 설정
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
fi

# 로컬 설정 (Git에 올리지 않는 머신별 설정)
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi

# 히스토리 설정
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# 디렉토리 이동 개선
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# 프롬프트 설정 (간단한 버전)
autoload -U colors && colors
setopt PROMPT_SUBST

# Git 브랜치 표시 함수
git_branch() {
    git branch 2>/dev/null | grep '^*' | sed 's/* //'
}

# 프롬프트
PS1='%{$fg[cyan]%}%c%{$reset_color%} %{$fg[yellow]%}$(git_branch)%{$reset_color%} $ '