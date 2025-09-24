-- Exploratory data analysis (EDA) on the cleaned data
 
 select MAX(total_laid_off), MAX(percentage_laid_off)
 from layoffs_staging2;
 
 select *
 from layoffs_staging2
 where percentage_laid_off= '95%' 
 order by funds_raised desc;
 
 select company , sum(total_laid_off)
 from layoffs_staging2
 group by company
 order by 2 desc;
 
 select MIN(`date`), MAX(`date`)
 from layoffs_staging2;
 
  select industry , sum(total_laid_off)
 from layoffs_staging2
 group by industry
 order by 2 desc;
 
 select country , sum(total_laid_off)
 from layoffs_staging2
 group by country
 order by 2 desc;
 
 select YEAR(`DATE`) , sum(total_laid_off)
 from layoffs_staging2
 group by YEAR(`DATE`)
 order by 1 desc;
 
 select STAGE , sum(total_laid_off)
 from layoffs_staging2
 group by STAGE
 order by 2 desc;
 

-- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;


-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- now using it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
