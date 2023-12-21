#!/usr/bin/env bash

# Function to convert SSH config to sshfs command
convert_ssh_to_sshfs() {
  local host=$1
  local ssh_config_file=$2

  local hostname
  local user
  local port
  local identity_file

  # Read SSH config and extract necessary information for the given host
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^Host\ $host || ( "$line" =~ ^HostName && -z "$hostname" ) ]]; then
      hostname=$(echo "$line" | awk '{print $2}')
    elif [[ "$line" =~ ^User && -z "$user" ]]; then
      user=$(echo "$line" | awk '{print $2}')
    elif [[ "$line" =~ ^Port && -z "$port" ]]; then
      port=$(echo "$line" | awk '{print $2}')
    elif [[ "$line" =~ ^IdentityFile && -z "$identity_file" ]]; then
      identity_file=$(echo "$line" | awk '{print $2}')
    fi
  done < "$ssh_config_file"

  # Check if all required parameters were found
  if [[ -n "$hostname" && -n "$user" && -n "$port" ]]; then
    sshfs_command="sshfs -o IdentityFile=$identity_file \
      -p $port \
      -o volname=$host \
      -o reconnect \
      -o ServerAliveInterval=15 \
      -o ServerAliveCountMax=3 \
      -o idmap=user \
      -o auto_xattr \
      -o dev \
      -o suid \
      -o defer_permissions \
      -o noappledouble \
      -o noapplexattr \
      -o auto_cache \
      -o no_readahead \
      -o nolocalcaches \
      -o noappledouble \
      $user@$hostname:/path/to/remote/directory /path/to/local/mount/point"

    echo "$sshfs_command"
  else
    echo "Error: Host information incomplete or not found."
    exit 1
  fi
}

# Example usage:
convert_ssh_to_sshfs "dash.magnusbox.com" "/path/to/your/ssh/config/file"

