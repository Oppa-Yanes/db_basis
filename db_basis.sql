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

CREATE TABLE t_plan (
    id UUID PRIMARY KEY,
    plan_date DATE NOT NULL,
	company_id INT4 NOT NULL,
	estate_id INT4 NOT NULL,
	division_id INT4 NOT NULL,
 	foreman_group_id INT4 NOT NULL,
 	foreman_id INT4 NOT NULL,
 	foreman_job_level VARCHAR NOT NULL,
 	foreman_job_name VARCHAR NOT NULL,
    profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_estate FOREIGN KEY (estate_id) REFERENCES m_estate(id),
    CONSTRAINT fk_division FOREIGN KEY (division_id) REFERENCES m_division(id),
    CONSTRAINT fk_foreman_group FOREIGN KEY (foreman_group_id) REFERENCES m_foreman_group(id),
    CONSTRAINT fk_foreman FOREIGN KEY (foreman_id) REFERENCES m_employee(id),
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

