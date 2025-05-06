#!/bin/bash

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_section() {
    echo -e "\n${BLUE}==== $1 ====${NC}"
}

# Function to check if a command was successful
check_success() {
    if [ $? -eq 0 ]; then
        print_message "$1 completed successfully."
    else
        print_error "$1 failed!"
        exit 1
    fi
}

# Check if script is running on Arch Linux
if [ ! -f /etc/arch-release ] && [ -z "$REPLIT_ENVIRONMENT" ]; then
    print_error "This script is intended for Arch Linux only!"
    print_warning "For demonstration purposes, you can set REPLIT_ENVIRONMENT=1 to bypass this check."
    exit 1
else
    if [ -n "$REPLIT_ENVIRONMENT" ]; then
        print_warning "Running in demo/Replit environment. This will show configuration files but won't install packages."
        DEMO_MODE=1
    fi
fi

print_section "Hyprland Installation Script"
print_message "This script will install Hyprland window manager with a customized Waybar on Arch Linux."
print_message "Please make sure you have an active internet connection."
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

# Update system and install packages only if not in demo mode
if [ -z "$DEMO_MODE" ]; then
    print_section "Updating System"
    print_message "Updating package database..."
    sudo pacman -Syu --noconfirm
    check_success "System update"

    # Install required packages
    print_section "Installing Dependencies"
    print_message "Installing Hyprland and required packages..."

    dependencies=(
        "hyprland"
        "waybar"
        "alacritty"  # Terminal
        "rofi-wayland"  # Application launcher
        "swaybg"  # Wallpaper utility
        "swaylock"  # Screen locker
        "swayidle"  # Idle manager
        "polkit-gnome"  # Authentication agent
        "grim"  # Screenshot utility
        "slurp"  # Region selection
        "wl-clipboard"  # Clipboard manager
        "mako"  # Notification daemon
        "networkmanager"  # Network management
        "bluez"  # Bluetooth support
        "bluez-utils"
        "pulseaudio"  # Audio server
        "pulseaudio-bluetooth"
        "pavucontrol"  # Audio control
        "brightnessctl"  # Brightness control
        "otf-font-awesome"  # Icons for waybar
        "noto-fonts"  # Fonts
        "noto-fonts-emoji"
        "ttf-dejavu"
        "xdg-desktop-portal-hyprland"  # XDG portal
        "pipewire"  # Modern audio/video server
        "wireplumber"  # Session manager for pipewire
    )

    for pkg in "${dependencies[@]}"; do
        print_message "Installing $pkg..."
        sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null
        if [ $? -ne 0 ]; then
            print_warning "$pkg installation failed, trying from AUR..."
            # Try installing from AUR using yay if available
            if command -v yay &> /dev/null; then
                yay -S --needed --noconfirm "$pkg"
                if [ $? -ne 0 ]; then
                    print_error "Failed to install $pkg from AUR."
                    exit 1
                fi
            else
                print_error "Package $pkg not found in official repositories and yay is not installed."
                print_message "Would you like to install yay (AUR helper)?"
                read -p "Install yay? (y/n): " install_yay
                
                if [[ $install_yay == "y" || $install_yay == "Y" ]]; then
                    print_message "Installing yay..."
                    sudo pacman -S --needed --noconfirm git base-devel
                    git clone https://aur.archlinux.org/yay.git /tmp/yay
                    cd /tmp/yay
                    makepkg -si --noconfirm
                    check_success "yay installation"
                    yay -S --needed --noconfirm "$pkg"
                    check_success "$pkg installation via AUR"
                else
                    print_error "Cannot continue without required package: $pkg"
                    exit 1
                fi
            fi
        fi
    done

    check_success "Dependencies installation"
else
    print_section "Demo Mode - Skipping Package Installation"
    print_message "In demo mode, we'll skip package installation and just set up configuration files."
fi

# Create configuration directories
print_section "Creating Configuration Directories"
print_message "Setting up configuration directories..."

config_dirs=(
    "$HOME/.config/hypr"
    "$HOME/.config/waybar"
    "$HOME/.config/waybar/modules"
)

