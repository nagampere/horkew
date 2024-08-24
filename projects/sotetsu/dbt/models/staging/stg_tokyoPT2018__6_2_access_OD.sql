with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/tokyoPT2018/6-2.xlsx',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as char) as origin,
    cast(Field2 as char) as destination,
    cast(Field3 as char) as connection,
    cast(Field4 as char) as purpose,
    cast(Field5 as int) as bus,
    cast(Field6 as int) as highway_bus,
    cast(Field7 as int) as automobile,
    cast(Field8 as int) as freight,
    cast(Field9 as int) as car_rental,
    cast(Field10 as int) as private_bus,
    cast(Field11 as int) as taxi,
    cast(Field12 as int) as bike,
    cast(Field13 as int) as cycle_rental,
    cast(Field14 as int) as cycle,
    cast(Field15 as int) as walk,
    cast(Field16 as int) as others,
    cast(Field17 as int) as unknown,
    cast(Field18 as int) as total
from
    source
where
    (index between 5 and 229363)
