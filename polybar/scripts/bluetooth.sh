#!/bin/bash

# Check if bluetoothctl is installed
if ! command -v bluetoothctl &> /dev/null; then
    echo ""
    exit 0
fi

# Check if bluetooth is powered on
if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    # Check if devices are connected
    devices_connected=$(bluetoothctl devices Connected 2>/dev/null | wc -l)

    if [ $devices_connected -gt 0 ]; then
        echo "ON ($devices_connected)"
    else
        echo "ON"
    fi
else
    echo "OFF"
fi
