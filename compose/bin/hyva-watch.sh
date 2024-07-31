#!/usr/bin/env bash

# Load theme path from environment file
source env/theme.env

# Ensure HYVA_THEME_PATH is set
if [ -z "$HYVA_THEME_PATH" ]; then
  echo "HYVA_THEME_PATH is not set in theme.env"
  exit 1
fi

# Debugging output
echo "HYVA_THEME_PATH: ${HYVA_THEME_PATH}"

TAILWIND_DIR="${HYVA_THEME_PATH}/web/tailwind"

# Check if the tailwind directory exists inside the Docker container
if ! bin/cli sh -c "[ -d '${TAILWIND_DIR}' ]"; then
  echo "Tailwind directory not found at ${TAILWIND_DIR} inside the Docker container."
  exit 1
fi

# Run the npm command
if [ "$1" == "--watch" ]; then
  # Kill duplicate watch process
  WATCH_PID=$(bin/clinotty ps -eaf | grep "npm run watch" | grep -v grep | awk '{print $2}')
  if [[ "" !=  "$WATCH_PID" ]]; then
    bin/cliq kill -9 "$WATCH_PID"
  fi

  # Run watch mode in the background
  bin/cliq sh -c "cd ${TAILWIND_DIR} && npm run --silent watch" &
  echo "npm run watch started in the background."
else
  bin/cli sh -c "cd ${TAILWIND_DIR} && npm run watch"
fi
