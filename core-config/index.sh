# ~/.core-config/index.sh

# Source all functions
for func_file in $HOME/cyberSpace/core-config/functions/*.sh; do
  source "$func_file"
done
# (Optional) Export config file path if you want
export CONFIG_FILES_JSON="$HOME/core-config/jsonFiles/config_files.json"

export CS_core="$CSpace/core-config"
export CS_func="$CSpace/core-config/functions"
export CS_json="$CSpace/core-config/jsonfiles"
