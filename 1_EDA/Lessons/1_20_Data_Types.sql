SELECT
table_name,
column_name,
data_type
FROM
information_schema.columns;
WHERE
table_name = 'job_postings_fact';

DESCRIBE job_postings_fact;

SELECT
CAST(job_id as varchar), 
CAST(company_id as varchar)
from 
job_postings_fact
WHERE
salary_year_avg is not null
limit 10;

SELECT
job_id::varchar || '-' || company_id::varchar as unique_id
from job_postings_fact
WHERE
salary_year_avg is not null
limit 10;