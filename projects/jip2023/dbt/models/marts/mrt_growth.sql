SELECT
    int_growth__nominal_gross_inputs.id as id,
    int_growth__nominal_gross_inputs.section_id as section_id,
    int_growth__nominal_gross_inputs.section_name as section_name,
    int_growth__nominal_gross_inputs.year as year,
    int_growth__real_gross_inputs.Y as Y,
    int_growth__nominal_gross_inputs.YC as YC,
    int_growth__nominal_gross_inputs_shere.YC_share as YC_share,
    int_growth__real_intermediate_inputs.M as M,
    int_growth__nominal_intermediate_inputs.PM as PM,
    int_growth__nominal_intermediate_inputs_shere.PM_share as PM_share,
    int_growth__real_value_added.V as V,
    int_growth__nominal_value_added.NV as NV,
    int_growth__nominal_value_added_shere.NV_share as NV_share,
    int_growth__labor_input_index.L as L,
    int_growth__hours_worked_index.H_index as H_index,
    int_growth__hours_worked.H as H,
    int_growth__labor_quality_index.LC as LC,
    int_growth__nominal_labor_costs.WL as WL,
    int_growth__capital_service_input.K as K,
    int_growth__real_net_capital_stock_index.K_T_index as K_T_index,
    int_growth__real_net_capital_stock.K_T as K_T,
    int_growth__capital_quality_index.KC as KC,
    int_growth__nominal_capital_service_input.RK as RK,
    int_growth__cost_share_of_intermediate_including_intermediate_inputs.Cy_PM as Cy_PM,
    int_growth__cost_share_of_labor_including_intermediate_inputs.Cy_WL as Cy_WL,
    int_growth__cost_share_of_capital_including_intermediate_inputs.Cy_RK as Cy_RK,
    int_growth__cost_share_of_labor_excluding_intermediate_inputs.Cv_WL as Cv_WL,
    int_growth__cost_share_of_capital_excluding_intermediate_inputs.Cv_RK as Cv_RK,
    int_growth__growth_rate_of_real_gross_output.Y_G as Y_G,
    int_growth__contribution_of_intermediate_inputs_gross_output_basis.YConM as YConM,
    int_growth__contribution_of_hours_worked_gross_output_basis.YConH as YConH,
    int_growth__contribution_of_labor_quality_gross_output_basis.YConLC as YConLC,
    int_growth__contribution_of_real_net_capital_stock_gross_output_basis.YConK_T as YConK_T,
    int_growth__contribution_of_capital_quality_gross_output_basis.YConKC as YConKC,
    int_growth__TFP_growth_rate_gross_output_basis.TFPy as TFPy,
    int_growth__growth_rate_of_real_value_added.V_G as V_G,
    int_growth__contribution_of_hours_worked_value_added_basis.VConH as VConH,
    int_growth__contribution_of_labor_quality_value_added_basis.VConLC as VConLC,
    int_growth__contribution_of_real_net_capital_stock_value_added_basis.VConK_T as VConK_T,
    int_growth__contribution_of_capital_quality_value_added_basis.VConKC as VConKC,
    int_growth__TFP_growth_rate_value_added_basis.TFPva as TFPva,
    int_growth__labor_producitvity_growth_rate.LP_G as LP_G,
    int_growth__growth_rate_of_total_hours_worked.H_G as H_G,
    int_growth__contribution_of_capital_stock_per_total_hours_worked_value_added_basis.LPConK_T as LPConK_T
FROM
    {{ref('int_growth__real_gross_inputs')}} as int_growth__real_gross_inputs
