select *
from layoffs;

-- REMOVE DUPLICATES

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

insert into layoffs_staging
select *
from layoffs;

select *,
row_number() over(PARTITION BY company, total_laid_off,`date`, percentage_laid_off, industry) as row_num
from layoffs_staging
;

with duplicate_cte as
(
select *,
row_number() over(PARTITION BY company, location, total_laid_off,`date`, percentage_laid_off, industry, stage,funds_raised, country) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num >1;

-- CREATING ANOTHER COPY OF STAGING FILE TO DELETE THE DUPLIACTES
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `stage` text,
  `funds_raised` text,
  `country` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

insert into layoffs_staging2
select *,
row_number() over(PARTITION BY company, location, total_laid_off,`date`, percentage_laid_off, industry, stage,funds_raised, country) as row_num
from layoffs_staging;

select *
from layoffs_staging2
where row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

select *
from layoffs_staging2;
 
 ------------------- removed duplicates --------------------
 
 -- STANDARDIZING DATA
 SELECT COMPANY, TRIM(COMPANY)
 FROM layoffs_staging2;
 
 update layoffs_staging2
 set company = trim(company);
 
 
 select `date`
 from layoffs_staging2;
 
 update layoffs_staging2
 set `date` = str_to_date( `date`, '%Y-%m-%d' );
 -- CHANGING THE `DATE` from text type to DATE type
 alter table layoffs_staging2
 modify column `date` DATE; 
 
 SELECT *
FROM layoffs_staging2;

select company, count(company)
from layoffs_staging2
group by company;
 
