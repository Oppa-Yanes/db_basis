DROP TABLE IF EXISTS t_akp CASCADE;
CREATE TABLE t_akp (
    id UUID PRIMARY KEY,
    akp_nbr VARCHAR UNIQUE NOT NULL,
    akp_date TIMESTAMP NOT NULL,
	company_id SERIAL4 NOT NULL,
	estate_id SERIAL4 NOT NULL,
	division_id SERIAL4 NOT NULL,
    block_id SERIAL4 NOT NULL,
	baris_nbr INT4 NOT NULL DEFAULT 0,
    total_bunch_count INT4 NOT NULL DEFAULT 0,
    total_plant NUMERIC(8,2) NOT NULL DEFAULT 0,
    akp NUMERIC(8,2) NOT NULL DEFAULT 0,
 	pic_path VARCHAR NOT NULL,
	pic_uri VARCHAR NOT NULL,
	user_uuid UUID NOT NULL,
    date_sync TIMESTAMP,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,

    CONSTRAINT fk_company FOREIGN KEY (company_id) REFERENCES company(id),
    CONSTRAINT fk_estate FOREIGN KEY (estate_id) REFERENCES estate(id),
    CONSTRAINT fk_division FOREIGN KEY (division_id) REFERENCES divisi(id),
    CONSTRAINT fk_block FOREIGN KEY (block_id) REFERENCES blok(id),
    CONSTRAINT fk_users FOREIGN KEY (user_uuid) REFERENCES users(uuid)
);

DROP TABLE IF EXISTS t_akp_line CASCADE;
CREATE TABLE t_akp_line (
    id UUID PRIMARY KEY,
    akp UUID NOT NULL,
	pokok_nbr INT4 NOT NULL DEFAULT 0,
	bunch_count INT4 NOT NULL DEFAULT 0,
    date_sync TIMESTAMP,
    create_by VARCHAR,
    create_date TIMESTAMP,
    write_by VARCHAR,
    write_date TIMESTAMP,

    CONSTRAINT fk_akp FOREIGN KEY (akp_id) REFERENCES t_akp(id)
);
