# 🔍 Log Analyser

**Turn a flood of log lines into a handful of problems you can actually act on.**

Log Analyser reads the log files you already have, groups the repeating errors together, and shows them in a simple web dashboard, so you can see what is new, what is getting worse and where in the code it happened.

| 😵 Without Log Analyser | ✅ With Log Analyser |
|---|---|
| 90 near-identical error lines, one per trace ID | **1** tracked problem, occurring 90 times |
| No idea what is new and what is old noise | Automatic **New / Spiking / Known** status, plus Suppress and Resolve buttons |
| Searching raw text for the file and line that threw | Class, method and file:line shown for you |
| Opening log files one by one to see what happened around an error | A **Logs** page: search every line, filter by level, service and time, follow one request across services |
| No idea which endpoints are slow | Average / min / max response time per endpoint |
| Copy-pasting errors into a report | **Export CSV** and a **Weekly digest** in one click |

- 🔒 **Self-hosted.** Your logs never leave your machine or network. No telemetry, no cloud.
- 🔌 **No setup work.** It reads existing `.log` files. No agents, no code changes. It understands the common `date -- LEVEL -- service -- message` lines out of the box, and can be pointed at other text formats or JSON logs (see [Other log formats](#-other-log-formats-and-settings)).
- 📦 **Nothing else to install.** No .NET, Node, database or web server needed.

---

## 📥 Download

**➡️ [Get the latest release](https://github.com/Zarin85/Log-Analyser/releases/latest)**

Download the zip for your computer from the **Assets** section of the release:

| Your computer | File |
|---|---|
| 🪟 Windows | `LogAnalyser-<version>-win-x64.zip` |
| 🍎 Mac (Intel) | `LogAnalyser-<version>-osx-x64.zip` |
| 🍎 Mac (M1/M2/M3/M4) | `LogAnalyser-<version>-osx-arm64.zip` |
| 🐧 Linux | `LogAnalyser-<version>-linux-x64.zip` |

---

## 🚀 Getting started

### 1. Start it

**Windows**
1. Extract the zip anywhere (for example your Desktop or `C:\Tools`).
2. Double-click **`LogAnalyser.Api.exe`**.
3. No window opens. After a few seconds your browser opens the dashboard by itself.

> If Windows SmartScreen says "Windows protected your PC", click **More info → Run anyway**. This happens because the app is not code-signed.

**Mac / Linux**
1. Extract the zip.
2. Open Terminal in that folder and run:
   ```
   chmod +x run.sh
   ./run.sh
   ```
3. Your browser opens the dashboard. Leave the Terminal window open while you use it.

> On a Mac, if it is blocked as "from an unidentified developer", go to **System Settings → Privacy & Security** and choose **Open Anyway**.

If the browser does not open, go to **http://localhost:5171**.

### 2. Create your account
Click **Sign up** and enter a name, email and password. The account is stored only on your computer.

### 3. Create a project
A project is one application or system. Give it a name and add one row for each **service log folder** (for example `business-clm-analytics`).

### 4. Add an environment
An environment is one place the logs live (for example Dev, Test or Prod). Give it a name and the **log path**: the root folder that contains your service folders. If the folders start with `dev-` or similar, put that in **Folder prefix**. Example: log path `\\server\AKS-Dev-Logs\business-clm`, prefix `dev-`, service `business-clm-analytics` means it reads `\\server\AKS-Dev-Logs\business-clm\dev-business-clm-analytics`, including sub-folders such as `ClmAnalyticsWebService`.

That is it. Within a few minutes your problems appear on the dashboard. From then on it runs by itself and keeps checking for new log lines every 10 minutes. You can change this to **2, 5, 7 or 10 minutes**: click your name in the top bar and pick a value under **Check logs every**.

---

## 📊 Using the dashboard

> 📘 Full walkthrough: **[USER_GUIDE.md](USER_GUIDE.md)**

⚠️ Out of the box your logs must be `.log` files with lines like `2025-01-31 14:05:09,123 -- ERROR -- service-name -- message`. For other formats, see [Other log formats](#-other-log-formats-and-settings).

- **Problems table:** every distinct error, with how many times it happened, which service it came from and its severity.
- **Status:**
  - 🆕 **New:** first time it has been seen
  - 📈 **Spiking:** at least 5 occurrences in a check, and at least double its usual amount
  - 📌 **Known:** been around a while, at a normal level
  - 🔕 **Suppressed:** you chose to ignore it (stays ignored)
  - ✅ **Resolved:** you marked it as fixed. If it happens again it goes back to **New**
  
  New, Spiking and Known are worked out automatically on every check. Suppressed and Resolved are set by you from the problem details page.
- **Severity:** errors that appear in more than one service are marked **Critical** automatically.
- **Problem details:** shows where it was thrown (class, method, file:line), the trace ID if there is one, and a chart of when it happened.
- **Search and sort:** filter by message, service or class, and sort by severity, count or most recent.
- **Performance:** average, minimum and maximum response time for each endpoint, taken from the same logs.
- **Export CSV / Weekly digest:** two buttons above the problems table. The CSV lists every problem. The digest is a one-page HTML summary of the last 7 days (counts, top problems, busiest services, slowest endpoints) you can save and share.

---

## 🧾 The Logs page

Open **Logs** in the top bar to see every stored log line, not just errors.

- **Search:** type any text, from a word to part of a stack trace. Matches are highlighted. Searches of 3 or more characters are the fastest.
- **Filter:** by level (Error, Warn, Info, Debug), by service, and by time range (last 15 minutes up to all stored).
- **Open a line:** click it for the full message and stack trace. From there you can show the **lines around it** (same service, or all services), **follow its trace** across services, jump to the **problem** it belongs to, or copy it.
- **Go live:** streams new lines as they are collected.
- **From a problem:** the problem page has **View logs** (all lines for that problem) and its trace ID links straight to that trace.

### How long lines are kept

| Level | Kept for (default) |
|---|---|
| Error and Warn | 15 days |
| Info | 3 days |
| Debug | 3 days, but Debug is **not stored** unless you turn it on |

Problem summaries and trends are kept longer (90 days). If a search finds nothing, the line may be older than its retention. Everything is redacted before it is stored, and you can change the numbers below.

---

## 🧩 Other log formats and settings

Everything below is optional. Settings go in **`config.json`**, which sits next to the program. Close Log Analyser, edit the file, and start it again. Keep the `"stateDatabase": "app.db"` line.

```json
{
  "stateDatabase": "app.db",
  "logFormat": "text",
  "logPattern": null,
  "timestampFormat": "yyyy-MM-dd HH:mm:ss,fff",
  "eventMinLevel": "INFO",
  "warnErrorEventDays": 15,
  "infoEventDays": 3,
  "debugEventDays": 3,
  "retentionDays": 90
}
```

| Setting | Use it to |
|---|---|
| `logFormat` | Set `"json"` if your logs are one JSON object per line (Serilog compact or JSON, log4net JSON layout). |
| `logPattern` | Describe another text format with a regular expression. It needs the named groups `ts`, `level` and `msg`; `service` is optional. |
| `timestampFormat` | Match the time format in your lines. If it is wrong, times show as year 0001. |
| `eventMinLevel` | Lowest level shown on the Logs page. Set `"DEBUG"` to include debug lines (this uses more disk). |
| `warnErrorEventDays`, `infoEventDays`, `debugEventDays` | How long the Logs page keeps lines per level. `0` keeps them forever. |
| `retentionDays` | How long problem summaries and trends are kept. |
| `maskRules` | A list of expressions for ids specific to your logs, so errors that differ only by that id count as one problem. |
| `storeEvents` | Set `false` to turn the Logs page's line storage off. |

Example for lines like `2025-01-31T14:05:09 [ERROR] OrderService: message`:

```json
"logPattern": "^(?<ts>\\d{4}-\\d{2}-\\d{2}T[\\d:]+) \\[(?<level>\\w+)\\] (?<service>\\w+): (?<msg>.*)$",
"timestampFormat": "yyyy-MM-dd'T'HH:mm:ss"
```

---

## 🛑 Stopping it

- **Windows:** click your name in the top bar, then **Quit Log Analyser**.
- **Mac / Linux:** press **Ctrl+C** in the Terminal window, or close it.

## 🔄 Updating to a new version

Download the new zip and replace only the program file:

- **Windows:** `LogAnalyser.Api.exe`
- **Mac / Linux:** `LogAnalyser.Api` and `run.sh`

⚠️ **Do not delete or replace** `config.json`, `app.db` or the `environments/` folder. Your accounts, projects and history are stored there.

---

## 🔒 Privacy and security

- Everything runs on your own computer or network. Nothing is sent anywhere.
- Email addresses, JWTs, IP addresses, card numbers and anything labelled `password`, `secret`, `token` or `authorization` in the logs are **hidden before they are stored and shown**.
- Passwords are stored with strong hashing, and after 5 wrong sign-ins for one email that email is locked for 15 minutes.
- Each environment's data is stored in its own separate file, so data cannot mix between projects or environments.
- Log Analyser only **reads** your log files. It never changes or deletes them.

---

## ❓ Troubleshooting

| Problem | What to try |
|---|---|
| Browser does not open | Go to **http://localhost:5171** yourself |
| Page does not load | Make sure the app is still running. On Windows, check Task Manager for `LogAnalyser.Api` |
| "Cannot read log files" on an environment | The path is wrong or you do not have permission to it. Check that you can open that folder yourself |
| Nothing shows up yet | Wait a few minutes. New environments are collected right after you add them |
| Logs page is empty or a line is missing | It may be older than its retention (see the table above), or it is Debug and Debug is off |
| No response times on Performance | Your logs need ASP.NET `Request finished ... - 200 - ... 12.3ms` lines |
| Times show as year 0001 | `timestampFormat` does not match your lines, see [Other log formats](#-other-log-formats-and-settings) |
| "Too many failed sign-in attempts" | Wait 15 minutes, or sign in with the right password |
| Port 5171 is already in use | Close any other copy of Log Analyser that is running |
| Forgot to unblock on Windows or Mac | See the notes under **Start it** above |

---

## 💬 Feedback and issues

Found a bug or have an idea? Open an issue: https://github.com/Zarin85/Log-Analyser/issues

## 🛠️ For developers

How the packages are built and published is in [BUILDING.md](BUILDING.md).
