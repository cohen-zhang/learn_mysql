# 事务隔离 Isolation

并不是所有的 MySQL 存储引擎都支持事务，比如原生的 MyISAM 就不支持事务。这也是为什么 MyISAM 被 InnoDB 取代的原因之一。

举个最经典的转账例子，假设 A 账户有 100 元，B 账户有 200 元，现在 A 要向 B 转账 50 元，那么这个转账操作就是一个事务。


## 事务的特性(AICD)

- 原子性（Atomicity）
- 一致性（Consistency）
- 隔离性（Isolation）
- 持久性（Durability）：英文读音：/dərə'bɪlətɪ/ ，和 persistence 的区别是，persistence 是指持久化，而 durability 是指持久性。

## 如果没有事务隔离，会出现哪些问题？

- 脏读：一个事务读取到了另一个事务未提交的数据
- 不可重复读：一个事务读取到了另一个事务已提交的update数据
- 幻读：一个事务读取到了另一个事务已提交的insert数据

但是，不能一味追求事务隔离级别越高越好，因为事务隔离级别越高，效率就越低，因为需要锁定更多的数据。

## 事务的隔离级别

- 读未提交（Read Uncommitted）：指在一个事务中修改了数据，另一个事务可以读取到未提交的数据，这样可能会导致脏读、不可重复读、幻读。
- **读已提交（Read Committed）**：指在一个事务中修改了数据，另一个事务要等到修改事务提交后才能读取到修改后的数据，这样可能会导致不可重复读、幻读。
- **可重复读（Repeatable Read）**：指在一个事务中读取数据，另一个事务要等到读取事务提交后才能修改数据，这样可能会导致幻读。
- 串行化（Serializable）：指在一个事务中读取数据，另一个事务要等到读取事务提交后才能修改数据，同时读取事务也要等到修改事务提交后才能读取数据，这样可以避免脏读、不可重复读、幻读。

不同数据库的默认隔离级别不同，**MySQL的默认隔离级别是可重复读**，Oracle的默认隔离级别是读已提交。



## 配置方法

启动参数： transaction-isolation
-- 查看 MySQL 的隔离级别：
mysql> show variables like 'transaction_isolation';

```sql
SELECT @@tx_isolation;

-- 可重复读
-- REPEATABLE-READ
```

以数据表 T 为例，事务 A 和事务 B 同时操作读数据表 T 的一行数据，事务 A 先执行，事务 B 修改字段值后执行。在不同隔离级别下，B 事务提交前、后，事务 A 读取到的数据是不同的。

| 隔离级别 | B事务提交前：事务 A 读取到的数据 | B事务提交后：事务 A 读取到的数据 |
| :--- | :--- | :--- |
| 读未提交 | 读取到未提交的数据 | 读取到已提交的数据 |
| 读已提交 | 读取到已提交的数据 | 读取到已提交的数据 |
| 可重复读 | 读取到已提交的数据 | 读取到已提交的数据 |
| 串行化 | 读取到已提交的数据 | 读取到已提交的数据 |

## 事务的隔离级别的实现（可重复读）

### 事务的启动

查询事务的启动方法

```sql
SHOW VARIABLES LIKE 'autocommit';
```

```sql
START TRANSACTION;
```

### 事务的提交

```sql
COMMIT;
```

### 事务的回滚

```sql
ROLLBACK;
```

### 事务的自动提交

MySQL 默认是自动提交事务的，即每条 SQL 语句都是一个事务，如果要关闭自动提交事务，可以使用以下命令：

```sql
SET autocommit=0;
```

建议你总是使用 set autocommit=1, 通过显式语句的方式来启动事务。 

用于查询持续时间超过 50 秒的长连接事务：

```sql
SELECT * FROM INFORMATION_SCHEMA.INNODB_TRX WHERE TIME_TO_SEC(timediff(now(),trx_started))>50;
```
