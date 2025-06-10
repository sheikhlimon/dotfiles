#!/bin/bash

STATE_FILE="/tmp/eye_timer_state"
DURATION=1800  # 30 minutes
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/complete.oga"

start_timer() {
  echo "$(date +%s)" > "$STATE_FILE"
  show_timer
}

stop_timer() {
  rm -f "$STATE_FILE"
  echo '{"text":"⏳","class":"eye-timer"}'
}

show_timer() {
  if [[ ! -f "$STATE_FILE" ]]; then
    # Timer not running
    echo '{"text":"⏳","tooltip":"Click to start eye break timer","class":"eye-timer"}'
    return
  fi

  start_time=$(<"$STATE_FILE")
  now=$(date +%s)
  elapsed=$(( now - start_time ))
  remaining=$(( DURATION - elapsed ))

  if (( remaining <= 0 )); then
    # Timer done — notify with restart button and play sound
    notify-send -u normal -t 30000 \
      "👓 Time to rest your eyes!" \
      "Take a 30-second break" \
      -h string:x-canonical-private-synchronous:eye_timer \
      -a eye_timer \
      -u normal \
      -i face-glasses-symbolic \
      -h string:desktop-entry:eye_timer \
      -h string:actions:Restart \
      -h string:urgency:normal

    paplay "$SOUND_FILE" 2>/dev/null &

    # Remove timer state
    rm -f "$STATE_FILE"
    echo '{"text":"⏳","class":"eye-timer"}'
  else
    min=$(( remaining / 60 ))
    sec=$(( remaining % 60 ))
    printf '{"text":"👓 %02d:%02d","tooltip":"Rest eyes in %02d:%02d","class":"eye-timer"}\n' "$min" "$sec" "$min" "$sec"
  fi
}

case "$1" in
  start) start_timer ;;
  stop) stop_timer ;;
  *) show_timer ;;
esac
