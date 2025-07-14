function fontswap() {
    if [[ "$1" == "init" ]]; then
        if [[ ! -d ~/.local/share/fonts ]]; then
            mkdir -p ~/.local/share/fonts
        fi
        cp $CS/core-config/fonts/*.ttf ~/.local/share/fonts/
        fc-cache -fv
        echo "Fonts installed and cache updated."
        return 1
    fi
    if [[ "$1" == "list" ]]; then
        echo "Available fonts:"
        fc-list : family | sort -u | nl
        return 1
    fi
    if [[ "$1" == "swap" ]]; then
        # Read font list into array properly (Zsh compatible)
        fonts=(${(f)"$(fc-list : family | sort -u)"})
        
        echo "Select the font number to swap to (or press Enter to type font name manually):"
        echo "Available fonts:"
        
        # Display numbered list (Zsh compatible)
        for i in {1..${#fonts[@]}}; do
            printf "%d) %s\n" $i "${fonts[$i]}"
        done
        echo
        
        while true; do
            echo -n "Enter font number (or type font name): "
            read input
            
            # Check if input is a number
            if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -ge 1 ] && [ "$input" -le "${#fonts[@]}" ]; then
                font="${fonts[$input]}"
                echo "You selected font: $font"
                break
            elif [[ -n "$input" ]]; then
                # Try to find the font by name
                if printf '%s\n' "${fonts[@]}" | grep -Fxq "$input"; then
                    font="$input"
                    echo "You selected font: $font"
                    break
                else
                    echo "Font '$input' not found. Please try again."
                fi
            else
                echo "Please enter a valid font number or name."
            fi
        done
        
        echo "Swapping font to '$font'..."
        # --- Actual swap logic for GNOME Terminal ---
        PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[],' " | cut -d',' -f1)
        if [[ -n "$PROFILE" ]]; then
            gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font "$font 12"
            echo "GNOME Terminal font changed to: $font 12"
        else
            echo "Could not find GNOME Terminal profile ID. Font swap failed."
        fi
	
	reload

        return 1
    fi
    echo "'$1' is not an existing command. Use 'init', 'list', or 'swap'."
    return 1
}
