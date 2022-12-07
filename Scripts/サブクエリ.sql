-- テーブルに別名をつける

show databases;

use day_10_14_db;
select database();
show tables;

select * from classes c ;
select
	*,
	cs.name,
	cs.*
FROM 
	classes as cs;
	
-- サブクエリ（副問合せ）
show tables;
select * from employees e ;

# 部署一覧
select * from departments d ;

# INで絞り込む
select * from employees e where department_id in(1,2);

#サブクエリを使う
select id from departments d where name in("経営企画部", "営業部");

#経営企画部か営業部のdepartment_idをもつ労働者のみを抽出
select * from employees e where department_id in
	(select id from departments d where name in("経営企画部", "営業部"))
;

-- INの複数クエリ（studentsとusersの姓名を比較して一致する人のみを取り出す）
select * from students;
select * from users;

# where(A,B)in((A,B))でAとBの組み合わせが一致したものを抽出することができる
select * from users where (first_name, last_name) in(("太郎", "清水"), ("春香", "山崎"));
select * from users where (first_name, last_name) in(("太郎", "清水"), ("春香", "高橋"));

select * from students s 
where (first_name, last_name) in (
	select first_name, last_name from users
);

select * from students s 
where (first_name, last_name) not in (
	select first_name, last_name from users
);


-- 集計関数を利用したサブクエリ -------------------------------------------------------
select * from employees e ;
select max(age) from employees e ;

#  年齢が最大の人のみ抽出
select * from employees e where age=(select max(age) from employees e2 );
#  年齢が平均より若い人のみ抽出
select * from employees e where age<(select avg(age) from employees e2 );


-- FROMで用いるサブクエリ ----------------------------------------------------------
# department_idごとの年齢の平均値を取得
select department_id, avg(age) as avg_age from employees e  group by department_id ;

#from文の中で作成した新しいtable（department_idごとの年齢の平均値のtable）にはASで仮名をつけなければならない
select 
	max(avg_age) as "部署ごとの平均年齢の最大値"
from
	(select department_id, avg(age) as avg_age from employees e  group by department_id) as tmp_emp
;

# 年代ごとの集計
select floor(age/10)*10 as "年代", count(*) as "人数" from employees e 
group by floor(age/10)*10;

# 一番人数が多い年代と少ない年代を抽出
SELECT 
	max(人数), min(人数)
from
	(select floor(age/10)*10 as "年代", count(*) as "人数" from employees e 
	group by floor(age/10)*10)
	as tmp_age
;

-- SELECT文の中で用いるサブクエリ ------------------------------------------------------
select * from customers c ;
# orders tableのcustmers_idにはcustomer tableのidが入っている
select * from orders;

# customers tableに登録されている人の中で，何かをorderしたことのある人において，最も最新の注文日時を抽出
select
	c.id,
	c.first_name,
	c.last_name,
	(select max(order_date) from orders where c.id=orders.customer_id) as "最新の注文日時",
	(select min(order_date) from orders where c.id=orders.customer_id) as "最初の注文日時",
	(select sum(order_amount * order_price) from orders where c.id=orders.customer_id) as "支払総額"
from customers c 
WHERE 
	c.id < 10
;

select * from orders o ;
select order_amount * order_price as "支払い金額" from orders o ;

select * from orders where customer_id order by customer_id ;
select customer_id, max(order_date), min(order_date) from orders where customer_id group by customer_id ;


-- CASEとともに使うサブクエリ

select id from departments d where name="経営企画部";
#department_idが経営企画部の人を経営層として抽出
select 
	emp.*,
	CASE 
		when emp.department_id=(select id from departments d where name="経営企画部")
			then "経営層"
		else "その他"
	end as "役割"
from employees as emp;


select avg(payment) from salaries s ;
#平均給与よりも給与が多い人のIDを抽出
select distinct employee_id  from salaries s where payment > (select avg(payment) from salaries);

SELECT 
	e.*,
	CASE 
		when e.id in(select distinct employee_id  from salaries s where payment > (select avg(payment) from salaries))
			then "○"
		else "✗"
	END as "給料が平均より高い"
FROM 
	employees e ;


-- INSERT, CREATEと使用するサブクエリ
show tables;

select * from students s ;
#students tableの内容からtmp_students tableを作成
create table tmp_students
	select * from students s ;

select * from tmp_students;

describe students ;
#主キーの設定などは反映されないので注意
describe tmp_students ;

drop table tmp_students;

create table tmp_students
	select * from students s where id < 10;

select * from tmp_students;

#dataを追加
insert into tmp_students
	select id+9 as id, first_name , last_name ,2 as grade from users;

select * from tmp_students;

#複数のtableに記載されている名前を集めたtableを作成（UNIONなので重複は削除）
create table names
	select first_name, last_name from students s 
	union
	select first_name , last_name from employees e 
	union
	select first_name , last_name from customers c
;
select * from names;






