# ============================================================================
# SHOW_DESKTOP_ICON.ps1
# Opens desktop folder and highlights the icon
# ============================================================================

$desktop = [Environment]::GetFolderPath("Desktop")
$iconPath = Join-Path $desktop "Math Worksheets.lnk"

Write-Host ""
Write-Host "=== Opening Desktop to Show Icon ===" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $iconPath) {
    Write-Host "✅ Icon found: Math Worksheets.lnk" -ForegroundColor Green
    Write-Host "📌 Location: $iconPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Opening desktop folder..." -ForegroundColor Yellow
    
    # Open desktop folder in Explorer
    Start-Process explorer.exe -ArgumentList $desktop
    
    Write-Host ""
    Write-Host "💡 Look for:" -ForegroundColor Yellow
    Write-Host "   - Green folder icon" -ForegroundColor Green
    Write-Host "   - Name: Math Worksheets" -ForegroundColor White
    Write-Host ""
    Write-Host "If you don't see it:" -ForegroundColor Yellow
    Write-Host "   1. Press F5 in the Explorer window (refresh)" -ForegroundColor White
    Write-Host "   2. Sort by Name (right-click > Sort by > Name)" -ForegroundColor White
    Write-Host "   3. Search for: Math" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "❌ Icon not found. Creating new one..." -ForegroundColor Red
    Write-Host ""
    PowerShell -ExecutionPolicy Bypass -File ".\CREATE_GREEN_ICON_ADVANCED.ps1"
}

