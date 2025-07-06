# 🚀 Ultimate ZSH Setup Script

Transform your terminal into a productivity powerhouse with this comprehensive ZSH configuration script! 

## ✨ What You'll Get

- **🎨 Beautiful Terminal**: Oh My Posh themes with bubblesextra styling
- **🧠 Smart Autosuggestions**: Context-aware completions from history
- **🔍 Fuzzy Finding**: FZF integration for lightning-fast file/history search
- **🎯 Enhanced Navigation**: Modern ls alternatives (eza/exa/lsd) with icons
- **⚡ Optimized Performance**: Streamlined configuration for speed
- **🛠️ Developer Tools**: Neovim, Git integration, and syntax highlighting
- **🌈 Syntax Highlighting**: Color-coded commands as you type
- **📚 Smart Completions**: Tab completion with visual menus

## 🎯 One-Line Installation

```bash
curl -fsSL https://raw.githubusercontent.com/planetsaint/zshsetup/main/paste.txt | bash
```

## 📋 Manual Installation

Prefer to review before running? Here's the step-by-step process:

### 1. 📥 Download the Script
```bash
curl -o setup_zsh.sh https://raw.githubusercontent.com/planetsaint/zshsetup/main/paste.txt
```

### 2. 🔓 Make it Executable
```bash
chmod +x setup_zsh.sh
```

### 3. 🚀 Run the Script
```bash
./setup_zsh.sh
```

## 💡 Pro Tips

- **🔄 Restart Required**: After installation, restart your terminal or run `exec zsh`
- **💾 Backup Safe**: Your existing `.zshrc` is automatically backed up
- **🎨 Theme Switching**: Multiple Oh My Posh themes are downloaded for easy switching
- **🛠️ Cross-Platform**: Works on Linux, macOS, and Windows (WSL)

## 🎮 Key Features & Shortcuts

| Feature | Shortcut | Description |
|---------|----------|-------------|
| **Smart Suggestions** | `→` | Accept full suggestion |
| **Fuzzy File Search** | `Ctrl+F` | Find files quickly |
| **History Search** | `Ctrl+R` | Search command history |
| **Tab Completion** | `Tab` | Enhanced completion menu |
| **Clear Line** | `Ctrl+K` | Clear current line |
| **Menu Navigation** | `↑/↓` | Navigate completion options |

## 🌟 What Gets Installed

- **Oh My Zsh** - The ultimate ZSH framework
- **Plugins**: autosuggestions, syntax highlighting, fzf, git, z-jump
- **Oh My Posh** - Cross-platform prompt theming
- **FZF** - Fuzzy finder for files and history
- **Modern Tools**: eza/exa/lsd (better ls), neovim
- **Optimized Config** - Performance-tuned .zshrc

## 🎨 Customization

Your new setup includes:
- **🎯 Smart autosuggestions** based on history and context
- **📱 Responsive design** that works on any screen size
- **🌈 Syntax highlighting** for better readability
- **⚡ Fast performance** with optimized loading
- **🎨 Beautiful themes** with bubblesextra as default

## 🔧 Troubleshooting

**Terminal not showing changes?**
```bash
exec zsh
```

**Want to revert changes?**
```bash
# Your old config is backed up with timestamp
cp ~/.zshrc.backup.* ~/.zshrc
```

**Permission issues?**
```bash
# Make sure you have sudo access for package installation
sudo -v
```

## 🤝 Contributing

Found a bug or want to suggest improvements? Feel free to:
- 🐛 Open an issue
- 🔧 Submit a pull request
- ⭐ Star the repository if you found it helpful!

## 📜 License

This script is free to use and modify. Share the terminal love! 💙

---

**Ready to supercharge your terminal?** 🚀
```bash
curl -fsSL https://raw.githubusercontent.com/planetsaint/zshsetup/main/paste.txt | bash
```

*Happy coding! 🎉*
