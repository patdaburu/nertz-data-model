-- Schema: contact

-- DROP SCHEMA contact;

CREATE SCHEMA contact
  AUTHORIZATION postgres;

COMMENT ON SCHEMA contact
  IS 'This schema contains generally visible contact information and metadata.';

-- DROP TABLE contact.telno_types

CREATE TABLE contact.telno_types
(
  code CHARACTER VARYING(8) PRIMARY KEY NOT NULL,
  short_description CHARACTER VARYING(16) NOT NULL,
  long_description TEXT NOT NULL
)
WITH (
OIDS = FALSE
);
COMMENT ON COLUMN contact.telno_types.code IS 'is the code that identifies the telephone number type';
COMMENT ON COLUMN contact.telno_types.short_description IS 'briefly describes the telephone number type';
COMMENT ON COLUMN contact.telno_types.long_description IS 'goes into greater detail about the alias type';
COMMENT ON TABLE contact.telno_types IS
    'contains information about supported telephone number types';
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