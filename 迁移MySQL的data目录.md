# 迁移 MySQL 的 data 目录

将 MySQL 的 data 目录放到 /dev/mapper/centos-root 这个分区导致该磁盘满了，需要将其迁移至其他磁盘或分区来释放空间。以下是一些迁移的步骤：

## 1. 创建新的存储目录

首先，需要在其他磁盘或分区中创建一个用于存储 MySQL 数据的新目录。比如，可以在 /data/mysql 目录下创建一个新目录。

```shell
mkdir /data/mysql/data
```

注意，为了保证安全性和可靠性，新目录需要具备相应的权限，例如 MySQL 用户需要有对目录的读写权限。

## 2. 备份 MySQL 数据

在迁移数据之前，需要先对 MySQL 数据进行备份，以保护数据的完整性和安全性。可以使用 mysqldump 工具或其他第三方工具来备份 MySQL 数据库。

```shell
mysqldump -u root -p --all-databases > /data/mysql/mysql_backup_$(date +%Y%m%d).sql
```

注意，备份的文件大小可能很大，需要足够的磁盘空间来存储。

## 3. 迁移 MySQL 数据

备份完成后，可以将备份文件移动到新目录中，并将 MySQL 数据目录迁移至新目录中。可以使用 cp 命令或者 rsync 命令来复制MySQL数据目录。

```shell
cp -r /var/lib/mysql /data/mysql/data/
```

rsync 命令可以在复制数据的同时保留权限和时间戳等信息。

```shell
rsync -av /var/lib/mysql /data/mysql/data/
```

## 4. 修改 MySQL 配置文件

迁移完成后，需要修改 MySQL 配置文件中 data 目录的路径。可以使用编辑器打开 MySQL 配置文件，例如 /etc/my.cnf 或者 /etc/mysql/mysql.conf.d/mysqld.cnf，并将其中的 datadir 选项的值修改为新路径。

```shell
sudo vi /etc/my.cnf
```

```shell
[mysqld]
datadir=/data/mysql/data
```

修改完成后，保存文件并退出编辑器。

## 5. 重启 MySQL

最后，需要重启 MySQL 服务以使新的配置生效。

```shell
systemctl restart mysqld
```

完成上述步骤后，MySQL 数据就被迁移到了新目录中，可以释放原有磁盘空间，保证系统正常运行。