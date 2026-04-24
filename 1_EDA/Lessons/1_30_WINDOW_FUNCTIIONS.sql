---COUNT ROws  -- Aggregration only
SELECT 
    COUNT(*)
FROM job_postings_fact


-- COUNT ROWS --- Window Function
SeLect
    job_id,
    count(*) OVER()
FROM
    job_postings_fact;


-- Partition by -- find hourly salary
SeLect
    job_id,
    job_title_short,
    salary_hour_avg,
    avg(salary_hour_avg) over (
        partition by job_title_short, company_id
    )
from job_postings_fact
Where 
    salary_hour_avg is not null
order by
    random()
LIMit 10;


-- order by -- ranking hour salary

SeLect
    job_id,
    job_title_short,
    salary_hour_avg,
    rank() over (
        order by salary_hour_avg desc
    ) as rank_hourly_salary
from
    job_postings_fact
Where
    salary_hour_avg is not null
order by 
    salary_hour_avg DESC
Limit 10;



-- partition by & Order by -- Running avg hourly salary

SeLect
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) over(
        partition by job_title_short
        order by job_posted_date
    ) as running_hourly_saalry
from
    job_postings_fact
Where
    salary_hour_avg is not null
order by
    job_title_short,
    job_posted_date
Limit 10;


-- Partition by & order by -- ranking by job_title_short


SeLect
    job_id,
    job_title_short,
    salary_hour_avg,
    rank() over(
        partition by job_title_short
        order by salary_hour_avg DESC

    ) as rank_hourly_salary
from
    job_postings_fact
Where
    salary_hour_avg is not null
order by 
    salary_hour_avg
Limit 10;



-- ranking Function -- RANK() vs DENSE_RANK

SeLect
    job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_rank() over (
        order by salary_hour_avg desc
    ) as rank_hourly_salary
from
    job_postings_fact
Where
    salary_hour_avg is not null
order by 
    rank_hourly_salary DESC
Limit 140;




-- Row Function -- providing a new job_id

SeLect
    *,
    row_number() over(
        Order by job_posted_date
    ) as new_job_id
FROm 
    job_postings_fact
ORDER by job_posted_date
LIMIT 20;

--- ANOTHER EXAMPLE ROW NUMBER FUNCTION

SeLect
    job_id,
    job_title_short,
    salary_hour_avg,
    row_number() over (
        order by salary_hour_avg desc
    ) as rank_hourly_salary
from
    job_postings_fact
Where
    salary_hour_avg is not null
order by 
    salary_hour_avg DESC
Limit 140;



--- LAG() - Time based comparison of company yearly salary

SELECT
    job_id,
    company_id,
    job_title,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) over (
        PARTITION by company_id
        order by job_posted_date
    ) as previous_posting_salary,
    salary_year_avg -     LAG(salary_year_avg) over (
        PARTITION by company_id
        order by job_posted_date
    ) as salary_change -- this is simply gonna give you the value assigned on a previous date for example today's value will be replaced with what was yesturday's value
from
    job_postings_fact
Where
    salary_year_avg is not null
order by 
    job_posted_date
LIMIT 60;

/* important note lag and lead both give previous or next value 
based on the time interval in your date coloumn like if it has
 an yearly or monthly order interval it means previous salary will
  be an year old and vice versa */




-- LEAD() - Time based comparison of company yearly salary opposite to LAG() this show the upcoming date value 
-- todays date will have the tomorrow's value 