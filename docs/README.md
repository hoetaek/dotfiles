# Documentation

This directory contains documentation for the dotfiles project.

## Available Guides

- [`PHP_VERSION_UPGRADE.md`](PHP_VERSION_UPGRADE.md) - Guide for upgrading PHP versions across all configuration files

## Configuration Files Structure

```
dotfiles/
├── zsh/                    # Zsh configuration modules
├── git/                    # Git configuration
├── claude/                 # Claude Code settings
├── iterm2/                 # iTerm2 preferences
├── phpstorm/              # PhpStorm IDE configuration
├── docs/                  # Documentation (this directory)
├── install.sh             # Main installation script
├── Brewfile              # Homebrew packages
└── README.md             # Main project README
```

## Adding New Documentation

When adding new guides or documentation:
1. Create `.md` files in this `docs/` directory
2. Update this README to link to new guides
3. Keep documentation focused and actionable