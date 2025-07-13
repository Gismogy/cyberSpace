# Init

if [ -z "$CS" ]; then
  ZSHLOC="$HOME/.zshrc"

  if [[ ! -f "$ZSHLOC" ]]; then
    echo "ZSH does not appear to be installed, or ~/.zshrc does not exist"
    # auto install ZSH later TODO
    exit 1
  else
    PDIRCORE="$(dirname "$(cd "$(dirname "$0")" && pwd)")"
    # init the default config 
    if [[ ! -d "$HOME/.oh-my-zsh"]] then
      echo "you havent installed oh my ZSH please do by searching it up : https://ohmyz.sh/#install "
    fi
    > $ZSHLOC
    echo "export ZSH=\"$HOME\"/.oh-my-zsh" >> "$ZSHLOC"
    echo "ZSH_THEME=ghostTheme" >> "$ZSHLOC"
    echo "plugins=(git)" >> "$ZSHLOC"
    echo "source $ZSH/oh-my-zsh.sh"
    # init own config
    echo "#[OwO] Insert the juice [OwO]" >>"$ZSHLOC"
    echo "export CS=\"$PDIRCORE\"" >>"$ZSHLOC"
    echo "source \"\$CS/core-config/index.sh\"" >>"$ZSHLOC"
    source "$ZSHLOC"
    exec zsh
  fi
fi

# init critical vars
CS_func="$CS/core-config/functions"
CS_json="$CS/core-config/jsonFiles"

# Source all functions
for func_file in $CS_func/*.sh; do
  source "$func_file"
done

echo "Ready to be used by you [OwO]"
