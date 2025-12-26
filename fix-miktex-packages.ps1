# Install fancyhdr package via MiKTeX
$miktexPackages = @('fancyhdr', 'geometry', 'graphicx', 'amsmath', 'tikz', 'pgfplots', 'fancyhdr')
foreach ($pkg in $miktexPackages) {
    Write-Host "Installing $pkg..."
    & miktex-packages.exe install $pkg --package-level=basic 2>&1 | Out-Null
}

# Fix worksheet.sty in MiKTeX installation
$miktexWorksheet = 'C:\Users\yaniv\AppData\Local\Programs\MiKTeX\tex\latex\worksheet\worksheet.sty'
if (Test-Path $miktexWorksheet) {
    $content = Get-Content $miktexWorksheet -Raw
    $content = $content -replace '\\PassOptionsToPackage\{headsepline=1pt\}\{scrlayer-scrpage\}', '% \PassOptionsToPackage{headsepline=1pt}{scrlayer-scrpage}  % disabled'
    $content = $content -replace '\\RequirePackage\{scrlayer-scrpage\}', '\RequirePackage{fancyhdr}  % replaced scrlayer-scrpage with fancyhdr'
    Set-Content -Path $miktexWorksheet -Value $content -NoNewline
    Write-Host "Fixed MiKTeX worksheet.sty to use fancyhdr"
}

# Update MiKTeX file database
& miktex-console.exe --update-fndb 2>&1 | Out-Null
Write-Host "MiKTeX database updated"
