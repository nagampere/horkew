WITH unpivot_alias AS (
    UNPIVOT {{ref('stg_labor__average_annual_change_in_hours_worked')}}
    ON 
        '95-00',
        '00-05',
        '05-10',
        '10-15',
        '15-20',
        '00-10',
        '10-20',
        '10-18',
        '18-20',
        '95-20'
    INTO
        NAME period
        VALUE hours_worked_change
)
SELECT 
    ROW_NUMBER() OVER () as id,
    section_id,
    section_name,
    period,
    hours_worked_change
FROM unpivot_alias