for dir in "${config_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_message "Created directory: $dir"
    else
        print_warning "Directory already exists: $dir"
        echo "Would you like to backup your existing configuration?"
        read -p "Create backup? (y/n): " create_backup
        
        if [[ $create_backup == "y" || $create_backup == "Y" ]]; then
            backup_dir="${dir}_backup_$(date +%Y%m%d_%H%M%S)"
            mv "$dir" "$backup_dir"
            mkdir -p "$dir"
            print_message "Created backup: $backup_dir"
        fi
    fi
done

# Create configuration files
print_section "Setting Up Configuration Files"

# Hyprland configuration
print_message "Creating Hyprland configuration..."
cat > "$HOME/.config/hypr/hyprland.conf" << 'EOL'
# Hyprland Configuration File
# See https://wiki.hyprland.org/Configuring/Configuring-Hyprland/ for more

# Monitor configuration
monitor=,preferred,auto,1

# Set variables
$terminal = alacritty
$menu = rofi -show drun
$browser = firefox

# Environment variables
env = XCURSOR_SIZE,24
env = WLR_NO_HARDWARE_CURSORS,1
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt5ct
env = GTK_THEME,Adwaita:dark

# Execute your favorite apps at launch
exec-once = waybar
exec-once = swaybg -i ~/.config/hypr/wallpaper.jpg
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = mako

# Input configuration
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1
    sensitivity = 0 # -1.0 - 1.0, 0 means no modification
    touchpad {
        natural_scroll = true
        tap-to-click = true
    }
}

# General settings
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle
}

# Decoration settings (rounded corners, shadows, blur, etc.)
decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
        vibrancy = 0.1696
    }
    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = true

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Layout settings
dwindle {
    pseudotile = true
    preserve_split = true
}

master {
    new_is_master = true
}

# Gestures
gestures {
    workspace_swipe = true
}

# Window rules
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(nm-connection-editor)$
windowrule = float, ^(blueman-manager)$

# Key bindings
$mainMod = SUPER

bind = $mainMod, Return, exec, $terminal
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, dolphin
bind = $mainMod, V, togglefloating,
bind = $mainMod, D, exec, $menu
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = $mainMod, F, fullscreen,

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Move windows with mainMod + SHIFT + arrow keys
bind = $mainMod SHIFT, left, movewindow, l
bind = $mainMod SHIFT, right, movewindow, r
bind = $mainMod SHIFT, up, movewindow, u
bind = $mainMod SHIFT, down, movewindow, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Screenshot bindings
bind = , Print, exec, grim - | wl-copy # Full screen
bind = SHIFT, Print, exec, grim -g "$(slurp)" - | wl-copy # Selected area

# Volume keys
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
bind = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle

# Brightness keys
bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
EOL

# Waybar configuration
print_message "Creating Waybar configuration..."
cat > "$HOME/.config/waybar/config" << 'EOL'
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "spacing": 4,
    "margin-top": 6,
    "margin-left": 8,
    "margin-right": 8,

    "modules-left": ["hyprland/workspaces", "custom/separator", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["cpu", "memory", "network", "custom/separator", "custom/power", "tray"],

    "hyprland/workspaces": {
        "disable-scroll": true,
        "on-click": "activate",
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
            "1": "  1 ", 
            "2": "  2 ",
            "3": "  3 ",
            "4": "  4 ",
            "5": "  5 ",
            "urgent": " 󰀨 ",
            "focused": " 󰮯 ",
            "default": " 󰑊 "
        }
    },

    "hyprland/window": {
        "format": "{}",
        "max-length": 25
    },

    "clock": {
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "format": " {:%a, %d %b %Y | %H:%M}",
        "format-alt": "{:%Y-%m-%d}",
        "interval": 1
    },

    "cpu": {
        "format": "󰻠 {usage}%",
        "tooltip": true,
        "interval": 1
    },

    "memory": {
        "format": "󰍛 {percentage}%",
        "tooltip-format": "{used:0.1f}GB / {total:0.1f}GB",
        "interval": 5
    },

    "network": {
        "format-wifi": "󰖩 {essid} ({signalStrength}%)",
        "format-ethernet": "󰈀 {ipaddr}/{cidr}",
        "tooltip-format": "{ifname} via {gwaddr}",
        "format-linked": "󰈀 {ifname} (No IP)",
        "format-disconnected": "⚠ Disconnected",
        "format-alt": "{ifname}: {ipaddr}/{cidr}"
    },

    "tray": {
        "icon-size": 16,
        "spacing": 10
    },
    
    "custom/separator": {
        "format": "|",
        "interval": "once",
        "tooltip": false
    },
    
    "custom/power": {
        "format": "⏻",
        "on-click": "hyprctl dispatch exit",
        "tooltip": false
    }
}
EOL

