# הגדרת סנכרון אוטומטי ל-GitHub

## שלב 1: התקנת Git (אם לא מותקן)

1. הורד Git מ: https://git-scm.com/download/win
2. התקן עם ההגדרות המומלצות
3. אמת התקנה: פתח PowerShell והרץ:
   ```powershell
   git --version
   ```

## שלב 2: יצירת Repository ב-GitHub

1. לך ל: https://github.com/new
2. התחבר עם החשבון: **yanivmiz77@gmail.com**
3. מלא פרטים:
   - **Repository name:** `math-worksheets`
   - **Description:** "מערכת LaTeX ליצירת דפי עבודה במתמטיקה בעברית"
   - **Visibility:** Public או Private (כפי שתרצה)
4. לחץ **Create repository**
5. אל תוסיף README, .gitignore, או רישיון (כבר יש לנו)

## שלב 3: הגדרת Remote המקומי

לאחר יצירת ה-repository, הרץ:

```powershell
cd "C:\Users\yaniv\math-worksheets"
git remote add origin https://github.com/yanivmiz77/math-worksheets.git
```

או אם אתה משתמש ב-SSH:

```powershell
git remote add origin git@github.com:yanivmiz77/math-worksheets.git
```

## שלב 4: סנכרון ראשוני

```powershell
.\SYNC_TO_GITHUB.ps1
```

## שלב 5: סנכרון אוטומטי תמיד

### אפשרות 1: הרצה ידנית (קל ביותר)

בכל פעם שתרצה לסנכרן, הרץ:

```powershell
.\SYNC_TO_GITHUB.ps1
```

### אפשרות 2: Task Scheduler (אוטומטי לחלוטין)

1. פתח **Task Scheduler** ב-Windows
2. לחץ **Create Basic Task**
3. שם: `Sync Math Worksheets to GitHub`
4. Trigger: **Daily** או **When I log on**
5. Action: **Start a program**
6. Program: `powershell.exe`
7. Arguments: `-ExecutionPolicy Bypass -File "C:\Users\yaniv\math-worksheets\SYNC_TO_GITHUB.ps1"`
8. Start in: `C:\Users\yaniv\math-worksheets`

### אפשרות 3: Pre-commit Hook (סנכרון אחרי כל commit)

צור קובץ: `.git\hooks\post-commit` (ללא extension)

```powershell
#!/bin/sh
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\yaniv\math-worksheets\SYNC_TO_GITHUB.ps1"
```

### אפשרות 4: VS Code Task

צור קובץ: `.vscode\tasks.json`

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Sync to GitHub",
            "type": "shell",
            "command": "powershell",
            "args": [
                "-ExecutionPolicy",
                "Bypass",
                "-File",
                "${workspaceFolder}\\SYNC_TO_GITHUB.ps1"
            ],
            "problemMatcher": []
        }
    ]
}
```

לאחר מכן: Ctrl+Shift+P → "Run Task" → "Sync to GitHub"

---

## אימות

אחרי הסנכרון, בדוק ב-GitHub:
https://github.com/yanivmiz77/math-worksheets

כל הקבצים אמורים להופיע שם!

---

## פתרון בעיות

### שגיאה: "remote origin already exists"
```powershell
git remote remove origin
git remote add origin https://github.com/yanivmiz77/math-worksheets.git
```

### שגיאה: "Authentication failed"
- ודא שאתה מחובר ל-GitHub
- אולי צריך Personal Access Token (PAT)
- או השתמש ב-SSH במקום HTTPS

### שגיאה: "Repository not found"
- ודא שה-repository נוצר ב-GitHub
- ודא שהשם נכון: `math-worksheets`
- ודא שיש הרשאות גישה

