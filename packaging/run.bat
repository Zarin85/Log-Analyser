@echo off
setlocal
cd /d "%~dp0"

if not exist config.json (
    copy /y config.template.json config.json >nul
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process -FilePath 'collector\LogAnalyser.exe' -ArgumentList '--config','config.json','watch' -WindowStyle Hidden"
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process -FilePath 'api\LogAnalyser.Api.exe' -WindowStyle Hidden"

timeout /t 3 /nobreak >nul
start "" http://localhost:5171

endlocal
