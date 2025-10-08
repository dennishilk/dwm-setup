#!/bin/bash
while true; do
  CPU=$(awk -v freq=$(lscpu | awk '/MHz/ {print $3}') 'BEGIN {printf "%.1fGHz", freq/1000}')
  MEM=$(free -h | awk '/Mem/ {print $3 "/" $2}')
  GPU=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "-")
  DATE=$(date +"%H:%M %d.%m.%Y")
  xsetroot -name " CPU:$CPU | RAM:$MEM | GPU:$GPU°C | $DATE "
  sleep 5
done

