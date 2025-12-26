# ============================================================================
# AUTO_SYNC_GITHUB.ps1 - סנכרון אוטומטי ל-GitHub אחרי כל שינוי
# רץ אוטומטית דרך Git hooks או VS Code
# ============================================================================

$ErrorActionPreference = "Continue"
$projectRoot = "C:\Users\yaniv\math-worksheets"
Set-Location $projectRoot

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

Write-Host "`n=== סנכרון אוטומטי ל-GitHub ===" -ForegroundColor Cyan
Write-Step "בודק שינויים..." "INFO"

# בדיקת git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Step "Git לא מותקן!" "ERROR"
    exit 1
}

# בדיקת repository
if (-not (Test-Path ".git")) {
    Write-Step "Git repository לא קיים!" "ERROR"
    exit 1
}

# בדיקת remote
$remote = git remote get-url origin 2>&1
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($remote)) {
    Write-Step "Remote לא מוגדר. צריך להוסיף:" "WARNING"
    Write-Host "  git remote add origin https://github.com/yanivmizrachiy/math-worksheets.git" -ForegroundColor Yellow
    exit 1
}

# בדיקת שינויים שלא commit-ו
$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Write-Step "אין שינויים חדשים לסנכרן" "INFO"
    
    # בדיקה אם יש commits שלא push-ו
    $ahead = git rev-list --count @{u}..HEAD 2>&1
    if ($ahead -and $ahead -gt 0) {
        Write-Step "יש $ahead commits שלא push-ו, דוחף ל-GitHub..." "INFO"
        $branch = git branch --show-current
        if (-not $branch) { $branch = "main" }
        git push origin $branch
        if ($LASTEXITCODE -eq 0) {
            Write-Step "Push הושלם בהצלחה!" "SUCCESS"
        } else {
            Write-Step "שגיאה ב-push" "ERROR"
            exit 1
        }
    } else {
        Write-Step "כל השינויים מסונכרנים" "SUCCESS"
    }
    exit 0
}

# יש שינויים - מוסיף, commit ו-push
Write-Host "`nשינויים שנמצאו:" -ForegroundColor Yellow
git status --short

Write-Step "מוסיף קבצים..." "INFO"
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Step "שגיאה בהוספת קבצים" "ERROR"
    exit 1
}

$commitMessage = "עדכון אוטומטי - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Step "יוצר commit..." "INFO"
git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Step "שגיאה ב-commit (אולי אין שינויים)" "WARNING"
    exit 0
}

$branch = git branch --show-current
if (-not $branch) {
    $branch = "main"
    git branch -M main
}

Write-Step "דוחף ל-GitHub..." "INFO"
git push origin $branch
if ($LASTEXITCODE -eq 0) {
    Write-Step "סנכרון הושלם בהצלחה!" "SUCCESS"
    Write-Host "`nהקישור ל-GitHub:" -ForegroundColor Cyan
    Write-Host $remote -ForegroundColor Green
} else {
    Write-Step "שגיאה ב-push" "ERROR"
    exit 1
}

exit 0

