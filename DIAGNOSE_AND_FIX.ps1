# ============================================================================
# Auto Diagnosis and Fix Script for math-worksheets project
# Checks all possible issues and fixes them automatically
# ============================================================================

param(
    [switch]$AutoFix = $true,
    [switch]$Verbose = $true
)

$ErrorActionPreference = "Continue"
$projectRoot = "C:\Users\yaniv\math-worksheets"
Set-Location $projectRoot

function Write-Status {
    param([string]$Message, [string]$Status = "INFO")
    $color = switch($Status) {
        "SUCCESS" { "Green" }
        "ERROR" { "Red" }
        "WARNING" { "Yellow" }
        default { "White" }
    }
    Write-Host "[$Status] $Message" -ForegroundColor $color
}

function Test-PackageInstalled {
    param([string]$PackageName)
    try {
        $result = & miktex-packages.exe --verify $PackageName 2>&1
        return ($LASTEXITCODE -eq 0)
    } catch {
        return $false
    }
}

function Install-Package {
    param([string]$PackageName)
    Write-Status "Installing package: $PackageName" "INFO"
    try {
        & miktex-console.exe --admin --install=$PackageName --package-level=basic --auto-install=yes 2>&1 | Out-Null
        Start-Sleep -Seconds 2
        return Test-PackageInstalled $PackageName
    } catch {
        Write-Status "Error installing $PackageName : $_" "ERROR"
        return $false
    }
}

# ============================================================================
# 1. Check project structure
# ============================================================================
Write-Host "`n=== Checking project structure ===" -ForegroundColor Cyan

$issues = @()
$fixes = @()

if (-not (Test-Path "$projectRoot\tex\main.tex")) {
    $issues += "main.tex not found"
    Write-Status "main.tex not found" "ERROR"
} else {
    Write-Status "main.tex found" "SUCCESS"
}

if (-not (Test-Path "$projectRoot\tex\worksheet.sty")) {
    $issues += "worksheet.sty not found"
    Write-Status "worksheet.sty not found" "ERROR"
} else {
    Write-Status "worksheet.sty found" "SUCCESS"
}

if (-not (Test-Path "$projectRoot\out")) {
    New-Item -ItemType Directory -Path "$projectRoot\out" -Force | Out-Null
    Write-Status "Created out directory" "SUCCESS"
}

# ============================================================================
# 2. Check required LaTeX packages
# ============================================================================
Write-Host "`n=== Checking LaTeX packages ===" -ForegroundColor Cyan

$requiredPackages = @(
    "geometry", "graphicx", "amsmath", "amssymb", 
    "fancyhdr", "tikz", "pgfplots", "array", "tabularx", "babel-hebrew"
)

$missingPackages = @()
foreach ($pkg in $requiredPackages) {
    if (Test-PackageInstalled $pkg) {
        Write-Status "Package $pkg installed" "SUCCESS"
    } else {
        Write-Status "Package $pkg missing" "WARNING"
        $missingPackages += $pkg
        if ($AutoFix) {
            if (Install-Package $pkg) {
                $fixes += "Installed: $pkg"
                Write-Status "Successfully installed: $pkg" "SUCCESS"
            } else {
                $issues += "Failed to install: $pkg"
            }
        }
    }
}

# ============================================================================
# 3. Check fonts
# ============================================================================
Write-Host "`n=== Checking fonts ===" -ForegroundColor Cyan

$fontsToCheck = @("Heebo", "Times New Roman", "David", "Arial")
$availableFonts = @()
foreach ($font in $fontsToCheck) {
    $result = fc-list | Select-String -Pattern $font
    if ($result) {
        Write-Status "Font $font available" "SUCCESS"
        $availableFonts += $font
    } else {
        Write-Status "Font $font not found" "WARNING"
    }
}

# Update main.tex to use available font
if ($AutoFix) {
    $mainTexPath = "$projectRoot\tex\main.tex"
    if (Test-Path $mainTexPath) {
        $mainTex = Get-Content $mainTexPath -Raw
        if ($mainTex -match "Heebo" -and $availableFonts -notcontains "Heebo") {
            if ($availableFonts -contains "Times New Roman") {
                $mainTex = $mainTex -replace "Heebo", "Times New Roman"
                Set-Content $mainTexPath -Value $mainTex -NoNewline
                $fixes += "Updated font to Times New Roman"
                Write-Status "Updated font to Times New Roman" "SUCCESS"
            }
        }
    }
}

# ============================================================================
# 4. Check MiKTeX worksheet.sty
# ============================================================================
Write-Host "`n=== Checking MiKTeX worksheet.sty ===" -ForegroundColor Cyan

