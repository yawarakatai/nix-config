#!/usr/bin/env bash
# Launch eww dashboard

# Kill any existing eww instances
pkill eww

# Launch eww daemon
eww daemon &

# Wait a moment for daemon to start
sleep 1

# Open the dashboard window
eww open dashboard

echo "Eww dashboard launched!"
echo "To close: eww close dashboard"
echo "To kill daemon: pkill eww"
