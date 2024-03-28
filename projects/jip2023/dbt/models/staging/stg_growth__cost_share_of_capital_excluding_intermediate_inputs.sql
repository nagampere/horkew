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
    cast(Field31 as double) as "1994",
    cast(Field32 as double) as "1995",
    cast(Field33 as double) as "1996",
    cast(Field34 as double) as "1997",
    cast(Field35 as double) as "1998",
    cast(Field36 as double) as "1999",
    cast(Field37 as double) as "2000",
    cast(Field38 as double) as "2001",
    cast(Field39 as double) as "2002",
    cast(Field40 as double) as "2003",
    cast(Field41 as double) as "2004",
    cast(Field42 as double) as "2005",
    cast(Field43 as double) as "2006",
    cast(Field44 as double) as "2007",
    cast(Field45 as double) as "2008",
    cast(Field46 as double) as "2009",
    cast(Field47 as double) as "2010",
    cast(Field48 as double) as "2011",
    cast(Field49 as double) as "2012",
    cast(Field50 as double) as "2013",
    cast(Field51 as double) as "2014",
    cast(Field52 as double) as "2015",
    cast(Field53 as double) as "2016",
    cast(Field54 as double) as "2017",
    cast(Field55 as double) as "2018",
    cast(Field56 as double) as "2019",
    cast(Field57 as double) as "2020",
    cast(Field58 as double) as "2021",
from
    source
where
    (index between 3 and 102) or 
    (index between 105 and 111)
