-- Schema: db

-- DROP SCHEMA db CASCADE;

CREATE SCHEMA db
  AUTHORIZATION postgres;

COMMENT ON SCHEMA db
  IS 'This schema contains common database objects.';

-- DROP TABLE db.version;
CREATE TABLE db.version
(
  part character varying(16) PRIMARY KEY NOT NULL,
  number INTEGER NOT NULL
)
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN db.version.part IS 'is the version number part (major, minor, revision, or build)';
COMMENT ON COLUMN db.version.number IS 'is the number of the version number part';
-- TODO: Create a function to set and retrieve the version.
-- TODO: LImit write access to the version table.
INSERT INTO db.version(part, number) VALUES('major', 0);
INSERT INTO db.version(part, number) VALUES('minor', 0);
INSERT INTO db.version(part, number) VALUES('revision', 0);
INSERT INTO db.version(part, number) VALUES('build', 0);


-- DROP TABLE db.entities;

CREATE TABLE db.entities
(
   created_by uuid NOT NULL, 
   created_at timestamp with time zone NOT NULL, 
   last_updated_at timestamp with time zone NOT NULL, 
   last_updated_by uuid NOT NULL,
   active boolean NOT NULL DEFAULT TRUE
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN db.entities.id IS 'uniquely defines the entity';
COMMENT ON COLUMN db.entities.created_by IS 'is the identifier of the User that created the record';
COMMENT ON COLUMN db.entities.created_at IS 'is a timestamp that indicates when the record was created';
COMMENT ON COLUMN db.entities.last_updated_at IS 'is a timestamp that indicates when the record was last updated';
COMMENT ON COLUMN db.entities.last_updated_by IS 'identifies the User that last updated the record';
COMMENT ON TABLE db.entities
  IS 'common parent for entity tables; it defines instantaneous information about row status, creation and updates';

-- DROP TABLE db.friendly_user_id_origins;

CREATE TABLE db.friendly_user_id_origins
(
   code character varying(8) PRIMARY KEY NOT NULL, 
   short_description character varying(255) NOT NULL, 
   long_description text NOT NULL,
   format character varying(255) NOT NULL
) 
WITH (
  OIDS = FALSE
)
;
COMMENT ON COLUMN db.friendly_user_id_origins.code IS 'identifies the origin of a user ID (generally, the internal or external system to which the ID is known)';
COMMENT ON COLUMN db.friendly_user_id_origins.short_description IS 'a short description';
COMMENT ON COLUMN db.friendly_user_id_origins.long_description IS 'a long description';
COMMENT ON TABLE db.friendly_user_id_origins
  IS 'supported user id origin systems';

-- DROP TABLE db.sys_user_roles;

CREATE TABLE db.sys_user_roles
(
   code character varying(16) PRIMARY KEY NOT NULL, 
   short_description character varying(255) NOT NULL, 
   long_description text NOT NULL,
   format character varying(255) NOT NULL
) INHERITS (db.entities) 
WITH (
  OIDS = FALSE
) 
;
COMMENT ON COLUMN db.sys_user_roles.code IS 'identifies a kind of user role';
COMMENT ON COLUMN db.sys_user_roles.short_description IS 'a short description';
COMMENT ON COLUMN db.sys_user_roles.long_description IS 'a long description';
COMMENT ON TABLE db.sys_user_roles
  IS 'defined system roles';


-- DROP TABLE db.sys_users;

CREATE TABLE db.sys_users
(
   id uuid PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
   friendly_id character varying(16) NOT NULL,
   friendly_id_origin character varying(8) NOT NULL 
    REFERENCES db.friendly_user_id_origins(code)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
   person_id uuid NOT NULL, -- The People relation has not yet been created.
   CONSTRAINT sys_users__friendly_id_and_friendly_id_origin__unique UNIQUE(friendly_id, friendly_id_origin)
) INHERITS (db.entities)
WITH (
  OIDS = FALSE
) 
;
COMMENT ON COLUMN db.sys_users.id IS 'uniquely identifies System Users';
COMMENT ON COLUMN db.sys_users.friendly_id IS 'is a friendly (i.e. recognizable to a human) user id';
COMMENT ON COLUMN db.sys_users.friendly_id_origin IS 'identifies the system of origin of the friendly id';
COMMENT ON COLUMN db.sys_users.person_id IS 'is the id of the Person associated with the User';

-- DROP TABLE db.sys_users_sys_user_roles

CREATE TABLE db.sys_users_sys_user_roles
(
   user_id uuid NOT NULL 
     REFERENCES db.sys_users(id)
       ON DELETE CASCADE 
       ON UPDATE CASCADE,
   user_role_code character varying(16)
     REFERENCES db.sys_user_roles(code)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   CONSTRAINT sys_users__sys_user_roles__unique UNIQUE(user_id, user_role_code)
)
WITH (
  OIDS = FALSE
);
COMMENT ON COLUMN db.sys_users_sys_user_roles.user_id IS 'is the User id';
COMMENT ON COLUMN db.sys_users_sys_user_roles.user_id IS 'is the User Role id';
COMMENT ON TABLE db.sys_user_roles
  IS 'matches Users to User Roles';






