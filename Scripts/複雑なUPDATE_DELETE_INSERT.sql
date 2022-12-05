use day_10_14_db;

select database();


-- サブクエリ（UPDATE）--------------------------------------
select * from employees e ;
#普通のUPDATE
update employees set age = age+1 where id =1;

select * from employees e ;

#サブクエリを利用

select * from departments d ;

select *
from employees e
where
	e.department_id = (select id from departments d where name = "営業部")
;

select * from employees e  ;
#営業部の人の年齢を＋２
#上の （select * from）部分をUPDATEに書き換える
update employees e
set e.age = e.age+2
where
	e.department_id = (select id from departments d where name = "営業部")
;

select * from employees e  ;

-- JOINとUPDATE ----------------------------------------------------------------

select * from employees e ;
alter table employees add department_name varchar(255);
select * from employees e ;
select * from departments d ;

# left join
select e.*, COALESCE(d.name, "不明") from employees e 
left join departments d 
	on e.department_id = d.id 
;

# update(select * from をUPDATEにしてset文を追加)
update employees e 
left join departments d 
	on e.department_id = d.id 
set e.department_name = COALESCE(d.name, "不明")
	;

select * from employees e ;


-- WITHとUPDATE -----------------------------------------

select * from stores;
alter table stores add all_sales int;
select * from stores;

#全売り上げを合計した値を格納したい
select * from items;
select * from  orders o ;

with tmp_sales as (
	select
		i.store_id ,
		sum(o.order_amount * o.order_price) as amount
	from items i 
	inner join orders o 
		on i.id = o.item_id 
	group by i.store_id 
)
select * from stores s
inner join tmp_sales ts
	on s.id = ts.store_id
;

# update(select * from をupdateにして最後にset文を追加)
with tmp_sales as (
	select
		i.store_id ,
		sum(o.order_amount * o.order_price) as amount
	from items i 
	inner join orders o 
		on i.id = o.item_id 
	group by i.store_id 
)
update stores s
inner join tmp_sales ts
	on s.id = ts.store_id
set s.all_sales = ts.amount
;

select * from stores s ;


-- DELETEとサブクエリ-----------------------------------

select * from employees e
where department_id in (
	select id from departments d WHERE name = "開発部"
)
;

# select * fromをdeleteにかえるだけ
delete from employees e
where department_id in (
	select id from departments d WHERE name = "開発部"
)
;
select * from employees e ;


-- INSERTとサブクエリ ------------------------------------------------------

select * from customers c ;
select * from orders o ;

select
	concat(c.last_name, c.first_name) as " name",
	order_date,
	o.order_amount * o.order_price as "その日の売り上げ",
	sum(o.order_amount * o.order_price) over(PARTITION by concat(c.last_name, c.first_name) order by o.order_date) as "合計売り上げ" 
from customers c 
inner join orders o 
	on c.id = o.customer_id 
;

create table customer_orders(
	name varchar(255),
	order_date date,
	sales int,
	total_sales int
);
select * from customer_orders;

# insert
insert into customer_orders
select
	concat(c.last_name, c.first_name) as " name",
	order_date,
	o.order_amount * o.order_price as "その日の売り上げ",
	sum(o.order_amount * o.order_price) over(PARTITION by concat(c.last_name, c.first_name) order by o.order_date) as "合計売り上げ" 
from customers c 
inner join orders o 
	on c.id = o.customer_id 
;

select * from customer_orders;

