-- Schema: contact

-- DROP SCHEMA contact;

CREATE SCHEMA contact
  AUTHORIZATION postgres;

COMMENT ON SCHEMA contact
  IS 'This schema contains generally visible contact information and metadata.';

-- DROP TABLE contact.telephone_number_types;

CREATE TABLE contact.telephone_number_types
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  short_description CHARACTER VARYING(16) NOT NULL,
  long_description TEXT NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN contact.telephone_number_types.code IS 'is the code that identifies the telephone number type';
COMMENT ON COLUMN contact.telephone_number_types.short_description IS 'briefly describes the telephone number type';
COMMENT ON COLUMN contact.telephone_number_types.long_description IS 'goes into greater detail about the telephone number type';
COMMENT ON TABLE contact.telephone_number_types IS
    'contains information about supported telephone number types';
-- TODO: Add seed data.

-- DROP TABLE contact.personal_email_types

CREATE TABLE contact.personal_email_types
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  short_description CHARACTER VARYING(16) NOT NULL,
  long_description TEXT NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN contact.personal_email_types.code IS 'is the code that identifies the email type';
COMMENT ON COLUMN contact.personal_email_types.short_description IS 'briefly describes the email type';
COMMENT ON COLUMN contact.personal_email_types.long_description IS 'goes into greater detail about the email type';
COMMENT ON TABLE contact.personal_email_types IS
    'contains information about supported email types';
-- TODO: Add seed data.

-- DROP TABLE contact.social_media

CREATE TABLE contact.social_media
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  short_description CHARACTER VARYING(16) NOT NULL,
  long_description TEXT NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN contact.social_media.code IS 'is the code that identifies the social media outlet';
COMMENT ON COLUMN contact.social_media.short_description IS 'briefly describes the social media outlet';
COMMENT ON COLUMN contact.social_media.long_description IS 'goes into greater detail about the social media outlet';
COMMENT ON TABLE contact.telno_types IS
    'contains information about supported social media outlets';
-- TODO: Add seed data.

-- DROP TABLE contact.web_address_protocols;

CREATE TABLE contact.web_address_protocols
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  formal CHARACTER VARYING(255) NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN contact.web_address_protocols.code IS 'is the code that identifies the protocol';
COMMENT ON COLUMN contact.web_address_protocols.formal IS 'the protocol as it appears in a URL';
COMMENT ON TABLE contact.web_address_protocols IS
    'contains information about known web protocols';
-- SEED DATA: contact.web_address_protocols
INSERT INTO contact.web_address_protocols(code, formal) VALUES ('HTTP', 'http');
INSERT INTO contact.web_address_protocols(code, formal) VALUES ('HTTPS', 'https');
