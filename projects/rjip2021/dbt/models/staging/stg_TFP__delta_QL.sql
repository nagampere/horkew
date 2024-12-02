select
    source.id as id,
    source.pref_id as pref_id,
    source.section_id as section_id,
    cast(NULL as double) as "1994",
    (1 - cost_of_capital_share."1995" - cost_of_capital_patent_share."1995") * (source."1995" - source."1994") / source."1994" as "1995",
    (1 - cost_of_capital_share."1996" - cost_of_capital_patent_share."1996") * (source."1996" - source."1995") / source."1995" as "1996",
    (1 - cost_of_capital_share."1997" - cost_of_capital_patent_share."1997") * (source."1997" - source."1996") / source."1996" as "1997",
    (1 - cost_of_capital_share."1998" - cost_of_capital_patent_share."1998") * (source."1998" - source."1997") / source."1997" as "1998",
    (1 - cost_of_capital_share."1999" - cost_of_capital_patent_share."1999") * (source."1999" - source."1998") / source."1998" as "1999",
    (1 - cost_of_capital_share."2000" - cost_of_capital_patent_share."2000") * (source."2000" - source."1999") / source."1999" as "2000",
    (1 - cost_of_capital_share."2001" - cost_of_capital_patent_share."2001") * (source."2001" - source."2000") / source."2000" as "2001",
    (1 - cost_of_capital_share."2002" - cost_of_capital_patent_share."2002") * (source."2002" - source."2001") / source."2001" as "2002",
    (1 - cost_of_capital_share."2003" - cost_of_capital_patent_share."2003") * (source."2003" - source."2002") / source."2002" as "2003",
    (1 - cost_of_capital_share."2004" - cost_of_capital_patent_share."2004") * (source."2004" - source."2003") / source."2003" as "2004",
    (1 - cost_of_capital_share."2005" - cost_of_capital_patent_share."2005") * (source."2005" - source."2004") / source."2004" as "2005",
    (1 - cost_of_capital_share."2006" - cost_of_capital_patent_share."2006") * (source."2006" - source."2005") / source."2005" as "2006",
    (1 - cost_of_capital_share."2007" - cost_of_capital_patent_share."2007") * (source."2007" - source."2006") / source."2006" as "2007",
    (1 - cost_of_capital_share."2008" - cost_of_capital_patent_share."2008") * (source."2008" - source."2007") / source."2007" as "2008",
    (1 - cost_of_capital_share."2009" - cost_of_capital_patent_share."2009") * (source."2009" - source."2008") / source."2008" as "2009",
    (1 - cost_of_capital_share."2010" - cost_of_capital_patent_share."2010") * (source."2010" - source."2009") / source."2009" as "2010",
    (1 - cost_of_capital_share."2011" - cost_of_capital_patent_share."2011") * (source."2011" - source."2010") / source."2010" as "2011",
    (1 - cost_of_capital_share."2012" - cost_of_capital_patent_share."2012") * (source."2012" - source."2011") / source."2011" as "2012",
    (1 - cost_of_capital_share."2013" - cost_of_capital_patent_share."2013") * (source."2013" - source."2012") / source."2012" as "2013",
    (1 - cost_of_capital_share."2014" - cost_of_capital_patent_share."2014") * (source."2014" - source."2013") / source."2013" as "2014",
    (1 - cost_of_capital_share."2015" - cost_of_capital_patent_share."2015") * (source."2015" - source."2014") / source."2014" as "2015",
    (1 - cost_of_capital_share."2016" - cost_of_capital_patent_share."2016") * (source."2016" - source."2015") / source."2015" as "2016",
    (1 - cost_of_capital_share."2017" - cost_of_capital_patent_share."2017") * (source."2017" - source."2016") / source."2016" as "2017",
    (1 - cost_of_capital_share."2018" - cost_of_capital_patent_share."2018") * (source."2018" - source."2017") / source."2017" as "2018",
FROM
    {{ref('stg_labor__quality_of_labor_index')}} as source
LEFT JOIN {{ref('stg_growth_account__cost_of_capital_share')}} as cost_of_capital_share
    ON  (source.pref_id = cost_of_capital_share.pref_id)
    AND (source.section_id = cost_of_capital_share.section_id)
LEFT JOIN {{ref('stg_growth_account__cost_of_capital_patent_share')}} as cost_of_capital_patent_share
    ON  (source.pref_id = cost_of_capital_patent_share.pref_id)
    AND (source.section_id = cost_of_capital_patent_share.section_id)
ORDER BY id
