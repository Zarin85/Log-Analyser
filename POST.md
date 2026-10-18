🔍 Log Analyser: Stop Reading Logs Line by Line!

Hello General,

Ever opened a log file and scrolled through hundreds of near-identical errors, just to find out what actually broke? I built a tool so we never have to do that again. 🚀

Log Analyser reads our .log files and groups repeating errors together. Instead of 90 error lines, you see 1 problem that happened 90 times.

Point it at a service like this:
\\server\AKS-Dev-Logs\business-clm\dev-business-clm-analytics\ClmAnalyticsWebService
and within minutes you get a clean list of problems.

✨ What you get
• Errors grouped automatically, no more scrolling through duplicates
• A status on every problem: New, Spiking or Known, so you instantly see what just broke
• Suppress harmless noise, or mark a problem Resolved once it's fixed
• Exactly where it happened: class, method, file and line
• Errors that hit more than one service are flagged Critical
• Average, fastest and slowest response time for every endpoint
• You pick how fresh the data is: it checks every 2, 5, 7 or 10 minutes

🔒 Safe to use
• Runs on your own computer, nothing goes to the cloud
• It only reads your logs, it never changes them
• Emails, tokens and passwords are hidden before anything is shown

⚡ Get started in 2 minutes
1. Download the zip for Windows / macOS / Linux and extract it
2. Double-click LogAnalyser.Api.exe (Mac/Linux: ./run.sh)
3. Your browser opens by itself. Sign up (the account stays on your computer)
4. Create a project, add an environment with your log path, and you're done!

Nothing else to install. No .NET, no database, no setup.

📌 Before you start
• Connect to Pritunl first. The log share is only reachable over the VPN, and without it the app will say "cannot read log files".
• Your logs need to be .log files with lines like: 2025-01-31 14:05:09,123 -- ERROR -- service -- message
• Windows may show a "protected your PC" warning because the app isn't code-signed. Click More info, then Run anyway.

📥 Download the latest release for Windows / macOS / Linux:
https://github.com/Zarin85/Log-Analyser/releases/latest

📖 Step-by-step user guide:
https://github.com/Zarin85/Log-Analyser/blob/main/USER_GUIDE.md

Try it on your own logs and let me know what you think. Bugs, ideas and feedback are all very welcome! 🙏
