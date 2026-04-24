SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
FROM
    job_postings_fact as jpf
FULL OUTER JOIN company_dim as cd
    on jpf.company_id = cd.company_id
LIMIT 10;

SELECT*
FROM skills_dim
LIMIT 10;

-----------------

SELECT
jpf.job_id,
jpf.job_title_short,
sjd.skill_id,
sd.skills

FROM job_postings_fact as jpf

LEFT JOIN skills_job_dim as sjd
on jpf.job_id = sjd.job_id

LEFT JOIN skills_dim as sd
on sjd.skill_id = sd.skill_id

LIMIT 10;


------------

SELECT
jpf.job_id,
jpf.job_title_short,
sjd.skill_id,
sd.skills

FROM job_postings_fact as jpf

INNER JOIN skills_job_dim as sjd
on jpf.job_id = sjd.job_id

INNER JOIN skills_dim as sd
on sjd.skill_id = sd.skill_id

LIMIT 10;

-------------------------

SELECT
jpf.job_id,
jpf.job_title_short,
sjd.skill_id,
sd.skills

FROM job_postings_fact as jpf

INNER JOIN skills_job_dim as sjd
on jpf.job_id = sjd.job_id

INNER JOIN skills_dim as sd
on sjd.skill_id = sd.skill_id

LIMIT 10;

----------------------

SELECT
jpf.job_id,
jpf.job_title_short,
sjd.skill_id,
sd.skills

FROM job_postings_fact as jpf

FULL OUTER JOIN skills_job_dim as sjd
on jpf.job_id = sjd.job_id

FULL OUTER JOIN skills_dim as sd
on sjd.skill_id = sd.skill_id;

--------------------

/* Find teh top 10 companies for posting jobs.
They my have >3000 postings
Limit this to only US jobs
*/

SELECT

cd.name as company_name,
COUNT(jpf.*) as posting_counts

from job_postings_fact as jpf

LEFT join company_dim as cd
on jpf.company_id = cd.company_id
where jpf.job_country = 'United States' 
GROUP by cd.name
having COUNT(jpf.job_id) > 3000
ORDER BY posting_counts DESC
LIMIT 10;


