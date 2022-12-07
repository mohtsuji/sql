create database day_15_18_db; 

use day_15_18_db;

select database();

-- 文字列に関して --------------------------
# CHAR 固定長文字列　最大255文字まで　charsetでUTF8などの指定ができるみたい
# VARCHAR 可変長文字列　最大65,535文字まで　charsetでUTF8などの指定ができるみたい　キーを貼ったり絞り込みに利用できる
# TEXT 色んな種類がある　charsetでUTF8などの指定ができるみたい

create table messages (
	name_code char(8),
	name varchar(25),
	message text -- 65535文字まで大丈夫
);

insert into messages values("00000001", "Yoshida Takeshi", "aaaaaba");
insert into messages values("00000002", "Yoshida Yusaku", "aaaaaba");


-- 数値型 --------------------------------------

create table patients (
	id smallint unsigned primary key auto_increment, -- 0-65535
	name varchar(50),
	age tinyint unsigned -- 0-255
);

insert into patients(name, age) values("Sachilo", 34);
insert into patients(id, name) values(65535, "Tako");

select * from patients;

alter table patients modify id mediumint unsigned auto_increment; -- 0-16777215

show full columns from patients;

alter table patients add column(height float);
alter table patients add column(weight float);

insert into patients(name, age, height, weight) values("Taro", 44, 175.6789, 67.8934);
select * from patients;

-- decimal（正確な小数点表示が可能）（ただし桁数を指定しないといけない）-------------------------
# もし規定より大きい桁を整数に入れたらエラー，少数に入れたら丸められてしまう
alter table patients add column score decimal(7,3); -- 整数部が４，小数部が３


insert into patients(name, age, score) values("Jiro", 54, 32.456);
insert into patients(name, age, score) values("Jiro", 54, 32.45);

select * from patients;

-- 論理型 ---------------------------------
# BOOLEANとしたとき，MySQLでは実際にはTINYINTが使用されている

create table managers(
	id int primary key auto_increment,
	name varchar(50),
	is_superuser boolean -- これは実際にはTYNYINTが使われている
);

show full columns from managers;

insert into managers(name, is_superuser) values("Jiro", true);
insert into managers(name, is_superuser) values("Taro", false);

select * from managers;
select * from managers where is_superuser = false;

# 基本的に数値型ならTRUE, FALSE使えるぽいな　
create table test(
	id tinyint,
	int_test int
);

insert into test values(false, true);
insert into test values(false, 5);

select * from test;
select * from test where id= false;
# 1のみをTRUEとして判定してるみたい
select * from test where int_test= true;

use day_15_18_db;

select database();

-- 日付型 ---------------------------------------------------

# DATE: YYYY-MM-DD
# TIME: HH:MM:SS
# DATETIME: YYYY-MM-DD HH:MM:SS 正確な日付と時刻　基本はこっちを使ったほうが良い（タイムスタンプではなく）
# TIMESTAMP: YYYY-MM-DD HH:MM:SS 2038年問題がある　create_at, update_atで使用

#current_timestampをdefaultで設定しておくと便利
create table alerms(
	id int primary key auto_increment,
	alerm_day DATE,
	alerm_time TIME,
	create_at TIMESTAMP default current_timestamp,
	update_at TIMESTAMP default current_timestamp on update current_timestamp # updateしたときに自動でタイムスタンプが挿入
);

select CURRENT_TIMESTAMP, now(), current_date, current_time;

insert into  alerms(alerm_day, alerm_time) values("2019-01-01", "19:50:21");
insert into  alerms(alerm_day, alerm_time) values("2021/01/01", "195021");

select * from alerms;

update alerms set alerm_time = CURRENT_TIMESTAMP where id = 1; 

select hour(alerm_time), second(alerm_time),alerm_time from alerms;

# 小数点何桁まで指定するかを指定する
create table tmp_time (
	num time(5)
);

insert into tmp_time values("21:05:21.54321");

select * from tmp_time;


create table tmp_datetime_timestamp(
	val_datetime datetime,
	val_timestamp timestamp,
	val_datetime_3 datetime(3),
	val_timestamp_3 timestamp(3)
);

# みんな同じ表示になる
insert into tmp_datetime_timestamp 
	values(current_timestamp,current_timestamp,current_timestamp,current_timestamp);
insert into tmp_datetime_timestamp 
	values("2019/01/01 09:08:07","2019/01/01 09:08:07","2019/01/01 09:08:07.6543","2019/01/01 09:08:07.6543");

select * from tmp_datetime_timestamp;





