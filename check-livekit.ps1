# LiveKit Server Status Check Script

Write-Host "=== LiveKit Server Status ===" -ForegroundColor Cyan
Write-Host ""

# Check Docker
try {
    docker ps | Out-Null
    Write-Host "[OK] Docker is running" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Docker is not running" -ForegroundColor Red
    exit 1
}

# Check container status
Write-Host ""
Write-Host "Container Status:" -ForegroundColor Yellow
docker-compose ps

# Check if server is responding
Write-Host ""
Write-Host "Server Health Check:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7880" -TimeoutSec 2 -UseBasicParsing
    Write-Host "[OK] Server is responding on http://localhost:7880" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
} catch {
    Write-Host "[ERROR] Server is not responding on port 7880" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Show logs (last 10 lines)
Write-Host ""
Write-Host "Recent Logs (last 10 lines):" -ForegroundColor Yellow
docker-compose logs --tail=10 livekit

