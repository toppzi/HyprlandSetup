#!/bin/bash

# Colors for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_option() {
    echo -e "${CYAN}[$1]${NC} $2"
}

# Configuration paths
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"
WAYBAR_CONFIG="$HOME/.config/waybar/config"
WAYBAR_STYLE="$HOME/.config/waybar/style.css"

# Check if Hyprland is installed
if [ ! -f "$HYPR_CONFIG" ]; then
    print_error "Hyprland configuration not found at $HYPR_CONFIG"
    print_message "Please install Hyprland first using install_hyprland.sh"
    exit 1
fi

# Main menu
show_main_menu() {
    clear
    print_section "Hyprland Configuration Wizard"
    echo "Welcome to the Hyprland configuration wizard. This tool helps you customize your Hyprland setup without editing files directly."
    echo ""
    print_option "1" "Appearance Settings"
    print_option "2" "Keybindings"
    print_option "3" "Waybar Configuration"
    print_option "4" "Window Rules"
    print_option "5" "Monitor Setup"
    print_option "6" "Apply Changes & Exit"
    print_option "0" "Exit Without Applying"
    echo ""
    
    read -p "Enter your choice [0-6]: " main_choice
    
    case $main_choice in
        1) appearance_menu ;;
        2) keybinding_menu ;;
        3) waybar_menu ;;
        4) window_rules_menu ;;
        5) monitor_menu ;;
        6) apply_changes ;;
        0) echo "Exiting without changes"; exit 0 ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; show_main_menu ;;
    esac
}

# Appearance menu
appearance_menu() {
    clear
    print_section "Appearance Settings"
    print_option "1" "Change Gaps (Inner/Outer)"
    print_option "2" "Change Border Size"
    print_option "3" "Change Border Colors"
    print_option "4" "Change Window Rounding"
    print_option "5" "Configure Blur Effects"
    print_option "6" "Change Wallpaper"
    print_option "7" "Configure Animation Settings"
    print_option "0" "Back to Main Menu"
    echo ""
    
    read -p "Enter your choice [0-7]: " appearance_choice
    
    case $appearance_choice in
        1) configure_gaps ;;
        2) configure_border_size ;;
        3) configure_border_colors ;;
        4) configure_rounding ;;
        5) configure_blur ;;
        6) configure_wallpaper ;;
        7) configure_animations ;;
        0) show_main_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; appearance_menu ;;
    esac
}

# Keybinding menu
keybinding_menu() {
    clear
    print_section "Keybinding Configuration"
    print_option "1" "Change Main Modifier Key"
    print_option "2" "Configure Application Shortcuts"
    print_option "3" "Configure Window Management Shortcuts"
    print_option "4" "Configure Workspace Shortcuts"
    print_option "0" "Back to Main Menu"
    echo ""
    
    read -p "Enter your choice [0-4]: " keybinding_choice
    
    case $keybinding_choice in
        1) configure_main_modifier ;;
        2) configure_app_shortcuts ;;
        3) configure_window_shortcuts ;;
        4) configure_workspace_shortcuts ;;
        0) show_main_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; keybinding_menu ;;
    esac
}

# Waybar menu
waybar_menu() {
    clear
    print_section "Waybar Configuration"
    print_option "1" "Toggle Waybar Modules (Enable/Disable)"
    print_option "2" "Change Waybar Colors"
    print_option "3" "Change Waybar Position"
    print_option "4" "Change Waybar Size"
    print_option "5" "Configure Waybar Opacity/Blur"
    print_option "0" "Back to Main Menu"
    echo ""
    
    read -p "Enter your choice [0-5]: " waybar_choice
    
    case $waybar_choice in
        1) configure_waybar_modules ;;
        2) configure_waybar_colors ;;
        3) configure_waybar_position ;;
        4) configure_waybar_size ;;
        5) configure_waybar_opacity ;;
        0) show_main_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; waybar_menu ;;
    esac
}

# Window rules menu
window_rules_menu() {
    clear
    print_section "Window Rules Configuration"
    print_option "1" "Add Window Rule"
    print_option "2" "Remove Window Rule"
    print_option "3" "List Window Rules"
    print_option "0" "Back to Main Menu"
    echo ""
    
    read -p "Enter your choice [0-3]: " window_rules_choice
    
    case $window_rules_choice in
        1) add_window_rule ;;
        2) remove_window_rule ;;
        3) list_window_rules ;;
        0) show_main_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; window_rules_menu ;;
    esac
}

# Monitor menu
monitor_menu() {
    clear
    print_section "Monitor Setup"
    print_option "1" "Add/Configure Monitor"
    print_option "2" "Remove Monitor Configuration"
    print_option "3" "List Monitor Configurations"
    print_option "0" "Back to Main Menu"
    echo ""
    
    read -p "Enter your choice [0-3]: " monitor_choice
    
    case $monitor_choice in
        1) add_monitor ;;
        2) remove_monitor ;;
        3) list_monitors ;;
        0) show_main_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; monitor_menu ;;
    esac
}

