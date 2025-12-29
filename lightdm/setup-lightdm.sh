#!/bin/bash

# LightDM Setup Script
# Configures LightDM with mini-greeter for minimalist i3wm setup

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }

if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root (use sudo)"
    exit 1
fi

echo "=========================================="
echo "  LightDM Mini Greeter Setup"
echo "=========================================="
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check installations
if ! command -v lightdm &> /dev/null; then
    print_error "lightdm is not installed!"
    echo "Install with: sudo pacman -S lightdm"
    exit 1
fi

if ! pacman -Qi lightdm-mini-greeter &> /dev/null 2>&1; then
    print_warning "lightdm-mini-greeter not found, attempting to install from AUR..."
    if command -v yay &> /dev/null; then
        sudo -u $SUDO_USER yay -S --noconfirm lightdm-mini-greeter
    else
        print_error "yay not found. Install lightdm-mini-greeter manually:"
        echo "  yay -S lightdm-mini-greeter"
        exit 1
    fi
fi

# Backup existing configs
print_info "Backing up existing LightDM configuration..."
timestamp=$(date +%Y%m%d_%H%M%S)

if [ -f /etc/lightdm/lightdm.conf ]; then
    cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.backup_${timestamp}
    print_success "Backed up lightdm.conf"
fi

if [ -f /etc/lightdm/lightdm-mini-greeter.conf ]; then
    cp /etc/lightdm/lightdm-mini-greeter.conf /etc/lightdm/lightdm-mini-greeter.conf.backup_${timestamp}
    print_success "Backed up lightdm-mini-greeter.conf"
fi

# Configure LightDM to use mini-greeter
print_info "Configuring LightDM to use mini-greeter..."
if [ -f /etc/lightdm/lightdm.conf ]; then
    sed -i 's/^#*greeter-session=.*/greeter-session=lightdm-mini-greeter/' /etc/lightdm/lightdm.conf
else
    mkdir -p /etc/lightdm
    echo "[Seat:*]" > /etc/lightdm/lightdm.conf
    echo "greeter-session=lightdm-mini-greeter" >> /etc/lightdm/lightdm.conf
fi
print_success "LightDM configured"

# Get username
read -p "Enter your username (default: $SUDO_USER): " USERNAME
USERNAME=${USERNAME:-$SUDO_USER}

# Install mini-greeter config
print_info "Installing mini-greeter configuration..."
if [ -f "$SCRIPT_DIR/lightdm-mini-greeter.conf" ]; then
    cp "$SCRIPT_DIR/lightdm-mini-greeter.conf" /etc/lightdm/lightdm-mini-greeter.conf
    sed -i "s/^user = .*/user = $USERNAME/" /etc/lightdm/lightdm-mini-greeter.conf
    print_success "Mini-greeter configured for user: $USERNAME"
else
    print_error "lightdm-mini-greeter.conf not found!"
    exit 1
fi

# Enable LightDM
print_info "Enabling LightDM service..."
systemctl enable lightdm.service
print_success "LightDM enabled"

echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
print_success "LightDM is ready to use"
echo ""
echo "Theme: Minimalist dark (matches i3wm)"
echo "User: $USERNAME"
echo ""
echo "Hotkeys (Super + key):"
echo "  S - Shutdown"
echo "  R - Restart"
echo "  H - Hibernate"
echo "  U - Suspend"
echo ""
echo "To start now: sudo systemctl start lightdm"
echo "Or reboot to see the new login screen"
echo ""
