DROP TABLE IF EXISTS m_foreman_group;
DROP TABLE IF EXISTS m_employee;
DROP TABLE IF EXISTS m_tph;
DROP TABLE IF EXISTS m_block;
DROP TABLE IF EXISTS m_department;
DROP TABLE IF EXISTS m_division;
DROP TABLE IF EXISTS m_estate;
DROP TABLE IF EXISTS m_operating_unit;
DROP TABLE IF EXISTS m_company;

CREATE TABLE m_company (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL UNIQUE,
    init VARCHAR,
    name VARCHAR NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP
);

CREATE TABLE m_operating_unit (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    company_id INT4 NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id)
);

CREATE TABLE m_estate (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    mark VARCHAR,
    is_pabrik BOOLEAN DEFAULT FALSE,
    is_nursery BOOLEAN DEFAULT FALSE,
    operating_unit_id INT4 NOT NULL,
    company_id INT4 NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id) 
);

CREATE TABLE m_division (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    mark VARCHAR,
    operating_unit_id INT4 NOT NULL,
    company_id INT4 NOT NULL,
    estate_id INT4 NOT NULL,
    parent_id INT4,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_estate FOREIGN KEY (estate_id) REFERENCES m_estate(id),
    CONSTRAINT fk_parent FOREIGN KEY (parent_id) REFERENCES m_division(id)
);

CREATE TABLE m_department (
    id SERIAL PRIMARY KEY,
    code VARCHAR,
    name VARCHAR NOT NULL,
    complete_name VARCHAR NOT NULL,
    operating_unit_id INT4,
    company_id INT4 NOT NULL,
    parent_id INT4,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_parent FOREIGN KEY (parent_id) REFERENCES m_department(id)
);

CREATE TABLE m_block (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL UNIQUE,
    code2 VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    topograph VARCHAR,
    soil VARCHAR,
    is_plasma BOOLEAN DEFAULT FALSE,
    plasma_owner VARCHAR,
    area_coefficient FLOAT8,
    block_area FLOAT8,
    planted_area FLOAT8,
    plant_total INT4,
    maturate_time INT4,
    planted_date DATE,
    mature_date DATE,
    mature_age INT4,
    immature_age INT4,
    is_dummmy BOOLEAN DEFAULT FALSE,    
    operating_unit_id INT4 NOT NULL,
    company_id INT4 NOT NULL,
    estate_id INT4 NOT NULL,
    division_id INT4 NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_estate FOREIGN KEY (estate_id) REFERENCES m_estate(id),
    CONSTRAINT fk_division FOREIGN KEY (division_id) REFERENCES m_division(id)
);

CREATE TABLE m_tph (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    lat FLOAT NOT NULL DEFAULT 0.0,
    long FLOAT NOT NULL DEFAULT 0.0,
    lat_adj INT NOT NULL DEFAULT 0,
	long_adj INT NOT NULL DEFAULT 0,
    operating_unit_id INT4 NOT NULL,
    company_id INT4 NOT NULL,
    estate_id INT4 NOT NULL,
    division_id INT4 NOT NULL,
    block_id INT4 NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_estate FOREIGN KEY (estate_id) REFERENCES m_estate(id),
    CONSTRAINT fk_division FOREIGN KEY (division_id) REFERENCES m_division(id),
    CONSTRAINT fk_block FOREIGN KEY (block_id) REFERENCES m_block(id)    
);


CREATE TABLE m_employee (
	id SERIAL PRIMARY KEY,
	nip VARCHAR NOT NULL,
	name VARCHAR NOT NULL,
	operating_unit_id INT4,
	company_id INT4 NOT NULL,
	estate_id INT4,
	division_id INT4,
	department_id INT4 NOT NULL,
	foreman_group_id INT4,
	foreman_id INT4,
	job_level_id INT4,
	job_level VARCHAR,
	job_id INT4 NOT NULL,
	job_name VARCHAR NOT NULL,
	type_id INT4 NOT NULL,
	type_name VARCHAR NOT NULL,
	status_id INT4 NOT NULL,
	job_status VARCHAR NOT NULL,
	fp_id INT4,
	gender VARCHAR,
	birthday DATE,
	id_number VARCHAR,
	work_date_start DATE,
	work_duration VARCHAR NOT NULL,
	contract_start DATE,
	contract_end DATE,
	contract_state VARCHAR,
	hr_transition VARCHAR,
	is_disabled BOOLEAN DEFAULT FALSE,
	create_by VARCHAR,
	create_date TIMESTAMP,
	write_by VARCHAR,
	write_date TIMESTAMP,
    
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_estate FOREIGN KEY (estate_id) REFERENCES m_estate(id),
    CONSTRAINT fk_division FOREIGN KEY (division_id) REFERENCES m_division(id),
    CONSTRAINT fk_department FOREIGN KEY (department_id) REFERENCES m_department(id)    
);

