SET FOREIGN_KEY_CHECKS=0;

ALTER TABLE galette_adherents
DROP COLUMN fingerprint;

ALTER TABLE galette_adherents CHANGE `icq_adh` TO `twitter_adh` VARCHAR(20);
ALTER TABLE galette_adherents CHANGE `msn_adh` TO `discord_adh` VARCHAR(150);
ALTER TABLE galette_adherents CHANGE `jabber_adh` TO `telegram_adh` VARCHAR(150);

UPDATE galette_database SET version = 0.932;
SET FOREIGN_KEY_CHECKS=1;
