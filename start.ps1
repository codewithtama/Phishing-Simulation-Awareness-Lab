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

if (-not (Test-Path $mailhogExe)) {
    Write-Host "[ERROR] mailhog.exe not found." -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $gophishExe)) {
    Write-Host "[ERROR] gophish.exe not found." -ForegroundColor Red
    exit 1
}

$configSrc = Join-Path $ROOT "config\gophish-local.json"
$configDst = Join-Path $GOPHISH_DIR "config.json"
Copy-Item -Path $configSrc -Destination $configDst -Force

Write-Host "[1/2] Starting MailHog (SMTP :1025, Web UI :8025)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit","-Command","Set-Location '$BIN'; .\mailhog.exe" -WindowStyle Normal

Start-Sleep -Seconds 2

Write-Host "[2/2] Starting Gophish (Admin :3333, Phish :8080)..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit","-Command","Set-Location '$GOPHISH_DIR'; .\gophish.exe" -WindowStyle Normal

Start-Sleep -Seconds 4

Start-Process "https://localhost:3333"
Start-Sleep -Milliseconds 500
Start-Process "http://localhost:8025"

Write-Host ""
Write-Host "  Services running!" -ForegroundColor Green
Write-Host "   Gophish Admin  : https://localhost:3333" -ForegroundColor White
Write-Host "   MailHog UI     : http://localhost:8025"  -ForegroundColor White
Write-Host "   Phish Listener : http://localhost:8080"  -ForegroundColor White
Write-Host ""
Write-Host "  [!] Lihat password Gophish di window terminal Gophish" -ForegroundColor Yellow
Write-Host "      cari tulisan: Please login with..." -ForegroundColor Yellow
Write-Host ""
Write-Host "  Tutup terminal Gophish/MailHog untuk stop." -ForegroundColor Gray
