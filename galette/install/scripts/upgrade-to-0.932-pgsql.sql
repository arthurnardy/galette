-- sequence for texts
DROP SEQUENCE IF EXISTS galette_texts_id_seq;
CREATE SEQUENCE galette_texts_id_seq
    START 1
    INCREMENT 1
    MAXVALUE 2147483647
    MINVALUE 1
    CACHE 1;

-- sequence for fields categories
DROP SEQUENCE IF EXISTS galette_fields_categories_id_seq;
CREATE SEQUENCE galette_fields_categories_id_seq
    START 1
    INCREMENT 1
    MAXVALUE 2147483647
    MINVALUE 1
    CACHE 1;

ALTER TABLE galette_adherents
DROP COLUMN fingerprint;

ALTER TABLE galette_adherents
RENAME COLUMN icq_adh TO twitter_adh, 
RENAME COLUMN msn_adh TO discord_adh, 
RENAME COLUMN jabber_adh TO telegram_adh;

UPDATE galette_database SET version = 0.932;
