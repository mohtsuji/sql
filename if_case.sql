select database();

show tables;

# if(条件式、真の値、偽の値)
SELECT if(10<20, "A", "B");
SELECT if(10>20, "A", "B");

select * from users;
select birth_place , if(birth_place="日本", '日本人', 'その他') as '国籍' from users;

select name, age, if(age < 20, "未成年", '成人') from users;

select name,height, if(class_no=6 and height > 170, "６組の170cm以上の人", 'その他') from students ;

select name, if(name like "%田%", '名前に田を含む', 'その他') as name_check from users;
select "田中" like "%田%";
select "中" like "%田%";

# case
select id, name, birth_place,
 case birth_place
 	when "日本" then '日本人'
 	else "外国人"
 end as '国籍' 
from users
where id > 30;

SELECT 
	name,
	CASE 
		when name in("香川県", "愛媛県", "徳島県", "高知県") then "四国"
		else "その他"
	END as "地域名"
from
	prefectures ;

# 計算
SELECT 
	name,
	birth_day,
	CASE 
		when date_format(birth_day, "%Y") % 4 = 0 then "閏年"
		else "閏年でない"
	END as "閏年か"
FROM users;

select * from tests_score ts where student_id % 3 = 0;
select
	*,
	CASE 
		when student_id % 3 = 0 then test_score_1
		when student_id % 3 = 1 then test_score_2
		when student_id % 3 = 2 then test_score_3
	END as score
from tests_score ;


# caseとorder by
#その他と四国を地域名で並び替えて表示
select
	*,
	case
		when name in("香川県", "愛媛県", "徳島県", "高知県") then "四国"
		else "その他"
	end as "地域名"
	from prefectures p # ここまでで表示
order by # 並び替え命令開始
	case
		when name in("香川県", "愛媛県", "徳島県", "高知県") then 0
		else 1
	end;


# caseとupdate
SELECT  * FROM users;

ALTER table users add birth_era varchar(2) after birth_day;

update users 
set birth_era = 
	CASE 
		when birth_day < "1989-01-07" then "昭和"
		when birth_day < "2019-05-01" then "平成"
		when birth_day >= "2019-05-01" then "令和"
		else "不明"
	END;
	
SELECT  * FROM users;


# caseとNULL
SELECT * from customers c where name is NULL;

SELECT
	*,
	CASE
		when name is NULL then "NULL"
		when name is not NULL then "NULL以外"
		else ""
	end as "NULL check"
from customers c;










