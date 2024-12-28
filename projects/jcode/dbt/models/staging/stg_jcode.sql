SELECT
    ROW_NUMBER() OVER () as id,
    "標準地域コード"::VARCHAR as "標準地域コード",
    "都道府県"::VARCHAR as "都道府県",
    "政令市･郡･支庁･振興局等"::VARCHAR as "政令市･郡･支庁･振興局等",
    "政令市･郡･支庁･振興局等（ふりがな）"::VARCHAR as "政令市･郡･支庁･振興局等（ふりがな）",
    "市区町村"::VARCHAR as "市区町村",
    "市区町村（ふりがな）"::VARCHAR as "市区町村（ふりがな）",
    "廃置分合等施行年月日"::VARCHAR as "廃置分合等施行年月日",
    "廃置分合等情報有無"::VARCHAR as "廃置分合等情報有無"
FROM
    read_csv_auto('../sources/FEA_hyoujun-20241228181305.csv')