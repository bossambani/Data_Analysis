-- Data Cleaning
USE `world_layoffs`;
SELECT * FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove unnecessary columns / rows


-- Creating a Stagin table to carry out the data cleaning
CREATE TABLE layoff_staging
LIKE layoffs;

INSERT INTO layoff_staging
SELECT * FROM layoffs;

SELECT * FROM layoff_staging;

SELECT *,
ROW_NUMBER() OVER
(PARTITION BY company, industry,
total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoff_staging;

WITH duplicates_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage,
country, funds_raised_millions) AS row_num
FROM layoff_staging
)
SELECT * 
FROM duplicates_cte
WHERE row_num > 1;

SELECT * 
FROM layoff_staging
WHERE company = 'Casper';

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` bigint DEFAULT NULL,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoff_staging2;

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage,
country, funds_raised_millions) AS row_num
FROM layoff_staging;


SET SQL_SAFE_UPDATES = 0;
DELETE 
FROM layoff_staging2
WHERE row_num > 1;
SET SQL_SAFE_UPDATES = 1;

SELECT * 
FROM layoff_staging2;

-- Standardizing Data
SELECT company, (TRIM(company))
FROM layoff_staging2;


SELECT DISTINCT(industry)
FROM layoff_staging2
ORDER BY 1;

SELECT industry
FROM layoff_staging2
WHERE industry LIKE 'Crypto%';

SET SQL_SAFE_UPDATES = 0;
UPDATE layoff_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT(country)
FROM layoff_staging2
ORDER BY 1;


SELECT DISTINCT(country), TRIM(TRAILING '.' FROM country)
FROM layoff_staging2
WHERE country LIKE 'United States%';

UPDATE layoff_staging2
SET country = TRIM(TRAILING '.' from country)
WHERE country LIKE 'United States%';


SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoff_staging2;

UPDATE layoff_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoff_staging2;

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` Date;

SELECT * 
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoff_staging2
WHERE industry IS NULL
OR industry = '';

UPDATE layoff_staging2
SET industry = NULL
WHERE industry = '';

SELECT t1.industry, t2.industry  
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry    
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoff_staging2
WHERE company = 'Airbnb';

SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT * 
FROM layoff_staging2;

ALTER TABLE layoff_staging2
DROP COLUMN row_num;
