SET FOREIGN_KEY_CHECKS=0;

-- table for saved searches
DROP TABLE IF EXISTS galette_tmplinks;
CREATE TABLE galette_tmplinks (
  id_adh int(10) unsigned,
  hash varchar(60) NOT NULL,
  target smallint(1) NOT NULL,
  creation_date datetime NOT NULL,
  PRIMARY KEY (hash),
  FOREIGN KEY (id_adh) REFERENCES galette_adherents (id_adh) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

UPDATE galette_database SET version = 0.94;
SET FOREIGN_KEY_CHECKS=1;
