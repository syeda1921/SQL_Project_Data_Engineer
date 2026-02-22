/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings
- Why? Retrieves the top 10 skills with the highest demand in the remote job market,
    providing insights into the most valuable skills for data engineers seeking remote work
*/

/*
KEY TAKEAWAYS

*/

SELECT
sd.skills,
COUNT(jpf.*) as demanded_counts,

FROM job_postings_fact as jpf

INNER JOIN skills_job_dim as sjd
on jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
on sjd.skill_id = sd.skill_id

where
jpf.job_title_short = 'Data Engineer'
and jpf.job_work_from_home = TRUE

GROUP BY 
sd.skills

ORDER by demanded_counts DESC

LIMIT 10;

/*
┌────────────┬─────────────────┐
│   skills   │ demanded_counts │
│  varchar   │      int64      │
├────────────┼─────────────────┤
│ sql        │           29221 │
│ python     │           28776 │
│ aws        │           17823 │
│ azure      │           14143 │
│ spark      │           12799 │
│ airflow    │            9996 │
│ snowflake  │            8639 │
│ databricks │            8183 │
│ java       │            7267 │
│ gcp        │            6446 │
├────────────┴─────────────────┤
│ 10 rows            2 columns │
└──────────────────────────────┘
*/




