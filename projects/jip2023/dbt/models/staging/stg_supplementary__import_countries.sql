with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/supplementary_import.xlsx',
        layer='Note',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as char) as area,
    cast(Field2 as int) as country_id,
    cast(Field3 as char) as country_name,
    cast(Field8 as double) as country_name_ja,
    cast(Field9 as double) as annotation
from
    source
where
    (index between 5 and 239) 
