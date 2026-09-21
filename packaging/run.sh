#!/bin/bash
cd "$(dirname "$0")"

if [ ! -f config.json ]; then
    cp config.template.json config.json
fi

chmod +x api/LogAnalyser.Api collector/LogAnalyser 2>/dev/null

./collector/LogAnalyser --config config.json watch &
COLLECTOR_PID=$!
./api/LogAnalyser.Api &
API_PID=$!

trap "kill $COLLECTOR_PID $API_PID 2>/dev/null" EXIT

sleep 3
open http://localhost:5171 2>/dev/null || xdg-open http://localhost:5171 2>/dev/null

echo "LogAnalyser is running. Close this window or press Ctrl+C to stop it."
wait