# Waybar CSS
print_message "Creating Waybar style..."
cat > "$HOME/.config/waybar/style.css" << 'EOL'
* {
    border: none;
    border-radius: 0;
    font-family: "DejaVu Sans", "Font Awesome 6 Free";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: rgba(30, 30, 46, 0.5);
    color: #cdd6f4;
    border-radius: 8px;
    transition-property: background-color;
    transition-duration: 0.5s;
    /* Enable blur behind the bar */
    box-shadow: 0 3px 5px rgba(0,0,0,0.2);
    backdrop-filter: blur(5px);
}

window#waybar.hidden {
    opacity: 0.2;
}

#workspaces button {
    padding: 0 5px;
    background-color: transparent;
    color: #cdd6f4;
    border-radius: 8px;
}

#workspaces button:hover {
    background: rgba(255, 255, 255, 0.15);
}

#workspaces button.active {
    background-color: rgba(166, 227, 161, 0.4);
    color: #fff;
}

#workspaces button.urgent {
    background-color: #f38ba8;
}

#clock,
#cpu,
#memory,
#network,
#custom-power,
#custom-separator,
#tray,
#hyprland-window {
    padding: 0 10px;
    margin: 0 4px;
    color: #cdd6f4;
    border-radius: 8px;
}

#clock {
    background-color: rgba(137, 180, 250, 0.4);
    font-weight: bold;
}

#cpu {
    background-color: rgba(166, 227, 161, 0.4);
}

#memory {
    background-color: rgba(245, 194, 231, 0.4);
}

#network {
    background-color: rgba(250, 179, 135, 0.4);
}

#network.disconnected {
    background-color: rgba(243, 139, 168, 0.4);
}

#tray {
    background-color: rgba(125, 196, 228, 0.4);
}

#custom-separator {
    color: #6c7086;
    font-size: 15px;
    margin: 0 2px;
}

#custom-power {
    background-color: rgba(243, 139, 168, 0.4);
    margin-right: 6px;
    font-size: 15px;
}

#custom-power:hover {
    background-color: rgba(243, 139, 168, 0.6);
}

#hyprland-window {
    background-color: rgba(180, 190, 254, 0.3);
    padding-left: 15px;
    padding-right: 15px;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #f38ba8;
}
EOL

# Create custom modules directory
print_message "Creating custom modules configuration..."
cat > "$HOME/.config/waybar/modules/custom_modules.json" << 'EOL'
{
    "custom/power": {
        "format": "⏻",
        "on-click": "hyprctl dispatch exit",
        "tooltip": false
    },
    
    "custom/separator": {
        "format": "|",
        "interval": "once",
        "tooltip": false
    },
    
    "custom/weather": {
        "exec": "curl 'https://wttr.in/?format=%C+%t'",
        "interval": 3600,
        "format": "{}",
        "tooltip": false
    },
    
    "custom/media": {
        "format": "{icon} {}",
        "return-type": "json",
        "max-length": 40,
        "format-icons": {
            "spotify": "",
            "default": "🎜"
        },
        "escape": true,
        "exec": "$HOME/.config/waybar/scripts/mediaplayer.py 2> /dev/null"
    }
}
EOL

# Create scripts directory for media player script
mkdir -p "$HOME/.config/waybar/scripts"

# Create media player script
print_message "Creating media player script..."
cat > "$HOME/.config/waybar/scripts/mediaplayer.py" << 'EOL'
#!/usr/bin/env python3
import argparse
import json
import os
import sys
import signal
import gi
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib

def write_output(text, player):
    output = {'text': text,
              'class': 'custom-' + player.props.player_name,
              'alt': player.props.player_name}
    sys.stdout.write(json.dumps(output) + '\n')
    sys.stdout.flush()

