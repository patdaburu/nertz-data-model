-- Database: nertz_core

-- DROP DATABASE "nertz_core";

CREATE DATABASE nertz_core
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_US.UTF-8'
       LC_CTYPE = 'en_US.UTF-8'
       CONNECTION LIMIT = -1;

COMMENT ON DATABASE nertz_core
  IS 'This is the core Nertz database.';
