function edit() {
  local key=$1
  local json_name=$2

  if [[ -z "$key" ]]; then
    echo "Usage: edit <key> [json_file]"
    return 1
  fi

  if [[ -z "$json_name" ]]; then
    json_name="edit.json"  # default JSON file
  fi

  local json_file="$CS_CORE/jsonFiles/$json_name"
  if [[ ! -f $json_file ]]; then
    echo "JSON config file not found: $json_file"
    return 1
  fi

  local file_path=$(jq -r --arg key "$key" '.[$key]' "$json_file")
  if [[ "$file_path" == "null" ]]; then
    echo "No entry for '$key' in $json_file"
    return 1
  fi

  file_path="${file_path/#\~/$HOME}"
  ${EDITOR:-nano} "$file_path"
}
