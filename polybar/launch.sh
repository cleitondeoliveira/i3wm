#!/bin/bash

# Terminate all running polybar instances
killall -q polybar

# Wait until all processes are terminated
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched..."
