# Store previous dir for comparison
LAST_DIR=""

splits() {
  if [[ "$PWD" == "$LAST_DIR" ]]; then
    return  # same dir, do nothing
  fi

  # Save current dir for next time
  LAST_DIR="$PWD"

  # Now split and do your thing
  IFS="/" read -rA PARTS <<< "$PWD"

  echo "New directory:"
  for i in "${PARTS[@]}"; do
    [[ -z "$i" ]] && continue
    echo "$i"
  done
}

powerline(){

local parts=($(splits))



}
# Hook it up to precmd
precmd_functions+=(splits)
