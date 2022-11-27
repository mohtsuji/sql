show databases;
use day_4_9_db;
select database();

# 1
select name, age from customers c 
	where age >= 28 and age <= 40
		and name like "%子"
	order by age desc
	limit 5;
	
# 2
select * from receipts r order by customer_id desc;
describe receipts ;
SELECT @@GLOBAL.sql_mode;
SET SESSION sql_mode = 'ONLY_FULL_GROUP_BY,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

insert into receipts  (customer_id, store_name, price) values(100, "Store X", 10000);
select * from receipts r order by customer_id desc;

# 3
delete from receipts where id = 0;
select * from receipts r order by customer_id desc;

# 4
select * from prefectures p where name is NULL OR name = "";
delete from prefectures where name is NULL OR name = "";
select * from prefectures p where name is NULL OR name = "";

# 5
update customers set age=age+1 where id between 20 and 50;
select * from customers c ;

# 6
select floor(rand()*10)%5;
select * from students s where class_no =6;

#alter table students add class_no_random integer;
SELECT * from students s ;

UPDATE students set class_no=CEILING(rand()*5) where class_no=6;
/*update students
	set class_no=
		case
			when floor(rand()*10)%5 = 0 then 1
			when floor(rand()*10)%5 = 1 then 2
			when floor(rand()*10)%5 = 2 then 3
			when floor(rand()*10)%5 = 3 then 4
			else 5
		end
	where class_no = 6;
*/

# 7
#select * from students where height < 160 and class_no =1;
select * from students s where (height < all(select height+10 from students s where class_no in(3,4))) and class_no = 1;		
#select height+10 from students s where class_no in(3,4) order by height*10;		

# 8
select department, trim(department)  from employees e where char_length(department)<>char_length(trim(department));
update employees set department=trim(department);
select * from employees e ;

# 9
select
	*,
	CASE 
		when salary >= 5000000 then round(salary * 0.9)
		when salary < 5000000 then round(salary * 1.1)
	END as salary_change
from employees e ;

# 10
select curdate();
insert into customers (name, age, birth_day) values("名無権兵衛", 0, curdate());
select * from customers c ;

# 11
alter table customers add name_length int;
select * from customers c ;
update customers set name_length=char_length(trim(name));

# 12
alter table tests_score add score int;
select * from tests_score ts ;

#COALESCE()はこのように、指定されたリストを先頭から確認し、最初に見つかったNULLでは無い値を返すという動きをします
alter table tests_score add score_sec int;
select *, COALESCE(test_score_1, test_score_2, test_score_3) as not_NULL from tests_score ts ;
update tests_score 
	set score_sec=
		case
			when COALESCE (test_score_1, test_score_2, test_score_3) >= 900
				then floor(COALESCE (test_score_1, test_score_2, test_score_3)*1.2)
			when COALESCE (test_score_1, test_score_2, test_score_3) <= 600
				then ceiling(COALESCE (test_score_1, test_score_2, test_score_3)*0.8)
			else COALESCE (test_score_1, test_score_2, test_score_3)
		end;
		
# 自力で描いた方（こっちも多分合ってる）
update tests_score 
	set score=
		CASE 
			WHEN test_score_1 is not NULL then 
				case 
					when test_score_1 >= 900 then floor(test_score_1 *1.2) 
					when test_score_1 <=600 then ceiling(test_score_1 * 0.8)
					else test_score_1 
				end
			WHEN test_score_2 is not NULL then 
				case 
					when test_score_2 >= 900 then floor(test_score_2 *1.2) 
					when test_score_2 <=600 then ceiling(test_score_2 * 0.8)
					else test_score_2 
				end
			WHEN test_score_3 is not NULL then 
				case 
					when test_score_3 >= 900 then floor(test_score_3 *1.2) 
					when test_score_3 <=600 then ceiling(test_score_3 * 0.8)
					else test_score_3 
				end
		END;
select * from tests_score ts ;

# 13
select
	*
from employees e 
order by
		CASE department
			when "マーケティング部" then 0
			when "研究部" then 1
			when "開発部" then 2
			when "総務部" then 3
			when "営業部" then 4
			when "経理部" then 5
		end
	;
		