<#
Builds one installable package per platform (win-x64, osx-x64, osx-arm64, linux-x64) into
release/. The Angular app is built once (first platform) and reused for the rest. Publishing is
a normal cross-compile, so this works from any one machine; the .NET runtime packs for the
other platforms are downloaded on first use.

Usage: ./scripts/build-all.ps1            # all four
       ./scripts/build-all.ps1 -SkipWebApp  # reuse the API's current wwwroot
#>
param([switch]$SkipWebApp)

$ErrorActionPreference = "Stop"
$single = Join-Path $PSScriptRoot "build-npm.ps1"
$first = -not $SkipWebApp

foreach ($rid in "win-x64", "osx-x64", "osx-arm64", "linux-x64") {
    Write-Host "######## $rid ########" -ForegroundColor Yellow
    if ($first) { & $single -Rid $rid } else { & $single -Rid $rid -SkipWebApp }
    if ($LASTEXITCODE -ne 0 -and $null -ne $LASTEXITCODE) { throw "Build failed for $rid" }
    $first = $false
}

Write-Host "== All packages ==" -ForegroundColor Cyan
Get-ChildItem (Join-Path (Split-Path -Parent $PSScriptRoot) "release") -Filter *.tgz |
    Select-Object Name, @{ n = "MB"; e = { [math]::Round($_.Length / 1MB, 1) } }
