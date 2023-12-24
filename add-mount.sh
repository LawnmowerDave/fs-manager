#!/usr/bin/env bash

echo "Please enter the name of an existing SSH host in your ~/.ssh/config file."
read -r ssh_host

# Get relevant SSH configuration variables for the specified host
ssh_config=$(awk -v host="$ssh_host" '
    BEGIN { RS = "\n\n"; ORS = "\n\n" }
    $1 == "Host" && $2 == host { print }
' ~/.ssh/config)

if [[ -z "$ssh_config" ]]; then
    echo "SSH configuration $ssh_host doesn't exist. "
    exit
fi

# Extract Port, Hostname, and IdentityFile
user=$(echo "$ssh_config" | awk '/User/ {print $2}')
port=$(echo "$ssh_config" | awk '/Port/ {print $2}')
hostname=$(echo "$ssh_config" | awk '/HostName/ {print $2}')
identity_file=$(echo "$ssh_config" | awk '/IdentityFile/ {print $2}')

if [[ -z "$port" ]]; then
    port="22"
fi

# --- Debug information ---
echo ""
echo "SSH Configuration for Host"
echo "------------------------------------"
echo "User: $user"
echo "Port: $port"
echo "Hostname: $hostname"
echo "IdentityFile: $identity_file"

sshkey_opt=""
#
# config specified identity file
if [[ ! -z "$identity_file" ]]; then
    sshkey_opt_oxfs="--ssh-key=$identity_file"
fi

echo ""
echo "Where would you like this filesystem to be mounted? (~/filesystems/$hostname)"
read -r mount_point

if [[ -z $mount_point ]]; then
    mkdir -p ~/filesystems 
    mount_point="~/filesystems/$hostname"
fi

echo "What type of filesystem would you like this to be? [sshfs, oxfs] (oxfs default)"
read -r fs_type

if [[ -z $fs_type ]]; then
    fs_type="oxfs"
fi

if [ "$fs_type" = "oxfs" ]; then
    oxfs_command="oxfs --host $user@$hostname --ssh-port $port $sshkey_opt_oxfs --mount-point $mount_point --cache-path ~/.oxfs --logging /tmp/oxfs.log --daemon --auto-cache"

    echo "source ~/.venv/oxfs/bin/activate" > mount/$hostname
    echo "$oxfs_command" >> mount/$hostname
    chmod +x mount/$hostname
    echo "diskutil unmount force $mount_point" > unmount/$hostname
    chmod +x unmount/$hostname
    echo "Successfully added oxfs config"

elif [ "$fs_type" = "sshfs" ]; then

    sshfs_command="sshfs -o IdentityFile=$identity_file -p $port -o volname=$hostname -o reconnect -o ServerAliveInterval=15 -o ServerAliveCountMax=3 -o idmap=user -o auto_xattr -o dev -o suid -o defer_permissions -o noappledouble -o noapplexattr -o auto_cache -o no_readahead -o nolocalcaches -o noappledouble $user@$hostname $sshkey_opt"

    echo "$sshfs_command" > mount/$hostname
    chmod +x mount/$hostname
    echo "diskutil unmount force $mount_point" > unmount/$hostname
    chmod +x unmount/$hostname
    echo "Successfully added sshfs config"
else 
    echo "$fs_type is not a valid option!"
fi
