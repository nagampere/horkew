WITH
all_exclude_total as (
    SELECT
        value_added.pref_id as pref_id,
        value_added.pref_name as pref_name,
        value_added.pref_id || ':' || value_added.pref_name as pref_id_name,
        value_added.section_id as section_id,
        value_added.section_name as section_name,
        value_added.section_id || ':' || value_added.section_name as section_id_name,
        value_added.year as year,
        value_added.value_added_real as value_added_real,
        value_added.value_added_nominal as value_added_nominal,
        capital.real_capital_stock as real_capital_stock,
        capital.cost_of_capital as cost_of_capital,
        capital.quality_of_capital as quality_of_capital,
        capital.real_capital_stock_patent as real_capital_stock_patent,
        capital.cost_of_capital_patent as cost_of_capital_patent,
        capital.quality_of_capital_patent as quality_of_capital_patent,
        labor.man_hour as man_hour,
        labor.cost_of_labor as cost_of_labor,
        labor.quality_of_labor_index as quality_of_labor_index,
        labor.quality_of_labor_comparison_index as quality_of_labor_comparison_index,
        labor.number_of_employed_persons as number_of_employed_persons,
        TFP.delta_VA as delta_VA,
        TFP.delta_Z as delta_Z,
        TFP.delta_QK as delta_QK,
        TFP.delta_Z_patent as delta_Z_patent,
        TFP.delta_QK_patent as delta_QK_patent,
        TFP.delta_H as delta_H,
        TFP.delta_QL as delta_QL,
        growth_account.labor_productivity as labor_productivity_growth,
        growth_account.capital_stock as capital_stock_growth,
        growth_account.capital_stock_patent as capital_stock_patent_growth,
        growth_account.quality_of_capital as quality_of_capital_growth,
        growth_account.quality_of_capital_patent as quality_of_capital_patent_growth,
        growth_account.quality_of_labor as quality_of_labor_growth,
        growth_account.cost_of_capital_share as cost_of_capital_share,
        growth_account.cost_of_capital_patent_share as cost_of_capital_patent_share,
        growth_account.RTFP as RTFP,
        growth_account.value_added_share as value_added_share,
    FROM {{ref('mrt_value_added')}} as value_added
    LEFT JOIN {{ref('mrt_growth_account')}} as growth_account
        ON  (value_added.pref_id = growth_account.pref_id)
        AND (value_added.section_id = growth_account.section_id)
        AND (value_added.year = growth_account.year)
    LEFT JOIN {{ref('mrt_capital')}} as capital
        ON  (value_added.pref_id = capital.pref_id)
        AND (value_added.section_id = capital.section_id)
        AND (value_added.year = capital.year)
    LEFT JOIN {{ref('mrt_labor')}} as labor
        ON  (value_added.pref_id = labor.pref_id)
        AND (value_added.section_id = labor.section_id)
        AND (value_added.year = labor.year)
    LEFT JOIN {{ref('mrt_TFP')}} as TFP
        ON  (value_added.pref_id = TFP.pref_id)
        AND (value_added.section_id = TFP.section_id)
        AND (value_added.year = TFP.year)
),
total_pref as (
    SELECT
        CAST(0 as int) as pref_id,
        CAST('全国' as varchar) as pref_name,
        CAST('0:全国' as varchar) as pref_id_name,
        section_id,
        first(section_name) as section_name,
        first(section_id_name) as section_id_name,
        year,
        SUM(value_added_real) as value_added_real,
        SUM(value_added_nominal) as value_added_nominal,
        SUM(real_capital_stock) as real_capital_stock,
        SUM(cost_of_capital) as cost_of_capital,
        AVG(quality_of_capital) as quality_of_capital,
        SUM(real_capital_stock_patent) as real_capital_stock_patent,
        SUM(cost_of_capital_patent) as cost_of_capital_patent,
        AVG(quality_of_capital_patent) as quality_of_capital_patent,
        SUM(man_hour) as man_hour,
        SUM(cost_of_labor) as cost_of_labor,
        AVG(quality_of_labor_index) as quality_of_labor_index,
        AVG(quality_of_labor_comparison_index) as quality_of_labor_comparison_index,
        SUM(number_of_employed_persons) as number_of_employed_persons,
        AVG(value_added_real * delta_VA) / AVG(value_added_real) as delta_VA,
        AVG(real_capital_stock * delta_Z) / AVG(real_capital_stock) as delta_Z,
        AVG(quality_of_capital * delta_QK) / AVG(quality_of_capital) as delta_QK,
        AVG(real_capital_stock_patent * delta_Z_patent) / AVG(real_capital_stock_patent) as delta_Z_patent,
        AVG(quality_of_capital_patent * delta_QK_patent) / AVG(quality_of_capital_patent) as delta_QK_patent,
        AVG(man_hour * delta_H) / AVG(man_hour) as delta_H,
        AVG(quality_of_labor_index * delta_QL) / AVG(quality_of_labor_index) as delta_QL,
        AVG(value_added_share * labor_productivity_growth) / AVG(value_added_share) as labor_productivity_growth,
        AVG(value_added_share * capital_stock_growth) / AVG(value_added_share) as capital_stock_growth,
        AVG(value_added_share * capital_stock_patent_growth) / AVG(value_added_share) as capital_stock_patent_growth,
        AVG(value_added_share * quality_of_capital_growth) / AVG(value_added_share) as quality_of_capital_growth,
        AVG(value_added_share * quality_of_capital_patent_growth) / AVG(value_added_share) as quality_of_capital_patent_growth,
        AVG(value_added_share * quality_of_labor_growth) / AVG(value_added_share) as quality_of_labor_growth,
        AVG(value_added_share * cost_of_capital_share) / AVG(value_added_share) as cost_of_capital_share,
        AVG(value_added_share * cost_of_capital_patent_share) / AVG(value_added_share) as cost_of_capital_patent_share,
        AVG(value_added_share * RTFP) / AVG(value_added_share) as RTFP,
        AVG(value_added_share) as value_added_share,
    FROM all_exclude_total
    GROUP BY section_id, year
),
all_marged as (
    SELECT
        *
    FROM all_exclude_total
    UNION ALL
    SELECT
        *
    FROM total_pref
    ORDER BY pref_id, section_id, year
)
SELECT 
    ROW_NUMBER() OVER () as id,
    pref_id,
    pref_name,
    pref_id_name,
    section_id,
    section_name,
    section_id_name,
    year,
    value_added_real,
    value_added_nominal,
    real_capital_stock,
    cost_of_capital,
    quality_of_capital,
    real_capital_stock_patent,
    cost_of_capital_patent,
    quality_of_capital_patent,
    man_hour,
    cost_of_labor,
    quality_of_labor_index,
    quality_of_labor_comparison_index,
    number_of_employed_persons,
    delta_VA - delta_Z - delta_QK - delta_Z_patent - delta_QK_patent - delta_H - delta_QL as TFP,
    delta_VA,
    delta_Z,
    delta_QK,
    delta_Z_patent,
    delta_QK_patent,
    delta_H,
    delta_QL,
    labor_productivity_growth,
    capital_stock_growth,
    capital_stock_patent_growth,
    quality_of_capital_growth,
    quality_of_capital_patent_growth,
    quality_of_labor_growth,
    cost_of_capital_share,
    cost_of_capital_patent_share,
    RTFP,
    value_added_share,
FROM all_marged


