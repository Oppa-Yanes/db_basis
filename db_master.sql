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

