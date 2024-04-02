SELECT
    int_supplementary__nominal_intermediate_inputs.id as id,
    int_supplementary__nominal_intermediate_inputs.section_id as section_id,
    int_supplementary__nominal_intermediate_inputs.section_name as section_name,
    int_supplementary__nominal_intermediate_inputs.year as year,
    int_supplementary__nominal_intermediate_inputs.PM as PM,
    int_supplementary__nominal_value_added.NV as NV,
    int_supplementary__nominal_labor_costs.WL as WL,
    int_supplementary__nominal_capital_service_input.RK as RK,
    int_supplementary__tax_and_subsidy.netTAX as netTAX,
    int_supplementary__labor_share_rate.LaborShare as LaborShare,
    int_supplementary__markup.Markup as Markup
FROM
    {{ref('int_supplementary__nominal_intermediate_inputs')}} as int_supplementary__nominal_intermediate_inputs
LEFT JOIN
    {{ref('int_supplementary__nominal_value_added')}} as int_supplementary__nominal_value_added
    ON (int_supplementary__nominal_value_added.section_id = int_supplementary__nominal_intermediate_inputs.section_id)
    AND (int_supplementary__nominal_value_added.year = int_supplementary__nominal_intermediate_inputs.year)
LEFT JOIN
    {{ref('int_supplementary__nominal_labor_costs')}} as int_supplementary__nominal_labor_costs
    ON (int_supplementary__nominal_labor_costs.section_id = int_supplementary__nominal_intermediate_inputs.section_id)
    AND (int_supplementary__nominal_labor_costs.year = int_supplementary__nominal_intermediate_inputs.year)
LEFT JOIN
    {{ref('int_supplementary__nominal_capital_service_input')}} as int_supplementary__nominal_capital_service_input
    ON (int_supplementary__nominal_capital_service_input.section_id = int_supplementary__nominal_intermediate_inputs.section_id)
    AND (int_supplementary__nominal_capital_service_input.year = int_supplementary__nominal_intermediate_inputs.year)
LEFT JOIN
    {{ref('int_supplementary__tax_and_subsidy')}} as int_supplementary__tax_and_subsidy
    ON (int_supplementary__tax_and_subsidy.section_id = int_supplementary__nominal_intermediate_inputs.section_id)
    AND (int_supplementary__tax_and_subsidy.year = int_supplementary__nominal_intermediate_inputs.year)
LEFT JOIN
    {{ref('int_supplementary__labor_share_rate')}} as int_supplementary__labor_share_rate
    ON (int_supplementary__labor_share_rate.section_id = int_supplementary__nominal_intermediate_inputs.section_id)
    AND (int_supplementary__labor_share_rate.year = int_supplementary__nominal_intermediate_inputs.year)
LEFT JOIN
    {{ref('int_supplementary__markup')}} as int_supplementary__markup
    ON (int_supplementary__markup.section_id = int_supplementary__nominal_intermediate_inputs.section_id)
    AND (int_supplementary__markup.year = int_supplementary__nominal_intermediate_inputs.year)
ORDER BY id
