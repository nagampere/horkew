with source as (
    SELECT 
        ROW_NUMBER() OVER () as index,
        * 
    FROM st_read(
        '../sources/growth.xlsx',
        layer='H',
        open_options = ['HEADERS=DISABLE', 'FIELD_TYPES=STRING']
    )
)

select
    ROW_NUMBER() OVER () as id,
    cast(Field1 as int) as section_id,
    cast(Field2 as char) as section_name,
    cast(Field3 as double) as "1994",
    cast(Field4 as double) as "1995",
    cast(Field5 as double) as "1996",
    cast(Field6 as double) as "1997",
    cast(Field7 as double) as "1998",
    cast(Field8 as double) as "1999",
    cast(Field9 as double) as "2000",
    cast(Field10 as double) as "2001",
    cast(Field11 as double) as "2002",
    cast(Field12 as double) as "2003",
    cast(Field13 as double) as "2004",
    cast(Field14 as double) as "2005",
    cast(Field15 as double) as "2006",
    cast(Field16 as double) as "2007",
    cast(Field17 as double) as "2008",
    cast(Field18 as double) as "2009",
    cast(Field19 as double) as "2010",
    cast(Field20 as double) as "2011",
    cast(Field21 as double) as "2012",
    cast(Field22 as double) as "2013",
    cast(Field23 as double) as "2014",
    cast(Field24 as double) as "2015",
    cast(Field25 as double) as "2016",
    cast(Field26 as double) as "2017",
    cast(Field27 as double) as "2018",
    cast(Field28 as double) as "2019",
    cast(Field29 as double) as "2020",
    cast(Field30 as double) as "2021",
from
    source
where
    (index between 115 and 214) or 
    (index between 217 and 223)
