LogAnalyser - local package
============================

Windows
-------
Double-click run.bat. Both the API and the collector start in the background
(no console windows) and your browser opens to http://localhost:5171 after a
few seconds. To stop LogAnalyser, double-click stop.bat.

macOS
-----
Open Terminal in this folder and run:
    chmod +x run.sh
    ./run.sh
(chmod is only needed the first time.) Your browser opens to
http://localhost:5171 after a few seconds. Leave the Terminal window open;
closing it or pressing Ctrl+C stops both the API and the collector.

First time use
---------------
Sign up for an account in the browser, create a project (list the services
whose logs you want analysed), then add an environment with the log path
you have access to. The collector checks for new environments/log paths
automatically every 10 minutes, and immediately the first time you add or
change one.

Updating to a new version
--------------------------
Replace the api/ and collector/ folders with the ones from the new
release. Leave config.json, app.db and the environments/ folder alone -
that's where your accounts, projects and history live.
