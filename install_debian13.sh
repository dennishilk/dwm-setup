#!/bin/bash
# =========================================================
# 🧠 DWM Setup Installer - Debian 13 (Trixie)
# GitHub Version – auto fetch from repo
# By Dennis Hilk
# =========================================================

set -e
echo "=== 🧠 Installing DWM Setup for Debian 13 (from GitHub) ==="
sleep 1

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo ./install_debian13.sh)"
  exit 1
fi

USER_NAME=$(logname)
USER_HOME=$(eval echo "~$USER_NAME")
CONFIG_DIR="$USER_HOME/.config/dwm"

# --- Packages ---
echo "=== 📦 Installing packages..."
apt update
apt install -y xorg feh alacritty fish rofi picom git build-essential \
  libx11-dev libxft-dev libxinerama-dev pipewire pipewire-audio \
  pipewire-pulse wireplumber zram-tools curl wget unzip nano fastfetch

# --- GPU detection ---
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

# --- Build DWM ---
echo "=== 🧱 Building DWM..."
cd /tmp
git clone https://git.suckless.org/dwm dwm-src
cd dwm-src
make clean && make && make install
cd /

# --- Download config from GitHub ---
echo "=== 🌐 Downloading latest DWM setup from GitHub..."
cd /tmp
wget -q https://github.com/dennishilk/dwm-setup/archive/refs/heads/main.zip -O dwm-setup.zip
unzip -q dwm-setup.zip
mkdir -p "$CONFIG_DIR"
cp -r /tmp/dwm-setup-main/dwm-setup/* "$CONFIG_DIR/"
chown -R "$USER_NAME:$USER_NAME" "$CONFIG_DIR"

# --- Enable autostart on TTY1 ---
BASH_PROFILE="$USER_HOME/.bash_profile"
if ! grep -q "exec dwm" "$BASH_PROFILE" 2>/dev/null; then
  echo 'if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec dwm; fi' >> "$BASH_PROFILE"
fi
chown "$USER_NAME:$USER_NAME" "$BASH_PROFILE"

echo "=== ✅ Installation complete!"
echo "Reboot and log in on TTY1 to start DWM automatically."
