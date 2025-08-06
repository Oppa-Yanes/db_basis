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

