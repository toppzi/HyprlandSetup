# Hyprland Easy Installer

A simple and customizable installer script for Hyprland window manager on Arch Linux, featuring a built-in configuration wizard.

## Features

- 🚀 **One-click installation**: Automated setup of Hyprland and dependencies
- 🔧 **Configuration wizard**: Easily customize your setup without editing files 
- 🎨 **Beautiful defaults**: Pre-configured with a transparent Waybar and clean aesthetics
- 📊 **System monitoring**: CPU, RAM, and network usage displayed in the status bar
- 🖼️ **Blur effects**: Stylish transparent blur for Waybar and windows
- 🧩 **Modular design**: Easily customize or add new features

## Screenshot

![Hyprland Screenshot](generated-icon.png)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/YourUsername/hyprland-easy-installer.git
   cd hyprland-easy-installer
   ```

2. Make the installation script executable:
   ```bash
   chmod +x install_hyprland.sh
   ```

3. Run the installer:
   ```bash
   ./install_hyprland.sh
   ```

4. Log out and select Hyprland from your display manager, or run `Hyprland` from a TTY.

## Configuration Wizard

After installing, you can customize your setup without editing files by running:

```bash
~/.config/hypr/configure_hyprland.sh
```

The wizard lets you configure:

- Appearance settings (gaps, borders, rounded corners, blur)
- Keybindings
- Waybar layout and appearance
- Window rules
- Monitor setup

## Key Bindings

Default key bindings (SUPER = Windows key):

- `SUPER + Return`: Open terminal (alacritty)
- `SUPER + Q`: Close active window
- `SUPER + M`: Exit Hyprland
- `SUPER + E`: Open file manager
- `SUPER + V`: Toggle floating window
- `SUPER + D`: Open application launcher (rofi)
- `SUPER + F`: Toggle fullscreen
- `SUPER + Arrow keys`: Navigate between windows
- `SUPER + SHIFT + Arrow keys`: Move windows
- `SUPER + 1-0`: Switch to workspace 1-10
- `SUPER + SHIFT + 1-0`: Move window to workspace 1-10
- `SUPER + Mouse drag`: Move or resize windows
- `Print`: Take a screenshot (full screen)
- `SHIFT + Print`: Take a screenshot (selected area)

## Customization

For advanced customization, you can edit:

- `~/.config/hypr/hyprland.conf`: Main Hyprland configuration
- `~/.config/waybar/config`: Waybar layout and modules
- `~/.config/waybar/style.css`: Waybar appearance
- `~/.config/waybar/modules/custom_modules.json`: Custom module definitions

## Requirements

- Arch Linux or Arch-based distribution
- Internet connection for package downloads

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Hyprland](https://hyprland.org/) - The dynamic tiling Wayland compositor
- [Waybar](https://github.com/Alexays/Waybar) - Highly customizable Wayland bar