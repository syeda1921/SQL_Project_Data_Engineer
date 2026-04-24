--Subquery
SELECT *
From (
SELECT *
From job_postings_fact
    where salary_year_avg is not null
        or salary_hour_avg is not null
)
LIMIT 10;

--CTE
With valid_salaries as (
    SELECT *
    From job_postings_fact
    where salary_year_avg is not null
        or salary_hour_avg is not null

)

Select *
From valid_salaries;

--Scenerio 1
-- Show each job's salary next to the overall market median
SELECT
job_title_short,
salary_year_avg,(
    Select 
    median(salary_year_avg)
    From job_postings_fact
) as  market_median_salary
From job_postings_fact
Where salary_year_avg is not null
LIMIT 10;

--Scenerio 2
-- Stage only jobs that are remote before aggregation to determien the remote median salary per job
SELECT
job_title_short,
median(salary_year_avg) as median_salary, 
(
    Select 
    median(salary_year_avg) 
    From job_postings_fact
    where job_work_from_home = true
) as  market_remote_median_salary
From (
    Select 
    job_title_short,
    salary_year_avg
    FROM job_postings_fact
    where job_work_from_home = TRUE
) as clean_jobs

Where salary_year_avg is not null
GROUP BY job_title_short
LIMIT 10;


--Scenerio 3
--Keep only job titles whose median salary is above the overal median:

SELECT
job_title_short,
median(salary_year_avg) as median_salary, 
(
    Select 
    median(salary_year_avg) 
    From job_postings_fact
    where job_work_from_home = true
) as  market_remote_median_salary
From (
    Select 
    job_title_short,
    salary_year_avg
    FROM job_postings_fact
    where job_work_from_home = TRUE
) as clean_jobs

GROUP BY job_title_short
HAVING median(salary_year_avg) > (  
        Select 
    median(salary_year_avg) 
    From job_postings_fact
    where job_work_from_home = true
)
LIMIT 10;


-- CTE Example
-- Comapre how much more (or less) remote roles pay comapred to onsite roles for each jobs title.
-- Use a CTE calculate the median salary by titke and work arrangement, then comapre those medians


WITH title_median as (
    SELECT
    job_title_short,
    job_work_from_home,
    MEDIAN(salary_year_avg):: INT as median_salary,
    FROM job_postings_fact
    Where job_country = 'Germany'
    GROUP by
    job_title_short,
    job_work_from_home
)

SELECT
r.job_title_short,
r.median_salary,
o.median_salary,
(r.median_salary - o.median_salary) as comparative_Salary_diff
From title_median as r
inner join title_median as o
on r.job_title_short = o.job_title_short
WHERE r.job_work_from_home = true
and o.job_work_from_home = false;


-- exits not exists example
SELECT *
From range(3) as src(key);


SELECT *
From range(2) as tgt(key);



SELECT *
From range(3) as src(key)
where not EXISTS (
    SELECT 1
    FROM range(2) as tgt(key)
    where src.key = tgt.key
);

--final example
--identity job postings that have no accociated skills brfore loading them into a data mart
SELECt*
From job_postings_fact 
order by job_id
LIMIT 10;


SELECt*
From skills_job_dim 
order by job_id
LIMIT 40;


SELECt*
From job_postings_fact  as tgt
where not exists (
    SELECT*
    From skills_job_dim as src
    where tgt.job_id = src.job_id
)
order by job_id;
