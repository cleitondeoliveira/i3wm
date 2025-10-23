#!/bin/bash

# Power menu script
choice=$(printf "󰗽 Logout\n󰜉 Restart\n󰐥 Shutdown" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/power-menu.rasi)

case "$choice" in
    *"Logout"*)
        i3-msg exit
        ;;
    *"Restart"*)
        systemctl reboot
        ;;
    *"Shutdown"*)
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
