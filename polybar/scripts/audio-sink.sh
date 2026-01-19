#!/bin/bash

# Function to get current sink
get_current_sink() {
    pactl get-default-sink
}

# Function to get friendly sink name
get_sink_description() {
    local sink=$1
    pactl list sinks | grep -A 1 "Name: $sink" | grep "Description:" | sed 's/.*Description: //'
}

# Function to get a short name with icon
get_short_name() {
    local desc="$1"
    case "$desc" in
        *"Headphones"*)
            echo " Headphones"
            ;;
        *"HDMI"*)
            echo "󱡫 HDMI"
            ;;
        *"Speaker"*|*"Speakers"*)
            echo " Speakers"
            ;;
        *"USB"*|*"ME6S"*)
            echo "  USB"
            ;;
        *)
            echo " Audio"
            ;;
    esac
}

# Left click: open menu to select
if [[ "${1}" == "menu" ]]; then
    # Get list of available sinks
    sinks=$(pactl list sinks short | awk '{print $2}')

    # Create menu with rofi
    declare -A sink_map
    menu_items=""

    while IFS= read -r sink; do
        desc=$(get_sink_description "$sink")
        short=$(get_short_name "$desc")
        menu_items+="$short - $desc\n"
        sink_map["$short - $desc"]="$sink"
    done <<< "$sinks"

    # Show menu and get selection
    selected=$(echo -e "$menu_items" | rofi -dmenu -i -p "Audio Output" -theme ~/.config/rofi/power-menu.rasi)

    if [[ -n "$selected" ]]; then
        new_sink="${sink_map[$selected]}"
        pactl set-default-sink "$new_sink"

        # Move all audio streams to the new sink
        pactl list short sink-inputs | awk '{print $1}' | while read -r stream; do
            pactl move-sink-input "$stream" "$new_sink" 2>/dev/null
        done
    fi
    exit 0
fi

# Always show current output
current_sink=$(get_current_sink)
current_desc=$(get_sink_description "$current_sink")
short_name=$(get_short_name "$current_desc")
echo "$short_name"
