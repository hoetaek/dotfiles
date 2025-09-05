# ============================================================
# LANGUAGE & RUNTIME ENVIRONMENTS
# ============================================================

### PHP Configuration (Laravel Herd 포함)
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
export PATH="/Users/hoetaekpro/.composer/vendor/bin:$PATH"

# Herd PHP 설정들
export HERD_PHP_84_INI_SCAN_DIR="/Users/hoetaekpro/Library/Application Support/Herd/config/php/84/"
export HERD_PHP_82_INI_SCAN_DIR="/Users/hoetaekpro/Library/Application Support/Herd/config/php/82/"
export HERD_PHP_83_INI_SCAN_DIR="/Users/hoetaekpro/Library/Application Support/Herd/config/php/83/"
export PATH="/Users/hoetaekpro/Library/Application Support/Herd/bin/":$PATH

### Node.js Configuration (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

### Python Configuration
export PATH="$PATH:/Users/hoetaekpro/.local/bin"
export POETRY_VIRTUALENVS_IN_PROJECT=true

### Rust Configuration
export PATH="$HOME/.cargo/bin:$PATH"

# ============================================================
# DATABASE CONFIGURATION
# ============================================================
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# ============================================================
# GENERAL ENVIRONMENT VARIABLES
# ============================================================

# 사용자 설정
DEFAULT_USER="$(whoami)"

# 에디터 설정
export EDITOR="vim"
export VISUAL="$EDITOR"

# 언어 설정
export LC_TIME=C

# 히스토리 설정
export HISTCONTROL=ignoredups:erasedups

# Less 설정 (페이징)
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s 2>&-'

# Bat (cat 개선) 테마
export BAT_THEME="GitHub"

# MySQL 설정 (Laravel 개발용)
export MYSQL_PS1="\u@\h [\d]> "