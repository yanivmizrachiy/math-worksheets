# ============================================================================
# SETUP_GITHUB_PAGES_AUTO.ps1
# הוראות להפעלת GitHub Pages אוטומטית
# ============================================================================

Write-Host ""
Write-Host "=== הגדרת GitHub Pages - קישור חיצוני קבוע ===" -ForegroundColor Cyan
Write-Host ""

$repoUrl = "https://github.com/yanivmizrachiy/math-worksheets"
$pagesUrl = "https://yanivmizrachiy.github.io/math-worksheets/"

Write-Host "🔗 הקישור שלך יהיה:" -ForegroundColor Green
Write-Host "$pagesUrl" -ForegroundColor Yellow
Write-Host ""

Write-Host "📋 שלבים להפעלה:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. פתח בדפדפן: $repoUrl/settings/pages" -ForegroundColor White
Write-Host ""
Write-Host "2. תחת 'Source', בחר:" -ForegroundColor White
Write-Host "   - Branch: main" -ForegroundColor Gray
Write-Host "   - Folder: / (root)" -ForegroundColor Gray
Write-Host ""
Write-Host "3. לחץ Save" -ForegroundColor White
Write-Host ""
Write-Host "4. המתן 1-2 דקות" -ForegroundColor White
Write-Host ""
Write-Host "5. פתח את הקישור: $pagesUrl" -ForegroundColor White
Write-Host ""

Write-Host "⚠️ חשוב:" -ForegroundColor Yellow
Write-Host "   - ודא ש-index.html נמצא בשורש ה-repository" -ForegroundColor Gray
Write-Host "   - קישורים פנימיים צריכים להיות יחסיים (לא מוחלטים)" -ForegroundColor Gray
Write-Host ""

# פתיחת הקישור
$openSettings = Read-Host "לפתוח את דף ההגדרות עכשיו? (Y/N)"
if ($openSettings -eq "Y" -or $openSettings -eq "y") {
    Start-Process "$repoUrl/settings/pages"
    Write-Host ""
    Write-Host "✅ נפתח דף ההגדרות בדפדפן!" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ הוראות הוצגו. לאחר ההפעלה, הקישור שלך יהיה:" -ForegroundColor Green
Write-Host "$pagesUrl" -ForegroundColor Yellow
Write-Host ""

