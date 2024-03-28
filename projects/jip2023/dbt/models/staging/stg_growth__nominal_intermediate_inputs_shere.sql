with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/growth.xlsx',
        layer='PM',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as int) as section_id,
    cast(Field2 as char) as section_name,
    cast(Field43 as double) as "1994",
    cast(Field44 as double) as "1995",
    cast(Field45 as double) as "1996",
    cast(Field46 as double) as "1997",
    cast(Field47 as double) as "1998",
    cast(Field48 as double) as "1999",
    cast(Field49 as double) as "2000",
    cast(Field50 as double) as "2001",
    cast(Field51 as double) as "2002",
    cast(Field52 as double) as "2003",
    cast(Field53 as double) as "2004",
    cast(Field54 as double) as "2005",
    cast(Field55 as double) as "2006",
    cast(Field56 as double) as "2007",
    cast(Field57 as double) as "2008",
    cast(Field58 as double) as "2009",
    cast(Field59 as double) as "2010",
    cast(Field60 as double) as "2011",
    cast(Field61 as double) as "2012",
    cast(Field62 as double) as "2013",
    cast(Field63 as double) as "2014",
    cast(Field64 as double) as "2015",
    cast(Field65 as double) as "2016",
    cast(Field66 as double) as "2017",
    cast(Field67 as double) as "2018",
    cast(Field68 as double) as "2019",
    cast(Field69 as double) as "2020",
    cast(Field70 as double) as "2021",
from
    source
where
    (index between 3 and 102)
