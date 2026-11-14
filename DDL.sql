#review 子查询

#R1（单行子查询）查工资最低的员工信息（last_name、salary）→ 预期 1 行：Olson 2100

SELECT last_name, salary
FROM employees e1 
WHERE salary = (SELECT MIN(salary)
				FROM employees);

#R2（相关子查询）查工资高于本部门平均工资的员工 → 预期 38 行

SELECT employee_id
FROM employees e1
WHERE salary > (SELECT AVG(salary)
				FROM employees e2
				WHERE e1.department_id = e2.department_id );


#数据库的创建 / 查看 / 修改 / 删除（DDL）

#D1. 创建数据库 demo_db（不指定字符集） → 验收：SHOW DATABASES; 里出现

CREATE DATABASE IF NOT EXISTS demo_db 
DEFAULT CHARACTER SET 'utf8mb4'
COLLATE 'utf8mb4_0900_ai_ci';

SHOW DATABASES;

#D2. 查看 demo_db 的建库语句 → 验收：SHOW CREATE DATABASE demo_db; 显示 utf8mb4 + utf8mb4_0900_ai_ci

SHOW CREATE DATABASE demo_db;

#D3. 创建 demo_db2，字符集 utf8mb4、排序规则 utf8mb4_unicode_ci → 验收：SHOW CREATE DATABASE demo_db2; 显示 unicode_ci
CREATE DATABASE IF NOT EXISTS demo_db2
DEFAULT CHARACTER SET 'utf8mb4'
COLLATE 'utf8mb4_unicode_ci';

SHOW CREATE DATABASE demo_db2;

#D4. 创建 demo_db3，字符集 gbk（观察旧字符集） → 验收：SHOW CREATE DATABASE demo_db3; 显示 gbk + gbk_chinese_ci

CREATE DATABASE IF NOT EXISTS demo_db3
DEFAULT CHARACTER SET 'gbk';

SHOW CREATE DATABASE demo_db3;

#D5. 把 demo_db 的字符集改成 utf8mb4、排序规则 utf8mb4_unicode_ci → 验收：SHOW CREATE DATABASE demo_db; 已变

ALTER DATABASE demo_db COLLATE 'utf8mb4_unicode_ci';
SHOW CREATE DATABASE demo_db;

#D6. 一次性列出所有 demo 开头的库的字符集（提示：查 information_schema.SCHEMATA） → 验收：3 个 demo 库 + 各自字符集

#不会

#D7. 切换到 demo_db，确认当前库 → 验收：SELECT DATABASE(); → demo_db

SELECT DATABASE();
USE demo_db;

#D8. 删除 demo_db2 → 验收：SHOW DATABASES; 里不再有它

DROP DATABASE IF EXISTS demo_db2;
SHOW DATABASES;

#D9. 删除一个不存在的库 demo_ghost，不加 IF EXISTS → 
#验收：报错 ERROR 1008 (HY000): Can't drop database 'demo_ghost'; database doesn't exist

DROP DATABASE demo_ghost;
#SQL 错误 [1008] [HY000]: Can't drop database 'demo_ghost'; database doesn't exist

#D10. 再删除一次 demo_ghost，这次加 IF EXISTS → 验收：不报错（Query OK）

DROP DATABASE IF EXISTS demo_ghost;

#D11. 重复创建 demo_db（不加 IF NOT EXISTS） → 验收：报错 ERROR 1007 (HY000): Can't create database 'demo_db'; database exists

CREATE DATABASE demo_db;
#SQL 错误 [1007] [HY000]: Can't create database 'demo_db'; database exists

#D12. 最后清理：删掉 demo_db、demo_db3 → 验收：SHOW DATABASES; 只剩系统库和原有用库

DROP DATABASE IF EXISTS demo_db;
DROP DATABASE IF EXISTS demo_db3;
SHOW DATABASES;
