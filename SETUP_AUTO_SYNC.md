# הגדרת סנכרון אוטומטי ל-GitHub

**כל עדכון בפרויקט יסונכרן אוטומטית ל-GitHub בחשבון yanivmiz77@gmail.com**

---

## 🎯 מה הוגדר?

### 1. Git Hook - סנכרון אוטומטי אחרי commit
- **קובץ:** `.git/hooks/post-commit`
- **פעולה:** רץ אוטומטית אחרי כל `git commit`
- **סקריפט:** `AUTO_SYNC_GITHUB.ps1`

### 2. סקריפט סנכרון אוטומטי
- **קובץ:** `AUTO_SYNC_GITHUB.ps1`
- **תפקיד:** מוסיף, commit ו-push אוטומטית ל-GitHub
- **שימוש:** רץ אוטומטית דרך Git hook או ידנית

### 3. VS Code Integration
- **Task:** "Auto Sync to GitHub"
- **קיצור:** `Ctrl+Alt+S` (Sync to GitHub)
- **תפקיד:** סנכרון ידני מהיר

---

## 🚀 איך זה עובד?

### אוטומטי (מומלץ):
1. אתה עורך קבצים ב-VS Code
2. אתה שומר (Ctrl+S) - LaTeX Workshop בונה PDF
3. אתה עושה `git commit` או `Ctrl+Alt+S`
4. Git hook רץ אוטומטית
5. השינויים נדחפים ל-GitHub

### ידני:
1. פתח PowerShell
2. נווט לתיקיית הפרויקט
3. הרץ: `.\AUTO_SYNC_GITHUB.ps1`

---

## ⚙️ הגדרות

### Remote URL:
```
https://github.com/yanivmizrachiy/math-worksheets.git
```

### Git User:
- **Name:** yanivmiz77
- **Email:** yanivmiz77@gmail.com

---

## 🔧 פתרון בעיות

### אם ה-hook לא רץ:
1. בדוק שהקובץ `.git/hooks/post-commit` קיים
2. בדוק שיש הרשאות הרצה
3. הרץ ידנית: `.\AUTO_SYNC_GITHUB.ps1`

### אם יש שגיאת push:
1. בדוק שיש חיבור לאינטרנט
2. בדוק שה-repository קיים ב-GitHub
3. בדוק שיש הרשאות גישה
4. הרץ: `git remote -v` כדי לראות את ה-remote

---

## 📋 שימוש ב-VS Code

### קיצורי מקשים:
- **Ctrl+Alt+S** - Sync to GitHub (ידני)
- **Ctrl+Alt+B** - Build PDF
- **Ctrl+Alt+V** - View Preview

### Tasks:
1. `Ctrl+Shift+P` → "Tasks: Run Task"
2. בחר "Auto Sync to GitHub"

---

## ✅ וידוא שהכל עובד

### בדיקה מהירה:
```powershell
cd C:\Users\yaniv\math-worksheets
.\AUTO_SYNC_GITHUB.ps1
```

### בדיקת Git Hook:
```powershell
cd C:\Users\yaniv\math-worksheets
git commit --allow-empty -m "בדיקת hook"
```

---

## 📝 הערות

- הסנכרון האוטומטי רץ רק אחרי `git commit`
- אם אתה רוצה סנכרון על כל שמירה, השתמש ב-VS Code Task
- הקבצים ב-`.gitignore` לא יסונכרנו
- כל commit יקבל הודעה אוטומטית עם תאריך ושעה

---

**עודכן:** 26 בדצמבר 2025

