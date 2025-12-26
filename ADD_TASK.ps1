# ============================================================================
# ADD_TASK.ps1 - Add task to history
# ============================================================================

param(
    [Parameter(Mandatory=$true)]
    [string]$TaskDescription,
    
    [string]$Category = "General",
    [string]$Priority = "Medium"
)

$ErrorActionPreference = "Continue"
$projectRoot = "C:\Users\yaniv\math-worksheets"
Set-Location $projectRoot

$historyDir = "history"
$today = Get-Date -Format "yyyy-MM-dd"
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$dailyHistoryFile = Join-Path $historyDir "$today.json"

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

# Read existing history
$history = @{
    date = $today
    updates = @()
    changedFiles = @()
    tasks = @()
    notes = @()
}

if (Test-Path $dailyHistoryFile) {
    try {
        $existing = Get-Content $dailyHistoryFile -Raw -Encoding UTF8 | ConvertFrom-Json
        $history = $existing
        if (-not $history.tasks) { $history.tasks = @() }
        if (-not $history.updates) { $history.updates = @() }
        if (-not $history.changedFiles) { $history.changedFiles = @() }
        if (-not $history.notes) { $history.notes = @() }
    } catch {
        Write-Step "Creating new history" "INFO"
    }
}

# Add new task
$newTask = @{
    id = [guid]::NewGuid().ToString()
    description = $TaskDescription
    category = $Category
    priority = $Priority
    status = "Open"
    createdTime = $now
    updatedTime = $now
    user = $env:USERNAME
}

if (-not $history.tasks) {
    $history.tasks = @()
}
$history.tasks += $newTask

# Save
try {
    $json = $history | ConvertTo-Json -Depth 10 -Compress:$false
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($dailyHistoryFile, $json, $utf8NoBom)
    Write-Step "Task added successfully!" "SUCCESS"
    Write-Host "`nTask: $TaskDescription" -ForegroundColor Cyan
    Write-Host "Category: $Category" -ForegroundColor Cyan
    Write-Host "Priority: $Priority" -ForegroundColor Cyan
} catch {
    Write-Step "Error saving task: $_" "ERROR"
    exit 1
}
