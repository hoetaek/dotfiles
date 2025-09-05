#!/bin/bash

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DOTFILES_DIR="$HOME/dotfiles"

echo -e "${BLUE}🚀 Starting dotfiles setup...${NC}"

# dotfiles 저장소 확인 및 설치/업데이트
if [ -d "$DOTFILES_DIR" ]; then
    echo -e "${BLUE}📦 Updating existing dotfiles...${NC}"
    cd "$DOTFILES_DIR"
    git pull origin master
else
    echo -e "${BLUE}📦 Cloning dotfiles repository...${NC}"
    git clone https://github.com/hoetaek/dotfiles.git "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# Homebrew 설치 확인
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}🍺 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # M1/M2 맥에서 PATH 설정
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}✅ Homebrew already installed${NC}"
fi

# Oh My Zsh 설치 확인
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}🎨 Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}✅ Oh My Zsh already installed${NC}"
fi

# Brewfile에서 패키지 설치
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo -e "${BLUE}📦 Installing packages from Brewfile...${NC}"
    brew bundle --file="$DOTFILES_DIR/Brewfile"
else
    echo -e "${RED}❌ Brewfile not found${NC}"
fi

# 기존 설정 파일 백업
backup_file() {
    if [ -f "$1" ]; then
        echo -e "${BLUE}💾 Backing up existing $1${NC}"
        mv "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    fi
}

# dotfiles 심볼릭 링크 생성
echo -e "${BLUE}🔗 Creating symlinks...${NC}"

# Zsh 설정
backup_file ~/.zshrc
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc

# Git 설정
backup_file ~/.gitconfig
if [ -f "$DOTFILES_DIR/git/.gitconfig" ]; then
    ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
fi

# Claude 설정
echo -e "${BLUE}🤖 Setting up Claude configuration...${NC}"
mkdir -p ~/.claude/plugins

backup_file ~/.claude/settings.json
if [ -f "$DOTFILES_DIR/claude/settings.json" ]; then
    ln -sf "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
fi

backup_file ~/.claude/statusline.sh
if [ -f "$DOTFILES_DIR/claude/statusline.sh" ]; then
    ln -sf "$DOTFILES_DIR/claude/statusline.sh" ~/.claude/statusline.sh
    chmod +x ~/.claude/statusline.sh
fi

backup_file ~/.claude/plugins/config.json
if [ -f "$DOTFILES_DIR/claude/plugins/config.json" ]; then
    ln -sf "$DOTFILES_DIR/claude/plugins/config.json" ~/.claude/plugins/config.json
fi

# iTerm2 설정
if [ -f "$DOTFILES_DIR/iterm2/com.googlecode.iterm2.plist" ]; then
    echo -e "${BLUE}📱 Setting up iTerm2 configuration...${NC}"
    
    # iTerm2가 실행 중이면 종료하라고 안내
    if pgrep -x "iTerm2" > /dev/null; then
        echo -e "${BLUE}⚠️  Please quit iTerm2 before applying settings${NC}"
        echo -e "${BLUE}Press any key when iTerm2 is closed...${NC}"
        read -n 1
    fi
    
    # 기존 설정 백업
    if [ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]; then
        cp ~/Library/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # 새 설정 복사
    cp "$DOTFILES_DIR/iterm2/com.googlecode.iterm2.plist" ~/Library/Preferences/com.googlecode.iterm2.plist
    echo -e "${GREEN}✅ iTerm2 configuration installed${NC}"
fi

# PhpStorm 설정
PHPSTORM_CONFIG_DIR="$HOME/Library/Application Support/JetBrains"
PHPSTORM_VERSION=$(ls "$PHPSTORM_CONFIG_DIR" 2>/dev/null | grep "PhpStorm" | tail -1)

