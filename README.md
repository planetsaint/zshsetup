import os

# Define the content for the README.md file
readme_content = """# Custom Zsh + Powerlevel10k Configuration

A high-performance, feature-rich Zsh configuration optimized for **Pop!_OS** and other Debian-based systems. This setup prioritizes terminal startup speed, intelligent history management, and a modern CLI aesthetic using **Powerlevel10k** and **Oh My Zsh**.

## Features

- **Fast Startup:** Optimized `compinit` to rebuild the completion dump only once every 24 hours.
- **Powerlevel10k:** Includes an instant prompt for immediate terminal readiness.
- **Intelligent Autosuggestions:** History-based suggestions with asynchronous fetching and specific accept/partial-accept keybindings.
- **Advanced Completion:** Case-insensitive, partial-match, and menu-driven completion styling.
- **Modern CLI Tools:** Automatic aliasing for modern replacements like `eza` or `exa` over standard `ls`.
- **FZF Integration:** Fuzzy finding for files, history, and completions via `Ctrl-F`, `Ctrl-R`, and `Ctrl-T`.
- **Security & Efficiency:** Specialized aliases for CAC reader status (`pcsc_scan`) and network diagnostics.

## Prerequisites

Before installation, ensure you have a **Nerd Font** installed in your terminal emulator (e.g., *MesloLGS NF*) to render icons and symbols correctly.

```bash
# Recommended system dependencies for Pop!_OS/Ubuntu/Debian
sudo apt update
sudo apt install -y zsh git curl fzf neovim pcsc-tools pcscd npm eza
