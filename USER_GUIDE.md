# 📘 Log Analyser: User Guide

**Log Analyser turns thousands of log lines into a short list of problems you can act on.**
It reads your `.log` files, groups repeating errors together, and shows them on a simple web page, along with how fast each endpoint responds.

Instead of 90 near-identical error lines, you see **1 problem that happened 90 times**.

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
- **Trace ID:** to look up the same request in your other tools.
- **History:** a chart of when it happened, and recent occurrences with the full stack trace.

Then decide: **Suppress** it if it is harmless noise, or **Resolve** it once you have fixed it.

> 🔒 Emails, tokens and passwords are replaced with `[REDACTED]` before they are shown.

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

## 🛑 Stop and restart

Click your name in the top bar, then **Quit Log Analyser**. (Mac/Linux: you can also press Ctrl+C in the Terminal.) To start again, open the exe (or `run.sh`) as before. Your data is kept.

---

## ❓ Common questions

**Nothing shows up.**
Check, in order: the environment card for **cannot read log files**; the log path and prefix; that files end in `.log`; that lines match the format above; and that your logs contain ERROR or WARN lines. Then wait a few minutes.

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
