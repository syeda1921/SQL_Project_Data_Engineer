/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/


SELECT
sd.skills,
ROUND(Median(jpf.salary_year_avg), 0) as median_salary,
COUNT(jpf.*) as demands_count,
ROUND(LN(COUNT(jpf.*)), 1) as ln_demands_count,
ROUND((Median(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1000_000, 2) as optimal_score,


FROM job_postings_fact as jpf

inner join skills_job_dim as sjd
on jpf.job_id = sjd.job_id

inner join skills_dim as sd
on sjd.skill_id = sd.skill_id

Where 
jpf.job_title_short = 'Data Engineer'
and jpf.job_work_from_home = TRUE
and jpf.salary_year_avg is not null

group by
sd.skills

having
COUNT(jpf.*) > 100

Order by
optimal_score DESC

LIMIT 20;

/*
KEY takeaways
*/


/*

│   skills   │ median_salary │ … │ ln_demands_count │ 
optimal_score │
│  varchar   │    double     │   │      double      │ 
   double     │
├────────────┼───────────────┼───┼──────────────────┼───────────────┤
│ terraform  │      184000.0 │ … │              5.3 │ 
         0.97 │
│ python     │      135000.0 │ … │              7.0 │ 
         0.95 │
│ aws        │      137320.0 │ … │              6.7 │ 
         0.91 │
│ sql        │      130000.0 │ … │              7.0 │ 
         0.91 │
│ airflow    │      150000.0 │ … │              6.0 │ 
         0.89 │
│ spark      │      140000.0 │ … │              6.2 │ 
         0.87 │
│ snowflake  │      135500.0 │ … │              6.1 │ 
         0.82 │
│ kafka      │      145000.0 │ … │              5.7 │ 
         0.82 │
│ azure      │      128000.0 │ … │              6.2 │ 
         0.79 │
│ java       │      135000.0 │ … │              5.7 │ 
         0.77 │
│ scala      │      137290.0 │ … │              5.5 │ 
         0.76 │
│ kubernetes │      150500.0 │ … │              5.0 │ 
         0.75 │
│ git        │      140000.0 │ … │              5.3 │ 
         0.75 │
│ databricks │      132750.0 │ … │              5.6 │ 
         0.74 │
│ redshift   │      130000.0 │ … │              5.6 │ 
         0.73 │
│ gcp        │      136000.0 │ … │              5.3 │ 
         0.72 │
│ nosql      │      134415.0 │ … │              5.3 │ 
         0.71 │
│ hadoop     │      135000.0 │ … │              5.3 │ 
         0.71 │
│ pyspark    │      140000.0 │ … │              5.0 │ 
          0.7 │
│ mongodb    │      135750.0 │ … │              4.9 │ 
         0.67 │
├────────────┴───────────────┴───┴──────────────────┴───────────────┤
├────────────┴───────────────┴───┴──────────────────┴───────────────┤
├────────────┴───────────────┴───┴──────────────────┴───────────────┤
├────────────┴───────────────┴───┴──────────────────┴───────────────┤
├────────────┴───────────────┴───┴──────────────────┴───────────────┤
│ 20 rows                                       5 columns (4 shown) │
└───────────────────────────────────────────────────────────────────┘


*/