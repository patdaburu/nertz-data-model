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

-- DROP TABLE postaddr.state_subdivision_categories;

CREATE TABLE postaddr.state_subdivision_categories
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  short_description CHARACTER VARYING(255) UNIQUE NOT NULL,
  long_description TEXT NOT NULL
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN postaddr.state_subdivision_categories.code IS
'identifies the subdivision category';
COMMENT ON COLUMN postaddr.state_subdivision_categories.short_description IS
'is the short description of the category';
COMMENT ON COLUMN postaddr.state_subdivision_categories.long_description IS
'is the long description of the category';
COMMENT ON TABLE postaddr.state_subdivision_categories IS
  'contains ISO-3166-2 state subdivision categories';
-- SEED DATA:
INSERT INTO postaddr.state_subdivision_categories (code, short_description, long_description)
VALUES
  ('STATE', 'state', 'a state'),
  ('DISTRICT', 'district', 'a district'),
  ('OUTLYING', 'outlying', 'an outlying area');


-- DROP TABLE postaddr.states;

CREATE TABLE postaddr.states
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  country CHARACTER VARYING(2) NOT NULL
  REFERENCES postaddr.countries(code)
  ON DELETE RESTRICT
  ON UPDATE CASCADE ,
  alpha_3_code CHARACTER VARYING(3) NOT NULL,
  subdivision_category CHARACTER VARYING(8) NOT NULL
    REFERENCES postaddr.state_subdivision_categories(code)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,

  name CHARACTER VARYING(255) UNIQUE NOT NULL,
  CONSTRAINT postaddr_states__alpha_3_code_and_country__unique UNIQUE(alpha_3_code, country)
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.states.code IS
'is the 2-letter alphanumeric code for the state';
COMMENT ON COLUMN postaddr.states.alpha_3_code IS
'is the 2-letter alphanumeric code for the state';
COMMENT ON COLUMN postaddr.states.country IS
'identifies the country in which the state resides';
COMMENT ON COLUMN postaddr.states.name IS
'is the name of the the state';
COMMENT ON TABLE postaddr.states IS
  'contains states as defined by ISO-3166-2';
-- TODO: Add seed data.
INSERT INTO postaddr.states(code, country, alpha_3_code, subdivision_category, name)
    VALUES
      ('US-AL', 'US', 'AL', 'STATE', 'Alabama'),
      ('US-AK', 'US', 'AK', 'STATE', 'Alaska'),
      ('US-AZ', 'US', 'AZ', 'STATE', 'Arizona'),
      ('US-AR', 'US', 'AR', 'STATE', 'Arkansas');
-- TODO: Complete seed data.


-- DROP TABLE postaddr.cities;

CREATE TABLE postaddr.cities
(
  id        UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
  state CHARACTER VARYING(8) NOT NULL
  REFERENCES postaddr.states(code)
  ON DELETE RESTRICT
  ON UPDATE CASCADE ,
  name CHARACTER VARYING(255) UNIQUE NOT NULL,
  CONSTRAINT postaddr_cities__state_and_name__unique UNIQUE(state, name)
) INHERITS(db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN postaddr.cities.id IS
'uniquely identifies the city';
COMMENT ON COLUMN postaddr.cities.state IS
'is the state code for the state in which the city resides';
COMMENT ON COLUMN postaddr.cities.name IS
'is the name of the the city';
COMMENT ON TABLE postaddr.cities IS
  'contains cities';
-- TODO: Add seed data.


