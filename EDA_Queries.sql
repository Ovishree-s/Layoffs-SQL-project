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
 
 
