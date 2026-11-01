#!/bin/bash

PROJECT_FOLDER=$HOME/Projects/Programming
LOGFILE=$HOME/.cache/open_project.log

# Capture all errors from tmux/rofi for debugging
mkdir -p "$(dirname "$LOGFILE")"
exec 2>> "$LOGFILE"
echo "=== run $(date '+%F %T') ===" >&2

# Pick a project with rofi
PROJECT_NAME=$(find "$PROJECT_FOLDER" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort | rofi -dmenu -i -p "Open Project")

if [ -z "$PROJECT_NAME" ]; then
    exit 0
fi

PROJECT_PATH="$PROJECT_FOLDER/$PROJECT_NAME"

# . and : are special in tmux target syntax, so replace them
SESSION_NAME=$(echo "$PROJECT_NAME" | tr '.: ' '___')

# Build the session if it doesn't exist yet
if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "creating session '$SESSION_NAME' in '$PROJECT_PATH'" >&2
    # Create a detached session in the project directory
    NVIM_WINDOW=$(tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_PATH" -P -F '#{window_id}')
    echo "nvim window: $NVIM_WINDOW" >&2

    # First tab: open nvim
    tmux send-keys -t "$NVIM_WINDOW" "nvim ." Enter

    # Second tab: plain shell
    tmux new-window -t "$SESSION_NAME" -c "$PROJECT_PATH"
    echo "windows now:" >&2
    tmux list-windows -t "$SESSION_NAME" >&2

    # Put focus back on the nvim tab
    tmux select-window -t "$NVIM_WINDOW"
else
    echo "session '$SESSION_NAME' already exists, attaching" >&2
fi

# Open the session in a new ghostty window
ghostty -e tmux attach-session -t "$SESSION_NAME" &