# Function to configure gaps
configure_gaps() {
    clear
    print_section "Configure Gaps"
    
    # Get current gaps
    current_gaps_in=$(grep "gaps_in =" "$HYPR_CONFIG" | awk '{print $3}')
    current_gaps_out=$(grep "gaps_out =" "$HYPR_CONFIG" | awk '{print $3}')
    
    echo "Current inner gaps: $current_gaps_in"
    echo "Current outer gaps: $current_gaps_out"
    echo ""
    
    read -p "Enter new inner gaps value [0-20] (press Enter to keep current): " gaps_in
    read -p "Enter new outer gaps value [0-20] (press Enter to keep current): " gaps_out
    
    # Update values if provided
    if [ -n "$gaps_in" ]; then
        if [[ "$gaps_in" =~ ^[0-9]+$ ]] && [ "$gaps_in" -ge 0 ] && [ "$gaps_in" -le 20 ]; then
            sed -i "s/gaps_in = [0-9]\+/gaps_in = $gaps_in/" "$HYPR_CONFIG"
            print_message "Inner gaps updated to $gaps_in"
        else
            print_error "Invalid value. Inner gaps not updated."
        fi
    fi
    
    if [ -n "$gaps_out" ]; then
        if [[ "$gaps_out" =~ ^[0-9]+$ ]] && [ "$gaps_out" -ge 0 ] && [ "$gaps_out" -le 20 ]; then
            sed -i "s/gaps_out = [0-9]\+/gaps_out = $gaps_out/" "$HYPR_CONFIG"
            print_message "Outer gaps updated to $gaps_out"
        else
            print_error "Invalid value. Outer gaps not updated."
        fi
    fi
    
    read -p "Press Enter to continue..."
    appearance_menu
}

# Function to configure border size
configure_border_size() {
    clear
    print_section "Configure Border Size"
    
    # Get current border size
    current_border=$(grep "border_size =" "$HYPR_CONFIG" | awk '{print $3}')
    
    echo "Current border size: $current_border"
    echo ""
    
    read -p "Enter new border size [0-5] (press Enter to keep current): " border_size
    
    # Update value if provided
    if [ -n "$border_size" ]; then
        if [[ "$border_size" =~ ^[0-9]+$ ]] && [ "$border_size" -ge 0 ] && [ "$border_size" -le 5 ]; then
            sed -i "s/border_size = [0-9]\+/border_size = $border_size/" "$HYPR_CONFIG"
            print_message "Border size updated to $border_size"
        else
            print_error "Invalid value. Border size must be between 0 and 5."
        fi
    fi
    
    read -p "Press Enter to continue..."
    appearance_menu
}

