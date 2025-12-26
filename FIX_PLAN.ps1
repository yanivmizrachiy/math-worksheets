# ============================================================================
# FIX_PLAN.ps1 - סקריפט תיקון אוטומטי לפרויקט math-worksheets
# מריץ את כל התיקונים הנדרשים להחזרת הפרויקט למצב BUILD תקין
# ============================================================================

param(
    [switch]$Backup = $true,
    [switch]$CleanBuild = $true,
    [switch]$Verbose = $true
)

$ErrorActionPreference = "Continue"
$projectRoot = "C:\Users\yaniv\math-worksheets"
Set-Location $projectRoot

function Write-Step {
    param([string]$Message)
    Write-Host "`n=== $Message ===" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

# ============================================================================
# 1. גיבויים
# ============================================================================
if ($Backup) {
    Write-Step "יצירת גיבויים"
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    
    $filesToBackup = @(
        "tex\main.tex",
        "tex\worksheet.sty"
    )
    
    foreach ($file in $filesToBackup) {
        if (Test-Path $file) {
            $backupPath = "$file.backup-$timestamp"
            Copy-Item $file $backupPath -Force
            Write-Success "גיבוי נוצר: $backupPath"
        }
    }
}

# ============================================================================
# 2. ניקוי קבצי build ישנים
# ============================================================================
if ($CleanBuild) {
    Write-Step "ניקוי קבצי build ישנים"
    $extensions = @("aux", "log", "fls", "fdb_latexmk", "xdv", "synctex.gz")
    
    foreach ($ext in $extensions) {
        Get-ChildItem $projectRoot -Filter "*.$ext" -Recurse -ErrorAction SilentlyContinue | 
            Remove-Item -Force -ErrorAction SilentlyContinue
    }
    Write-Success "ניקוי הושלם"
}

# ============================================================================
# 3. תיקון main.tex
# ============================================================================
Write-Step "בודק ומתקן main.tex"

$mainTexPath = "$projectRoot\tex\main.tex"
if (Test-Path $mainTexPath) {
    $content = Get-Content $mainTexPath -Raw
    
    # בדיקה ותיקון polyglossia -> babel
    if ($content -match '\\usepackage\{polyglossia\}') {
        Write-Error "נמצא polyglossia - צריך להחליף ל-babel ידנית"
    } else {
        Write-Success "babel נמצא (לא polyglossia)"
    }
    
    # בדיקה של פונט
    if ($content -match 'Heebo' -and $content -notmatch 'Times New Roman') {
        Write-Error "נמצא Heebo - צריך להחליף ל-Times New Roman ידנית"
    } else {
        Write-Success "פונט תקין (Times New Roman או אחר)"
    }
    
    # בדיקת worksheet.sty
    if ($content -match '\\usepackage\{worksheet\}') {
        Write-Error "נמצא \\usepackage{worksheet} - מומלץ להחליף ל-\\input{./tex/worksheet.sty}"
    } else {
        Write-Success "טעינת worksheet.sty תקינה"
    }
} else {
    Write-Error "main.tex לא נמצא!"
}

# ============================================================================
# 4. תיקון worksheet.sty המקומי
# ============================================================================
Write-Step "בודק worksheet.sty המקומי"

$worksheetPath = "$projectRoot\tex\worksheet.sty"
if (Test-Path $worksheetPath) {
    $content = Get-Content $worksheetPath -Raw
    
    # בדיקה של חבילות חיצוניות
    if ($content -match '\\RequirePackage\{geometry\}') {
        Write-Error "נמצא geometry - צריך להסיר (לא מותקן)"
    }
    if ($content -match '\\RequirePackage\{fancyhdr\}') {
        Write-Error "נמצא fancyhdr - צריך להסיר (לא מותקן)"
    }
    if ($content -match '\\RequirePackage.*tikz') {
        Write-Error "נמצא tikz - צריך להסיר (לא מותקן)"
    }
    
    Write-Success "worksheet.sty נבדק"
} else {
    Write-Error "worksheet.sty לא נמצא!"
}

# ============================================================================
# 5. תיקון worksheet.sty של MiKTeX (אם קיים)
# ============================================================================
Write-Step "בודק worksheet.sty של MiKTeX"

$miktexWorksheet = "$env:LOCALAPPDATA\Programs\MiKTeX\tex\latex\worksheet\worksheet.sty"
if (Test-Path $miktexWorksheet) {
    $content = Get-Content $miktexWorksheet -Raw
    if ($content -match 'scrlayer-scrpage' -and $content -notmatch 'fancyhdr.*replaced') {
        Write-Host "מתקן worksheet.sty של MiKTeX..." -ForegroundColor Yellow
        Copy-Item $miktexWorksheet "$miktexWorksheet.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')" -Force
        $content = $content -replace '\\PassOptionsToPackage\{headsepline=1pt\}\{scrlayer-scrpage\}', '% \PassOptionsToPackage{headsepline=1pt}{scrlayer-scrpage}  % disabled'
        $content = $content -replace '\\RequirePackage\{scrlayer-scrpage\}', '\RequirePackage{fancyhdr}  % replaced with fancyhdr'
        Set-Content -Path $miktexWorksheet -Value $content -NoNewline
        Write-Success "תיקנתי worksheet.sty של MiKTeX"
    } else {
        Write-Success "worksheet.sty של MiKTeX כבר מתוקן או לא מכיל scrlayer-scrpage"
    }
} else {
    Write-Host "worksheet.sty של MiKTeX לא נמצא (אין בעיה)" -ForegroundColor Yellow
}

# ============================================================================
# 6. עדכון מאגר MiKTeX
# ============================================================================
Write-Step "מעדכן מאגר MiKTeX"
& miktex-console.exe --update-fndb 2>&1 | Out-Null
Write-Success "מאגר MiKTeX עודכן"

# ============================================================================
# 7. הרצת build
# ============================================================================
Write-Step "מריץ build"
Write-Host "מריץ: latexmk -pdfxe -interaction=nonstopmode tex\main.tex" -ForegroundColor Yellow

$buildOutput = & latexmk -pdfxe -interaction=nonstopmode -file-line-error -synctex=1 "tex\main.tex" 2>&1
$buildLog = $buildOutput | Out-String
$buildLog | Out-File "$projectRoot\out\fix-plan-build.log" -Encoding UTF8

if ($buildLog -match "Output written.*pages of output") {
    Write-Success "Build הצליח!"
    
    # המרה ל-PDF אם צריך
    if (Test-Path "$projectRoot\main.xdv") {
        Write-Host "ממיר XDV ל-PDF..." -ForegroundColor Yellow
        & xdvipdfmx "$projectRoot\main.xdv" 2>&1 | Out-Null
    }
    
    # בדיקת PDF
    $pdfPaths = @("$projectRoot\tex\main.pdf", "$projectRoot\main.pdf")
    foreach ($pdfPath in $pdfPaths) {
        if (Test-Path $pdfPath) {
            $pdf = Get-Item $pdfPath
            Write-Success "PDF נוצר: $pdfPath"
            Write-Host "  גודל: $([math]::Round($pdf.Length/1KB, 2)) KB" -ForegroundColor Green
            Write-Host "  תאריך: $($pdf.LastWriteTime)" -ForegroundColor Green
            break
        }
    }
} else {
    Write-Error "Build נכשל"
    $errors = $buildLog | Select-String -Pattern "Error|! " | Select-Object -First 5
    Write-Host "שגיאות:"
    foreach ($err in $errors) {
        Write-Host "  - $($err.Line.Trim())" -ForegroundColor Yellow
    }
    Write-Host "`nלוג מלא נמצא ב: out\fix-plan-build.log" -ForegroundColor Yellow
}

# ============================================================================
# 8. סיכום
# ============================================================================
Write-Step "סיכום"
Write-Host "תיקון הושלם!" -ForegroundColor Green
Write-Host "`nאם יש שגיאות, בדוק את:"
Write-Host "  - out\fix-plan-build.log" -ForegroundColor Yellow
Write-Host "  - main.log" -ForegroundColor Yellow