CREATE TABLE m_foreman_group (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    type VARCHAR NOT NULL,
    foreman_id INT4,
    foreman1_id INT4,
    kerani_id INT4,
    kerani1_id INT4,
    kerani_panen_id INT4,
    operating_unit_id INT4 NOT NULL,
    company_id INT4 NOT NULL,
    division_id INT4 NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_division FOREIGN KEY (division_id) REFERENCES m_division(id),
    CONSTRAINT fk_foreman FOREIGN KEY (foreman_id) REFERENCES m_employee(id),
    CONSTRAINT fk_foreman1 FOREIGN KEY (foreman1_id) REFERENCES m_employee(id),
    CONSTRAINT fk_kerani FOREIGN KEY (kerani_id) REFERENCES m_employee(id),
    CONSTRAINT fk_kerani1 FOREIGN KEY (kerani1_id) REFERENCES m_employee(id),
    CONSTRAINT fk_kerani_panen FOREIGN KEY (kerani_panen_id) REFERENCES m_employee(id)
);

-- CREATE ACCESS TO ODOO DB

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

DROP SERVER IF EXISTS gbs_prd_server CASCADE;
CREATE SERVER gbs_prd_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (
    host 'localhost',
    dbname 'GBS_PRD',
    port '5432'
);

CREATE USER MAPPING FOR CURRENT_USER
SERVER gbs_prd_server
OPTIONS (
    user 'postgres',        -- user di GBS_PRD
    password 'gbsselaludihati' -- password user di GBS_PRD
);

IMPORT FOREIGN SCHEMA public
FROM SERVER gbs_prd_server
INTO public;

-- IMPORT ODOO

-- company
UPDATE m_company SET is_disabled = TRUE;
INSERT INTO m_company (id, code, name, init, is_disabled, create_by, create_date, write_by, write_date)
SELECT a.id, a.code, a.name, NULL, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    res_company a
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
ON CONFLICT (id) DO UPDATE
SET
    code = EXCLUDED.code,
    name = EXCLUDED.name,
    init = EXCLUDED.init,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;
UPDATE m_company SET init = 'GBS' WHERE id = 1;
UPDATE m_company SET init = 'LKK' WHERE id = 2;

-- operating_unit
UPDATE m_operating_unit SET is_disabled = TRUE;
INSERT INTO m_operating_unit (id, code, name, company_id, is_disabled, create_by, create_date, write_by, write_date)
SELECT a.id, a.code, a.name, a.company_id, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    operating_unit a
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
WHERE a.active
ON CONFLICT (id) DO UPDATE
SET
    code = EXCLUDED.code,
    name = EXCLUDED.name,
    company_id = EXCLUDED.company_id,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;

-- estate
UPDATE m_estate SET is_disabled = TRUE;
INSERT INTO m_estate (id, code, name, mark, is_pabrik, is_nursery, operating_unit_id, company_id, is_disabled, create_by, create_date, write_by, write_date)
SELECT a.id, a.code, a.name, a.mark, COALESCE(a.is_pabrik,FALSE), COALESCE(a.is_nursery,FALSE), a.operating_unit_id, a.company_id, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    plantation_estate a
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
WHERE a.active
ON CONFLICT (id) DO UPDATE
SET
    code = EXCLUDED.code,
    name = EXCLUDED.name,
    mark = EXCLUDED.mark,
    is_pabrik = EXCLUDED.is_pabrik,
    is_nursery = EXCLUDED.is_nursery,
    operating_unit_id = EXCLUDED.operating_unit_id,
    company_id = EXCLUDED.company_id,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;

-- divisi
UPDATE m_division SET is_disabled = TRUE;
INSERT INTO m_division (id, code, name, mark, operating_unit_id, company_id, estate_id, parent_id, is_disabled, create_by, create_date, write_by, write_date)
SELECT a.id, a.code, a.name, a.mark, a.operating_unit_id, a.company_id, a.estate_id, a.parent_division_id, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    plantation_division a
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
WHERE a.active AND a.is_office = FALSE 
ON CONFLICT (id) DO UPDATE
SET
    code = EXCLUDED.code,
    name = EXCLUDED.name,
    mark = EXCLUDED.mark,
    operating_unit_id = EXCLUDED.operating_unit_id,
    company_id = EXCLUDED.company_id,
    estate_id = EXCLUDED.estate_id,
    parent_id = EXCLUDED.parent_id,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;

