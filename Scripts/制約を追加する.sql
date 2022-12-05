show databases;

use day_15_18_db;

select database();


select * from employees;

describe employees;

-- 既存のテーブルに制約を追加する ------------------------------------

alter table employees add constraint uniq_employees_name unique(name);

describe employees;
 
-- tableの制約一覧を確認する----------------------------------------
select
	*
from information_schema.KEY_COLUMN_USAGE
where table_name = "employees"
;


-- 制約を削除する ---------------------------------------

alter table employees drop constraint uniq_employees_name ;

#今度は２つに対して制約を課す
alter table employees add constraint uniq_employees_name unique(name, age);

describe employees;

-- tableに対するCREATE文を確認する ----------------------------------------------
show create table employees;


-- DEFAULTを追加する---------------------------------------------------

select * from customers;
describe customers;
show create table customers;

alter table customers drop constraint customers_chk_1;

alter table customers alter age set default 20;
describe customers;

insert into customers(id,name) values(2,"Jiro");
select * from customers;

-- NOT NULLを追加する-------------------------------------------------

alter table customers modify name varchar(255) NOT NULL;
describe customers;


-- CHECK制約を追加する -------------------------------------------

alter table customers add constraint check_age check(age >= 20);


-- primary keyを追加する-----------------------------------

alter table customers drop primary key;

alter table customers add constraint pk_customers primary key(id);
describe customers;


-- 外部キーを追加する----------------------------
# 外部キー
describe students;

show create table students;

#外部キーの削除
alter table students drop constraint students_ibfk_1;


alter table students add constraint fk_students foreign key(school_id) references schools(id);












