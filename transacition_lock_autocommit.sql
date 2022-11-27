select database();

show tables;

select * from users;

-- transactionの開始
start transaction;

-- UPDATE 
update users set name="中山　成美" where id=1;

select * from users;

-- rollback（トランザクション開始前に戻す）
rollback;

-- commit（トランザクションをDBに反映）
commit;

select * from users;


select * from students;
delete from students where id=300;

-- autocommit確認
# mysqlの設定を確認 
show variables;
show variables where Variable_name="autocommit";
# auto commit をOFFにする（明示的にコミットしないと変更が反映されないようにする ）
set autocommit=0;

delete from students where id=299;
# 変更を反映する
commit;

# autocommit をONにする
set autocommit=1;

-- LOCK(update, delete,insert = 排他ロック)
# 共有ロック＝SELECTのみ可能
# 排他ロック＝SELECTすら不可

#主キーまたはユニークキーでロック＝行ロック（選択された行のみロック）
#それ以外でロック＝テーブル全体がロックされてしまう

start transaction;
show tables;
select * from customers c ;
#主キーでUPDATE（行ロック）（排他ロック＝他の入り口からは更新ができなくなる,selectは可能）
update customers set age=43 where id=1;
# ROllbackまたはCommitするとロックが解除される
rollback;

start transaction;
#主キー以外でUPDATE（テーブルロック＝テーブル全体に排他ロックがかかる）
update customers set age=42 where name="河野 文典";
update customers set age=42 where id=1;

rollback;

-- select でロック
# for share（共有ロック）
# for update（排他ロック）
start transaction;
# 共有ロック
select * from customers c where id=1 for share;
update customers set age=1 where id=1;
select * from customers c ;
rollback;
# 排他ロック
start transaction;
select * from customers c where id=1 for update;
rollback;

-- 明示的なテーブルロック
# lock table ~ read（実行したセッションも他のセッションもSELECTしかできなくなる）
# lock table ~ write（実行したセッションは読み書き可能、他のセッションは何もできない）
# unlock tables（現セッションの保有するテーブルロックを全て解除）

-- lock table read
lock table customers read;
select * from customers; # 可能
update customers set age=42 where id=1; #エラー
unlock tables;

-- lock table write
lock table customers write;
select * from customers; # 可能
update customers set age=42 where id=1; #エラー
unlock tables;

-- dead lock(更新するテーブルの順番を揃えればデッドロックは怒らない！)
start transaction;
-- customers→users
update customers set age=42 where id=1;
update users set age=42 where id=1;





