# 算術演算子
select 1 +1;
select 3-1;

select DATABASE();
show tables;
select name, age from users limit 10;
select name, age, age+3 as age_3 from users limit 10;

select name, age, age-1 as age_1 from users;

select birth_day, birth_day +2 from users;

select * from employees ;
select department, name, salary ,salary *1.1 as salary_next_year from employees ;

select 10/3;
select salary/10 from employees ;

select 10 % 3;

# 文字の連結
select department, name from employees ;
select concat(department, ": ", name) as "部署: 名前" from employees ;
select concat(name, "(", age, ")") as "名前（年齢）" from users;


# 現在日時の表示
select now();
# 別にfrom usersであっても、usersから得られる情報しか表示できないわけではない
select now(), name, age from users;
select now(), 3+2, name, age from users;

# 日付
select curdate();

# formatを指定して日時を表示
select date_format(now(), "%Y/%m/%d");

# バイト数を数える
select length("tako");
select length("あい"); # 6

# 文字数を数える
select CHAR_LENGTH("tako");
select char_length("あい");# 2
select name, CHAR_LENGTH(name) from users;

# trim空白を削除する
select LTRIM("     ABC    ")as a;
select RTRIM("     ABC    ") as a; 
select TRIM("     ABC    ")as a; 
# 名前の長さと、前後の空白を削除した時の長さが異なる人を抽出（要するに前後に空白が入ってしまってる人）
select name, CHAR_LENGTH(name) as name_length  from employees WHERE CHAR_LENGTH(name)<>CHAR_LENGTH(TRIM(name))  ;
# updateして空白を削除する
update employees set name=trim(name) WHERE CHAR_LENGTH(name)<>CHAR_LENGTH(TRIM(name))  ;

#replate置換
SELECT REPLACE("I like apple", "apple", "lemon");

select * from users WHERE name LIKE "Mrs%";
select REPLACE(name, "Mrs", "Ms") from users WHERE name LIKE "Mrs%";
update users set name=REPLACE(name, "Mrs", "Ms") WHERE name LIKE "Mrs%";
select * from users WHERE name LIKE "Mrs%";
select * from users WHERE name LIKE "Ms%";

#小文字大文字の変換
select upper("apple");
select lower("APPLE");

select name, upper(name), lower(name) from users;

#substring文字列の切り取り
select SUBSTRING(name, 2, 3), name from employees ; 
#２文字目が田の人を取り出す
select * from employees WHERE substr(name, 2,1)="田";

# reverse逆順にする
SELECT REVERSE(name), name from employees ; 









