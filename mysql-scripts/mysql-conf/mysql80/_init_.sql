CREATE USER IF NOT EXISTS 'useradmin'@'localhost' IDENTIFIED WITH  mysql_native_password BY 'xxx';
GRANT ALL PRIVILEGES ON *.* TO 'useradmin'@'localhost' WITH GRANT OPTION;
ALTER USER 'useradmin'@'localhost' IDENTIFIED WITH  mysql_native_password BY 'xxx';
CREATE USER IF NOT EXISTS 'userrepladmin'@'%' IDENTIFIED WITH  mysql_native_password BY 'xxx';
GRANT REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'userrepladmin'@'%';
ALTER USER  'userrepladmin'@'%' IDENTIFIED WITH mysql_native_password BY 'xxxx';