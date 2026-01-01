#!/bin/bash

# Check if Flameshot is running
if pgrep -x "flameshot" > /dev/null; then
    echo "󰹑 "
else
    echo " "
fi
