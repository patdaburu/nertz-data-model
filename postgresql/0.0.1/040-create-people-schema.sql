-- Schema: people

-- DROP SCHEMA people;

CREATE SCHEMA people
  AUTHORIZATION postgres;

COMMENT ON SCHEMA people
  IS 'This schema contains information about people that is subject to normal security measures.';

-- DROP TABLE people.personal_name_honorifics

CREATE TABLE people.personal_name_honorifics
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  formal CHARACTER VARYING(255) NOT NULL,
  abbreviation CHARACTER VARYING(12) NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN people.personal_name_honorifics.code IS 'is the code that identifies the honorific';
COMMENT ON COLUMN people.personal_name_honorifics.formal IS 'is the full honorific';
COMMENT ON COLUMN people.personal_name_honorifics.abbreviation IS 'is the abbreviated form';
COMMENT ON TABLE people.personal_name_honorifics IS
  'contains the supported personal name suffixes';
-- TODO: Add seed data.

-- DROP TABLE people.personal_name_suffixes;

CREATE TABLE people.personal_name_suffixes
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  formal CHARACTER VARYING(255) NOT NULL,
  abbreviation CHARACTER VARYING(12) NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN people.personal_name_suffixes.code IS 'is the code that identifies the suffix';
COMMENT ON COLUMN people.personal_name_suffixes.formal IS 'is the full suffix';
COMMENT ON COLUMN people.personal_name_suffixes.abbreviation IS 'is the abbreviated form';
COMMENT ON TABLE people.personal_name_suffixes IS
  'contains the known personal name suffixes';
-- TODO: Add seed data.

-- DROP TABLE people.personal_name_types

CREATE TABLE people.personal_name_types
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  short_description CHARACTER VARYING(255) NOT NULL,
  long_description TEXT NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN people.personal_name_types.code IS 'is the code that identifies the personal name type';
COMMENT ON COLUMN people.personal_name_types.short_description IS 'briefly describes the alias type';
COMMENT ON COLUMN people.personal_name_types.long_description IS 'goes into greater detail about the alias type';
COMMENT ON TABLE people.personal_name_types IS
  'contains information about the supported personal name types';
-- TODO: Add seed data.



-- DROP TABLE people.people;

CREATE TABLE people.people
(
  id        UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
  secrets   UUID             NOT NULL UNIQUE ,
  /*
    REFERENCES peoplesec.personal_secrets (token)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    */
  -- TODO: The peoplesec tables don't exist yet.
  fictional BOOLEAN          NOT NULL DEFAULT FALSE
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN people.people.id IS 'uniquely identifies a Person';
COMMENT ON COLUMN people.people.secrets IS 'is the token to retrieve personal secrets';
COMMENT ON COLUMN people.people.fictional IS
  'indicates whether or not the person is a real person as opposed to a fiction';
COMMENT ON TABLE people.people IS 'identifies people';
