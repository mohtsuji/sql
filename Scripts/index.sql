use day_15_18_db;

-- インデックス（検索を高速化する）-----------------------

create table student(
	id int primary key,
	name varchar(255),
	age int,
	gender char(1),
	constraint chk_students check((age>=15 and age <=20) and (gender = "M" or gender = "F"))
);

select * from student;
# indexの確認
show index from student;

insert into student values(1, "Taro", 16, "M");

# typeに注目（ALLになっていたら全検索している）（検索の仕方の詳細を表示している？）
explain select * from student where name = "Taro";

create index idx_student_name on student(name);
explain select * from student where name = "Taro";

-- 関数インデックスの作成---------------------------------
explain select * from student where lower(name) = "taro";

create index idx_student_lower_name on student((lower(name)));
explain select * from student where lower(name) = "taro";

show tables;

-- ユニークインデックス--------------------------------------------------
create table users(
	id int primary key,
	first_name varchar(255),
	last_name varchar(255) default "" not NULL
);

create unique index idx_users_uniq_first_name on users(first_name);

# ユニークインデックスなので重複不可
insert into users(id, first_name) values(3, "ABC");

show index from users;

describe users;












