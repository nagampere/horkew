SELECT
    int_capital__indices_of_capital_input_by_sector.id as id,
    int_capital__indices_of_capital_input_by_sector.section_id as section_id,
    int_capital__indices_of_capital_input_by_sector.section_name as section_name,
    int_capital__nominal_investment_by_sector.nominal_investment as nominal_investment,
    int_capital__real_investment_by_sector.real_investment as real_investment,
    int_capital__indices_of_capital_input_by_sector.input_index as input_index,
    int_capital__indices_of_capital_quality_by_sector.quality_index as quality_index,
    int_capital__nominal_net_capital_stock_by_sector.nominal_net_stock as nominal_net_stock,
    int_capital__real_net_capital_stock_by_sector.real_net_stock as real_net_stock,
    int_capital__nominal_capital_cost_by_sector.nominal_cost as nominal_cost
FROM
    {{ref('int_capital__indices_of_capital_input_by_sector')}} as int_capital__indices_of_capital_input_by_sector

LEFT JOIN
    {{ref('int_capital__nominal_investment_by_sector')}} as int_capital__nominal_investment_by_sector
    ON (int_capital__nominal_investment_by_sector.section_id = int_capital__indices_of_capital_input_by_sector.section_id)
    AND (int_capital__nominal_investment_by_sector.year = int_capital__indices_of_capital_input_by_sector.year)
LEFT JOIN
    {{ref('int_capital__real_investment_by_sector')}} as int_capital__real_investment_by_sector
    ON (int_capital__real_investment_by_sector.section_id = int_capital__indices_of_capital_input_by_sector.section_id)
    AND (int_capital__real_investment_by_sector.year = int_capital__indices_of_capital_input_by_sector.year)
LEFT JOIN
    {{ref('int_capital__indices_of_capital_quality_by_sector')}} as int_capital__indices_of_capital_quality_by_sector
    ON (int_capital__indices_of_capital_quality_by_sector.section_id = int_capital__indices_of_capital_input_by_sector.section_id)
    AND (int_capital__indices_of_capital_quality_by_sector.year = int_capital__indices_of_capital_input_by_sector.year)
LEFT JOIN
    {{ref('int_capital__nominal_net_capital_stock_by_sector')}} as int_capital__nominal_net_capital_stock_by_sector
    ON (int_capital__nominal_net_capital_stock_by_sector.section_id = int_capital__indices_of_capital_input_by_sector.section_id)
    AND (int_capital__nominal_net_capital_stock_by_sector.year = int_capital__indices_of_capital_input_by_sector.year)
LEFT JOIN
    {{ref('int_capital__real_net_capital_stock_by_sector')}} as int_capital__real_net_capital_stock_by_sector
    ON (int_capital__real_net_capital_stock_by_sector.section_id = int_capital__indices_of_capital_input_by_sector.section_id)
    AND (int_capital__real_net_capital_stock_by_sector.year = int_capital__indices_of_capital_input_by_sector.year)
LEFT JOIN
    {{ref('int_capital__nominal_capital_cost_by_sector')}} as int_capital__nominal_capital_cost_by_sector
    ON (int_capital__nominal_capital_cost_by_sector.section_id = int_capital__indices_of_capital_input_by_sector.section_id)
    AND (int_capital__nominal_capital_cost_by_sector.year = int_capital__indices_of_capital_input_by_sector.year)
ORDER BY id
