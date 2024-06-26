SELECT
    int_labor__average_annual_change_in_indices_of_labor_input_by_sector.id as id,
    int_labor__average_annual_change_in_indices_of_labor_input_by_sector.section_id as section_id,
    int_labor__average_annual_change_in_indices_of_labor_input_by_sector.section_name as section_name,
    int_labor__average_annual_change_in_indices_of_labor_input_by_sector.period as period,
    int_labor__average_annual_change_in_indices_of_labor_input_by_sector.input_index_change as input_index_change,
    int_labor__average_annual_change_in_hours_worked.hours_worked_change as hours_worked_change,
    int_labor__average_annual_change_in_indices_of_labor_quality_by_sector.quality_index_change as quality_index_change
FROM
    {{ref('int_labor__average_annual_change_in_indices_of_labor_input_by_sector')}} as int_labor__average_annual_change_in_indices_of_labor_input_by_sector
LEFT JOIN
    {{ref('int_labor__average_annual_change_in_hours_worked')}} as int_labor__average_annual_change_in_hours_worked
    ON (int_labor__average_annual_change_in_hours_worked.section_id = int_labor__average_annual_change_in_indices_of_labor_input_by_sector)
    AND (int_labor__average_annual_change_in_hours_worked.period = int_labor__average_annual_change_in_indices_of_labor_input_by_sector.period)
LEFT JOIN
    {{ref('int_labor__average_annual_change_in_indices_of_labor_quality_by_sector')}} as int_labor__average_annual_change_in_indices_of_labor_quality_by_sector
    ON (int_labor__average_annual_change_in_indices_of_labor_quality_by_sector.section_id = int_labor__average_annual_change_in_indices_of_labor_input_by_sector)
    AND (int_labor__average_annual_change_in_indices_of_labor_quality_by_sector.period = int_labor__average_annual_change_in_indices_of_labor_input_by_sector.period)
ORDER BY id