# Function to configure border colors
configure_border_colors() {
    clear
    print_section "Configure Border Colors"
    
    # Get current colors
    current_active=$(grep -o "col.active_border = rgba([^)]*)" "$HYPR_CONFIG" | sed 's/col.active_border = //')
    current_inactive=$(grep -o "col.inactive_border = rgba([^)]*)" "$HYPR_CONFIG" | sed 's/col.inactive_border = //')
    
    echo "Current active border color: $current_active"
    echo "Current inactive border color: $current_inactive"
    echo ""
    echo "Enter new colors in RGBA format (e.g., rgba(33ccffee))"
    echo "For gradient, use format: rgba(color1) rgba(color2) 45deg"
    echo ""
    
    read -p "Enter new active border color (press Enter to keep current): " active_color
    read -p "Enter new inactive border color (press Enter to keep current): " inactive_color
    
    # Update active color if provided
    if [ -n "$active_color" ]; then
        if [[ "$active_color" =~ rgba\( ]]; then
            sed -i "s|col.active_border = .*$|col.active_border = $active_color|" "$HYPR_CONFIG"
            print_message "Active border color updated"
        else
            print_error "Invalid format. Active border color not updated."
        fi
    fi
    
    # Update inactive color if provided
    if [ -n "$inactive_color" ]; then
        if [[ "$inactive_color" =~ rgba\( ]]; then
            sed -i "s|col.inactive_border = .*$|col.inactive_border = $inactive_color|" "$HYPR_CONFIG"
            print_message "Inactive border color updated"
        else
            print_error "Invalid format. Inactive border color not updated."
        fi
    fi
    
    read -p "Press Enter to continue..."
    appearance_menu
}

# Function to configure window rounding
configure_rounding() {
    clear
    print_section "Configure Window Rounding"
    
    # Get current rounding
    current_rounding=$(grep "rounding =" "$HYPR_CONFIG" | awk '{print $3}')
    
    echo "Current window rounding: $current_rounding"
    echo ""
    
    read -p "Enter new rounding value [0-15] (press Enter to keep current): " rounding
    
    # Update value if provided
    if [ -n "$rounding" ]; then
        if [[ "$rounding" =~ ^[0-9]+$ ]] && [ "$rounding" -ge 0 ] && [ "$rounding" -le 15 ]; then
            sed -i "s/rounding = [0-9]\+/rounding = $rounding/" "$HYPR_CONFIG"
            print_message "Window rounding updated to $rounding"
        else
            print_error "Invalid value. Rounding must be between 0 and 15."
        fi
    fi
    
    read -p "Press Enter to continue..."
    appearance_menu
}

# Function to configure blur effects
configure_blur() {
    clear
    print_section "Configure Blur Effects"
    
    # Get current blur settings
    current_enabled=$(grep "enabled = " "$HYPR_CONFIG" | head -1 | awk '{print $3}')
    current_size=$(grep "size = " "$HYPR_CONFIG" | head -1 | awk '{print $3}')
    current_passes=$(grep "passes = " "$HYPR_CONFIG" | head -1 | awk '{print $3}')
    current_vibrancy=$(grep "vibrancy = " "$HYPR_CONFIG" | head -1 | awk '{print $3}')
    
    echo "Current blur enabled: $current_enabled"
    echo "Current blur size: $current_size"
    echo "Current blur passes: $current_passes"
    echo "Current blur vibrancy: $current_vibrancy"
    echo ""
    
    read -p "Enable blur? (yes/no/press Enter to keep current): " blur_enabled
    read -p "Enter blur size [1-20] (press Enter to keep current): " blur_size
    read -p "Enter blur passes [1-5] (press Enter to keep current): " blur_passes
    read -p "Enter blur vibrancy [0.0-1.0] (press Enter to keep current): " blur_vibrancy
    
    # Update enabled if provided
    if [ -n "$blur_enabled" ]; then
        if [[ "$blur_enabled" == "yes" ]]; then
            sed -i '/blur {/,/}/s/enabled = .*/enabled = true/' "$HYPR_CONFIG"
            print_message "Blur enabled set to true"
        elif [[ "$blur_enabled" == "no" ]]; then
            sed -i '/blur {/,/}/s/enabled = .*/enabled = false/' "$HYPR_CONFIG"
            print_message "Blur enabled set to false"
        else
            print_error "Invalid value. Use 'yes' or 'no'."
        fi
    fi
    
    # Update size if provided
    if [ -n "$blur_size" ]; then
        if [[ "$blur_size" =~ ^[0-9]+$ ]] && [ "$blur_size" -ge 1 ] && [ "$blur_size" -le 20 ]; then
            sed -i '/blur {/,/}/s/size = [0-9]\+/size = '"$blur_size"'/' "$HYPR_CONFIG"
            print_message "Blur size updated to $blur_size"
        else
            print_error "Invalid value. Blur size must be between 1 and 20."
        fi
    fi
    
    # Update passes if provided
    if [ -n "$blur_passes" ]; then
        if [[ "$blur_passes" =~ ^[0-9]+$ ]] && [ "$blur_passes" -ge 1 ] && [ "$blur_passes" -le 5 ]; then
            sed -i '/blur {/,/}/s/passes = [0-9]\+/passes = '"$blur_passes"'/' "$HYPR_CONFIG"
            print_message "Blur passes updated to $blur_passes"
        else
            print_error "Invalid value. Blur passes must be between 1 and 5."
        fi
    fi
    
    # Update vibrancy if provided
    if [ -n "$blur_vibrancy" ]; then
        if [[ "$blur_vibrancy" =~ ^0?\.[0-9]+$ ]] && (( $(echo "$blur_vibrancy <= 1.0" | bc -l) )); then
            sed -i '/blur {/,/}/s/vibrancy = [0-9]\+\.[0-9]\+/vibrancy = '"$blur_vibrancy"'/' "$HYPR_CONFIG"
            print_message "Blur vibrancy updated to $blur_vibrancy"
        else
            print_error "Invalid value. Blur vibrancy must be between 0.0 and 1.0."
        fi
    fi
    
    read -p "Press Enter to continue..."
    appearance_menu
}

# Function to configure wallpaper
configure_wallpaper() {
    clear
    print_section "Configure Wallpaper"
    
    # Get current wallpaper
    current_wallpaper=$(grep "swaybg -i" "$HYPR_CONFIG" | awk '{print $3}')
    
    echo "Current wallpaper path: $current_wallpaper"
    echo ""
    echo "Enter new wallpaper path. You can use:"
    echo "1. Absolute path: /path/to/wallpaper.jpg"
    echo "2. Relative to home: ~/Pictures/wallpaper.jpg"
    echo ""
    
    read -p "Enter new wallpaper path (press Enter to keep current): " wallpaper_path
    
    # Update wallpaper if provided
    if [ -n "$wallpaper_path" ]; then
        # Expand ~ to $HOME if present
        wallpaper_path="${wallpaper_path/#\~/$HOME}"
        
        if [ -f "$wallpaper_path" ]; then
            sed -i "s|swaybg -i .*|swaybg -i $wallpaper_path|" "$HYPR_CONFIG"
            print_message "Wallpaper updated to $wallpaper_path"
        else
            print_error "File not found: $wallpaper_path"
        fi
    fi
    
    read -p "Press Enter to continue..."
    appearance_menu
}

# Function to configure animations
configure_animations() {
    clear
    print_section "Configure Animations"
    
    # Get current animation settings
    current_enabled=$(grep "animations {" -A 1 "$HYPR_CONFIG" | grep "enabled = " | awk '{print $3}')
    
    echo "Current animations enabled: $current_enabled"
    echo ""
    
    read -p "Enable animations? (yes/no/press Enter to keep current): " anim_enabled
    
    # Update animations if provided
    if [ -n "$anim_enabled" ]; then
        if [[ "$anim_enabled" == "yes" ]]; then
            sed -i '/animations {/,+1s/enabled = .*/enabled = true/' "$HYPR_CONFIG"
            print_message "Animations enabled"
        elif [[ "$anim_enabled" == "no" ]]; then
            sed -i '/animations {/,+1s/enabled = .*/enabled = false/' "$HYPR_CONFIG"
            print_message "Animations disabled"
        else
            print_error "Invalid value. Use 'yes' or 'no'."
        fi
    fi
    
    read -p "Press Enter to continue..."
    appearance_menu
}

# Function to configure the main modifier key
configure_main_modifier() {
    clear
    print_section "Configure Main Modifier Key"
    
    # Get current main modifier
    current_modifier=$(grep "mainMod =" "$HYPR_CONFIG" | awk '{print $3}')
    
    echo "Current main modifier key: $current_modifier"
    echo ""
    echo "Available options:"
    echo "1. SUPER (Windows key)"
    echo "2. ALT"
    echo "3. CTRL"
    echo "4. SHIFT"
    echo ""
    
    read -p "Enter your choice [1-4] (press Enter to keep current): " modifier_choice
    
    # Update modifier if provided
    case $modifier_choice in
        1) sed -i 's/mainMod = .*/mainMod = SUPER/' "$HYPR_CONFIG"; print_message "Main modifier updated to SUPER" ;;
        2) sed -i 's/mainMod = .*/mainMod = ALT/' "$HYPR_CONFIG"; print_message "Main modifier updated to ALT" ;;
        3) sed -i 's/mainMod = .*/mainMod = CTRL/' "$HYPR_CONFIG"; print_message "Main modifier updated to CTRL" ;;
        4) sed -i 's/mainMod = .*/mainMod = SHIFT/' "$HYPR_CONFIG"; print_message "Main modifier updated to SHIFT" ;;
        "") print_message "Keeping current modifier" ;;
        *) print_error "Invalid choice. Main modifier not updated." ;;
    esac
    
    read -p "Press Enter to continue..."
    keybinding_menu
}

