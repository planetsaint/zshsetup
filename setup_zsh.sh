#!/bin/bash

# ZSH Complete Setup Script
# This script installs Oh My Zsh, plugins, oh-my-posh, and configures everything

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on supported OS
check_os() {
    log_info "Checking operating system..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        log_success "Linux detected"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        log_success "macOS detected"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
        log_success "Windows (WSL/Cygwin) detected"
    else
        log_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

# Install dependencies
install_dependencies() {
    log_info "Installing dependencies..."
    
    case $OS in
        linux)
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get update
                sudo apt-get install -y zsh curl git wget unzip build-essential
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y zsh curl git wget unzip gcc gcc-c++ make
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm zsh curl git wget unzip base-devel
            elif command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y zsh curl git wget unzip gcc gcc-c++ make
            else
                log_error "Package manager not found. Please install zsh, curl, git, wget, and unzip manually."
                exit 1
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install zsh curl git wget
            else
                log_warning "Homebrew not found. Please install manually or install Homebrew first."
            fi
            ;;
        windows)
            log_info "Assuming WSL - dependencies should be available"
            ;;
    esac
    
    log_success "Dependencies installed"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    log_info "Installing Oh My Zsh..."
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_warning "Oh My Zsh already installed, skipping..."
        return
    fi
    
    # Download and install Oh My Zsh without changing shell automatically
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    log_success "Oh My Zsh installed"
}

# Install Oh My Zsh plugins
install_plugins() {
    log_info "Installing Oh My Zsh plugins..."
    
    local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    
    # zsh-autosuggestions
    if [[ ! -d "$plugin_dir/zsh-autosuggestions" ]]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir/zsh-autosuggestions"
    else
        log_warning "zsh-autosuggestions already installed"
    fi
    
    # zsh-syntax-highlighting
    if [[ ! -d "$plugin_dir/zsh-syntax-highlighting" ]]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir/zsh-syntax-highlighting"
    else
        log_warning "zsh-syntax-highlighting already installed"
    fi
    
    log_success "Oh My Zsh plugins installed"
}

# Install Oh My Posh
install_oh_my_posh() {
    log_info "Installing Oh My Posh..."
    
    if command -v oh-my-posh >/dev/null 2>&1; then
        log_warning "Oh My Posh already installed, updating..."
        case $OS in
            linux|windows)
                sudo curl -s https://ohmyposh.dev/install.sh | bash -s
                ;;
            macos)
                if command -v brew >/dev/null 2>&1; then
                    brew upgrade oh-my-posh
                else
                    curl -s https://ohmyposh.dev/install.sh | bash -s
                fi
                ;;
        esac
        return
    fi
    
    case $OS in
        linux|windows)
            # Use official installer
            curl -s https://ohmyposh.dev/install.sh | bash -s
            # Add to PATH if not already there
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install jandedobbeleer/oh-my-posh/oh-my-posh
            else
                # Manual installation for macOS
                curl -s https://ohmyposh.dev/install.sh | bash -s
            fi
            ;;
    esac
    
    log_success "Oh My Posh installed"
}

# Download Oh My Posh themes
download_themes() {
    log_info "Downloading Oh My Posh themes..."
    
    local theme_dir="$HOME/.cache/oh-my-posh/themes"
    mkdir -p "$theme_dir"
    
    # Download bubblesextra theme
    if [[ ! -f "$theme_dir/bubblesextra.omp.json" ]] || [[ ! -s "$theme_dir/bubblesextra.omp.json" ]]; then
        curl -s https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/bubblesextra.omp.json > "$theme_dir/bubblesextra.omp.json"
        log_success "bubblesextra theme downloaded"
    else
        log_warning "bubblesextra theme already exists"
    fi
    
    # Download a few other popular themes as backup
    local themes=("bubbles" "powerlevel10k_rainbow" "atomic" "dracula")
    for theme in "${themes[@]}"; do
        if [[ ! -f "$theme_dir/$theme.omp.json" ]]; then
            curl -s "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/$theme.omp.json" > "$theme_dir/$theme.omp.json" 2>/dev/null || true
        fi
    done
    
    log_success "Oh My Posh themes downloaded"
}

# Install FZF
install_fzf() {
    log_info "Installing FZF..."
    
    if command -v fzf >/dev/null 2>&1; then
        log_warning "FZF already installed, skipping..."
        return
    fi
    
    case $OS in
        linux)
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get install -y fzf
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y fzf
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm fzf
            elif command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y fzf
            else
                # Manual installation
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                ~/.fzf/install --all
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install fzf
                # Install shell integration
                $(brew --prefix)/opt/fzf/install
            else
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                ~/.fzf/install --all
            fi
            ;;
        windows)
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install --all
            ;;
    esac
    
    log_success "FZF installed"
}

