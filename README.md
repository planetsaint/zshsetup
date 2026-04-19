import os
from weasyprint import HTML

This repository contains a performance-optimized Zsh configuration designed for Pop!_OS and Debian-based distributions. The environment utilizes Oh My Zsh and Powerlevel10k to provide a responsive, feature-rich command-line interface.

## System Features

- **Optimized Startup:** compinit performance tuning to minimize shell load times.
- **Enhanced Completion:** Case-insensitive, partial-match, and menu-driven completion logic.
- **Productivity Tools:** Integrated aliases for modern command-line utilities (eza, nvim) and smart history management.
- **Fuzzy Finding:** Native fzf integration for file navigation and history search.
- **CAC Support:** Specialized aliases for Smart Card/CAC reader status monitoring.

## Prerequisites

### Nerd Fonts
To render the visual elements and symbols in this configuration, a Nerd Font must be installed and active in your terminal emulator. 
**Recommended:** MesloLGS NF.

### Dependencies
The installation script will attempt to install the following packages:
- zsh, git, curl, fzf, neovim, pcsc-tools, pcscd, npm, eza (or exa).

## Installation

### One-Line Automated Installation
Run the following command to install dependencies, frameworks, and apply the configuration automatically:

```bash
bash -c "$(curl -fsSL [https://raw.githubusercontent.com/planetsaint/zshsetup/main/setup.sh](https://raw.githubusercontent.com/planetsaint/zshsetup/main/setup.sh))"import os

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
