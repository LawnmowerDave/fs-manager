#!/usr/bin/env bash

echo "--- Active sshfs mounts ---"
ps aux | grep -i sftp | grep -v grep | while read line; do 
    server=$(echo "$line" | sed -n 's/.*-2 .*@\([^[:space:]]*\).*/\1/p')

    echo "$server"
done

echo "--- Active oxfs mounts ---"

ps -A | grep "oxfs" | while read -r line; do
    echo ""
    echo "$line"
done

echo "--- END ---"

