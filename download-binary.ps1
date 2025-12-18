# Script to download LiveKit server binary for Windows

Write-Host "=== Download LiveKit Server Binary ===" -ForegroundColor Cyan
Write-Host ""

$binDir = "bin"
$latestReleaseUrl = "https://api.github.com/repos/livekit/livekit/releases/latest"

# Create bin directory if not exists
if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
    Write-Host "[OK] Created bin directory" -ForegroundColor Green
}

Write-Host "Fetching latest release info..." -ForegroundColor Yellow
try {
    $releaseInfo = Invoke-RestMethod -Uri $latestReleaseUrl -Headers @{"Accept"="application/json"}
    $version = $releaseInfo.tag_name
    Write-Host "[OK] Latest version: $version" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to fetch release info" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please download manually from:" -ForegroundColor Yellow
    Write-Host "https://github.com/livekit/livekit/releases/latest" -ForegroundColor Cyan
    exit 1
}

# Find Windows binary asset
# Pattern: livekit_VERSION_windows_amd64.zip
$windowsAsset = $releaseInfo.assets | Where-Object { 
    $_.name -like "livekit_*_windows_amd64.zip"
} | Select-Object -First 1

# If latest release has no assets, try previous releases
if (-not $windowsAsset) {
    Write-Host "[WARNING] Latest release has no assets, checking previous releases..." -ForegroundColor Yellow
    $allReleases = Invoke-RestMethod -Uri "https://api.github.com/repos/livekit/livekit/releases"
    foreach ($rel in $allReleases) {
        if ($rel.assets.Count -gt 0) {
            $windowsAsset = $rel.assets | Where-Object { 
                $_.name -like "livekit_*_windows_amd64.zip"
            } | Select-Object -First 1
            if ($windowsAsset) {
                Write-Host "[OK] Found binary in release: $($rel.tag_name)" -ForegroundColor Green
                break
            }
        }
    }
}

if (-not $windowsAsset) {
    Write-Host "[ERROR] Could not find Windows binary in any release" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please download manually from:" -ForegroundColor Yellow
    Write-Host "https://github.com/livekit/livekit/releases" -ForegroundColor Cyan
    Write-Host "Look for file: livekit_*_windows_amd64.zip" -ForegroundColor Yellow
    exit 1
}

$downloadUrl = $windowsAsset.browser_download_url
$zipFile = Join-Path $binDir "livekit-server.zip"
$exeFile = Join-Path $binDir "livekit-server.exe"

Write-Host ""
Write-Host "Downloading: $($windowsAsset.name)" -ForegroundColor Yellow
Write-Host "Size: $([math]::Round($windowsAsset.size / 1MB, 2)) MB" -ForegroundColor Gray
Write-Host ""

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing
    Write-Host "[OK] Download completed" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Download failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Extracting..." -ForegroundColor Yellow
try {
    Expand-Archive -Path $zipFile -DestinationPath $binDir -Force
    Write-Host "[OK] Extraction completed" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Extraction failed" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Clean up zip file
Remove-Item $zipFile -ErrorAction SilentlyContinue

# Check if exe exists (could be livekit.exe or livekit-server.exe)
$possibleExe1 = Join-Path $binDir "livekit.exe"
$possibleExe2 = Join-Path $binDir "livekit-server.exe"

if (Test-Path $possibleExe1) {
    # Rename to livekit-server.exe for consistency
    if (-not (Test-Path $exeFile)) {
        Rename-Item -Path $possibleExe1 -NewName "livekit-server.exe"
        Write-Host "[OK] Renamed livekit.exe to livekit-server.exe" -ForegroundColor Green
    }
}

if (Test-Path $exeFile) {
    Write-Host ""
    Write-Host "[SUCCESS] LiveKit server binary ready!" -ForegroundColor Green
    Write-Host "Location: $exeFile" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "You can now run:" -ForegroundColor Yellow
    Write-Host "  .\bin\livekit-server.exe --dev" -ForegroundColor Cyan
    Write-Host "  or" -ForegroundColor Gray
    Write-Host "  .\start-livekit-binary.ps1" -ForegroundColor Cyan
} else {
    Write-Host "[WARNING] livekit-server.exe not found after extraction" -ForegroundColor Yellow
    Write-Host "Checking for livekit.exe..." -ForegroundColor Yellow
    if (Test-Path $possibleExe1) {
        Write-Host "[INFO] Found livekit.exe, you can use it directly" -ForegroundColor Cyan
        Write-Host "  .\bin\livekit.exe --dev" -ForegroundColor Cyan
    } else {
        Write-Host "Please check bin directory and extract manually if needed" -ForegroundColor Yellow
    }
}

