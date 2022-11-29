select database();

use my_db;

show tables;

alter table people
add age int after name;

select * from people;

insert into people values(1, "John", 18, "2001-01-01");
insert into people values(2, "Alice", 15, "2003-01-01");
insert into people values(3, "Paul", 19, "2000-01-01");
insert into people values(4, "Chris", 17, "2001-01-01");
insert into people values(5, "Vette", 20, "2001-01-01");
insert into people values(6, "Tsuyoshi", 21, "2001-01-01");


-- ORDER BY
#  昇順で表示
select * from people order by age;

#  降順で表示
select * from people order by age desc;

# 誕生日で降順，誕生日が同じ人は名前で降順で並び替えられる
select * from people order by birth_day desc, name;

-- DISTINCT（重複を削除して抽出）
# 重複を削除して表示（各誕生日が1度ずつしか表示されない）
select DISTINCT birth_day from people;
select DISTINCT birth_day from people order by birth_day;

# 名前も誕生日も同じ人は削除される
SELECT DISTINCT name, birth_day from people;

-- LIMIT
# 最初の3行だけ表示
select * from people limit 3;
# 誕生日を昇順で並び替えたときの上から3人だけ表示
select * from people order by birth_day limit 3;
# 誕生日が2001年の人を年齢で並び替えて，若い3人だけを表示
select * from people
where birth_day="2001-01-01"
order by age
limit 3;

#最初の3行を飛ばして，2行のみ表示
select * from people limit 3, 2;
select * from people limit 2 offset 3;

# TRUNCATEでレコードを全部削除すると，メモリ領域が開放される（deleteだと開放されない代わりにデータの復活が可能）
truncate people; 

select * from people;














