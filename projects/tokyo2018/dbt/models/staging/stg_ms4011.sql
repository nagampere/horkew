
{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER () as id,
    回収分類 as answer_type,
    バッチ番号 as id_batch,
    整理番号：市区町村 as id_area,
    整理番号：ロット番号 as id_lot,
    整理番号：世帯ＳＱ as id_household,
    世帯人数／5歳未満含む as household_size,
    世帯人数／5歳未満除く as household_size_over_5th,
    回収個人票数 as individual,
    現住所：完全桁数 as address_accuracy,
    現住所：ゾーンコード as address_zcode,
    現住所：JISコード（5桁） as address_jcode,
    所有車両：自動車 as owned_car,
    所有車両：自転車 as owned_bike,
    所有車両：原付・バイク as owned_motorcycle,
    世帯年収 as income,
    個人番号 as personal_number,
    性別 as sex,
    年齢 as age, 
    世帯主との続柄 as relationship,
    就業（形態・状況） as employment,
    職業 as job,
    自動車運転免許保有の状況 as licence,
    自由に使える自動車の有無 as ownership_car,
    外出に関する身体的な困難さ as disability,
FROM read_csv_auto('/Users/nagampere/File/horkew/projects/tokyo2018/sources/MS4011_UTF.csv')
