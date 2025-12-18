# LiveKit Server Startup Script - Dev Mode (Simplified)
# This uses --dev flag which doesn't require config file

Write-Host "=== LiveKit Server Startup (Dev Mode) ===" -ForegroundColor Cyan

# Check if Docker is running
try {
    docker ps | Out-Null
    Write-Host "[OK] Docker is running" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Docker is not running or not installed!" -ForegroundColor Red
    Write-Host "Please install Docker Desktop and make sure it's running." -ForegroundColor Yellow
    Write-Host "You may need to restart Docker Desktop if you see API version errors." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Starting LiveKit server in DEV mode..." -ForegroundColor Yellow
Write-Host "Server will be available at: http://localhost:7880" -ForegroundColor Cyan
Write-Host "API Key: devkey" -ForegroundColor Cyan
Write-Host "API Secret: secret" -ForegroundColor Cyan
Write-Host ""

# Stop any existing container
docker stop livekit-server-dev 2>$null
docker rm livekit-server-dev 2>$null

# Start using --dev flag (no config needed)
docker run -d `
    --name livekit-server-dev `
    -p 7880:7880 `
    -p 7881:7881 `
    -p 7882:7882/udp `
    -p 50000-50100:50000-50100/udp `
    --restart unless-stopped `
    livekit/livekit-server:latest `
    --dev

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "[SUCCESS] LiveKit server started!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To view logs: docker logs -f livekit-server-dev" -ForegroundColor Yellow
    Write-Host "To stop server: docker stop livekit-server-dev" -ForegroundColor Yellow
    Write-Host "To check status: docker ps | findstr livekit" -ForegroundColor Yellow
    Write-Host ""
    
    # Wait a moment then check if server is responding
    Start-Sleep -Seconds 5
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:7880" -TimeoutSec 3 -UseBasicParsing
        Write-Host "[OK] Server is responding on port 7880" -ForegroundColor Green
        Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
    } catch {
        Write-Host "[WARNING] Server may still be starting up..." -ForegroundColor Yellow
        Write-Host "Check logs: docker logs livekit-server-dev" -ForegroundColor Yellow
    }
} else {
    Write-Host "[ERROR] Failed to start LiveKit server" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Make sure Docker Desktop is running" -ForegroundColor Yellow
    Write-Host "2. Try restarting Docker Desktop" -ForegroundColor Yellow
    Write-Host "3. Check if ports 7880, 7881, 7882 are available" -ForegroundColor Yellow
    exit 1
}

