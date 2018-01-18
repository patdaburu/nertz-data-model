-- DROP TABLE postaddr.countries;

CREATE TABLE postaddr.countries
(
  code CHARACTER VARYING(2) PRIMARY KEY NOT NULL,
  alpha_2_code CHARACTER VARYING(2) UNIQUE NOT NULL,
  alpha_3_code CHARACTER VARYING(3) UNIQUE NOT NULL,
  numeric_code INTEGER,
  name CHARACTER VARYING(255) UNIQUE NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.countries.code IS
'is the internal code';
COMMENT ON COLUMN postaddr.countries.alpha_2_code IS
'is the 2-letter alphanumeric code';
COMMENT ON COLUMN postaddr.countries.alpha_3_code IS
'is the 3-letter alphanumeric code';
COMMENT ON COLUMN postaddr.countries.numeric_code IS
'is the numeric code';
COMMENT ON COLUMN postaddr.countries.name IS
'is the English name of the the country';
COMMENT ON TABLE postaddr.countries IS
  'contains ISO-3166-1 country codes';
-- TODO: Add seed data.
INSERT INTO postaddr.countries(code, alpha_2_code, alpha_3_code, numeric_code, name)
    VALUES('US', 'US', 'USA', 840, 'United States of America');

