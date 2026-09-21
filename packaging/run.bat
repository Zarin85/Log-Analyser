@echo off
setlocal
cd /d "%~dp0"

if not exist config.json (
    copy /y config.template.json config.json >nul
)

start "LogAnalyser Collector" cmd /k "collector\LogAnalyser.exe --config config.json watch"
start "LogAnalyser API" cmd /k "api\LogAnalyser.Api.exe"

timeout /t 3 /nobreak >nul
start http://localhost:5171

endlocal
