WITH residential_structures as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 100
),
non_residential_buildings as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 210
),
structures as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 220
),
land_improvement as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 230
),
transport_equipment as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 310
),
computing_equipment as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 321
),
communications_equipment as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 322
),
other_machinery_and_equipment as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 330
),
defense_equipment as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 400
),
cultivated_assets as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 500
),
research_and_development as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 610
),
mineral_exploration_and_evaluation as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 620
),
computer_software as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 630
),
original_entertainment_works as (
    SELECT
        *
    FROM
        {{ref('stg_capital__investment_matrix_and_stock_matrix')}}
    WHERE
        asset_id = 640
), 
merge_table as (
    SELECT
        residential_structures.section_id as section_id,
        residential_structures.section_name as section_name,
        residential_structures.year as year,
        residential_structures.nominal_investment as RS_nominal_investment,
        residential_structures.real_investment as RS_real_investment,
        residential_structures.nominal_capital_stock as RS_nominal_capital_stock,
        residential_structures.real_capital_stock as RS_real_capital_stock,
        residential_structures.nominal_capital_cost as RS_nominal_capital_cost,
        non_residential_buildings.nominal_investment as NRS_nominal_investment,
        non_residential_buildings.real_investment as NRS_real_investment,
        non_residential_buildings.nominal_capital_stock as NRS_nominal_capital_stock,
        non_residential_buildings.real_capital_stock as NRS_real_capital_stock,
        non_residential_buildings.nominal_capital_cost as NRS_nominal_capital_cost,
        structures.nominal_investment as ST_nominal_investment,
        structures.real_investment as ST_real_investment,
        structures.nominal_capital_stock as ST_nominal_capital_stock,
        structures.real_capital_stock as ST_real_capital_stock,
        structures.nominal_capital_cost as ST_nominal_capital_cost,
        land_improvement.nominal_investment as LA_nominal_investment,
        land_improvement.real_investment as LA_real_investment,
        land_improvement.nominal_capital_stock as LA_nominal_capital_stock,
        land_improvement.real_capital_stock as LA_real_capital_stock,
        land_improvement.nominal_capital_cost as LA_nominal_capital_cost,
        transport_equipment.nominal_investment as TE_nominal_investment,
        transport_equipment.real_investment as TE_real_investment,
        transport_equipment.nominal_capital_stock as TE_nominal_capital_stock,
        transport_equipment.real_capital_stock as TE_real_capital_stock,
        transport_equipment.nominal_capital_cost as TE_nominal_capital_cost,
        computing_equipment.nominal_investment as CPE_nominal_investment,
        computing_equipment.real_investment as CPE_real_investment,
        computing_equipment.nominal_capital_stock as CPE_nominal_capital_stock,
        computing_equipment.real_capital_stock as CPE_real_capital_stock,
        computing_equipment.nominal_capital_cost as CPE_nominal_capital_cost,
        communications_equipment.nominal_investment as CME_nominal_investment,
        communications_equipment.real_investment as CME_real_investment,
        communications_equipment.nominal_capital_stock as CME_nominal_capital_stock,
        communications_equipment.real_capital_stock as CME_real_capital_stock,
        communications_equipment.nominal_capital_cost as CME_nominal_capital_cost,
        other_machinery_and_equipment.nominal_investment as OE_nominal_investment,
        other_machinery_and_equipment.real_investment as OE_real_investment,
        other_machinery_and_equipment.nominal_capital_stock as OE_nominal_capital_stock,
        other_machinery_and_equipment.real_capital_stock as OE_real_capital_stock,
        other_machinery_and_equipment.nominal_capital_cost as OE_nominal_capital_cost,
        defense_equipment.nominal_investment as DE_nominal_investment,
        defense_equipment.real_investment as DE_real_investment,
        defense_equipment.nominal_capital_stock as DE_nominal_capital_stock,
        defense_equipment.real_capital_stock as DE_real_capital_stock,
        defense_equipment.nominal_capital_cost as DE_nominal_capital_cost,
        cultivated_assets.nominal_investment as CA_nominal_investment,
        cultivated_assets.real_investment as CA_real_investment,
        cultivated_assets.nominal_capital_stock as CA_nominal_capital_stock,
        cultivated_assets.real_capital_stock as CA_real_capital_stock,
        cultivated_assets.nominal_capital_cost as CA_nominal_capital_cost,
        research_and_development.nominal_investment as RD_nominal_investment,
        research_and_development.real_investment as RD_real_investment,
        research_and_development.nominal_capital_stock as RD_nominal_capital_stock,
        research_and_development.real_capital_stock as RD_real_capital_stock,
        research_and_development.nominal_capital_cost as RD_nominal_capital_cost,
        mineral_exploration_and_evaluation.nominal_investment as ME_nominal_investment,
        mineral_exploration_and_evaluation.real_investment as ME_real_investment,
        mineral_exploration_and_evaluation.nominal_capital_stock as ME_nominal_capital_stock,
        mineral_exploration_and_evaluation.real_capital_stock as ME_real_capital_stock,
        mineral_exploration_and_evaluation.nominal_capital_cost as ME_nominal_capital_cost,
        computer_software.nominal_investment as CS_nominal_investment,
        computer_software.real_investment as CS_real_investment,
        computer_software.nominal_capital_stock as CS_nominal_capital_stock,
        computer_software.real_capital_stock as CS_real_capital_stock,
        computer_software.nominal_capital_cost as CS_nominal_capital_cost,
        original_entertainment_works.nominal_investment as AO_nominal_investment,
        original_entertainment_works.real_investment as AO_real_investment,
        original_entertainment_works.nominal_capital_stock as AO_nominal_capital_stock,
        original_entertainment_works.real_capital_stock as AO_real_capital_stock,
        original_entertainment_works.nominal_capital_cost as AO_nominal_capital_cost
    FROM
        residential_structures
    LEFT JOIN non_residential_buildings
        ON (non_residential_buildings.section_id = residential_structures.section_id)
        AND (non_residential_buildings.year = residential_structures.year)
    LEFT JOIN structures
        ON (structures.section_id = residential_structures.section_id)
        AND (structures.year = residential_structures.year)
    LEFT JOIN land_improvement
        ON (land_improvement.section_id = residential_structures.section_id)
        AND (land_improvement.year = residential_structures.year)
    LEFT JOIN transport_equipment
        ON (transport_equipment.section_id = residential_structures.section_id)
        AND (transport_equipment.year = residential_structures.year)
    LEFT JOIN computing_equipment
        ON (computing_equipment.section_id = residential_structures.section_id)
        AND (computing_equipment.year = residential_structures.year)
    LEFT JOIN communications_equipment
        ON (communications_equipment.section_id = residential_structures.section_id)
        AND (communications_equipment.year = residential_structures.year)
    LEFT JOIN other_machinery_and_equipment
        ON (other_machinery_and_equipment.section_id = residential_structures.section_id)
        AND (other_machinery_and_equipment.year = residential_structures.year)
    LEFT JOIN defense_equipment
        ON (defense_equipment.section_id = residential_structures.section_id)
        AND (defense_equipment.year = residential_structures.year)
    LEFT JOIN cultivated_assets
        ON (cultivated_assets.section_id = residential_structures.section_id)
        AND (cultivated_assets.year = residential_structures.year)
    LEFT JOIN research_and_development
        ON (research_and_development.section_id = residential_structures.section_id)
        AND (research_and_development.year = residential_structures.year)
    LEFT JOIN mineral_exploration_and_evaluation
        ON (mineral_exploration_and_evaluation.section_id = residential_structures.section_id)
        AND (mineral_exploration_and_evaluation.year = residential_structures.year)
    LEFT JOIN computer_software
        ON (computer_software.section_id = residential_structures.section_id)
        AND (computer_software.year = residential_structures.year)
    LEFT JOIN original_entertainment_works
        ON (original_entertainment_works.section_id = residential_structures.section_id)
        AND (original_entertainment_works.year = residential_structures.year)
    ORDER BY section_id, year
)
SELECT
    ROW_NUMBER() OVER () as id,
    *
FROM
    merge_table
