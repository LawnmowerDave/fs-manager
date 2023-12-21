#!/usr/bin/env bash

# Unmount everything that's currently mounted
ps aux | grep -i sftp | grep -v grep | while read line; do 
    server=$(echo "$line" | sed -n 's/.*-2 .*@\([^[:space:]]*\).*/\1/p')

    filepath="unmount/$server"
    
    if test -f "$filepath"; then
        bash $filepath
    fi
done

echo "Done unmounting.\n"

# Then mount everything
for file in "mount"/*; do
    if [ -f "$file" ]; then
        bash $file
    fi
done

echo "All filesystems mounted.\n"
