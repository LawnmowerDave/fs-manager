#!/usr/bin/env bash

echo "--- Active sshfs mounts ---"
ps aux | grep -i sftp | grep -v grep | while read line; do 
    server=$(echo "$line" | sed -n 's/.*-2 .*@\([^[:space:]]*\).*/\1/p')

    echo "$server"
done

echo "--- END ---"

