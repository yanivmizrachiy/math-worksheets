# ============================================================================
# FIND_DESKTOP_ICON.ps1
# Finds desktop icon and shows information
# ============================================================================

$desktop = [Environment]::GetFolderPath("Desktop")
Write-Host ""
Write-Host "=== Searching Desktop for Icon ===" -ForegroundColor Cyan
Write-Host "Desktop path: $desktop"
Write-Host ""

# Search for relevant files
$allFiles = Get-ChildItem $desktop -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -like "*Math*" -or 
    $_.Name -like "*worksheet*" -or
    $_.Extension -eq ".lnk" -or 
    $_.Extension -eq ".url"
}

if ($allFiles) {
    Write-Host "Found $($allFiles.Count) relevant files:" -ForegroundColor Green
    Write-Host ""
    foreach ($file in $allFiles) {
        Write-Host "  $($file.Name)" -ForegroundColor Cyan
        Write-Host "    Path: $($file.FullName)" -ForegroundColor White
        Write-Host "    Type: $($file.Extension)" -ForegroundColor White
        Write-Host "    Date: $($file.LastWriteTime)" -ForegroundColor Gray
        Write-Host ""
        
        if ($file.Extension -eq ".lnk") {
            try {
                $shell = New-Object -ComObject WScript.Shell
                $shortcut = $shell.CreateShortcut($file.FullName)
                Write-Host "    Target: $($shortcut.TargetPath)" -ForegroundColor Gray
                Write-Host "    Icon: $($shortcut.IconLocation)" -ForegroundColor Gray
                Write-Host ""
            } catch {
                # Ignore
            }
        }
    }
} else {
    Write-Host "No relevant files found on desktop" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Tips:" -ForegroundColor Yellow
Write-Host "  - Press F5 on desktop to refresh" -ForegroundColor White
Write-Host "  - Search for: Math Worksheets" -ForegroundColor White
Write-Host ""