# Function to configure application shortcuts
configure_app_shortcuts() {
    clear
    print_section "Configure Application Shortcuts"
    
    # Get current application shortcuts
    echo "Current application shortcuts:"
    grep -E "bind = \\\$mainMod,.*, exec," "$HYPR_CONFIG" | while read -r line; do
        key=$(echo "$line" | awk '{print $4}' | tr -d ',')
        app=$(echo "$line" | awk '{for(i=6;i<=NF;i++) printf "%s ", $i}')
        printf "Key: %-10s App: %s\n" "$key" "$app"
    done
    echo ""
    
    print_option "1" "Add new shortcut"
    print_option "2" "Modify existing shortcut"
    print_option "0" "Back to keybinding menu"
    echo ""
    
    read -p "Enter your choice [0-2]: " app_shortcut_choice
    
    case $app_shortcut_choice in
        1) add_app_shortcut ;;
        2) modify_app_shortcut ;;
        0) keybinding_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; configure_app_shortcuts ;;
    esac
}

# Function to add new application shortcut
add_app_shortcut() {
    echo ""
    echo "Adding new application shortcut"
    read -p "Enter key (e.g., E, Return, F1): " key
    read -p "Enter application command: " app_command
    
    if [ -n "$key" ] && [ -n "$app_command" ]; then
        # Find the last application shortcut line
        last_line=$(grep -n "bind = \\\$mainMod,.*, exec," "$HYPR_CONFIG" | tail -1 | cut -d: -f1)
        
        # Insert new shortcut after the last one
        sed -i "${last_line}a bind = \$mainMod, $key, exec, $app_command" "$HYPR_CONFIG"
        print_message "New shortcut added: $key -> $app_command"
    else
        print_error "Key and application command are required."
    fi
    
    read -p "Press Enter to continue..."
    configure_app_shortcuts
}

# Function to modify existing application shortcut
modify_app_shortcut() {
    echo ""
    echo "Modifying existing shortcut"
    read -p "Enter the key of the shortcut to modify: " key_to_modify
    
    if [ -n "$key_to_modify" ]; then
        # Check if shortcut exists
        if grep -q "bind = \\\$mainMod, $key_to_modify, exec," "$HYPR_CONFIG"; then
            read -p "Enter new application command: " new_app_command
            
            if [ -n "$new_app_command" ]; then
                sed -i "s|bind = \\\$mainMod, $key_to_modify, exec,.*|bind = \\\$mainMod, $key_to_modify, exec, $new_app_command|" "$HYPR_CONFIG"
                print_message "Shortcut modified: $key_to_modify -> $new_app_command"
            else
                print_error "New application command is required."
            fi
        else
            print_error "Shortcut with key '$key_to_modify' not found."
        fi
    else
        print_error "Key to modify is required."
    fi
    
    read -p "Press Enter to continue..."
    configure_app_shortcuts
}

# Function to configure window management shortcuts
configure_window_shortcuts() {
    clear
    print_section "Configure Window Management Shortcuts"
    
    # Display current window management shortcuts
    echo "Current window management shortcuts:"
    grep -E "bind = \\\$mainMod,.*, (killactive|togglefloating|fullscreen|movefocus|movewindow)" "$HYPR_CONFIG" | while read -r line; do
        key=$(echo "$line" | awk '{print $4}' | tr -d ',')
        action=$(echo "$line" | awk '{print $6}' | tr -d ',')
        printf "Key: %-10s Action: %s\n" "$key" "$action"
    done
    echo ""
    
    print_option "1" "Close window (killactive)"
    print_option "2" "Toggle floating"
    print_option "3" "Toggle fullscreen"
    print_option "0" "Back to keybinding menu"
    echo ""
    
    read -p "Enter your choice [0-3]: " window_action_choice
    
    case $window_action_choice in
        1) modify_window_shortcut "killactive" ;;
        2) modify_window_shortcut "togglefloating" ;;
        3) modify_window_shortcut "fullscreen" ;;
        0) keybinding_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; configure_window_shortcuts ;;
    esac
}

# Function to modify window management shortcut
modify_window_shortcut() {
    action=$1
    echo ""
    echo "Modifying shortcut for $action"
    
    # Get current key for this action
    current_key=$(grep "bind = \\\$mainMod,.*, $action" "$HYPR_CONFIG" | awk '{print $4}' | tr -d ',')
    echo "Current key: $current_key"
    
    read -p "Enter new key (e.g., Q, F, T) (press Enter to keep current): " new_key
    
    if [ -n "$new_key" ]; then
        sed -i "s|bind = \\\$mainMod, $current_key, $action|bind = \\\$mainMod, $new_key, $action|" "$HYPR_CONFIG"
        print_message "Shortcut for $action updated to $new_key"
    else
        print_message "Keeping current shortcut"
    fi
    
    read -p "Press Enter to continue..."
    configure_window_shortcuts
}

# Function to configure workspace shortcuts
configure_workspace_shortcuts() {
    clear
    print_section "Configure Workspace Shortcuts"
    
    echo "Current workspace switching implementation uses number keys 1-0"
    echo "This wizard does not support changing workspace switching keys"
    echo "as it would require extensive changes to the config structure."
    echo ""
    
    read -p "Press Enter to go back..."
    keybinding_menu
}

