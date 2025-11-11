#!/bin/bash

# Check if Caps Lock is on
status=$(xset q | grep "Caps Lock" | awk '{print $4}')

if [ "$status" = "on" ]; then
    echo "CAPS"
else
    echo ""
fi
