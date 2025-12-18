# Script to stop LiveKit server (binary mode)

Write-Host "=== Stopping LiveKit Server (Binary Mode) ===" -ForegroundColor Cyan
Write-Host ""

$process = Get-Process -Name "livekit-server" -ErrorAction SilentlyContinue

if ($process) {
    Write-Host "Found LiveKit server process (PID: $($process.Id))" -ForegroundColor Yellow
    Stop-Process -Id $process.Id -Force
    Start-Sleep -Seconds 1
    
    # Verify it's stopped
    $check = Get-Process -Name "livekit-server" -ErrorAction SilentlyContinue
    if (-not $check) {
        Write-Host "[SUCCESS] LiveKit server stopped" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Process may still be running" -ForegroundColor Yellow
    }
} else {
    Write-Host "[INFO] No LiveKit server process found" -ForegroundColor Yellow
}

