# 🧠 DWM Setup (By Dennis Hilk)

A clean and modern DWM setup for **Debian 13 (Trixie)** and **Arch Linux Zen**.  
It features transparency, blur, rounded corners, Fish shell, Rofi launcher, PipeWire audio, and automatic GPU detection.  
Everything is stored inside `~/.config/dwm` — simple, fast, and hacker-friendly.

---

## 🚀 Features

- 🪶 Lightweight DWM desktop environment
- ✨ Blur, transparency and rounded corners via **Picom**
- 🧠 Auto-start DWM directly from **TTY1** (no startx)
- 🧩 Config files stored in `~/.config/dwm`
- 🐟 **Fish shell** with Fastfetch
- 🎨 **Rofi** dark Arch-blue theme
- 🔊 **PipeWire + WirePlumber** audio system
- ⚙️ **ZRAM** support
- 🎮 Auto GPU detection (**NVIDIA / AMD / Intel**)
- 💾 Works on both Debian 13 & Arch Linux Zen


## ⚙️ Installation

### 🧠 Debian 13

sudo ./install_debian13.sh

🐧 Arch Linux Zen

sudo ./install_arch_zen.sh

After installation:

Reboot

Log in on TTY1

DWM starts automatically 🎉

📦 Requirements
Package	Purpose
xorg, feh, picom, rofi, fish, pipewire	Core environment
build-essential / base-devel	for compiling DWM
git, curl, wget, fastfetch	utilities
zram-tools / zram-generator	compressed RAM swap

All required packages are installed automatically by the installers.


🧰 Customization

Change wallpaper → replace ~/.config/dwm/wallpaper.png

Edit blur/transparency → ~/.config/dwm/picom.conf

Change keybindings → edit config.def.h in DWM source

Modify Rofi theme → ~/.config/dwm/rofi/theme.rasi

Add your own startup scripts → ~/.config/dwm/autostart.sh
