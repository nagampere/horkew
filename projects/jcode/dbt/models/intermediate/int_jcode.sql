SELECT
    jcode.id as id,
    jcode."標準地域コード" as "標準地域コード",
    jcode."都道府県" as "都道府県",
    jcode."政令市･郡･支庁･振興局等" as "政令市･郡･支庁･振興局等",
    jcode."政令市･郡･支庁･振興局等（ふりがな）" as "政令市･郡･支庁･振興局等（ふりがな）",
    jcode."市区町村" as "市区町村",
    jcode."市区町村（ふりがな）" as "市区町村（ふりがな）",
    jcode."廃置分合等施行年月日" as "廃置分合等施行年月日",
    jcode."廃置分合等情報有無" as "廃置分合等情報有無",
    establish."廃置分合等施行年月日" as "establish_date",
    CASE 
        WHEN establish."廃置分合等施行年月日" IS NULL THEN 1969
        ELSE YEAR(establish."廃置分合等施行年月日")
    END as "establish_year",
    establish."改正事由" as "establish_reason",
    dissolve."廃置分合等施行年月日" as "dissolve_date",
    CASE 
        WHEN dissolve."廃置分合等施行年月日" IS NULL THEN 9999
        ELSE YEAR(dissolve."廃置分合等施行年月日")-1
    END as "dissolve_year",
    dissolve."改正事由" as "dissolve_reason",
FROM {{ ref('stg_jcode') }} as jcode
LEFT JOIN {{ ref('stg_establish') }} as establish
ON jcode."標準地域コード" = establish."標準地域コード"
LEFT JOIN {{ ref('stg_dissolve') }} as dissolve
ON jcode."標準地域コード" = dissolve."標準地域コード"
