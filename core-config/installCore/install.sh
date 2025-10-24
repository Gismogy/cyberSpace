# MINT
if grep -q '^ID=linuxmint' /etc/os-release; then
  # install the zsh auto
  apt update
  apt install -y zsh
else
  echo "error"
  exit 0;
fi


