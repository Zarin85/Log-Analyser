# Log Analyser command line

Install Log Analyser from a terminal, run it, and let an AI assistant read your logs.
The package includes the whole app, so there is nothing else to install. Node 18 or newer is
only used to start it.

## Install

You need Node 18+ and a file named like `log-analyser-1.4.0-win-x64.tgz`, given to you by
whoever shares Log Analyser. The platform in the name is `win-x64`, `osx-x64`, `osx-arm64` or
`linux-x64`; use the one that matches your computer.

```
npm install -g ./log-analyser-1.4.0-win-x64.tgz
```

Keep the `./` (or give the full path). Without it, npm reads the name as a GitHub `user/repo`
and fails.

## Set up and start

```
log-analyser init
log-analyser start
```

`init` is optional. On its own it only prepares your data folder and prints the next steps.
`start` runs the app and opens http://localhost:5171. Then click Sign up (this only creates the
account), sign in, and create your project and environment on the Projects page ("Get started in
three steps").

To script the setup instead, pass flags to `init` (`--email --name --password --project --services --env --path --prefix`, and `--repo FOLDER --branch NAME` to link the project's code: one repository, several paths separated by `;`, or a folder that holds several repositories). For example:

```
log-analyser init --email you@example.com --project "Business CLM" --services business-clm-analytics --env dev --path "\\server\AKS-Dev-Logs\business-clm" --prefix dev-
```

`start` runs the app and opens http://localhost:5171. Running `log-analyser` with no command
does the same.

## Commands

| Command | What it does |
|---|---|
| `init` | Prepares the data folder and prints next steps; with flags, also adds an account, project and environment |
| `start` | Runs the app and opens it in your browser (default) |
| `status` | Environments, last check, problems and stored log lines |
| `doctor` | Checks the data folder, port, log folders, Ollama and, if code is linked, git, the code folder and the branch |
| `analyse` / `analyze` | Explains new and spiking problems with the local Ollama model, then exits (`--env NAME`, `--signature SIG`) |
| `report` | Prints analysed problems as Markdown (`--env NAME`, `--service NAME`, `--category NAME`, `--out FILE`) |
| `mcp` | Read-only MCP server for AI agents |
| `version` | Prints the version |
| `help` | Lists the commands |

An unknown command prints the help and exits with code 2.

`analyse` needs AI analysis turned on (Account page in the app) and Ollama running. It is slow
on a CPU. Then:

```
log-analyser analyse --env dev
log-analyser report --env dev --out dev-report.md
```

## Use it from an AI agent (MCP)

`log-analyser mcp` is a read-only MCP server over stdio. It reads your local data directly, so
the app does not need to be running.

Claude Code:

```
claude mcp add log-analyser -- log-analyser mcp
```

Other clients:

```json
{ "mcpServers": { "log-analyser": { "command": "log-analyser", "args": ["mcp"] } } }
```

Tools: `list_environments`, `list_problems`, `get_problem`, `search_logs`, `get_trace`,
`get_context`, `endpoint_performance`, `get_code_context`, `get_analysis`. Emails, IP addresses, card numbers and
tokens are redacted, and results are capped (200 lines, about 60,000 characters).

Try asking:

- "What are the new or spiking problems in dev?"
- "Show the latest errors from business-clm-analytics and the likely cause."
- "Follow trace ID abc123 across all services."
- "Which endpoints are the slowest?"
- "What happened around that timeout?"
- "Find the code behind problem <signature> and tell me what recently changed there."

## Your data

Everything (config, database, collected logs) is in `~/.log-analyser`. Set `LOG_ANALYSER_HOME`
to use another folder. Log lines older than the retention window are dropped.

## Remove it

```
npm uninstall -g log-analyser
```

Your data stays in `~/.log-analyser` until you delete that folder.

## Build the package (maintainers)

Needs the .NET 8 SDK, Node/npm, and the `LogAnalyser` and `LogAnalyser-WebApp` repos beside
this one.

```
./scripts/build-npm.ps1
```

- `-Rid win-x64|osx-x64|osx-arm64|linux-x64` builds for another platform (default: this computer).
- `-SkipWebApp` reuses the API's current `wwwroot` instead of rebuilding the web app.
- Each run produces one platform: `release/log-analyser-<version>-<rid>.tgz`. Build once per platform.
