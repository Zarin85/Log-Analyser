# Log Analyser — packaging

Builds ready-to-run, self-contained release packages of Log Analyser for Windows and
macOS (Intel + Apple Silicon) and Linux, bundling the Angular web app into the API's
static files so a package is a single folder with no separate install step for
.NET, Node, or a web server.

This repo (`Log-Analyser` on GitHub) is deliberately separate from the app's own source
so it can be published and versioned on its own (release notes, packaging fixes)
without churn in the application repos. It has no code of its own — it only
orchestrates builds of the other two repos, which must be checked out as siblings, in
folders named exactly as below (`scripts/build-package.ps1` and the CI workflow's
`actions/checkout` `path:` values both key off these local folder names, not the repos'
GitHub names):

    <parent>/
      LogAnalyser/           # .NET 8 API + collector (github.com/Zarin85/LogAnalyser)
      LogAnalyser-WebApp/    # Angular SPA (github.com/Zarin85/LogAnalyser-WebApp)
      Log-Analyser/          # this repo (github.com/Zarin85/Log-Analyser)

## Build a release

    ./scripts/build-package.ps1 -Version 1.0.0

Requires the .NET 8 SDK and Node/npm on PATH, and both sibling repos present. Produces
`release/LogAnalyser-{version}-{rid}.zip` for `win-x64`, `osx-x64`, `osx-arm64`, and
`linux-x64` — each one a self-contained single-file publish of the API and collector,
plus `packaging/run.bat` or `run.sh`, `config.template.json`, and `README.txt` from
this repo. `release/` is gitignored; it's a build output, not source.

## Layout

    packaging/
      run.bat / run.sh       # launcher copied into every package
      stop.bat                # win-x64 only - run.bat starts both processes hidden
                               # (no console windows), so there's nothing to Ctrl+C
      config.template.json   # copied to config.json on first run
      README.txt             # end-user instructions, copied into every package
    scripts/
      build-package.ps1      # does the actual building/publishing/zipping

## Updating an existing install

Replace the `api/` and `collector/` folders with the ones from the new release. Leave
`config.json`, `app.db`, and `environments/` alone — that's where accounts, projects,
and history live.

## Publishing a GitHub release

Build first, then attach the resulting zips to a tagged release:

    ./scripts/build-package.ps1 -Version 1.0.0
    git tag v1.0.0 && git push origin v1.0.0
    gh release create v1.0.0 release/LogAnalyser-1.0.0-*.zip --title v1.0.0 --generate-notes

The version passed to the build script should match the tag (without the `v`) so the
zip filenames line up with the release they're attached to.