# Function to configure Waybar modules
configure_waybar_modules() {
    clear
    print_section "Configure Waybar Modules"
    
    # Get current modules
    left_modules=$(grep "\"modules-left\":" "$WAYBAR_CONFIG" | sed 's/.*\[\(.*\)\].*/\1/')
    center_modules=$(grep "\"modules-center\":" "$WAYBAR_CONFIG" | sed 's/.*\[\(.*\)\].*/\1/')
    right_modules=$(grep "\"modules-right\":" "$WAYBAR_CONFIG" | sed 's/.*\[\(.*\)\].*/\1/')
    
    echo "Current left modules: $left_modules"
    echo "Current center modules: $center_modules"
    echo "Current right modules: $right_modules"
    echo ""
    
    print_option "1" "Toggle CPU module"
    print_option "2" "Toggle Memory module"
    print_option "3" "Toggle Network module"
    print_option "4" "Toggle Clock position (left/center/right)"
    print_option "5" "Toggle Custom Weather module"
    print_option "6" "Toggle Custom Power module"
    print_option "0" "Back to Waybar menu"
    echo ""
    
    read -p "Enter your choice [0-6]: " module_choice
    
    case $module_choice in
        1) toggle_waybar_module "cpu" ;;
        2) toggle_waybar_module "memory" ;;
        3) toggle_waybar_module "network" ;;
        4) change_clock_position ;;
        5) toggle_waybar_module "custom/weather" ;;
        6) toggle_waybar_module "custom/power" ;;
        0) waybar_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; configure_waybar_modules ;;
    esac
}

# Function to toggle a waybar module
toggle_waybar_module() {
    module=$1
    
    # Check if the module exists in any position
    if grep -q "\"$module\"" "$WAYBAR_CONFIG"; then
        # Module exists, remove it
        sed -i "s/\"$module\", //g" "$WAYBAR_CONFIG"
        sed -i "s/, \"$module\"//g" "$WAYBAR_CONFIG"
        sed -i "s/\"$module\"//g" "$WAYBAR_CONFIG"
        print_message "Module '$module' removed"
    else
        # Module doesn't exist, add it to right section
        right_modules_line=$(grep -n "\"modules-right\":" "$WAYBAR_CONFIG" | cut -d: -f1)
        right_modules_content=$(grep "\"modules-right\":" "$WAYBAR_CONFIG" | sed 's/.*\[\(.*\)\].*/\1/')
        
        if [ -z "$right_modules_content" ]; then
            # Right modules are empty
            new_right_modules="\"$module\""
        else
            # Add to existing modules
            new_right_modules="$right_modules_content, \"$module\""
        fi
        
        sed -i "${right_modules_line}s/\[.*\]/[$new_right_modules]/" "$WAYBAR_CONFIG"
        print_message "Module '$module' added to right section"
    fi
    
    read -p "Press Enter to continue..."
    configure_waybar_modules
}

# Function to change clock position
change_clock_position() {
    clear
    print_section "Change Clock Position"
    
    echo "Where would you like to position the clock?"
    print_option "1" "Left"
    print_option "2" "Center"
    print_option "3" "Right"
    print_option "0" "Cancel"
    echo ""
    
    read -p "Enter your choice [0-3]: " position_choice
    
    # Remove clock from all positions first
    sed -i 's/\"clock\", //g' "$WAYBAR_CONFIG"
    sed -i 's/, \"clock\"//g' "$WAYBAR_CONFIG"
    sed -i 's/\"clock\"//g' "$WAYBAR_CONFIG"
    
    case $position_choice in
        1) 
            left_modules_line=$(grep -n "\"modules-left\":" "$WAYBAR_CONFIG" | cut -d: -f1)
            left_modules_content=$(grep "\"modules-left\":" "$WAYBAR_CONFIG" | sed 's/.*\[\(.*\)\].*/\1/')
            
            if [ -z "$left_modules_content" ]; then
                new_left_modules="\"clock\""
            else
                new_left_modules="$left_modules_content, \"clock\""
            fi
            
            sed -i "${left_modules_line}s/\[.*\]/[$new_left_modules]/" "$WAYBAR_CONFIG"
            print_message "Clock moved to left section"
            ;;
        2)
            center_modules_line=$(grep -n "\"modules-center\":" "$WAYBAR_CONFIG" | cut -d: -f1)
            center_modules_content=$(grep "\"modules-center\":" "$WAYBAR_CONFIG" | sed 's/.*\[\(.*\)\].*/\1/')
            
            if [ -z "$center_modules_content" ]; then
                new_center_modules="\"clock\""
            else
                new_center_modules="$center_modules_content, \"clock\""
            fi
            
            sed -i "${center_modules_line}s/\[.*\]/[$new_center_modules]/" "$WAYBAR_CONFIG"
            print_message "Clock moved to center section"
            ;;
        3)
            right_modules_line=$(grep -n "\"modules-right\":" "$WAYBAR_CONFIG" | cut -d: -f1)
            right_modules_content=$(grep "\"modules-right\":" "$WAYBAR_CONFIG" | sed 's/.*\[\(.*\)\].*/\1/')
            
            if [ -z "$right_modules_content" ]; then
                new_right_modules="\"clock\""
            else
                new_right_modules="$right_modules_content, \"clock\""
            fi
            
            sed -i "${right_modules_line}s/\[.*\]/[$new_right_modules]/" "$WAYBAR_CONFIG"
            print_message "Clock moved to right section"
            ;;
        0|"")
            print_message "Clock position unchanged"
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
    
    read -p "Press Enter to continue..."
    configure_waybar_modules
}

# Function to configure Waybar colors
configure_waybar_colors() {
    clear
    print_section "Configure Waybar Colors"
    
    print_option "1" "Change background color/opacity"
    print_option "2" "Change text color"
    print_option "3" "Change module colors"
    print_option "0" "Back to Waybar menu"
    echo ""
    
    read -p "Enter your choice [0-3]: " color_choice
    
    case $color_choice in
        1) configure_waybar_bg_color ;;
        2) configure_waybar_text_color ;;
        3) configure_waybar_module_colors ;;
        0) waybar_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; configure_waybar_colors ;;
    esac
}

