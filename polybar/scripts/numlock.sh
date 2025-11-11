#!/bin/bash

# Check if Num Lock is on
status=$(xset q | grep "Num Lock" | awk '{print $8}')

if [ "$status" = "on" ]; then
    echo "NUM"
else
    echo ""
fi
