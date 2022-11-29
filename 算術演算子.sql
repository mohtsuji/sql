select database();

show databases;

use my_db;

# 0
select 1= 0

# 1
select 1=1

# 0
select 1 <= 0

# 1
select "Tako" > "A"

# 1
select 1<>0 #<> == !=

# 1
select 1!=0 #<> == !=

# whereは計算結果が1になった行を取り出すだけ

create database day_4_9_db;