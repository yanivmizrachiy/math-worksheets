# 🌐 הגדרת GitHub Pages - קישור חיצוני קבוע

## ✅ מה זה GitHub Pages?

GitHub Pages מאפשר לך לפרסם את האתר שלך באינטרנט עם קישור חיצוני קבוע שיפעל מכל מכשיר!

**הקישור יהיה:** `https://yanivmizrachiy.github.io/math-worksheets/`

---

## 🚀 איך להפעיל (3 שלבים פשוטים)

### שלב 1: היכנס ל-GitHub

1. לך ל: **https://github.com/yanivmizrachiy/math-worksheets**
2. התחבר עם החשבון שלך

### שלב 2: הפעל GitHub Pages

1. לחץ על **Settings** (הגדרות) - בחלק העליון של הדף
2. בחלק השמאלי, לחץ על **Pages** (תחת "Code and automation")
3. תחת **Source**, בחר **Deploy from a branch**
4. תחת **Branch**, בחר:
   - Branch: **main**
   - Folder: **/ (root)** או **/docs** (אם תיצור תיקיית docs)
5. לחץ **Save**

### שלב 3: המתן לפרסום

- GitHub יעבוד כ-1-2 דקות
- אחרי כמה דקות, הקישור שלך יהיה זמין!

---

## 🔗 הקישור שלך

אחרי ההפעלה, הקישור החיצוני שלך יהיה:

**https://yanivmizrachiy.github.io/math-worksheets/**

קישור זה יעבוד מכל מכשיר - מחשב, טלפון, טאבלט - מכל מקום בעולם!

---

## ⚠️ הערות חשובות

### 1. תיקיית קבצים
GitHub Pages מחפש את `index.html` בשורש ה-repository או בתיקיית `/docs`.

**האפשרויות:**
- **אפשרות א' (מומלץ):** העביר את `index.html` לתיקיית `docs/`
  - צור תיקייה `docs/` בשורש
  - העתק את `index.html` לתיקייה `docs/`
  - הגדר GitHub Pages להציג מ-`/docs`
  
- **אפשרות ב':** השאר את `index.html` בשורש
  - הגדר GitHub Pages להציג מ-root (`/`)

### 2. קבצים חיצוניים
אם יש קישורים פנימיים ב-`index.html`, ודא שהם יחסיים (relative):
- ✅ `tex/main.tex` (יחסי)
- ❌ `C:\Users\yaniv\math-worksheets\tex\main.tex` (מוחלט - לא יעבוד)

### 3. זמן פרסום
- הפרסום לוקח 1-2 דקות
- אם יש שגיאות, בדוק ב-Settings → Pages → "View deployment details"

---

## 🔧 אוטומציה (אופציונלי)

אם אתה רוצה שהאתר יתעדכן אוטומטית אחרי כל push, ניתן להוסיף GitHub Action.

כבר יש לך קובץ: `.github/workflows/build-and-sync.yml`

ניתן להוסיף לו גם פרסום ל-GitHub Pages!

---

## 📋 שלבים מהירים

1. ✅ לך ל: https://github.com/yanivmizrachiy/math-worksheets/settings/pages
2. ✅ בחר Branch: **main**, Folder: **/ (root)**
3. ✅ לחץ **Save**
4. ✅ המתן 1-2 דקות
5. ✅ פתח: **https://yanivmizrachiy.github.io/math-worksheets/**

---

## ✅ אחרי ההפעלה

הקישור שלך יהיה:
**https://yanivmizrachiy.github.io/math-worksheets/**

קישור זה:
- ✅ עובד מכל מכשיר
- ✅ עובד מכל מקום בעולם
- ✅ קבוע ולא משתנה
- ✅ מתעדכן אוטומטית אחרי כל push

---

**🎉 מעולה! עכשיו יש לך אתר זמין בכל מקום!**

