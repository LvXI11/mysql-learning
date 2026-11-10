#1.CONCAT / CONCAT_WS 拼接
SELECT CONCAT(first_name, ' ', last_name) AS 全名
FROM employees;

SELECT CONCAT_WS('-', first_name, last_name) AS 全名2
FROM employees;

SELECT CONCAT('abc', NULL);

#2.LENGTH / CHAR_LENGTH 获取长度
SELECT LENGTH('数据库') AS 字节数, CHAR_LENGTH('数据库') AS字符数;

#3.LEFT /RIGHT / SUBSTR 截取子串
SELECT employee_id, email, LEFT(email, 3), RIGHT(email, 2), SUBSTR(email, 2, 2)
FROM employees LIMIT 5;

#4. INSTR 子串在主串中的位置
SELECT INSTR('database', 'base'), INSTR('hello', 'z');

#5. UPPER / LOWER /REPLACE / TRIM 大小写转换 / 替换字符串中的字符 / 去除首末的空格
SELECT UPPER('Hello'), LOWER('hELLO'), REPLACE('a-b-c', '-', '+'), CONCAT('---', TRIM('    hell  o  '), '---');

#6. LPAD / RPAD 补位（对齐）
SELECT employee_id, LPAD(employee_id, 5, '0') AS 补零工号
FROM employees LIMIT 5;

SELECT salary, LPAD(salary, 10, '*'), RPAD(salary, 10, '')
FROM employees;