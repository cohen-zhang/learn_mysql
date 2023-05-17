-- 查看当前的事务： 
SELECT * FROM INFORMATION_SCHEMA.INNODB_TRX; 
-- 查看当前锁定的事务： 
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCKS; 
-- 查看当前等锁的事务： 
SELECT * FROM INFORMATION_SCHEMA.INNODB_LOCK_WAITS;
-- 查询时间超过 60s 的长事务
select * from information_schema.INNODB_TRX where TIME_TO_SEC(TIMEDIFF(now(),trx_started)) > 60;

-- 从 information_schema 中 MySQL 库表大小倒序排序

SELECT
    table_schema,
    table_name,
    table_rows,
    avg_row_length,
    data_length,
    index_length,
    round((data_length + index_length) / 1024 / 1024, 2) AS all_mb,
    round((data_length) / 1024 / 1024, 2) AS data_mb,
    round((index_length) / 1024 / 1024, 2) AS index_mb
FROM infomation_schema.tables
WHERE table_schema = 'ob_tradingdb'
ORDER BY data_length DESC;

-- 该语句会查询 information_schema.TABLES 表，从而获取所有非系统表（即不在 'mysql'、'information_schema' 和 'performance_schema' 数据库中的表）的数据量和大小，并按照数据量进行降序排列。在 CONCAT 函数中使用了 FORMAT 函数格式化数据大小，方便查看。

SELECT 
    table_schema AS '数据库名',
    table_name AS '表名',
    table_rows AS '数据量',
    avg_row_length,
    data_length,
    index_length,
    CONCAT(FORMAT(table_rows * avg_row_length / (1024 * 1024), 2), ' MB') AS '数据大小'
FROM
    information_schema.TABLES
WHERE
    table_schema NOT IN ('mysql' , 'information_schema', 'performance_schema')
ORDER BY
    data_length DESC;



-- 正在查询的 sql :合并查询，多线程 （mybatis ）
show PROCESSLIST ;
-- 杀进程
KILL 2104;

-- 查看当前正在发生的SQL事件
SELECT * from performance_schema.events_statements_current where sql_text like '%t_dict_category%';


select * from information_schema.PROCESSLIST where info is not null;



-- 查看版本
SELECT VERSION();

-- 查看 mysql.`user`，是否能使用远程连接（'%' 表示所有ip）
select * from mysql.`user`

-- 查询表结构 information_schema
SELECT TABLE_NAME, COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_COMMENT  
FROM information_schema.COLUMNS where TABLE_NAME in ('t_order');

-- 查看表的最新数据更新时间
SELECT TABLE_NAME, UPDATE_TIME FROM information_schema.TABLES where TABLE_NAME in ('t_order');
这个 UPDATE_TIME 是表结构的更新时间，不是数据更新时间，如果表结构没有变化，这个时间就不会变化。

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
mysql -e "show databases;" -h127.0.0.1 -uUser -pPassword -P3306 | grep -Ev "Database|information_schema|mysql|sys|performance_schema" | xargs mysqldump -h127.0.0.1 -uUser -pPassword -t -P3306 --all-databases > /home/archforce/mysql/all_20210109.sql

-- 选择具体的database，执行sql文件
mysql -h127.0.0.1 -uUser -pPassword -P3306 basedb < /home/archforce/mysql/all_20210109.sql
mysql -h127.0.0.1 -uUser -pPassword -P3306 < /home/archforce/mysql/all_20210109.sql
