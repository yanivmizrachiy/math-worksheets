# ============================================================================
# VIEW_HISTORY.ps1 - View history
# ============================================================================

param(
    [string]$Date = (Get-Date -Format "yyyy-MM-dd"),
    [switch]$All,
    [switch]$Tasks,
    [switch]$Files
)

$ErrorActionPreference = "Continue"
$projectRoot = "C:\Users\yaniv\math-worksheets"
Set-Location $projectRoot

$historyDir = "history"

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

if ($All) {
    # Show all history
    $allHistoryFile = Join-Path $historyDir "all-history.json"
    if (Test-Path $allHistoryFile) {
        $allHistory = Get-Content $allHistoryFile -Raw -Encoding UTF8 | ConvertFrom-Json
        Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "All History" -ForegroundColor Cyan
        Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan
        
        $allHistory.days | Sort-Object -Property date -Descending | ForEach-Object {
            Write-Host "📅 $($_.date)" -ForegroundColor Yellow
            Write-Host "   Updates: $($_.updates)" -ForegroundColor White
            Write-Host "   Changed Files: $($_.changedFiles)" -ForegroundColor White
            Write-Host "   Last Update: $($_.lastUpdate)`n" -ForegroundColor Gray
        }
    } else {
        Write-Step "No all history found" "WARNING"
    }
} else {
    # Show daily history
    $dailyHistoryFile = Join-Path $historyDir "$Date.json"
    if (Test-Path $dailyHistoryFile) {
        $history = Get-Content $dailyHistoryFile -Raw -Encoding UTF8 | ConvertFrom-Json
        
        Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "History - $Date" -ForegroundColor Cyan
        Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor Cyan
        
        if ($Tasks -or (-not $Files)) {
            Write-Host "📋 Tasks:" -ForegroundColor Yellow
            if ($history.tasks -and $history.tasks.Count -gt 0) {
                $history.tasks | ForEach-Object {
                    Write-Host "   • [$($_.status)] $($_.description)" -ForegroundColor White
                    Write-Host "     Category: $($_.category) | Priority: $($_.priority)" -ForegroundColor Gray
                    Write-Host "     Created: $($_.createdTime)`n" -ForegroundColor DarkGray
                }
            } else {
                Write-Host "   No tasks today`n" -ForegroundColor Gray
            }
        }
        
        if ($Files -or (-not $Tasks)) {
            Write-Host "📁 Changed Files:" -ForegroundColor Yellow
            if ($history.changedFiles -and $history.changedFiles.Count -gt 0) {
                $history.changedFiles | ForEach-Object {
                    Write-Host "   • [$($_.status)] $($_.file)" -ForegroundColor White
                    if ($_.lastTime) {
                        Write-Host "     Last Update: $($_.lastTime)`n" -ForegroundColor Gray
                    } else {
                        Write-Host ""
                    }
                }
            } else {
                Write-Host "   No files changed today`n" -ForegroundColor Gray
            }
        }
        
        Write-Host "📊 Summary:" -ForegroundColor Yellow
        Write-Host "   Updates: $($history.updates.Count)" -ForegroundColor White
        Write-Host "   Changed Files: $($history.changedFiles.Count)" -ForegroundColor White
        Write-Host "   Tasks: $($history.tasks.Count)`n" -ForegroundColor White
    } else {
        Write-Step "No history found for $Date" "WARNING"
    }
}
