#!/bin/bash

# Dotfiles installation script
# Mars Theme i3 Configuration

set -e

echo "======================================"
echo "  Dotfiles Installation - Mars Theme  "
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root!"
    exit 1
fi

echo "This script will install the dotfiles configuration."
echo "Your existing configs will be backed up to ~/.config/backup/"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Create backup directory
echo ""
echo "Creating backup of existing configurations..."
mkdir -p ~/.config/backup
timestamp=$(date +%Y%m%d_%H%M%S)

# Backup existing configs
if [ -d ~/.config/i3 ]; then
    mv ~/.config/i3 ~/.config/backup/i3_$timestamp
    print_success "Backed up i3 config"
fi

if [ -d ~/.config/polybar ]; then
    mv ~/.config/polybar ~/.config/backup/polybar_$timestamp
    print_success "Backed up polybar config"
fi

if [ -d ~/.config/picom ]; then
    mv ~/.config/picom ~/.config/backup/picom_$timestamp
    print_success "Backed up picom config"
fi

if [ -d ~/.config/nitrogen ]; then
    mv ~/.config/nitrogen ~/.config/backup/nitrogen_$timestamp
    print_success "Backed up nitrogen config"
fi

# Create config directories
echo ""
echo "Creating configuration directories..."
mkdir -p ~/.config/{i3,polybar/scripts,picom,nitrogen}
print_success "Directories created"

# Install i3 config
echo ""
echo "Installing i3 configuration..."
cp i3/config ~/.config/i3/config
cp i3/power-menu.sh ~/.config/i3/power-menu.sh
chmod +x ~/.config/i3/power-menu.sh
print_success "i3 config installed"

# Install polybar config
echo ""
echo "Installing polybar configuration..."
cp polybar/config.ini ~/.config/polybar/config.ini
cp polybar/launch.sh ~/.config/polybar/launch.sh
chmod +x ~/.config/polybar/launch.sh
print_success "Polybar config installed"

# Install polybar scripts (optional)
if [ -f polybar/scripts/bluetooth.sh ]; then
    cp polybar/scripts/bluetooth.sh ~/.config/polybar/scripts/bluetooth.sh
    chmod +x ~/.config/polybar/scripts/bluetooth.sh
    print_success "Polybar scripts installed"
fi

# Install picom config
echo ""
echo "Installing picom configuration..."
cp picom/picom.conf ~/.config/picom/picom.conf
print_success "Picom config installed"

# Install nitrogen config
echo ""
echo "Installing nitrogen configuration..."
cp nitrogen/nitrogen.cfg ~/.config/nitrogen/nitrogen.cfg
cp nitrogen/bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
print_success "Nitrogen config installed"

# SDDM config (requires root)
echo ""
echo "Installing SDDM configuration (requires sudo)..."
if sudo cp sddm/sddm.conf /etc/sddm.conf 2>/dev/null; then
    print_success "SDDM config installed"
else
    print_warning "Could not install SDDM config (requires sudo)"
fi

# Check for wallpaper
echo ""
if [ ! -f ~/Pictures/wallpapers/wallhaven-zm387v.jpg ]; then
    print_warning "Wallpaper not found at ~/Pictures/wallpapers/wallhaven-zm387v.jpg"
    echo "  You can set a wallpaper using nitrogen after installation."
fi

# Summary
echo ""
echo "======================================"
echo "  Installation Complete!              "
echo "======================================"
echo ""
print_success "All configurations have been installed"
echo ""
echo "Next steps:"
echo "  1. Set your wallpaper with: nitrogen"
echo "  2. Reload i3 with: Mod+Shift+R"
echo "  3. Or logout and login again"
echo ""
echo "Backups saved in: ~/.config/backup/"
echo ""
