🔍 **Log Analyser: stop reading logs line by line**

Hi team 👋

I built a small tool called **Log Analyser** that turns a flood of log lines into a short list of problems you can act on.

**What is it?**
It reads our `.log` files and groups repeating errors together.
Instead of 90 near-identical error lines, you see **1 problem that happened 90 times**.

**What you get**
✅ Errors grouped automatically (no more scrolling through duplicates)
✅ An automatic status for each one (**New / Spiking / Known**), so you can tell what just broke, plus buttons to **Suppress** noise or mark a problem **Resolved**
✅ The class, method and file:line where it was thrown
✅ Average / min / max response time per endpoint, from the same logs
✅ Errors that hit more than one service are flagged **Critical**

**Safe to use**
🔒 It runs on your own machine. Logs never leave your computer, and nothing is sent to the cloud.
🔒 Emails, tokens and passwords in the logs are hidden before they are shown.
🔒 It only reads log files. It never changes them.

**How to use it (about 2 minutes)**
1️⃣ Download the zip for your computer (Windows / Mac / Linux) from the release page below
2️⃣ Extract it, then double-click `LogAnalyser.Api.exe` (Mac/Linux: run `./run.sh`)
3️⃣ Your browser opens by itself. If not, go to http://localhost:5171
4️⃣ Sign up (the account stays on your computer), create a **project**, add the service log folders, then add an **environment** with the path to the log root
5️⃣ Wait a few minutes and your problems appear. After that it keeps updating by itself.

Nothing else to install. No .NET, no database, no setup.
📝 Logs need the format `2025-01-31 14:05:09,123 -- ERROR -- service -- message` (and `.log` files). The full guide explains it.
⚠️ Windows may show a "protected your PC" warning because the app is not code-signed. Click **More info → Run anyway**.

**📥 Download:** https://github.com/Zarin85/Log-Analyser/releases/latest
**📖 Full guide:** https://github.com/Zarin85/Log-Analyser/blob/main/USER_GUIDE.md

Try it on your own logs and tell me what you think. Bugs and ideas are very welcome. 🙏
