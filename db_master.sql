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

CREATE TABLE m_afdeling (
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
    CONSTRAINT fk_parent_id FOREIGN KEY (parent_id) REFERENCES m_afdeling(id)
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
    afdeling_id INT4 NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_estate FOREIGN KEY (estate_id) REFERENCES m_estate(id),
    CONSTRAINT fk_afdeling FOREIGN KEY (afdeling_id) REFERENCES m_afdeling(id)
);

DROP TABLE IF EXISTS m_tph;
CREATE TABLE m_tph (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    lat FLOAT,
    long FLOAT,
    operating_unit_id INT4 NOT NULL,
    company_id INT4 NOT NULL,
    estate_id INT4 NOT NULL,
    afdeling_id INT4 NOT NULL,
    block_id INT4 NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,
    
    CONSTRAINT fk_operating_unit FOREIGN KEY (operating_unit_id) REFERENCES m_operating_unit(id),
    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES m_company(id),
    CONSTRAINT fk_estate FOREIGN KEY (estate_id) REFERENCES m_estate(id),
    CONSTRAINT fk_afdeling FOREIGN KEY (afdeling_id) REFERENCES m_afdeling(id),
    CONSTRAINT fk_block FOREIGN KEY (block_id) REFERENCES m_block(id)    
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
SELECT a.id, a.code, a.name, a.mark, a.is_pabrik, a.is_nursery, a.operating_unit_id, a.company_id, FALSE, x.login, a.create_date, y.login, a.write_date
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

-- afdeling
UPDATE m_afdeling SET is_disabled = TRUE;
INSERT INTO m_afdeling (id, code, name, mark, operating_unit_id, company_id, estate_id, parent_id, is_disabled, create_by, create_date, write_by, write_date)
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
	company_id,estate_id,afdeling_id,is_disabled,create_by,create_date,write_by,write_date
)
SELECT 
	a.id, a.code, b.code, a.name, c.name, d.name, a.block_plasma, e.name, a.area_coefficient, b.block_area, a.planted_area,
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
    afdeling_id = EXCLUDED.afdeling_id,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;

-- tph
UPDATE m_tph SET is_disabled = TRUE;
INSERT INTO m_tph (id,code,name,lat,long,operating_unit_id,company_id,estate_id,afdeling_id,block_id,is_disabled,create_by,create_date,write_by,write_date)
SELECT 
	a.id,REPLACE(a.name,' ',''),REPLACE(a.name,' ',''),0,0,a.operating_unit_id,a.company_id, b.estate_id, b.division_id, a.planted_block_id, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    plantation_harvest_staging a
    LEFT JOIN plantation_land_planted b ON b.id = a.planted_block_id
    --LEFT JOIN plantation_division c ON c.id = b.division_id
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
    afdeling_id = EXCLUDED.afdeling_id,
    block_id = EXCLUDED.block_id,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;


