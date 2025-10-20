#!/bin/bash

# Power menu script for i3
choice=$(echo -e "󰗽  Logout\n󰜉 Restart\n⏻  Shutdown" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/power-menu.rasi)

case "$choice" in
    "󰗽  Logout")
        i3-msg exit
        ;;
    "󰜉  Restart")
        sudo reboot
        ;;
    "⏻  Shutdown")
        sudo poweroff
        ;;
    *)
        exit 0
        ;;
esac
