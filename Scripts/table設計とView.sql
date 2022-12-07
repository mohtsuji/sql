-- table設計 ---------------------------------------

# 通常は第3正規まで行う。正規化をすればデータ容量は小さくなるが，代わりに処理速度が遅くなることがあるので，あえて第2までにすることがある
# 主キーは基本つける。数値型かCHAR型に。VARCHARだと空白などが入って思わぬ挙動をすることがあるので望ましくない。
# create_at, update_atは基本つけましょう
# 制約，デフォルト値，コメントは基本書きましょう。システムの信頼性向上と保守性の向上のため。


-- View --------------------------------------------
 # 外部スキーマ：ユーザー，アプリケーションからみたDBの構造(Viewなど）
# 概念スキーマ：DBのデータ構造（テーブルなど）
# 内部スキーマ：テーブルの細部。データファイルの詳細な物理配置（カラムタイプ，インデックス，RAIDなど）

# View：テーブル同士を紐付けたり，特定のカラムのみを取り出したりして作成された仮想的なテーブルのこと。外部スキーマに当たる。
# Viewはあくまでショートカットなので，tableが作成されるわけではなく，設定されたクエリが毎回叩かれているだけ
# 副問合せ以外では，whereやorder byはつけない（汎用性が下がるから）
# Viewの中にViewを作らない。パフォーマンスが下がる

use day_10_14_db;
show tables;

select s.name as store_name, i.name as item_name from stores s
inner join items i 
	on i.store_id  = s.id
;

# Viewの作成
create view stores_items_view as
select s.name as store_name, i.name as item_name from stores s
inner join items i 
	on i.store_id  = s.id
;

select * from stores_items_view;

# Viewは毎回クエリを叩いているので，元のTableを変更すると，Viewにも変更が反映される
update items set name = "new Item 山田 1" where name = "Item 山田 1";

# Viewも表示される
show tables;

# Viewだけを一覧表示
select * from information_schema.views where TABLE_SCHEMA ="day_10_14_db";

# Viewの詳細を確認
show create view stores_items_view;

/*CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` 
 SQL SECURITY DEFINER VIEW `stores_items_view` AS 
 select `s`.`name` AS `store_name`,`i`.`name` AS `item_name` 
 from (`stores` `s` join `items` `i` on((`i`.`store_id` = `s`.`id`)))
*/

# 絞り込みも可能　
select * from stores_items_view where store_name = "山田商店";

# Viewの削除
drop view stores_items_view;

#Viewの定義変更



