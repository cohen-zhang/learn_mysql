-- 数据库备份
-- 指定库
mysql -e "show databases;" -h127.0.0.1 -uUser -pPassword -P3306 | grep -Ev "Database|information_schema|mysql|sys|performance_schema" | xargs mysqldump -h127.0.0.1 -uUser -pPassword -t -P3306 --databases ob_basedb ob_tradingconfigdb ob_riskdb > /home/archforce/mysql/all_20210109.sql
mysql -e "show databases;" -h127.0.0.1 -uUser -pPassword -P3306 | grep -Ev "Database|information_schema|mysql|sys|performance_schema" | xargs mysqldump -h127.0.0.1 -uUser -pPassword -t -P3306 --all-databases > /home/archforce/mysql/all_20210109.sql

-- 指定库忽略表
mysqldump -hlocalhost -P3306 -ubos -p --routines --set-gtid-purged=OFF --databases appconfigdb cm_basedb cm_bosgwdb cm_clearingdb cm_dpdb cm_exportdb cm_importdb cm_tradingconfigdb cm_tradingdb mddb operationdb userdb --ignore-table=operationdb.t_audit_operation_log --ignore-table=operationdb.t_endofday_log --ignore-table=operationdb.t_error_log --ignore-table=operationdb.t_heartbeat_time --ignore-table=operationdb.t_indicator_la > /home/archforce/atp_bos_yyyymmdd.sql

-- 把select脚本查询的结果导出到 .sql 文件
mysql -h127.0.0.1 -uUser -pPassword -P3306 -e "select * from ob_tradingconfigdb.t_ors_special_order_routing" > /home/archforce/mysql/all_20210109.sql

-- 执行sql文件, 使用 select concat 拼接成 insert 语句，并使用 'into outfile' 把结果集输出到 .sql 文件
select * from ob_tradingconfigdb.t_ors_special_order_routing into outfile '/home/archforce/mysql/all_20210109.sql';

-- 清除表数据
TRUNCATE TABLE ob_tradingconfigdb.t_ors_special_order_routing;

-- 把select脚本查询的结果导出到 .scv 文件
-- sed 's/\t/,/g' 的含义为：把制表符替换成逗号
mysql -h127.0.0.1 -uUser -pPassword -P3306 -e "select * from ob_tradingconfigdb.t_ors_special_order_routing" | sed 's/\t/,/g' > /home/archforce/mysql/all_20210109.csv

-- 从一张表查出部分字段，插入到另一张表
insert into ob_tradingconfigdb.t_ors_special_order_routing (id, routing_name, routing_type, routing_value, routing_status, add_time, update_time) select id, routing_name, routing_type, routing_value, routing_status, add_time, update_time from ob_tradingconfigdb.t_ors_special_order_routing where id = 1;

-- 使用 load data 执行 .sql 文件
load data infile '/home/archforce/mysql/all_20210109.sql' into table ob_tradingconfigdb.t_ors_special_order_routing;

-- 查询 t_user_assets_unit 表所有数据，再拼接成 insert 语句插入到 t_data_rights 表
select concat("insert into t_data_rights (id, data_rights_code, user_name, data_rights_type, add_user, add_time, update_user, update_time) values (", id, ", ", permission_type, ", '", user_name, "', '", assets_unit, "', '", add_user, "', '", add_time, "', '", update_user, "', '", update_time, "');") from t_user_assets_unit;

-- 选择具体的database，执行sql文件
mysql -h127.0.0.1 -uUser -pPassword -P3306 basedb < /home/archforce/mysql/all_20210109.sql
mysql -h127.0.0.1 -uUser -pPassword -P3306 < /home/archforce/mysql/all_20210109.sql

-- MySQL导出数据为csv的方法
select * from test into outfile '/tmp/test.csv' fields terminated by ","  escaped by '' optionally enclosed  by ''   lines terminated by '\n' ;
————————————————
版权声明：本文为CSDN博主「zhaixing_0307」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_43931358/article/details/111224558

-- 如果要看到字段名字
mysql> select * into outfile '/tmp/test1.csv' fields terminated by ',' escaped by '' optionally enclosed  by '' lisnes terminated by '\n' from (select 'col1','col2','col3','col4','col5' union select id,user,url,name,age  from test) b;



