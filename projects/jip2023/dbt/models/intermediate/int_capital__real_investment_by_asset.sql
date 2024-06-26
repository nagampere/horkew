WITH unpivot_alias AS (
    UNPIVOT {{ref('stg_capital__real_investment_by_asset')}}
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
        2020
    INTO
        NAME year
        VALUE real_investment
)
SELECT 
    ROW_NUMBER() OVER () as id,
    asset_id,
    asset_name,
    cast(year as int) as year,
    real_investment
FROM unpivot_alias
