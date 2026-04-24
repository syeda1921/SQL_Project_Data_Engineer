SELECT CHAR_LENGTH('SQL');
SELECT LENGTH('SQL');
SELECT LOWER('SQL');
SELECT UPPER('sql');


-- substring/Extract

SELECT left('SQL', 2);
SELECT substring('SQL', 2, 1); -- (word, start_position, character_extarction_number)


-- Concetenations 

SELECT CONCAT('SQL', '_', 'FUNCTION'); --or
SELECT CONCAT('SQL' || '_' ||  'FUNCTION');

--Trimming_function

SELECT TRIM(' SQL ');
SELECT LTRIM(' SQL');
SELECT RTRIM('SQL ');


-- Replacement

SELECT Replace('SQL', 'Q', '_'); -- (word, replace what chaarcter, Replace woth)


select regexp_replace('name@gmail.com', '^.*(@)', '\1');

--- Final Example - Cleanup this using text Functions

with title_table as (
select
    job_title,
    LOWER(trim(job_title)) as job_title_clean
From job_postings_fact

)

SeLect 
    job_title,
    CASE
        When job_title_clean like '%data%' and job_title_clean like '%analyst%' then 'Data Analyst'
        when job_title_clean like '%data%' and job_title_clean like '%engineer%' then 'Data Engineer'
        when job_title_clean like '%data%' and job_title_clean like '%scientist%' then 'Data Scientist'
        Else 'Other'
        End  as job_category
    From title_table
    Order by random()
    Limit 10;



-- NULL if functiom

select
    MEDIAN(NullIF(salary_year_avg, 0)),
    MEDIAN(NULLIF(salary_hour_avg, 0))
From 
    job_postings_fact
where
    salary_year_avg is not null or salary_hour_avg is not null
LIMIT 10;


-- COALESCE

SELECT COALESCE(1, null, 3);


SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080)
From
    job_postings_fact
where
    salary_hour_avg is not null or salary_year_avg is not null
LIMIT 10;


SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080) as standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) is not null then 'MISSING'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 75000 then 'LOW'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2080) < 150000 then 'HIGH'
        ELSE 'High'
    END as salary_bucket
From job_postings_fact
ORDER by standardized_salary DESC;