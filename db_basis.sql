-- CREATE ACCESS TO ODOO GBS_PRD

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

DROP SERVER IF EXISTS db_master_server CASCADE;
CREATE SERVER db_master_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (
    host 'localhost',
    dbname 'DB_MASTER',
    port '5432'
);

CREATE USER MAPPING FOR CURRENT_USER
SERVER db_master_server
OPTIONS (
    user 'postgres',	-- user di DB_MASTER
    password 'gbsselaludihati'	-- password user di DB_MASTER
);

IMPORT FOREIGN SCHEMA public
FROM SERVER db_master_server
INTO public;

-- MAIN TABLES

CREATE TABLE m_profile (
	id UUID PRIMARY KEY,
	emp_id INT4 NOT NULL,
	nip VARCHAR NOT NULL,
	name VARCHAR NOT NULL,
	company_id INT4,
	estate_id INT4,
	division_id INT4,
	job_level_id INT4,
	access_level CHAR NOT NULL,
	device_id VARCHAR, 
	device_model VARCHAR,
	last_version VARCHAR, 
	last_update TIMESTAMP,
	last_sync TIMESTAMP,
	is_disabled BOOLEAN DEFAULT FALSE,
	create_by VARCHAR,
	create_date TIMESTAMP,
	write_by VARCHAR,
	write_date TIMESTAMP    
);

CREATE TABLE t_rkh (
    id UUID PRIMARY KEY,
    rkh_date DATE NOT NULL,
	company_id INT4 NOT NULL,
	estate_id INT4 NOT NULL,
	division_id INT4 NOT NULL,
 	foreman_group_id INT4 NOT NULL,
	foreman_group_name VARCHAR,
 	foreman_id INT4 NOT NULL,
	foreman_nip VARCHAR NOT NULL,
	foreman_name VARCHAR NOT NULL,
	foreman_job_level_id INT4 NOT NULL,
 	foreman_job_level_name VARCHAR NOT NULL,
	foreman_job_id INT4 NOT NULL,
 	foreman_job_name VARCHAR NOT NULL,
    profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

CREATE TABLE t_rkh_member (
    id UUID PRIMARY KEY,
	rkh_id UUID NOT NULL,
	emp_id INT4 NOT NULL,
	nip VARCHAR NOT NULL,
	name VARCHAR NOT NULL,
	job_level_id INT4 NOT NULL,
 	job_level_name VARCHAR,
	job_id INT4 NOT NULL,
 	job_name VARCHAR,
    profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_rkh FOREIGN KEY (rkh_id) REFERENCES t_rkh(id),
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

CREATE TABLE t_rkh_location (
    id UUID PRIMARY KEY,
	rkh_id UUID NOT NULL,
	block_id INT4 NOT NULL,
	block_code VARCHAR NOT NULL,
	akp
	taksasi
    profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_rkh FOREIGN KEY (rkh_id) REFERENCES t_rkh(id),
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);


