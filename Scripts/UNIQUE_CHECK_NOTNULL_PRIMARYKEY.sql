create database day_15_18_db;
use day_15_18_db;

select database();

show tables;

-- NOT NULL（NULLを許容しない） ------------------------------------------------------

create table users(
	id int primary key,
	first_name varchar(255),
	last_name varchar(255) default "" not NULL
);

insert into users(id) values(1);

select * from users;

create table users_2(
	id int primary key,
	first_name varchar(255),
	last_name varchar(255) not NULL,
	age int default 0
);

insert into users_2(id, first_name, last_name) values(1, "Taro", "Yamada");

select * from users_2;

insert into users_2 values(2, "Jiro", "Suzuki", NULL);

select * from users_2;


-- UNIQUE（重複を許容しない）(NULLは重複してもOK)---------------------------------------

create table login_users(
	id int primary key,
	name varchar(255) not null,
	email varchar(255) not null unique
);

insert into login_users values(1, "Shingo", "abc@mail.com");

select * from login_users;

create table tmp_names(
	name varchar(255) unique
);

insert into tmp_names values("Taro");
insert into tmp_names values(NULL);

select * from tmp_names;


-- CHECK（制約を自由に指定できる）-----------------------------------------

#年齢は２０歳以上でないといけない
create table customers (
	id int primary key,
	name varchar(255),
	age int check(age >= 20)
);

insert into customers values(1, "Taro", 21);
insert into customers values(1, "Jiro", 15); #error

select * from customers;

#複数のカラムに対する制約

create table student(
	id int primary key,
	name varchar(255),
	age int,
	gender char(1),
	constraint chk_students check((age>=15 and age <=20) and (gender = "M" or gender = "F"))
);

describe student;

insert into student values(1, "Taro", 18, "M");
insert into student values(1, "Taro", 18, "U"); # error
insert into student values(1, "Taro", 18, "F"); # error

insert into student values(NULL, "Jiro", 16, "M"); # error


-- PRIMARY KEY(NOT NULL　＋　UNIQUE）（インデックスが自動付与）----------------------------------

create table employees(
	company_id int,
	employee_code char(8),
	name varchar(255),
	age int,
	 primary key(company_id, employee_code)
	);

# primary keyの組み合わせが異なっていればOK
insert into employees values(1, 1, NULL, 1);
insert into employees values(1, 2, NULL, 1);

select * from employees;

show index from employees;