def on_play(player, status, manager):
    on_metadata(player, player.props.metadata, manager)

def on_metadata(player, metadata, manager):
    player_name = player.props.player_name
    if player_name == 'spotify' and \
            'mpris:trackid' in metadata.keys() and \
            ':ad:' in metadata['mpris:trackid']:
        write_output('', player)
        return

    if player_name == 'spotify' and \
            metadata['mpris:trackid'].startswith('spotify:ad:'):
        write_output('', player)
        return

    if player.props.status != 'Playing':
        return

    artist = metadata['xesam:artist'][0] if metadata['xesam:artist'] else ''
    if not artist:
        artist = metadata['xesam:albumArtist'][0] if metadata['xesam:albumArtist'] else ''
    song = metadata['xesam:title'] if metadata['xesam:title'] else ''

    if artist and song:
        write_output('{} - {}'.format(artist, song), player)
    else:
        write_output('{}'.format(song), player)

def on_player_appeared(manager, player, selected_player=None):
    if player is not None and (selected_player is None or player.name == selected_player):
        player.connect('playback-status', on_play, manager)
        player.connect('metadata', on_metadata, manager)
        manager.manage_player(player)
    else:
        manager.unmanage_player(player)

def on_player_vanished(manager, player):
    sys.stdout.write('\n')
    sys.stdout.flush()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--player')
    args = parser.parse_args()

    manager = Playerctl.PlayerManager()
    manager.connect('name-appeared', lambda *args: on_player_appeared(*args, args.player))
    manager.connect('player-vanished', on_player_vanished)

    signal.signal(signal.SIGINT, lambda _, __: sys.exit(0))
    signal.signal(signal.SIGTERM, lambda _, __: sys.exit(0))

    for player in manager.props.player_names:
        if args.player is not None and args.player != player.name:
            continue
        try:
            player = Playerctl.Player.new_from_name(player)
            on_player_appeared(manager, player, args.player)
        except:
            pass

    try:
        main_loop = GLib.MainLoop()
        main_loop.run()
    except KeyboardInterrupt:
        pass

if __name__ == '__main__':
    main()
EOL

# Make the script executable
chmod +x "$HOME/.config/waybar/scripts/mediaplayer.py"

# Create a default wallpaper if it doesn't exist
print_message "Setting up a default wallpaper..."

if [ ! -f "$HOME/.config/hypr/wallpaper.jpg" ]; then
    # Let's create a simple colored wallpaper if we don't have one
    if command -v convert &> /dev/null; then
        # Using ImageMagick to create a gradient wallpaper
        convert -size 1920x1080 gradient:#1e1e2e:#313244 "$HOME/.config/hypr/wallpaper.jpg"
        print_message "Created a default gradient wallpaper."
    else
        # If ImageMagick is not available, we'll download a sample wallpaper
        if command -v curl &> /dev/null; then
            curl -L -o "$HOME/.config/hypr/wallpaper.jpg" "https://raw.githubusercontent.com/catppuccin/wallpapers/main/landscapes/evening-sky.png" || \
            print_warning "Could not download a wallpaper. Please add one manually to ~/.config/hypr/wallpaper.jpg"
        else
            print_warning "Neither ImageMagick nor curl is available. Please add a wallpaper manually to ~/.config/hypr/wallpaper.jpg"
        fi
    fi
fi

print_section "Installation Complete"
print_message "Hyprland and Waybar have been installed and configured successfully!"

# Copy the configuration wizard to the home directory
print_message "Installing the configuration wizard..."
cp "$(dirname "$0")/configure_hyprland.sh" "$HOME/.config/hypr/"
chmod +x "$HOME/.config/hypr/configure_hyprland.sh"

print_message "To start Hyprland, log out and select Hyprland from your display manager."
print_message "Or run 'Hyprland' from a TTY if you're not using a display manager."
print_message "Enjoy your new Hyprland setup with a transparent blurred Waybar!"
print_message "To customize your setup without editing files, run: ~/.config/hypr/configure_hyprland.sh"

# Make the script executable
chmod +x "$0"
