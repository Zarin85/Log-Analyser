<#
Builds the Angular web app into the API's wwwroot, then publishes self-contained,
single-file builds of the API + collector for Windows and macOS (Intel and Apple
Silicon), and zips each one into a ready-to-run package under release/.

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
$collectorProject = Join-Path $backendRoot "collector-loganalyser" "LogAnalyser.csproj"
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
# linux-x64 reuses run.sh (its xdg-open fallback already targets Linux desktops).
$rids = [ordered]@{
    "win-x64"   = "run.bat"
    "osx-x64"   = "run.sh"
    "osx-arm64" = "run.sh"
    "linux-x64" = "run.sh"
}

foreach ($rid in $rids.Keys) {
    $runScript = $rids[$rid]
    Write-Host "== Publishing $rid ==" -ForegroundColor Cyan
    $stagingDir = Join-Path $releaseRoot $rid "LogAnalyser"
    if (Test-Path $stagingDir) { Remove-Item $stagingDir -Recurse -Force }
    New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null

    dotnet publish $apiProject -c Release -r $rid --self-contained true `
        -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true `
        -o (Join-Path $stagingDir "api")
    if ($LASTEXITCODE -ne 0) { throw "API publish failed for $rid" }

    dotnet publish $collectorProject -c Release -r $rid --self-contained true `
        -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true `
        -o (Join-Path $stagingDir "collector")
    if ($LASTEXITCODE -ne 0) { throw "Collector publish failed for $rid" }

    # The console app's own config.json (a dev-convenience file link, see its .csproj)
    # rides along into both publish outputs via the project reference. It must not
    # survive here: the package's config.json lives only at the package root (created
    # by run.bat/run.sh on first launch), and a stray copy inside api/ or collector/
    # would make Program.cs's config-file walk-up resolve to the wrong directory,
    # silently pointing the database at api/app.db instead of the package root.
    Remove-Item (Join-Path $stagingDir "api" "config.json") -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $stagingDir "collector" "config.json") -ErrorAction SilentlyContinue

    Copy-Item (Join-Path $packagingDir "config.template.json") $stagingDir
    Copy-Item (Join-Path $packagingDir "README.txt") $stagingDir
    Copy-Item (Join-Path $packagingDir $runScript) $stagingDir
    # Windows runs both processes fully hidden (no console windows), so unlike run.sh -
    # where Ctrl+C in the visible terminal stops everything - there's nothing to Ctrl+C.
    if ($rid -eq "win-x64") {
        Copy-Item (Join-Path $packagingDir "stop.bat") $stagingDir
    }

    $zipPath = Join-Path $releaseRoot "LogAnalyser-$Version-$rid.zip"
    if (Test-Path $zipPath) { Remove-Item $zipPath }
    Compress-Archive -Path $stagingDir -DestinationPath $zipPath

    Write-Host "-> $zipPath" -ForegroundColor Green
}

Write-Host "== Done ==" -ForegroundColor Cyan
