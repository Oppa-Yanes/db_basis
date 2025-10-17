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

DROP TABLE IF EXISTS t_taksasi CASCADE;
CREATE TABLE t_taksasi (
	id UUID PRIMARY KEY,
	harvest_date DATE NOT NULL,
	company_id INT4 NOT NULL,
	estate_id INT4 NOT NULL,
	division_id INT4 NOT NULL,	
	block_id INT4 NOT NULL,
	planted_area NUMERIC(8,2) DEFAULT 0,
	plant_total INT4 DEFAULT 0,
	bjr NUMERIC(8,2) DEFAULT 0,
	base_weight INT4 DEFAULT 0,
	akp NUMERIC(8,2) DEFAULT 0,
	est_ripe_bunch INT4 DEFAULT 0,
	est_weight NUMERIC(8,2) DEFAULT 0,
	est_hk NUMERIC(8,2) DEFAULT 0,
	est_output NUMERIC(8,2) DEFAULT 0,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP
);

DROP TABLE IF EXISTS m_profile CASCADE;
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

DROP TABLE IF EXISTS t_transport CASCADE;
CREATE TABLE t_transport (
    id UUID PRIMARY KEY,
    transport_nbr VARCHAR UNIQUE NOT NULL,
    transport_date TIMESTAMP NOT NULL,
	company_id INT4 NOT NULL,
	estate_id INT4 NOT NULL,
	division_id INT4 NOT NULL,
	equipment_id INT4 NOT NULL,
	driver_id INT4 NOT NULL,
	loader_id INT4 NOT NULL,
	total_bunch INT4 NOT NULL DEFAULT 0,
	total_loose_fruit NUMERIC(8,2) NOT NULL DEFAULT 0,
	total_weight NUMERIC(8,2) NOT NULL DEFAULT 0,
 	pic_path VARCHAR NOT NULL,
	pic_uri VARCHAR NOT NULL,
	rfid_id VARCHAR,
	rfid_text VARCHAR,
	profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    sync_attempt INT4 NOT NULL DEFAULT 0,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

DROP TABLE IF EXISTS t_rkh CASCADE;
CREATE TABLE t_rkh (
    id UUID PRIMARY KEY,
    rkh_nbr VARCHAR UNIQUE NOT NULL,
    rkh_date DATE NOT NULL,
	stage CHAR NOT NULL,
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
    sync_attempt INT4 NOT NULL DEFAULT 0,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

DROP TABLE IF EXISTS t_harvester CASCADE;
CREATE TABLE t_harvester (
    id UUID PRIMARY KEY,
	rkh_id UUID NOT NULL,
	emp_id INT4 NOT NULL,
	nip VARCHAR NOT NULL,
	fp_id VARCHAR NOT NULL,
	name VARCHAR NOT NULL,
	job_level_id INT4 NOT NULL,
 	job_level_name VARCHAR,
	job_id INT4 NOT NULL,
 	job_name VARCHAR,
	is_asistensi BOOLEAN DEFAULT FALSE,
	foreman_group_id INT4 NOT NULL,
	foreman_group_name VARCHAR,
    profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    sync_attempt INT4 NOT NULL DEFAULT 0,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_rkh FOREIGN KEY (rkh_id) REFERENCES t_rkh(id),
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

DROP TABLE IF EXISTS t_location CASCADE;
CREATE TABLE t_location (
    id UUID PRIMARY KEY,
	rkh_id UUID NOT NULL,
	block_id INT4 NOT NULL,
	block_code VARCHAR NOT NULL,
	harvest_area NUMERIC(8,2) NOT NULL DEFAULT 0,
	est_weight NUMERIC(8,2) NOT NULL DEFAULT 0,
	est_bunch INT4 NOT NULL DEFAULT 0,
	est_hk NUMERIC(8,2) NOT NULL DEFAULT 0,
	est_output NUMERIC(8,2) NOT NULL DEFAULT 0,
    profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    sync_attempt INT4 NOT NULL DEFAULT 0,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_rkh FOREIGN KEY (rkh_id) REFERENCES t_rkh(id),
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

DROP TABLE IF EXISTS t_harvest CASCADE;
CREATE TABLE t_harvest (
    id UUID PRIMARY KEY,
    harvest_nbr VARCHAR UNIQUE NOT NULL,
    harvest_date TIMESTAMP NOT NULL,
 	harvester_id UUID NOT NULL,
 	location_id UUID NOT NULL,
	tph_id INT4 NOT NULL,
	tph_code VARCHAR NOT NULL,
    lat FLOAT NOT NULL DEFAULT 0,
    long FLOAT NOT NULL DEFAULT 0,
	bunch_qty INT4 NOT NULL DEFAULT 0,
	unripe_qty INT4 NOT NULL DEFAULT 0,
	overripe_qty INT4 NOT NULL DEFAULT 0,
	rotten_qty INT4 NOT NULL DEFAULT 0,
	empty_bunch_qty INT4 NOT NULL DEFAULT 0,
	loose_fruit_qty NUMERIC(8,2) NOT NULL DEFAULT 0,
	pic_path VARCHAR NOT NULL,
	pic_uri VARCHAR NOT NULL,
	rfid_id VARCHAR,
	rfid_text VARCHAR,
	transport_id UUID,
 	profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    sync_attempt INT4 NOT NULL DEFAULT 0,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_transport FOREIGN KEY (transport_id) REFERENCES t_transport(id),
    CONSTRAINT fk_harvester FOREIGN KEY (harvester_id) REFERENCES t_harvester(id),
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

DROP TABLE IF EXISTS t_bkm CASCADE;
CREATE TABLE t_bkm (
    id UUID PRIMARY KEY,
	rkh_id UUID NOT NULL,
	harvester_id UUID UNIQUE NOT NULL,
	ha_amt NUMERIC(8,2) NOT NULL DEFAULT 0,
	p01 NUMERIC(8,2) NOT NULL DEFAULT 0,
	p02 NUMERIC(8,2) NOT NULL DEFAULT 0,
	p03 NUMERIC(8,2) NOT NULL DEFAULT 0,
	p04 NUMERIC(8,2) NOT NULL DEFAULT 0,
	p05 NUMERIC(8,2) NOT NULL DEFAULT 0,
	p06 NUMERIC(8,2) NOT NULL DEFAULT 0,
	p07 NUMERIC(8,2) NOT NULL DEFAULT 0,	
	profile_id UUID NOT NULL,
    date_sync TIMESTAMP,
    sync_attempt INT4 NOT NULL DEFAULT 0,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_rkh FOREIGN KEY (rkh_id) REFERENCES t_rkh(id),
    CONSTRAINT fk_harvester FOREIGN KEY (harvester_id) REFERENCES t_harvester(id),
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES m_profile(id)
);

-- IMPORT DATA

UPDATE t_taksasi SET is_disabled = TRUE;
INSERT INTO t_taksasi (
	id, code, census_date, harvest_date, company_id, estate_id, division_id, block_id, 
	harvest_area, est_weight, est_ripe_bunch, est_hk, est_output, state,
	is_disabled, create_by, create_date, write_by, write_date
	)
SELECT
	a.id, a.name, a.taksasi_date, a.tanggal_rencana_panen, b.company_id, a.plantation_estate_id, a.division_id, a.block_land, 
	a.total_luas_panen, a.total_taksasi_panen, a.total_jumlah_janjang_masak, a.total_hk, a.jumlah_kghk, a.state,
	FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    plantation_taksasi a
    LEFT JOIN plantation_division b ON b.id = a.division_id
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
ON CONFLICT (id) DO UPDATE
SET
    code = EXCLUDED.code,
    census_date = EXCLUDED.census_date,
    harvest_date = EXCLUDED.harvest_date,
    company_id = EXCLUDED.company_id,
    estate_id = EXCLUDED.estate_id,
    division_id = EXCLUDED.division_id,
    block_id = EXCLUDED.block_id,
    harvest_area = EXCLUDED.harvest_area,
    est_weight = EXCLUDED.est_weight,
    est_ripe_bunch = EXCLUDED.est_ripe_bunch,
    est_hk = EXCLUDED.est_hk,
    est_output = EXCLUDED.est_output,
    state = EXCLUDED.state,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;


