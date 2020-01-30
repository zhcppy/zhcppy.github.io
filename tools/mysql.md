# MySQL

```bash
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
alias mysqldump=/usr/local/mysql/bin/mysqldump
```

```bash
ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }'
mysql -h localhost -P 3306 --protocol=tcp -u root
```

* mac 上安装 mysql 8.0 程序连接会失败的问题

错误信息为: Client does not support authentication protocol requested by server; consider upgrading MySQL client

需要在mysql中修改一下密码: ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root1234'

* mac mysql terminal client

先安装mysql workbench

然后修改环境变量 echo "export PATH=$PATH:/Applications/MySQLWorkbench.app/Contents/MacOS" >> ~/.zshrc; source ~/.zshrc

* mysql Too many connections

```sql
show variables like 'max_connections';

set global max_connections = 1500;
```

* mysql 8.0 推荐使用 caching_sha2_password [DOC](https://dev.mysql.com/doc/refman/8.0/en/upgrading-from-previous-series.html#upgrade-caching-sha2-password)

```sql
ALTER USER user IDENTIFIED WITH caching_sha2_password BY 'password';

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root1234';

UPDATE mysql.user SET Password=PASSWORD('new-password-here') WHERE USER='user-name-here' AND Host='host-name-here';
```

* database backup

```bash
mysqldump -uroot -proot1234 --databases btc_prod > btc_prod.sql
```

## 命令使用

```sql
# 创建数据库
create database test_db;
# 显示所有数据库
show databases;
# 选择数据库
use test_db;
# 创建表
create table test
(id int unsigned not null auto_increment primary key,
name varchar not null);
# 向表中插入数据
insert [into] [ignore] 表名 [(列名1, 列名2, 列名3, ...)] values (值1, 值2, 值3, ...);
# 查询表中的数据
select 列名称 from 表名称 [查询条件];
# 更新表中的数据
update 表名称 set 列名称=新值 where 更新条件;
# 删除表中的数据
delete from 表名称 where 删除条件;

## 创建后对表的修改 ##
# 添加列
alter table 表名 add 列名 列数据类型 [after 插入位置];
# 修改列
alter table 表名 change 列名称 列新名称 新数据类型;
# 删除列
alter table 表名 drop 列名称;
# 重命名表
alter table 表名 rename 新表名;
# 删除表
drop table 表名;
# 删除数据库
drop database 数据库名;
# 修改 root 用户密码
mysqladmin -u root -p password 新密码;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
# TODO explain 慢查询 sql执行计划
# mysql sudo 登陆的问题
update mysql.user set authentication_string=password("root") where user="root";
update mysql.user set plugin="mysql_native_password" where user="root";
flush privileges;

# 修改表名
ALTER TABLE transaction_0s      RENAME TO transaction_0;

# 修改列名
ALTER TABLE transaction_0 DROP fee;
ALTER TABLE transaction_0 CHANGE blockhash block_hash varchar(255) DEFAULT NULL;

# mysql log
show master logs;
reset master;
PURGE BINARY LOGS BEFORE 'binlog.000196';
SHOW BINARY LOGS;

# 修改mysql密码
select host,user,plugin,authentication_string from mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root1234';
flush privileges;

# 修改mysql最大连接数
ulimit -a

show variables like "table_open_cache";

set global table_open_cache = 10000;

show variables like "max_connections";

set global max_connections = 1000;

show variables like "open_files_limit";

show global status  like 'open%';

show global status like '%Threads_connected%';

show global variables like '%timeout%';

show variables like 'log_%';
# 删除日志文件
PURGE BINARY LOGS TO 'binlog.000024';
# 统计每分钟新增数据量
select DATE_FORMAT(created_at,'%H:%i') as time, count(1) as num from vins group by DATE_FORMAT(created_at,'%H:%i');
# 统计每半小时新增数据量
select H,bigger,count(1) as num from (select DATE_FORMAT(created_at,'%H') as H,case when DATE_FORMAT(created_at,'%i')<=30 then 0 else 1 end as bigger from vins) as t group by H,bigger;

show full processlist;

show status like 'Threads%';
```
