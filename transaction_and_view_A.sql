#review

/*
R1	建外键时，父表被参照的那一列必须是什么？	必须是主键或 UNIQUE（= 有索引）。不满足报 1822 Missing index
R2	子表插一个父表里没有的值 → ？｜父表删了还被子行引用、没写规则 → ？
	1452 Cannot add or update a child row｜1451 Cannot delete or update a parent row
	
R3	ON DELETE SET NULL 的要求	子表外键列必须允许 NULL；不满足 → 建外键直接失败 1215
R4	CHECK (age > 0) 插 age = NULL	能进。CHECK 碰到 NULL 算 UNKNOWN，MySQL 当作“不违反”
R5	加外键时 MySQL 自动干了什么？彻底删要几步？	自动给子表建一个同名索引；删两步：DROP FOREIGN KEY 名字 → DROP INDEX 名字
 * */


#transaction


CREATE DATABASE IF NOT EXISTS txn_lab;
USE txn_lab;
CREATE TABLE account (
id INT PRIMARY KEY,
name VARCHAR(20),
balance DECIMAL(10,2)
);
INSERT INTO account 
VALUES (1,'张三', 1000), (2,'李四',1000);

SELECT *
FROM account;
#T1	看 @@autocommit；UPDATE account SET balance=500 WHERE id=1;
#后立刻开一个新连接查 → 值变了吗？说明什么	能答出“默认自动提交，所以变了”

SELECT @@autocommit;

UPDATE account SET balance = 1000
WHERE id = 2;
#怎么建新连接啊，不会

#T2	START TRANSACTION → 扣 200 → 查（自己会话看得到 800）→ 
#另一连接查（看不到）→ ROLLBACK → 再查	回滚后回到 1000；另一连接全程看不到变化
BEGIN;
UPDATE account 
SET balance = balance - 200
WHERE id = 1;
ROLLBACK ;

SELECT *
FROM account;

#T3	START TRANSACTION → 扣 100（A）→ SAVEPOINT sp1 → 再扣 100（B）→ ROLLBACK TO sp1 → 查	只撤销 B，剩下 900

START TRANSACTION ;
UPDATE account
SET balance = balance - 100
WHERE id = 1;

SAVEPOINT sp1;

UPDATE account
SET balance = balance - 100
WHERE id = 1;
ROLLBACK TO sp1;
COMMIT ;
#T4 ★	双会话：两边都 SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
#然后 A START TRANSACTION 读一次；B 改并 COMMIT；A 再读一次	A 两次读到不同值 = 不可重复读

SET SESSION TRANSACTION ISOLATION LEVEL
READ COMMITTED;

START TRANSACTION;
SELECT *
FROM account;
COMMIT;

#T5 ★	同 T4，但两边改 REPEATABLE READ	A 两次读到同一值（B 提交了也看不见）= 可重复读

SET SESSION TRANSACTION ISOLATION LEVEL
REPEATABLE READ;

START TRANSACTION;
SELECT *
FROM account;
COMMIT;
#T6 ★	双会话：B 改数据但不提交；A 用 READ UNCOMMITTED 去读	A 读到 B 没提交的值 = 脏读（读完把 B ROLLBACK 掉）

SET SESSION TRANSACTION ISOLATION LEVEL
READ UNCOMMITTED;

START TRANSACTION;
SELECT *
FROM account;
COMMIT;

#T7	START TRANSACTION → 扣钱 → CREATE TABLE t_tmp(id INT); → ROLLBACK → 查 balance	扣钱没被回滚（DDL 隐式提交）

SET autocommit = 1;
SELECT @@autocommit;

SELECT *
FROM account ;

START TRANSACTION;
UPDATE account 
SET balance = balance + 100
WHERE id = 1;
CREATE TABLE t_tmp(id INT);
ROLLBACK;
#测出来了


