-- Create a temp table
Create or replace temp table src_priority_jobs as
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name as company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP as updated_at
FROM
    data_jobs.job_postings_fact  as jpf  
LEFT JOIN data_jobs.company_dim  as cd
    on jpf.company_id = cd.company_id
INNER JOIN staging.priority_roles as r
    on jpf.job_title_short = r.role_name;

-- -- uodate statement
-- update main.priority_jobs_snapshot as tgt
-- SET
--     priority_lvl = src.priority_lvl,
--     updated_at = src.updated_at
-- from src_priority_jobs as src
-- where tgt.job_id = src.job_id
--     and tgt.priority_lvl is distinct from src.priority_lvl; -- row by row comapre if someting changed?

-- -- Insert Statement


-- insert into main.priority_jobs_snapshot (
--     job_id,
--     job_title_short,
--     company_name,
--     job_posted_date,
--     salary_year_avg,
--     priority_lvl,
--     updated_at
-- )
-- SELECT
--     src.job_id,
--     src.job_title_short,
--     src.company_name,
--     src.job_posted_date,
--     src.salary_year_avg,
--     src.priority_lvl,
--     src.updated_at
-- from src_priority_jobs as src
-- where not exists (
--     Select 1
--     from main.priority_jobs_snapshot as tgt
--     where tgt.job_id = src.job_id
-- );

-- -- DELETE Satemnet
-- DELETE FROM main.priority_jobs_snapshot as tgt
-- where not exists (
--     SELECT 1
--     From src_priority_jobs as src
--     where tgt.job_id = src.job_id
-- );

-- MERGE INTO

MERGE INTO main.priority_jobs_snapshot as tgt
USING src_priority_jobs as src
on tgt.job_id = src.job_id

WHEN MATCHED And tgt.priority_lvl is distinct from src.priority_lvl then
    update SET
    priority_lvl = src.priority_lvl,
    updated_at = src.updated_at
WHEN NOT MATCHED then
 insert (
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
values (
    src.job_id,
    src.job_title_short,
    src.company_name,
    src.job_posted_date,
    src.salary_year_avg,
    src.priority_lvl,
    src.updated_at
)

WHEN NOT MATCHED BY SOURCE THEN DELETE;

-- Final Check querry
SELECT
    job_title_short,
    COUNT(*) as job_count,
    MIN(priority_lvl) as priority_lvl,
    MIN(updated_at) as updated_at
FROM priority_jobs_snapshot 
GROUP BY job_title_short
ORDER BY job_count DESC;


     