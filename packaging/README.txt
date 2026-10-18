LogAnalyser - local package
============================

Windows
-------
Double-click LogAnalyser.Api.exe. No console window opens, and your browser
opens to http://localhost:5171 automatically after a few seconds. To stop
LogAnalyser, click your name in the top bar, then Quit Log Analyser.

macOS / Linux
-------------
Open Terminal in this folder and run:
    chmod +x run.sh
    ./run.sh
(chmod is only needed the first time.) Your browser opens to
http://localhost:5171 automatically after a few seconds. Leave the Terminal
window open; closing it or pressing Ctrl+C stops LogAnalyser.

First time use
---------------
Sign up for an account in the browser, create a project (list the services
whose logs you want analysed), then add an environment with the log path
you have access to. LogAnalyser checks for new environments/log paths
automatically every 10 minutes by default, and immediately the first time you
add or change one. To change how often, click your name in the top bar and
pick 2, 5, 7 or 10 minutes under "Check logs every".

What you get
------------
Problems: repeating errors grouped, with New / Spiking / Known status.
Logs: every log line searchable by text, level, service and time, with live
tail. Lines are kept per level (Error/Warn 15 days, Info 3 days, Debug off
by default). Performance: response time per endpoint. Dashboard buttons
export the problems to CSV and a weekly digest to HTML.

Other log formats and settings
-------------------------------
By default the logs must look like:
    2025-01-31 14:05:09,123 -- ERROR -- service-name -- message
For another format, close LogAnalyser and add settings to config.json next to
the program (keep the "stateDatabase" line): "logFormat": "json" for JSON
lines, "logPattern" and "timestampFormat" for another text format,
"eventMinLevel", "warnErrorEventDays", "infoEventDays", "debugEventDays" and
"retentionDays" for what the Logs page keeps. See the README for details.

Updating to a new version
--------------------------
Replace LogAnalyser.Api.exe (Windows) or LogAnalyser.Api and run.sh
(macOS/Linux) with the ones from the new release. Leave config.json, app.db
and the environments/ folder alone - that's where your accounts, projects
and history live.
