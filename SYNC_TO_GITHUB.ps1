# ============================================================================
# SYNC_TO_GITHUB.ps1 - סנכרון אוטומטי ל-GitHub
# מריץ commit ו-push של כל השינויים ל-GitHub
# ============================================================================

param(
    [switch]$AutoCommit = $true,
    [string]$CommitMessage = "עדכון אוטומטי - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
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
    Write-Step "Git לא מותקן! התקן מ: https://git-scm.com/download/win" "ERROR"
    exit 1
}

Write-Host "`n=== סנכרון אוטומטי ל-GitHub ===" -ForegroundColor Cyan

# בדיקת repository
if (-not (Test-Path ".git")) {
    Write-Step "מאתחל Git repository..." "INFO"
    git init
    if ($LASTEXITCODE -ne 0) {
        Write-Step "שגיאה באתחול Git" "ERROR"
        exit 1
    }
}

# הגדרת משתמש (אם לא הוגדר)
$currentUser = git config user.email
if (-not $currentUser) {
    Write-Step "מגדיר Git config..." "INFO"
    git config user.name "yanivmiz77"
    git config user.email "yanivmiz77@gmail.com"
}

# בדיקת remote
$remote = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Step "Remote לא מוגדר. צריך להוסיף:" "WARNING"
    Write-Host "  git remote add origin https://github.com/yanivmiz77/math-worksheets.git" -ForegroundColor Yellow
    Write-Host "  או:" -ForegroundColor Yellow
    Write-Host "  git remote add origin git@github.com:yanivmiz77/math-worksheets.git" -ForegroundColor Yellow
    Write-Host "`nאחרי שתיצור repository ב-GitHub, הרץ את הסקריפט שוב" -ForegroundColor Yellow
    exit 0
}

# בדיקת שינויים
Write-Step "בודק שינויים..." "INFO"
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Step "אין שינויים לסנכרן" "INFO"
    exit 0
}

# הצגת שינויים
Write-Host "`nשינויים שנמצאו:" -ForegroundColor Yellow
git status --short

# הוספת קבצים
Write-Step "מוסיף קבצים..." "INFO"
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Step "שגיאה בהוספת קבצים" "ERROR"
    exit 1
}

# Commit
if ($AutoCommit) {
    Write-Step "יוצר commit..." "INFO"
    git commit -m $CommitMessage
    if ($LASTEXITCODE -ne 0) {
        Write-Step "שגיאה ב-commit" "ERROR"
        exit 1
    }
    Write-Step "Commit נוצר בהצלחה" "SUCCESS"
}

# Push ל-GitHub
Write-Step "דוחף ל-GitHub..." "INFO"
$branch = git branch --show-current
if (-not $branch) {
    $branch = "main"
    git branch -M main
}

git push -u origin $branch
if ($LASTEXITCODE -eq 0) {
    Write-Step "סנכרון הושלם בהצלחה!" "SUCCESS"
    Write-Host "`nהקישור ל-GitHub:" -ForegroundColor Cyan
    $remoteUrl = git remote get-url origin
    Write-Host $remoteUrl -ForegroundColor Green
} else {
    Write-Step "שגיאה ב-push. בדוק:" "ERROR"
    Write-Host "  1. שה-repository קיים ב-GitHub" -ForegroundColor Yellow
    Write-Host "  2. שיש הרשאות גישה" -ForegroundColor Yellow
    Write-Host "  3. שה-remote מוגדר נכון" -ForegroundColor Yellow
    exit 1
}

Write-Host "`nסיום סנכרון" -ForegroundColor Cyan

