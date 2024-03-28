SELECT
    int_capital__nominal_net_capital_stock_by_asset.id as id,
    int_capital__nominal_net_capital_stock_by_asset.asset_id as asset_id,
    int_capital__nominal_net_capital_stock_by_asset.asset_name as asset_name,
    int_capital__nominal_investment_by_asset.nominal_investment as nominal_investment,
    int_capital__real_investment_by_asset.real_investment as real_investment,
    int_capital__nominal_net_capital_stock_by_asset.nominal_net_stock as nominal_net_stock,
    int_capital__real_net_capital_stock_by_asset.real_net_stock as real_net_stock,
    int_capital__nominal_capital_cost_by_asset.nominal_cost as nominal_cost
FROM
    {{ref('int_capital__nominal_net_capital_stock_by_asset')}} as int_capital__nominal_net_capital_stock_by_asset
LEFT JOIN
    {{ref('int_capital__nominal_investment_by_asset')}} as int_capital__nominal_investment_by_asset
    ON (int_capital__nominal_investment_by_asset.asset_id = int_capital__nominal_net_capital_stock_by_asset.asset_id)
    AND (int_capital__nominal_investment_by_asset.year = int_capital__nominal_net_capital_stock_by_asset.year)
LEFT JOIN
    {{ref('int_capital__real_investment_by_asset')}} as int_capital__real_investment_by_asset
    ON (int_capital__real_investment_by_asset.asset_id = int_capital__nominal_net_capital_stock_by_asset.asset_id)
    AND (int_capital__real_investment_by_asset.year = int_capital__nominal_net_capital_stock_by_asset.year)
LEFT JOIN
    {{ref('int_capital__real_net_capital_stock_by_asset')}} as int_capital__real_net_capital_stock_by_asset
    ON (int_capital__real_net_capital_stock_by_asset.asset_id = int_capital__nominal_net_capital_stock_by_asset.asset_id)
    AND (int_capital__real_net_capital_stock_by_asset.year = int_capital__nominal_net_capital_stock_by_asset.year)
LEFT JOIN
    {{ref('int_capital__nominal_capital_cost_by_asset')}} as int_capital__nominal_capital_cost_by_asset
    ON (int_capital__nominal_capital_cost_by_asset.asset_id = int_capital__nominal_net_capital_stock_by_asset.asset_id)
    AND (int_capital__nominal_capital_cost_by_asset.year = int_capital__nominal_net_capital_stock_by_asset.year)
ORDER BY id
