WITH 
real_capital_stock as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(real_capital_stock) as real_capital_stock
    FROM {{ref('int_capital__real_capital_stock')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_capital__real_capital_stock')}}
),
real_capital_stock_patent as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(real_capital_stock_patent) as real_capital_stock_patent
    FROM {{ref('int_capital__real_capital_stock_patent')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_capital__real_capital_stock_patent')}}
),
cost_of_capital as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(cost_of_capital) as cost_of_capital
    FROM {{ref('int_capital__cost_of_capital')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_capital__cost_of_capital')}}
),
cost_of_capital_patent as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        SUM(cost_of_capital_patent) as cost_of_capital_patent
    FROM {{ref('int_capital__cost_of_capital_patent')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_capital__cost_of_capital_patent')}}
),
quality_of_capital as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        AVG(quality_of_capital) as quality_of_capital
    FROM {{ref('int_capital__quality_of_capital')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_capital__quality_of_capital')}}
),
quality_of_capital_patent as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        AVG(quality_of_capital_patent) as quality_of_capital_patent
    FROM {{ref('int_capital__quality_of_capital_patent')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_capital__quality_of_capital_patent')}}
)
SELECT
    ROW_NUMBER() OVER () as id,
    real_capital_stock.pref_id as pref_id,
    real_capital_stock.pref_name as pref_name,
    real_capital_stock.section_id as section_id,
    real_capital_stock.section_name as section_name,
    real_capital_stock.year as year,
    real_capital_stock.real_capital_stock as real_capital_stock,
    real_capital_stock_patent.real_capital_stock_patent as real_capital_stock_patent,
    cost_of_capital.cost_of_capital as cost_of_capital,
    cost_of_capital_patent.cost_of_capital_patent as cost_of_capital_patent,
    quality_of_capital.quality_of_capital as quality_of_capital,
    quality_of_capital_patent.quality_of_capital_patent as quality_of_capital_patent,
FROM real_capital_stock
LEFT JOIN real_capital_stock_patent
    ON  (real_capital_stock.pref_id = real_capital_stock_patent.pref_id)
    AND (real_capital_stock.section_id = real_capital_stock_patent.section_id)
    AND (real_capital_stock.year = real_capital_stock_patent.year)
LEFT JOIN cost_of_capital
    ON  (real_capital_stock.pref_id = cost_of_capital.pref_id)
    AND (real_capital_stock.section_id = cost_of_capital.section_id)
    AND (real_capital_stock.year = cost_of_capital.year)
LEFT JOIN cost_of_capital_patent
    ON  (real_capital_stock.pref_id = cost_of_capital_patent.pref_id)
    AND (real_capital_stock.section_id = cost_of_capital_patent.section_id)
    AND (real_capital_stock.year = cost_of_capital_patent.year)
LEFT JOIN quality_of_capital
    ON  (real_capital_stock.pref_id = quality_of_capital.pref_id)
    AND (real_capital_stock.section_id = quality_of_capital.section_id)
    AND (real_capital_stock.year = quality_of_capital.year)
LEFT JOIN quality_of_capital_patent
    ON  (real_capital_stock.pref_id = quality_of_capital_patent.pref_id)
    AND (real_capital_stock.section_id = quality_of_capital_patent.section_id)
    AND (real_capital_stock.year = quality_of_capital_patent.year)
ORDER BY pref_id, section_id, year
