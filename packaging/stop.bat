@echo off
echo Stopping LogAnalyser...
taskkill /IM LogAnalyser.Api.exe /F >nul 2>&1
taskkill /IM LogAnalyser.exe /F >nul 2>&1
echo Done.
pause
