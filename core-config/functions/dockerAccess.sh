function fixAccess() {
  if [[ "$1" == "own" ]]; then
    echo "Owning now: user"
    chown -R floyd "$2"
  elif [[ "$1" == "access" ]]; then
    echo "Giving user access"
    chmod -R u+rwX "$2"
  else
    echo "Unknown command: $1"
  fi
}
