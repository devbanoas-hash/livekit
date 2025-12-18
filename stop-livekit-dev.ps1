# LiveKit Server Stop Script - Dev Mode

Write-Host "=== Stopping LiveKit Server (Dev Mode) ===" -ForegroundColor Cyan

docker stop livekit-server-dev
docker rm livekit-server-dev

if ($LASTEXITCODE -eq 0) {
    Write-Host "[SUCCESS] LiveKit server stopped" -ForegroundColor Green
} else {
    Write-Host "[INFO] Container may not exist or already stopped" -ForegroundColor Yellow
}

