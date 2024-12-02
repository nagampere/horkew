WITH 
delta_VA as (
    SELECT 
        delta_VA.pref_id as pref_id,
        first(delta_VA.pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        delta_VA.year,
        SUM(delta_VA.delta_VA * VA_share.value_added_share) as delta_VA
    FROM {{ref('int_TFP__delta_VA')}} as delta_VA
    LEFT JOIN {{ref('int_growth_account__value_added_share')}} as VA_share
        ON  VA_share.pref_id = delta_VA.pref_id
        AND VA_share.section_id = delta_VA.section_id
        AND VA_share.year = delta_VA.year
    GROUP BY delta_VA.pref_id, delta_VA.year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_TFP__delta_VA')}}
),
delta_Z as (
    SELECT 
        delta_Z.pref_id as pref_id,
        first(delta_Z.pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        delta_Z.year,
        SUM(delta_Z.delta_Z * VA_share.value_added_share) as delta_Z
    FROM {{ref('int_TFP__delta_Z')}} as delta_Z
    LEFT JOIN {{ref('int_growth_account__value_added_share')}} as VA_share
        ON  VA_share.pref_id = delta_Z.pref_id
        AND VA_share.section_id = delta_Z.section_id
        AND VA_share.year = delta_Z.year
    GROUP BY delta_Z.pref_id, delta_Z.year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_TFP__delta_Z')}}
),
delta_QK as (
    SELECT 
        delta_QK.pref_id as pref_id,
        first(delta_QK.pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        delta_QK.year,
        SUM(delta_QK.delta_QK * VA_share.value_added_share) as delta_QK
    FROM {{ref('int_TFP__delta_QK')}} as delta_QK
    LEFT JOIN {{ref('int_growth_account__value_added_share')}} as VA_share
        ON  VA_share.pref_id = delta_QK.pref_id
        AND VA_share.section_id = delta_QK.section_id
        AND VA_share.year = delta_QK.year
    GROUP BY delta_QK.pref_id, delta_QK.year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_TFP__delta_QK')}}
),
delta_Z_patent as (
    SELECT 
        delta_Z_patent.pref_id as pref_id,
        first(delta_Z_patent.pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        delta_Z_patent.year,
        SUM(delta_Z_patent.delta_Z_patent * VA_share.value_added_share) as delta_Z_patent
    FROM {{ref('int_TFP__delta_Z_patent')}} as delta_Z_patent
    LEFT JOIN {{ref('int_growth_account__value_added_share')}} as VA_share
        ON  VA_share.pref_id = delta_Z_patent.pref_id
        AND VA_share.section_id = delta_Z_patent.section_id
        AND VA_share.year = delta_Z_patent.year
    GROUP BY delta_Z_patent.pref_id, delta_Z_patent.year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_TFP__delta_Z_patent')}}
),
delta_QK_patent as (
    SELECT 
        delta_QK_patent.pref_id as pref_id,
        first(delta_QK_patent.pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        delta_QK_patent.year,
        SUM(delta_QK_patent.delta_QK_patent * VA_share.value_added_share) as delta_QK_patent
    FROM {{ref('int_TFP__delta_QK_patent')}} as delta_QK_patent
    LEFT JOIN {{ref('int_growth_account__value_added_share')}} as VA_share
        ON  VA_share.pref_id = delta_QK_patent.pref_id
        AND VA_share.section_id = delta_QK_patent.section_id
        AND VA_share.year = delta_QK_patent.year
    GROUP BY delta_QK_patent.pref_id, delta_QK_patent.year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_TFP__delta_QK_patent')}}
),
delta_H as (
    SELECT 
        delta_H.pref_id as pref_id,
        first(delta_H.pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        delta_H.year,
        SUM(delta_H.delta_H * VA_share.value_added_share) as delta_H
    FROM {{ref('int_TFP__delta_H')}} as delta_H
    LEFT JOIN {{ref('int_growth_account__value_added_share')}} as VA_share
        ON  VA_share.pref_id = delta_H.pref_id
        AND VA_share.section_id = delta_H.section_id
        AND VA_share.year = delta_H.year
    GROUP BY delta_H.pref_id, delta_H.year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_TFP__delta_H')}}
),
delta_QL as (
    SELECT 
        delta_QL.pref_id as pref_id,
        first(delta_QL.pref_name) as pref_name,
        CAST(0 as int) as section_id,
        CAST('全産業' as VARCHAR) as section_name,
        delta_QL.year,
        SUM(delta_QL.delta_QL * VA_share.value_added_share) as delta_QL
    FROM {{ref('int_TFP__delta_QL')}} as delta_QL
    LEFT JOIN {{ref('int_growth_account__value_added_share')}} as VA_share
        ON  VA_share.pref_id = delta_QL.pref_id
        AND VA_share.section_id = delta_QL.section_id
        AND VA_share.year = delta_QL.year
    GROUP BY delta_QL.pref_id, delta_QL.year
    UNION ALL
    SELECT * exclude (id) FROM {{ref('int_TFP__delta_QL')}}
)
SELECT
    ROW_NUMBER() OVER () as id,
    delta_VA.pref_id as pref_id,
    delta_VA.pref_name as pref_name,
    delta_VA.section_id as section_id,
    delta_VA.section_name as section_name,
    delta_VA.year as year,
    delta_VA.delta_VA as delta_VA,
    delta_Z.delta_Z as delta_Z,
    delta_QK.delta_QK as delta_QK,
    delta_Z_patent.delta_Z_patent as delta_Z_patent,
    delta_QK_patent.delta_QK_patent as delta_QK_patent,
    delta_H.delta_H as delta_H,
    delta_QL.delta_QL as delta_QL,
FROM delta_VA
LEFT JOIN delta_Z
    ON  (delta_VA.pref_id = delta_Z.pref_id)
    AND (delta_VA.section_id = delta_Z.section_id)
    AND (delta_VA.year = delta_Z.year)
LEFT JOIN delta_QK
    ON  (delta_VA.pref_id = delta_QK.pref_id)
    AND (delta_VA.section_id = delta_QK.section_id)
    AND (delta_VA.year = delta_QK.year)
LEFT JOIN delta_Z_patent
    ON  (delta_VA.pref_id = delta_Z_patent.pref_id)
    AND (delta_VA.section_id = delta_Z_patent.section_id)
    AND (delta_VA.year = delta_Z_patent.year)
LEFT JOIN delta_QK_patent
    ON  (delta_VA.pref_id = delta_QK_patent.pref_id)
    AND (delta_VA.section_id = delta_QK_patent.section_id)
    AND (delta_VA.year = delta_QK_patent.year)
LEFT JOIN delta_H
    ON  (delta_VA.pref_id = delta_H.pref_id)
    AND (delta_VA.section_id = delta_H.section_id)
    AND (delta_VA.year = delta_H.year)
LEFT JOIN delta_QL
    ON  (delta_VA.pref_id = delta_QL.pref_id)
    AND (delta_VA.section_id = delta_QL.section_id)
    AND (delta_VA.year = delta_QL.year)
ORDER BY pref_id, section_id, year