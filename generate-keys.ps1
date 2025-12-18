# Script to generate LiveKit API Key and Secret
# This will create a new key/secret pair for production use

Write-Host "=== Generate LiveKit API Keys ===" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
try {
    docker ps | Out-Null
    Write-Host "[OK] Docker is running" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Docker is not running!" -ForegroundColor Red
    exit 1
}

Write-Host "Generating new API key and secret..." -ForegroundColor Yellow
Write-Host ""

# Run LiveKit server in generate-keys mode
$output = docker run --rm livekit/livekit-server:latest livekit-server generate-keys 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host $output -ForegroundColor Green
    Write-Host ""
    Write-Host "=== Next Steps ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Copy the API Key and Secret above" -ForegroundColor Yellow
    Write-Host "2. Update livekit.yaml with your new keys:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   keys:" -ForegroundColor Gray
    Write-Host "     YOUR_API_KEY: YOUR_API_SECRET" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Update your app environment variables:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   LIVEKIT_API_KEY=YOUR_API_KEY" -ForegroundColor Gray
    Write-Host "   LIVEKIT_API_SECRET=YOUR_API_SECRET" -ForegroundColor Gray
    Write-Host ""
    Write-Host "4. Restart LiveKit server" -ForegroundColor Yellow
} else {
    Write-Host "[ERROR] Failed to generate keys" -ForegroundColor Red
    Write-Host $output -ForegroundColor Red
    exit 1
}

