WITH 
unpivot_alias AS (
    UNPIVOT {{ref('stg_value_added__nominal')}}
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
        2018
    INTO
        NAME year
        VALUE value_added_nominal
)
SELECT 
    ROW_NUMBER() OVER () as id,
    unpivot_alias.pref_id as pref_id,
    stg_prefectures.pref_name as pref_name,
    unpivot_alias.section_id as section_id,
    stg_sections.section_name as section_name,
    cast(unpivot_alias.year as int) as year,
    unpivot_alias.value_added_nominal as value_added_nominal
FROM unpivot_alias
LEFT JOIN
    {{ref('stg_prefectures')}} as stg_prefectures
    ON (stg_prefectures.pref_id = unpivot_alias.pref_id)
LEFT JOIN
    {{ref('stg_sections')}} as stg_sections
    ON (stg_sections.section_id = unpivot_alias.section_id)
