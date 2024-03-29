
{{ config(materialized='table') }}

SELECT
    cast(seq as bigint) as id,
    駅名 as station_name,
    ふりがな as station_name_kana,
    駅コード as station_code,
    ゾーンコード as zcode,
    所在地 as location_name,
    備考 as annotation,
    路線名 as line_name_1,
    2 as line_name_2,
    3 as line_name_3,
    4 as line_name_4,
    5 as line_name_5,
    6 as line_name_6,
    7 as line_name_7,
    8 as line_name_8,
    9 as line_name_9,
    10 as line_name_10,
    11 as line_name_11,
    12 as line_name_12,
    13 as line_name_13,
    14 as line_name_14,
FROM read_csv_auto('/Users/nagampere/File/horkew/projects/tokyo2018/sources/05駅コード表.csv')