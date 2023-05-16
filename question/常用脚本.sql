-- 查看当前的事务：
SELECT * FROM INFORMATION_SCHEMA.INNODB_TRX;
-- 查看当前锁定的事务：
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCKS;
-- 查看当前等锁的事务：
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS;
-- 查询时间超过 60s 的长事务
select * from information_schema.INNODB_TRX where TIME_TO_SEC(TIMEDIFF(now(),trx_started)) > 60;


-- 正在查询的 sql :合并查询，多线程 （mybatis ）
show PROCESSLIST ;
-- 杀进程
KILL 2104;

-- 查看当前正在发生的SQL事件
SELECT * from performance_schema.events_statements_current where sql_text like '%t_dict_category%';


select * from information_schema.PROCESSLIST where info is not null;



-- 查看版本
SELECT VERSION();

-- 查看 mysql.`user`
select * from mysql.`user`

-- 查询表结构 information_schema
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_COMMENT
FROM information_schema.COLUMNS where TABLE_NAME in ('t_order');

-- 查看表的建表语句
show CREATE TABLE ob_tradingdb.t_order;


--------------------------------
-- dml 操作行级锁的等待时间
show VARIABLES like '%innodb_lock_wait_timeout%';
-- 隔离级别
show VARIABLES like 'transaction_isolation';
-- 最大可链接数
show VARIABLES like '%connections%';
SELECT user,max_user_connections from mysql.user where user = 'User';

-- 查看引擎
show ENGINES;

-- 开启日志模式 (会导致 general_log.CSV 非常大)
-- set GLOBAL log_output = 'TABLE';  SET GLOBAL general_log = 'ON';
-- set GLOBAL log_output = 'TABLE';  SET GLOBAL general_log = 'OFF';

select * from mysql.general_log order by event_time desc;

select * from performance_schema.metadata_locks;
select * from  information_schema.TABLES;

-- 时间比较

select * FROM ob_tradingconfigdb.t_calendar
WHERE physical_date >= STR_TO_DATE('2021-01-01','%Y-%m-%d') AND physical_date <= STR_TO_DATE('2021-12-31','%Y-%m-%d');

select * from ob_tradingconfigdb.t_ors_business_rule where UNIX_TIMESTAMP(add_time )> UNIX_TIMESTAMP('2020-11-11 18:00:00');


-- 设置mysql最大可执行的sql文件大小
show global VARIABLES like 'max_allowed_packet';
set global max_allowed_packet = (1024*1024*1024)


-- 自增主键 初始值设置
-- alter table ob_tradingconfigdb.t_ors_special_order_routing AUTO_INCREMENT = 12;
-- truncate table ob_tradingconfigdb.t_ors_special_order_routing;



-- 数据库备份
-- 指定库
mysql -e "show databases;" -h127.0.0.1 -uUser -pPassword -P3306 | grep -Ev "Database|information_schema|mysql|sys|performance_schema" | xargs mysqldump -h127.0.0.1 -uUser -pPassword -t -P3306 --databases ob_basedb ob_tradingconfigdb ob_riskdb > /home/archforce/mysql/all_20210109.sql


-- 查看 MySQL 数据库表的大小并降序排列
SELECT table_schema AS '数据库名', table_name AS '表名', round(((data_length + index_length) / 1024 / 1024), 2) AS '表大小(MB)' FROM information_schema.TABLES WHERE table_schema = 'ob_tradingconfigdb' ORDER BY (data_length + index_length) DESC;
