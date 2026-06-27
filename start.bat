@echo off
title Phishing Simulation Awareness Lab
color 0A

echo.
echo  ===========================================
echo   Phishing Simulation Awareness Lab
echo  ===========================================
echo.

set ROOT=%~dp0
set BIN=%ROOT%bin
set GOPHISH_DIR=%BIN%\gophish

if not exist "%BIN%\mailhog.exe" (
    echo [ERROR] mailhog.exe not found di: %BIN%
    pause
    exit /b 1
)
if not exist "%GOPHISH_DIR%\gophish.exe" (
    echo [ERROR] gophish.exe not found di: %GOPHISH_DIR%
    pause
    exit /b 1
)

copy /Y "%ROOT%config\gophish-local.json" "%GOPHISH_DIR%\config.json" >nul
echo [OK] Config siap

taskkill /F /IM mailhog.exe >nul 2>&1
taskkill /F /IM gophish.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul

echo [1/2] Starting MailHog  (SMTP :1025  ^|  Web UI :8025)...
start "MailHog" /D "%BIN%" "%BIN%\mailhog.exe"
ping -n 3 127.0.0.1 >nul

echo [2/2] Starting Gophish  (Admin :3333  ^|  Phish :8080)...
start "Gophish" /D "%GOPHISH_DIR%" "%GOPHISH_DIR%\gophish.exe"
ping -n 5 127.0.0.1 >nul

echo.
echo  ===========================================
echo   SERVICES RUNNING
echo  ===========================================
echo.
echo   Gophish Admin  : https://localhost:3333
echo   MailHog UI     : http://localhost:8025
echo   Phish Listener : http://localhost:8080
echo.
echo   Username : admin
echo   Password : lihat di window Gophish (cari "Please login with...")
echo.
echo   [!] Jangan tutup window Gophish dan MailHog!
echo  ===========================================
echo.

start "" "https://localhost:3333"
ping -n 2 127.0.0.1 >nul
start "" "http://localhost:8025"

echo  Browser dibuka. Selesai!