# Install modern ls alternatives
install_ls_alternatives() {
    log_info "Installing modern ls alternatives..."
    
    case $OS in
        linux)
            if command -v apt-get >/dev/null 2>&1; then
                # Try to install eza first (newer than exa)
                if ! sudo apt-get install -y eza 2>/dev/null; then
                    # Try exa as fallback
                    if ! sudo apt-get install -y exa 2>/dev/null; then
                        # Try lsd as last resort
                        sudo apt-get install -y lsd 2>/dev/null || log_warning "Could not install any modern ls alternative"
                    fi
                fi
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y exa 2>/dev/null || sudo yum install -y lsd 2>/dev/null || log_warning "Could not install exa or lsd"
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm eza 2>/dev/null || sudo pacman -S --noconfirm exa 2>/dev/null || sudo pacman -S --noconfirm lsd 2>/dev/null || log_warning "Could not install any modern ls alternative"
            elif command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y eza 2>/dev/null || sudo dnf install -y exa 2>/dev/null || sudo dnf install -y lsd 2>/dev/null || log_warning "Could not install any modern ls alternative"
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install eza 2>/dev/null || brew install exa 2>/dev/null || brew install lsd 2>/dev/null || log_warning "Could not install eza, exa, or lsd"
            fi
            ;;
        windows)
            log_warning "Please install eza, exa, or lsd manually if desired"
            ;;
    esac
    
    log_success "Modern ls alternatives installation attempted"
}

# Install Neovim
install_neovim() {
    log_info "Installing Neovim..."
    
    if command -v nvim >/dev/null 2>&1; then
        log_warning "Neovim already installed, skipping..."
        return
    fi
    
    case $OS in
        linux)
            if command -v apt-get >/dev/null 2>&1; then
                sudo apt-get install -y neovim
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y neovim
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm neovim
            elif command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y neovim
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                brew install neovim
            fi
            ;;
        windows)
            log_warning "Please install Neovim manually"
            ;;
    esac
    
    log_success "Neovim installation attempted"
}

# Create the latest optimized .zshrc
create_zshrc() {
    log_info "Creating latest optimized .zshrc..."
    
    # Backup existing .zshrc if it exists
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Existing .zshrc backed up"
    fi
    
    cat > "$HOME/.zshrc" << 'EOF'
# ~/.zshrc - Optimized ZSH Configuration

# Set UTF-8 encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export FUNCNEST=500

# Oh My Zsh setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Using oh-my-posh instead

# Plugins - streamlined list
plugins=(
    git
    z
    zsh-autosuggestions
    fzf
    colored-man-pages
    zsh-syntax-highlighting
)

# Autosuggestions configuration - optimized for better UX
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ZSH Autosuggestions - accept with right arrow
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
    forward-char
    vi-forward-char
    end-of-line
    vi-end-of-line
    vi-add-eol
)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
    forward-word
    emacs-forward-word
    vi-forward-word
    vi-forward-word-end
    vi-forward-blank-word
    vi-forward-blank-word-end
    vi-find-next-char
    vi-find-next-char-skip
)

# Load Oh My Zsh
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Oh My Posh - simplified theme loading
if command -v oh-my-posh >/dev/null 2>&1; then
    theme_file="$HOME/.cache/oh-my-posh/themes/bubblesextra.omp.json"
    if [[ -f "$theme_file" && -s "$theme_file" ]]; then
        eval "$(oh-my-posh init zsh --config $theme_file)"
    else
        eval "$(oh-my-posh init zsh --config bubblesextra 2>/dev/null || oh-my-posh init zsh)"
    fi
fi

# History configuration - enhanced for better suggestions
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS SHARE_HISTORY
setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_VERIFY
setopt INC_APPEND_HISTORY

# Key bindings - emacs style
bindkey -e
bindkey '^D' delete-char
bindkey '^H' backward-delete-char

# Auto-completion and suggestions
setopt COMPLETE_IN_WORD    # Complete from both ends of a word
setopt ALWAYS_TO_END       # Move cursor to end of completed word
setopt PATH_DIRS           # Perform path search even on command names with slashes
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash
setopt AUTO_PARAM_KEYS     # Remove trailing spaces from completed parameters

# Enable real-time suggestions
setopt CORRECT             # Suggest corrections for commands
setopt CORRECT_ALL         # Suggest corrections for all arguments

# Arrow key navigation for completion
bindkey "^[[A" reverse-menu-complete    # Up arrow for reverse completion
bindkey "^[[B" menu-complete           # Down arrow for completion

