# PHP Version Upgrade Guide

When upgrading to a new PHP version, update these files:

## 1. Brewfile
```bash
# Change this line:
brew "php@8.2"
# To:
brew "php@8.3"  # or whatever new version
```

## 2. zsh/exports.zsh
```bash
# Update these PATH exports:
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"

# To:
export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"
```

## 3. PhpStorm Configuration (Optional)
If you want to update PhpStorm settings:
1. Open PhpStorm
2. Configure new PHP interpreter
3. Re-export phpstorm configuration:
   ```bash
   cp ~/Library/Application\ Support/JetBrains/PhpStorm*/options/php-tools.xml phpstorm/options/
   ```

## 4. After Changes
Run the install script to apply changes:
```bash
cd ~/dotfiles && ./install.sh
```

Or manually:
```bash
brew uninstall php@8.2
brew install php@8.3
source ~/.zshrc
```