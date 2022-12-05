use day_10_14_db;

select database();

/*1. employeesテーブルとcustomersテーブルの両方から、それぞれidが10より小さいレコードを取り出します。
両テーブルのfirst_name, last_name, ageカラムを取り出し、行方向に連結します。
連結の際は、重複を削除するようにしてください。*/

select first_name , last_name , age from employees e where id < 10
union
select first_name , last_name , age from customers c  where id < 10;


/*2. departmentsテーブルのnameカラムが営業部の人の、月収の最大値、最小値、平均値、合計値を計算してください。
employeesテーブルのdepartment_idとdepartmentsテーブルのidが紐づけられ
salariesテーブルのemployee_idとemployeesテーブルのidが紐づけられます。
月収はsalariesテーブルのpaymentカラムに格納されています*/

select max(payment), min(payment), avg(payment), sum(payment) from salaries s
inner join employees e 
	on s.employee_id = e.id
inner join departments d
	on d.id = e.department_id
where d.name = "営業部"
;

select * from departments d ;
select * from salaries s  ;


/*3. classesテーブルのidが、5よりも小さいレコードとそれ以外のレコードを履修している生徒の数を計算してください。
classesテーブルのidとenrollmentsテーブルのclass_id、enrollmentsテーブルのstudent_idとstudents.idが紐づく
classesにはクラス名が格納されていて、studentsと多対多で結合される*/

select * from classes c ;
select * from enrollments e  ;
select * from students s ;
describe enrollments ;

select 
	CASE 
		when c.id < 5 THEN "under_five"
		when c.id >= 5 THEN "over_five"
	END as "kubun",
	count(*)
from classes c 
inner join enrollments e  on c.id = e.class_id
inner join students s  on e.student_id  = s.id
group by
	CASE 
		when c.id < 5 THEN "under_five"
		when c.id >= 5 THEN "over_five"
	END
;

select * from classes c; 

/*4. ageが40より小さい全従業員で月収の平均値が7,000,000よりも大きい人の、月収の合計値と平均値を計算してください。
employeesテーブルのidとsalariesテーブルのemployee_idが紐づけでき、salariesテーブルのpaymentに月収が格納されています*/

# 自分の回答（合ってはいる）
with over_40 as (
	select * from employees e where age < 40
), over_40_salaries as (
	select
		s.employee_id ,
		sum(payment) as "合計",
		avg(payment) as "平均"
	from over_40 o
	inner join salaries s 
		on o.id = s.employee_id
	group by s.employee_id 
)
select
	*	
from over_40_salaries os
where 平均>=7000000;

# 模範回答
select e.id, sum(s.payment), avg(s.payment)
from employees e 
inner join salaries s 
	on e.id = s.employee_id 
where e.age < 40
group by e.id
having avg(s.payment) > 7000000
	;

select * from employees e ;
select * from salaries s order by employee_id ;

select employee_id , avg(payment) from salaries s2 group by employee_id;


/*5. customer毎に、order_amountの合計値を計算してください。
customersテーブルとordersテーブルは、idカラムとcustomer_idカラムで紐づけができます
ordersテーブルのorder_amountの合計値を取得します。
SELECTの対象カラムに副問い合わせを用いて値を取得してください。*/

select * from customers c ;
select * from orders o ;


select
	id,
	(select sum(order_amount) from orders o where o.customer_id = c.id) as sum_order_amount
from customers c 
;

select sum(order_amount) from orders group by customer_id ;

# 模範回答
SELECT 
	*,
	(select sum(order_amount) from orders o 
		where o.customer_id  = c.id) as sum_order_amount
from customers c 
;

/*6. customersテーブルからlast_nameに田がつくレコード、
ordersテーブルからorder_dateが2020-12-01以上のレコード、
storesテーブルからnameが山田商店のレコード同士を連結します
customersとorders, ordersとitems, itemsとstoresが紐づきます。
first_nameとlast_nameの値を連結(CONCAT)して集計(GROUP BY)し、そのレコード数をCOUNTしてください。*/

select * from customers c where last_name like "%田%"  ;
select * from orders o  where order_date >= "2020-12-01";
select * from items i ;
select * from stores s where name = "山田商店";

# 自分の回答
select
	concat(last_name, first_name),
	count(*)
from customers c
inner join orders o
	on c.id = o.customer_id
inner join items i 
	on o.item_id = i.id
inner join stores s
	on i.store_id = s.id
where last_name like "%田%" 
	and order_date >= "2020-12-01"
	and s.name = "山田商店"
group by concat(last_name, first_name)
;

# 模範回答
SELECT 
	concat(customers.last_name, customers.first_name), count(*)
FROM 
	(select * from customers c where last_name like "%田%") as customers
inner join (select * from orders o where order_date >= "2020-12-01") as orders
	on customers.id = orders.customer_id 
inner join items i
	on orders.item_id = i.id 
