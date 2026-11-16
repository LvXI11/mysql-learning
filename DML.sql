#DML增删改数据

CREATE DATABASE IF NOT EXISTS exercise;
USE exercise;
SELECT DATABASE();

#T1. 建两张表

CREATE TABLE my_employees(
Id INT(10),
First_name VARCHAR(10),
Last_name VARCHAR(10),
Userid VARCHAR(10),
Salary double(10, 2)
);

CREATE TABLE users(
id INT,
userid VARCHAR(10),
department_id INT
);

#T2. 显示 my_employees 的结构 → 验收：DESC 输出

DESC my_employees;
DESC users;

#T3. 插入 5 行到 my_employees：

INSERT INTO my_employees (Id, First_name, Last_name, Userid, Salary)
VALUES (1, 'patel', 'Ralph', 'Rpatel', 895),
	   (2, 'Dancs', 'Betty', 'Bdancs', 860),
	   (3, 'Biri', 'Ben', 'Bbiri', 1100),
	   (4, 'Newman', 'Chad', 'Cnewman', 750),
	   (5, 'ropeburn', 'Audrey', 'Aropebur', 1550);

SELECT *
FROM my_employees ;

INSERT INTO my_employees 
SET Id = 6, First_name = 'xy', Last_name = 'l', Salary = 12000, Userid = 'lxy';


#T4. 插入 users 5 行：(1,Rpatel,10) (2,Bdancs,10) (3,Bbiri,20) (4,Cnewman,30) (5,Aropebur,40) → 验收：5 行
INSERT INTO users (id, userid, department_id)
VALUES (1, 'Rpatel', 10),
	   (2, 'Bdancs', 10),
	   (3, 'Bbiri', 20),
	   (4, 'Cnewman', 30),
	   (5, 'Aropebur', 40);

INSERT INTO users 
SET id = 6, userid = 'lxy', department_id = 11;

SELECT *
FROM users;

#T5. 3 号员工 last_name 改为 drelxer → 验收：SELECT * FROM my_employees WHERE id = 3; → drelxer

UPDATE my_employees 
SET last_name = 'drelxer'
WHERE Id = 3;

#T6. 工资少于 900 的改为 1000 → 验收：895、860、750 三行变 1000；1100、1550 不变

UPDATE my_employees 
SET Salary = 1000
WHERE Salary < 900;

#T7. 删除 userid 为 Bbiri 的记录（users 和 my_employees 两个表都删） → 验收：两表各剩 4 行

DELETE FROM my_employees
WHERE Userid = 'Bbiri';

DELETE FROM users 
WHERE userid = 'Bbiri';

#T8. 删除所有数据（两表 DELETE 全清） → 验收：两表 0 行

DELETE FROM my_employees ;
DELETE FROM users;

#T9. 检查所作的修正（SELECT 查看）


#T10. 清空表 my_employees（TRUNCATE） → 验收：0 行，SHOW TABLES 表还在



#事务练习

SET autocommit = true;

#C1	SELECT @@autocommit;	1

SELECT @@autocommit;

#C2	BEGIN → INSERT 1 行 → 查 6 行 → ROLLBACK → 查 5 行	回滚生效


#C3	BEGIN → UPDATE 工资 → 查 → COMMIT → 重连再查	值保留


#C4	BEGIN → INSERT 2 行 → SAVEPOINT sp1 → INSERT 1 行 → ROLLBACK TO sp1	只回滚最后 1 行


#C5	BEGIN → INSERT 1 行 → CREATE TABLE t_imp(id INT) → ROLLBACK	插入的行还在（DDL 隐式提交）


#C6	BEGIN → TRUNCATE my_employees → ROLLBACK	回不来（0 行）


#C7	BEGIN → UPDATE 2 行 + DELETE 1 行 → ROLLBACK	数据恢复原样


#C8	SET autocommit=0 → INSERT 1 行 → 不提交断开重连	行消失；最后改回 autocommit=1

