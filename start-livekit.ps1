# LiveKit Server Startup Script for Windows
# This script helps you start LiveKit server using Docker

Write-Host "=== LiveKit Server Startup ===" -ForegroundColor Cyan

# Check if Docker is running
try {
    docker ps | Out-Null
    Write-Host "[OK] Docker is running" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Docker is not running or not installed!" -ForegroundColor Red
    Write-Host "Please install Docker Desktop and make sure it's running." -ForegroundColor Yellow
    exit 1
}

# Check if config file exists
if (-not (Test-Path "livekit.yaml")) {
    Write-Host "[ERROR] livekit.yaml not found!" -ForegroundColor Red
    Write-Host "Please create livekit.yaml from config-sample.yaml" -ForegroundColor Yellow
    exit 1
}

# Check if docker-compose.yml exists
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "[ERROR] docker-compose.yml not found!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Starting LiveKit server..." -ForegroundColor Yellow
Write-Host "Server will be available at: http://localhost:7880" -ForegroundColor Cyan
Write-Host "API Key: devkey" -ForegroundColor Cyan
Write-Host "API Secret: secret" -ForegroundColor Cyan
Write-Host ""

# Start using docker-compose
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "[SUCCESS] LiveKit server started!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To view logs: docker-compose logs -f" -ForegroundColor Yellow
    Write-Host "To stop server: docker-compose down" -ForegroundColor Yellow
    Write-Host "To check status: docker-compose ps" -ForegroundColor Yellow
    Write-Host ""
    
    # Wait a moment then check if server is responding
    Start-Sleep -Seconds 3
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:7880" -TimeoutSec 2 -UseBasicParsing
        Write-Host "[OK] Server is responding on port 7880" -ForegroundColor Green
    } catch {
        Write-Host "[WARNING] Server may still be starting up..." -ForegroundColor Yellow
    }
} else {
    Write-Host "[ERROR] Failed to start LiveKit server" -ForegroundColor Red
    exit 1
}

