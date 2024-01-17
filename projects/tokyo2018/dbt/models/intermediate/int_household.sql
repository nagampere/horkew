SELECT
    ROW_NUMBER() OVER () as id,
    first(answer_type) as answer_type,
    first(id_batch) as id_batch,
    id_area,
    id_lot,
    id_household,
    if(first(household_size)!=99, first(household_size), NULL) as household_size,
    if(first(household_size_over_5th)!=99, first(household_size_over_5th), NULL) as household_size_over_5th,
    first(individual) as individual,
    first(address_accuracy) as address_accuracy,
    first(address_zcode) as address_zcode,
    first(address_jcode) as address_jcode,
    if(first(owned_car)!=99, first(owned_car), NULL) as owned_car,
    if(first(owned_bike)!=99, first(owned_bike), NULL) as owned_bike,
    if(first(owned_motorcycle)!=99, first(owned_motorcycle), NULL) as owned_motorcycle,
    CASE 
        WHEN first(income)==1 THEN '0~200'
        WHEN first(income)==2 THEN '200~600'
        WHEN first(income)==3 THEN '600~1000'
        WHEN first(income)==4 THEN '1000~1500'
        WHEN first(income)==5 THEN '1500~'
        ELSE NULL
    END as income,
    count(sex) filter(sex==1) as member_male,
    count(sex) filter(sex==2) as member_female,
    count(age) filter(age<15) as member_under_15th,
    count(age) filter(age>=15 and age<65) as member_working_age,
    count(age) filter(age>=65 and age!=999) as member_over_65th,
    count(age) filter(age>=75 and age!=999) as member_over_75th,
    count(employment) filter(employment in(1,2,3,4,5,6,91)) as member_worker,
    count(employment) filter(employment in(7)) as member_student,
    count(employment) filter(employment in(8,9)) as member_other,
    count(employment) filter(employment in(2)) as member_regular_worker,
    count(employment) filter(employment in(3,4)) as member_irregular_worker,
    count(job) filter(job==1) as member_primary_industry,
    count(job) filter(job==2) as member_secondary_industry,
    count(job) filter(job==3) as member_tertiary_industry,
    count(licence) filter(licence==1) as member_driver,
    count(disability) filter(disability in(3,4)) as member_need_suppurt,
    count(disability) filter(disability in(5)) as member_bedridden,
FROM 
    {{ ref("stg_ms4011") }}
GROUP BY 
    id_area, 
    id_lot,
    id_household
ORDER BY id