## 问题描述

客户 DBA 反馈期货生产环境 MySQL 所在服务器内存打满

## 问题检查

2. 检查错误日志,路径在 my.cnf 里有定义 ，比如 log-error=/var/log/mysqld.log
tail -f /var/log/mysql/error.log

3. 检查服务器资源使用状态
使用 free -m 检查

4. 主从同步检查 
在从库服务器上，检查从库同步情况，执行
mysql> show slave status\G; 
检查检查”Retrieved_Gtid_Set”和”Executed_Gtid_Set”是否一致。