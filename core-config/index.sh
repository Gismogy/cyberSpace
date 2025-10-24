#!/bin/sh

# ----------------------------
# SH PHASE: Only POSIX sh here
# ----------------------------

ZSHLOC="$HOME/.zshrc"

# Check if Zsh is installed
if ! command -v zsh >/dev/null 2>&1; then
    echo "Zsh is not installed!"
    echo "Do you want to install Zsh and update the system? (y/n)"
    read answer

    if [ "$answer" != "y" ]; then
        echo "❌ Installation canceled."
        exit 0
    fi

    # Run your install script if it exists
    if [ -f "$PWD/installCore/install.sh" ]; then
        sh "$PWD/installCore/install.sh"
    else
        echo "❌ Install script not found!"
        exit 1
    fi

    # Verify installation succeeded
    if command -v zsh >/dev/null 2>&1; then
        echo "✅ Zsh installed successfully!"
        echo "Please rerun this script using Zsh: zsh $0"
        exit 0
    else
        echo "❌ Zsh installation failed!"
        exit 1
    fi
fi

# ----------------------------
# ZSH PHASE: Only run under Zsh
# ----------------------------
if [ "$ZSH_NAME" != "zsh" ]; then
    echo "Please run this file with Zsh! Installation is probably done."
    exit 1
fi

# Check if .zshrc needs initialization
if [ ! -f "$ZSHLOC" ] || [ "$(head -n 1 "$ZSHLOC")" != "#[UwU]" ]; then
    PDIRCORE="$(dirname "$(cd "$(dirname "$0")" && pwd)")"

    : > "$ZSHLOC"
    echo "#[UwU]" >> "$ZSHLOC"
    echo "export ZSH=\"\$HOME/.oh-my-zsh\"" >> "$ZSHLOC"
    echo "export CS=\"$PDIRCORE\"" >> "$ZSHLOC"
    echo "ZSH_THEME=" >> "$ZSHLOC"
    echo "plugins=(git)" >> "$ZSHLOC"
    if [ ! -f "$ZSH" ]; then
      mkdir $HOME/.oh-my-zsh
    fi

    echo "source \$ZSH/oh-my-zsh.sh" >> "$ZSHLOC"
    echo "source \$CS/oh-my-zsh/themes/cyberSpaceGhostV1.zsh-theme" >> "$ZSHLOC"
    echo "#[OwO] Insert the juice [OwO]" >> "$ZSHLOC"
    echo "source \"\$CS/core-config/index.sh\"" >> "$ZSHLOC"

    exit 0
fi

# ----------------------------
# Zsh runtime: Source functions
# ----------------------------
if [ -z "$CS" ]; then
    echo "Make sure to run this in ZSH, and with ZSH"
    exit;
fi
CS_func="$CS/core-config/functions"
CS_json="$CS/core-config/jsonFiles"

for func_file in "$CS_func"/*.sh; do
    source "$func_file"
done

echo "🎉 Ready to be used by you [OwO]"