inner join (select * from stores where name = "山田商店") as stores
	on stores.id = i.store_id
group by concat(customers.last_name, customers.first_name)
;


/*7. salariesのpaymentが9,000,000よりも大きいものが存在するレコードを、employeesテーブルから取り出してください。
employeesテーブルとsalariesテーブルを紐づけます。
EXISTSとINとINNER JOIN、それぞれの方法で記載してください*/

select* from employees e2 ;
select * from salaries s;
select * from salaries s where payment>9000000;

# EXIST
select * from employees e
where EXISTS (select * from salaries s where payment>9000000 and e.id = s.employee_id);

# IN
select * from employees e where e.id IN (select employee_id  from salaries s where payment > 9000000);

# INNER JOIN
select
	e.*
from employees e 
inner join salaries s 
	on e.id = s.employee_id 
where s.payment>9000000	
;	
# 重複を削除してあげる
select
	distinct e.*
from employees e 
inner join salaries s 
	on e.id = s.employee_id 
where s.payment>9000000	
;	


/*8. employeesテーブルから、salariesテーブルと紐づけのできないレコードを取り出してください。
EXISTSとINとLEFT JOIN、それぞれの方法で記載してください*/

# EXISTS
select * from employees e 
	where exists (select * from salaries s where e.id = s.employee_id);
# 19,20を取り出せばOK
select * from employees e 
	where not exists (select * from salaries s where e.id = s.employee_id)

# IN 
select * from employees e 
	where id not in (select employee_id from salaries s);

# LEFT JOIN（紐付けできなかった人はNULLになるのでそれを利用する）
select * from employees e
left join salaries s 
	on s.employee_id  = e.id
where s.id is null
;

/*9. employeesテーブルとcustomersテーブルのage同士を比較します
customersテーブルの最小age, 平均age, 最大ageとemployeesテーブルのageを比較して、
employeesテーブルのageが、最小age未満のものは最小未満、最小age以上で平均age未満のものは平均未満、
平均age以上で最大age未満のものは最大未満、それ以外はその他と表示します
WITH句を用いて記述します*/

select * from employees e ;
select * from customers c ;

with cus_ages as (
	select
		min(age) as 'min_age',
		avg(age) as 'avg_age',
		max(age) as 'max_age'
	from customers c 
)
select
	e.*,
	CASE 
		when age < cus_ages.min_age then "最小未満"
		when cus_ages.min_age <= age and age < cus_ages.avg_age then "平均未満"
		when cus_ages.avg_age <= age and age < cus_ages.max_age then "最大未満"
		ELSE "その他"
	END
from employees e
cross join cus_ages
;

select * from employees e cross join customers c ;


/*10. customersテーブルからageが50よりも大きいレコードを取り出して、ordersテーブルと連結します。
customersテーブルのidに対して、ordersテーブルのorder_amount*order_priceのorder_date毎の合計値。
合計値の7日間平均値、合計値の15日平均値、合計値の30日平均値を計算します。
7日間平均、15日平均値、30日平均値が計算できない区間(対象よりも前の日付のデータが十分にない区間)は、空白を表示してください。*/

select * from customers c;
select * from customers c where age > 50;
select * from orders o ;

# これはだめ、累積で計算してるから
with cus_over_50 as (
	select * from customers c where age > 50
), amount_table as (
	SELECT
		cus_over_50.id,
		cus_over_50.age,
		o.order_date ,
		sum(o.order_amount * o.order_price) over(partition by cus_over_50.id order by order_date) as amount
	from orders o
	inner join cus_over_50
		on o.customer_id  = cus_over_50.id
)
SELECT 
	*,
	avg(am.amount) over(rows between 6 PRECEDING and current row ) as "７日間平均",
	avg(am.amount) over(rows between 6 PRECEDING and current row ) as "７日間平均",
	avg(am.amount) over(rows between 6 PRECEDING and current row ) as "７日間平均"
from amount_table am
		;

# 模範回答
with cus_over_50 as (
	select * from customers c where age > 50
), customers_order as (
	SELECT
		co.id,
		co.age,
		o.order_date ,
		sum(o.order_amount * o.order_price)  as amount,
		row_number() over(partition by co.id order by o.order_date) as row_num
	from orders o
	inner join cus_over_50 co
		on o.customer_id  = co.id
	group by co.id, o.order_date 
)
SELECT 
	*,
	CASE 
		when row_num < 7 then ""
		else avg(cus.amount) over(partition by id order by order_date rows between 6 PRECEDING and current row )
	END as  "７日間平均",
	CASE 
		when row_num < 15 then ""
		else avg(cus.amount) over(rows between 14 PRECEDING and current row )
	END as "15日間平均",
	CASE 
		when row_num < 30 then ""
		else avg(cus.amount) over(rows between 29 PRECEDING and current row ) 
	END as "30日間平均"
FROM customers_order cus
;



avg(amount) over(rows between 6 PRECEDING and current row )



















