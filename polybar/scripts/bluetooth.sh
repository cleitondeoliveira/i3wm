#!/bin/bash

# Check if bluetooth is powered on
bluetooth_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$bluetooth_status" = "yes" ]; then
    # Check if any device is connected
    connected=$(bluetoothctl devices Connected | wc -l)
    if [ "$connected" -gt 0 ]; then
        device_name=$(bluetoothctl devices Connected | head -n1 | cut -d' ' -f3-)
        echo "󰂯 $device_name"
    else
        echo "󰂯 On"
    fi
else
    echo "󰂯 Off"
fi
