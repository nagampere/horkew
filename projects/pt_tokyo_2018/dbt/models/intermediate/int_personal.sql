SELECT
    id,
    answer_type,
    id_batch,
    id_area,
    id_lot,
    id_household,
    if(household_size!=99, household_size, NULL) as household_size,
    if(household_size_over_5th!=99, household_size_over_5th, NULL) as household_size_over_5th,
    individual,
    address_accuracy,
    address_zcode,
    address_jcode,
    if(owned_car!=99, owned_car, NULL) as owned_car,
    if(owned_bike!=99,owned_bike, NULL) as owned_bike,
    if(owned_motorcycle!=99, owned_motorcycle, NULL) as owned_motorcycle,
    CASE 
        WHEN income==1 THEN '0~200'
        WHEN income==2 THEN '200~600'
        WHEN income==3 THEN '600~1000'
        WHEN income==4 THEN '1000~1500'
        WHEN income==5 THEN '1500~'
        ELSE NULL
    END as income,
    personal_number,
    CASE 
        WHEN sex==1 THEN '男性'
        WHEN sex==2 THEN '女性'
        ELSE 'その他'
    END as sex,
    if(age!=999, age, NULL) as age,
    CASE 
        WHEN relationship==0 THEN '世帯主'
        WHEN relationship==1 THEN '配偶者'
        WHEN relationship==2 THEN '子'
        WHEN relationship==3 THEN '子の配偶者'
        WHEN relationship==4 THEN '父母'
        WHEN relationship==5 THEN '配偶者の父母'
        WHEN relationship==6 THEN '孫'
        WHEN relationship==7 THEN '祖父母'
        WHEN relationship==8 THEN '兄弟姉妹'
        WHEN relationship==9 THEN '他の親族'
        ELSE NULL
    END as relationship,
    CASE 
        WHEN employment==1 THEN '自営業主・家族従業者'
        WHEN employment==2 THEN '正規の職員・従業員'
        WHEN employment==3 THEN '派遣社員・契約社員'
        WHEN employment==4 THEN 'パート・アルバイト'
        WHEN employment==5 THEN '会社等の役員'
        WHEN employment in(6,91) THEN 'その他就業者'
        WHEN employment==7 THEN '園児・生徒・学生'
        WHEN employment==8 THEN '専業主婦・主夫'
        WHEN employment==9 THEN '無職'
        ELSE NULL
    END as employment,
    CASE 
        WHEN job==1 THEN '第一次産業'
        WHEN job==2 THEN '第二次産業'
        WHEN job==3 THEN '第三次産業'
        ELSE NULL
    END as job,
    CASE 
        WHEN licence==1 THEN '持っている'
        WHEN licence==2 THEN '持っていない'
        WHEN licence==3 THEN '返納した'
        ELSE NULL
    END as licence,
    CASE 
        WHEN ownership_car==1 THEN '自分専用車を利用'
        WHEN ownership_car==2 THEN '家族共用車を利用'
        WHEN ownership_car==3 THEN '保有なし'
        ELSE NULL
    END as ownership_car,
    CASE 
        WHEN disability==1 THEN '困難ではない'
        WHEN disability==2 THEN '困難でも一人で外出可'
        WHEN disability==3 THEN '外出時に一部で介助'
        WHEN disability==4 THEN '外出時に必ず介助'
        WHEN disability==5 THEN '外出不可能'
        ELSE NULL
    END as disability,
FROM {{ ref("stg_ms4011") }}