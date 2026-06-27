$ROOT = $PSScriptRoot
$BIN  = Join-Path $ROOT "bin"
$GOPHISH_DIR = Join-Path $BIN "gophish"
$mailhogExe  = Join-Path $BIN "mailhog.exe"
$gophishExe  = Join-Path $GOPHISH_DIR "gophish.exe"

Write-Host ""
Write-Host "  ===========================================" -ForegroundColor Cyan
Write-Host "   Phishing Simulation Awareness Lab"        -ForegroundColor Cyan
Write-Host "  ===========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $mailhogExe)) { Write-Host "[ERROR] mailhog.exe not found." -ForegroundColor Red; exit 1 }
if (-not (Test-Path $gophishExe)) { Write-Host "[ERROR] gophish.exe not found." -ForegroundColor Red; exit 1 }

# Copy local config
Copy-Item -Path (Join-Path $ROOT "config\gophish-local.json") -Destination (Join-Path $GOPHISH_DIR "config.json") -Force

# Kill any leftovers
Get-Process mailhog  -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process gophish  -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 500

# Start MailHog in its own detached window
Write-Host "[1/2] Starting MailHog..." -ForegroundColor Green
Start-Process "cmd.exe" -ArgumentList "/c start `"MailHog`" `"$mailhogExe`"" -WorkingDirectory $BIN
Start-Sleep -Seconds 2

# Start Gophish in its own detached window
Write-Host "[2/2] Starting Gophish..." -ForegroundColor Green
Start-Process "cmd.exe" -ArgumentList "/c start `"Gophish`" `"$gophishExe`"" -WorkingDirectory $GOPHISH_DIR
Start-Sleep -Seconds 4

# Verify ports
$ports = netstat -ano 2>$null | Select-String "3333|8025"
if ($ports) {
    Write-Host "  Ports: LISTENING" -ForegroundColor Green
} else {
    Write-Host "  Ports belum listen, tunggu beberapa detik..." -ForegroundColor Yellow
}

# Read password
$logPath = Join-Path $GOPHISH_DIR "gophish.log"
Start-Sleep -Seconds 1
$passLine = Get-Content $logPath -ErrorAction SilentlyContinue | Select-String "Please login"
Write-Host ""
if ($passLine) {
    $pw = ($passLine -replace '.*password ', '')
    Write-Host "  PASSWORD GOPHISH: $pw" -ForegroundColor Yellow
} else {
    Write-Host "  Lihat password di window Gophish yang baru terbuka" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "   Gophish Admin  : https://localhost:3333" -ForegroundColor White
Write-Host "   MailHog UI     : http://localhost:8025"  -ForegroundColor White
Write-Host "   Phish Listener : http://localhost:8080"  -ForegroundColor White
Write-Host ""
Write-Host "  Opening browser..." -ForegroundColor Cyan
Start-Process "https://localhost:3333"
Start-Sleep -Milliseconds 800
Start-Process "http://localhost:8025"
Write-Host "  Done! Jangan tutup window Gophish dan MailHog yang terbuka." -ForegroundColor Green
