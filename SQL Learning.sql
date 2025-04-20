-- BEGINNER LEVEL
SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT first_name, last_name, birth_date
FROM parks_and_recreation.employee_demographics;

SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics;

-- WHERE CLAUSE
SELECT * 
FROM parks_and_recreation.employee_salary
WHERE first_name = 'Leslie';

SELECT * 
FROM parks_and_recreation.employee_salary
WHERE salary <= 50000;

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE gender != 'Female';

-- lOGIC OPERATORS(AND, OR, NOT)

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE gender != 'Female'
AND birth_date > '1985-01,01';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE gender != 'Female'
OR birth_date > '1985-01,01';

-- LIKE STATEMENT
-- % and _
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'Jer%';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE '%er%';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'a___%';

SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE birth_date LIKE '1989%';


-- GROUP BY
SELECT gender, COUNT(Age) as total_age, MAX(Age) as max_age, MIN(Age) as min_age, AVG(Age) as avg_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

-- ORDER BY
-- sorts the values either in desc and asc order
SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY first_name ASC;

SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY gender, age DESC;


-- HAVING vs WHERE
SELECT gender, AVG(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

SELECT occupation, AVG(salary)
FROM parks_and_recreation.employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;

-- LIMIT and ALIASING
SELECT * 
FROM parks_and_recreation.employee_demographics
ORDER BY age DESC
LIMIT 3;

SELECT gender, AVG(age) AS avg_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING avg_age > 40;

-- INTERMEDIATE LEVEL
-- JOINS
-- INNER JOIN
SELECT demo.employee_id, age, occupation, salary
FROM parks_and_recreation.employee_demographics AS demo
INNER JOIN parks_and_recreation.employee_salary AS sal
	ON demo.employee_id = sal.employee_id;
    
-- OUTER JOIN
SELECT *
FROM parks_and_recreation.employee_demographics AS demo
LEFT JOIN parks_and_recreation.employee_salary AS sal
	ON demo.employee_id = sal.employee_id;
    
SELECT *
FROM parks_and_recreation.employee_demographics AS demo
RIGHT JOIN parks_and_recreation.employee_salary AS sal
	ON demo.employee_id = sal.employee_id;

-- SELF JOIN
SELECT *
FROM parks_and_recreation.employee_demographics AS demo
LEFT JOIN parks_and_recreation.employee_salary AS sal
	ON demo.employee_id = sal.employee_id;
    
-- JOINING MULTIPLE TABLES TOGETHER
SELECT *
FROM parks_and_recreation.employee_demographics AS demo
RIGHT JOIN parks_and_recreation.employee_salary AS sal
	ON demo.employee_id = sal.employee_id
INNER JOIN parks_and_recreation.parks_departments AS dept
	ON sal.dept_id = dept.department_id;

-- UNIONS
SELECT first_name, last_name
FROM parks_and_recreation.employee_demographics 
UNION ALL
SELECT first_name, last_name
FROM parks_and_recreation.employee_salary;

SELECT first_name, last_name, 'OLD MAN' AS label
FROM parks_and_recreation.employee_demographics 
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'OLD LADY' AS label
FROM parks_and_recreation.employee_demographics 
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'HIGHLY PAID' AS label
FROM parks_and_recreation.employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;

-- STRING FUNCTIONS
SELECT LENGTH('Skyfall');

SELECT first_name, LENGTH(first_name)
FROM parks_and_recreation.employee_demographics
ORDER BY 2;

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM parks_and_recreation.employee_demographics;

SELECT RTRIM('          SKY        ');

SELECT first_name,
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name, 3, 2),
birth_date,
SUBSTRING(birth_date, 6, 2)
FROM parks_and_recreation.employee_demographics;

-- REPLACE
SELECT first_name, REPLACE(first_name, 'Tom', 'Tommy')
FROM parks_and_recreation.employee_demographics;

