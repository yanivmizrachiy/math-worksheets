# ============================================================================
# CREATE_GREEN_DESKTOP_ICON.ps1
# יוצר אייקון ירוק בולט לשולחן העבודה
# ============================================================================

$ErrorActionPreference = "Stop"
$projectRoot = "C:\Users\yaniv\math-worksheets"
$indexPath = Join-Path $projectRoot "index.html"
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutName = "מערכת דפי עבודה במתמטיקה.lnk"
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

Write-Host "`n=== יצירת אייקון ירוק בולט לשולחן העבודה ===" -ForegroundColor Cyan

# Check if index.html exists
if (-not (Test-Path $indexPath)) {
    Write-Step "index.html not found at $indexPath" "ERROR"
    exit 1
}

Write-Step "Source: $indexPath" "INFO"
Write-Step "Desktop shortcut: $shortcutPath" "INFO"

try {
    # Create WScript Shell object
    $WshShell = New-Object -ComObject WScript.Shell
    
    # Create shortcut
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $indexPath
    $Shortcut.WorkingDirectory = $projectRoot
    $Shortcut.Description = "מערכת דפי עבודה במתמטיקה - Premium Edition"
    
    # Set icon to green folder icon (Windows system icon)
    # Using green folder icon from shell32.dll (icon index 4 is green folder)
    $Shortcut.IconLocation = "shell32.dll,4"
    
    # Alternative: Use green application icon
    # $Shortcut.IconLocation = "imageres.dll,99"  # Green circle
    
    # Save shortcut
    $Shortcut.Save()
    
    Write-Step "Desktop shortcut created successfully!" "SUCCESS"
    Write-Step "Using green folder icon (shell32.dll,4)" "INFO"
    
    # Try to set custom green icon if available
    # Check if we can use a green icon from system
    try {
        # Try to use green application icon from imageres.dll
        $Shortcut.IconLocation = "imageres.dll,99"
        $Shortcut.Save()
        Write-Step "Updated to green application icon" "SUCCESS"
    } catch {
        Write-Step "Using default green folder icon" "INFO"
    }
    
    Write-Host "`n✅ Shortcut created successfully!" -ForegroundColor Green
    Write-Host "📌 Desktop shortcut: $shortcutPath" -ForegroundColor Cyan
    Write-Host "🎨 Icon: Green folder/application icon" -ForegroundColor Green
    Write-Host "`n💡 Double-click the shortcut to open the website!`n" -ForegroundColor Yellow
    
} catch {
    Write-Step "Error creating shortcut: $_" "ERROR"
    
    # Fallback: Create .url file with green theme
    Write-Step "Creating .url file as fallback..." "WARNING"
    $urlName = "מערכת דפי עבודה במתמטיקה.url"
    $urlPath = Join-Path $desktopPath $urlName
    $filePathEscaped = $indexPath.Replace('\', '/').Replace(':', ':')
    $urlContent = "[InternetShortcut]`r`nURL=file:///$filePathEscaped`r`nIconFile=$filePathEscaped`r`nIconIndex=0`r`n"
    
    try {
        [System.IO.File]::WriteAllText($urlPath, $urlContent, [System.Text.Encoding]::ASCII)
        Write-Step "URL file created as fallback" "SUCCESS"
    } catch {
        Write-Step "Failed to create URL file: $_" "ERROR"
        exit 1
    }
}

