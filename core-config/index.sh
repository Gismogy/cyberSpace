#!/bin/sh

# Init
# SH HERE ONLY

ZSHLOC="$HOME/.zshrc"

if [ ! -f "$ZSHLOC" ]; then
  echo "ZSH does not appear to be installed, or ~/.zshrc does not exist"
  # auto install ZSH later TODO
  exit 1
fi

if [ "$(head -n 1 "$ZSHLOC")" != "#[UwU]" ]; then
  PDIRCORE="$(dirname "$(cd "$(dirname "$0")" && pwd)")"

  : > "$ZSHLOC"
  echo "#[UwU]" >> "$ZSHLOC"
  echo "export ZSH=\"\$HOME/.oh-my-zsh\"" >> "$ZSHLOC"
  echo "export CS=\"$PDIRCORE\"" >> "$ZSHLOC"  
  echo "ZSH_THEME=" >> "$ZSHLOC"
  echo "plugins=(git)" >> "$ZSHLOC"
  echo "source \$ZSH/oh-my-zsh.sh" >> "$ZSHLOC"
  echo "source \$CS/oh-my-zsh/themes/cyberSpaceGhostV1.zsh-theme" >> "$ZSHLOC"
  # Init own config
  echo "#[OwO] Insert the juice [OwO]" >> "$ZSHLOC"
  echo "source \"\$CS/core-config/index.sh\"" >> "$ZSHLOC"
  echo "Please run the command with zsh now"
  exit 0
fi

if [ "$ZSH_NAME" != "zsh" ]; then
  echo "Please run this file with ZSH! Installation is probably done."
  exit 1
fi

# FROM HERE ON OUT ITS ZSH

# Init critical vars
CS_func="$CS/core-config/functions"
CS_json="$CS/core-config/jsonFiles"

# Source all functions
for func_file in "$CS_func"/*.sh; do
  source "$func_file"
done

echo "Ready to be used by you [OwO]"

