# 📘 Log Analyser: User Guide

**Log Analyser turns thousands of log lines into a short list of problems you can act on.**
It reads your `.log` files, groups repeating errors together, and shows them on a simple web page, along with how fast each endpoint responds.

Instead of 90 near-identical error lines, you see **1 problem that happened 90 times**. And when you need the raw lines, the **Logs** page lets you search every one of them.

> 🔒 It runs on your own computer. Your logs never leave it, and it only reads them. It never changes them.

A nicer-looking version of this guide is in [`USER_GUIDE.html`](USER_GUIDE.html). Open it in your browser.

---

## 🚀 Get started in 3 steps

1. **Download** the zip for your computer from the [releases page](https://github.com/Zarin85/Log-Analyser/releases/latest) and extract it.
2. **Start it.** Windows: double-click `LogAnalyser.Api.exe`. Mac/Linux: run `./run.sh` in Terminal.
3. **Use it.** Your browser opens at **http://localhost:5171**. Sign up (the account stays on your computer) and follow the setup below.

> ⚠️ Windows may say it "protected your PC" because the app is not code-signed. Click **More info → Run anyway**.

---

## ⚙️ Set up your logs

You do this once. You tell the app **what** to watch (a project) and **where** the logs are (an environment).

### Your logs must look like this

- Files end in **`.log`**.
- Each line starts like this: `2025-01-31 14:05:09,123 -- ERROR -- service-name -- message`
- Each service has its own folder. Sub-folders are fine.

Your logs look different (JSON lines, another timestamp, another layout)? See [Other log formats and settings](#-other-log-formats-and-settings).

### 1. Create a project

A **project** is one application you want to watch. Click **New project**, give it a name, and add one row per **service**: the folder name of that service's logs, **without** any prefix such as `dev-`.

### 2. Add an environment

An **environment** is one place the logs live, such as `dev` or `production`. Open your project and click **New environment**.

**Example.** Your logs are in:

```
\\server\AKS-Dev-Logs\business-clm\dev-business-clm-analytics\ClmAnalyticsWebService
```

Enter:

| Where | Field | Value |
|---|---|---|
| Project | Service | `business-clm-analytics` |
| Environment | Name | `dev` |
| Environment | Log path | `\\server\AKS-Dev-Logs\business-clm` |
| Environment | Folder prefix | `dev-` |

The app joins them as *log path + prefix + service*, then reads every `.log` file below it, including sub-folders like `ClmAnalyticsWebService`. You do not type the sub-folder.

After saving, wait a few minutes. The app checks again by itself every **10 minutes** by default. You can change this to 2, 5, 7 or 10 minutes (see [How often it checks](#-how-often-it-checks)).

| Label on the environment card | Meaning |
|---|---|
| *(none)* | Working normally |
| **not collected yet** | The first check is still running |
| **cannot read log files** | Wrong path, share offline, or no permission. Hover over it to see why, then **Edit** |

---

## 📊 Read your dashboard

Click **Open** on an environment. At the top you see the key numbers: active problems, new this week, what is spiking, and your slowest endpoint. Below are charts and a table with **one row per problem**.

**In the table you can:** search by message, service or class; sort by any column; tick **Show all** to include everything (otherwise you see only New and Spiking); and click a row for details.

**Share it:** **Export CSV** saves every problem to a spreadsheet file. **Weekly digest** saves a one-page summary of the last 7 days (counts, top problems, busiest services, slowest endpoints) that you can send to your team.

### What the statuses mean

| Status | Meaning | Set by |
|---|---|---|
| 🆕 **New** | First time this problem has been seen | Automatic |
| 📈 **Spiking** | Suddenly happening much more than usual | Automatic |
| 📌 **Known** | Been around a while, at a normal level | Automatic |
| 🔕 **Suppressed** | You chose to ignore it | You |
| ✅ **Resolved** | You marked it fixed. If it comes back, it becomes **New** | You |

### What the severities mean

| Severity | When |
|---|---|
| 🔴 **Critical** | The problem appears in more than one service |
| 🟠 **High** | It is spiking, or it has happened 500+ times |
| 🟡 **Medium** | It is new, or it has happened 20+ times |
| 🟢 **Low** | Everything else |

---

## 🔎 Investigate a problem

Click a problem to see:

- **What happened:** an example of the error message.
- **Where:** the service, class, method, and file and line number.
- **Trace ID:** click it to see every log line of that request, across services.
- **History:** a chart of when it happened, and recent occurrences with the full stack trace.

Then decide: **Suppress** it if it is harmless noise, or **Resolve** it once you have fixed it. **View logs** shows all the stored log lines for this problem, and **Copy link** gives you a link to send to a colleague.

> 🔒 Emails, tokens, passwords, IP addresses and card numbers are replaced with `[REDACTED]` before they are stored or shown.

---

## 🧾 Search your logs

Open **Logs** in the top bar to see every stored log line, not only errors.

- **Search:** type any text, from a word to part of a stack trace. Matches are highlighted. Searches of 3 or more characters are the fastest.
- **Filter:** by level (Error, Warn, Info, Debug), by service, and by time range (from the last 15 minutes up to everything stored).
- **Open a line:** click it to see the full message and stack trace. From there you can:
  - **Lines around this** to see what else that service logged just before and after,
  - **All services** to see every service around that moment,
  - **Follow trace** to see one request across services,
  - **View problem** to jump to the problem it belongs to,
  - **Copy** the line.
- **Go live:** streams new lines as they are collected.
- **Load older lines** at the bottom shows more.

### How long lines are kept

| Level | Kept for (default) |
|---|---|
| Error and Warn | 15 days |
| Info | 3 days |
| Debug | 3 days, but Debug is **not stored** unless you turn it on |

Problem summaries and trends are kept longer (90 days). If a search finds nothing, the line may be older than its retention. You can change all of these (see below).

> 💡 The time range is measured from the newest stored line, not from the clock, so a quiet system still shows its last hour.

---

## 🧭 More pages

- **Timeline:** every error in time order. Pick a date range and service. Great for "what went wrong around 2pm yesterday?"
- **Performance:** average, fastest and slowest response time for each endpoint.
- **Service view:** click any service name to see its 30-day trend and all its problems.
- **Account:** click your name in the top bar to see your details, sign out, or **Quit Log Analyser**.

---

## ⏱️ How often it checks

By default the app looks for new log lines every **10 minutes**. To change it, click your name in the top bar and use **Check logs every** to pick **2, 5, 7 or 10 minutes**. It saves right away and applies within seconds. Shorter means fresher data, but the app reads your log share more often.

---

## 🧩 Other log formats and settings

Everything here is optional. Settings go in **`config.json`**, next to the program. Close Log Analyser, edit the file, and start it again. Keep the `"stateDatabase": "app.db"` line.

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
| `storeEvents` | Set `false` to stop storing log lines for the Logs page. |

Example for lines like `2025-01-31T14:05:09 [ERROR] OrderService: message`:

```json
"logPattern": "^(?<ts>\\d{4}-\\d{2}-\\d{2}T[\\d:]+) \\[(?<level>\\w+)\\] (?<service>\\w+): (?<msg>.*)$",
"timestampFormat": "yyyy-MM-dd'T'HH:mm:ss"
```

---

## 🛑 Stop and restart

Click your name in the top bar, then **Quit Log Analyser**. (Mac/Linux: you can also press Ctrl+C in the Terminal.) To start again, open the exe (or `run.sh`) as before. Your data is kept.

---

## ❓ Common questions

**Nothing shows up.**
Check, in order: the environment card for **cannot read log files**; the log path and prefix; that files end in `.log`; that lines match the format above (or your own format is set in `config.json`); and that your logs contain ERROR or WARN lines. Then wait a few minutes.

**The Logs page is empty, or a line I expect is missing.**
It may be older than its retention (see the table above), or it is a Debug line and Debug is not stored by default.

**Performance is empty.**
It needs ASP.NET `Request finished ... - 200 - ... 12.3ms` lines in your logs.

**"Too many failed sign-in attempts".**
After 5 wrong passwords for one email, that email is locked for 15 minutes. Wait, then try again.

**How fresh is the data?**
Every 10 minutes by default. You can choose 2, 5, 7 or 10 minutes on your account page. It is not real time.

**Does it change my logs?**
No. It only reads them.

**Where is my data?**
Next to the program, in `app.db` and the `environments/` folder. Keep them when you update.

**How do I update?**
Download the new zip and replace only the program file (`LogAnalyser.Api.exe`, or `LogAnalyser.Api` and `run.sh`). Leave `config.json`, `app.db` and `environments/` alone.

**Found a bug or have an idea?**
Tell us at https://github.com/Zarin85/Log-Analyser/issues
