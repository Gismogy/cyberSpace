function fixJson() {
  local file="$CS_JSON/${1}.json"
  if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file"
    return 1
  fi

  echo "Validating and fixing: $file"

  # Use jq to safely re-encode all MEMORY[].content strings
  local fixed_json
  fixed_json=$(jq '
    .MEMORY |= map(
      if .content then
        .content |= @json | fromjson
      else
        .
      end
    )
  ' "$file") || {
    echo "Error: jq failed. Your JSON may be too broken."
    return 1
  }

  # Validate the result
  echo "$fixed_json" | jq . >/dev/null || {
    echo "Error: Fixed JSON is invalid!"
    return 1
  }

  echo "$fixed_json" >| "$file"
  echo "✅ JSON file fixed: $file"
}
