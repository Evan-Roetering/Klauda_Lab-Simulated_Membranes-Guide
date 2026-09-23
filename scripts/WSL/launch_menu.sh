#!/usr/bin/env bash

# Directory containing your SSH scripts
SCRIPT_DIR="$HOME/bin/ssh_scripts"

# Get list of scripts
mapfile -t scripts < <(find "$SCRIPT_DIR" -maxdepth 1 -type f -executable | sort -r)

echo "=============================="
echo "   SSH / WSL Launcher Menu"
echo "=============================="
echo "1) Stay in local WSL"

# Print menu dynamically
for i in "${!scripts[@]}"; do
    name="Login to $(basename "${scripts[$i]}") over ssh"
    echo "$((i+2))) $name"
done

echo "------------------------------"
read -rp "Select an option: " choice

# Handle input
if [[ "$choice" == "1" ]]; then
    echo "Staying in local WSL..."
    cd ~
    exit 0
fi

index=$((choice - 2))

if [[ $index -ge 0 && $index -lt ${#scripts[@]} ]]; then
    selected_script="${scripts[$index]}"
    echo "Loggin in to $(basename "$selected_script") over ssh..."
    exec "$selected_script"
else
    echo "Invalid selection."
    exit 1
fi
