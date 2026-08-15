#!/bin/bash
# Portable screen recording script - works with any Hyprland setup
# (Based on omarchy-capture-screenrecording, omarchy-specific bits removed)
#
# Usage:
#   screenrecord                           # pick monitor/region and record
#   screenrecord --with-desktop-audio      # include system audio
#   screenrecord --with-microphone-audio   # include microphone
#   screenrecord --with-webcam             # include webcam overlay
#   screenrecord --stop-recording          # stop current recording
#
# Env vars:
#   SCREENRECORD_DIR=...       # output dir (default: $XDG_VIDEOS_DIR or ~/Videos)
#   SCREENRECORD_USE_PORTAL=1  # use xdg-desktop-portal (for HDR, external GPU)
#   SCREENRECORD_DEBUG=1       # log to /tmp/screenrecord.log

[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="${SCREENRECORD_DIR:-${XDG_VIDEOS_DIR:-$HOME/Videos}}"

if [[ ! -d $OUTPUT_DIR ]]; then
  notify-send "Screen recording directory does not exist: $OUTPUT_DIR" -u critical -t 3000
  exit 1
fi

DESKTOP_AUDIO="false"
MICROPHONE_AUDIO="false"
WEBCAM="false"
WEBCAM_DEVICE=""
RESOLUTION=""
STOP_RECORDING="false"
RECORDING_FILE="/tmp/screenrecord-filename"
LOG_FILE=$([[ ${SCREENRECORD_DEBUG:-false} == "true" ]] && echo "/tmp/screenrecord.log" || echo "/dev/null")

for arg in "$@"; do
  case "$arg" in
  --with-desktop-audio) DESKTOP_AUDIO="true" ;;
  --with-microphone-audio) MICROPHONE_AUDIO="true" ;;
  --with-webcam) WEBCAM="true" ;;
  --webcam-device=*) WEBCAM_DEVICE="${arg#*=}" ;;
  --resolution=*) RESOLUTION="${arg#*=}" ;;
  --stop-recording) STOP_RECORDING="true" ;;
  esac
done

start_webcam_overlay() {
  cleanup_webcam

  if [[ -z $WEBCAM_DEVICE ]]; then
    WEBCAM_DEVICE=$(v4l2-ctl --list-devices 2>/dev/null | grep -m1 "^[[:space:]]*/dev/video" | tr -d '\t')
    if [[ -z $WEBCAM_DEVICE ]]; then
      notify-send "No webcam devices found" -u critical -t 3000
      return 1
    fi
  fi

  local scale=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .scale')
  local target_width=$(awk "BEGIN {printf \"%.0f\", 360 * $scale}")

  local preferred_resolutions=("640x360" "1280x720" "1920x1080")
  local video_size_arg=""
  local available_formats=$(v4l2-ctl --list-formats-ext -d "$WEBCAM_DEVICE" 2>/dev/null)

  for resolution in "${preferred_resolutions[@]}"; do
    if echo "$available_formats" | grep -q "$resolution"; then
      video_size_arg="-video_size $resolution"
      break
    fi
  done

  ffplay -f v4l2 $video_size_arg -framerate 30 "$WEBCAM_DEVICE" \
    -vf "crop=iw/2:ih,scale=${target_width}:-1" \
    -window_title "WebcamOverlay" \
    -noborder \
    -fflags nobuffer -flags low_delay \
    -probesize 32 -analyzeduration 0 \
    -loglevel quiet &
  sleep 1
}

cleanup_webcam() {
  pkill -f "WebcamOverlay" 2>/dev/null
}

default_resolution() {
  local width height
  read -r width height < <(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.width) \(.height)"')
  if ((width > 3840 || height > 2160)); then
    echo "3840x2160"
  else
    echo "0x0"
  fi
}

get_rectangles() {
  local active_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')
  hyprctl monitors -j | jq -r --arg ws "$active_workspace" '
    .[] | select(.activeWorkspace.id == ($ws | tonumber)) |
    "\(.x),\(.y) \(.width / .scale | floor)x\(.height / .scale | floor)"'
  hyprctl clients -j | jq -r --arg ws "$active_workspace" '
    .[] | select(.workspace.id == ($ws | tonumber)) |
    "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
}

