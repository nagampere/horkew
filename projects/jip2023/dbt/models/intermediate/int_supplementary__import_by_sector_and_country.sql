WITH union_table AS (
    SELECT * FROM {{ref('stg_supplementary__import_1994')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_1995')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_1996')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_1997')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_1998')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_1999')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2000')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2001')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2002')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2003')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2004')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2005')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2006')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2007')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2008')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2009')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2010')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2011')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2012')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2013')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2014')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2015')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2016')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2017')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2018')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2019')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2020')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__import_2021')}}
    ORDER BY year, section_id
),
unpivot_alias AS (
    UNPIVOT union_table
    ON 
        from103,
        from104,
        from105,
        from106,
        from107,
        from108,
        from110,
        from111,
        from112,
        from113,
        from116,
        from117,
        from118,
        from120,
        from121,
        from122,
        from123,
        from124,
        from125,
        from126,
        from127,
        from128,
        from129,
        from130,
        from131,
        from132,
        from133,
        from134,
        from135,
        from137,
        from138,
        from140,
        from141,
        from143,
        from144,
        from145,
        from146,
        from147,
        from149,
        from150,
        from151,
        from152,
        from153,
        from154,
        from155,
        from156,
        from157,
        from158,
        from201,
        from202,
        from203,
        from204,
        from205,
        from206,
        from207,
        from208,
        from209,
        from210,
        from211,
        from212,
        from213,
        from215,
        from216,
        from217,
        from218,
        from219,
        from220,
        from221,
        from222,
        from223,
        from224,
        from225,
        from227,
        from228,
        from229,
        from230,
        from231,
        from232,
        from233,
        from234,
        from235,
        from236,
        from237,
        from238,
        from239,
        from240,
        from241,
        from242,
        from243,
        from244,
        from245,
        from246,
        from247,
        from248,
        from301,
        from302,
        from303,
        from304,
        from305,
        from306,
        from307,
        from308,
        from309,
        from310,
        from311,
        from312,
        from314,
        from315,
        from316,
        from317,
        from319,
        from320,
        from321,
        from322,
        from323,
        from324,
        from325,
        from326,
        from327,
        from328,
        from329,
        from330,
        from331,
        from332,
        from333,
        from334,
        from335,
        from336,
        from337,
        from401,
        from402,
        from403,
        from404,
        from405,
        from406,
        from407,
        from408,
        from409,
        from410,
        from411,
        from412,
        from413,
        from414,
        from415,
        from501,
        from502,
        from503,
        from504,
        from505,
        from506,
        from507,
        from508,
        from509,
        from510,
        from511,
        from512,
        from513,
        from514,
        from515,
        from516,
        from517,
        from518,
        from519,
        from520,
        from521,
        from522,
        from523,
        from524,
        from525,
        from526,
        from527,
        from528,
        from529,
        from530,
        from531,
        from532,
        from533,
        from534,
        from535,
        from536,
        from537,
        from538,
        from539,
        from540,
        from541,
        from542,
        from543,
        from544,
        from545,
        from546,
        from547,
        from548,
        from549,
        from550,
        from551,
        from552,
        from553,
        from554,
        from555,
        from556,
        from557,
        from558,
        from559,
        from560,
        from601,
        from602,
        from605,
        from606,
        from607,
        from608,
        from609,
        from610,
        from611,
        from612,
        from613,
        from614,
        from615,
        from616,
        from617,
        from618,
        from619,
        from620,
        from621,
        from622,
        from624,
        from625,
        from626,
        from627,
        from628,
        from701,
        from702
    INTO
        NAME from_country
        VALUE from_value
),
from_countries AS (
    SELECT
        country_id // 100 as from_area_id,
        CASE 
            WHEN country_id // 100 == 1 THEN 'Asia'
            WHEN country_id // 100 == 2 THEN 'Europe'
            WHEN country_id // 100 == 3 THEN 'North America'
            WHEN country_id // 100 == 4 THEN 'South America'
            WHEN country_id // 100 == 5 THEN 'Africa'
            WHEN country_id // 100 == 6 THEN 'Oceania'
            WHEN country_id // 100 == 7 THEN 'Special Areas'
        END as from_area_name,
        country_id as from_country_id,
        country_name as from_country_name,
        country_name_ja as from_country_name_ja,
        'from' || cast(country_id as char) as from_country,
        annotation as from_country_annotation
    FROM
        {{ref('stg_supplementary__import_countries')}}
),
joined_table as (
    SELECT 
        unpivot_alias.section_id as section_id,
        unpivot_alias.section_name as section_name,
        unpivot_alias.year as year,
        from_countries.from_area_id,
        from_countries.from_area_name,
        from_countries.from_country_id,
        from_countries.from_country_name,
        from_countries.from_country_name_ja,
        from_countries.from_country_annotation,
        unpivot_alias.from_value as from_value
    FROM 
        unpivot_alias
    LEFT JOIN
        from_countries
        ON from_countries.from_country = unpivot_alias.from_country
    ORDER BY year, section_id
)
SELECT 
    ROW_NUMBER() OVER () as id,
    *
FROM
    joined_table


