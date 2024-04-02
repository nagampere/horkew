WITH joined_table as (
    SELECT
        int_supplementary__export_by_sector_and_country.id as id,
        int_supplementary__export_by_sector_and_country.section_id as section_id,
        int_supplementary__export_by_sector_and_country.section_name as section_name,
        int_supplementary__export_by_sector_and_country.year as year,
        int_supplementary__export_by_sector_and_country.to_area_id as area_id,
        int_supplementary__export_by_sector_and_country.to_area_name as area_name,
        int_supplementary__export_by_sector_and_country.to_country_id as country_id,
        int_supplementary__export_by_sector_and_country.to_country_name as country_name,
        int_supplementary__export_by_sector_and_country.to_country_name_ja as country_name_ja,
        int_supplementary__export_by_sector_and_country.to_country_annotation as country_annotation,
        int_supplementary__export_by_sector_and_country.to_value as to_value,
        int_supplementary__import_by_sector_and_country.from_value as from_value
    FROM
        {{ref('int_supplementary__export_by_sector_and_country')}} as int_supplementary__export_by_sector_and_country
    FULL JOIN
        {{ref('int_supplementary__import_by_sector_and_country')}} as int_supplementary__import_by_sector_and_country
        ON (int_supplementary__import_by_sector_and_country.section_id = int_supplementary__export_by_sector_and_country.section_id)
        AND (int_supplementary__import_by_sector_and_country.year = int_supplementary__export_by_sector_and_country.year)
        AND (int_supplementary__import_by_sector_and_country.from_country_id = int_supplementary__export_by_sector_and_country.to_country_id)
    ORDER BY year, section_id, country_id
)
SELECT
    ROW_NUMBER() OVER () as id,
    *
FROM
    joined_table