#!/bin/bash
# 🧠 DWM Autostart Script
feh --bg-scale ~/.config/dwm/wallpaper.png &
picom --experimental-backends --config ~/.config/dwm/picom.conf &
~/.config/dwm/status.sh &
pipewire & wireplumber &

