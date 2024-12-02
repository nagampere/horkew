WITH 
RTFP_all as (
    SELECT 
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        RTFP
    FROM {{ref('int_growth_account__RTFP')}}
    UNION ALL
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        RTFP
    FROM {{ref('int_growth_account__RTFP_agg')}}
),
labor_productivity as (
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        labor_productivity
    FROM {{ref('int_growth_account__labor_productivity')}}
    UNION ALL
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        labor_productivity
    FROM {{ref('int_growth_account__labor_productivity_agg')}}
),
capital_stock as (
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        capital_stock
    FROM {{ref('int_growth_account__capital_stock')}}
    UNION ALL
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        capital_stock
    FROM {{ref('int_growth_account__capital_stock_agg')}}
),
capital_stock_patent as (
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        capital_stock_patent
    FROM {{ref('int_growth_account__capital_stock_patent')}}
    UNION ALL
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        capital_stock_patent
    FROM {{ref('int_growth_account__capital_stock_patent_agg')}}
),
quality_of_capital as (
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        quality_of_capital
    FROM {{ref('int_growth_account__quality_of_capital')}}
    UNION ALL
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        quality_of_capital
    FROM {{ref('int_growth_account__quality_of_capital_agg')}}
),
quality_of_capital_patent as (
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        quality_of_capital_patent
    FROM {{ref('int_growth_account__quality_of_capital_patent')}}
    UNION ALL
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        quality_of_capital_patent
    FROM {{ref('int_growth_account__quality_of_capital_patent_agg')}}
),
quality_of_labor as (
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        quality_of_labor
    FROM {{ref('int_growth_account__quality_of_labor')}}
    UNION ALL
    SELECT
        id,
        pref_id,
        pref_name,
        section_id,
        section_name,
        year,
        quality_of_labor
    FROM {{ref('int_growth_account__quality_of_labor_agg')}}
),
value_added_share as (
    SELECT 
        pref_id,
        first(pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        year,
        CAST(1 as double) as value_added_share
    FROM {{ref('int_growth_account__value_added_share')}}
    GROUP BY pref_id, year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_growth_account__value_added_share')}}
)
SELECT
    ROW_NUMBER() OVER () as id,
    RTFP_all.pref_id as pref_id,
    RTFP_all.pref_name as pref_name,
    RTFP_all.section_id as section_id,
    RTFP_all.section_name as section_name,
    RTFP_all.year as year,
    labor_productivity.labor_productivity as labor_productivity,
    capital_stock.capital_stock as capital_stock,
    quality_of_capital.quality_of_capital as quality_of_capital,
    capital_stock_patent.capital_stock_patent as capital_stock_patent,
    quality_of_capital_patent.quality_of_capital_patent as quality_of_capital_patent,
    quality_of_labor.quality_of_labor as quality_of_labor,
    cost_of_capital_share.cost_of_capital_share as cost_of_capital_share,
    cost_of_capital_patent_share.cost_of_capital_patent_share as cost_of_capital_patent_share,
    RTFP_all.RTFP as RTFP,
    value_added_share.value_added_share as value_added_share,
FROM RTFP_all
LEFT JOIN labor_productivity
    ON  (RTFP_all.pref_id = labor_productivity.pref_id)
    AND (RTFP_all.section_id = labor_productivity.section_id)
    AND (RTFP_all.year = labor_productivity.year)
LEFT JOIN capital_stock
    ON  (RTFP_all.pref_id = capital_stock.pref_id)
    AND (RTFP_all.section_id = capital_stock.section_id)
    AND (RTFP_all.year = capital_stock.year)
LEFT JOIN capital_stock_patent
    ON  (RTFP_all.pref_id = capital_stock_patent.pref_id)
    AND (RTFP_all.section_id = capital_stock_patent.section_id)
    AND (RTFP_all.year = capital_stock_patent.year)
LEFT JOIN quality_of_capital
    ON  (RTFP_all.pref_id = quality_of_capital.pref_id)
    AND (RTFP_all.section_id = quality_of_capital.section_id)
    AND (RTFP_all.year = quality_of_capital.year)
LEFT JOIN quality_of_capital_patent
    ON  (RTFP_all.pref_id = quality_of_capital_patent.pref_id)
    AND (RTFP_all.section_id = quality_of_capital_patent.section_id)
    AND (RTFP_all.year = quality_of_capital_patent.year)
LEFT JOIN quality_of_labor
    ON  (RTFP_all.pref_id = quality_of_labor.pref_id)
    AND (RTFP_all.section_id = quality_of_labor.section_id)
    AND (RTFP_all.year = quality_of_labor.year)
LEFT JOIN {{ref('int_growth_account__cost_of_capital_share')}} as cost_of_capital_share
    ON  (RTFP_all.pref_id = cost_of_capital_share.pref_id)
    AND (RTFP_all.section_id = cost_of_capital_share.section_id)
    AND (RTFP_all.year = cost_of_capital_share.year)
LEFT JOIN {{ref('int_growth_account__cost_of_capital_patent_share')}} as cost_of_capital_patent_share
    ON  (RTFP_all.pref_id = cost_of_capital_patent_share.pref_id)
    AND (RTFP_all.section_id = cost_of_capital_patent_share.section_id)
    AND (RTFP_all.year = cost_of_capital_patent_share.year)
LEFT JOIN value_added_share
    ON  (RTFP_all.pref_id = value_added_share.pref_id)
    AND (RTFP_all.section_id = value_added_share.section_id)
    AND (RTFP_all.year = value_added_share.year)
ORDER BY pref_id, section_id, year
