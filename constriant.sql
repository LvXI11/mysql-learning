#review 复习 2 题（昨天：数据类型）

#R1. DESC product; 看一眼（顺便回忆每个列的类型选择理由）

DESC product;

#R2. 给 product 插一行 price = 99.999 → 查出是 100.00（DECIMAL 四舍五入）

INSERT INTO product (price)
VALUES (99.999);

SELECT *
FROM product ;


#constraint

CREATE TABLE IF NOT EXISTS emp2 (
id INT,
name VARCHAR(20));

CREATE TABLE IF NOT EXISTS dept2(
id INT,
name VARCHAR(20));

DESC emp2;
DESC dept2;

#T1. 向表 emp2 的 id 列添加 PRIMARY KEY 约束，约束名 my_emp_id_pk → 
#验收：SHOW CREATE TABLE emp2; 能看到 CONSTRAINT my_emp_id_pk PRIMARY KEY (id)

ALTER TABLE emp2 
ADD CONSTRAINT my_emp_id_pk PRIMARY KEY (id);

SHOW CREATE TABLE emp2;
#不对啊，主键只有一个自己命名也还是默认的PRIMARY KEY啊

#T2. 向表 dept2 的 id 列添加 PRIMARY KEY 约束，约束名 my_dept_id_pk

ALTER TABLE dept2
ADD CONSTRAINT PRIMARY KEY (id);
SHOW CREATE TABLE dept2;

#T3. 向 emp2 添加列 dept_id，并定义 FOREIGN KEY 约束，关联 dept2 的 id 列 →（外键今天可能还没学，学完外键再做这题）




#S1. DESC students; → 验收：id 有 PRI、name 有 NO、email 有 UNI

USE exercise;
SELECT DATABASE();

CREATE TABLE IF NOT EXISTS students (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL,
email VARCHAR(50) UNIQUE,
age INT DEFAULT 18
);

DESC students;

#S2. 插入 name = NULL → 验收：报错 1048

INSERT INTO students (name, email, age)
VALUES (NULL,'qq.com', 19);
#SQL 错误 [1048] [23000]: Column 'name' cannot be null


#S3. 插入两行相同 email → 验收：报错 1062（Duplicate entry）
INSERT INTO students (name, email, age)
VALUES ('lv','qq.com', 19),('lv','qq.com', 12);
#SQL 错误 [1062] [23000]: Duplicate entry 'qq.com' for key 'students.email'


#S4. 不写 id 插 2 行 → 验收：id 自动 1、2
INSERT INTO students (name, email)
VALUES ('lv', 'qq.com'), ('xiang', '163.com');

SELECT *
FROM students;

#S5. 删掉第 1 行再插一行 → 验收：新 id = 3（不复用 1）

DELETE FROM students 
WHERE id = 3;

INSERT INTO students (name, email)
VALUES ('yin', '162');

#S6. TRUNCATE students; 后插一行 → 验收：id 从 1 重新开始

TRUNCATE students;


#S7. 用 ALTER TABLE students ADD CONSTRAINT uk_name UNIQUE(name); 加唯一约束 → SHOW CREATE TABLE 验证

ALTER TABLE students
ADD CONSTRAINT uk_name UNIQUE(name);

SHOW CREATE TABLE students;

#S8. 建复合主键表 score(student_id INT, course_id INT, PRIMARY KEY(student_id, course_id))，插两行相同 (1,1) → 验收：报错 1062

CREATE TABLE IF NOT EXISTS score (
student_id INT,
course_id INT,
PRIMARY KEY(student_id, course_id)
);

DESC score;

INSERT INTO score (student_id, course_id)
VALUES (1,2);

SELECT *
FROM score;


#Z1 组合约束设计（1 题） 在 exercise 库建 emp_account，要求一条建表语句里全部搞定：

CREATE TABLE IF NOT EXISTS emp_account (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
phone CHAR(11) UNIQUE,
status ENUM('在职', '离职') NOT NULL DEFAULT '在职',
hire_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
salary DECIMAL(8, 2) NOT NULL DEFAULT 0
) AUTO_INCREMENT = 1000;


DESC emp_account;

ALTER TABLE emp_account
ADD CONSTRAINT uk_name_phone UNIQUE (name, phone);

