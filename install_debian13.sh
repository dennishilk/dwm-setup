#!/bin/bash
# =========================================================
# 🧠 DWM Setup Installer - Debian 13 (Trixie)
# By Dennis Hilk
# =========================================================

set -e

echo "=== 🧠 Installing DWM Setup for Debian 13 ==="
sleep 1

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo ./install_debian13.sh)"
  exit 1
fi

USER_NAME=$(logname)
USER_HOME=$(eval echo "~$USER_NAME")
CONFIG_DIR="$USER_HOME/.config/dwm"

echo "=== 📦 Installing base packages..."
apt update
apt install -y xorg feh alacritty fish rofi picom git build-essential \
  libx11-dev libxft-dev libxinerama-dev pipewire pipewire-audio \
  pipewire-pulse wireplumber zram-tools curl wget unzip nano fastfetch

# GPU detection
echo "=== 🔍 Detecting GPU..."
if lspci | grep -E "NVIDIA|GeForce"; then
  echo "NVIDIA GPU detected"
  apt install -y nvidia-driver nvidia-settings
elif lspci | grep -E "Radeon|AMD"; then
  echo "AMD GPU detected"
  apt install -y firmware-amd-graphics
elif lspci | grep -E "Intel"; then
  echo "Intel GPU detected"
  apt install -y intel-microcode
else
  echo "⚠️  No known GPU found"
fi

# DWM build
echo "=== 🧱 Building DWM..."
cd /tmp
git clone https://git.suckless.org/dwm dwm-src
cd dwm-src
make clean && make && make install
cd /

# === 🔍 Find and copy DWM setup files ===
echo "=== 🔍 Locating dwm-setup directory..."
INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -d "$INSTALL_DIR/dwm-setup" ]; then
  echo "Found: $INSTALL_DIR/dwm-setup"
  cp -r "$INSTALL_DIR/dwm-setup/"* "$CONFIG_DIR/"
elif [ -d "$INSTALL_DIR/../dwm-setup" ]; then
  echo "Found: $INSTALL_DIR/../dwm-setup"
  cp -r "$INSTALL_DIR/../dwm-setup/"* "$CONFIG_DIR/"
else
  echo "⚠️  Could not find the dwm-setup directory!"
  echo "Please make sure the folder 'dwm-setup/' exists next to this installer."
  exit 1
fi

chown -R "$USER_NAME:$USER_NAME" "$CONFIG_DIR"


# Autostart at login
BASH_PROFILE="$USER_HOME/.bash_profile"
if ! grep -q "exec dwm" "$BASH_PROFILE" 2>/dev/null; then
  echo 'if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec dwm; fi' >> "$BASH_PROFILE"
fi
chown "$USER_NAME:$USER_NAME" "$BASH_PROFILE"

echo "=== ✅ Installation complete!"
echo "Reboot and login on TTY1 to start DWM automatically."

