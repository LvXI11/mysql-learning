#review DML + DDL

#R1. 建表 r1(id INT, name VARCHAR(20))，插 2 行，UPDATE 第一行 name，SELECT 验证

SELECT DATABASE();

CREATE TABLE IF NOT EXISTS r1 (
id INT,
name VARCHAR(20)
);

DESC r1;

INSERT INTO r1 (id, name)
VALUES (1, 'helen'), (2, 'jack');

SELECT *
FROM r1;

UPDATE r1 
SET id = 99, name = 'mery'
WHERE id = 1;

#R2. 用 LIKE 和 AS SELECT 从 employees 各复制一张表，比较行数（0 vs 107）

CREATE TABLE IF NOT EXISTS copy_table
LIKE myemployees.employees;

SELECT *
FROM copy_table;

CREATE TABLE copy_table2
AS SELECT *
FROM myemployees.employees;

SELECT *
FROM copy_table2;
#R3. 对其中一张 TRUNCATE 后验证：行数 0、表结构还在

TRUNCATE TABLE copy_table2;

#数据类型练习

#T1.设计表

CREATE TABLE product (
id INT,
name VARCHAR(50),
price DECIMAL(10, 2),
stock INT UNSIGNED,
on_sale ENUM('Y','N') DEFAULT 'Y',
created DATETIME DEFAULT CURRENT_TIMESTAMP,
descrip TEXT,
tag SET('热卖', '新品', '清仓')
);

DESC product;

#T2. 插入 1 行正常数据（不写 created，看默认值自动填）→ 验收：SELECT * 时间列自动有值
INSERT INTO product (id, name, price, stock, on_sale, descrip, tag)
VALUES (1, 'apple', '5.2', 100, 'Y', 'delicious', '热卖,清仓');

SELECT *
FROM product;

#T3.（DECIMAL 精度） 把 price 更新为 199.999 → 验收：SELECT price 显示 200.00（四舍五入到 2 位）

UPDATE product 
SET price = 199.999
WHERE id = 1;

#T4.（枚举非法值） 插入 on_sale = 'M' → 验收：报错 1265（Data truncated），插不进去

INSERT INTO product (id, name, price, stock, on_sale, descrip, tag)
VALUES (2, 'pear', 12.3333, 50, 'M', 'crisp and sweet', '热卖,新品');
#SQL 错误 [1265] [01000]: Data truncated for column 'on_sale' at row 1


#T5.（SET 多选） 把 tags 设为 '热卖,新品' → 验收：SELECT tags 显示两值；再试非法值 '清仓,打折' → 报错


INSERT INTO product (id, name, price, stock, on_sale, descrip, tag)
VALUES (2, 'pear', 12.3333, 50, 'Y', 'crisp and sweet', '清仓,打折');
#SQL 错误 [1265] [01000]: Data truncated for column 'tag' at row 1

INSERT INTO product (id, name, price, stock, on_sale, descrip, tag)
VALUES (2, 'pear', 12.3333, 50, 'Y', 'crisp and sweet', '热卖,新品');


#T7.（字符集与长度） 建 t_char(c CHAR(10), v VARCHAR(10))，插入 'abc' → 
#验收：SELECT LENGTH(c), LENGTH(v) 都是 3（CHAR 的补空格在存储层，查询自动去掉）；
#再插 10 个汉字到 v 成功、11 个汉字报 1406（Data too long）

CREATE TABLE IF NOT EXISTS t_char(
c CHAR(10),
v VARCHAR(10)
);

DESC t_char;

INSERT INTO t_char (c, v)
VALUES ('abc   ', 'abc');

SELECT LENGTH(c), LENGTH(v)
FROM t_char;

INSERT INTO t_char (v)
VALUES ('你好你好牛你好牛啊啊');

SELECT *
FROM t_char;

INSERT INTO t_char (v)
VALUES ('你好你好牛你好牛啊啊啊');
#SQL 错误 [1406] [22001]: Data truncation: Data too long for column 'v' at row 1


#T10.（CHAR vs VARCHAR 存储） 说明：CHAR(10) 存 'abc' 实际占 10 字节（补 7 个空格），VARCHAR 占 3+1；
#用 LENGTH 看不到补空格的原因是什么？（口述）

#补空格是在内存层面的，查找会自动去掉空格

#T11.（设计题） 给"订单表"选类型并建表：订单号（大整数）、金额（2 位小数）、
#状态（枚举：待支付/已支付/已发货/已完成/已取消）、下单时间（日期时间）、备注（长文本）→ 
#验收：DESC 结构合理 + 能说出每列为什么选这个类型

CREATE TABLE IF NOT EXISTS order_table(
id BIGINT UNSIGNED,
price DECIMAL(10, 2),
state SET('待支付', '已支付', '已发货', '已完成', '已取消'),
order_time DATETIME DEFAULT CURRENT_TIMESTAMP,
remark TEXT);

ALTER TABLE order_table
MODIFY state ENUM('待支付', '已支付', '已发货', '已完成', '已取消') DEFAULT '待支付';

ALTER TABLE order_table
CHANGE id order_id BIGINT UNSIGNED;

ALTER TABLE order_table
CHANGE price amount DECIMAL(10, 2);

DESC order_table;

#T12. SHOW CREATE TABLE product; 看完整建表语句（含字符集、默认值、枚举定义）

SHOW CREATE TABLE product;
