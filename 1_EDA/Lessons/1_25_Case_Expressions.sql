-- CAtagorizing catagorical values Values
-- Classifying the 'job_title' column values as:
-- 'Data Analyst'
-- 'Data Engineer'
-- 'Data Scientist'

Select
    job_title,
    CASE
        When job_title LIKE '%Data%' and job_title LIKE '%Analyst%' then 'Data Analyst'
        When job_title LIKE '%Data%' and job_title LIKE '%Engineer%' then 'Data Engineer'
        When job_title LIKE '%Data%' and job_title LIKE '%Scientist%' then 'Data Scientist'
        ELSE 'Other'
    END as job_title_caatgory,
    job_title_short
FROM job_postings_fact
Order by RANDOM()
LIMIT 20;



-- Conditional Agggregation 
-- Calculate median SAalries for  Different Buckets
        -- < $100K
        -- >= $100K

Select
    job_title_short,
    COUNT(8) as total_postings,
    median (
        CASE
            When salary_year_avg < 100_000 then salary_year_avg
            END
         ) as  median_low_salary,
    median (
        CASE
            when salary_year_avg >= 100_000 then salary_year_avg
            END
         ) as median_high_salary
FROM job_postings_fact
where salary_year_avg is not null
group by job_title_short;


-- Final EXAM
-- Compute a standardized_salary using yearly salary and adjusted hourly salary (e.g. 2080 hours/year)
-- Categorize salary into tiers of: 
    -- < 75K 'low'
    -- 75K - 150K 'Medium'
    -- >= 150K 'High'



    WITH salaries as (
        Select
            job_title_short,
            salary_year_avg,
            salary_hour_avg,
            CASE
                when salary_year_avg is not null then salary_year_avg
                when salary_hour_avg is not null then salary_hour_avg*2080
            END as standardized_salary
        From job_postings_fact
        where salary_year_avg is not null or salary_hour_avg is not null
    )  
    
Select 
    *,
    CASE
        when standardized_salary is null then 'Missing'
        when standardized_salary < 75000 then 'low'
        when standardized_salary < 150_000 then 'Medium'
        ELSE 'High'
    END as salary_bucket
FROM salaries
LIMIT 10;

