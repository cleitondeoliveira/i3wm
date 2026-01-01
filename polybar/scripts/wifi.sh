#!/bin/bash

# Get WiFi status
wifi_status=$(nmcli -t -f DEVICE,TYPE,STATE device | grep wifi)

if echo "$wifi_status" | grep -q ":connected"; then
    # Get connected network name
    ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
    if [ -n "$ssid" ]; then
        echo "  $ssid"
    else
        echo "󰖩 Connected"
    fi
elif echo "$wifi_status" | grep -q ":disconnected"; then
    echo "󱚼 Disconnected"
elif echo "$wifi_status" | grep -q ":unavailable"; then
    echo "󱚵 Unavailable"
else
    echo "  Off"
fi
