SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE galette_adherents
DROP COLUMN fingerprint;

ALTER TABLE galette_adherents
RENAME COLUMN icq_adh TO twitter_adh, 
RENAME COLUMN msn_adh TO discord_adh, 
RENAME COLUMN jabber_adh TO telegram_adh;

UPDATE galette_database SET version = 0.932;
SET FOREIGN_KEY_CHECKS=1;
