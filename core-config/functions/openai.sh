function ai() {
  local config_dir="${CS_JSON:-$HOME/.config/cyberSpace}"
  local json_file="$config_dir/openai.json"

  mkdir -p "$config_dir"

  # Initialize JSON config if missing
  if [[ ! -f "$json_file" ]]; then
    echo '{"CONFIG":{"OPENAI_API_KEY":"","SYSTEM_MSG":"You are a helpful assistant."},"MEMORY":[]}' >| "$json_file"
  fi

  # Show config usage
  if [[ "$1" == "-c" ]]; then
    echo "Config points stored in JSON file:"
    echo "  OPENAI_API_KEY  - Your API key"
    echo "  SYSTEM_MSG      - System message start"
    echo "  MEMORY          - Chat memory array"
    echo
    echo "Usage:"
    echo "  ai              # interactive prompt"
    echo "  ai 'prompt'     # one-shot prompt"
    echo "  ai -clear       # clear memory only"
    echo "  ai -c           # show this info"
    return 0
  fi

  # Clear memory
  if [[ "$1" == "-clear" ]]; then
    jq '.MEMORY = []' "$json_file" >| "$json_file.tmp" && mv "$json_file.tmp" "$json_file"
    echo "Memory cleared in $json_file"
    return 0
  fi

  # Read config
  local json_data api_key system_msg
  json_data=$(<"$json_file")
  api_key=$(jq -r '.CONFIG.OPENAI_API_KEY // empty' <<< "$json_data")
  system_msg=$(jq -r '.CONFIG.SYSTEM_MSG // "You are a helpful assistant."' <<< "$json_data")

  if [[ -z "$api_key" ]]; then
    echo "Error: OPENAI_API_KEY is empty in $json_file CONFIG section."
    return 1
  fi

  # Get prompt
  local prompt="$*"
  if [[ -z "$prompt" ]]; then
    echo "Enter your prompt below. Press Ctrl+D when done:"
    prompt=$(</dev/stdin)
  fi

  if [[ -z "$prompt" ]]; then
    echo "Error: No prompt provided."
    return 1
  fi

  # Extract memory
  local memory_json messages_json
  memory_json=$(jq '.MEMORY' <<< "$json_data")

  # --- ✅ FIX: Use jq -Rs to safely encode multi-line prompt ---
  local prompt_json
  prompt_json=$(jq -Rs <<< "$prompt")

  messages_json=$(jq -n \
    --arg system "$system_msg" \
    --argjson memory "$memory_json" \
    --argjson user "$prompt_json" \
    '
    [{"role":"system","content":$system}] + $memory + [{"role":"user","content":$user}]
    ')

  # Debug: show the final JSON being sent
  # echo "-----"
  # echo "Messages JSON: $messages_json"
  # echo "-----"

  # Call OpenAI API
  local response reply
  response=$(curl -sS https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $api_key" \
    -d @- <<<"{
      \"model\": \"gpt-4o-mini\",
      \"messages\": $messages_json
    }")

  reply=$(echo "$response" | jq -r '.choices[0].message.content // "No response"')
  echo "$reply"

  # --- ✅ FIX: Use jq -Rs when saving memory to handle multi-line ---
  local updated_json user_escaped assistant_escaped
  user_escaped=$(jq -Rs <<< "$prompt")
  assistant_escaped=$(jq -Rs <<< "$reply")

  updated_json=$(jq \
    --argjson user "$user_escaped" \
    --argjson assistant "$assistant_escaped" \
    '.MEMORY += [{"role":"user","content":$user},{"role":"assistant","content":$assistant}]' <<< "$json_data")

  echo "$updated_json" >| "$json_file"
}
