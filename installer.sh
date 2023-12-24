#!/bin/bash


if [ ! -d "mount" ]; then
    mkdir mount
fi

if [ ! -d "unmount" ]; then
    mkdir unmount
fi

echo "What filesystem would you like to install?"
echo "1. SSHFS (More stable)"
echo "2. OXFS (Faster)"

read -r choice

# SSHFS
if [ "$choice" -eq 1 ]; then

    if ! command -v sshfs &> /dev/null
    then
        echo "SSHFS not detected, installing..."
        brew install sshfs
    fi
    
# OXFS
elif [ "$choice" -eq 2 ]; then

    if ! command -v oxfs &> /dev/null
    then
        mkdir ~/.venv
        python3 -m venv ~/.venv/oxfs
        source ~/.venv/oxfs/bin/activate
        pip3 install oxfs
    fi

else 
    echo "Choice $choice does not exist."
    exit 1
fi

