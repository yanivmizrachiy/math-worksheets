# ============================================================================
# SYNC_TO_GITHUB.ps1 - סנכרון אוטומטי ל-GitHub
# מריץ commit ו-push של כל השינויים ל-GitHub
# ============================================================================

param(
    [switch]$AutoCommit = $true,
    [string]$CommitMessage = ""
)

$ErrorActionPreference = "Continue"
$projectRoot = "C:\Users\yaniv\math-worksheets"
Set-Location $projectRoot

function Write-Step {
    param([string]$Message, [string]$Status = "INFO")
    $color = switch($Status) {
        "SUCCESS" { "Green" }
        "ERROR" { "Red" }
        "WARNING" { "Yellow" }
        default { "White" }
    }
    Write-Host "[$Status] $Message" -ForegroundColor $color
}

# בדיקת git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Step "Git is not installed! Install from: https://git-scm.com/download/win" "ERROR"
    exit 1
}

Write-Host ""
Write-Host "=== Sync to GitHub ===" -ForegroundColor Cyan
Write-Host ""

# בדיקת repository
if (-not (Test-Path ".git")) {
    Write-Step "Initializing Git repository..." "INFO"
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Step "Error initializing Git" "ERROR"
        exit 1
    }
}

# הגדרת משתמש (אם לא הוגדר)
$currentUser = git config user.email
if (-not $currentUser) {
    Write-Step "Setting Git config..." "INFO"
    git config user.name "yanivmiz77"
    git config user.email "yanivmiz77@gmail.com"
}

# בדיקת remote
$remote = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Step "Remote not configured. Need to add:" "WARNING"
    Write-Host "  git remote add origin https://github.com/yanivmiz77/math-worksheets.git" -ForegroundColor Yellow
    Write-Host "  or:" -ForegroundColor Yellow
    Write-Host "  git remote add origin git@github.com:yanivmiz77/math-worksheets.git" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After creating repository on GitHub, run this script again" -ForegroundColor Yellow
    exit 0
}

# בדיקת שינויים
Write-Step "Checking changes..." "INFO"
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Step "No changes to sync" "INFO"
    exit 0
}

# הצגת שינויים
Write-Host ""
Write-Host "Changes found:" -ForegroundColor Yellow
git status --short

# הוספת קבצים
Write-Step "Adding files..." "INFO"
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Step "Error adding files" "ERROR"
    exit 1
}

# Commit
if ($AutoCommit) {
    if ([string]::IsNullOrWhiteSpace($CommitMessage)) {
        $CommitMessage = "Auto update - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }
    Write-Step "Creating commit..." "INFO"
    git commit -m $CommitMessage
    if ($LASTEXITCODE -ne 0) {
        Write-Step "Error creating commit" "ERROR"
        exit 1
    }
    Write-Step "Commit created successfully" "SUCCESS"
}

# Push ל-GitHub
Write-Step "Pushing to GitHub..." "INFO"
$branch = git branch --show-current
if (-not $branch) {
    $branch = "main"
    git branch -M main
}

git push -u origin $branch
if ($LASTEXITCODE -eq 0) {
    Write-Step "Sync completed successfully!" "SUCCESS"
    Write-Host ""
    Write-Host "GitHub URL:" -ForegroundColor Cyan
    $remoteUrl = git remote get-url origin
    Write-Host $remoteUrl -ForegroundColor Green
} else {
    Write-Step "Error pushing. Check:" "ERROR"
    Write-Host "  1. Repository exists on GitHub" -ForegroundColor Yellow
    Write-Host "  2. You have access permissions" -ForegroundColor Yellow
    Write-Host "  3. Remote is configured correctly" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Sync completed" -ForegroundColor Cyan
Write-Host ""

