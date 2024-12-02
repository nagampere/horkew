WITH 
VA_real as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(value_added_real) as value_added_real
    FROM {{ref('int_value_added__real')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_value_added__real')}}
),
VA_nominal as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(value_added_nominal) as value_added_nominal
    FROM {{ref('int_value_added__nominal')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_value_added__nominal')}}
)
SELECT
    ROW_NUMBER() OVER () as id,
    VA_real.pref_id as pref_id,
    VA_real.pref_name as pref_name,
    VA_real.section_id as section_id,
    VA_real.section_name as section_name,
    VA_real.year as year,
    VA_real.value_added_real as value_added_real,
    VA_nominal.value_added_nominal as value_added_nominal,
FROM VA_real
LEFT JOIN VA_nominal
    ON  (VA_real.pref_id = VA_nominal.pref_id)
    AND (VA_real.section_id = VA_nominal.section_id)
    AND (VA_real.year = VA_nominal.year)
ORDER BY pref_id, section_id, year
