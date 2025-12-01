#!/bin/bash

# Read JSON input
input=$(cat)

# Extract information from JSON
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "$(pwd)"')
output_style=$(echo "$input" | jq -r '.output_style.name // ""')

# Get basic info
user=$(whoami)
hostname=$(hostname -s)
os_icon=""  # No OS icon

# Directory with substitutions (from your starship.toml)
dir_name=$(basename "$current_dir")
case "$dir_name" in
    "Desktop") dir_substitution=" " ;;
    "Documents") dir_substitution=" " ;;
    "Downloads") dir_substitution=" " ;;
    "Music") dir_substitution="󰎈 " ;;
    "Pictures") dir_substitution=" " ;;
    "Videos") dir_substitution=" " ;;
    "GitHub") dir_substitution="󰊤 " ;;
    *) dir_substitution="" ;;
esac

# Show directory with substitution or basename
if [[ -n "$dir_substitution" ]]; then
    display_dir="$dir_substitution"
else
    # Show truncated path like starship (max 3 levels)
    display_dir=$(echo "$current_dir" | sed "s|$HOME| |" | sed -E 's|([^/]+/[^/]+/[^/]+/).*/|\1••/|')
fi

# Git info
if git rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git branch --show-current 2>/dev/null || echo "HEAD")
    git_status=""
    
    # Check for changes
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        git_status=" "  # Modified indicator
    fi
    
    # Check for untracked files
    if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
        git_status="$git_status ?"  # Untracked indicator
    fi
    
    # Check if ahead/behind
    if git rev-parse --verify @{u} >/dev/null 2>&1; then
        ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
        behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
        
        if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
            git_status="$git_status ⇕⇡$ahead⇣$behind"
        elif [[ "$ahead" -gt 0 ]]; then
            git_status="$git_status ⇡$ahead"
        elif [[ "$behind" -gt 0 ]]; then
            git_status="$git_status ⇣$behind"
        else
            git_status="$git_status ✓"
        fi
    fi
    
    git_info="  $git_branch$git_status"
else
    git_info=""
fi

# No language version display

# Output style indicator
if [[ -n "$output_style" && "$output_style" != "default" ]]; then
    style_indicator=" [$output_style]"
else
    style_indicator=""
fi

# Build final status line
left_part="$display_dir$git_info"
right_part="$model$style_indicator"

# Use printf to handle the colors and spacing
printf "%s%s%s" "$left_part" "$(printf '%*s' $((40 - ${#left_part} - ${#right_part})) '')" "$right_part"