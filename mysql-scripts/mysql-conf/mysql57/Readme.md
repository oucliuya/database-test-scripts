

# steps to start a mysql instance

```bash
# create mysql instance directories
mkdir -p /home/tester/mysqls/mysql3306/data
mkdir -p /home/tester/mysqls/mysql3306/tmp
#在/home/tester/mysqls/mysql3306 中创建my.cnf, 改成合适配置

# * 修改server_id
# * 修改各种路径
ln -s /home/tester/local/mysql/share /home/tester/mysqls/mysql3306/share
ln -s /home/tester/local/mysql/lib /home/tester/mysqls/mysql3306/lib


# init a new instance 
/home/tester/local/mysql/bin/mysqld --defaults-file=/home/tester/mysqls/mysql3306/my.cnf --initialize

# start server
/home/tester/local/mysql/bin/mysqld_safe  --defaults-file=/home/tester/mysqls/mysql3306/my.cnf &

# another way to start server
/home/tester/local/mysql/bin/mysqld --defaults-file=/home/tester/mysqls/mysql3306/my.cnf &

# start server without binlog 
/home/tester/local/mysql/bin/mysqld  --skip-log-bin --defaults-file=/home/tester/mysqls/mysql3306/my.cnf &


# get the init password from log file mysql.err
cat /home/tester/mysqls/mysql3306/mysqld-err.log | grep password | grep temp |tail -1 | awk '{print $NF}'

# first login with socket and the init password
mysql -uroot -S /home/tester/mysqls/mysql3306/tmp/mysql.sock --connect-expired-password -p

# change password for user root before you do any query
alter user 'root'@'localhost' identified  WITH  mysql_native_password by 'Test123';
GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY 'Test123';
flush privileges;

# create a new user with all privileges
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED WITH  mysql_native_password BY 'Password123';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';
flush privileges;
```