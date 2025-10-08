#!/bin/bash
# =========================================================
# 🧠 DWM Setup Installer - Arch Linux (Zen)
# GitHub version - auto fetch from repo
# By Dennis Hilk
# =========================================================

set -e

echo "=== 🧠 Installing DWM Setup for Arch Linux (from GitHub) ==="
sleep 1

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo ./install_arch_zen.sh)"
  exit 1
fi

USER_NAME=$(logname)
USER_HOME=$(eval echo "~$USER_NAME")
CONFIG_DIR="$USER_HOME/.config/dwm"

# --- Install dependencies ---
echo "=== 📦 Installing packages..."
pacman -Syu --noconfirm
pacman -S --noconfirm base-devel xorg-server xorg-xinit feh alacritty fish rofi picom git \
pipewire pipewire-audio pipewire-pulse wireplumber zram-generator curl wget unzip nano fastfetch linux-zen linux-zen-headers

# --- GPU detection ---
echo "=== 🔍 Detecting GPU..."
if lspci | grep -E "NVIDIA|GeForce"; then
  echo "NVIDIA GPU detected"
  pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
elif lspci | grep -E "Radeon|AMD"; then
  echo "AMD GPU detected"
  pacman -S --noconfirm xf86-video-amdgpu
elif lspci | grep -E "Intel"; then
  echo "Intel GPU detected"
  pacman -S --noconfirm mesa
else
  echo "⚠️  No known GPU found"
fi

# --- Enable ZRAM ---
echo -e "[zram0]\nzram-size = ram / 2\ncompression-algorithm = zstd" > /etc/systemd/zram-generator.conf
systemctl enable --now systemd-zram-setup@zram0.service || true

# --- Build DWM ---
echo "=== 🧱 Building DWM..."
cd /tmp
git clone https://git.suckless.org/dwm dwm-src
cd dwm-src
make clean && make && make install
cd /

# --- Fetch configuration from GitHub ---
echo "=== 🌐 Downloading latest DWM setup from GitHub..."
cd /tmp
wget -q https://github.com/dennishilk/dwm-setup/archive/refs/heads/main.zip -O dwm-setup.zip
unzip -q dwm-setup.zip
mkdir -p "$CONFIG_DIR"
cp -r /tmp/dwm-setup-main/dwm-setup/* "$CONFIG_DIR/"
chown -R "$USER_NAME:$USER_NAME" "$CONFIG_DIR"

# --- Autostart on TTY1 ---
BASH_PROFILE="$USER_HOME/.bash_profile"
if ! grep -q "exec dwm" "$BASH_PROFILE" 2>/dev/null; then
  echo 'if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec dwm; fi' >> "$BASH_PROFILE"
fi
chown "$USER_NAME:$USER_NAME" "$BASH_PROFILE"

echo "=== ✅ Installation complete!"
echo "Reboot and log in on TTY1 to start DWM automatically."
