# 📝 איך ליצור דף עבודה במתמטיקה - מדריך מעשי

## ✅ כן! אפשר ליצור דפי עבודה במערכת הזו

המערכת מוכנה לשימוש ומאפשרת ליצור דפי עבודה מקצועיים במתמטיקה.

---

## 🚀 תהליך יצירת דף עבודה (3 שלבים פשוטים)

### שלב 1: פתח את main.tex
1. פתח את הקובץ `tex/main.tex` ב-VS Code או עורך טקסט אחר
2. זה הקובץ שבו אתה כותב את התוכן של דף העבודה

### שלב 2: כתוב את התוכן
השתמש בפקודות LaTeX כדי ליצור:
- **כותרות** - `\section*{כותרת}`
- **שאלות** - `\subsection*{שאלה 1}`
- **משוואות** - `$x^2 + y^2 = r^2$` (בתוך טקסט) או `\begin{equation}...\end{equation}` (משוואה ממוספרת)
- **רשימות** - `\begin{enumerate}...\end{enumerate}`
- **טבלאות** - `\begin{tabular}...\end{tabular}`

### שלב 3: בנה PDF
הרץ ב-PowerShell או VS Code Terminal:
```powershell
latexmk -pdfxe tex\main.tex
```

---

## 📚 דוגמאות מעשיות

### דוגמה 1: שאלה פשוטה

```latex
\section*{שאלה 1}
פתרו את המשוואה:
\begin{equation}
2x + 5 = 13
\end{equation}

\vspace{2cm}

מקום לפתרון:
```

### דוגמה 2: רשימת שאלות

```latex
\section*{תרגילים}
\begin{enumerate}
\item פתרו: $x^2 - 5x + 6 = 0$
\item מצאו את נקודת החיתוך של $y = 2x + 1$ ו-$y = -x + 4$
\item חשבו: $\int_0^1 x^2 \, dx$
\end{enumerate}
```

### דוגמה 3: טבלה

```latex
\section*{טבלת ערכים}
\begin{center}
\begin{tabular}{|c|c|}
\hline
$x$ & $f(x) = x^2$ \\
\hline
0 & 0 \\
1 & 1 \\
2 & 4 \\
3 & 9 \\
\hline
\end{tabular}
\end{center}
```

### דוגמה 4: משוואות מתקדמות

```latex
\section*{אלגברה}
פתרו את מערכת המשוואות:
\begin{align}
x + y &= 10 \\
2x - y &= 5
\end{align}
```

---

## 💡 טיפים חכמים

### 1. שימוש ב-VS Code Snippets
ב-VS Code יש snippets מוכנים:
- הקלד "שאלה" והקש Tab → נוצר template לשאלה
- הקלד "משוואה" והקש Tab → נוצר template למשוואה
- הקלד "גרף" והקש Tab → נוצר template לשאלת גרף

### 2. יצירת גרפים
השתמש בכלים חיצוניים:
- **Desmos** - צור גרף והעתק תמונה
- **GeoGebra** - צור גרף ושמור כ-PDF/תמונה
- הוסף תמונה לקובץ: `\includegraphics{path/to/image.png}`

### 3. עיצוב מהיר
- **כותרות** - `\section*{...}` או `\subsection*{...}`
- **רווח** - `\vspace{2cm}` (2 ס"מ רווח)
- **קו הפרדה** - `\hrule` (קו אופקי)
- **הדגשה** - `\textbf{טקסט חשוב}`

---

## 📋 דוגמה מלאה - דף עבודה שלם

```latex
\documentclass[a4paper,12pt]{article}
% ... (כל ההגדרות מ-main.tex)

\begin{document}

\section*{דף עבודה - משוואות ליניאריות}
\textbf{שם התלמיד:} \underline{\hspace{5cm}}

\vspace{1cm}

\subsection*{שאלה 1}
פתרו את המשוואות הבאות:

\begin{enumerate}
\item $3x + 7 = 22$
\vspace{2cm}

\item $5x - 3 = 2x + 9$
\vspace{2cm}

\item $\frac{x}{2} + 4 = 10$
\vspace{2cm}
\end{enumerate}

\subsection*{שאלה 2}
פתרו את מערכת המשוואות:
\begin{align}
x + 2y &= 8 \\
3x - y &= 1
\end{align}

\vspace{3cm}

\subsection*{שאלה 3}
נתונה הפונקציה $f(x) = 2x + 1$.
\begin{enumerate}
\item מצאו את $f(3)$
\item מצאו את $x$ כך ש-$f(x) = 7$
\end{enumerate}

\end{document}
```

---

## 🎯 שלבים מעשיים עכשיו

1. **פתח** את `tex/main.tex`
2. **החלף** את התוכן בדוגמה שלמעלה (או כתוב תוכן משלך)
3. **שמור** את הקובץ (Ctrl+S)
4. **בנה PDF**: הרץ `latexmk -pdfxe tex\main.tex`
5. **פתח** את `main.pdf` כדי לראות את התוצאה!

---

## ⚠️ בעיות נפוצות ופתרונות

### שגיאת build
- **פתרון**: הרץ `FIX_PLAN.ps1` או `DIAGNOSE_AND_FIX.ps1`

### פונטים לא מופיעים נכון
- **פתרון**: המערכת משתמשת ב-Times New Roman (מותקן כבר ב-Windows)

### משוואות לא מופיעות
- **פתרון**: ודא שאתה בתוך `$...$` או `\begin{equation}...\end{equation}`

---

## 📚 משאבים נוספים

- **VS Code Snippets** - `.vscode/latex.json` - כל ה-templates מוכנים
- **מדריך LaTeX** - חפש "LaTeX tutorial" בגוגל
- **Desmos/GeoGebra** - ליצירת גרפים (ראה באתר)

---

**✅ המערכת מוכנה לשימוש! התחל ליצור דפי עבודה!** 🚀

