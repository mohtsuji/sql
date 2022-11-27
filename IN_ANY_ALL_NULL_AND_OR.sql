show databases;

use day_4_9_db;

# IN 
# 年齢が12か24か３6の人だけ取り出す
SELECT * FROM users WHERE age IN (12,24,36)

SELECT * FROM users WHERE birth_place  IN ("France","Germany","Italy");
# 産まれた場所がフランス，ドイツ，イタリア以外の人を抽出
SELECT * FROM users WHERE birth_place not IN ("France","Germany","Italy");


SELECT  customer_id FROM receipts;
SELECT * FROM customers WHERE id IN (SELECT  customer_id FROM receipts);
SELECT * FROM customers WHERE id IN (SELECT  customer_id FROM receipts where id<10);

show tables;

SELECT * from receipts;

# ANY,ALL

SELECT age from employees WHERE salary > 5000000 ORDER BY age desc;
SELECT age from employees WHERE salary > 5000000 ORDER BY age desc limit 1;
# 年収が500万以上の人たち全員よりも年齢が高い人のみ抽出（要するに45歳以上）
SELECT * FROM users WHERE age > all(SELECT age from employees WHERE salary > 5000000);
SELECT * FROM users WHERE age > all(SELECT age from employees WHERE salary > 5000000) order by age;

SELECT age from employees WHERE salary > 5000000 ORDER BY age limit 1; # 23
# 年収が500万以上の人たちのいずれかよりも年齢が高い人のみ抽出（要するにこの中で一番若い人よりも年齢が上だと抽出される）
SELECT * FROM users WHERE age > any(SELECT age from employees WHERE salary > 5000000);
SELECT * FROM users WHERE age > any(SELECT age from employees WHERE salary > 5000000) order by age;

# allの場合は=は使えない（全員と等しい人はいないので意味がない）
SELECT * FROM users WHERE age = all(SELECT age from employees WHERE salary > 5000000) order by age;
SELECT * FROM users WHERE age = any(SELECT age from employees WHERE salary > 5000000) order by age;


# AND,OR

SELECT * FROM employees ;
SELECT * FROM employees WHERE department = ' 営業部 ';
SELECT * FROM employees WHERE department = ' 営業部 ' AND name like "%田%" AND age < 35;
SELECT * FROM employees WHERE department = ' 営業部 ' AND (name like "%田%" OR name like "%西%");

#開発部か営業部の人を抽出
SELECT * FROM employees WHERE department = " 営業部 " OR department = " 開発部 ";
# INでかくならこうなる
SELECT * FROM employees WHERE department IN (" 営業部 ", " 開発部 ");

# 営業部以外の人（NOT = 直後の否定)
SELECT * FROM employees WHERE not department = " 営業部 ";

# 出力 = NULL
select NULL = "Taro";
# 出力 = NULL
select NULL != "Taro";
# 出力 = NULL
select NULL = NULL;
# 出力 = 1
select NULL is NULL;
# 出力 = 0
select NULL is not NULL;

SELECT * FROM  customers  WHERE name is NULL;
# AかBかCのいずれか
SELECT * FROM  customers  WHERE name in ("Taro", "Jiro", NULL);

# ""=NULLはNULLになるので，すべてtrueにならず，なにもでてこない
SELECT * FROM  customers  WHERE name not in ("Taro", "Jiro", NULL);

# AでもBでもCでもない
SELECT * FROM  customers  WHERE name not in ("Taro", "Jiro", "河野 文典");
SELECT * FROM  customers  WHERE name in ("Taro", "Jiro", "河野 文典");

SELECT * FROM customers WHERE name is NULL;

#河野と稲田とNULLの人を取り出す
SELECT * FROM customers WHERE (name in ("河野 文典", "稲田 季雄") OR (name is NULL));

#河野と稲田とNULLの人以外を取り出す
SELECT * FROM customers WHERE name not in ("河野 文典", "稲田 季雄") and name is not null;

SELECT * FROM customers WHERE id < 10;
#誕生日がNULLの人がいるので，何もでてこない
SELECT * from users WHERE birth_day <= all(select birth_day FROM customers WHERE id < 10);
# 誕生日がNULLのひとをはじく
SELECT * from users WHERE birth_day <= all(select birth_day FROM customers WHERE id < 10 and birth_day is not NULL);

