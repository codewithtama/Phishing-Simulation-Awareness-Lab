$ROOT = $PSScriptRoot
$BIN  = Join-Path $ROOT "bin"
$GOPHISH_DIR = Join-Path $BIN "gophish"

Write-Host ""
Write-Host "  ===========================================" -ForegroundColor Cyan
Write-Host "   Phishing Simulation Awareness Lab"        -ForegroundColor Cyan
Write-Host "  ===========================================" -ForegroundColor Cyan
Write-Host ""

$mailhogExe = Join-Path $BIN "mailhog.exe"
$gophishExe = Join-Path $GOPHISH_DIR "gophish.exe"

if (-not (Test-Path $mailhogExe)) { Write-Host "[ERROR] mailhog.exe not found." -ForegroundColor Red; exit 1 }
if (-not (Test-Path $gophishExe)) { Write-Host "[ERROR] gophish.exe not found." -ForegroundColor Red; exit 1 }

$configSrc = Join-Path $ROOT "config\gophish-local.json"
$configDst = Join-Path $GOPHISH_DIR "config.json"
Copy-Item -Path $configSrc -Destination $configDst -Force

# Kill any leftover processes
Get-Process mailhog  -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process gophish  -ErrorAction SilentlyContinue | Stop-Process -Force

Write-Host "[1/2] Starting MailHog..." -ForegroundColor Green
$mh = Start-Process -FilePath $mailhogExe -WorkingDirectory $BIN -PassThru -WindowStyle Minimized
Write-Host "      PID: $($mh.Id)"

Start-Sleep -Seconds 2

Write-Host "[2/2] Starting Gophish..." -ForegroundColor Green
$gp = Start-Process -FilePath $gophishExe -WorkingDirectory $GOPHISH_DIR -PassThru -WindowStyle Minimized -RedirectStandardError (Join-Path $GOPHISH_DIR "gophish.log")
Write-Host "      PID: $($gp.Id)"

Start-Sleep -Seconds 3

# Check still alive
if ($mh.HasExited) { Write-Host "[WARN] MailHog sudah exit!" -ForegroundColor Red }
else               { Write-Host "       MailHog: OK" -ForegroundColor Green }

if ($gp.HasExited) { Write-Host "[WARN] Gophish sudah exit!" -ForegroundColor Red }
else               { Write-Host "       Gophish: OK" -ForegroundColor Green }

Write-Host ""
Write-Host "  ===========================================" -ForegroundColor Cyan

# Read password from log
Start-Sleep -Seconds 1
$logPath = Join-Path $GOPHISH_DIR "gophish.log"
$passLine = Get-Content $logPath -ErrorAction SilentlyContinue | Select-String "Please login"
if ($passLine) {
    Write-Host "  PASSWORD: $passLine" -ForegroundColor Yellow
} else {
    Write-Host "  Lihat password di: $logPath" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "   Gophish Admin  : https://localhost:3333" -ForegroundColor White
Write-Host "   MailHog UI     : http://localhost:8025"  -ForegroundColor White
Write-Host "   Phish Listener : http://localhost:8080"  -ForegroundColor White
Write-Host ""

Start-Process "https://localhost:3333"
Start-Sleep -Milliseconds 500
Start-Process "http://localhost:8025"

Write-Host "  Browser dibuka! Tekan Enter untuk keluar dari launcher"
Write-Host "  (service tetap berjalan di background)"
Read-Host
