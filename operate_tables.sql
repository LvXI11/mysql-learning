#review DDL

#R1. 创建数据库 review_db，字符集 utf8mb4、排序规则 utf8mb4_unicode_ci → SHOW CREATE DATABASE 验证

CREATE DATABASE IF NOT EXISTS review_db
DEFAULT CHARACTER SET 'utf8mb4'
COLLATE 'utf8mb4_unicode_ci';

SHOW CREATE DATABASE review_db;

#R2. 用 information_schema.SCHEMATA 查所有 review% 库的字符集/排序规则

SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME LIKE 'review%' ;

#R3. 把 review_db 的排序规则改成 utf8mb4_0900_ai_ci（ALTER）→ SHOW CREATE 验证，最后 DROP 掉

ALTER DATABASE  review_db
COLLATE 'utf8mb4_0900_ai_ci' ;

SHOW CREATE DATABASE review_db; 

DROP DATABASE IF EXISTS review_db;

SHOW DATABASES;


#operate_tables

#T1. 创建表 dept1：id INT(7)、name VARCHAR(25) → 验收：DESC dept1;

CREATE TABLE IF NOT EXISTS dept1 (
id INT(7),
name VARCHAR(25)
);

DESC dept1;

#T2. 将 departments 表中的数据"插入"新表 dept2（用建表复制方式：CREATE TABLE dept2 AS SELECT * FROM departments;）
# → 验收：SELECT COUNT(*) FROM dept2; ≥ 27；DESC dept2;

CREATE TABLE IF NOT EXISTS dept2
AS SELECT *
FROM departments;

SELECT *
FROM dept2;

DESC dept2;

SELECT DATABASE();

#T3. 创建表 emp5：id INT(7)、first_name VARCHAR(25)、last_name VARCHAR(25)、dept_id INT(7) → 验收：DESC emp5;

CREATE TABLE IF NOT EXISTS emp5 (
id INT(7),
first_name VARCHAR(25),
dept_id INT(7)
);

DESC emp5;

#T4. 将 emp5 的 last_name 长度增加到 50 → 验收：DESC emp5; 里 last_name 变为 varchar(50)

ALTER TABLE emp5
ADD last_name VARCHAR(25);

ALTER TABLE emp5 
DROP last_name;

ALTER TABLE emp5
ADD last_name VARCHAR(25) AFTER first_name;

ALTER TABLE emp5
MODIFY last_name VARCHAR(50);

DESC emp5;

#T5. 根据表 employees 创建 employees2（自选两种方式之一） → 验收：用 LIKE → 0 行；用 AS SELECT → 107 行（自己要能说清区别）

CREATE TABLE IF NOT EXISTS employees2
LIKE employees;

CREATE TABLE IF NOT EXISTS employees3
AS SELECT *
FROM employees;

SELECT *
FROM employees2;

SELECT *
FROM employees3;

#T6. 删除表 emp5 → 验收：SHOW TABLES; 中消失

DROP TABLE IF EXISTS emp5;

SHOW TABLES;

#T7. 将表 employees2 重命名为 emp5 → 验收：SHOW TABLES; 出现 emp5
RENAME TABLE employees2 TO emp5;

SHOW TABLES;


#T8. 在表 dept1（原文写 dept，若报"表不存在"用 dept1）和 emp5 中添加新列 test_column，并检查 → 验收：DESC dept1; DESC emp5; 都有 test_column
ALTER TABLE dept1 
ADD test_colum INT(2);

ALTER TABLE emp5 
ADD test_colum INT(2);

DESC dept1;
DESC emp5;

#T9. 直接删除 emp5 中的列 dept_id → 验收：DESC emp5; 里没有 dept_id

#这是错的吧，emp5里没有这个列（因为前面改了）


#补充题

#S1.（数据类型选型） 建表 students： 学号 CHAR(5)、姓名 VARCHAR(20)、性别 CHAR(1)、生日 DATE、身高 DECIMAL(4,1)、
#简介 TEXT、创建时间 DATETIME DEFAULT CURRENT_TIMESTAMP → 验收：DESC students; 类型全对
USE student_course;
SELECT DATABASE();

CREATE TABLE students (
id CHAR(5),
name VARCHAR(20),
gender CHAR(1),
birthday DATE,
height DECIMAL(4,1),
introduce TEXT,
create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DESC students;


#S6.（TRUNCATE 清空） 对 emp_c2 执行 TRUNCATE，再查 → 验收：SELECT COUNT(*) FROM emp_c2; = 0；SHOW TABLES; 表还在（结构没删）

USE myemployees;

SELECT *
FROM employees3;

TRUNCATE TABLE employees3;

