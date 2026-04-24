SELECT unnest([1, 2, 3, 4])
union all
Select unnest([1, 2, 3]);


SELECT unnest([1, 2, 3, 4])
INTersect all
Select unnest([1, 2, 3]);



SELECT unnest([1, 1, 1, 4])
EXCEPT all
Select unnest([1, 1, 2, 3]);


--Practice question

create temp table jobs_2023 as
Select* Exclude (job_id, job_posted_date)
FROM job_postings_fact
Where Extract(year from job_posted_date) = 2023;

SELECT* from jobs_2023;


create temp table jobs_2024 as
Select* Exclude (job_id, job_posted_date)
FROM job_postings_fact
Where Extract(year from job_posted_date) = 2024;

SELECT* from jobs_2024;


--what unique job postings apeared in either 2023 and 2024?

SELECT*
from jobs_2023
union
SELECT*
from jobs_2024;


SELECT 
    'jobs_2023' as table_name,
    count(*) as record
from jobs_2023
union
Select
    'jobs_2024' as table_name,
    count(*) as record
From jobs_2024;


-- which jobs postings apeared across both years, counting duplicates?


SELECT*
from jobs_2023
union all
SELECT*
from jobs_2024;


SELECT 
    'jobs_2023' as table_name,
    count(*) as record
from jobs_2023
union all
Select
    'jobs_2024' as table_name,
    count(*) as record
From jobs_2024;

-- which job postings appeared in 2023 but not in 2024

Select*
from jobs_2023
EXCEPT
Select*
from jobs_2024;


-- which job postings from 2023 remained after subtracting amtching 2024 postings, one-for-one?

Select*
from jobs_2023
EXCEPT all
Select*
from jobs_2024;

-- which job postings apeared in both 2023 adn 2024?

Select*
from jobs_2023
INTERSECT
Select*
from jobs_2024;


-- what job postings appeared in both years, preserving duplication counts?

Select*
from jobs_2023
INTERSECT all
Select*
from jobs_2024;