# Function to configure Waybar background color
configure_waybar_bg_color() {
    clear
    print_section "Configure Waybar Background"
    
    # Get current background
    current_bg=$(grep "background:" "$WAYBAR_STYLE" | head -1 | sed 's/.*background: \(.*\);.*/\1/')
    
    echo "Current background: $current_bg"
    echo ""
    echo "Enter new background color in one of these formats:"
    echo "- HEX: #1e1e2e"
    echo "- RGB: rgb(30, 30, 46)"
    echo "- RGBA: rgba(30, 30, 46, 0.5)"
    echo ""
    
    read -p "Enter new background color (press Enter to keep current): " new_bg
    
    if [ -n "$new_bg" ]; then
        # Validate color format
        if [[ "$new_bg" =~ ^#[0-9A-Fa-f]{6}$ ]] || [[ "$new_bg" =~ ^rgb\([0-9]+,\ *[0-9]+,\ *[0-9]+\)$ ]] || [[ "$new_bg" =~ ^rgba\([0-9]+,\ *[0-9]+,\ *[0-9]+,\ *[0-9]*\.?[0-9]+\)$ ]]; then
            sed -i "s|background: .*|background: $new_bg;|" "$WAYBAR_STYLE"
            print_message "Background color updated to $new_bg"
        else
            print_error "Invalid color format"
        fi
    fi
    
    read -p "Press Enter to continue..."
    configure_waybar_colors
}

# Function to configure Waybar text color
configure_waybar_text_color() {
    clear
    print_section "Configure Waybar Text Color"
    
    # Get current text color
    current_color=$(grep "color:" "$WAYBAR_STYLE" | head -1 | sed 's/.*color: \(.*\);.*/\1/')
    
    echo "Current text color: $current_color"
    echo ""
    echo "Enter new text color in one of these formats:"
    echo "- HEX: #cdd6f4"
    echo "- RGB: rgb(205, 214, 244)"
    echo ""
    
    read -p "Enter new text color (press Enter to keep current): " new_color
    
    if [ -n "$new_color" ]; then
        # Validate color format
        if [[ "$new_color" =~ ^#[0-9A-Fa-f]{6}$ ]] || [[ "$new_color" =~ ^rgb\([0-9]+,\ *[0-9]+,\ *[0-9]+\)$ ]]; then
            sed -i "s|color: .*|color: $new_color;|" "$WAYBAR_STYLE"
            print_message "Text color updated to $new_color"
        else
            print_error "Invalid color format"
        fi
    fi
    
    read -p "Press Enter to continue..."
    configure_waybar_colors
}

# Function to configure Waybar module colors
configure_waybar_module_colors() {
    clear
    print_section "Configure Waybar Module Colors"
    
    print_option "1" "CPU module"
    print_option "2" "Memory module"
    print_option "3" "Clock module"
    print_option "4" "Network module"
    print_option "0" "Back to Waybar colors menu"
    echo ""
    
    read -p "Enter your choice [0-4]: " module_choice
    
    case $module_choice in
        1) configure_module_color "cpu" ;;
        2) configure_module_color "memory" ;;
        3) configure_module_color "clock" ;;
        4) configure_module_color "network" ;;
        0) configure_waybar_colors ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; configure_waybar_module_colors ;;
    esac
}

# Function to configure a specific module's color
configure_module_color() {
    module=$1
    clear
    print_section "Configure $module Module Color"
    
    # Get current module background color
    current_color=$(grep -A 1 "#$module {" "$WAYBAR_STYLE" | grep "background-color:" | sed 's/.*background-color: \(.*\);.*/\1/')
    
    echo "Current $module background color: $current_color"
    echo ""
    echo "Enter new background color in one of these formats:"
    echo "- HEX: #a6e3a1"
    echo "- RGB: rgb(166, 227, 161)"
    echo "- RGBA: rgba(166, 227, 161, 0.4)"
    echo ""
    
    read -p "Enter new background color (press Enter to keep current): " new_color
    
    if [ -n "$new_color" ]; then
        # Validate color format
        if [[ "$new_color" =~ ^#[0-9A-Fa-f]{6}$ ]] || [[ "$new_color" =~ ^rgb\([0-9]+,\ *[0-9]+,\ *[0-9]+\)$ ]] || [[ "$new_color" =~ ^rgba\([0-9]+,\ *[0-9]+,\ *[0-9]+,\ *[0-9]*\.?[0-9]+\)$ ]]; then
            sed -i "/#$module {/,/}/{s/background-color: .*/background-color: $new_color;/}" "$WAYBAR_STYLE"
            print_message "$module background color updated to $new_color"
        else
            print_error "Invalid color format"
        fi
    fi
    
    read -p "Press Enter to continue..."
    configure_waybar_module_colors
}

# Function to configure Waybar position
configure_waybar_position() {
    clear
    print_section "Configure Waybar Position"
    
    # Get current position
    current_position=$(grep "\"position\":" "$WAYBAR_CONFIG" | sed 's/.*: "\(.*\)",/\1/')
    
    echo "Current position: $current_position"
    echo ""
    print_option "1" "Top"
    print_option "2" "Bottom"
    print_option "0" "Back to Waybar menu"
    echo ""
    
    read -p "Enter your choice [0-2]: " position_choice
    
    case $position_choice in
        1) 
            sed -i 's/"position": ".*"/"position": "top"/' "$WAYBAR_CONFIG"
            print_message "Waybar position set to top"
            ;;
        2)
            sed -i 's/"position": ".*"/"position": "bottom"/' "$WAYBAR_CONFIG"
            print_message "Waybar position set to bottom"
            ;;
        0) waybar_menu ;;
        *) print_error "Invalid option. Press any key to continue."; read -n 1; configure_waybar_position ;;
    esac
    
    read -p "Press Enter to continue..."
    waybar_menu
}

