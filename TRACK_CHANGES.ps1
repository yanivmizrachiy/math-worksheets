# ============================================================================
# TRACK_CHANGES.ps1 - Track file changes and tasks
# Optimized version with shared functions
# ============================================================================

$ErrorActionPreference = "Stop"

# Import common functions
$modulePath = Join-Path $PSScriptRoot "modules\CommonFunctions.psm1"
if ((Test-Path $modulePath) -and $PSScriptRoot) {
    Import-Module $modulePath -Force -ErrorAction SilentlyContinue
}

# Fallback functions if module not found
if (-not (Get-Command Write-Step -ErrorAction SilentlyContinue)) {
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
    function Get-ProjectRoot {
        if (Test-Path "C:\Users\yaniv\math-worksheets") {
            return "C:\Users\yaniv\math-worksheets"
        }
        return (Get-Location).Path
    }
    function Read-JsonFile {
        param([string]$FilePath)
        if (-not (Test-Path $FilePath)) { return $null }
        try {
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            $content = [System.IO.File]::ReadAllText($FilePath, $utf8NoBom)
            return $content | ConvertFrom-Json
        } catch {
            return $null
        }
    }
    function Write-JsonFile {
        param([string]$FilePath, [object]$Data)
        try {
            $json = $Data | ConvertTo-Json -Depth 10 -Compress:$false
            $utf8NoBom = New-Object System.Text.UTF8Encoding $false
            $dir = Split-Path $FilePath -Parent
            if ($dir -and -not (Test-Path $dir)) {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
            }
            [System.IO.File]::WriteAllText($FilePath, $json, $utf8NoBom)
            return $true
        } catch {
            return $false
        }
    }
    function Get-GitChangedFiles {
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
            return @()
        }
        $gitStatus = git status --porcelain 2>&1
        $changedFiles = @()
        if ($gitStatus) {
            $gitStatus | ForEach-Object {
                if ($_ -match '^\s*([AMDU])\s+(.+)$') {
                    $status = $matches[1]
                    $file = $matches[2].Trim()
                    $statusText = switch($status) {
                        "A" { "Added" }
                        "M" { "Modified" }
                        "D" { "Deleted" }
                        "U" { "Unmerged" }
                        default { $status }
                    }
                    $changedFiles += [PSCustomObject]@{
                        File = $file
                        Status = $statusText
                        GitStatus = $status
                    }
                }
            }
        }
        return $changedFiles
    }
}

$projectRoot = Get-ProjectRoot
if (-not $projectRoot) {
    $projectRoot = "C:\Users\yaniv\math-worksheets"
}
Set-Location $projectRoot

$historyDir = Join-Path $projectRoot "history"
$today = Get-Date -Format "yyyy-MM-dd"
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Create history directory if not exists
if (-not (Test-Path $historyDir)) {
    New-Item -ItemType Directory -Path $historyDir -Force | Out-Null
    Write-Step "History directory created" "INFO"
}

$dailyHistoryFile = Join-Path $historyDir "$today.json"

# Read existing history
$history = @{
    date = $today
    updates = @()
    changedFiles = @()
    tasks = @()
    notes = @()
}

$existing = Read-JsonFile -FilePath $dailyHistoryFile
if ($existing) {
    $history.updates = @($existing.updates)
    $history.changedFiles = @($existing.changedFiles)
    $history.tasks = @($existing.tasks)
    $history.notes = @($existing.notes)
}

# Check file changes using shared function
Write-Step "Checking file changes..." "INFO"
$changedFiles = Get-GitChangedFiles

# Convert to array of hashtables for JSON
$changedFilesArray = @()
foreach ($file in $changedFiles) {
    $changedFilesArray += @{
        file = $file.File
        status = $file.Status
        time = $now
    }
}

# Add new update
$update = @{
    time = $now
    filesChanged = $changedFilesArray.Count
    fileDetails = $changedFilesArray
    user = $env:USERNAME
    system = $env:COMPUTERNAME
}

$history.updates += $update

# Update file list efficiently using hashtable
$fileIndex = @{}
foreach ($item in $history.changedFiles) {
    $fileIndex[$item.file] = $item
}

foreach ($file in $changedFilesArray) {
    if ($fileIndex.ContainsKey($file.file)) {
        $fileIndex[$file.file].status = $file.status
        $fileIndex[$file.file].lastTime = $file.time
    } else {
        $newFile = @{
            file = $file.file
            status = $file.status
            firstTime = $file.time
            lastTime = $file.time
        }
        $fileIndex[$file.file] = $newFile
    }
}

$history.changedFiles = $fileIndex.Values

# Save daily history
if (Write-JsonFile -FilePath $dailyHistoryFile -Data $history) {
    Write-Step "History saved: $dailyHistoryFile" "SUCCESS"
} else {
    exit 1
}

# Update all history
$allHistoryFile = Join-Path $historyDir "all-history.json"
$allHistory = @{
    lastUpdate = $now
    days = @()
}

$existingAll = Read-JsonFile -FilePath $allHistoryFile
if ($existingAll) {
    $allHistory.days = @($existingAll.days)
}

# Update or add today
$dayIndex = -1
for ($i = 0; $i -lt $allHistory.days.Count; $i++) {
    if ($allHistory.days[$i].date -eq $today) {
        $dayIndex = $i
        break
    }
}

if ($dayIndex -ge 0) {
    $allHistory.days[$dayIndex].updates = $history.updates.Count
    $allHistory.days[$dayIndex].changedFiles = $history.changedFiles.Count
    $allHistory.days[$dayIndex].lastUpdate = $now
} else {
    $allHistory.days += @{
        date = $today
        updates = $history.updates.Count
        changedFiles = $history.changedFiles.Count
        lastUpdate = $now
    }
}

# Save all history
if (Write-JsonFile -FilePath $allHistoryFile -Data $allHistory) {
    Write-Step "All history updated" "SUCCESS"
}

Write-Host "`n✅ Tracking completed!" -ForegroundColor Green
