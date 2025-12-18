# LiveKit Server Status Check Script

Write-Host "=== LiveKit Server Status ===" -ForegroundColor Cyan
Write-Host ""

# Check if server is responding
Write-Host "Server Health Check:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7880" -TimeoutSec 2 -UseBasicParsing
    Write-Host "[OK] Server is responding on http://localhost:7880" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
    
    if ($response.Content -eq "OK") {
        Write-Host "[SUCCESS] LiveKit server is running correctly!" -ForegroundColor Green
    }
} catch {
    Write-Host "[ERROR] Server is not responding on port 7880" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Make sure server is running:" -ForegroundColor Yellow
    Write-Host "  .\start-livekit-binary.ps1" -ForegroundColor Cyan
}

# Check binary process
Write-Host ""
Write-Host "Process Check:" -ForegroundColor Yellow
$process = Get-Process -Name "livekit-server" -ErrorAction SilentlyContinue
if ($process) {
    Write-Host "[OK] LiveKit server process is running (PID: $($process.Id))" -ForegroundColor Green
} else {
    Write-Host "[INFO] No livekit-server process found (may be running in Docker)" -ForegroundColor Yellow
}

# Check Docker (optional)
Write-Host ""
Write-Host "Docker Check (optional):" -ForegroundColor Yellow
try {
    docker ps | Out-Null
    $dockerContainer = docker ps --filter "name=livekit" --format "{{.Names}}" 2>$null
    if ($dockerContainer) {
        Write-Host "[INFO] Docker container found: $dockerContainer" -ForegroundColor Cyan
    } else {
        Write-Host "[INFO] No Docker containers found (using binary mode)" -ForegroundColor Gray
    }
} catch {
    Write-Host "[INFO] Docker not available (using binary mode)" -ForegroundColor Gray
}

