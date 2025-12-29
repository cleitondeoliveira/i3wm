# i3wm Dotfiles - Minimalist Setup

Clean and minimalist i3wm configuration with dark theme.

![Desktop](screenshots/screenshot-1.png)

## Features

- **WM:** i3-gaps
- **Bar:** Polybar
- **Compositor:** Picom
- **Terminals:** Ghostty (default), Kitty
- **Launcher:** dmenu + j4-dmenu-desktop
- **Power Menu:** Rofi
- **Lock:** i3lock-color
- **DM:** LightDM + mini-greeter
- **Theme:** GitHub Dark colors
- **Fonts:** Iosevka Nerd Font

## Quick Install

```bash
git clone <your-repo-url> ~/i3wm-dotfiles
cd ~/i3wm-dotfiles
chmod +x quick-setup.sh
./quick-setup.sh
```

This will:
1. Install all required packages (with confirmation)
2. Copy all dotfiles to `~/.config/`
3. Optionally setup LightDM display manager
4. Backup existing configs to `~/.config/backup/`

## Manual Installation

### 1. Install Packages

**Core packages:**
```bash
sudo pacman -S i3-gaps polybar picom dmenu j4-dmenu-desktop \
               rofi nitrogen dunst thunar firefox \
               flameshot pavucontrol nm-applet blueman \
               xautolock xorg-xrandr ttf-iosevka-nerd \
               ttf-jetbrains-mono-nerd
```

**Terminals:**
```bash
sudo pacman -S ghostty kitty
```

**AUR packages:**
```bash
yay -S i3lock-color lightdm-mini-greeter
```

**Optional:**
```bash
sudo pacman -S code  # VSCode
yay -S autotiling-rs  # Auto-tiling
```

### 2. Install Dotfiles

```bash
chmod +x install.sh
./install.sh
```

### 3. Setup Display Manager (Optional)

```bash
sudo ./lightdm/setup-lightdm.sh
```

### 4. Reload

Press `Mod+Shift+R` or logout and login again.

## Key Bindings

### Applications
| Key | Action |
|-----|--------|
| `Mod+Enter` | Terminal (Ghostty) |
| `Mod+Space` | App launcher (dmenu) |
| `Mod+F` | File manager |
| `Mod+Z` | VSCode |
| `Mod+B` | Browser |
| `Mod+P` | Audio control |
| `Print` | Screenshot |

### Windows
| Key | Action |
|-----|--------|
| `Mod+Arrows` | Navigate |
| `Mod+Shift+Arrows` | Move window |
| `Mod+V` | Split horizontal |
| `Mod+Shift+V` | Split vertical |
| `Mod+T` | Toggle floating |
| `Mod+Q` | Close window |

### Workspaces
| Key | Action |
|-----|--------|
| `Mod+1-5` | Switch workspace |
| `Mod+Shift+1-5` | Move to workspace |

### System
| Key | Action |
|-----|--------|
| `Mod+Shift+C` | Reload config |
| `Mod+Shift+R` | Restart i3 |
| `Mod+Shift+X` | Lock screen |
| `Mod+Escape` | Power menu (Rofi) |

## Customization

### Colors

Edit `~/.config/i3/config`:
```
set $bg-color            #0d1117
set $inactive-bg-color   #161b22
set $text-color          #c9d1d9
set $accent-color        #898989
set $border-color        #30363d
set $focused-border      #c9d1d9
```

Edit `~/.config/polybar/config.ini`:
```ini
[colors]
background = #0d1117
foreground = #c9d1d9
primary = #898989
alert = #da3633
```

### dmenu Colors

Edit `~/.config/i3/config` launcher line:
```bash
bindsym $mod+space exec j4-dmenu-desktop --dmenu="dmenu -i -nb '#0d1117' -nf '#c9d1d9' -sb '#898989' -sf '#0d1117' -fn 'Iosevka-11'"
```

### Polybar Modules

Edit modules in `~/.config/polybar/config.ini`:
```ini
modules-left = cpu temperature
modules-center = i3
modules-right = memory pulseaudio date battery
```

### Monitor Setup

Edit `~/.config/i3/config`:
```bash
# Laptop only
exec_always --no-startup-id xrandr --output eDP-1 --auto --primary

# External only (current config)
exec_always --no-startup-id xrandr --output eDP-1 --off --output HDMI-1 --auto --primary

# Dual monitors
exec_always --no-startup-id xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1
```

## Troubleshooting

### Polybar not starting
```bash
# Test polybar
~/.config/polybar/launch.sh

# Check polybar scripts permissions
chmod +x ~/.config/polybar/scripts/*.sh
```

### Fonts not rendering
```bash
fc-cache -fv
fc-list | grep -i iosevka
```

### i3lock not working
```bash
# Test lock script
~/.config/i3lock/lock.sh

# Install i3lock-color
yay -S i3lock-color
```

### LightDM issues
```bash
# Check if enabled
systemctl status lightdm

# Reconfigure
sudo ./lightdm/setup-lightdm.sh
```

## Repository Structure

```
i3wm/
├── i3/                    # i3 config + power menu
├── polybar/               # Polybar config + scripts
├── picom/                 # Compositor config
├── rofi/                  # App launcher themes
├── ghostty/               # Ghostty terminal config
├── kitty/                 # Kitty terminal config
├── i3lock/                # Lock screen script
├── nitrogen/              # Wallpaper manager config
├── lightdm/               # Display manager config
├── quick-setup.sh         # One-command full setup
├── install.sh             # Dotfiles installer
└── README.md
```

## What's Included

- **i3-gaps** with minimal borders (2px) and gaps (3px inner, 1px outer)
- **Polybar** with CPU, temp, memory, audio, battery, updates modules
- **Picom** for transparency (85% inactive), shadows, and smooth fading
- **dmenu + j4-dmenu-desktop** for ultra-minimal app launcher (top bar)
- **Rofi** for visual power menu (logout, restart, shutdown)
- **i3lock-color** with blur effect and clock display
- **LightDM mini-greeter** for ultra-minimal login screen
- **Ghostty** as default terminal (Catppuccin Mocha theme)
- **Kitty** as alternative terminal
- **GitHub Dark** color scheme throughout

## Credits

- Fonts: Iosevka Nerd Font, JetBrains Mono Nerd Font
- WM: i3-gaps
- Bar: Polybar
- Theme: GitHub Dark / Catppuccin Mocha

## License

MIT - Free to use and modify
