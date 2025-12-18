# Script to start LiveKit server using binary (no Docker)

Write-Host "=== LiveKit Server Startup (Binary Mode) ===" -ForegroundColor Cyan
Write-Host ""

$exeFile = "bin\livekit-server.exe"
$configFile = "livekit.yaml"

# Check if binary exists
if (-not (Test-Path $exeFile)) {
    Write-Host "[ERROR] Binary not found at: $exeFile" -ForegroundColor Red
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "  1. Download binary automatically:" -ForegroundColor Cyan
    Write-Host "     .\download-binary.ps1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  2. Download manually from:" -ForegroundColor Cyan
    Write-Host "     https://github.com/livekit/livekit/releases/latest" -ForegroundColor Gray
    Write-Host "     Extract livekit-server.exe to D:\livekit\bin\" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "[OK] Binary found: $exeFile" -ForegroundColor Green

# Check if config file exists
if (Test-Path $configFile) {
    Write-Host "[OK] Config file found: $configFile" -ForegroundColor Green
    $useConfig = $true
} else {
    Write-Host "[INFO] Config file not found, using --dev mode" -ForegroundColor Yellow
    $useConfig = $false
}

Write-Host ""
Write-Host "Starting LiveKit server..." -ForegroundColor Yellow
Write-Host "Server will be available at: http://localhost:7880" -ForegroundColor Cyan
Write-Host "API Key: devkey" -ForegroundColor Cyan
Write-Host "API Secret: secret" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

# Check if server is already running
$process = Get-Process -Name "livekit-server" -ErrorAction SilentlyContinue
if ($process) {
    Write-Host "[WARNING] LiveKit server process already running (PID: $($process.Id))" -ForegroundColor Yellow
    $response = Read-Host "Stop existing process and start new one? (y/n)"
    if ($response -eq "y" -or $response -eq "Y") {
        Stop-Process -Id $process.Id -Force
        Start-Sleep -Seconds 2
    } else {
        Write-Host "Exiting..." -ForegroundColor Yellow
        exit 0
    }
}

# Start server
try {
    if ($useConfig) {
        Write-Host "Starting with config file: $configFile" -ForegroundColor Gray
        & $exeFile --config $configFile
    } else {
        Write-Host "Starting in dev mode (--dev)" -ForegroundColor Gray
        & $exeFile --dev
    }
} catch {
    Write-Host ""
    Write-Host "[ERROR] Failed to start server" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

