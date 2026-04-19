#!/bin/bash

# 1. Install System Dependencies (Debian/Ubuntu/Pop!_OS)
echo "📦 Installing system packages..."
sudo apt update && sudo apt install -y zsh git curl fzf neovim pcsc-tools pcscd npm eza || sudo apt install -y exa

# 2. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🛠️ Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# 3. Install Powerlevel10k & Plugins
echo "🎨 Installing theme and plugins..."
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 4. Link the .zshrc from this repo to Home
# This assumes the script is run from the cloned repo directory
echo "🔗 Linking configuration..."
ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"

# 5. Change default shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to zsh..."
    chsh -s $(which zsh)
fi

echo "✅ Setup complete! Restart your terminal or run 'zsh'."
