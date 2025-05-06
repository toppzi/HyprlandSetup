# Hyprland Easy Installer Documentation

This document provides detailed information about the Hyprland Easy Installer and Configuration Wizard.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Installation Script](#installation-script)
3. [Configuration Wizard](#configuration-wizard)
4. [File Structure](#file-structure)
5. [Customization Options](#customization-options)
6. [Troubleshooting](#troubleshooting)

## Project Overview

The Hyprland Easy Installer is designed to simplify the installation and configuration of Hyprland, a dynamic tiling Wayland compositor for Linux. The project consists of two main components:

1. **Installation Script** (`install_hyprland.sh`): Automates the installation of Hyprland and its dependencies on Arch Linux.
2. **Configuration Wizard** (`configure_hyprland.sh`): Provides a text-based interface for customizing your Hyprland setup without directly editing configuration files.

## Installation Script

The installation script performs the following tasks:

1. Checks if the system is running Arch Linux
2. Updates the system package database
3. Installs Hyprland and necessary dependencies
4. Creates configuration directories
5. Sets up default configurations for Hyprland and Waybar
6. Downloads a default wallpaper
7. Sets up the configuration wizard for easy customization

### Command Line Options

The installation script supports the following environment variables:

- `REPLIT_ENVIRONMENT=1`: Enables demo mode, which skips package installation and only creates configuration files (useful for testing)

## Configuration Wizard

The configuration wizard provides a menu-driven interface for customizing your Hyprland setup. It modifies the configuration files based on your selections, eliminating the need to manually edit these files.

### Main Menu Options

1. **Appearance Settings**: Customize gaps, borders, rounded corners, blur effects, etc.
2. **Keybindings**: Change keyboard shortcuts for various actions
3. **Waybar Configuration**: Customize the status bar appearance and modules
4. **Window Rules**: Set specific behaviors for certain applications
5. **Monitor Setup**: Configure multiple displays or adjust resolution
6. **Apply Changes & Exit**: Save changes and exit the wizard

## File Structure

```
.
├── install_hyprland.sh           # Main installation script
├── configure_hyprland.sh         # Configuration wizard
├── README.md                     # Project overview and instructions
├── LICENSE                       # MIT License
├── config/                       # Configuration directory
│   ├── hypr/                     # Hyprland config files
│   │   └── hyprland.conf         # Main Hyprland configuration
│   └── waybar/                   # Waybar config files
│       ├── config                # Waybar layout and modules
│       ├── style.css             # Waybar appearance
│       ├── modules/              # Custom modules directory
│       │   └── custom_modules.json  # Custom module definitions
│       └── scripts/              # Scripts for Waybar modules
│           └── mediaplayer.py    # Media player integration
└── generated-icon.png            # Project screenshot
```

## Customization Options

### Appearance

- **Gaps**: Inner and outer gaps between windows
- **Border Size**: Window border thickness
- **Border Colors**: Colors for active and inactive window borders
- **Window Rounding**: Rounded corners for windows
- **Blur Effects**: Background blur for windows and UI elements
- **Wallpaper**: System background image
- **Animations**: Window transition animations

### Keybindings

- **Modifier Key**: Change the main modifier key (SUPER, ALT, CTRL, SHIFT)
- **Application Shortcuts**: Keys for launching applications
- **Window Management**: Keys for manipulating windows
- **Workspace Navigation**: Keys for switching between workspaces

### Waybar

- **Modules**: Enable/disable various status indicators
- **Colors**: Customize status bar and module colors
- **Position**: Top or bottom screen placement
- **Size**: Height of the status bar
- **Opacity/Blur**: Transparency settings for the bar

### Window Rules

- **Float Rules**: Make specific applications automatically float
- **Workspace Assignment**: Open certain applications on specific workspaces
- **Special Behaviors**: Set fullscreen, no focus, etc. for specific windows

### Monitor Setup

- **Multiple Displays**: Configure additional monitors
- **Resolution**: Set screen resolution and scaling
- **Position**: Arrange monitors in physical space

## Troubleshooting

### Common Issues

1. **Installation errors**: 
   - Ensure your system is up-to-date with `sudo pacman -Syu`
   - Check internet connection
   - Verify you have sufficient permissions

2. **Waybar not appearing**:
   - Try restarting Waybar: `killall waybar && waybar &`
   - Check the configuration file for syntax errors

3. **Missing icons**:
   - Ensure Font Awesome is installed: `sudo pacman -S otf-font-awesome`

4. **Configuration changes not taking effect**:
   - Restart Hyprland after making changes (Super+M)
   - Check for errors in the logs: `cat ~/.hyprland.log`

### Getting Help

If you encounter issues not covered here, you can:

1. Check the [Hyprland Wiki](https://wiki.hyprland.org/)
2. Visit the [Hyprland GitHub repository](https://github.com/hyprwm/Hyprland)
3. Join the [Hyprland Discord](https://discord.com/invite/hyprland)
4. Open an issue on the Hyprland Easy Installer GitHub repository