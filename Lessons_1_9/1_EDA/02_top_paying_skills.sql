/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/

 /*Keytake aways

 */


SELECT
sd.skills,
Round(MEDIAN(jpf.salary_year_avg), 0) as Median_salary,
COUNT(jpf.*) as demands_count

FROM job_postings_fact as jpf

Inner JOIN skills_job_dim as sjd
on jpf.job_id = sjd.job_id

Inner JOIN skills_dim as sd
on sjd.skill_id = sd.skill_id

where
jpf.job_location = 'United States'
and jpf.job_title_short = 'Data Analyst'

GROUP BY
sd.skills

HAVING
COUNT(jpf.*) > 100


ORDER BY Median_salary DESC


LIMIT 10;


/*

┌──────────┬───────────────┬───────────────┐
│  skills  │ Median_salary │ demands_count │
│ varchar  │    double     │     int64     │
├──────────┼───────────────┼───────────────┤
│ python   │      100000.0 │           215 │
│ r        │       94750.0 │           132 │
│ power bi │       89750.0 │           109 │
│ tableau  │       89500.0 │           158 │
│ sql      │       89500.0 │           249 │
│ excel    │       88602.0 │           168 │
└──────────┴───────────────┴───────────────┘
*/