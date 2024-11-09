-- Create the databases if they do not exist
CREATE DATABASE IF NOT EXISTS modw;
CREATE DATABASE IF NOT EXISTS moddb;
CREATE DATABASE IF NOT EXISTS mod_hpcdb;
CREATE DATABASE IF NOT EXISTS mod_shredder;
CREATE DATABASE IF NOT EXISTS mod_logger;

-- Ensure the xdmod_user exists and set the password (if it hasn't been set)
CREATE USER IF NOT EXISTS 'xdmod_user'@'%';
ALTER USER 'xdmod_user'@'%' IDENTIFIED BY 'xdmod_pass';

-- Grant all privileges to xdmod_user on all required databases
GRANT ALL PRIVILEGES ON modw.* TO 'xdmod_user'@'%';
GRANT ALL PRIVILEGES ON moddb.* TO 'xdmod_user'@'%';
GRANT ALL PRIVILEGES ON mod_hpcdb.* TO 'xdmod_user'@'%';
GRANT ALL PRIVILEGES ON mod_shredder.* TO 'xdmod_user'@'%';
GRANT ALL PRIVILEGES ON mod_logger.* TO 'xdmod_user'@'%';

-- Ensure privileges are applied
FLUSH PRIVILEGES;
