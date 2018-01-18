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