# Tab completion setup - enhanced for better suggestions
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Enhanced completion with more context
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# Smart completion for commands
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-command-:*:' verbose false
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# History-based completion
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes select

# Make Tab cycle through completions with visible menu
zstyle ':completion:*' menu select=1
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
bindkey '^I' expand-or-complete-prefix  # Tab for completion

# Auto-show completion menu
setopt AUTO_LIST           # Automatically list choices on ambiguous completion
setopt AUTO_MENU           # Show completion menu on successive tab press
setopt MENU_COMPLETE       # Insert first match immediately on tab
setopt LIST_PACKED         # Compact listing (smaller menu)
setopt LIST_TYPES          # Show file types in completion

# Key bindings for autosuggestions and navigation
bindkey '^[[C' forward-char           # Right arrow to accept full suggestion
bindkey '^K' kill-line                # Ctrl+K to clear line

# Force menu completion to show options
bindkey '^I' menu-complete            # Tab shows menu and completes
bindkey '^[[Z' reverse-menu-complete  # Shift+Tab for reverse
bindkey ' ' magic-space               # Space expands history

# FZF configuration
if command -v fzf >/dev/null 2>&1; then
    bindkey '^F' fzf-file-widget      # Ctrl+F for file search
    bindkey '^T' fzf-completion       # Ctrl+T for completion
    bindkey '^R' fzf-history-widget   # Ctrl+R for history search
    
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_CTRL_T_OPTS="--preview 'cat {}' --preview-window=right:50%"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"
fi

# Environment variables
export EDITOR="nvim"
export GIT_SSH="ssh"

# Aliases
alias vim="nvim"
alias ll="ls -la"
alias la="ls -la"
alias l="ls -l"
alias g="git"
alias grep="grep --color=auto"
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"

# Enhanced ls with modern tools
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons"
    alias ll="eza -la --icons"
    alias la="eza -la --icons"
elif command -v exa >/dev/null 2>&1; then
    alias ls="exa --icons"
    alias ll="exa -la --icons"
    alias la="exa -la --icons"
elif command -v lsd >/dev/null 2>&1; then
    alias ls="lsd"
    alias ll="lsd -la"
    alias la="lsd -la"
else
    # Fallback with colors
    [[ "$OSTYPE" == "darwin"* ]] && alias ls="ls -G" || alias ls="ls --color=auto"
    alias ll="ls -la"
fi

# Utility functions
which() { command -v "$1" 2>/dev/null; }

# Load local customizations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Disable bell
unsetopt BEEP

echo "ZSH configuration loaded successfully!"
EOF
    
    log_success "Latest optimized .zshrc created"
}

# Change default shell to zsh
change_shell() {
    log_info "Changing default shell to zsh..."
    
    if [[ "$SHELL" == *"zsh"* ]]; then
        log_warning "Default shell is already zsh"
        return
    fi
    
    # Find zsh path
    ZSH_PATH=$(command -v zsh)
    
    # Check if zsh is in /etc/shells
    if ! grep -q "$ZSH_PATH" /etc/shells; then
        log_info "Adding zsh to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    
    # Change shell
    chsh -s "$ZSH_PATH"
    log_success "Default shell changed to zsh (restart terminal to take effect)"
}

# Clear zsh cache
clear_zsh_cache() {
    log_info "Clearing ZSH cache..."
    rm -f ~/.zcompdump*
    log_success "ZSH cache cleared"
}

# Main installation function
main() {
    log_info "Starting ZSH complete setup with latest configuration..."
    
    check_os
    install_dependencies
    install_oh_my_zsh
    install_plugins
    install_oh_my_posh
    download_themes
    install_fzf
    install_ls_alternatives
    install_neovim
    create_zshrc
    clear_zsh_cache
    change_shell
    
    log_success "ZSH setup completed successfully!"
    log_info "Features included:"
    log_info "  ✓ Smart autosuggestions with history/completion/context"
    log_info "  ✓ Enhanced tab completion with menu"
    log_info "  ✓ Right arrow accepts suggestions"
    log_info "  ✓ Ctrl+F for file search, Ctrl+T for completion, Ctrl+R for history"
    log_info "  ✓ Up/Down arrows for completion navigation"
    log_info "  ✓ Ctrl+K to clear line"
    log_info "  ✓ Modern ls alternatives (eza/exa/lsd)"
    log_info "  ✓ FZF integration for fuzzy finding"
    log_info "  ✓ Oh My Posh theming"
    log_info "  ✓ Syntax highlighting and corrections"
    log_info ""
    log_info "Please restart your terminal or run: exec zsh"
    log_info "Your old .zshrc has been backed up with a timestamp"
}

# Run the main function
main "$@"