select_capture_target() {
  local rects=$(get_rectangles)
  hyprpicker -r -z >/dev/null 2>&1 &
  local picker_pid=$!
  sleep .1
  local selection=$(echo "$rects" | slurp 2>/dev/null)
  kill $picker_pid 2>/dev/null

  [[ $selection =~ ^(-?[0-9]+),(-?[0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]] || return 1
  local sx=${BASH_REMATCH[1]} sy=${BASH_REMATCH[2]}
  local sw=${BASH_REMATCH[3]} sh=${BASH_REMATCH[4]}

  if ((sw * sh < 20)); then
    while IFS= read -r rect; do
      [[ $rect =~ ^(-?[0-9]+),(-?[0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]] || continue
      local rx=${BASH_REMATCH[1]} ry=${BASH_REMATCH[2]}
      local rw=${BASH_REMATCH[3]} rh=${BASH_REMATCH[4]}
      if ((sx >= rx && sx < rx + rw && sy >= ry && sy < ry + rh)); then
        sx=$rx sy=$ry sw=$rw sh=$rh
        break
      fi
    done <<<"$rects"
  fi

  local monitor=$(hyprctl monitors -j | jq -r --argjson x "$sx" --argjson y "$sy" --argjson w "$sw" --argjson h "$sh" '
    .[] | select(.x == $x and .y == $y and (.width / .scale | floor) == $w and (.height / .scale | floor) == $h) | .name' | head -1)

  if [[ -n $monitor ]]; then
    echo "monitor:$monitor"
    return
  fi

  echo "region:${sw}x${sh}+${sx}+${sy}"
}

start_screenrecording() {
  local capture_args=()
  local target

  if [[ ${SCREENRECORD_USE_PORTAL:-false} == "true" ]]; then
    target="portal"
    capture_args=(-w portal -s "${RESOLUTION:-$(default_resolution)}")
  else
    target=$(select_capture_target) || return 1

    case $target in
    monitor:*)
      capture_args=(-w "${target#monitor:}" -s "${RESOLUTION:-$(default_resolution)}")
      ;;
    region:*)
      capture_args=(-w "${target#region:}")
      [[ -n $RESOLUTION ]] && capture_args+=(-s "$RESOLUTION")
      ;;
    esac
  fi

  [[ $WEBCAM == "true" ]] && start_webcam_overlay

  local filename="$OUTPUT_DIR/screenrecording-$(date +'%Y-%m-%d_%H-%M-%S').mp4"
  local audio_devices=""
  local audio_args=()

  [[ $DESKTOP_AUDIO == "true" ]] && audio_devices+="default_output"

  if [[ $MICROPHONE_AUDIO == "true" ]]; then
    [[ -n $audio_devices ]] && audio_devices+="|"
    audio_devices+="default_input"
  fi

  [[ -n $audio_devices ]] && audio_args+=(-a "$audio_devices" -ac aac)

  echo "===== $(date '+%F %T') args: $* target: $target =====" >>"$LOG_FILE"
  gpu-screen-recorder "${capture_args[@]}" -k auto -f 60 -fm cfr -fallback-cpu-encoding yes -o "$filename" "${audio_args[@]}" 2>>"$LOG_FILE" &
  local pid=$!

  while kill -0 $pid 2>/dev/null && [[ ! -f $filename ]]; do
    sleep 0.2
  done

  if kill -0 $pid 2>/dev/null; then
    echo "$filename" >"$RECORDING_FILE"
    notify-send "Screen recording started" "$filename" -t 3000
  fi
}

stop_screenrecording() {
  pkill -SIGINT -f "^gpu-screen-recorder"

  local count=0
  while pgrep -f "^gpu-screen-recorder" >/dev/null && ((count < 50)); do
    sleep 0.1
    count=$((count + 1))
  done

  cleanup_webcam

  if pgrep -f "^gpu-screen-recorder" >/dev/null; then
    pkill -9 -f "^gpu-screen-recorder"
    notify-send "Screen recording error" "Process had to be force-killed. Video may be corrupted." -u critical -t 5000
  else
    finalize_recording
    local filename=$(cat "$RECORDING_FILE" 2>/dev/null)
    echo "$filename"
    local preview="${filename%.mp4}-preview.png"

    ffmpeg -y -i "$filename" -ss 00:00:00.1 -vframes 1 -q:v 2 "$preview" -loglevel quiet 2>/dev/null

    (
      ACTION=$(notify-send "Screen recording saved" "Click to open" -t 10000 -i "${preview:-$filename}" -A "default=open")
      [[ $ACTION == "default" ]] && mpv "$filename"
      rm -f "$preview"
    ) &
  fi

  rm -f "$RECORDING_FILE"
}

finalize_recording() {
  local latest
  latest=$(cat "$RECORDING_FILE" 2>/dev/null)
  [[ -f $latest ]] || return

  local video_codec=(-c:v copy)
  if ffprobe -v error -select_streams v:0 -read_intervals %+0.2 -show_entries packet=flags -of csv=p=0 "$latest" 2>/dev/null | grep -q D; then
    video_codec=(-c:v libx264 -preset veryfast -crf 20)
  fi

  local args=(-y -ss 0.1 -i "$latest" "${video_codec[@]}")
  if ffprobe -v error -select_streams a -show_entries stream=codec_type -of csv=p=0 "$latest" 2>/dev/null | grep -q audio; then
    args+=(-af "volume=enable='lt(t,0.4)':volume=0,afade=t=in:st=0.4:d=0.05,loudnorm=I=-14:TP=-1.5:LRA=11")
  fi

  local processed="${latest%.mp4}-processed.mp4"
  if ffmpeg "${args[@]}" "$processed" -loglevel quiet 2>/dev/null; then
    mv "$processed" "$latest"
  else
    rm -f "$processed"
  fi
}

if pgrep -f "^gpu-screen-recorder" >/dev/null; then
  stop_screenrecording
elif [[ $STOP_RECORDING == "true" ]]; then
  exit 1
else
  start_screenrecording || cleanup_webcam
fi
