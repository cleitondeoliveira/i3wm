#!/bin/bash

# Quick Setup Script for i3wm Dotfiles
# One-command installation: packages, configs, and display manager

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }
print_section() { echo -e "\n${CYAN}=== $1 ===${NC}\n"; }

if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root!"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ""
echo "╔════════════════════════════════════════╗"
echo "║  i3wm Quick Setup - Minimalist Theme  ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check if pacman is available (Arch-based)
if ! command -v pacman &> /dev/null; then
    print_error "This script is designed for Arch-based distributions"
    exit 1
fi

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    print_warning "yay (AUR helper) is not installed"
    read -p "Install yay first? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Installing yay..."
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
        print_success "yay installed"
    else
        print_warning "Skipping AUR packages installation"
    fi
fi

# ============================================
# STEP 1: Install Packages
# ============================================

print_section "Package Installation"

# Core packages
CORE_PACKAGES=(
    "i3-gaps"
    "polybar"
    "picom"
    "dmenu"
    "j4-dmenu-desktop"
    "rofi"
    "nitrogen"
    "dunst"
    "thunar"
    "firefox"
    "flameshot"
    "pavucontrol"
    "nm-applet"
    "blueman"
    "xautolock"
    "xorg-xrandr"
    "ttf-iosevka-nerd"
    "ttf-jetbrains-mono-nerd"
)

# Optional packages
OPTIONAL_PACKAGES=(
    "ghostty"
    "kitty"
    "autotiling-rs"
    "code"
)

# AUR packages
AUR_PACKAGES=(
    "i3lock-color"
    "lightdm-mini-greeter"
)

echo "Core packages to install:"
printf '  - %s\n' "${CORE_PACKAGES[@]}"
echo ""
read -p "Install core packages? (Y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    print_info "Installing core packages..."
    sudo pacman -S --needed --noconfirm "${CORE_PACKAGES[@]}"
    print_success "Core packages installed"
else
    print_warning "Skipped core packages"
fi

echo ""
echo "Optional packages:"
printf '  - %s\n' "${OPTIONAL_PACKAGES[@]}"
echo ""
read -p "Install optional packages? (Y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    print_info "Installing optional packages..."
    for pkg in "${OPTIONAL_PACKAGES[@]}"; do
        if pacman -Si "$pkg" &> /dev/null; then
            sudo pacman -S --needed --noconfirm "$pkg" || print_warning "Failed to install $pkg"
        else
            print_warning "$pkg not found in repos, skipping"
        fi
    done
    print_success "Optional packages processed"
else
    print_warning "Skipped optional packages"
fi

if command -v yay &> /dev/null; then
    echo ""
    echo "AUR packages:"
    printf '  - %s\n' "${AUR_PACKAGES[@]}"
    echo ""
    read -p "Install AUR packages? (Y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        print_info "Installing AUR packages..."
        yay -S --needed --noconfirm "${AUR_PACKAGES[@]}" || print_warning "Some AUR packages failed"
        print_success "AUR packages processed"
    else
        print_warning "Skipped AUR packages"
    fi
fi

# ============================================
# STEP 2: Install Dotfiles
# ============================================

print_section "Dotfiles Installation"

echo "This will backup existing configs to ~/.config/backup/"
echo ""
read -p "Install dotfiles? (Y/n): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    bash "$SCRIPT_DIR/install.sh"
else
    print_warning "Skipped dotfiles installation"
fi

# ============================================
# STEP 3: Display Manager Setup
# ============================================

print_section "Display Manager Setup"

echo "Configure LightDM with mini-greeter?"
echo "This provides a minimalist login screen matching your i3 theme"
echo ""
read -p "Setup LightDM? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Setting up LightDM..."
    sudo bash "$SCRIPT_DIR/lightdm/setup-lightdm.sh"
else
    print_info "Skipped LightDM setup"
    echo "You can run it later with: sudo ./lightdm/setup-lightdm.sh"
fi

# ============================================
# STEP 4: Final Steps
# ============================================

print_section "Final Steps"

echo "Recommended next steps:"
echo ""
echo "1. Set wallpaper:"
echo "   nitrogen"
echo ""
echo "2. Reload i3 or logout:"
echo "   - Press Mod+Shift+R (if in i3)"
echo "   - Or logout and login again"
echo ""
echo "3. Check polybar scripts permissions:"
echo "   chmod +x ~/.config/polybar/scripts/*"
echo ""

if [ -f ~/.config/polybar/scripts/aur-updates.sh ]; then
    chmod +x ~/.config/polybar/scripts/*.sh 2>/dev/null || true
    print_success "Polybar scripts made executable"
fi

echo ""
echo "╔════════════════════════════════════════╗"
echo "║      Setup Complete!                   ║"
echo "╚════════════════════════════════════════╝"
echo ""
print_success "Your minimalist i3wm environment is ready!"
echo ""

# Show what was installed
echo "Configuration summary:"
echo "  - Window Manager: i3-gaps"
echo "  - Status Bar: Polybar"
echo "  - Compositor: Picom"
echo "  - Launcher: Rofi"
echo "  - Terminals: Ghostty, Kitty"
echo "  - Lock Screen: i3lock-color"
if systemctl is-enabled lightdm.service &> /dev/null; then
    echo "  - Display Manager: LightDM (enabled)"
fi
echo ""
echo "Enjoy your setup! 🚀"
echo ""
