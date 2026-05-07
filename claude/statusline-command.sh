#!/bin/bash

# Read JSON input
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // "$(pwd)"')
output_style=$(echo "$input" | jq -r '.output_style.name // ""')

# Context window
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // null')

# OS icon — Arch
printf '\033[36m \033[0m'

# Directory with starship substitutions
dir_name=$(basename "$current_dir")
case "$dir_name" in
    Desktop)   printf ' ' ;;
    Documents) printf ' ' ;;
    Downloads) printf ' ' ;;
    Music)     printf '󰎈 ' ;;
    Pictures)  printf ' ' ;;
    Videos)    printf ' ' ;;
    GitHub)    printf '󰊤 ' ;;
    *)         printf '%s' "$(echo "$current_dir" | sed "s|^$HOME|~|" | sed -E 's|([^/]+/[^/]+/[^/]+/).*/|\1••/|')" ;;
esac

# Git branch + status (matching starship git_status symbols)
if git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git -C "$current_dir" --no-optional-locks branch --show-current 2>/dev/null || echo "HEAD")
    git_status=""

    # Modified
    git -C "$current_dir" --no-optional-locks diff-index --quiet HEAD -- 2>/dev/null || git_status="$git_status "
    # Untracked
    [[ -n $(git -C "$current_dir" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null) ]] && git_status="$git_status ?"
    # Ahead/behind
    if git -C "$current_dir" rev-parse --verify @{u} >/dev/null 2>&1; then
        ahead=$(git -C "$current_dir" --no-optional-locks rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
        behind=$(git -C "$current_dir" --no-optional-locks rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
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

    printf ' \033[36m %s\033[0m%s' "$git_branch" "$git_status"

    # Git metrics (added/deleted lines) — like starship git_metrics
    metrics=$(git -C "$current_dir" --no-optional-locks diff --stat 2>/dev/null | tail -1)
    if [[ -n "$metrics" ]]; then
        added=$(git -C "$current_dir" --no-optional-locks diff --numstat 2>/dev/null | awk '{s+=$1} END {print s}')
        deleted=$(git -C "$current_dir" --no-optional-locks diff --numstat 2>/dev/null | awk '{s+=$2} END {print s}')
        if [[ -n "$added" && "$added" != "0" ]]; then
            printf ' \033[32m[▴%s]\033[0m' "$added"
        fi
        if [[ -n "$deleted" && "$deleted" != "0" ]]; then
            printf ' \033[31m[▿%s]\033[0m' "$deleted"
        fi
    fi
fi

# Right side: model + output style + context
right=""
if [[ -n "$output_style" && "$output_style" != "default" ]]; then
    right="$right [$output_style]"
fi

if [[ "$used_percentage" != "null" && -n "$used_percentage" ]]; then
    context_k=$((context_size / 1000))
    right="$right ${used_percentage}% ${context_k}k"
fi

# Model name
printf ' \033[2m%s\033[0m' "$model"
printf '%s' "$right"