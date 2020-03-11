-- Table for temporaty links
DROP TABLE IF EXISTS galette_tmplinks;
CREATE TABLE galette_tmplinks(
  id_adh integer REFERENCES galette_adherents (id_adh) ON DELETE CASCADE ON UPDATE CASCADE,
  hash character varying(60) NOT NULL,
  target smallint NOT NULL,
  creation_date timestamp NOT NULL,
  PRIMARY KEY (hash)
);

UPDATE galette_database SET version = 0.94;
