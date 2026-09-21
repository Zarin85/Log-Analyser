<#
Builds the Angular web app into the API's wwwroot, then publishes a self-contained,
single-file build of the API (which also runs the collector in-process - see
CollectorBackgroundService in the backend repo) for Windows, macOS (Intel and Apple
Silicon), and Linux, and zips each one into a ready-to-run package under release/.

Lives in its own repo (LogAnalyser-Packaging), a sibling of LogAnalyser (the API +
collector) and LogAnalyser-WebApp (the Angular app) - all three must be checked out
side by side under the same parent directory for the relative paths below to resolve.
#>
param(
    [string]$Version = "dev"
)

$ErrorActionPreference = "Stop"

$packageRepoRoot = Split-Path -Parent $PSScriptRoot
$parentDir = Split-Path -Parent $packageRepoRoot
$backendRoot = Resolve-Path (Join-Path $parentDir "LogAnalyser")
$webAppRoot = Resolve-Path (Join-Path $parentDir "LogAnalyser-WebApp")
$apiProject = Join-Path $backendRoot "net-loganalyser" "LogAnalyser.Api.csproj"
$wwwroot = Join-Path $backendRoot "net-loganalyser" "wwwroot"
$packagingDir = Join-Path $packageRepoRoot "packaging"
$releaseRoot = Join-Path $packageRepoRoot "release"

Write-Host "== Building Angular web app ==" -ForegroundColor Cyan
Push-Location $webAppRoot
npm run build
if ($LASTEXITCODE -ne 0) { throw "Angular build failed" }
Pop-Location

Write-Host "== Merging web app into API wwwroot ==" -ForegroundColor Cyan
if (Test-Path $wwwroot) { Remove-Item $wwwroot -Recurse -Force }
Copy-Item (Join-Path $webAppRoot "dist" "webapp" "browser") $wwwroot -Recurse

# osx-x64 covers Intel Macs, osx-arm64 covers Apple Silicon (M-series) - a self-contained
# build is tied to one CPU architecture, so both are needed to cover the team's Macs.
$rids = "win-x64", "osx-x64", "osx-arm64", "linux-x64"

foreach ($rid in $rids) {
    Write-Host "== Publishing $rid ==" -ForegroundColor Cyan
    $stagingDir = Join-Path $releaseRoot $rid "LogAnalyser"
    if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
    New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null

    $publishArgs = @(
        "-c", "Release", "-r", $rid, "--self-contained", "true",
        "-p:PublishSingleFile=true", "-p:IncludeNativeLibrariesForSelfExtract=true"
    )
    # WinExe only for win-x64: on Windows this drops the console subsystem entirely, so
    # double-clicking the exe shows no window at all. It's a Windows PE-header concept -
    # meaningless (and left untried here) for the other RIDs.
    if ($rid -eq "win-x64") { $publishArgs += "-p:OutputType=WinExe" }

    dotnet publish $apiProject @publishArgs -o $stagingDir
    if ($LASTEXITCODE -ne 0) { throw "Publish failed for $rid" }

    # The console app's own config.json (a dev-convenience file link, see its .csproj)
    # rides along into the publish output via the project reference. It must not survive
    # here: Program.cs now auto-creates its own default config.json next to the exe on
    # first launch if none is found, and a stray copy from the build would make it think
    # one already exists.
    Remove-Item (Join-Path $stagingDir "config.json") -ErrorAction SilentlyContinue

    Copy-Item (Join-Path $packagingDir "README.txt") $stagingDir
    if ($rid -eq "win-x64") {
        # No run.bat needed - the exe itself opens no console window and opens the
        # browser once it's listening (see Program.cs). stop.bat is still needed since
        # there's no window left to close.
        Copy-Item (Join-Path $packagingDir "stop.bat") $stagingDir
    }
    else {
        Copy-Item (Join-Path $packagingDir "run.sh") $stagingDir
    }

    $zipPath = Join-Path $releaseRoot "LogAnalyser-$Version-$rid.zip"
    if (Test-Path $zipPath) { Remove-Item $zipPath }
    Compress-Archive -Path $stagingDir -DestinationPath $zipPath

    Write-Host "-> $zipPath" -ForegroundColor Green
}

Write-Host "== Done ==" -ForegroundColor Cyan
