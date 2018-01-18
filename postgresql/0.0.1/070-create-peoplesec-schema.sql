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
  token   UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
  date_of_birth DATE NOT NULL
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


/** NAMES */

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
  first CHARACTER VARYING(255) NOT NULL,
  middle CHARACTER VARYING(255),
  last CHARACTER VARYING(255)
) INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_names.secrets IS 'identifies the set of secrets to which this name belongs';
COMMENT ON COLUMN peoplesec.personal_names.name_type IS 'is the type of name';
COMMENT ON COLUMN peoplesec.personal_names.first IS 'is the first part of the name';
COMMENT ON COLUMN peoplesec.personal_names.middle IS 'is everything between the first and last parts';
COMMENT ON COLUMN peoplesec.personal_names.last IS 'is the last part of the name';
COMMENT ON TABLE peoplesec.personal_names IS 'contains the individual names used by People';


-- DROP TABLE peoplesec.personal_names_nicknames;

CREATE TABLE peoplesec.personal_names_nicknames
(
  personal_name UUID UNIQUE NOT NULL
    REFERENCES peoplesec.personal_names (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  nickname      CHARACTER VARYING(255)
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_names_preferences.personal_name IS 'is the identifier of the personal name';
COMMENT ON COLUMN peoplesec.personal_names_preferences.preferred_as_of IS
'is the timestamp marking when the entry was preferred';
COMMENT ON TABLE peoplesec.personal_names_preferences
IS 'establishes the preferences of personal names';


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
COMMENT ON COLUMN peoplesec.personal_names_suffixes.personal_name IS 'is the identifier of the personal name';
COMMENT ON COLUMN peoplesec.personal_names_suffixes.suffix IS 'is the honorific applied to the personal name';
COMMENT ON TABLE peoplesec.personal_names_suffixes
  IS 'contains the honorifics applied to personal names';

/** CONTACT INFO */

-- DROP TABLE peoplesec.personal_web_addresses;

CREATE TABLE peoplesec.personal_web_addresses
(
  id               UUID PRIMARY KEY       NOT NULL DEFAULT uuid_generate_v4(),
  secrets          UUID                   NOT NULL
    REFERENCES peoplesec.personal_secrets (token)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  protocol         CHARACTER VARYING(8)   NOT NULL
    REFERENCES contact.web_address_protocols
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  principal_domain CHARACTER VARYING(255) NOT NULL,
  top_level_domain CHARACTER VARYING(16)  NOT NULL,
  path             CHARACTER VARYING(255) NOT NULL
) INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_web_addresses.id IS
  'uniquely identifies the web address';
COMMENT ON COLUMN peoplesec.personal_web_addresses.secrets IS
  'identifies the set of secrets to which this address belongs';
COMMENT ON COLUMN peoplesec.personal_web_addresses.protocol IS
  'is the address protocol';
COMMENT ON COLUMN peoplesec.personal_web_addresses.principal_domain IS
  'is the address principal domain';
COMMENT ON COLUMN peoplesec.personal_web_addresses.top_level_domain IS
  'is the address top-level domain';
COMMENT ON COLUMN peoplesec.personal_web_addresses.path IS
  'is the address top-level domain';
COMMENT ON TABLE peoplesec.personal_web_addresses IS
  'contains personal web addresses';

-- DROP TABLE peoplesec.personal_web_addresses_subdomains;

CREATE TABLE peoplesec.personal_web_addresses_subdomains
(
    personal_web_address          UUID     UNIQUE              NOT NULL
    REFERENCES peoplesec.personal_web_addresses (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  subdomain         CHARACTER VARYING(255) NOT NULL
) INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_web_addresses_subdomains.personal_web_address IS
  'identifies the personal web address that has this subdomain';
COMMENT ON COLUMN peoplesec.personal_web_addresses_subdomains.subdomain IS
  'is the subdomain';
COMMENT ON TABLE peoplesec.personal_web_addresses_subdomains IS
  'contains subdomains for personal web addresses that have them';

-- DROP TABLE peoplesec.personal_web_addresses_preferences;

CREATE TABLE peoplesec.personal_web_addresses_preferences
(
   personal_web_address uuid UNIQUE NOT NULL
     REFERENCES peoplesec.personal_web_addresses(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   preferred_as_of TIMESTAMP WITH TIME ZONE DEFAULT now()
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_web_addresses_preferences.personal_web_address IS
  'is the identifier of the personal web address';
COMMENT ON COLUMN peoplesec.personal_web_addresses_preferences.preferred_as_of IS
  'is the timestamp marking when the entry was preferred';
COMMENT ON TABLE peoplesec.personal_web_addresses_preferences
  IS 'establishes the preferences of personal web addresses';


-- DROP TABLE peoplesec.personal_telephone_numbers;

CREATE TABLE peoplesec.personal_telephone_numbers
(
  id               UUID PRIMARY KEY       NOT NULL DEFAULT uuid_generate_v4(),
  secrets          UUID                   NOT NULL
    REFERENCES peoplesec.personal_secrets (token)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  telephone_number_type CHARACTER VARYING(8) NOT NULL
    REFERENCES contact.telephone_number_types
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  country_code CHARACTER(2) NOT NULL,
  area_code CHARACTER(2) NOT NULL,
  prefix CHARACTER(3) NOT NULL,
  subscriber CHARACTER(4) NOT NULL
) INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_telephone_numbers.id IS
  'uniquely identifies the personal telephone number';
COMMENT ON COLUMN peoplesec.personal_telephone_numbers.secrets IS
  'identifies the set of secrets to which this personal telephone number belongs';
COMMENT ON COLUMN peoplesec.personal_telephone_numbers.country_code IS
  'is the country code';
COMMENT ON COLUMN peoplesec.personal_telephone_numbers.area_code IS
  'is the area code';
COMMENT ON COLUMN peoplesec.personal_telephone_numbers.prefix IS
  'is the prefix';
COMMENT ON COLUMN peoplesec.personal_telephone_numbers.subscriber IS
  'is the subscriber';
COMMENT ON TABLE peoplesec.personal_telephone_numbers IS
  'contains personal telephone numbers';

-- DROP TABLE peoplesec.personal_telephone_numbers_extensions;

CREATE TABLE peoplesec.personal_telephone_numbers_extensions
(
  personal_telephone_number UUID UNIQUE            NOT NULL -- A telephone number may have only one extension.
    REFERENCES peoplesec.personal_telephone_numbers (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  extension                 CHARACTER VARYING(255) NOT NULL
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_telephone_numbers_extensions.personal_telephone_number IS
'is the identifier of the personal telephone number';
COMMENT ON COLUMN peoplesec.personal_telephone_numbers_extensions.extension IS
'is the extension';
COMMENT ON TABLE peoplesec.personal_telephone_numbers_extensions
IS 'contains the extensions of personal telephone numbers';

-- DROP TABLE peoplesec.personal_telephone_numbers_preferences;

CREATE TABLE peoplesec.personal_telephone_numbers_preferences
(
   personal_telephone_number uuid UNIQUE NOT NULL
     REFERENCES peoplesec.personal_telephone_numbers(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   preferred_as_of TIMESTAMP WITH TIME ZONE DEFAULT now()
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_telephone_numbers_preferences.personal_telephone_number IS
  'is the identifier of the personal telephone number';
COMMENT ON COLUMN peoplesec.personal_telephone_numbers_preferences.preferred_as_of IS
  'is the timestamp marking when the entry was preferred';
COMMENT ON TABLE peoplesec.personal_telephone_numbers_preferences
  IS 'establishes the preferences of personal telephone number';


-- DROP TABLE peoplesec.personal_email_addresses;

CREATE TABLE peoplesec.personal_email_addresses
(
  id                  UUID PRIMARY KEY       NOT NULL DEFAULT uuid_generate_v4(),
  secrets             UUID                   NOT NULL
    REFERENCES peoplesec.personal_secrets (token)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  personal_email_type CHARACTER VARYING(8)   NOT NULL
    REFERENCES contact.personal_email_types (code)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  user_name           CHARACTER VARYING(255) NOT NULL,
  principal_domain    CHARACTER VARYING(255) NOT NULL,
  top_level_domain    CHARACTER VARYING(16)  NOT NULL
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_email_addresses.id IS
'uniquely identifies the personal email address';
COMMENT ON COLUMN peoplesec.personal_email_addresses.secrets IS
'identifies the set of secrets to which this personal email address belongs';
COMMENT ON COLUMN peoplesec.personal_email_addresses.user_name IS
'is the user (everything before @)';
COMMENT ON COLUMN peoplesec.personal_email_addresses.principal_domain IS
'is the address principal domain';
COMMENT ON COLUMN peoplesec.personal_email_addresses.top_level_domain IS
'is the address top-level domain';
COMMENT ON TABLE peoplesec.personal_email_addresses IS
'contains personal email addresses';

-- DROP TABLE peoplesec.personal_email_addresses_subdomains;

CREATE TABLE peoplesec.personal_email_addresses_subdomains
(
    personal_email_address          UUID    UNIQUE               NOT NULL
    REFERENCES peoplesec.personal_email_addresses (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  subdomain         CHARACTER VARYING(255) NOT NULL
) INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_email_addresses_subdomains.personal_email_address IS
  'identifies the personal email address that has this subdomain';
COMMENT ON COLUMN peoplesec.personal_email_addresses_subdomains.subdomain IS
  'is the subdomain';
COMMENT ON TABLE peoplesec.personal_email_addresses_subdomains IS
  'contains subdomains for personal email addresses that have them';

-- DROP TABLE peoplesec.personal_email_addresses_preferences;

CREATE TABLE peoplesec.personal_email_addresses_preferences
(
   personal_email_address uuid UNIQUE NOT NULL
     REFERENCES peoplesec.personal_email_addresses(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   preferred_as_of TIMESTAMP WITH TIME ZONE DEFAULT now()
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_email_addresses_preferences.personal_email_address IS
'is the identifier of the personal email address';
COMMENT ON COLUMN peoplesec.personal_email_addresses_preferences.preferred_as_of IS
  'is the timestamp marking when the entry was preferred';
COMMENT ON TABLE peoplesec.personal_email_addresses_preferences
  IS 'establishes the preferences of personal web addresses';


-- DROP TABLE peoplesec.personal_social_media_handles;

CREATE TABLE peoplesec.personal_social_media_handles
(
  id                  UUID PRIMARY KEY       NOT NULL DEFAULT uuid_generate_v4(),
  secrets             UUID                   NOT NULL
    REFERENCES peoplesec.personal_secrets (token)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  social_medium CHARACTER VARYING(8)   NOT NULL
    REFERENCES contact.social_media (code)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  handle          CHARACTER VARYING(255) NOT NULL
)
  INHERITS (db.entities)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_social_media_handles.id IS
'uniquely identifies the personal social media handle';
COMMENT ON COLUMN peoplesec.personal_social_media_handles.secrets IS
'identifies the set of secrets to which this personal social media handle belongs';
COMMENT ON TABLE peoplesec.personal_social_media_handles IS
'contains personal social media handles';

-- DROP TABLE peoplesec.personal_social_media_handles_preferences;

CREATE TABLE peoplesec.personal_social_media_handles_preferences
(
   personal_social_media_handle uuid UNIQUE NOT NULL
     REFERENCES peoplesec.personal_social_media_handles(id)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   preferred_as_of TIMESTAMP WITH TIME ZONE DEFAULT now()
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN peoplesec.personal_social_media_handles_preferences.personal_social_media_handle IS
'is the identifier of the personal social media handle';
COMMENT ON COLUMN peoplesec.personal_social_media_handles_preferences.preferred_as_of IS
  'is the timestamp marking when the entry was preferred';
COMMENT ON TABLE peoplesec.personal_social_media_handles_preferences
  IS 'establishes the preferences of personal social media handles';
