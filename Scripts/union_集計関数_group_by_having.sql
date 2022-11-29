use day_4_9_db;

-- UNION

#UNION（重複する行は１つにまとめる）
#UNION ALL（重複したまま取り出す）

select database();

 #重複なし（処理が少し長い）
select * from new_students ns
union
select * from students s ;

select * from new_students ns
union
select * from students s 
order by id;

# 重複あり
select * from new_students ns
union all
select * from students s 
order by id;


select * from students s  where id < 10
union ALL 
select * from students s2 where id < 10
order by id;

select age, name from users u  where id < 10;

#idとageはともにINTなので，以下のような結合も可能（わかりづらくない？）
#order byを指定するときは，１つ目のSELECTのカラム名を使用しなければならない
select id, name from students s where id < 10
union
select age, name from users u  where id < 10
order by id;

#以下はカラム数があっていないのでエラー
select id,name,height from students s
union
select age,name from users;


-- 集計関数

# NULLについて
# SUM,MIN,MAX,AVGではNULLは無視される
# COUNTは，列名指定した場合はNULLを無視，*で指定した場合はNULLも含んでカウントする


-- count（古いDBだと＊よりも主キーでCOUNTするほうが早い場合がある）
select * from customers c WHERE name is NULL;
# NULLもカウント
select count(*) from customers c ;
# NULLは無視
select count(name) from customers c ;

select count(name) from customers c where id > 80;

-- max,min
select max(age), min(age) from users where birth_place ="日本";

# 日付に対するMIN（一番古い日付）とMAX（一番新しい日付）
select max(birth_day), min(birth_day) from users;

-- sum
select sum(salary) from employees e ;


-- average
select avg(salary) from employees e ;

create table tmp_count(
	num INT
	);
show tables;

insert into tmp_count values(1);
insert into tmp_count values(2);
insert into tmp_count values(3);
insert into tmp_count values(NULL);

select * from tmp_count;

# NULLを無視して(1+2+3)/3=2になる
select avg(num) from tmp_count ;
# NULLも0として平均に含めてほしいとき(numがNULLなら0が選択される）
select COALESCE (num, 0) from tmp_count ;
select avg(COALESCE (num, 0)) from tmp_count ;


-- group by

select age from users
	WHERE birth_place ="日本"
	order by age;

select age, count(*), max(birth_day), min(birth_day) from users
	WHERE birth_place ="日本"
	group by age
	order by age;

select age, count(*), max(birth_day), min(birth_day) from users
	WHERE birth_place ="日本"
	group by age
	order by count(*);

select * from employees e ;

select department , sum(salary), floor(avg(salary)), min(salary) from employees e
	where age > 40
	group by department
;

select * from users;
select
	CASE 
		when birth_place ="日本" then "日本人"
		else "その他"
	END as "国籍",
	count(*),
	max(age)
FROM users
group by
	CASE 
		when birth_place ="日本" then "日本人"
		else "その他"
	END
;

select 
	CASE 
		when name in ("愛媛県", "高知県","香川県", "徳島県") then "四国"
		else "その他"
	END as "地名",
	count(*)
from prefectures p 
group by
	CASE 
		when name in ("愛媛県", "高知県","香川県", "徳島県") then "四国"
		else "その他"
	END
;

SELECT
	age,
	CASE 	
		when age < 20 then "未成年"
		else "成人"
	END as "分類",
	count(*)
from users u 
group by age
order by age
;

-- having（集計結果に対する絞り込み)

select department, avg(salary)
from employees e
group by department
;

select department, avg(salary)
from employees e
group by department
having avg(salary) > 3980000
;

select birth_place , age, count(*) from users
group by birth_place , age
having count(*) > 2
ORDER by count(*), age 
;

#distinctは重複を削除して表示
select
	"重複なし"
from users
having count(distinct name) = count(name)
;

select
	"重複なし"
from users
having count(distinct age) = count(age)
;