LEFT JOIN
    {{ref('int_growth__nominal_gross_inputs')}} as int_growth__nominal_gross_inputs
    ON (int_growth__nominal_gross_inputs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__nominal_gross_inputs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__nominal_gross_inputs_shere')}} as int_growth__nominal_gross_inputs_shere
    ON (int_growth__nominal_gross_inputs_shere.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__nominal_gross_inputs_shere.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__real_intermediate_inputs')}} as int_growth__real_intermediate_inputs
    ON (int_growth__real_intermediate_inputs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__real_intermediate_inputs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__nominal_intermediate_inputs')}} as int_growth__nominal_intermediate_inputs
    ON (int_growth__nominal_intermediate_inputs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__nominal_intermediate_inputs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__nominal_intermediate_inputs_shere')}} as int_growth__nominal_intermediate_inputs_shere
    ON (int_growth__nominal_intermediate_inputs_shere.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__nominal_intermediate_inputs_shere.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__real_value_added')}} as int_growth__real_value_added
    ON (int_growth__real_value_added.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__real_value_added.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__nominal_value_added')}} as int_growth__nominal_value_added
    ON (int_growth__nominal_value_added.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__nominal_value_added.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__nominal_value_added_shere')}} as int_growth__nominal_value_added_shere
    ON (int_growth__nominal_value_added_shere.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__nominal_value_added_shere.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__labor_input_index')}} as int_growth__labor_input_index
    ON (int_growth__labor_input_index.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__labor_input_index.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__hours_worked_index')}} as int_growth__hours_worked_index
    ON (int_growth__hours_worked_index.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__hours_worked_index.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__hours_worked')}} as int_growth__hours_worked
    ON (int_growth__hours_worked.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__hours_worked.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__labor_quality_index')}} as int_growth__labor_quality_index
    ON (int_growth__labor_quality_index.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__labor_quality_index.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__nominal_labor_costs')}} as int_growth__nominal_labor_costs
    ON (int_growth__nominal_labor_costs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__nominal_labor_costs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__capital_service_input')}} as int_growth__capital_service_input
    ON (int_growth__capital_service_input.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__capital_service_input.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__real_net_capital_stock_index')}} as int_growth__real_net_capital_stock_index
    ON (int_growth__real_net_capital_stock_index.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__real_net_capital_stock_index.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__real_net_capital_stock')}} as int_growth__real_net_capital_stock
    ON (int_growth__real_net_capital_stock.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__real_net_capital_stock.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__capital_quality_index')}} as int_growth__capital_quality_index
    ON (int_growth__capital_quality_index.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__capital_quality_index.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__nominal_capital_service_input')}} as int_growth__nominal_capital_service_input
    ON (int_growth__nominal_capital_service_input.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__nominal_capital_service_input.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__cost_share_of_intermediate_including_intermediate_inputs')}} as int_growth__cost_share_of_intermediate_including_intermediate_inputs
    ON (int_growth__cost_share_of_intermediate_including_intermediate_inputs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__cost_share_of_intermediate_including_intermediate_inputs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__cost_share_of_labor_including_intermediate_inputs')}} as int_growth__cost_share_of_labor_including_intermediate_inputs
    ON (int_growth__cost_share_of_labor_including_intermediate_inputs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__cost_share_of_labor_including_intermediate_inputs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__cost_share_of_capital_including_intermediate_inputs')}} as int_growth__cost_share_of_capital_including_intermediate_inputs
    ON (int_growth__cost_share_of_capital_including_intermediate_inputs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__cost_share_of_capital_including_intermediate_inputs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__cost_share_of_labor_excluding_intermediate_inputs')}} as int_growth__cost_share_of_labor_excluding_intermediate_inputs
    ON (int_growth__cost_share_of_labor_excluding_intermediate_inputs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__cost_share_of_labor_excluding_intermediate_inputs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__cost_share_of_capital_excluding_intermediate_inputs')}} as int_growth__cost_share_of_capital_excluding_intermediate_inputs
    ON (int_growth__cost_share_of_capital_excluding_intermediate_inputs.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__cost_share_of_capital_excluding_intermediate_inputs.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__growth_rate_of_real_gross_output')}} as int_growth__growth_rate_of_real_gross_output
    ON (int_growth__growth_rate_of_real_gross_output.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__growth_rate_of_real_gross_output.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_intermediate_inputs_gross_output_basis')}} as int_growth__contribution_of_intermediate_inputs_gross_output_basis
    ON (int_growth__contribution_of_intermediate_inputs_gross_output_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_intermediate_inputs_gross_output_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_hours_worked_gross_output_basis')}} as int_growth__contribution_of_hours_worked_gross_output_basis
    ON (int_growth__contribution_of_hours_worked_gross_output_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_hours_worked_gross_output_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_labor_quality_gross_output_basis')}} as int_growth__contribution_of_labor_quality_gross_output_basis
    ON (int_growth__contribution_of_labor_quality_gross_output_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_labor_quality_gross_output_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_real_net_capital_stock_gross_output_basis')}} as int_growth__contribution_of_real_net_capital_stock_gross_output_basis
    ON (int_growth__contribution_of_real_net_capital_stock_gross_output_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_real_net_capital_stock_gross_output_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_capital_quality_gross_output_basis')}} as int_growth__contribution_of_capital_quality_gross_output_basis
    ON (int_growth__contribution_of_capital_quality_gross_output_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_capital_quality_gross_output_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__TFP_growth_rate_gross_output_basis')}} as int_growth__TFP_growth_rate_gross_output_basis
    ON (int_growth__TFP_growth_rate_gross_output_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__TFP_growth_rate_gross_output_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__growth_rate_of_real_value_added')}} as int_growth__growth_rate_of_real_value_added
    ON (int_growth__growth_rate_of_real_value_added.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__growth_rate_of_real_value_added.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_hours_worked_value_added_basis')}} as int_growth__contribution_of_hours_worked_value_added_basis
    ON (int_growth__contribution_of_hours_worked_value_added_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_hours_worked_value_added_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_labor_quality_value_added_basis')}} as int_growth__contribution_of_labor_quality_value_added_basis
    ON (int_growth__contribution_of_labor_quality_value_added_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_labor_quality_value_added_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_real_net_capital_stock_value_added_basis')}} as int_growth__contribution_of_real_net_capital_stock_value_added_basis
    ON (int_growth__contribution_of_real_net_capital_stock_value_added_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_real_net_capital_stock_value_added_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_capital_quality_value_added_basis')}} as int_growth__contribution_of_capital_quality_value_added_basis
    ON (int_growth__contribution_of_capital_quality_value_added_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_capital_quality_value_added_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__TFP_growth_rate_value_added_basis')}} as int_growth__TFP_growth_rate_value_added_basis
    ON (int_growth__TFP_growth_rate_value_added_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__TFP_growth_rate_value_added_basis.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__labor_producitvity_growth_rate')}} as int_growth__labor_producitvity_growth_rate
    ON (int_growth__labor_producitvity_growth_rate.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__labor_producitvity_growth_rate.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__growth_rate_of_total_hours_worked')}} as int_growth__growth_rate_of_total_hours_worked
    ON (int_growth__growth_rate_of_total_hours_worked.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__growth_rate_of_total_hours_worked.year = int_growth__real_gross_inputs.year)
LEFT JOIN
    {{ref('int_growth__contribution_of_capital_stock_per_total_hours_worked_value_added_basis')}} as int_growth__contribution_of_capital_stock_per_total_hours_worked_value_added_basis
    ON (int_growth__contribution_of_capital_stock_per_total_hours_worked_value_added_basis.section_id = int_growth__real_gross_inputs.section_id)
    AND (int_growth__contribution_of_capital_stock_per_total_hours_worked_value_added_basis.year = int_growth__real_gross_inputs.year)
ORDER BY id
