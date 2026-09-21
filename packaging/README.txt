LogAnalyser - local package
============================

Windows
-------
Double-click LogAnalyser.Api.exe. No console window opens, and your browser
opens to http://localhost:5171 automatically after a few seconds. To stop
LogAnalyser, double-click stop.bat.

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
automatically every 10 minutes, and immediately the first time you add or
change one.

Updating to a new version
--------------------------
Replace LogAnalyser.Api.exe (Windows) or LogAnalyser.Api and run.sh
(macOS/Linux) with the ones from the new release. Leave config.json, app.db
and the environments/ folder alone - that's where your accounts, projects
and history live.
