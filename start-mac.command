#!/usr/bin/env bash
cd "$(dirname "$0")"
echo "Starting Zetron DCS5020 Console on Mac..."
which open >/dev/null 2>&1 && (sleep 1 && open "http://localhost:8080") &
python3 -m http.server 8080
