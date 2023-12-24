#!/usr/bin/env bash

for file in "unmount"/*; do
    if [ -f "$file" ]; then
        bash $file
    fi
done
