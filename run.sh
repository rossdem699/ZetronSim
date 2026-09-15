#!/usr/bin/env bash
PORT=8080
echo "Starting Mawson Station Comms Console on http://localhost:$PORT ..."
if which google-chrome >/dev/null 2>&1; then
  (sleep 1 && google-chrome "http://localhost:$PORT") &
elif which xdg-open >/dev/null 2>&1; then
  (sleep 1 && xdg-open "http://localhost:$PORT") &
fi
python3 -m http.server $PORT
