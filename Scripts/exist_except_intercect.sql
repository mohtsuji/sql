use day_10_14_db;

select database();

select * from departments d ;
select * from employees e ;

-- EXISTS ------------------------------------------------------------------------
select * from employees e 
	where EXISTS(
		select * from departments d where e.department_id=d.id
	)
;
#1でもよい
select * from employees e 
	where EXISTS(
		select 1 from departments d where e.department_id=d.id
	)
;
#うえってこれと一緒じゃないの？
select * from employees e 
	where e.department_id =(
		select department_id  from departments d  where e.department_id=d.id
	)
;
#INを使った書き方(EXISTSは基本INで代替できるが，EXISTSのほうがパフォーマンスが良い)
select * from employees e 
	where e.department_id in (select id from departments d);

# 更に絞り込む
select * from departments d where d.name in ("営業部", "開発部");

select * from employees e 
	where EXISTS (
		select * from departments d where d.name in ("営業部", "開発部")
		and
		e.department_id =d.id
	)
;


select * from customers c 
	where exists(select * from orders o where c.id=o.customer_id and o.order_date="2020-12-31");

select * from customers c 
	where not exists(select * from orders o where c.id=o.customer_id and o.order_date="2020-12-31");

#manager_idが存在する人を抽出
select * from employees e ;

select * from employees e 
	where exists(select 1 from employees e2 where e2.manager_id =e.id)
;


-- NULLとEXISTS ------------------------------------------------------------------------

# not existsの場合，TRUE以外を返すので，結果がNULLになるものも抽出される
# not inの場合，FALSEを返すので，結果がNULLになるものは抽出されない

#条件のすべてがTRUEの人のみ抽出
select * FROM customers c
	where exists
		(select * from customers_2 c2 where
			c.first_name = c2.first_name
			AND 
			c.last_name = c2.last_name
			AND 
			c.phone_number =c2.phone_number 
		)
;

#２つの条件がTRUEで，かつ，下の条件がTRUEまたは電話番号が両方ともNULLの人を抽出
select * FROM customers c
	where exists
		(select * from customers_2 c2 where
			c.first_name = c2.first_name
			AND 
			c.last_name = c2.last_name
			AND 
			c.phone_number =c2.phone_number OR (c.phone_number is NULL and c2.phone_number is NULL)
		)
;

#全条件がTRUEの人以外を抽出（結果がNULLも抽出）
select * FROM customers c
	where not exists
		(select * from customers_2 c2 where
			c.first_name = c2.first_name
			AND 
			c.last_name = c2.last_name
			AND 
			c.phone_number =c2.phone_number 
		)
;

#条件のすべてがTRUEの人のみ抽出
select * FROM customers c
	where (first_name, last_name, phone_number) in
		(select first_name , last_name , phone_number  from customers_2)
;

#条件のいずれかがFALSEの人を抽出
# first_name != c2.first_name OR last_name != c2.last_name OR phone_number != c2.phone_number
select * FROM customers c
	where (first_name, last_name, phone_number) not in
		(select first_name , last_name , phone_number  from customers_2 c2)
;


-- EXCEPT（ある集合と別の集合の差を求める）------------------------------------------------

#EXCEPT(MINUS)をEXITSで記述する（一方の集合から，もう一方の集合に存在するレコードを除外して抽出する）
select * from customers c 
union
select * from customers_2 c2 ;

#cの中で，c2とかぶっていないものだけを取り出す(phone_numberはNULLが含まれるので，どっちもNULLのやつも除外してあげる）
select * from customers c 
	where not exists (
		select * from customers_2 c2 
			WHERE 
				c.id= c2.id AND 
				c.first_name = c2.first_name AND 
				c.last_name = c2.last_name AND 
				c.phone_number = c2.phone_number OR (c.phone_number is NULL and c2.phone_number is null) AND 
				c.age = c2.age 
	)
;


-- INTERCECT（ある集合と別の集合の積集合（一致するもの）だけを取り出す）---------------------
#INTERCECTをEXITSで記述する

select * from customers c 
	where exists (
		select * from customers_2 c2 
			WHERE 
				c.id= c2.id AND 
				c.first_name = c2.first_name AND 
				c.last_name = c2.last_name AND 
				c.phone_number = c2.phone_number OR (c.phone_number is NULL and c2.phone_number is null) AND 
				c.age = c2.age 
	)
;




