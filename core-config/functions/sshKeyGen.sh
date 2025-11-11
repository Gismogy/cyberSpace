#!/bin/bash

sshKeyCreate() {
    BASE_DIR="$HOME/.ssh/autoKey"
    mkdir -p "$BASE_DIR" 2>/dev/null

    RANDOM_NUM=$(( RANDOM % 1000000000 ))  # between 0 and 999999999
    RANDOM_LETTERS=$(head /dev/urandom | tr -dc a-f0-9 | head -c 8) # 8 random hex letters
    FOLDER_NAME="${RANDOM_NUM}${RANDOM_LETTERS}"
    TARGET_DIR="$BASE_DIR/$FOLDER_NAME"

    mkdir -p "$TARGET_DIR" 2>/dev/null

    KEY_PATH="$TARGET_DIR/id_ed25519"

    ssh-keygen -t ed25519 -C "vCore auto Generated" -f "$KEY_PATH" -N "" -q >/dev/null 2>&1

    local json_file="$TARGET_DIR/metadata.json"

    local used="no"
    local ip_target="0.0.0.0"
    local mac="00:00:00:00:00:00"
    local location="unknown"
    local os=""
    local extra="none"

    # Write JSON file
    cat > "$json_file" <<EOF
{
    "used": "$used",
    "IP Target": "$ip_target",
    "Mac": "$mac",
    "Location": "$location",
    "OS": "$os",
    "Extra": "$extra"
}
EOF
  echo $FOLDER_NAME
}
clearSsh(){
  BASE_DIR="$HOME/.ssh"
  rm -r "$BASE_DIR/autoKey"
  mkdir "$BASE_DIR/autoKey"
}

linkPC() {
    local target="$1"
    local target_user="$2"
    local password="$3"

    if [ -z "$target_user" ] || [ -z "$target" ] || [ -z "$password" ]; then
        echo "Usage: linkPC <Port/IP> <user> <password>"
        return 1
    fi

    # Determine if target is IP or port
    local target_ip target_port
    if [[ "$target" == *.* ]]; then
        target_ip="$target"
        target_port=22
    else
        target_ip="localhost"
        target_port="$target"
    fi

    # Create/get SSH key
    local key key_path pub_path
    key=$(sshKeyCreate)
    key_path="$HOME/.ssh/autoKey/$key"
    pub_path=$(find "$key_path" -type f -name "*.pub" | head -n 1)

    if [ ! -f "$pub_path" ]; then
        echo "Public key not found in $key_path"
        return 1
    fi

    # Deploy SSH key
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no -p "$target_port" "$target_user@$target_ip" \
        "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no -p "$target_port" "$target_user@$target_ip" \
        "cat >> ~/.ssh/authorized_keys" < "$pub_path"
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no -p "$target_port" "$target_user@$target_ip" \
        "chmod 600 ~/.ssh/authorized_keys"

    echo "SSH key deployed successfully to $target_user@$target_ip:$target_port"

    # Fill metadata
    local json_file="$key_path/metadata.json"
    local used="yes"
    local mac
    mac=$(sshpass -p "$password" ssh -o StrictHostKeyChecking=no -p "$target_port" "$target_user@$target_ip" \
          "ip link | awk '/ether/ {print \$2; exit}'")  # get first MAC
    local os
    os=$(sshpass -p "$password" ssh -o StrictHostKeyChecking=no -p "$target_port" "$target_user@$target_ip" \
          "uname -a")
    local location="unknown"
    local extra="none"

    # Command to directly connect later
    local directConnectLINK="ssh -i \"$key_path/id_ed25519\" -p $target_port $target_user@$target_ip"

    # Update JSON
    cat > "$json_file" <<EOF
{
    "used": "$used",
    "IP Target": "$target_ip",
    "Mac": "$mac",
    "Location": "$location",
    "OS": "$os",
    "Extra": "$extra",
    "directConnectLINK": "$directConnectLINK"
}
EOF

  echo -n "Do you want to connect to this PC now? (yes/no): "
  read answer
  # convert to lowercase safely in zsh
  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

  if [[ "$answer" == "yes" || "$answer" == "y" ]]; then
      connectToPC "$key"
  fi
}

connectToPC() {
    local folder="$1"

    if [ -z "$folder" ]; then
        echo "Usage: connectToPC <folder_name>"
        return 1
    fi

    local json_file="$HOME/.ssh/autoKey/$folder/metadata.json"
    if [ ! -f "$json_file" ]; then
        echo "No metadata found for $folder"
        return 1
    fi

    # Read the directConnectLINK from JSON
    local cmd
    cmd=$(grep '"directConnectLINK":' "$json_file" | sed -E 's/.*"directConnectLINK": "(.*)".*/\1/')

    if [ -z "$cmd" ]; then
        echo "No directConnectLINK found in metadata."
        return 1
    fi

    echo "Connecting to $folder..."

    # Use eval to execute the command string
    eval "$cmd"
}