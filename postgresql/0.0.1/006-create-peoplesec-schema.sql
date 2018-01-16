-- Schema: peoplesec

-- DROP SCHEMA peoplesec;

CREATE SCHEMA peoplesec
  AUTHORIZATION postgres;

COMMENT ON SCHEMA peoplesec
  IS 'This schema contains personal secrets!';

-- DROP TABLE peoplesec.personal_secrets;
-- ALTER TABLE people.people DROP CONSTRAINT people__people__secrets_fk;

CREATE TABLE peoplesec.personal_secrets
(
  token   UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4()
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_secrets.token IS 'uniquely identifies the set of personal secrets';
--COMMENT ON COLUMN peoplesec.personal_secrets.ssn IS 'is person''s social security number';
COMMENT ON TABLE peoplesec.personal_secrets IS
  'is the point of collation for a set of personal secrets';

-- Create the FOREIGN KEY relationship from people.people(secrets) to peoplesec.personal_secrets(token).

ALTER TABLE people.people
    ADD CONSTRAINT people__people__secrets_fk
    FOREIGN KEY (secrets)
    REFERENCES peoplesec.personal_secrets(token);

-- DROP TABLE peoplesec.personal_names;

CREATE TABLE peoplesec.personal_names
(
  id        UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
  secrets   UUID             NOT NULL
    REFERENCES peoplesec.personal_secrets (token)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  name_type CHARACTER VARYING(8) NOT NULL
    REFERENCES people.personal_name_types(code)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  given_name CHARACTER VARYING(255) NOT NULL,
  middle CHARACTER VARYING(255),
  surname CHARACTER VARYING(255)
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_names.secrets IS 'identifies the set of secrets to which this name belongs';
COMMENT ON COLUMN peoplesec.personal_names.name_type IS 'is the type of name';
COMMENT ON COLUMN peoplesec.personal_names.given_name IS 'is a given name';
COMMENT ON COLUMN peoplesec.personal_names.middle IS 'is everything between the given name and the surname';
COMMENT ON COLUMN peoplesec.personal_names.surname IS 'is the surname';
COMMENT ON TABLE peoplesec.personal_names IS 'contains the individual names used by People';


-- DROP TABLE peoplesec.personal_names_preferences;

CREATE TABLE peoplesec.personal_names_preferences
(
   personal_name uuid NOT NULL UNIQUE  -- Only one (1) timestamp is saved per personal name.
     REFERENCES peoplesec.personal_names(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   preferred_as_of TIMESTAMP WITH TIME ZONE DEFAULT now()
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_names_preferences.personal_name IS 'is the identifier of the personal name';
COMMENT ON COLUMN peoplesec.personal_names_preferences.preferred_as_of IS
  'is the timestamp marking when the entry was preferred';
COMMENT ON TABLE peoplesec.personal_names_preferences
  IS 'establishes the preferences of personal names';


-- DROP TABLE peoplesec.personal_names_honorifics;

CREATE TABLE peoplesec.personal_names_honorifics
(
   personal_name uuid NOT NULL UNIQUE  -- Only one (1) honorific is permitted per name.
     REFERENCES db.sys_users(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   honorific character varying(8)
     REFERENCES people.personal_name_honorifics(code)
       ON DELETE CASCADE
       ON UPDATE CASCADE
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_names_honorifics.personal_name IS 'is the identifier of the personal name';
COMMENT ON COLUMN peoplesec.personal_names_honorifics.honorific IS 'is the honorific applied to the personal name';
COMMENT ON TABLE peoplesec.personal_names_honorifics
  IS 'contains the honorifics applied to personal names';


-- DROP TABLE peoplesec.personal_names_suffixes;

CREATE TABLE peoplesec.personal_names_suffixes
(
   personal_name uuid NOT NULL
     REFERENCES peoplesec.personal_names(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   suffix character varying(8)
     REFERENCES people.personal_name_suffixes(code)
       ON DELETE CASCADE
       ON UPDATE CASCADE
  -- TODO: Add constraint... the same personal name should not specify the same suffix more than once!
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_names_honorifics.personal_name IS 'is the identifier of the personal name';
COMMENT ON COLUMN peoplesec.personal_names_honorifics.honorific IS 'is the honorific applied to the personal name';
COMMENT ON TABLE peoplesec.personal_names_suffixes
  IS 'contains the honorifics applied to personal names';