INSERT INTO emp_account (name, email, phone)
VALUES ('张三','1', NULL),('张三','2', NULL);

SELECT *
FROM emp_account;

INSERT INTO emp_account (name, email, phone)
VALUES ('张三', '3', '13333333'), ('张三', '4', '13333333');
#SQL 错误 [1062] [23000]: Duplicate entry '13333333' for key 'emp_account.phone'

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'exercise'
AND TABLE_NAME = 'emp_account';

ALTER TABLE emp_account 
DROP INDEX uk_name_phone;

ALTER TABLE emp_account 
MODIFY phone CHAR(11) NOT NULL;
#SQL 错误 [1138] [22001]: Data truncation: Invalid use of NULL value

UPDATE emp_account 
SET phone = '2121'
WHERE id = 1002;

UPDATE emp_account 
SET phone = '211'
WHERE id = 1003;

SELECT *
FROM emp_account ;

ALTER TABLE emp_account 
DROP INDEX phone;

ALTER TABLE emp_account 
MODIFY phone CHAR(11) NOT NULL;

DESC emp_account;

SHOW INDEX FROM emp_account;

ALTER TABLE emp_account 
AUTO_INCREMENT = 5000;

INSERT INTO emp_account (name, email, phone)
VALUES ('李四', 'llllaw', '232302');


#外键约束

CREATE TABLE IF NOT EXISTS dept_f (
id INT PRIMARY KEY,
name VARHCAR(20) NOT NULL
);

DESC dept_f;

INSERT INTO dept_f (id, name)
VALUES (1, '研发'), (2, '测试');

SELECT *
FROM dept_f;

CREATE TABLE IF NOT EXISTS emp_f (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL,
dept_id INT,
CONSTRAINT fk_emp_f_dept_f FOREIGN KEY (dept_id) REFERENCES dept_f(id)
);

DESC emp_f;

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'exercise'
AND TABLE_NAME = 'emp_f';

INSERT INTO emp_f (name, dept_id)
VALUES ('张三', 1), ('李四', 2), ('王五', 1);

SELECT *
FROM emp_f;


#F1	建完查 COUNT(*)	3 行

#F2	插 ('赵六', 99)	被拒：父表里没有 99（1452）；表里还是 3 行

INSERT INTO emp_f (name, dept_id)
VALUES ('赵六', 99);
#SQL 错误 [1452] [23000]: Cannot add or update a child row: a foreign key constraint fails
# (`exercise`.`emp_f`, CONSTRAINT `fk_emp_f_dept_f` FOREIGN KEY (`dept_id`) REFERENCES `dept_f` (`id`))


#F3	先加部门 (3,'运维')，再把张三的 dept_id 改成 3	成功；张三 dept_id = 3

INSERT INTO dept_f (id, name)
VALUES (3, '运维');

SELECT *
FROM dept_f;

UPDATE emp_f 
SET dept_id = 3
WHERE name = '张三';

SELECT *
FROM emp_f;

#F4	把张三的 dept_id 改成 NULL	成功 —— 外键列没写 NOT NULL，NULL 不校验

UPDATE emp_f 
SET dept_id = NULL
WHERE name = '张三';

#F5	删 dept_f 里 id=2	被拒：李四还引用着它（1451）

DELETE FROM dept_f 
WHERE id = 2;
#SQL 错误 [1451] [23000]: Cannot delete or update a parent row: a foreign key constraint fails


#F6	DROP TABLE dept_f	被拒：被 emp_f 引用（3730）

DROP TABLE dept_f;
#SQL 错误 [3730] [HY000]: Cannot drop table 'dept_f' referenced by a foreign key constraint 'fk_emp_f_dept_f' on table 'emp_f'.




#级联

CREATE TABLE IF NOT EXISTS dept_g (
id INT PRIMARY KEY,
name VARCHAR(20) NOT NULL);

DESC dept_g;

INSERT INTO dept_g (id, name)
VALUES (1, 'A'), (2, 'B'), (3, 'C');

SELECT *
FROM dept_g;

CREATE TABLE IF NOT EXISTS emp_g (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL,
dept_id INT,
CONSTRAINT fk_emp_g_dept_g FOREIGN KEY (dept_id) REFERENCES dept_g(id)
);

DESC emp_g;

