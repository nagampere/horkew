with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/tokyoPT2018/6-1.xlsx',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as char) as purpose,
    cast(Field2 as char) as station,
    cast(Field3 as char) as connection,
    cast(Field4 as int) as bus,
    cast(Field5 as int) as highway_bus,
    cast(Field6 as int) as automobile,
    cast(Field7 as int) as freight,
    cast(Field8 as int) as car_rental,
    cast(Field9 as int) as private_bus,
    cast(Field10 as int) as taxi,
    cast(Field11 as int) as bike,
    cast(Field12 as int) as cycle_rental,
    cast(Field13 as int) as cycle,
    cast(Field14 as int) as walk,
    cast(Field15 as int) as others,
    cast(Field16 as int) as unknown,
    cast(Field17 as int) as total
from
    source
where
    (index between 5 and 43177)