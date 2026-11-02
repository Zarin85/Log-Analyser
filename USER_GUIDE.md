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

After saving, wait a few minutes. The app checks again by itself every **10 minutes** by default. You can change this to 10 seconds, 15 seconds, 7 minutes or 10 minutes (see [How often it checks](#-how-often-it-checks)).

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
- **AI analysis** and **Paste logs:** optional plain-language explanations of your problems, and a place to paste any log for a quick breakdown (see [AI analysis](#-ai-analysis-optional)).
- **Account:** click your name in the top bar to see your details, set how often logs are checked, set up AI analysis, sign out, or **Quit Log Analyser**.

---

## ⏱️ How often it checks

By default the app looks for new log lines every **10 minutes**. To change it, click your name in the top bar and use **Check logs every** to pick **10 seconds, 15 seconds, 7 minutes or 10 minutes**. It saves right away and applies within seconds. Shorter means fresher data, but the app reads your log share more often.

---

## 🤖 AI analysis (optional)

Log Analyser can explain your problems in plain language using a **free AI model that runs on your own computer** through [Ollama](https://ollama.com). Nothing goes to the cloud, and it stays off until you turn it on.

1. Install Ollama from **ollama.com/download**.
2. Open a terminal and run `ollama pull qwen2.5:7b` (about 5 GB, one time).
3. In Log Analyser click your name in the top bar, find **AI analysis (Ollama)**, tick **Turn on AI analysis**, click **Test connection**, then **Save**.

Two extra pages then appear inside an environment:

- **AI analysis:** explains each new or spiking error with a category (Database, Timeout/Network, Authentication and so on), possible causes marked as hypotheses, and steps to investigate. Filter by service or category, and use **Download report** or **Copy report** for a ready-to-share Markdown summary.
- **Paste logs:** paste any log text and get a summary, the error messages found, possible causes, investigation steps and what information is missing. Nothing is saved, and emails, IP addresses, card numbers and tokens are masked before analysis.

> 💡 Answers are AI suggestions, so treat them as a starting point. A normal PC analyses a few problems per minute. If Ollama is not running, these pages say so and the rest of the app works as usual.

---

## 🔗 Link your code (optional)

Point a project at the folder on your computer that holds its code, and every problem page can show **the code behind the error**: the file the stack trace points at, the failing line with the lines around it, who last changed each line, and what changed recently.

### What you get

On a problem's page, a **Code** card shows:

- The file and line from the stack trace, with the failing line highlighted and the code around it.
- Who last changed each line and when (git "blame").
- **Recent changes to this file**, with a **Possible cause** marker on any change made in the 14 days before the problem first appeared.
- The branch and commit it read, so you know exactly which version you are looking at.
- **Explain with code:** if [AI analysis](#-ai-analysis-optional) is on, the local Ollama model suggests a likely cause based on the code.

### Set it up

**You need:** [git](https://git-scm.com/downloads) installed, and your code on your computer as git clones: either one repository, for example `C:\code\business-clm-analytics`, or a folder that holds several, for example `C:\code\CLM` with one sub-folder per repository.

1. Open your project's **edit** form and find the **Code** card.
2. Type the full path in **Repository folder**. It can be:
   - one repository,
   - a folder that holds several repositories (every sub-folder that is a git repository is used), or
   - several paths, one per line (or separated by `;`).
3. Click **Test / Load branches**. With several repositories it tells you how many it found.
4. Pick a **Branch**, or leave **Current branch in that folder**. Leaving it means each repository uses whatever it has checked out. Picking a branch uses it in every repository that has it; the others use their current branch.
5. Click **Save code settings**.

**Remove** clears the setting.

Prefer a terminal? Add the folder when you set up, and check it any time:

```
log-analyser init --repo "C:\code\business-clm-analytics" --branch main
log-analyser init --repo "C:\code\CLM"      # a folder of repositories
log-analyser doctor
```

`doctor` checks that git is installed and that the folder and branch can be read. See [Command line](#-command-line).

> 🔒 Log Analyser only **reads** your folder (with `git show`, `blame`, `log` and `grep`). It never checks out a branch, fetches, edits a file or runs your code, so your current branch and uncommitted work are untouched. Files that look like they hold secrets (`.env`, keys, certificates, credentials), and binary or very large files, are never shown. Code sent to the local AI model is masked first, and nothing leaves your computer.

### Good to know

- It reads the **branch you chose**, which may not be what is deployed, so line numbers can be off. The card says which branch and commit it used.
- It finds the file by the end of the path in the log, then by class name, then by searching for the method name. When it is a guess, the card says so.
- If the log has no file and line, it shows where the method is, or the start of the file.
- With several repositories, the file is looked for in each one. The longest match of the path in the log wins, and when two repositories match equally the one whose name fits the service wins (for example `business-clm-analytics` prefers a repository named `...-clm-analytics`). The card shows which repository the file came from.
- File matching is tuned to the stack-trace formats Log Analyser already reads.

---

## 💻 Command line

Prefer a terminal? Log Analyser also comes as a command line you install with npm. It runs the same app, so everything above still applies.

**You need:** Node 18 or newer, and a file named like `log-analyser-1.4.0-win-x64.tgz` from whoever shares Log Analyser with you. The platform in the name is `win-x64`, `osx-x64`, `osx-arm64` or `linux-x64`. Pick the one that matches your computer.

```
npm install -g ./log-analyser-1.4.0-win-x64.tgz
```

> ⚠️ Keep the `./` (or give the full path). Without it, npm thinks `log-analyser-...tgz` is a GitHub user/repo name and fails.

### Set up and start

```
log-analyser init
log-analyser start
```

`init` is optional. Run on its own it only prepares your data folder and prints the next steps; it does not ask you anything. `start` runs the app and opens **http://localhost:5171**. Then:

1. Click **Sign up** and create your account. This only creates the account.
2. **Sign in** with it.
3. Create your project and environment on the **Projects** page ([Set up your logs](#-set-up-your-logs)).

### Scripted setup (optional)

To do the account, project and environment from a script instead, pass flags to `init`: `--email`, `--name`, `--password`, `--project`, `--services`, `--env`, `--path`, `--prefix`. To also [link the project's code](#-link-your-code-optional), add `--repo FOLDER` and optionally `--branch NAME`.

```
log-analyser init --email you@example.com --project "Business CLM" --services business-clm-analytics --env dev --path "\\server\AKS-Dev-Logs\business-clm" --prefix dev-
```

Typing just `log-analyser` does the same as `log-analyser start`.

### All commands

| Command | What it does |
|---|---|
| `init` | Prepares the data folder and prints the next steps. With flags, also adds an account, project and environment (see above) |
| `start` | Runs the app and opens it in your browser (the default) |
| `status` | Shows each environment, its last check, problems and stored log lines |
| `doctor` | Checks the data folder, the port, your log folders, Ollama and, if you linked code, git, the code folder and the branch |
| `analyse` (or `analyze`) | Explains new and spiking problems with the local AI model, then exits. Options: `--env NAME`, `--signature SIG` |
| `report` | Prints the analysed problems as a Markdown report. Options: `--env NAME`, `--service NAME`, `--category NAME`, `--out FILE` |
| `mcp` | Runs the AI-agent server (see the next section) |
| `version` | Prints the version |
| `help` | Lists the commands |

An unknown command prints the help and exits with code 2.

### Analyse and report

`analyse` needs [AI analysis](#-ai-analysis-optional) turned on and Ollama running. On a computer without a graphics card it can take a minute or two per problem. Press Ctrl+C to stop.

```
log-analyser analyse --env dev
log-analyser report --env dev --out dev-report.md
```

If you have only one environment you can leave out `--env`.

### Where your data lives

In a folder called `.log-analyser` in your home folder. To use another folder, set the `LOG_ANALYSER_HOME` environment variable. Log lines older than the retention window (see [How long lines are kept](#how-long-lines-are-kept)) are dropped.

### Remove it

```
npm uninstall -g log-analyser
```

Your data stays in `~/.log-analyser` until you delete that folder.

---

## 🔌 Use it from an AI agent (MCP)

Let an AI assistant look at your collected logs for you. `log-analyser mcp` is a **read-only** [MCP](https://modelcontextprotocol.io) server: the assistant can ask questions, but it cannot change anything.

It reads your local data directly, so **Log Analyser does not need to be running**. You do need to have installed the [command line](#-command-line) and set up at least one environment (in the app, or with `log-analyser init` flags).

### Connect Claude Code

```
claude mcp add log-analyser -- log-analyser mcp
```

### Connect another assistant

Add this to the MCP settings of your assistant:

```json
{
  "mcpServers": {
    "log-analyser": {
      "command": "log-analyser",
      "args": ["mcp"]
    }
  }
}
```

### What the assistant can do

| Tool | Use |
|---|---|
| `list_environments` | See your environments, their services and last check |
| `list_problems` | List tracked problems, newest first |
| `get_problem` | Details of one problem |
| `search_logs` | Search stored log lines |
| `get_trace` | Follow one trace ID across services |
| `get_context` | Lines around one log line |
| `endpoint_performance` | Response times per endpoint |
| `get_code_context` | The code behind a problem: file, failing line, blame and recent changes (needs a [linked code folder](#-link-your-code-optional)) |
| `get_analysis` | Stored AI explanation of a problem |

### Try asking

- "What are the new or spiking problems in dev?"
- "Show me the latest errors from business-clm-analytics and what is likely causing them."
- "Follow trace ID `abc123` across all services."
- "Which endpoints are the slowest?"
- "What happened around that timeout, in the minute before and after?"
- "Find the code behind problem `<signature>` and tell me what recently changed there."

> 🔒 Emails, IP addresses, card numbers and tokens are masked before anything is sent to the assistant, including code from `get_code_context`. Results are capped at 200 lines (about 60,000 characters), so ask narrower questions if an answer looks cut off.

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
Every 10 minutes by default. You can choose 10 seconds, 15 seconds, 7 minutes or 10 minutes on your account page. It is not real time.

**Does it change my logs?**
No. It only reads them.

**Where is my data?**
Next to the program, in `app.db` and the `environments/` folder. Keep them when you update.

**How do I update?**
Download the new zip and replace only the program file (`LogAnalyser.Api.exe`, or `LogAnalyser.Api` and `run.sh`). Leave `config.json`, `app.db` and `environments/` alone.

**Found a bug or have an idea?**
Tell us at https://github.com/Zarin85/Log-Analyser/issues
