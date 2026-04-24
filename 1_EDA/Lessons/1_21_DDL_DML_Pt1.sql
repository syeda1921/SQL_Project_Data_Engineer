.read 1_EDA\Lessons\1_21_DDL_DML_Pt1.sql


USE data_jobs;

DROP DATABASE if exists jobs_mart;

CREATE DATABASE if not exists jobs_mart;

USE jobs_mart; 

SHOW DATABASES;

SELECT*
FROM information_schema.schemata;


DROP SCHEMA if exists staging;

CREATE SCHEMA if not EXISTS staging;

DROP TABLE IF EXISTS staging.preferred_role;

SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';


CREATE TABLE if NOT EXISTS staging.preferred_role (
    role_id INTEGER PRIMARY KEY,
    role_name Varchar
);


Insert INTO staging.preferred_role (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Data Analyst'),
    (3, 'Data Science');

SELECT *
FROM staging.preferred_role;

ALTER Table staging.preferred_role
ADD COLUMN preferred_roles BOOLEAN;

--ALTER Table staging.preferred_role
--DROP COLUMN preferred_role;

UPDATE staging.preferred_role
SET preferred_roles = FALSE
WHERE role_id= 1 or role_id=2;


UPDATE staging.preferred_role
SET preferred_roles = FALSE
WHERE role_id= 3;

Alter table staging.preferred_role
RENAME to priority_roles;

Select*
from staging.priority_roles;

Alter table staging.priority_roles
RENAME Column preferred_roles to priority_lvl;

ALTER TAble staging.priority_roles
ALTER Column priority_lvl type INTEGER;

UPDATE staging.priority_roles
set priority_lvl = 3
Where role_id = 3;