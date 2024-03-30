SELECT
    int_labor__indices_of_labor_input_by_sector.id as id,
    int_labor__indices_of_labor_input_by_sector.section_id as section_id,
    int_labor__indices_of_labor_input_by_sector.section_name as section_name,
    int_labor__indices_of_labor_input_by_sector.year as year,
    int_labor__indices_of_labor_input_by_sector.input_index as input_index,
    int_labor__indices_of_hours_worked_by_sector.hours_worked_index as hours_worked_index,
    int_labor__indices_of_labor_quality_by_sector.quality_index as quality_index,
    int_labor__number_of_workers_by_sector.number_of_workers as number_of_workers,
    int_labor__hours_worked_by_sector.hours_worked as hours_worked,
    int_labor__nominal_labor_costs_by_sector.nominal_costs as nominal_costs,
    int_labor__share_of_female_workers.share_of_female as share_of_female,
    int_labor__share_of_part_time_workers.share_of_part_time as share_of_part_time,
    int_labor__share_of_workers_aged_55_and_over.share_of_55_over as share_of_55_over
FROM
    {{ref('int_labor__indices_of_labor_input_by_sector')}} as int_labor__indices_of_labor_input_by_sector
LEFT JOIN 
    {{ref('int_labor__indices_of_hours_worked_by_sector')}} as int_labor__indices_of_hours_worked_by_sector
    ON (int_labor__indices_of_hours_worked_by_sector.section_id = int_labor__indices_of_labor_input_by_sector.section_id)
    AND (int_labor__indices_of_hours_worked_by_sector.year = int_labor__indices_of_labor_input_by_sector.year)
LEFT JOIN 
    {{ref('int_labor__indices_of_labor_quality_by_sector')}} as int_labor__indices_of_labor_quality_by_sector
    ON (int_labor__indices_of_labor_quality_by_sector.section_id = int_labor__indices_of_labor_input_by_sector.section_id)
    AND (int_labor__indices_of_labor_quality_by_sector.year = int_labor__indices_of_labor_input_by_sector.year)
LEFT JOIN 
    {{ref('int_labor__number_of_workers_by_sector')}} as int_labor__number_of_workers_by_sector
    ON (int_labor__number_of_workers_by_sector.section_id = int_labor__indices_of_labor_input_by_sector.section_id)
    AND (int_labor__number_of_workers_by_sector.year = int_labor__indices_of_labor_input_by_sector.year)
LEFT JOIN 
    {{ref('int_labor__hours_worked_by_sector')}} as int_labor__hours_worked_by_sector
    ON (int_labor__hours_worked_by_sector.section_id = int_labor__indices_of_labor_input_by_sector.section_id)
    AND (int_labor__hours_worked_by_sector.year = int_labor__indices_of_labor_input_by_sector.year)
LEFT JOIN 
    {{ref('int_labor__nominal_labor_costs_by_sector')}} as int_labor__nominal_labor_costs_by_sector
    ON (int_labor__nominal_labor_costs_by_sector.section_id = int_labor__indices_of_labor_input_by_sector.section_id)
    AND (int_labor__nominal_labor_costs_by_sector.year = int_labor__indices_of_labor_input_by_sector.year)
LEFT JOIN 
    {{ref('int_labor__share_of_female_workers')}} as int_labor__share_of_female_workers
    ON (int_labor__share_of_female_workers.section_id = int_labor__indices_of_labor_input_by_sector.section_id)
    AND (int_labor__share_of_female_workers.year = int_labor__indices_of_labor_input_by_sector.year)
LEFT JOIN 
    {{ref('int_labor__share_of_part_time_workers')}} as int_labor__share_of_part_time_workers
    ON (int_labor__share_of_part_time_workers.section_id = int_labor__indices_of_labor_input_by_sector.section_id)
    AND (int_labor__share_of_part_time_workers.year = int_labor__indices_of_labor_input_by_sector.year)
LEFT JOIN 
    {{ref('int_labor__share_of_workers_aged_55_and_over')}} as int_labor__share_of_workers_aged_55_and_over
    ON (int_labor__share_of_workers_aged_55_and_over.section_id = int_labor__indices_of_labor_input_by_sector.section_id)
    AND (int_labor__share_of_workers_aged_55_and_over.year = int_labor__indices_of_labor_input_by_sector.year)
ORDER BY id
