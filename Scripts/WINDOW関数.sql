use day_10_14_db;

select database();

-- WINDOW（業に対する集計を行う)---------------------------------

-- partition by-------------------------------------

select * from employees e ;
# over()のみだと全行を含めて実行される
select *, avg(age) over(), count(*) over()
	from employees e ;
	
# 特定の行（部署）ごとに集計する
select *, 
	avg(age) over(PARTITION by department_id) as avg_age, 
	count(*) over(PARTITION by department_id) as count_depart
from employees e ;

# 各年代が何人いるのかを集計
select distinct
	floor(age/10) * 10,
	concat(count(*) over(partition by floor(age/10)), "人") as age_count
from employees e ;

# 日付ごとに売上を集計
select 
	*,
	sum(order_amount * order_price) over(PARTITION by order_date)
from orders o ;

# 月ごとに売上を集計
select 
	*,
	date_format(order_date, "%Y/%m"),
	sum(order_amount * order_price) over(PARTITION by date_format(order_date, "%Y/%m"))
from orders o ;

-- フレーム（partitionを更に小さい単位にまとめたもの）-------------------------------------------------

-- order by （並び替えて，同じ値を１つのフレームとして集計する（そしてなぜか累積）-------------------------------- 
SELECT 	
	*,
	count(*) over(order by age) as age_count
from employees e ;

# 条件を２つにすることも可能
select
	*, 
	sum(order_price) over(order by order_date, customer_id)
from orders;

SELECT 
	floor(age/10),
	count(*) over(order by floor(age/10))
from employees e ;


-- partition + order by -------------------------------------------

# 部署ごとに，年齢を昇順でカウント（累積）
SELECT 
	department_id ,
	age,
	count(*) over(partition by department_id order by age) as count_value
from employees e ;

# 人ごとの，最大の収入
SELECT 
	*,
	max(payment) over(partition by e.id)
from employees e
inner join salaries s 
on e.id = s.employee_id 
;

# 月ごとの，最大の収入をemployeesのIDで昇順に並ぶかえる
SELECT 
	*,
	sum(s.payment) over(partition by s.paid_date  order by e.id)
from employees e
inner join salaries s 
on e.id = s.employee_id 
;


-- ROWS BETWEEN（対象の行の範囲を指定する）---------------------------------------

# ７日間の売上の平均を求める
# まずは日付ごとの合計値を求める
# それに対して７日平均を求める

#これは失敗例
SELECT 
	*,
	sum(order_price * order_amount) 
		over(order by order_date rows between 6 PRECEDING and current row)
from orders o 
order by order_date
;

# これは成功例
with daily_summary as(
	SELECT 
		order_date,
		sum(order_price * order_amount) as sale
	from orders o 
	group by order_date 
) 
select
	*,
	avg(sale) over(order by order_date rows between 6 PRECEDING and current row)
from daily_summary
;

-- RAGE BETWEEN（現在の行の「値」を基準として集計する行の範囲を指定する。必ずorder by と一緒に使う）----------
SELECT 
	*,
	sum(summary_salary.payment) 
		over(order by age range between UNBOUNDED PRECEDING and 1 FOLLOWING) as p_summary
from employees e 
inner join
	(select
		employee_id,
		sum(payment) as payment
	from salaries s 
	group by employee_id) as summary_salary 
on e.id = summary_salary.employee_id
;


-- ROW_NUMBER, RANK, DENSE_RANK -----------------------------------

# 行番号を降ってくれる
SELECT 
	*,
	row_number() over(order by age) as row_num
from employees e ;

# ランクを降る
SELECT 
	*,
	row_number() over(order by age) as row_num,
	rank() over(order by age) as row_rank,
	DENSE_RANK() over(order by age) as row_dense
from employees e ;

-- cume_dist（その値が全体のなん％目に当たるか）, percent_rank（その行が全体のなん％目にあたるか） ----------------------------------------------
SELECT 
	age,
	count(*) over() as cnt,
	rank() over(order by age) as row_rank, #(RANK - 1) / (行数 - 1)
	PERCENT_RANK() over(order by age) as p_rank, #現在の行の値より小さい行の割合
	CUME_DIST() over(order by age) as c_age
from employees e ;


-- LAG, LEAD --------------------------------------------
SELECT 
	age,
	lag(age) over(order by age), # 自分よりも一つ前の行の値
	lag(age, 3, 0) over(order by age), #自分より３つ前，ない場合は0
	lead(age) over(order by age), # 自分よりも一つ後の行の値
	lead(age, 2, 0) over(order by age) # 自分よりも２つ後の行の値，ない場合は０
from customers c ;


-- first_value, last_value -------------------------------------

SELECT 
	*,
	first_value(first_name) over(PARTITION  by department_id order by age), #そのグループの中で一番上の行の値
	last_value(first_name) over(PARTITION  by department_id order by age
		range between UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) #そのグループの中で一番下の行の値
from employees e ;


-- NTILE -----------------------------------------

# 全体を２つ(()内の数字）のグループに分けて，どっちのグループに属するかを表示

SELECT 
* from
	(SELECT 
		age,
		NTILE(10) over(order by age) as ntile_value 
	from employees e) as tmp
WHERE tmp.ntile_value = 8
;





