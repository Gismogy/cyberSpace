# ~/.core-config/index.sh

# Load all ENV Vars first
initJson="$HOME/cyberSpace/core-config/jsonFiles/export.json"

if [[ ! -f $initJson ]]; then
  echo "INIT CONFIG NOT FOUND ERROR"
  return 1
fi

# Loop through all key-value pairs in export.json
jq -r 'to_entries[] | "\(.key) \(.value)"' "$initJson" | while read -r key value; do
  # Optional: export as ENV var
  export "$key=$value"
  echo "Loaded: $key → $value"
done

# Source all functions
for func_file in $HOME/cyberSpace/core-config/functions/*.sh; do
  source "$func_file"
done

