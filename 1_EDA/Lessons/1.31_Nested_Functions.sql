-- Array Intro

Select ['python', 'sql', 'r'] as skills_array;

With skills as (
    Select 'python' as skill
    UNION ALL 
    Select 'sql'
    UNION ALL
    Select 'r'
), skills_array as (
    select array_agg(skill order by skill) as skills
    from skills
)
Select 
    skills[1] as first_skill
from skills_array;

-- STRUCT

Select {};


with skill_table as (
    Select 
    'python' as skills, 'programming' as types
    UNIOn all
    Select 'sql', 'querry_languge'
    UNION all
    Select 'r', 'programming'
) 
Select 
    struct_pack(
        skill:= skills,
        type:= types
    )
From skill_table;


-- Aray of structs

Select [
    {skills: 'python' , type: 'programming'},
    {skills: 'sql' , type: 'query_language'}
] as skills_array_of_structs;



-- Array of structs example 


with skill_table as (
    Select 
    'python' as skills, 'programming' as types
    UNIOn all
    Select 'sql', 'querry_languge'
    UNION all
    Select 'r', 'programming'
), skills_array_struct as (
Select 
    array_agg(
        struct_pack(
            skill:= skills,
            type:= types
        )
    ) as array_struct
From skill_table
)
Select
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
from skills_array_struct;


--map
-- 11:19

-- json

with raw_skills_json as (
    select
    '{"skills":"python", "type":"programming"}' ::json as skill_json
)
Select 
    struct_pack(
        skill := json_extract_string(skill_json, '$.skill'),
        type:= json_extract_string(skill_json, '$.type')
    )
From 
raw_skills_json;



-- json to array of struct

with raw_json as (
    select
    '[
    {"skills":"python", "type":"programming"},
    {"skills":"sql", "type":"querry_languge"},
    {"skills":"r", "type":"programming"}    
    ]' ::json as skills_json
)
Select 
    array_agg(
    struct_pack(
        skill := json_extract_string(e.value, '$.skills'),
        type:= json_extract_string(e.value, '$.type')
    )
    order by json_extract_string(e.value, '$.skill')
    ) as skills
From 
raw_json, json_each(skills_json) as e;


-- Array Final Example
-- Build a flat skill table for co_workers to acess job titles, salary info, and skills in one table


CREATE OR REPLACE TEMP table job_skills_array as 
Select
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) as skills_array
From job_postings_fact as jpf
LEft JOIN skills_job_dim as sj
        on jpf.job_id = sj.job_id
LEFT join skills_dim as sd
        on sd.skill_id = sj.skill_id
GROUP by all;

Select 
job_title_short
from job_skills_array;


-- From the presective of data analyst , analyze the median salary per skills

with flat_skill as (
    Select 
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) as skill
    From 
        job_skills_array
)
Select
    skill,
    MEDIAN(salary_year_avg) as median_salary
From flat_skill
GROUP by skill
ORDER BY median_salary DESC;


-- ARRAY of structs - FInal Example
-- Build a falt skill & type table for co-workers to access job titles, salary info, skills, and type in one table

CREATE OR REPLACE TEMP table job_skills_array_struct as 
Select
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        struct_pack(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) as skills_type
From job_postings_fact as jpf
LEft JOIN skills_job_dim as sj
        on jpf.job_id = sj.job_id
LEFT join skills_dim as sd
        on sd.skill_id = sj.skill_id
GROUP by all;


-- FRom the prespective of a data analyst, analyze the median salary per type of skill 


with flat_skill as (
    Select
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type as skill_type,
        UNNEST(skills_type).skill_name as skill_name
    FRom
        job_skills_array_struct
)
Select
    skill_type,
    MEDIAN(salary_year_avg) as median_salary
From flat_skill
GROUP by skill_type;