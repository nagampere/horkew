{{ config(materialized='view') }}

with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/growth.xlsx',
        layer='Cy',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as int) as section_id,
    cast(Field2 as char) as section_name,
    cast(Field59 as double) as "1994",
    cast(Field60 as double) as "1995",
    cast(Field61 as double) as "1996",
    cast(Field62 as double) as "1997",
    cast(Field63 as double) as "1998",
    cast(Field64 as double) as "1999",
    cast(Field65 as double) as "2000",
    cast(Field66 as double) as "2001",
    cast(Field67 as double) as "2002",
    cast(Field68 as double) as "2003",
    cast(Field69 as double) as "2004",
    cast(Field70 as double) as "2005",
    cast(Field71 as double) as "2006",
    cast(Field72 as double) as "2007",
    cast(Field73 as double) as "2008",
    cast(Field74 as double) as "2009",
    cast(Field75 as double) as "2010",
    cast(Field76 as double) as "2011",
    cast(Field77 as double) as "2012",
    cast(Field78 as double) as "2013",
    cast(Field79 as double) as "2014",
    cast(Field80 as double) as "2015",
    cast(Field81 as double) as "2016",
    cast(Field82 as double) as "2017",
    cast(Field83 as double) as "2018",
    cast(Field84 as double) as "2019",
    cast(Field85 as double) as "2020",
    cast(Field86 as double) as "2021",
from
    source
where
    (index between 3 and 102) or 
    (index between 105 and 111)
