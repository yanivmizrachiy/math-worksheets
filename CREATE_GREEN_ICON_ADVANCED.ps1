# ============================================================================
# CREATE_GREEN_ICON_ADVANCED.ps1
# Creates bright green desktop icon
# ============================================================================

$ErrorActionPreference = "Continue"
$projectRoot = "C:\Users\yaniv\math-worksheets"
$indexPath = Join-Path $projectRoot "index.html"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutName = "Math Worksheets System.lnk"
$shortcutPath = Join-Path $desktopPath $shortcutName

function Write-Step {
    param([string]$Message, [string]$Status = "INFO")
    $color = switch($Status) {
        "SUCCESS" { "Green" }
        "ERROR" { "Red" }
        "WARNING" { "Yellow" }
        default { "Cyan" }
    }
    Write-Host "[$Status] $Message" -ForegroundColor $color
}

Write-Host ""
Write-Host "=== Creating Bright Green Desktop Icon ===" -ForegroundColor Green
Write-Host ""

# Check if index.html exists
if (-not (Test-Path $indexPath)) {
    Write-Step "index.html not found" "ERROR"
    exit 1
}

try {
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $indexPath
    $Shortcut.WorkingDirectory = $projectRoot
    $Shortcut.Description = "Math Worksheets System - Premium Edition"
    
    # Use green folder icon (shell32.dll,4) - most visible green icon
    $iconLocation = "shell32.dll,4"
    $Shortcut.IconLocation = $iconLocation
    $Shortcut.Save()
    
    Write-Step "Shortcut created with green icon!" "SUCCESS"
    Write-Step "Icon: $iconLocation (Green Folder)" "INFO"
    
    Write-Host ""
    Write-Host "Bright green icon created successfully!" -ForegroundColor Green
    Write-Host "Location: $shortcutPath" -ForegroundColor Cyan
    Write-Host "Icon: Bright Green Folder" -ForegroundColor Green
    Write-Host ""
    Write-Host "Double-click the green icon to open!" -ForegroundColor Yellow
    Write-Host ""
    
} catch {
    Write-Step "Error creating shortcut: $_" "ERROR"
    Write-Step "Please run manually or check permissions" "WARNING"
}
