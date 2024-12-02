WITH 
man_hour as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(man_hour) as man_hour
    FROM {{ref('int_labor__man_hour')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_labor__man_hour')}}
),
cost_of_labor as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(cost_of_labor) as cost_of_labor
    FROM {{ref('int_labor__cost_of_labor')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_labor__cost_of_labor')}}
),
quality_of_labor_index as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        AVG(quality_of_labor_index) as quality_of_labor_index
    FROM {{ref('int_labor__quality_of_labor_index')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_labor__quality_of_labor_index')}}
),
quality_of_labor_comparison_index as (
    SELECT * FROM {{ref('int_labor__quality_of_labor_comparison_index')}}
),
number_of_employed_persons as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(number_of_employed_persons) as number_of_employed_persons
    FROM {{ref('int_labor__number_of_employed_persons')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_labor__number_of_employed_persons')}}
)
SELECT
    ROW_NUMBER() OVER () as id,
    man_hour.pref_id as pref_id,
    man_hour.pref_name as pref_name,
    man_hour.section_id as section_id,
    man_hour.section_name as section_name,
    man_hour.year as year,
    man_hour.man_hour as man_hour,
    cost_of_labor.cost_of_labor as cost_of_labor,
    quality_of_labor_index.quality_of_labor_index as quality_of_labor_index,
    quality_of_labor_comparison_index.quality_of_labor_comparison_index as quality_of_labor_comparison_index,
    number_of_employed_persons.number_of_employed_persons as number_of_employed_persons,
FROM man_hour
LEFT JOIN cost_of_labor
    ON  (man_hour.pref_id = cost_of_labor.pref_id)
    AND (man_hour.section_id = cost_of_labor.section_id)
    AND (man_hour.year = cost_of_labor.year)
LEFT JOIN quality_of_labor_index
    ON  (man_hour.pref_id = quality_of_labor_index.pref_id)
    AND (man_hour.section_id = quality_of_labor_index.section_id)
    AND (man_hour.year = quality_of_labor_index.year)
LEFT JOIN quality_of_labor_comparison_index
    ON  (man_hour.pref_id = quality_of_labor_comparison_index.pref_id)
    AND (man_hour.section_id = quality_of_labor_comparison_index.section_id)
    AND (man_hour.year = quality_of_labor_comparison_index.year)
LEFT JOIN number_of_employed_persons
    ON  (man_hour.pref_id = number_of_employed_persons.pref_id)
    AND (man_hour.section_id = number_of_employed_persons.section_id)
    AND (man_hour.year = number_of_employed_persons.year)
ORDER BY pref_id, section_id, year
