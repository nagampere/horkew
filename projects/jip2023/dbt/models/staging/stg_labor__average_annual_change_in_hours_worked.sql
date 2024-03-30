with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/labor__average_annual_change_in_hours_worked.xlsx',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as int) as section_id,
    cast(Field2 as char) as section_name,
    cast(Field3 as double) as "95-00",
    cast(Field4 as double) as "00-05",
    cast(Field5 as double) as "05-10",
    cast(Field6 as double) as "10-15",
    cast(Field7 as double) as "15-20",
    cast(Field8 as double) as "00-10",
    cast(Field9 as double) as "10-20",
    cast(Field10 as double) as "10-18",
    cast(Field11 as double) as "18-20",
    cast(Field12 as double) as "95-20"
from
    source
where
    index between 3 and 102
