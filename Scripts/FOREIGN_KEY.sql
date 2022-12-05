
-- FOREIGN KEY 外部キー（他のテーブルと紐付けをするキー）---------------------------------------
-- 参照整合性（ちゃんと紐付け先が存在している状態）
-- 参照整合性の崩壊（紐付け先が存在しない状態）

# 外部キーの制約を守らないとエラーになる（ちゃんと参照できるように保たなければえらーになる）

show databases;

use day_15_18_db;

drop table student;

create table schools(
	id int primary key,
	name varchar(255)
);

create table students(
	id int primary key,
	name varchar(255),
	age int,
	school_id int,
	foreign key(school_id) references schools(id)
);


insert into schools values(1, "北高校");
insert into students values(1, "Taro", 18, 1);

update schools set id =2; # error（studentsとの外部キーがきれてしまうから）

delete from schools; # error(削除するときは外部キーを制約しているテーブルを先に行う)

update students set school_id = 2; #error（さんしょうさきがないから）


create table salaries(
	id int primary key,
	company_id int,
	employee_code char (8),
	payment int,
	paid_date date,
	foreign key(company_id, employee_code) references employees(company_id, employee_code)
);

select * from employees;

insert into salaries values(1, 1, 1, 1000, "2020-01-01");


describe students;

drop table students;

-- ON DELETE, ON UPDATE（DELETEやUPDATEで外部キーの制約が破られた時の挙動を設定する）--------------------

# CASCADEは参照先が削除または更新された時、自動で参照しているやつも削除（レコードごと）または更新される------------
create table students(
	id int primary key,
	name varchar(255),
	age int,
	school_id int,
	foreign key(school_id) references schools(id)
	on delete cascade on update cascade
);

insert into students values(1, "Taro", 18, 1);

select * from students;

select * from schools;
update schools set id = 3 where id = 1;

# こっちも更新されている
select * from students;

# DELETEしてみる
delete from schools;
# こっちも削除されている
select * from students;


# SET NULL（参照先がなくなったらNULLが入る）-------------------------------------------------------------
drop table students;

create table students(
	id int primary key,
	name varchar(255),
	age int,
	school_id int,
	foreign key(school_id) references schools(id)
	on delete set null on update set null
);

insert into schools values(1, "北高校");
insert into schools values(2, "南高校");

insert into students values(1, "Taro", 16, 1);
insert into students values(2, "Taro", 16, 2);

select * from students;
select * from schools;

update schools set id = 3 where id = 1;

# NULLになってる
select * from students;
select * from schools;

update students set school_id = 3 where school_id is NULL;

select * from students;
select * from schools;

delete from schools where id = 3;

# NULLになってる
select * from students;
select * from schools;


# SET DEFAULT（参照先がなくなったらデフォルト値が入る）----------------------------------------------
drop table students;

create table students(
	id int primary key,
	name varchar(255),
	age int,
	school_id int default -1,
	foreign key(school_id) references schools(id)
	on delete set default on update set default
);

select * from schools;
select * from students;

insert into schools values(1, "北高校");
insert into students values(1, "Taro", 17, 1);

select * from schools;
select * from students;

update schools set id = 3 where id = 1;