-- block
UPDATE m_block SET is_disabled = TRUE;
INSERT INTO m_block (
	id,code,code2,name,topograph,soil,is_plasma,plasma_owner,area_coefficient,block_area,planted_area,
	plant_total,maturate_time,planted_date,mature_date,mature_age,immature_age,is_dummmy,operating_unit_id,
	company_id,estate_id,division_id,is_disabled,create_by,create_date,write_by,write_date
)
SELECT 
	a.id, a.code, b.code, a.name, c.name, d.name, COALESCE(a.block_plasma,FALSE), e.name, a.area_coefficient, b.block_area, a.planted_area,
	a.plant_total,a.maturate_time_norm,a.planted_date,a.mature_date,a.plant_mature_age,a.plant_immature_age,a.is_dummy,a.operating_unit_id,
	a.company_id, a.estate_id, a.division_id, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    plantation_land_planted a
    LEFT JOIN plantation_land_block b ON b.id = a.block_id
    LEFT JOIN plantation_land_topograph c ON c.id = b.topograph_id
    LEFT JOIN plantation_land_soil d ON d.id = b.soil_id
    LEFT JOIN res_partner e ON e.id = a.owner_plasma_id
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
WHERE a.active 
ON CONFLICT (id) DO UPDATE
SET
	code = EXCLUDED.code,
    code2 = EXCLUDED.code2,
    name = EXCLUDED.name,
    topograph = EXCLUDED.topograph,
    soil = EXCLUDED.soil,
    is_plasma = EXCLUDED.is_plasma,
    plasma_owner = EXCLUDED.plasma_owner,
    area_coefficient = EXCLUDED.area_coefficient,
    block_area = EXCLUDED.block_area,
    planted_area = EXCLUDED.planted_area,
    plant_total = EXCLUDED.plant_total,
    maturate_time = EXCLUDED.maturate_time,
    planted_date = EXCLUDED.planted_date,
    mature_date = EXCLUDED.mature_date,
    mature_age = EXCLUDED.mature_age,
    immature_age = EXCLUDED.immature_age,
    is_dummmy = EXCLUDED.is_dummmy,
    operating_unit_id = EXCLUDED.operating_unit_id,
    company_id = EXCLUDED.company_id,
    estate_id = EXCLUDED.estate_id,
    division_id = EXCLUDED.division_id,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;

-- tph
UPDATE m_tph SET is_disabled = TRUE;
INSERT INTO m_tph (id,code,name,lat,long,lat_adj,long_adj,operating_unit_id,company_id,estate_id,division_id,block_id,is_disabled,create_by,create_date,write_by,write_date)
SELECT 
	a.id,REPLACE(a.name,' ',''),REPLACE(a.name,' ',''),0,0,0,0,a.operating_unit_id,a.company_id, b.estate_id, b.division_id, a.planted_block_id, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    plantation_harvest_staging a
    LEFT JOIN plantation_land_planted b ON b.id = a.planted_block_id
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
WHERE a.active AND a.planted_block_id IS NOT NULL
ON CONFLICT (id) DO UPDATE
SET
	code = EXCLUDED.code,
    name = EXCLUDED.name,
    lat = EXCLUDED.lat,
    long = EXCLUDED.long,
    operating_unit_id = EXCLUDED.operating_unit_id,
    company_id = EXCLUDED.company_id,
    estate_id = EXCLUDED.estate_id,
    division_id = EXCLUDED.division_id,
    block_id = EXCLUDED.block_id,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;

-- department
UPDATE m_department SET is_disabled = TRUE;
INSERT INTO m_department (id, code, name, complete_name, operating_unit_id, company_id, parent_id, is_disabled, create_by, create_date, write_by, write_date)
SELECT a.id, NULL, a.name, a.complete_name, b.operating_unit_id, a.company_id, a.parent_id, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    hr_department a
    LEFT JOIN plantation_division b ON b.id = a.division_id
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
WHERE a.active
ON CONFLICT (id) DO UPDATE
SET
    code = EXCLUDED.code,
    name = EXCLUDED.name,
    complete_name = EXCLUDED.complete_name,
    operating_unit_id = EXCLUDED.operating_unit_id,
    company_id = EXCLUDED.company_id,
    parent_id = EXCLUDED.parent_id,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;

