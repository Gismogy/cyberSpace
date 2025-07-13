function edit() {

  echo "this function is not ready, exiting"
  return

  local key=$1
  local json_name=$2

  local json_file="$CS_json/edit.json"
  if [[ ! -f $json_file ]]; then
    echo "JSON config file not found: $json_file"
    return 1
  fi

  local file_path=$(jq -r --arg key "$key" '.[$key]' "$json_file")
  if [[ "$file_path" == "null" ]]; then
    echo "No entry for '$key' in $json_file"
    return 1
  fi

  echo file_path

  file_path="${file_path/#\~/$HOME}"
  ${EDITOR:-nvim} "$file_path"
}
