# 🚀 סנכרון אוטומטי ל-GitHub - הוראות מהירות

## ✅ מה כבר מוכן?

1. ✅ Git repository מוגדר מקומית
2. ✅ User config: **yanivmiz77@gmail.com**
3. ✅ `.gitignore` מוגדר (מתעלם מקבצי build)
4. ✅ סקריפט סנכרון: `SYNC_TO_GITHUB.ps1`
5. ✅ מדריך מלא: `SETUP_GITHUB.md`

## 📋 מה שנותר לעשות (3 שלבים פשוטים):

### שלב 1: צור Repository ב-GitHub

1. לך ל: **https://github.com/new**
2. התחבר עם: **yanivmiz77@gmail.com**
3. שם: `math-worksheets`
4. לחץ **Create repository**

### שלב 2: חבר את המקומי ל-GitHub

```powershell
cd "C:\Users\yaniv\math-worksheets"
git remote add origin https://github.com/yanivmiz77/math-worksheets.git
```

### שלב 3: סנכרן!

```powershell
.\SYNC_TO_GITHUB.ps1
```

**זה הכל!** 🎉

---

## 🔄 סנכרון אוטומטי תמיד

### אפשרות קלה: הרץ ידנית כשצריך
```powershell
.\SYNC_TO_GITHUB.ps1
```

### אפשרות מתקדמת: Task Scheduler (אוטומטי לחלוטין)

1. פתח **Task Scheduler** ב-Windows
2. Create Basic Task → שם: `Sync GitHub`
3. Trigger: **Daily** או **When I log on**
4. Action: **Start a program**
5. Program: `powershell.exe`
6. Arguments:
   ```
   -ExecutionPolicy Bypass -File "C:\Users\yaniv\math-worksheets\SYNC_TO_GITHUB.ps1"
   ```
7. Start in: `C:\Users\yaniv\math-worksheets`

---

## 📝 מה נסנכרן?

**כן:**
- כל קבצי התיעוד (`.md`, `.json`)
- קבצי מקור (`tex/`)
- סקריפטים (`.ps1`)
- HTML (`index.html`)
- `.gitignore`

**לא (מוזנח ב-.gitignore):**
- קבצי build (`.aux`, `.log`, `.fls`)
- PDF (אם תרצה לשמור PDF, תצטרך לשנות `.gitignore`)

---

## 🔗 קישורים שימושיים

- **Repository שלך:** https://github.com/yanivmiz77/math-worksheets
- **מדריך מפורט:** ראה `SETUP_GITHUB.md`
- **סקריפט סנכרון:** `SYNC_TO_GITHUB.ps1`

---

**מעולה! הכל מוכן לסנכרון אוטומטי! 🚀**

