#数值型单行函数测试
#1.ROUND 四舍五入 TRUNCATE 截取
SELECT employee_id, salary / 7, ROUND(salary / 7, 1), TRUNCATE(salary / 7, 1)
FROM employees
WHERE employee_id = 100;

#2.CEIL /FLOOR 向上/向下取整
SELECT salary / 7, CEIL(salary / 7), FLOOR(salary / 7)
FROM employees
WHERE employee_id = 100;

SELECT CEIL(-44.7), FLOOR(-44.7), ABS(-12)
FROM DUAL;

#3.ABS 绝对值
SELECT employee_id, salary, abs(3000 - salary) AS 差额#AS 是什么意思
FROM employees
WHERE employee_id IN(100, 200);

#4.MOD / % 取余
SELECT employee_id, salary % 700, MOD(salary, 700)
FROM employees LIMIT 5 OFFSET 5;

#5.RAND 随机数
SELECT RAND();

SELECT employee_id, last_name 
FROM employees
ORDER BY RAND() LIMIT 3;
#这个有点不懂啊，ORDER BY 后面不是跟的排序条件吗，排序条件是随机数是什么意思啊

#6.SIGN 判断正负
SELECT SIGN(2), SIGN(-1), SIGN(0);

#7.POW / POWER 幂函数
SELECT POW(2,3);

#8. SQRT 开方函数
SELECT SQRT(16);

#9.GREATEST 取最大值
SELECT GREATEST(12, -2, 0,4444);

#10.LEAST 取最小值
SELECT LEAST(0, 11,3);

SELECT ABS(-2), ROUND(123.456), ROUND(123.456, 0), ROUND(123.456, 1),
CEIL(44.0000001), CEILING(44.0000000001), FLOOR(44.99999999);

SELECT TRUNCATE(123.456, 0), TRUNCATE(123.456, 1);

SELECT RAND(2), RAND(), RAND(2);

