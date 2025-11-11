#!/bin/bash

# Check for AUR updates
if ! command -v yay &> /dev/null; then
    echo ""
    exit
fi

updates=$(yay -Qu 2>/dev/null | wc -l)

if [ "$updates" -gt 0 ]; then
    echo " $updates"
else
    echo ""
fi
