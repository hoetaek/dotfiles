# 🛠️ My Dotfiles

macOS 개발 환경 자동화를 위한 dotfiles 저장소

## 🚀 빠른 설치

```bash
# 원라이너 설치
curl -fsSL https://raw.githubusercontent.com/hoetaek/dotfiles/main/install.sh | bash
```

## 📦 포함된 내용

- **Homebrew**: 패키지 관리자 자동 설치
- **PHP/Laravel**: 개발 환경 (PHP 8.2, Composer, MySQL, Redis)
- **Zsh**: 모듈식 구조로 관리
- **Git**: 개발자 친화적 설정
- **개발 도구**: VS Code, Docker 등

## 🔧 수동 설치

```bash
git clone https://github.com/hoetaek/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 🔄 업데이트

```bash
cd ~/dotfiles && git pull && brew bundle
```

## 📁 구조

```
~/dotfiles/
├── install.sh          # 자동 설치 스크립트
├── Brewfile            # Homebrew 패키지 목록
├── zsh/                # Zsh 설정
│   ├── .zshrc
│   ├── aliases.zsh
│   ├── exports.zsh
│   └── laravel.zsh
├── git/                # Git 설정
│   └── .gitconfig
├── claude/             # Claude Code 설정
├── iterm2/             # iTerm2 환경설정
├── phpstorm/           # PhpStorm IDE 설정
├── docs/               # 문서 및 가이드
└── README.md
```

## 📚 문서

자세한 설정 가이드는 [`docs/`](docs/) 디렉토리를 참고하세요.