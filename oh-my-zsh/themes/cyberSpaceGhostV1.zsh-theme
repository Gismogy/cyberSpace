# Enhanced CyberSpace Ghost Theme with Toggleable Export Values
# Update your existing cyberSpaceGhostV1.zsh-theme with this content

# Default state - exports shown by default
cs_show_exports=true

# Function to show CS exports with values (toggleable)
cs_exports_info() {
    local cs_info=""
    
    # Only show if toggle is enabled and CS is set
    if [[ "$cs_show_exports" == "true" && -n "$CS" ]]; then
        cs_info="%F{cyan}CS:%F{white}${CS##*/}%f "
        
        # Add sub-exports with shortened paths
        [[ -n "$CS_CORE" ]] && cs_info="${cs_info}%F{green}CORE:%F{white}${CS_CORE##*/}%f "
        [[ -n "$CS_FUNC" ]] && cs_info="${cs_info}%F{magenta}FUNC:%F{white}${CS_FUNC##*/}%f "
        [[ -n "$CS_JSON" ]] && cs_info="${cs_info}%F{yellow}JSON:%F{white}${CS_JSON##*/}%f "
    fi
    
    echo "$cs_info"
}

# Function to show full export paths (for right prompt or when needed)
cs_full_exports() {
    local exports_list=""
    
    [[ -n "$CS" ]] && exports_list="${exports_list}%F{cyan}CS=%F{white}$CS%f\n"
    [[ -n "$CS_CORE" ]] && exports_list="${exports_list}%F{green}CS_CORE=%F{white}$CS_CORE%f\n"
    [[ -n "$CS_FUNC" ]] && exports_list="${exports_list}%F{magenta}CS_FUNC=%F{white}$CS_FUNC%f\n"
    [[ -n "$CS_JSON" ]] && exports_list="${exports_list}%F{yellow}CS_JSON=%F{white}$CS_JSON%f\n"
    
    echo "$exports_list"
}

# Enhanced prompt with CS exports
PROMPT='%F{cyan}%n@%m %F{yellow}%~ $(cs_exports_info)%F{green}➜ %f'

# Right prompt shows time and optionally CS path
RPROMPT='%F{red}[%*]%f %F{blue}${CS:+CS:${CS##*/}}%f'

# Toggle functions for showing/hiding exports
cs-show() {
    cs_show_exports=true
    echo "%F{green}CS exports now visible in prompt%f"
}

cs-hide() {
    cs_show_exports=false
    echo "%F{red}CS exports now hidden from prompt%f"
}

# Optional: Add a function to quickly show all exports
alias cs-exports='echo -e "$(cs_full_exports)"'

# Status function to check current toggle state
cs-status() {
    if [[ "$cs_show_exports" == "true" ]]; then
        echo "%F{green}CS exports are currently VISIBLE%f"
    else
        echo "%F{red}CS exports are currently HIDDEN%f"
    fi
}
