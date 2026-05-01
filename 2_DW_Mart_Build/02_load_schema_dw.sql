Select '=== Loading company_dim Table ===' as info;


Insert into company_dim (company_id, name)
Select company_id, name
from read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=True);


Select '=== Loading skills_dim Table ===' as info;

Insert into skills_dim (skill_id, skills, type)
Select skill_id, skills, type
from read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT=TRUE);



Select '=== Loading job_postings_fact Table ===' as info;

Insert into job_postings_fact (job_id, company_id, job_title_short, job_title, job_location, job_via,
    job_schedule_type, job_work_from_home, search_location, job_posted_date, job_no_degree_mention, job_health_insurance, job_country, salary_rate, salary_year_avg, 
    salary_hour_avg)
from read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT=TRUE);



Select '=== Loading job_id Table ===' as info;

select job_id (company_id, job_title_short, job_title, job_location, job_via,
    job_schedule_type, job_work_from_home, search_location, job_posted_date, job_no_degree_mention, job_health_insurance, job_country, salary_rate, salary_year_avg, 
    salary_hour_avg)
from read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT=TRUE);


Select '=== Loading skill_job_dim Table ===' as info;

insert into skill_job_dim (skill_id, job_id)
Select skill_id, job_id
from read_csv ('https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT=TRUE);



Select 'Company dim' as table_name, Count(*) as record_count from company_dim
UNION ALL
Select 'Skills dim', Count(*) from skills_dim
UNION ALL
Select 'Job Postings Fact', Count(*) from job_postings_fact
UNION ALL
Select 'Skills Job Dim', Count(*) from skill_job_dim;




Select '==== Company Dimention Sample ====' as INFO;
Select * from company_dim limit 5;

Select '==== Skills Dim ====' as INFO;
Select * from skills_dim limit 5;

Select '==== Job Postings Fact ====' as INFO;
Select * from job_postings_fact limit 5;

Select '==== Skills Job Dim ====' as INFO;
Select * from skill_job_dim limit 5;