if [ -d "$DOTFILES_DIR/phpstorm" ] && [ -n "$PHPSTORM_VERSION" ]; then
    echo -e "${BLUE}🐘 Setting up PhpStorm configuration...${NC}"
    
    PHPSTORM_PATH="$PHPSTORM_CONFIG_DIR/$PHPSTORM_VERSION"
    
    # 기존 설정 백업
    if [ -d "$PHPSTORM_PATH" ]; then
        echo -e "${BLUE}💾 Backing up existing PhpStorm settings${NC}"
        cp -r "$PHPSTORM_PATH/options" "$PHPSTORM_PATH/options.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
        cp -r "$PHPSTORM_PATH/codestyles" "$PHPSTORM_PATH/codestyles.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    fi
    
    # 설정 디렉토리 생성
    mkdir -p "$PHPSTORM_PATH/options"
    mkdir -p "$PHPSTORM_PATH/codestyles"
    
    # 설정 파일 복사
    if [ -d "$DOTFILES_DIR/phpstorm/options" ]; then
        cp "$DOTFILES_DIR/phpstorm/options/"* "$PHPSTORM_PATH/options/" 2>/dev/null || true
    fi
    
    if [ -d "$DOTFILES_DIR/phpstorm/codestyles" ]; then
        cp "$DOTFILES_DIR/phpstorm/codestyles/"* "$PHPSTORM_PATH/codestyles/" 2>/dev/null || true
    fi
    
    echo -e "${GREEN}✅ PhpStorm configuration installed for $PHPSTORM_VERSION${NC}"
elif [ -d "$DOTFILES_DIR/phpstorm" ]; then
    echo -e "${BLUE}⚠️  PhpStorm configuration found in dotfiles but PhpStorm not installed${NC}"
fi

# Launchpad 설정 (선택적)
if [ -f "$DOTFILES_DIR/launchpad/launchpad_backup.sql" ]; then
    echo -e "${BLUE}📱 Launchpad configuration found${NC}"
    echo -e "${BLUE}Do you want to restore Launchpad folder organization? (y/N)${NC}"
    read -r LAUNCHPAD_RESPONSE
    
    if [[ "$LAUNCHPAD_RESPONSE" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}📱 Restoring Launchpad configuration...${NC}"
        cd "$DOTFILES_DIR/launchpad"
        ./import_launchpad.sh
        cd "$DOTFILES_DIR"
    else
        echo -e "${BLUE}⏭️  Skipping Launchpad configuration${NC}"
    fi
fi

# 로컬 설정 파일 생성 (머신별로 다른 설정)
if [ ! -f ~/.zshrc.local ]; then
    cat > ~/.zshrc.local << 'EOF'
# 이 파일은 Git에 올리지 않습니다 (.gitignore에 추가)
# 머신별로 다른 설정들을 여기에 작성하세요

# 예시: 회사 컴퓨터에서만 사용하는 설정
# export COMPANY_VPN="vpn.company.com"
# alias deploy-staging="./scripts/deploy.sh staging"

# Git 사용자 정보 (개인정보이므로 여기에 설정)
# git config --global user.name "Your Name"
# git config --global user.email "your.email@example.com"
EOF
    echo -e "${GREEN}✅ Created ~/.zshrc.local for machine-specific settings${NC}"
fi

# zsh를 기본 쉘로 설정
if [ "$SHELL" != "$(which zsh)" ]; then
    echo -e "${BLUE}🐚 Changing default shell to zsh...${NC}"
    chsh -s $(which zsh)
fi

# Git 사용자 정보 설정 확인
if ! git config --global user.name &>/dev/null || ! git config --global user.email &>/dev/null; then
    echo -e "${BLUE}👤 Git user information not configured.${NC}"
    echo -e "${BLUE}Please add your information to ~/.zshrc.local:${NC}"
    echo "git config --global user.name \"Your Name\""
    echo "git config --global user.email \"your.email@example.com\""
fi

echo -e "${GREEN}🎉 Dotfiles setup complete!${NC}"
echo -e "${BLUE}Please restart your terminal or run: source ~/.zshrc${NC}"