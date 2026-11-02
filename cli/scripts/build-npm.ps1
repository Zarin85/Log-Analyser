<#
Builds the installable npm package: log-analyser-<version>-<rid>.tgz, containing the launcher
(bin/log-analyser.js) and a self-contained console build of the API for one platform.

Lives in the cli/ folder of the Log-Analyser repo, next to LogAnalyser (API + collector) and
LogAnalyser-WebApp (Angular). Unlike the zip packaging, win-x64 is a normal console build here (not WinExe) so
the command line can print.

Usage:  ./scripts/build-npm.ps1                 # this computer's platform
        ./scripts/build-npm.ps1 -Rid linux-x64  # another platform
        ./scripts/build-npm.ps1 -SkipWebApp     # reuse the API's current wwwroot
Install: npm install -g ./release/log-analyser-1.4.0-win-x64.tgz
#>
param(
    [string]$Rid = "",
    [string]$Version = "",   # e.g. 1.4.0; defaults to package.json's version
    [switch]$SkipWebApp
)

$ErrorActionPreference = "Stop"

$cliRoot = Split-Path -Parent $PSScriptRoot
# Two layouts: a sibling folder (a standalone folder next to the app repos), or the cli/ folder
# inside the Log-Analyser packaging repo (which sits next to the app repos, as in the release
# workflow).
$parentDir = if ((Split-Path -Leaf $cliRoot) -eq "cli") { Split-Path -Parent (Split-Path -Parent $cliRoot) }
             else { Split-Path -Parent $cliRoot }
$backendRoot = Resolve-Path (Join-Path $parentDir "LogAnalyser")
$webAppRoot = Resolve-Path (Join-Path $parentDir "LogAnalyser-WebApp")
$apiProject = Join-Path $backendRoot "net-loganalyser" "LogAnalyser.Api.csproj"
$wwwroot = Join-Path $backendRoot "net-loganalyser" "wwwroot"
$releaseRoot = Join-Path $cliRoot "release"

if (-not $Rid) {
    $arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
    if ($IsWindows) { $Rid = "win-x64" }
    elseif ($IsMacOS) { $Rid = if ($arch -eq "Arm64") { "osx-arm64" } else { "osx-x64" } }
    else { $Rid = "linux-x64" }
}

if (-not $SkipWebApp) {
    Write-Host "== Building Angular web app ==" -ForegroundColor Cyan
    Push-Location $webAppRoot
    try {
        npm run build
        if ($LASTEXITCODE -ne 0) { throw "Angular build failed" }
    } finally { Pop-Location }

    if (Test-Path $wwwroot) { Remove-Item $wwwroot -Recurse -Force }
    Copy-Item (Join-Path $webAppRoot "dist" "webapp" "browser") $wwwroot -Recurse
}

Write-Host "== Publishing $Rid ==" -ForegroundColor Cyan
$runtimeDir = Join-Path $cliRoot "runtime" $Rid
if (Test-Path (Join-Path $cliRoot "runtime")) { Remove-Item (Join-Path $cliRoot "runtime") -Recurse -Force }
New-Item -ItemType Directory -Path $runtimeDir -Force | Out-Null

$publishArgs = @("-c", "Release", "-r", $Rid, "--self-contained", "true",
    "-p:PublishSingleFile=true", "-p:IncludeNativeLibrariesForSelfExtract=true")
if ($Version) { $publishArgs += "-p:Version=$Version" }
dotnet publish $apiProject @publishArgs -o $runtimeDir
if ($LASTEXITCODE -ne 0) { throw "Publish failed for $Rid" }
# The dev-convenience config.json rides along via the project reference; the app creates its
# own in the user's data folder, so a stray copy must not ship.
Remove-Item (Join-Path $runtimeDir "config.json") -ErrorAction SilentlyContinue

Write-Host "== Packing ==" -ForegroundColor Cyan
New-Item -ItemType Directory -Path $releaseRoot -Force | Out-Null
Push-Location $cliRoot
try {
    if ($Version) { npm pkg set "version=$Version" | Out-Null }
    $packed = npm pack --pack-destination $releaseRoot --silent
}
finally { Pop-Location }
$version = (Get-Content (Join-Path $cliRoot "package.json") -Raw | ConvertFrom-Json).version
$final = Join-Path $releaseRoot "log-analyser-$version-$Rid.tgz"
Move-Item (Join-Path $releaseRoot $packed) $final -Force
Write-Host "-> $final" -ForegroundColor Green
Write-Host "Install with: npm install -g `"$final`""