# Function to configure Waybar size
configure_waybar_size() {
    clear
    print_section "Configure Waybar Size"
    
    # Get current height
    current_height=$(grep "\"height\":" "$WAYBAR_CONFIG" | sed 's/.*: \(.*\),/\1/')
    
    echo "Current height: $current_height pixels"
    echo ""
    
    read -p "Enter new height in pixels [20-50] (press Enter to keep current): " new_height
    
    if [ -n "$new_height" ]; then
        if [[ "$new_height" =~ ^[0-9]+$ ]] && [ "$new_height" -ge 20 ] && [ "$new_height" -le 50 ]; then
            sed -i "s/\"height\": [0-9]\+/\"height\": $new_height/" "$WAYBAR_CONFIG"
            print_message "Waybar height updated to $new_height pixels"
        else
            print_error "Invalid value. Height must be between 20 and 50 pixels."
        fi
    fi
    
    read -p "Press Enter to continue..."
    waybar_menu
}

# Function to configure Waybar opacity and blur
configure_waybar_opacity() {
    clear
    print_section "Configure Waybar Opacity & Blur"
    
    # Get current values
    current_bg=$(grep "background:" "$WAYBAR_STYLE" | head -1 | sed 's/.*background: \(.*\);.*/\1/')
    current_blur=$(grep "backdrop-filter:" "$WAYBAR_STYLE" | sed 's/.*backdrop-filter: blur(\(.*\));.*/\1/' 2>/dev/null)
    
    echo "Current background: $current_bg"
    if [ -n "$current_blur" ]; then
        echo "Current blur: $current_blur"
    else
        echo "Blur not enabled"
    fi
    echo ""
    
    read -p "Enter new background opacity [0.0-1.0] (press Enter to keep current): " new_opacity
    read -p "Enable blur? (yes/no/press Enter to keep current): " enable_blur
    
    if [ -n "$new_opacity" ]; then
        if [[ "$new_opacity" =~ ^0?\.[0-9]+$ ]] && (( $(echo "$new_opacity <= 1.0" | bc -l) )); then
            # Extract RGB part from current background
            if [[ "$current_bg" =~ rgba ]]; then
                rgb_part=$(echo "$current_bg" | sed 's/rgba(\([0-9]\+, *[0-9]\+, *[0-9]\+\),.*/\1/')
                sed -i "s|background: .*|background: rgba($rgb_part, $new_opacity);|" "$WAYBAR_STYLE"
            elif [[ "$current_bg" =~ rgb ]]; then
                rgb_part=$(echo "$current_bg" | sed 's/rgb(\([0-9]\+, *[0-9]\+, *[0-9]\+\)).*/\1/')
                sed -i "s|background: .*|background: rgba($rgb_part, $new_opacity);|" "$WAYBAR_STYLE"
            elif [[ "$current_bg" =~ ^# ]]; then
                # Convert hex to rgba
                r=$(printf "%d" 0x${current_bg:1:2})
                g=$(printf "%d" 0x${current_bg:3:2})
                b=$(printf "%d" 0x${current_bg:5:2})
                sed -i "s|background: .*|background: rgba($r, $g, $b, $new_opacity);|" "$WAYBAR_STYLE"
            fi
            print_message "Background opacity updated to $new_opacity"
        else
            print_error "Invalid opacity value. Must be between 0.0 and 1.0."
        fi
    fi
    
    if [ -n "$enable_blur" ]; then
        if [[ "$enable_blur" == "yes" ]]; then
            if grep -q "backdrop-filter:" "$WAYBAR_STYLE"; then
                sed -i "s|backdrop-filter: .*|backdrop-filter: blur(5px);|" "$WAYBAR_STYLE"
            else
                sed -i "/window#waybar {/a\ \ \ \ backdrop-filter: blur(5px);" "$WAYBAR_STYLE"
            fi
            print_message "Blur effect enabled"
        elif [[ "$enable_blur" == "no" ]]; then
            sed -i "/backdrop-filter/d" "$WAYBAR_STYLE"
            print_message "Blur effect disabled"
        else
            print_error "Invalid value. Use 'yes' or 'no'."
        fi
    fi
    
    read -p "Press Enter to continue..."
    waybar_menu
}

# Function to add window rule
add_window_rule() {
    clear
    print_section "Add Window Rule"
    
    echo "Window rules apply special properties to certain windows."
    echo "Common rules include: float, workspace, fullscreen, nofocus, etc."
    echo ""
    echo "You need to provide a rule and a window identifier (usually app name or class)."
    echo "The window identifier can be found using 'hyprctl clients'."
    echo ""
    
    read -p "Enter rule (e.g., float, workspace 2): " rule
    read -p "Enter window identifier (e.g., ^(firefox)$, title:^(Calculator)$): " window_id
    
    if [ -n "$rule" ] && [ -n "$window_id" ]; then
        # Find the last window rule line or the section header
        last_rule_line=$(grep -n "^windowrule = " "$HYPR_CONFIG" | tail -1 | cut -d: -f1)
        
        if [ -n "$last_rule_line" ]; then
            # Insert after the last rule
            sed -i "${last_rule_line}a windowrule = $rule, $window_id" "$HYPR_CONFIG"
        else
            # Find window rule section header and insert after it
            rules_section=$(grep -n "# Window rules" "$HYPR_CONFIG" | cut -d: -f1)
            if [ -n "$rules_section" ]; then
                sed -i "${rules_section}a windowrule = $rule, $window_id" "$HYPR_CONFIG"
            else
                # If no section exists, add before key bindings
                key_bindings=$(grep -n "# Key bindings" "$HYPR_CONFIG" | cut -d: -f1)
                sed -i "${key_bindings}i # Window rules\nwindowrule = $rule, $window_id\n" "$HYPR_CONFIG"
            fi
        fi
        
        print_message "Window rule added: $rule for $window_id"
    else
        print_error "Rule and window identifier are required."
    fi
    
    read -p "Press Enter to continue..."
    window_rules_menu
}

# Function to remove window rule
remove_window_rule() {
    clear
    print_section "Remove Window Rule"
    
    # List existing rules with numbers
    echo "Current window rules:"
    grep "^windowrule = " "$HYPR_CONFIG" | cat -n
    echo ""
    
    read -p "Enter the number of the rule to remove: " rule_number
    
    if [ -n "$rule_number" ]; then
        if [[ "$rule_number" =~ ^[0-9]+$ ]]; then
            # Get line number of the rule
            line_number=$(grep -n "^windowrule = " "$HYPR_CONFIG" | sed -n "${rule_number}p" | cut -d: -f1)
            
            if [ -n "$line_number" ]; then
                rule_text=$(sed -n "${line_number}p" "$HYPR_CONFIG")
                sed -i "${line_number}d" "$HYPR_CONFIG"
                print_message "Rule removed: $rule_text"
            else
                print_error "Rule number not found."
            fi
        else
            print_error "Please enter a valid number."
        fi
    fi
    
    read -p "Press Enter to continue..."
    window_rules_menu
}

# Function to list window rules
list_window_rules() {
    clear
    print_section "Window Rules"
    
    echo "Current window rules:"
    grep "^windowrule = " "$HYPR_CONFIG" | cat -n
    echo ""
    
    read -p "Press Enter to continue..."
    window_rules_menu
}

# Function to add/configure monitor
add_monitor() {
    clear
    print_section "Add/Configure Monitor"
    
    # List current monitor configurations
    echo "Current monitor configurations:"
    grep "^monitor=" "$HYPR_CONFIG" | cat -n
    echo ""
    
    echo "Enter monitor details in the format: name,resolution,position,scale"
    echo "Examples:"
    echo "  DP-1,1920x1080@60,0x0,1"
    echo "  HDMI-A-1,1920x1080,1920x0,1"
    echo "  ,preferred,auto,1 (for default monitor)"
    echo ""
    
    read -p "Enter monitor configuration: " monitor_config
    
    if [ -n "$monitor_config" ]; then
        # Check if the format is valid
        if [[ "$monitor_config" =~ ^[^,]*,[^,]*,[^,]*,[^,]*$ ]]; then
            # Find the last monitor line or the section header
            last_monitor_line=$(grep -n "^monitor=" "$HYPR_CONFIG" | tail -1 | cut -d: -f1)
            
            # Extract monitor name
            monitor_name=$(echo "$monitor_config" | cut -d, -f1)
            
            # Check if this monitor already exists
            existing_line=$(grep -n "^monitor=$monitor_name," "$HYPR_CONFIG" | cut -d: -f1)
            
            if [ -n "$existing_line" ]; then
                # Update existing monitor
                sed -i "s|^monitor=$monitor_name,.*|monitor=$monitor_config|" "$HYPR_CONFIG"
                print_message "Updated monitor: $monitor_name"
            else
                # Add new monitor
                sed -i "${last_monitor_line}a monitor=$monitor_config" "$HYPR_CONFIG"
                print_message "Added new monitor: $monitor_config"
            fi
        else
            print_error "Invalid format. Please use: name,resolution,position,scale"
        fi
    fi
    
    read -p "Press Enter to continue..."
    monitor_menu
}

# Function to remove monitor configuration
remove_monitor() {
    clear
    print_section "Remove Monitor Configuration"
    
    # List current monitor configurations
    echo "Current monitor configurations:"
    grep "^monitor=" "$HYPR_CONFIG" | cat -n
    echo ""
    
    read -p "Enter the number of the monitor to remove: " monitor_number
    
    if [ -n "$monitor_number" ]; then
        if [[ "$monitor_number" =~ ^[0-9]+$ ]]; then
            # Get line number of the monitor
            line_number=$(grep -n "^monitor=" "$HYPR_CONFIG" | sed -n "${monitor_number}p" | cut -d: -f1)
            
            if [ -n "$line_number" ]; then
                monitor_text=$(sed -n "${line_number}p" "$HYPR_CONFIG")
                
                # Check if it's the default monitor
                if [[ "$monitor_text" == "monitor=,preferred,auto,1" ]]; then
                    print_error "Cannot remove default monitor configuration."
                else
                    sed -i "${line_number}d" "$HYPR_CONFIG"
                    print_message "Monitor removed: $monitor_text"
                fi
            else
                print_error "Monitor number not found."
            fi
        else
            print_error "Please enter a valid number."
        fi
    fi
    
    read -p "Press Enter to continue..."
    monitor_menu
}

# Function to list monitor configurations
list_monitors() {
    clear
    print_section "Monitor Configurations"
    
    echo "Current monitor configurations:"
    grep "^monitor=" "$HYPR_CONFIG" | cat -n
    echo ""
    
    read -p "Press Enter to continue..."
    monitor_menu
}

# Function to apply changes
apply_changes() {
    clear
    print_section "Applying Changes"
    
    print_message "All changes have been saved to configuration files."
    print_message "To apply these changes, you can:"
    print_message "1. Restart Hyprland (SUPER+M and then log back in)"
    print_message "2. Reload Waybar by killing it and letting it restart"
    print_message "   (usually 'killall waybar' will do this, as it's set to auto-restart)"
    
    read -p "Would you like to restart Waybar now? (y/n): " restart_waybar
    
    if [[ "$restart_waybar" == "y" || "$restart_waybar" == "Y" ]]; then
        killall waybar 2>/dev/null
        print_message "Waybar has been restarted."
    fi
    
    print_message "Configuration complete!"
    exit 0
}

# Start the wizard
show_main_menu