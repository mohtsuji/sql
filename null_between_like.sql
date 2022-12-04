show databases;

use day_4_9_db;

show tables;

describe users;

select * from users limit 10;

SELECT  * FROM  users where name = "奥村 成美";

SELECT * FROM users WHERE birth_place = "日本";

# 実行順：from → where → order by → limit
SELECT * FROM users WHERE birth_place != "日本" ORDER BY age limit 10;

SELECT * FROM users WHERE age<50 limit 10;

describe users;

-- UPDATE 
update users set name = "奥山 成美" where id = 1;

SELECT * from users where id=1;

SELECT * FROM users order by id DESC limit 1;

DELETE FROM users WHERE id = 200;

select database();

show tables;

describe customers;

# NULLの取り出し方
select * from customers WHERE name is NULL;

# 1
select null is null;

# NULL以外
SELECT * FROM customers WHERE name is not NULL;

select * from prefectures ;

select * from prefectures where name is null;

select * from prefectures where name = "";

# between
# 年齢が5以上10以下の人のみ
SELECT * FROM users WHERE age BETWEEN 5 AND 10;

# 年齢が（5以上10以下）以外
SELECT * FROM users WHERE age not BETWEEN 5 AND 10;

-- like -----------------------------------------------------------
# % は任意の0文字以上を表す
# 村なんとかさんだけ取り出す（前方一致）
SELECT * FROM users WHERE name LIKE "村%";

# なんとか郎さんだけ取り出す（後方一致）
SELECT * FROM users WHERE name LIKE "%郎";

# 名前にaが含まれる人全員（中間一致）
SELECT * FROM users WHERE name LIKE "%a%";

#_は任意の一文字を表す
SELECT * FROM prefectures WHERE name LIKE "福_県";



