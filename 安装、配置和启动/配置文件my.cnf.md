# MySQL 数据库的配置文件 my.cnf 及其属性详细说明

## my.cnf 配置文件的位置

MySQL 配置文件的位置和名称是固定的，配置文件名是 my.cnf，它的位置和操作系统有关。
- Linux 系统：/etc/my.cnf
- Windows 系统：C:\Windows\my.ini
- Mac 系统：/usr/local/mysql/my.cnf

## my.cnf 配置文件的属性详细说明

配置文件中的属性名称和属性值是不区分大小写的，但是建议大写，这样容易识别。

### [client] 客户端程序的配置

这个属性配置的是客户端程序的配置，比如 mysql 命令行客户端程序。
```
[client]
port=3306
socket=/tmp/mysql.sock
default-character-set=utf8
```

### [mysqld] MySQL 服务器的配置

这个属性配置的是 MySQL 服务器的配置，比如 MySQL 服务器的端口、MySQL 服务器的字符集等。
```
[mysqld]
port=3306
socket=/tmp/mysql.sock
character-set-server=utf8
```

### [mysqld_safe] MySQL 服务器启动时的配置

这个属性配置的是 MySQL 服务器启动时的配置，比如 MySQL 服务器启动时的日志文件等。
```
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

### [mysql.server] MySQL 服务器启动时的配置

这个属性配置的是 MySQL 服务器启动时的配置，比如 MySQL 服务器启动时的日志文件等。
```
[mysql.server]
user=mysql
basedir=/var/lib
```

### [mysql] MySQL 客户端程序的配置

这个属性配置的是 MySQL 客户端程序的配置，比如 MySQL 客户端程序的端口等。

```
[mysql]
no-auto-rehash
default-character-set=utf8
```

### [mysqldump] 数据库备份程序 mysqldump 的配置

这个属性配置的是数据库备份程序 mysqldump 的配置，比如备份时的字符集等。
```