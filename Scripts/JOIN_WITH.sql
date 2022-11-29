use day_10_14_db;

select database();

show tables;

-- JOIN（列方向に連結） -------------------------------------
# UNIONなどは行方向の連結だったと思う

-- INNER JOIN(内部結合：指定した条件にあったレコードのみを連結) ----------------------

# department_idを持っている
select * from employees e ;
# idを持っている(department_idと一致すべきもの)
select * from departments d ;

# eのdepartment_idとdのidが一致するように列方向の連結が行われる
# (department tableのidは4までしか存在しないのでeのdpartment_idが5の人は抽出されない)
select * from employees e 
	inner join departments d 
		on e.department_id = d.id
;

# 特定のカラムのみ抽出
select e.id, e.first_name , e.last_name , d.id as department_id , d.name as department_name from employees e 
	inner join departments d 
		on e.department_id = d.id
;

# 複数のレコードで紐付ける
select * from students s ;
select * from users;
# 姓名両方が一致した人のみ紐付けて，一致した人のみ抽出
select * from students s 
	inner join users u 
		on s.first_name =u.first_name AND s.last_name = u.last_name 
;

# =以外で紐付ける
select * from employees e 
	inner join students s 
		on e.id < s.id 
;

-- LEFT (OUTER) JOIN（外部結合：複数のテーブルを結合するが，左のテーブルはすべてのレコードを抽出し，右のテーブルは紐付けができたレコードのみ抽出する）
# RIGHT JOINは右が基準になる

select e.id, e.first_name , e.last_name , d.id as department_id , d.name as department_name from employees e 
	inner join departments d 
		on e.department_id = d.id
;

#紐付けができなかった部分についてはNULLが入る
select e.id, e.first_name , e.last_name , d.id as department_id , d.name as department_name from employees e 
	left join departments d 
		on e.department_id = d.id
;
#NULLが入る場所をcoalesce関数で，該当なしと表示するようにするとわかりやすい
select e.id, e.first_name , e.last_name , COALESCE(d.id, "該当なし") as department_id , d.name as department_name from employees e 
	left join departments d 
		on e.department_id = d.id
;

#class_idとstudent_idを持つ
select * from enrollments e ;
select * from classes c ;
select * from students s ;

select * from enrollments e 
	left join classes c 
		on e.class_id =c.id 
;

# students tableのid=33の人はenrollmentsのstudents_idがないので紐付けできず，NULLが入るのでclasses tableとの紐付けもできず，以降がすべてNULLになる
select * from students s 
	left join enrollments e 
		on s.id = e.student_id 
	left join classes c 
		on e.class_id =c.id 
;

# 一番下はclassesとenrollmentsで紐付けできなかったので，左側がすべてNULLになる
select * from students s 
	right join enrollments e 
		on s.id = e.student_id 
	right join classes c 
		on e.class_id =c.id 
;

-- FULL OUTER JOIN(MySQLにはない：結合できなかった行をNULLにする)
# UNIONを使って実現してみる

select * from students s 
	left join enrollments e 
		on s.id = e.student_id 
	LEFT join classes c 
		on e.class_id =c.id 
UNION
select * from students s 
	right join enrollments e 
		on s.id = e.student_id 
	right join classes c 
		on e.class_id =c.id
;


-- customers, orders, items, storesを紐付ける
-- customers.idで並び替える
# これは結局４つのtable全てに登録されているIDを取り出しているから，joinの順序は関係なさそう
select
	c.id, c.last_name , o.item_id ,o.order_amount , o.order_price , o.order_date , i.name, s.name
FROM 
	customers c 
inner join orders o 
	on c.id=o.customer_id # ここは順不同でOK
inner join items i 
	on o.item_id  = i.id
inner join stores s 
	on i.store_id = s.id 
order by c.id
;


-- customers, orders, items, storesを紐付ける
-- customers.idで並び替える
-- customers.idが10で，orders.order_dateが2020-08-01よりあとの情報に絞り込む
select
	c.id, c.last_name , o.item_id ,o.order_amount , o.order_price , o.order_date , i.name, s.name