-- locate
SELECT first_name, LOCATE('An', first_name)
FROM parks_and_recreation.employee_demographics;

-- CONCAT
SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name) AS full_name
FROM parks_and_recreation.employee_demographics;

-- CASE STATEMENTS
SELECT first_name, last_name,
age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Older'
    WHEN age >= 50 THEN 'Oldest'
END AS age_bracket
FROM parks_and_recreation.employee_demographics;

-- pay increase and bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- finance dept = 10% bonus

SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN (salary * 0.05) + salary
    WHEN salary > 50000 THEN (salary * 0.07) + salary
END AS new_salary,
CASE
	WHEN dept_id = 6 THEN salary * 0.10
END AS Bonus
FROM parks_and_recreation.employee_salary;

-- Subqueries
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE employee_id IN
					(SELECT employee_id
                    FROM parks_and_recreation.employee_salary
                    WHERE dept_id = 1)
;


SELECT first_name, last_name, salary,
(SELECT AVG(salary)
FROM parks_and_recreation.employee_salary)
FROM parks_and_recreation.employee_salary;

SELECT AVG(max_age)
FROM
(SELECT gender,
AVG(age) AS avg_age,
MAX(age) AS max_age,
MIN(age) AS min_age,
COUNT(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender) AS agg_table;


-- Window Functions
SELECT gender, AVG(salary) AS avg_salary
FROM parks_and_recreation.employee_demographics AS demo
JOIN
	parks_and_recreation.employee_salary AS sal
    ON demo.employee_id = sal.employee_id
GROUP BY gender;

SELECT demo.first_name, demo.last_name, gender, salary, 
SUM(salary) OVER(PARTITION BY gender ORDER BY demo.employee_id) as rolling_total
FROM parks_and_recreation.employee_demographics AS demo
JOIN
	parks_and_recreation.employee_salary AS sal
    ON demo.employee_id = sal.employee_id;


SELECT demo.employee_id, demo.first_name, demo.last_name, gender, salary, 
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM parks_and_recreation.employee_demographics AS demo
JOIN
	parks_and_recreation.employee_salary AS sal
    ON demo.employee_id = sal.employee_id;
    



SELECT demo.first_name, demo.last_name, sal.salary,
ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num,
RANK() OVER(ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(ORDER BY salary DESC) AS dense_rank_num
FROM parks_and_recreation.employee_salary AS demo
JOIN
	parks_and_recreation.employee_salary AS sal
    ON demo.employee_id = sal.employee_id
;


-- CTEs
WITH CTE_Example AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal
FROM parks_and_recreation.employee_demographics demo
JOIN parks_and_recreation.employee_salary sal
	ON demo.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example
;

WITH CTE_Example AS
(
SELECT employee_id, gender
FROM parks_and_recreation.employee_demographics 
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM parks_and_recreation.employee_salary sal
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id
;


-- Temporary Tables
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

INSERT INTO temp_table
VALUES('Bossy', 'Ambaka', 'Killer');

SELECT *
FROM temp_table;


CREATE TEMPORARY TABLE salary_greater_50k
( SELECT *
FROM parks_and_recreation.employee_salary
WHERE salary > 50000
);

SELECT *
FROM salary_greater_50k;


-- Stored Procedures

CREATE PROCEDURE large_salaries()
SELECT *
FROM parks_and_recreation.employee_salary
WHERE salary > 50000;

CALL large_salaries;


CREATE PROCEDURE small_salaries()
SELECT *
FROM parks_and_recreation.employee_salary
WHERE salary < 50000;

CALL large_salaries;


USE `parks_and_recreation`;
DROP  PROCEDURE IF EXISTS `salary_by_id`;

DELIMITER $$
USE `parks_and_recreation`$$
CREATE PROCEDURE salary_by_id(employee_id_param INT)
BEGIN
	SELECT salary
    FROM employee_salary
    WHERE employee_id = employee_id_param;
END $$

DELIMITER ;

CALL salary_by_id(1)
    



