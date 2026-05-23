-- Exploratory Data Analysis
SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions desc;

SELECT company,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 desc;

SELECT MIN(date), MAX(date)
FROM layoffs_staging2;

SELECT stage,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 desc;

SELECT company,AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 desc;


SELECT SUBSTRING(DATE,1,7) AS month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(DATE,1,7) IS NOT NULL
GROUP BY MONTH
ORDER BY 1 asc;


WITH Rolling_total AS
(
SELECT SUBSTRING(DATE,1,7) AS month, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(DATE,1,7) IS NOT NULL
GROUP BY MONTH
ORDER BY 1 asc)
SELECT month,total_off,SUM(total_off) OVER(ORDER BY MONTH) AS Rolling_total
FROM Rolling_total;


SELECT company,YEAR(date),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC
;


WITH Company_Year  (Company,Years,total_laid_off) AS
(
SELECT company,YEAR(date),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(date)
),COMAPNY_YEAR_RANK AS
(SELECT *,DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS RANKING
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM COMAPNY_YEAR_RANK
WHERE RANKING<=5 ;