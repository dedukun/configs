#!/bin/sh
# SOURCE: https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/pulseaudio-microphone

status() {
  MUTED=$(pacmd list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')

  if [ "$MUTED" = "yes" ]; then
    echo ""
  else
    echo ""
    # cat "/tmp/polybar-pulseaudio-microphone"
  fi
}

listen() {
  status

  LANG=en_GB.UTF-8
  pactl subscribe | while read -r event; do
    if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
      status
    fi
  done
}

toggle() {
  MUTED=$(pacmd list-sources | awk '/\*/,EOF {print}' | awk '/muted/ {print $2; exit}')
  DEFAULT_SOURCE=$(pacmd list-sources | awk '/\*/,EOF {print $3; exit}')

  if [ "$MUTED" = "yes" ]; then
    pacmd set-source-mute "$DEFAULT_SOURCE" 0
  else
    pacmd set-source-mute "$DEFAULT_SOURCE" 1
  fi
}

case "$1" in
--toggle)
  toggle
  ;;
*)
  listen
  ;;
esac
