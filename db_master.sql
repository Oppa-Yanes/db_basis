-- CREATE ACCESS TO GBS_PRD FROM DB_MASTER

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

-- contoh pakai:
-- SELECT * FROM hr_foreman_group LIMIT 10;
-- END CREATE

CREATE TABLE m_company (
    id SERIAL PRIMARY KEY,
    code VARCHAR NOT NULL UNIQUE,
    name VARCHAR NOT NULL,
    is_disabled BOOLEAN DEFAULT FALSE,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP
);

-- insert into m_company
UPDATE m_company SET is_disabled = TRUE;
INSERT INTO m_company (id, code, name, is_disabled, create_by, create_date, write_by, write_date)
SELECT a.id, a.code, a.name, FALSE, x.login, a.create_date, y.login, a.write_date
FROM
    res_company a
    LEFT JOIN res_users x ON x.id = a.create_uid
    LEFT JOIN res_users y ON y.id = a.write_uid
ON CONFLICT (id) DO UPDATE
SET
    code = EXCLUDED.code,
    name = EXCLUDED.name,
    is_disabled = FALSE,
    create_by = EXCLUDED.create_by,
    create_date = EXCLUDED.create_date,
    write_by = EXCLUDED.write_by,
    write_date = EXCLUDED.write_date
;


