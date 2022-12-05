use day_15_18_db;

-- AUTO INCREMENT（値をNULLでINSERTしたときに自動的に１からカウントアップされた値が挿入される）---------------------------

create table animals(
	id int primary key auto_increment comment '主キーのIDです',
	name varchar(50) not null comment '動物の名前です'
);

insert into animals values(null, "Dog");
select * from animals;

insert into animals(name) values("Cat");
select * from animals;

-- 自動的に挿入される値が何になるかの確認
select AUTO_INCREMENT from information_schema.tables where table_name = "animals";

insert into animals values(4, "tako");
select * from animals;

#4が最大なので次は５になる
insert into animals(name) values("neko");
select * from animals;

-- 自動挿入の開始する値を指定（この場合１００から順に挿入されていく）
alter table animals auto_increment = 100;

insert into animals(name) values("bird");
select * from animals;

#いっぺんにINSERTするときに便利（勝手に番号振ってくれるから）
insert into animals(name)
select "Snake"
union all
select "Dino"
union all
select "Gibra";

select * from animals;

insert into animals(name)
select name from animals;

select * from animals;


-- commentのかくにんする ----------------------------------------------------------

show full columns from animals;


show table status;



















