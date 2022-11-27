select database();

use my_db;

create table people(
	id int primary key,
	name varchar(50),
	birth_day date default "1990-01-01" #何も指定しなかったら1990-01-01が入る
);

show tables;

insert into people
values(1, "Taro", "2001-01-01");

select * from people;

#  カラムを指定してinsert
INSERT into people(id, name)
values(2, "Jiro");

# シングルクォーテーションでもよい
insert into people(id, birth_day)
values(3, '2002-01-01');

# シングルクォーテーションを中で使いたいときは，2回重ねる
insert into people
values(4, 'John''s son', '2020-01-01');

# シングルクォーテーションの中にダブルクォーテーションを入れるのはそのままでよい
insert into people
values(5, 'John"s son', '2020-01-01');

show tables;

# 全レコードを表示
select * from people;

# カラムの一部を指定して表示
select id, birth_day, name, name from people;

# カラム名を変更して表示
select id as "番号", name as '名前' from people;

# 条件を指定して表示
select * from people
where id <= 2;

select * from people
where name = "Taro";

#  全レコードを変更
UPDATE people set birth_day=NULL, name="";
select * from people;
describe people;

# カラムの定義変更
alter table people 
modify name varchar(50) default "nanashi";

# 変更するレコードを指定
update people set name="Taro", birth_day="2000-10-10"
where id > 4;

# レコードの削除
delete from people where id>4;

# 全部のレコードを削除
delete from people;
















