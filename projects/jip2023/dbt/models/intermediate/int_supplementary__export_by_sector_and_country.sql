WITH union_table AS (
    SELECT * FROM {{ref('stg_supplementary__export_1994')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_1995')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_1996')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_1997')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_1998')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_1999')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2000')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2001')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2002')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2003')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2004')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2005')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2006')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2007')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2008')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2009')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2010')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2011')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2012')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2013')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2014')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2015')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2016')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2017')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2018')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2019')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2020')}}
    UNION ALL BY NAME
    SELECT * FROM {{ref('stg_supplementary__export_2021')}}
    ORDER BY year, section_id
),
unpivot_alias AS (
    UNPIVOT union_table
    ON 
        to103,
        to104,
        to105,
        to106,
        to107,
        to108,
        to110,
        to111,
        to112,
        to113,
        to116,
        to117,
        to118,
        to120,
        to121,
        to122,
        to123,
        to124,
        to125,
        to126,
        to127,
        to128,
        to129,
        to130,
        to131,
        to132,
        to133,
        to134,
        to135,
        to137,
        to138,
        to140,
        to141,
        to143,
        to144,
        to145,
        to146,
        to147,
        to149,
        to150,
        to151,
        to152,
        to153,
        to154,
        to155,
        to156,
        to157,
        to158,
        to201,
        to202,
        to203,
        to204,
        to205,
        to206,
        to207,
        to208,
        to209,
        to210,
        to211,
        to212,
        to213,
        to215,
        to216,
        to217,
        to218,
        to219,
        to220,
        to221,
        to222,
        to223,
        to224,
        to225,
        to227,
        to228,
        to229,
        to230,
        to231,
        to232,
        to233,
        to234,
        to235,
        to236,
        to237,
        to238,
        to239,
        to240,
        to241,
        to242,
        to243,
        to244,
        to245,
        to246,
        to247,
        to248,
        to301,
        to302,
        to303,
        to304,
        to305,
        to306,
        to307,
        to308,
        to309,
        to310,
        to311,
        to312,
        to314,
        to315,
        to316,
        to317,
        to319,
        to320,
        to321,
        to322,
        to323,
        to324,
        to325,
        to326,
        to327,
        to328,
        to329,
        to330,
        to331,
        to332,
        to333,
        to334,
        to335,
        to336,
        to337,
        to401,
        to402,
        to403,
        to404,
        to405,
        to406,
        to407,
        to408,
        to409,
        to410,
        to411,
        to412,
        to413,
        to414,
        to415,
        to501,
        to502,
        to503,
        to504,
        to505,
        to506,
        to507,
        to508,
        to509,
        to510,
        to511,
        to512,
        to513,
        to514,
        to515,
        to516,
        to517,
        to518,
        to519,
        to520,
        to521,
        to522,
        to523,
        to524,
        to525,
        to526,
        to527,
        to528,
        to529,
        to530,
        to531,
        to532,
        to533,
        to534,
        to535,
        to536,
        to537,
        to538,
        to539,
        to540,
        to541,
        to542,
        to543,
        to544,
        to545,
        to546,
        to547,
        to548,
        to549,
        to550,
        to551,
        to552,
        to553,
        to554,
        to555,
        to556,
        to557,
        to558,
        to559,
        to560,
        to601,
        to602,
        to605,
        to606,
        to607,
        to608,
        to609,
        to610,
        to611,
        to612,
        to613,
        to614,
        to615,
        to616,
        to617,
        to618,
        to619,
        to620,
        to621,
        to622,
        to624,
        to625,
        to626,
        to627,
        to628,
        to701,
        to702
    INTO
        NAME to_country
        VALUE to_value
),
to_countries AS (
    SELECT
        country_id // 100 as to_area_id,
        CASE 
            WHEN country_id // 100 == 1 THEN 'Asia'
            WHEN country_id // 100 == 2 THEN 'Europe'
            WHEN country_id // 100 == 3 THEN 'North America'
            WHEN country_id // 100 == 4 THEN 'South America'
            WHEN country_id // 100 == 5 THEN 'Africa'
            WHEN country_id // 100 == 6 THEN 'Oceania'
            WHEN country_id // 100 == 7 THEN 'Special Areas'
        END as to_area_name,
        country_id as to_country_id,
        country_name as to_country_name,
        country_name_ja as to_country_name_ja,
        'to' || cast(country_id as char) as to_country,
        annotation as to_country_annotation
    FROM
        {{ref('stg_supplementary__export_countries')}}
),
joined_table as (
    SELECT 
        unpivot_alias.section_id as section_id,
        unpivot_alias.section_name as section_name,
        unpivot_alias.year as year,
        to_countries.to_area_id as to_area_id,
        to_countries.to_area_name as to_area_name,
        to_countries.to_country_id as to_country_id,
        to_countries.to_country_name as to_country_name,
        to_countries.to_country_name_ja as to_country_name_ja,
        to_countries.to_country_annotation as to_country_annotation,
        unpivot_alias.to_value as to_value
    FROM 
        unpivot_alias
    LEFT JOIN
        to_countries
        ON to_countries.to_country = unpivot_alias.to_country
    ORDER BY year, section_id
)
SELECT 
    ROW_NUMBER() OVER () as id,
    *
FROM
    joined_table


