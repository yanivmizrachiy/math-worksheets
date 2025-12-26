# ============================================================================
# CREATE_DESKTOP_LINK.ps1
# Creates desktop shortcut to index.html
# The link is saved in project and synced to GitHub
# ============================================================================

$ErrorActionPreference = "Stop"
$projectRoot = "C:\Users\yaniv\math-worksheets"
$indexPath = Join-Path $projectRoot "index.html"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$linkName = "Math Worksheets System.url"
$linkPath = Join-Path $desktopPath $linkName
$linkInProject = Join-Path $projectRoot $linkName

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

Write-Host "`n=== Creating Desktop Link ===" -ForegroundColor Cyan

# Check if index.html exists
if (-not (Test-Path $indexPath)) {
    Write-Step "index.html not found at $indexPath" "ERROR"
    exit 1
}

Write-Step "Source: $indexPath" "INFO"
Write-Step "Desktop target: $linkPath" "INFO"
Write-Step "Project target: $linkInProject" "INFO"

# Create .url file for desktop
$filePathEscaped = $indexPath.Replace('\', '/').Replace(':', ':')
$urlContent = "[InternetShortcut]`r`nURL=file:///$filePathEscaped`r`nIconFile=$filePathEscaped`r`nIconIndex=0`r`n"

try {
    # Create link on desktop
    [System.IO.File]::WriteAllText($linkPath, $urlContent, [System.Text.Encoding]::ASCII)
    Write-Step "Desktop link created successfully!" "SUCCESS"
    
    # Create link in project (for syncing)
    [System.IO.File]::WriteAllText($linkInProject, $urlContent, [System.Text.Encoding]::ASCII)
    Write-Step "Project link created successfully!" "SUCCESS"
    
    # Add to Git
    Set-Location $projectRoot
    git add $linkInProject 2>&1 | Out-Null
    Write-Step "Link added to Git" "SUCCESS"
    
    Write-Host "`n✅ Link created successfully!" -ForegroundColor Green
    Write-Host "📌 Desktop link: $linkPath" -ForegroundColor Cyan
    Write-Host "📌 Project link: $linkInProject" -ForegroundColor Cyan
    Write-Host "`n💡 Link will sync automatically to GitHub on next commit!`n" -ForegroundColor Yellow
    
} catch {
    Write-Step "Error creating link: $_" "ERROR"
    exit 1
}
