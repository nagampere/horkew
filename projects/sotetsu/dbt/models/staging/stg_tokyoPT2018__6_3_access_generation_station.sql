with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/tokyoPT2018/6-3.xlsx',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as char) as station,
    cast(Field2 as char) as s_zone,
    cast(Field3 as char) as purpose,
    cast(Field4 as int) as access_bus,
    cast(Field5 as int) as access_highway_bus,
    cast(Field6 as int) as access_automobile,
    cast(Field7 as int) as access_freight,
    cast(Field8 as int) as access_car_rental,
    cast(Field9 as int) as access_private_bus,
    cast(Field10 as int) as access_taxi,
    cast(Field11 as int) as access_bike,
    cast(Field12 as int) as access_cycle_rental,
    cast(Field13 as int) as access_cycle,
    cast(Field14 as int) as access_walk,
    cast(Field15 as int) as access_others,
    cast(Field16 as int) as access_unknown,
    cast(Field17 as int) as access_total,
    cast(Field18 as int) as egress_bus,
    cast(Field19 as int) as egress_highway_bus,
    cast(Field20 as int) as egress_automobile,
    cast(Field21 as int) as egress_freight,
    cast(Field22 as int) as egress_car_rental,
    cast(Field23 as int) as egress_private_bus,
    cast(Field24 as int) as egress_taxi,
    cast(Field25 as int) as egress_bike,
    cast(Field26 as int) as egress_cycle_rental,
    cast(Field27 as int) as egress_cycle,
    cast(Field28 as int) as egress_walk,
    cast(Field29 as int) as egress_others,
    cast(Field30 as int) as egress_unknown,
    cast(Field31 as int) as egress_total,
    cast(Field32 as int) as total_bus,
    cast(Field33 as int) as total_highway_bus,
    cast(Field34 as int) as total_automobile,
    cast(Field35 as int) as total_freight,
    cast(Field36 as int) as total_car_rental,
    cast(Field37 as int) as total_private_bus,
    cast(Field38 as int) as total_taxi,
    cast(Field39 as int) as total_bike,
    cast(Field40 as int) as total_cycle_rental,
    cast(Field41 as int) as total_cycle,
    cast(Field42 as int) as total_walk,
    cast(Field43 as int) as total_others,
    cast(Field44 as int) as total_unknown,
    cast(Field45 as int) as total_total
from
    source
where
    (index between 5 and 97274)
