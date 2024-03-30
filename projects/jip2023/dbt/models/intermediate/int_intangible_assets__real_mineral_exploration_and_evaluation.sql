WITH unpivot_alias AS (
    UNPIVOT {{ref('stg_intangible_assets__real_mineral_exploration_and_evaluation')}}
    ON 
        1994,
        1995,
        1996,
        1997,
        1998,
        1999,
        2000,
        2001,
        2002,
        2003,
        2004,
        2005,
        2006,
        2007,
        2008,
        2009,
        2010,
        2011,
        2012,
        2013,
        2014,
        2015,
        2016,
        2017,
        2018,
        2019,
        2020,
        2021
    INTO
        NAME year
        VALUE Iq_ME
)

SELECT 
    ROW_NUMBER() OVER () as id,
    section_id,
    section_name,
    cast(year as int) as year,
    Iq_ME
FROM unpivot_alias