FROM 
	customers c 
inner join orders o 
	on c.id=o.customer_id # ここは順不同でOK
inner join items i 
	on o.item_id  = i.id
inner join stores s 
	on i.store_id = s.id 
where c.id = 10 and o.order_date > "2020-08-01"
order by c.id
;
# サブクエリで書いてみる
select
	c.id, c.last_name , o.item_id ,o.order_amount , o.order_price , o.order_date , i.name, s.name
FROM 
	(select * from customers where id = 10) as c
inner join (select * from orders where order_date > "2020-08-01") as o 
	on c.id=o.customer_id # ここは順不同でOK
inner join items i 
	on o.item_id  = i.id
inner join stores s 
	on i.store_id = s.id 
order by c.id
;

-- GROUP BYの紐付け
select * from customers c 
inner join
	(select customer_id, SUM(order_amount * order_price) as summary_price
		from orders
		group by customer_id) as order_summary
on c.id = order_summary.customer_id
order by c.age
limit 5
;

-- SELF JOIN（自己結合：同一のtableを結合する）

select
	concat(e.last_name, e.first_name) as "部下の名前",
	concat(e2.last_name, e2.first_name) as "上司の名前",
from employees e 
inner join employees e2 # これをon以下の条件で整列させて連結
	on e.manager_id = e2.id
;

# left joinにすると，上司のいない人（manager_idがNULLの人）も抽出できる
select
	concat(e.last_name, e.first_name) as "部下の名前",
	COALESCE(concat(e2.last_name, e2.first_name), "該当なし") as "上司の名前"
from employees e 
left join employees e2 # これをon以下の条件で整列させて連結
	on e.manager_id = e2.id
;


-- CROSS JOIN（交差結合：２つのテーブルのすべての組み合わせを取得する）-------------------------

# 古い書き方（これでもCORSS JOINになる）
select * from employees e, employees e2 where e.id=1 ;

select * from employees e
cross join employees e2
on e.id < e2.id;


-- 計算結果とCASEで紐付け
# 平均年齢よりも高いかどうかを判定
select 
	*, 
	CASE 
		when c.age > summary_customers.avg_age then "○"
		else "✗"
	END as "平均年齢よりも年齢が高いか"
from customers c 
cross join
	(select avg(age) as avg_age from customers) as summary_customers
;

select
	e.id,
	avg(s2.payment),
	CASE 
		when avg(s2.payment) >= summary.avg_payment then "○"
		else "✗"
	END as "平均月収以上か"
from employees e 
inner join salaries s2 
	on e.id = s2.employee_id 
cross join
	(select avg(payment) as avg_payment from salaries) as summary
group by e.id, summary.avg_payment
;


-- WITH（実行結果を一時的にテーブルに格納する）-----------------------------

# departmentから営業部の人を取り出してemployeesと結合する
select
	*
from employees e 
inner join departments d 
	on e.department_id =d.id 
where d.name = "営業部"
;

# withを使って書くとこうなる
with tmp_departments as
	(select * from departments where name = '営業部')
select * from employees e inner join tmp_departments
	on e.department_id = tmp_departments.id; 


-- stores tableからid=1,2,3のものを取り出す
-- items tableと紐付け，items tableとorders tableを紐付ける
-- orders tableのorder_amount*order_priceの合計値をstores tableのstore_nameごとに集計する
#JOINやGROUPは処理が重いので，なるべく絞り込んだ後，最後に実行するといい
with tmp_stores as (
	select * from stores where id in (1,2,3)
), tmp_items_orders as (
	SELECT
		items.id as items_id,
		tmp_stores.id as store_id, 
		orders.id as order_id,
		orders.order_amount as order_amount,
		orders.order_price  as order_price,
		tmp_stores.name as store_name
	from tmp_stores
	inner join items
		on tmp_stores.id = items.store_id
	inner join orders
		on items.id = orders.item_id 
)
select
	store_name, 
	sum(order_amount * order_price)
from tmp_items_orders
group by store_name;

