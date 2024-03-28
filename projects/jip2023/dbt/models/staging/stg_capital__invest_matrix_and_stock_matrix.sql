with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/capital.xlsx',
        layer='投資・資産マトリックス',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as int) as section_id,
    cast(Field2 as char) as section_name,
    cast(Field3 as int) as asset_id,
    cast(Field4 as char) as asset_name,
    cast(Field5 as int) as year,
    cast(Field6 as double) as nominal_investment,
    cast(Field7 as double) as real_investment,
    cast(Field8 as double) as nominal_capital_stock,
    cast(Field9 as double) as real_capital_stock,
    cast(Field10 as double) as nominal_capital_cost
from
    source
where
    index >= 3