-- m_employee
UPDATE m_employee SET is_disabled = TRUE;
INSERT INTO m_employee (
	id, nip, name, operating_unit_id, company_id, estate_id, division_id, department_id, foreman_group_id, foreman_id, job_level_id, job_level,
	job_id, job_name, type_id, type_name, status_id, job_status, fp_id, gender, birthday, id_number, work_date_start, work_duration,
	contract_start, contract_end, contract_state, hr_transition,
	is_disabled, create_by, create_date, write_by, write_date
)
SELECT 
	emp.id,
	emp.nomor_induk_pegawai AS nip,
	emp.name AS emp_name,
	emp.operating_unit_id,
	emp.company_id,
	div.estate_id,
	emp.division_id,
	emp.department_id,
	emp.foreman_group_id,
	emp.foreman_id,
	emp.job_level_id,
	lvl.name AS job_level,
	emp.job_id,
	job.name AS job_name,
	emp.employee_type_id AS type_id,
	typ.name AS employee_type,
	emp.employee_status_id AS status_id,
	sts.name AS job_status,
	emp.fp_id_emp,
	emp.gender,
	emp.birthday,
	emp.identification_id AS id_number,
	emp.work_date_start,
	emp.work_duration_string AS work_duration,
	ctract.date_start AS contract_start,
	ctract.date_end AS contract_end,
	ctract.state AS contract_state,
	ctract.hr_transition,
	FALSE,
	cu.login AS create_by,
	emp.create_date,
	wu.login AS write_by,
	emp.write_date
FROM
	hr_employee emp
	LEFT JOIN hr_department dept ON dept.id = emp.department_id
	LEFT JOIN plantation_division div ON div.id = emp.division_id
	LEFT JOIN hr_employee_type typ ON typ.id = emp.employee_type_id
	LEFT JOIN hr_job job ON job.id = emp.job_id
	LEFT JOIN hit_md_employee_status sts ON sts.id = emp.employee_status_id
	LEFT JOIN hit_md_job_level lvl ON lvl.id = emp.job_level_id
	LEFT JOIN hr_contract ctract ON ctract.id = emp.contract_id
	LEFT JOIN res_users cu ON cu.id = emp.create_uid
	LEFT JOIN res_users wu ON wu.id = emp.write_uid
WHERE emp.active
ON CONFLICT (id) DO UPDATE
SET
	nip              = EXCLUDED.nip,
	name             = EXCLUDED.name,
	operating_unit_id = EXCLUDED.operating_unit_id,
	company_id       = EXCLUDED.company_id,
	estate_id        = EXCLUDED.estate_id,
	division_id      = EXCLUDED.division_id,
	department_id    = EXCLUDED.department_id,
	foreman_group_id = EXCLUDED.foreman_group_id,
	foreman_id       = EXCLUDED.foreman_id,
	job_level_id     = EXCLUDED.job_level_id,
	job_level        = EXCLUDED.job_level,
	job_id           = EXCLUDED.job_id,
	job_name         = EXCLUDED.job_name,
	type_id          = EXCLUDED.type_id,
	type_name        = EXCLUDED.type_name,
	status_id        = EXCLUDED.status_id,
	job_status       = EXCLUDED.job_status,
	fp_id			 = EXCLUDED.fp_id,
	gender           = EXCLUDED.gender,
	birthday         = EXCLUDED.birthday,
	id_number        = EXCLUDED.id_number,
	work_date_start  = EXCLUDED.work_date_start,
	work_duration    = EXCLUDED.work_duration,
	contract_start   = EXCLUDED.contract_start,
	contract_end     = EXCLUDED.contract_end,
	contract_state   = EXCLUDED.contract_state,
	hr_transition    = EXCLUDED.hr_transition,
	is_disabled      = FALSE,
	create_by        = EXCLUDED.create_by,
	create_date      = EXCLUDED.create_date,
	write_by         = EXCLUDED.write_by,
	write_date       = EXCLUDED.write_date
;

-- foreman group
UPDATE m_foreman_group SET is_disabled = TRUE;
INSERT INTO m_foreman_group (id, code, name, type, foreman_id, foreman1_id, kerani_id, kerani1_id, kerani_panen_id, operating_unit_id, company_id, department_id, is_disabled, create_by, create_date, write_by, write_date)
SELECT a.id, a.code, a.name, a.type, foreman_id, foreman1_id, kerani_id, kerani1_id, kerani_harvest_id, a.operating_unit_id, a.company_id, a.department_id, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    hr_foreman_group a
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
WHERE a.active 
ON CONFLICT (id) DO UPDATE
SET
    code              = EXCLUDED.code,
    name              = EXCLUDED.name,
    type              = EXCLUDED.type,
    foreman_id        = EXCLUDED.foreman_id,
    foreman1_id       = EXCLUDED.foreman1_id,
    kerani_id         = EXCLUDED.kerani_id,
    kerani1_id        = EXCLUDED.kerani1_id,
    kerani_panen_id   = EXCLUDED.kerani_panen_id,
    operating_unit_id = EXCLUDED.operating_unit_id,
    company_id        = EXCLUDED.company_id,
    department_id     = EXCLUDED.department_id,
    is_disabled       = FALSE,
    create_by         = EXCLUDED.create_by,
    create_date       = EXCLUDED.create_date,
    write_by          = EXCLUDED.write_by,
    write_date        = EXCLUDED.write_date
;


