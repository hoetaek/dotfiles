# ============================================================
# BASIC ALIASES
# ============================================================

# 기본 명령어 개선
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# 파일 작업
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

# 네트워킹
alias ping='ping -c 5'
alias myip='curl ipinfo.io/ip'

# ============================================================
# GIT ALIASES
# ============================================================
alias g='git'
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gd='git diff'
alias gds='git diff --staged'

# ============================================================
# GITHUB CLI ALIASES
# ============================================================
alias ghlist="PAGER='' gh issue list -a hoetaek --json number,title -q '.[] | \"\(.number) \(.title)\"'"
alias ghprlist='GH_PAGER= gh pr list --json title,headRefName,baseRefName,number -q ".[] | \"┌─ PR #\(.number): \(.title)\n├─ From: \(.headRefName)\n└─ To: \(.baseRefName)\n\""'
alias doissues="ghlist | fzf -m --reverse | awk '{print \$1}' | xargs doissue"

# ============================================================
# LARAVEL ALIASES
# ============================================================
alias pa='php artisan'
alias a='php artisan'           # 더 짧은 버전
alias tinker='php artisan tinker'
alias migrate='php artisan migrate'
alias rollback='php artisan migrate:rollback'
alias serve='php artisan serve'
alias fresh='php artisan migrate:fresh --seed'
alias optimize='php artisan optimize'
alias route='php artisan route:list'

# ============================================================
# TESTING ALIASES (Pest 중심)
# ============================================================
alias pest='./vendor/bin/pest'
alias p='./vendor/bin/pest'          # 짧은 버전
alias pf='./vendor/bin/pest --filter'
alias pb='./vendor/bin/pest --bail'
alias pr='./vendor/bin/pest --retry'
alias pd='./vendor/bin/pest --dirty'
alias pp='./vendor/bin/pest --parallel'
alias phpunit='./vendor/bin/phpunit'

# ============================================================
# COMPOSER ALIASES
# ============================================================
alias comp='composer'
alias ci='composer install'
alias cu='composer update'
alias cr='composer require'
alias crd='composer require --dev'

# ============================================================
# NODE/NPM ALIASES
# ============================================================
alias ni='npm install'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrs='npm run start'

# Vue.js 관련
alias vd='npm run dev'
alias vb='npm run build'

# ============================================================
# PYTHON ALIASES
# ============================================================
alias python='python3'
alias pip='pip3'

# ============================================================
# DEVELOPMENT WORKFLOW ALIASES
# ============================================================
# (AI 커밋 메시지 도구는 필요시 여기에 추가)

# ============================================================
# SYSTEM UTILITIES
# ============================================================

# 개선된 명령어들 (brew로 설치한 도구들)
if command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -la'
    alias tree='exa --tree'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# ============================================================
# macOS SPECIFIC
# ============================================================
alias finder='open .'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'

# ============================================================
# DOCKER ALIASES
# ============================================================
alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'