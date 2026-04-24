CREATE or replace Table staging.job_postings_flat as 
SELECT
jpf.job_id,
jpf.job_title_short,
jpf.job_title,
jpf.job_location,
jpf.job_via,
jpf.job_schedule_type,
jpf.job_work_from_home,
jpf.search_location,
jpf.job_posted_date,
jpf.job_no_degree_mention,
jpf.job_health_insurance,
jpf.job_country,
jpf.salary_rate,
jpf.salary_year_avg,
jpf.salary_hour_avg,
cd.name as company_name
FROM
    data_jobs.job_postings_fact as jpf
Left join data_jobs.company_dim as cd
on jpf.company_id = cd.company_id;


Create or replace Table staging.priority_job_flat_view as
SELECT
    jpf.*
FROM staging.job_postings_flat as jpf
JOIN staging.priority_roles as r
ON jpf.job_title_short = r.role_name
where r.priority_lvl = 1;

SELECT 
job_title_short,
count(*) as job_count
from staging.priority_job_flat_view
GROUP BY job_title_short
Order by job_count desc;

Create OR REPLACE TEMPOrary table senior_jobs_flat_temp as 
SELECT *
FROM staging.priority_job_flat_view
WHERE job_title_short = 'Senior Data Scientist';

SELECT 
job_title_short,
count(*) as job_count
from senior_jobs_flat_temp
GROUP BY job_title_short
Order by job_count desc;

SELECT COUNT(*) from staging.job_postings_flat;
SELECT COUNT(*) from staging.priority_job_flat_view;
SELECT COUNT(*) from senior_jobs_flat_temp;

DELETE FROM staging.job_postings_flat
Where job_posted_date < '2024-01-01';

SELECT COUNT(*) 
from staging.job_postings_flat;
SELECT COUNT(*) from staging.priority_job_flat_view;
SELECT COUNT(*) from senior_jobs_flat_temp;

TRUNCATE TABLE staging.job_postings_flat;

SELECT
jpf.job_id,
jpf.job_title_short,
jpf.job_title,
jpf.job_location,
jpf.job_via,
jpf.job_schedule_type,
jpf.job_work_from_home,
jpf.search_location,
jpf.job_posted_date,
jpf.job_no_degree_mention,
jpf.job_health_insurance,
jpf.job_country,
jpf.salary_rate,
jpf.salary_year_avg,
jpf.salary_hour_avg,
cd.name as company_name
FROM
    data_jobs.job_postings_fact as jpf
Left join data_jobs.company_dim as cd
on jpf.company_id = cd.company_id
where job_posted_date >= '2024-01-01';

