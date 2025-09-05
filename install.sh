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
    git pull origin main
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