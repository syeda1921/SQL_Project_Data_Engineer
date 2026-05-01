-- Step 1: DW - Create star schema tables
drop table if exists skill_job_dim;
drop table if exists job_postings_fact;
drop table if exists company_dim;
drop table if exists skills_dim;


Create table company_dim    (
    company_id  integer     primary key,
    name        varchar
);

create table skills_dim (
    skill_id    integer     primary key,
    skills       varchar,
    type        varchar
);

create table job_postings_fact  (
    job_id          integer     primary key,
    company_id      integer,
    job_title_short varchar,
    job_title       varchar,
    job_location    varchar,
    job_via         varchar,
    job_schedule_type varchar,
    job_work_from_home Boolean,
    search_location varchar, 
    job_posted_date timestamp,
    job_no_degree_mention Boolean,
    job_health_insurance Boolean,
    job_country     varchar,
    salary_rate     varchar,
    salary_year_avg double,
    salary_hour_avg double,  
    foreign key (company_id)  References company_dim(company_id)

);

create table skill_job_dim (
    skill_id Integer,
    job_id integer,
    primary key (skill_id, job_id),
    foreign key (skill_id) references skills_dim(skill_id)

);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'main';