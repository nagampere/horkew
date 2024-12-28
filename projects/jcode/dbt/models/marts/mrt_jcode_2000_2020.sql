WITH 
jcode_2000 as (
    SELECT
        *
    FROM
        {{ ref('int_jcode') }} as jcode
    where
        (jcode."establish_year" <=2000) AND (jcode."dissolve_year" >=2000)
),
jcode_2020 as (
    SELECT
        *
    FROM
        {{ ref('int_jcode') }} as jcode
    where
        (jcode."establish_year" <=2020) AND (jcode."dissolve_year" >=2020)
)
SELECT
    jcode_2000.id
    jcode_2000."標準地域コード"
    jcode_2000."都道府県"
    jcode_2000."政令市･郡･支庁･振興局等"
    jcode_2000."政令市･郡･支庁･振興局等（ふりがな）"
    jcode_2000."市区町村"
    jcode_2000."市区町村（ふりがな）"
    jcode_2000."廃置分合等施行年月日"
    jcode_2000."廃置分合等情報有無"
FROM jcode_2000
OUTER JOIN jcode_2020
ON jcode_2000."標準地域コード" = jcode_2020."標準地域コード"
