# LiveKit Server Stop Script for Windows

Write-Host "=== Stopping LiveKit Server ===" -ForegroundColor Cyan

if (Test-Path "docker-compose.yml") {
    docker-compose down
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] LiveKit server stopped" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Failed to stop server" -ForegroundColor Red
    }
} else {
    Write-Host "[ERROR] docker-compose.yml not found!" -ForegroundColor Red
}

