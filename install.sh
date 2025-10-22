#!/bin/bash

# i3wm Dotfiles Installation Script
# Minimalist Dark Theme

set -e

echo "=========================================="
echo "  i3wm Dotfiles Installation"
echo "  Minimalist Dark Theme"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root!"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "This script will install the i3wm dotfiles configuration."
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
print_info "Creating backup of existing configurations..."
mkdir -p ~/.config/backup
timestamp=$(date +%Y%m%d_%H%M%S)

# Backup existing configs
backup_config() {
    local config_name=$1
    if [ -d ~/.config/$config_name ]; then
        mv ~/.config/$config_name ~/.config/backup/${config_name}_${timestamp}
        print_success "Backed up $config_name config"
    fi
}

backup_config "i3"
backup_config "i3blocks"
backup_config "picom"
backup_config "rofi"
backup_config "kitty"
backup_config "i3lock"

# Create config directories
echo ""
print_info "Creating configuration directories..."
mkdir -p ~/.config/{i3,i3blocks,picom,rofi,kitty,i3lock}
print_success "Directories created"

# Install i3 config
echo ""
print_info "Installing i3 configuration..."
if [ -d "$SCRIPT_DIR/i3" ]; then
    cp "$SCRIPT_DIR/i3/config" ~/.config/i3/config
    if [ -f "$SCRIPT_DIR/i3/power-menu.sh" ]; then
        cp "$SCRIPT_DIR/i3/power-menu.sh" ~/.config/i3/power-menu.sh
        chmod +x ~/.config/i3/power-menu.sh
    fi
    print_success "i3 config installed"
else
    print_error "i3 config directory not found!"
fi

# Install i3blocks config
echo ""
print_info "Installing i3blocks configuration..."
if [ -f "$SCRIPT_DIR/i3blocks/config" ]; then
    cp "$SCRIPT_DIR/i3blocks/config" ~/.config/i3blocks/config
    print_success "i3blocks config installed"

    # Check if i3blocks-contrib is needed
    if [ ! -d ~/.config/i3blocks/scripts ]; then
        print_warning "i3blocks scripts not found. You may need to install i3blocks-contrib:"
        echo "  git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3blocks/scripts"
    fi
else
    print_error "i3blocks config not found!"
fi

# Install picom config
echo ""
print_info "Installing picom configuration..."
if [ -f "$SCRIPT_DIR/picom/picom.conf" ]; then
    cp "$SCRIPT_DIR/picom/picom.conf" ~/.config/picom/picom.conf
    print_success "Picom config installed"
else
    print_error "Picom config not found!"
fi

# Install rofi config
echo ""
print_info "Installing rofi configuration..."
if [ -f "$SCRIPT_DIR/rofi/config.rasi" ]; then
    cp "$SCRIPT_DIR/rofi/config.rasi" ~/.config/rofi/config.rasi
    print_success "Rofi config installed"
else
    print_error "Rofi config not found!"
fi

# Install kitty config
echo ""
print_info "Installing kitty configuration..."
if [ -f "$SCRIPT_DIR/kitty/kitty.conf" ]; then
    cp "$SCRIPT_DIR/kitty/kitty.conf" ~/.config/kitty/kitty.conf
    print_success "Kitty config installed"
else
    print_error "Kitty config not found!"
fi

# Install i3lock config
echo ""
print_info "Installing i3lock configuration..."
if [ -f "$SCRIPT_DIR/i3lock/lock.sh" ]; then
    cp "$SCRIPT_DIR/i3lock/lock.sh" ~/.config/i3lock/lock.sh
    chmod +x ~/.config/i3lock/lock.sh
    print_success "i3lock config installed"
else
    print_error "i3lock config not found!"
fi

# Check dependencies
echo ""
print_info "Checking dependencies..."

check_dependency() {
    if command -v $1 &> /dev/null; then
        print_success "$1 is installed"
    else
        print_warning "$1 is NOT installed"
    fi
}

echo ""
echo "Core dependencies:"
check_dependency "i3"
check_dependency "i3blocks"
check_dependency "picom"
check_dependency "rofi"
check_dependency "kitty"
check_dependency "i3lock"
check_dependency "nitrogen"
check_dependency "dunst"
check_dependency "flameshot"
check_dependency "pavucontrol"

echo ""
echo "Optional dependencies:"
check_dependency "autotiling-rs"
check_dependency "zeditor"

# Check fonts
echo ""
print_info "Checking fonts..."
if fc-list | grep -i "iosevka" > /dev/null; then
    print_success "Iosevka font is installed"
else
    print_warning "Iosevka font is NOT installed"
    echo "  Install with: sudo pacman -S ttf-iosevka-nerd"
fi

if fc-list | grep -i "jetbrains" > /dev/null; then
    print_success "JetBrains Mono font is installed"
else
    print_warning "JetBrains Mono font is NOT installed"
    echo "  Install with: sudo pacman -S ttf-jetbrains-mono-nerd"
fi

# Summary
echo ""
echo "=========================================="
echo "  Installation Complete!"
echo "=========================================="
echo ""
print_success "All configurations have been installed"
echo ""
echo "Next steps:"
echo "  1. Install missing dependencies (see warnings above)"
echo "  2. Install i3blocks-contrib scripts if needed:"
echo "     git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3blocks/scripts"
echo "  3. Set your wallpaper with: nitrogen"
echo "  4. Reload i3 with: Mod+Shift+R"
echo "  5. Or logout and login again"
echo ""
echo "Backups saved in: ~/.config/backup/"
echo ""
echo "Enjoy your minimalist i3wm setup!"
echo ""
