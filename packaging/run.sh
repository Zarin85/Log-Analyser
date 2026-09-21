#!/bin/bash
cd "$(dirname "$0")"

chmod +x LogAnalyser.Api 2>/dev/null

# The app opens the browser itself once it's actually listening (see Program.cs), and
# creates config.json/app.db next to itself automatically on first run - nothing to set
# up here.
./LogAnalyser.Api &
API_PID=$!

trap "kill $API_PID 2>/dev/null" EXIT

echo "LogAnalyser is running. Close this window or press Ctrl+C to stop it."
wait
