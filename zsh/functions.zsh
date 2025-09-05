# ============================================================
# UTILITY FUNCTIONS
# ============================================================

# 디렉토리 생성 후 이동
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 파일 찾기 (개선된 find)
ff() {
    if command -v fd &> /dev/null; then
        fd "$1"
    else
        find . -name "*$1*" -type f
    fi
}

# 프로세스 찾기 및 종료
pskill() {
    ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill
}

# 압축 해제 (자동 포맷 감지)
extract() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf "$1"     ;;
            *.tar.gz)    tar xvzf "$1"     ;;
            *.bz2)       bunzip2 "$1"      ;;
            *.rar)       unrar x "$1"      ;;
            *.gz)        gunzip "$1"       ;;
            *.tar)       tar xvf "$1"      ;;
            *.tbz2)      tar xvjf "$1"     ;;
            *.tgz)       tar xvzf "$1"     ;;
            *.zip)       unzip "$1"        ;;
            *.Z)         uncompress "$1"   ;;
            *.7z)        7z x "$1"         ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# 디렉토리 크기 확인
dirsize() {
    du -sh "${1:-.}" | sort -hr
}

# 빠른 백업
backup() {
    cp "$1"{,.backup.$(date +%Y%m%d_%H%M%S)}
}

# 네트워크 확인
netcheck() {
    echo "Testing network connectivity..."
    ping -c 3 google.com
    echo ""
    echo "DNS resolution test..."
    nslookup google.com
}

# 포트 확인
port() {
    if [ -z "$1" ]; then
        echo "Usage: port <port_number>"
        return 1
    fi
    lsof -i :$1
}

# Git 관련 함수들
gclone() {
    git clone "git@github.com:$1.git"
}

# ============================================================
# LARAVEL SPECIFIC FUNCTIONS
# ============================================================

# Laravel 프로젝트 생성
new_laravel() {
    if [ -z "$1" ]; then
        echo "Usage: new_laravel <project-name>"
        return 1
    fi
    
    echo "Creating Laravel project: $1"
    laravel new "$1"
    cd "$1"
    
    # 기본 패키지들 설치
    echo "Installing Pest..."
    composer require --dev pestphp/pest
    ./vendor/bin/pest --init
    
    # Git 초기화
    echo "Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit"
    
    echo "✅ Laravel project '$1' created successfully!"
    echo "📁 Location: $(pwd)"
}

# Laravel 개발 서버 시작 (포트 지정 가능)
artisan_serve() {
    local port=${1:-8000}
    echo "Starting Laravel development server on port $port..."
    php artisan serve --port="$port"
}

# Laravel 마이그레이션 상태 확인
migration_status() {
    echo "Migration status:"
    php artisan migrate:status
}

# Laravel 로그 실시간 보기
laravel_log() {
    if [ -f "storage/logs/laravel.log" ]; then
        tail -f storage/logs/laravel.log
    else
        echo "Laravel log file not found!"
    fi
}

# ============================================================
# DEVELOPMENT WORKFLOW FUNCTIONS
# ============================================================

# 프로젝트 초기 설정 (PHP/Laravel)
project_setup() {
    echo "Setting up PHP/Laravel project..."
    
    # Composer 설치
    if [ -f "composer.json" ]; then
        echo "Installing Composer dependencies..."
        composer install
    fi
    
    # NPM 설치
    if [ -f "package.json" ]; then
        echo "Installing NPM dependencies..."
        npm install
    fi
    
    # .env 파일 생성
    if [ -f ".env.example" ] && [ ! -f ".env" ]; then
        echo "Creating .env file..."
        cp .env.example .env
    fi
    
    # Laravel 키 생성
    if [ -f "artisan" ]; then
        echo "Generating Laravel application key..."
        php artisan key:generate
    fi
    
    echo "✅ Project setup complete!"
}

# Git 브랜치 정리
git_cleanup() {
    echo "Cleaning up merged branches..."
    git branch --merged | grep -v "\*\|main\|master\|develop" | xargs -n 1 git branch -d
    echo "✅ Branch cleanup complete!"
}

# 업데이트 함수
update_system() {
    echo "🔄 Updating system packages..."
    
    # Homebrew 업데이트
    if command -v brew &> /dev/null; then
        echo "Updating Homebrew..."
        brew update && brew upgrade
    fi
    
    # Composer global 업데이트
    echo "Updating global Composer packages..."
    composer global update
    
    # NPM global 업데이트
    if command -v npm &> /dev/null; then
        echo "Updating global NPM packages..."
        npm update -g
    fi
    
    echo "✅ System update complete!"
}