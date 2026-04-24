Select
    Job_posted_date::DATE as date,
    Job_posted_date::TIME as time,
    Job_posted_date::TIMESTAMP as timestamp,
    Job_posted_date::TIMESTAMPTZ as TIMESTAMPTZ
FROM job_postings_fact
LIMIT 10;
    

-- EXTRACT

Select
    Job_posted_date,
    Extract(year from Job_posted_date) as year,
    EXtract(month from job_posted_date) as month,
    Extract(day from Job_posted_date) as day
FROM job_postings_fact 
Order by random()
limit 10;


SELECT 
    EXtract(year from job_posted_date) as job_posted_year,
    EXTRACT(month from job_posted_date) as job_posted_month,
    count(job_id) as job_count
FROM job_postings_fact
Where job_title_short = 'Data Engineer'
GROUP by 
    Extract(year from job_posted_date),
    Extract(month from job_posted_date)
ORder by 
    job_posted_year,
    job_posted_month;
 


-- TRUNCATE

SELECT
    job_posted_date,
    DATE_TRUNC('month', job_posted_date) as job_posted_month
FROM job_postings_fact
ORDER by random()
LIMIT 10;


SELECT
    job_posted_date,
    DATE_TRUNC('year', job_posted_date) as job_posted_year,
    DATE_TRUNC('quarter', job_posted_date) as job_posted_quarter,
    DATE_TRUNC('month', job_posted_date) as job_posted_month,
    DATE_TRUNC('week', job_posted_date) as job_posted_week,
    DATE_TRUNC('day', job_posted_date) as job_posed_day,
    DATE_TRUNC('hour', job_posted_date) as job_date_hour
FROM job_postings_fact
ORder by random()
LIMIt 10;



SELECT
    Date_trunc('month', job_posted_date) as job_posted_month,
    count(job_id) as job_counts
From job_postings_fact
Where 
    job_title_short = 'Data Engineer' and
    Extract(year from job_posted_date) = 2024
--  DATE_TRUNC('year', job_posted_date) = 2024 (could have used this instead of extarct)
Group by
    Date_trunc('month', job_posted_date)
ORDER BY 
    job_posted_month;


-- At time zone


Select 
    '2026-01-01 00:00:00'::TIMESTAMPTZ at time zone 'UTC';


SELEct
    job_title_short,
    job_location,
    job_posted_date at time zone 'UTC' at time zone 'EST'
FROm job_postings_fact
Where
    job_location like 'New York, NY';




SELEct
    EXTRACT(hour from job_posted_date at time zone 'UTC' at time zone 'EST'),
    count(job_id) aS job_posted_hourly
FROm job_postings_fact
Where
    job_location like 'New York, NY'
GROUP BY
    EXTRACT(hour from job_posted_date at time zone 'UTC' at time zone 'EST')
ORDER BY
    job_posted_hourly;
