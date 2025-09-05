# ============================================================
# LARAVEL SPECIFIC CONFIGURATION
# ============================================================

# Laravel 관련 환경변수
export LARAVEL_START="$HOME/Code"

# ============================================================
# LARAVEL SHORTCUTS
# ============================================================

# 빠른 Laravel 명령어들
alias route:list='php artisan route:list'
alias route:cache='php artisan route:cache'
alias route:clear='php artisan route:clear'
alias config:cache='php artisan config:cache'
alias config:clear='php artisan config:clear'
alias view:cache='php artisan view:cache'
alias view:clear='php artisan view:clear'
alias queue:work='php artisan queue:work'
alias queue:restart='php artisan queue:restart'

# ============================================================
# LARAVEL DEVELOPMENT HELPERS
# ============================================================

# Laravel 프로젝트 디렉토리로 빠른 이동
cdl() {
    if [ -z "$1" ]; then
        cd "$LARAVEL_START" || cd ~/Code
    else
        cd "$LARAVEL_START/$1" || cd "~/Code/$1"
    fi
}

# Laravel 새 모델 생성 (마이그레이션, 팩토리, 시더 포함)
make:model() {
    if [ -z "$1" ]; then
        echo "Usage: make:model <ModelName>"
        return 1
    fi
    
    php artisan make:model "$1" -mfs
    echo "✅ Created model $1 with migration, factory, and seeder"
}

# Laravel 새 컨트롤러 생성 (리소스 컨트롤러)
make:controller() {
    if [ -z "$1" ]; then
        echo "Usage: make:controller <ControllerName>"
        return 1
    fi
    
    php artisan make:controller "$1" --resource
    echo "✅ Created resource controller $1"
}

# Laravel 테스트 실행 (특정 테스트 또는 전체)
test() {
    if [ -z "$1" ]; then
        # Pest 또는 PHPUnit 자동 감지
        if [ -f "vendor/bin/pest" ]; then
            ./vendor/bin/pest
        else
            ./vendor/bin/phpunit
        fi
    else
        if [ -f "vendor/bin/pest" ]; then
            ./vendor/bin/pest --filter="$1"
        else
            ./vendor/bin/phpunit --filter="$1"
        fi
    fi
}

# Laravel 캐시 전체 정리
cache:flush() {
    echo "🧹 Clearing all Laravel caches..."
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
    composer dump-autoload
    echo "✅ All caches cleared!"
}

# Laravel 개발 환경 재시작
restart:dev() {
    echo "🔄 Restarting Laravel development environment..."
    
    # 캐시 정리
    cache:flush
    
    # Queue 재시작
    php artisan queue:restart
    
    # NPM 개발 서버 재시작 (백그라운드에서 실행 중이라면)
    pkill -f "npm run dev" 2>/dev/null || true
    
    echo "✅ Development environment restarted!"
}

# Laravel 로그 레벨별 보기
log:error() {
    tail -f storage/logs/laravel.log | grep "ERROR"
}

log:debug() {
    tail -f storage/logs/laravel.log | grep "DEBUG"
}

log:info() {
    tail -f storage/logs/laravel.log | grep "INFO"
}

# ============================================================
# DATABASE HELPERS
# ============================================================

# 데이터베이스 마이그레이션 및 시딩
migrate:fresh() {
    echo "🗄️ Refreshing database..."
    php artisan migrate:fresh --seed
    echo "✅ Database refreshed with seed data!"
}

# 데이터베이스 백업 (MySQL)
db:backup() {
    local db_name=$(php artisan tinker --execute="echo config('database.connections.mysql.database');" 2>/dev/null | tail -1)
    local backup_file="database_backup_$(date +%Y%m%d_%H%M%S).sql"
    
    if [ -n "$db_name" ]; then
        mysqldump "$db_name" > "$backup_file"
        echo "✅ Database backed up to: $backup_file"
    else
        echo "❌ Could not determine database name"
    fi
}

# ============================================================
# COMPOSER & DEPENDENCIES
# ============================================================

# Composer 최적화
composer:optimize() {
    echo "🚀 Optimizing Composer..."
    composer install --optimize-autoloader --no-dev
    composer dump-autoload --optimize
    echo "✅ Composer optimized!"
}

# Laravel 성능 최적화
optimize:production() {
    echo "🚀 Optimizing Laravel for production..."
    
    # 설정 캐싱
    php artisan config:cache
    
    # 라우트 캐싱
    php artisan route:cache
    
    # 뷰 캐싱
    php artisan view:cache
    
    # Composer 최적화
    composer:optimize
    
    echo "✅ Production optimization complete!"
}

# ============================================================
# HERD INTEGRATION (Laravel Herd 사용시)
# ============================================================

# Herd 사이트 관리
herd:link() {
    if command -v herd &> /dev/null; then
        herd link
        echo "✅ Current directory linked with Herd"
    else
        echo "❌ Laravel Herd not found"
    fi
}

herd:open() {
    local site_name=$(basename "$PWD")
    if command -v herd &> /dev/null; then
        open "http://$site_name.test"
    else
        echo "❌ Laravel Herd not found"
    fi
}