$miktexWorksheet = "$env:LOCALAPPDATA\Programs\MiKTeX\tex\latex\worksheet\worksheet.sty"
if (Test-Path $miktexWorksheet) {
    $content = Get-Content $miktexWorksheet -Raw
    if ($content -match "scrlayer-scrpage") {
        Write-Status "Found issue in MiKTeX worksheet.sty (scrlayer-scrpage)" "WARNING"
        if ($AutoFix) {
            $content = $content -replace '\\PassOptionsToPackage\{headsepline=1pt\}\{scrlayer-scrpage\}', '% \PassOptionsToPackage{headsepline=1pt}{scrlayer-scrpage}  % disabled'
            $content = $content -replace '\\RequirePackage\{scrlayer-scrpage\}', '\RequirePackage{fancyhdr}  % replaced'
            Set-Content $miktexWorksheet -Value $content -NoNewline
            $fixes += "Fixed MiKTeX worksheet.sty"
            Write-Status "Fixed MiKTeX worksheet.sty" "SUCCESS"
        }
    } else {
        Write-Status "MiKTeX worksheet.sty looks OK" "SUCCESS"
    }
}

# ============================================================================
# 5. Update MiKTeX database
# ============================================================================
Write-Host "`n=== Updating MiKTeX database ===" -ForegroundColor Cyan
if ($AutoFix) {
    & miktex-console.exe --update-fndb 2>&1 | Out-Null
    Write-Status "Updated MiKTeX database" "SUCCESS"
}

# ============================================================================
# 6. Clean old build files
# ============================================================================
Write-Host "`n=== Cleaning old build files ===" -ForegroundColor Cyan
if ($AutoFix) {
    Get-ChildItem "$projectRoot" -Filter "*.aux" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem "$projectRoot" -Filter "*.log" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem "$projectRoot" -Filter "*.fls" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Get-ChildItem "$projectRoot" -Filter "*.fdb_latexmk" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Status "Cleaned old build files" "SUCCESS"
}

# ============================================================================
# 7. Test build
# ============================================================================
Write-Host "`n=== Testing build ===" -ForegroundColor Cyan

& latexmk -C "tex\main.tex" 2>&1 | Out-Null
$buildOutput = & latexmk -pdfxe -interaction=nonstopmode -file-line-error -synctex=1 "tex\main.tex" 2>&1
$buildLog = $buildOutput | Out-String

$buildLog | Out-File "$projectRoot\out\diagnose-build.log" -Encoding UTF8

if ($buildLog -match "Output written.*pages of output") {
    $pagesPattern = "Output written on.*\((\d+) pages"
    $pagesMatch = [regex]::Match($buildLog, $pagesPattern)
    if ($pagesMatch.Success) {
        $pages = $pagesMatch.Groups[1].Value
        Write-Status "Build succeeded! $pages pages created" "SUCCESS"
    } else {
        Write-Status "Build succeeded!" "SUCCESS"
    }
    
    # Check for PDF
    $pdfPaths = @("$projectRoot\tex\main.pdf", "$projectRoot\main.pdf")
    foreach ($pdfPath in $pdfPaths) {
        if (Test-Path $pdfPath) {
            $pdf = Get-Item $pdfPath
            Write-Status "PDF found: $pdfPath" "SUCCESS"
            Write-Status "Size: $([math]::Round($pdf.Length/1KB, 2)) KB" "SUCCESS"
            break
        }
    }
} else {
    Write-Status "Build failed" "ERROR"
    $errors = $buildLog | Select-String -Pattern "Error|! " | Select-Object -First 5
    foreach ($err in $errors) {
        Write-Status $err.Line "ERROR"
        $issues += $err.Line
    }
}

# ============================================================================
# 8. Summary
# ============================================================================
Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Issues found: $($issues.Count)" -ForegroundColor $(if($issues.Count -eq 0){"Green"}else{"Red"})
Write-Host "Fixes applied: $($fixes.Count)" -ForegroundColor Green

if ($issues.Count -gt 0) {
    Write-Host "`nIssues:"
    foreach ($issue in $issues) {
        Write-Host "  - $issue" -ForegroundColor Yellow
    }
}

if ($fixes.Count -gt 0) {
    Write-Host "`nFixes:"
    foreach ($fix in $fixes) {
        Write-Host "  + $fix" -ForegroundColor Green
    }
}

# Create JSON report
$report = @{
    timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss"
    issues = $issues
    fixes = $fixes
    packages_installed = $requiredPackages | Where-Object { Test-PackageInstalled $_ }
    packages_missing = $missingPackages
    fonts_available = $availableFonts
    build_success = (Test-Path "$projectRoot\tex\main.pdf") -or (Test-Path "$projectRoot\main.pdf")
}

$report | ConvertTo-Json -Depth 10 | Out-File "$projectRoot\out\diagnose-report.json" -Encoding UTF8
Write-Status "Report saved to: out\diagnose-report.json" "SUCCESS"

Write-Host "`nDiagnosis complete" -ForegroundColor Cyan
