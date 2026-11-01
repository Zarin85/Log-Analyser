#!/usr/bin/env node
// Thin launcher: finds the bundled self-contained .NET build for this machine, points it at
// a per-user data folder and hands over the command line. All the real work is in the exe.
'use strict';

const { spawn } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

const RIDS = {
  'win32-x64': 'win-x64',
  'darwin-x64': 'osx-x64',
  'darwin-arm64': 'osx-arm64',
  'linux-x64': 'linux-x64',
};

const rid = RIDS[`${process.platform}-${process.arch}`];
if (!rid) {
  console.error(`Log Analyser has no build for ${process.platform}-${process.arch}.`);
  process.exit(1);
}

const exeName = process.platform === 'win32' ? 'LogAnalyser.Api.exe' : 'LogAnalyser.Api';
const exe = path.join(__dirname, '..', 'runtime', rid, exeName);
if (!fs.existsSync(exe)) {
  console.error(
    `This package was built without the ${rid} runtime (${exe} is missing).\n` +
      'Install the package that matches your computer.'
  );
  process.exit(1);
}

const home = process.env.LOG_ANALYSER_HOME || path.join(os.homedir(), '.log-analyser');
fs.mkdirSync(home, { recursive: true });

// `log-analyser` with no command starts the app, like `log-analyser start`.
let args = process.argv.slice(2);
if (args[0] === 'start') args = args.slice(1);

const child = spawn(exe, args, {
  stdio: 'inherit',
  env: { ...process.env, LOG_ANALYSER_HOME: home },
});
for (const sig of ['SIGINT', 'SIGTERM']) process.on(sig, () => child.kill(sig));
child.on('error', (e) => {
  console.error(`Could not start Log Analyser: ${e.message}`);
  process.exit(1);
});
child.on('exit', (code, signal) => process.exit(code ?? (signal ? 1 : 0)));
