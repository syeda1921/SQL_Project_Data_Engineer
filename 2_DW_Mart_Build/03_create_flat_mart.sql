/* 
If you want a separate schema for the flat mart table you can 
type this in the bash terminal
duckdb flat_mart.duckdb -c ".read 03_craete_flat.sql"
*/

-- Step 3: Mart -- Create flat MArt table

Create Schema flat_mart cascade;

Select "=== Flat Mart Sample ===" as info;
Create or replace table flat_mart.job_postings as 
Select 
    jpf.job_id, jpf.company_id, jpf.job_title_short, jpf.job_title, jpf.job_location, jpf.job_via,
    jpf.job_schedule_type, jpf.job_work_from_home, jpf.search_location, jpf.job_posted_date, jpf.job_no_degree_mention, jpf.job_health_insurance, jpf.job_country, jpf.salary_rate, jpf.salary_year_avg, 
    jpf.salary_hour_avg,
    -- Company Dimention table
    cd.company_id,
    cd.name as company_name,
    ARRAY_AGG(
        Struct_pack(
            type := sd.type,
            name := sd.skills
        )
    ) as skills_and_types

From
    job_postings_fact as jpf
LEFT join
    company_dim as cd
    on jpf.company_id = cd.company_id
LEFT join
    skill_job_dim as sjd
    on jpf.job_id = sjd.job_id
Left join
    skills_dim as sd
    on sjd.skill_id = sd.skill_id
Group by All; -- all in group by can Only be used in duckdb other wise palce all selected coloumn from jpf

Select 'Flat Mart Job Postings' as table_name, count(*) as record_count from flat_mart.job_postings;

Select "=== Flat Mart Sample ===" as info;
Select* from flat_mart.job_postings LIMIT 10;

