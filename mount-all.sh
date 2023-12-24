#!/usr/bin/env bash

# Unmount everything that's currently mounted
bash unmount-all.sh
echo "Done unmounting."

# Then mount everything
for file in "mount"/*; do
    if [ -f "$file" ]; then
        bash $file
    fi
done

echo "All filesystems mounted."