ALTER TABLE emp_g 
DROP FOREIGN KEY fk_emp_g_dept_g;

ALTER TABLE emp_g 
ADD CONSTRAINT fk_emp_g_dept_g FOREIGN KEY (dept_id) REFERENCES dept_g(id)
ON DELETE CASCADE ON UPDATE CASCADE;


INSERT INTO emp_g (name, dept_id)
VALUES ('a', 1), ('b', 2), ('c', 3), ('d', 3);

SELECT *
FROM emp_g;

#F7	删 dept_g 里 id=3	父表剩 2 行；emp_g 只剩 2 行（c、d 跟着没了）

DELETE FROM dept_g 
WHERE id = 3;

SELECT *
FROM dept_g;
SELECT *
FROM emp_g;

#F8	把 dept_g 的 id=2 改成 20	员工 b 的 dept_id 变成 20

UPDATE dept_g 
SET id = 20
WHERE id = 2;

#F9	建 emp_g2：结构同上，但用 ON DELETE SET NULL（dept_id 必须允许 NULL），插 3 行后删一个父行	对应员工 dept_id 变成 NULL

CREATE TABLE IF NOT EXISTS emp_g2 (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL,
dept_id INT,
CONSTRAINT fk_emp_g2_dept_g FOREIGN KEY (dept_id) REFERENCES dept_g(id)
ON DELETE SET NULL 
);

INSERT INTO dept_g (id, name)
VALUES (3, 'C'),(4,'D');
SELECT *
FROM dept_g;

INSERT INTO emp_g2 (name, dept_id)
VALUES ('e', 3),('f', 3),('g',4);
SELECT *
FROM emp_g2;

DELETE FROM dept_g 
WHERE id = 4;

SELECT *
FROM emp_g2;

#F10	查 information_schema.REFERENTIAL_CONSTRAINTS	能看到 DELETE_RULE = CASCADE
SELECT *
FROM information_schema.REFERENTIAL_CONSTRAINTS 
WHERE TABLE_NAME = 'emp_g2';

#F11	五步：① 查出 emp_g 的外键名 ② DROP FOREIGN KEY ③ SHOW CREATE TABLE 看那个 KEY 还在吗 ④
 #再删索引（索引名=外键名）⑤ 这时删 dept_g 里 id=1，还报 1451 吗	② 约束没了但 KEY 还在；③
 #索引删掉后 KEY 消失；⑤ 先预判再跑，记录你的预判 vs 实际

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS 
WHERE TABLE_NAME = 'emp_g2';

ALTER TABLE emp_g2 
DROP FOREIGN KEY fk_emp_g2_dept_g;

SHOW CREATE TABLE emp_g2;
DESC emp_g2;

SHOW INDEX FROM emp_g2;
ALTER TABLE emp_g2 
DROP INDEX fk_emp_g2_dept_g;

DELETE FROM dept_g 
WHERE id = 1;



#check
CREATE TABLE IF NOT EXISTS chk_emp (
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20) NOT NULL,
age INT CONSTRAINT ck_age CHECK (age BETWEEN 18 AND 60),
salary DECIMAL(8,2) CONSTRAINT ck_salary CHECK (salary > 0)
);

DESC chk_emp;

#F12	插 ('老张', 17, 5000) 和 ('老李', 30, -1)	都被拒，提示里带约束名 ck_age / ck_salary（3819）
INSERT INTO chk_emp (name, age, salary)
VALUES ('老张', 17, 5000), ('老李', 30, -1);
#SQL 错误 [3819] [HY000]: Check constraint 'ck_age' is violated


#F13	插 ('老王', NULL, 5000)	成功 —— CHECK 遇到 NULL 得 UNKNOWN，算通过

INSERT INTO chk_emp (name, age, salary )
VALUES ('老王', NULL, 5000);

SELECT *
FROM chk_emp ;
#F14	删掉 ck_age（想想删 CHECK 用的是 DROP CHECK 还是 DROP CONSTRAINT），再插一个 17 岁	能删成；删完 17 岁能插进
ALTER TABLE chk_emp 
DROP CHECK ck_age;

SHOW INDEX FROM chk_emp;
INSERT INTO chk_emp (name, age, salary)
VALUES ('hhhh', 17, 3);

SELECT *
FROM chk_emp;


