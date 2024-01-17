SELECT
    ms2611.id as id,
    ms2611.is_first==1 as is_first,
    if(ms2611.answer_type==1,'郵便回収','WEB回収') as answer_type,
    ms2611.id_batch as id_batch,
    ms2611.id_area as id_area,
    ms2611.id_lot as id_lot,
    ms2611.id_household as household,
    if(ms2611.household_size!=99, ms2611.household_size, NULL) as household_size,
    if(ms2611.household_size_over_5th!=99, ms2611.household_size_over_5th, NULL) as household_size_over_5th,
    ms2611.individual as individual,
    ms2711.address_accuracy as address_accuracy,
    ms2711.address_zcode as address_zcode,
    ms2711.address_block as address_block,
    ms2711.address_number as address_number,
    ms2711.address_lat as address_lat,
    ms2711.address_lon as address_lon,
    ms2711.address_level as address_level,
    ms2711.address_jcode as address_jcode,
    if(ms2611.owned_car!=99, ms2611.owned_car, NULL) as owned_car,
    if(ms2611.owned_bike!=99, ms2611.owned_bike, NULL) as owned_bike,
    if(ms2611.owned_motorcycle!=99, ms2611.owned_motorcycle, NULL) as owned_motorcycle,
    CASE 
        WHEN ms2611.income==1 THEN '0~200'
        WHEN ms2611.income==2 THEN '200~600'
        WHEN ms2611.income==3 THEN '600~1000'
        WHEN ms2611.income==4 THEN '1000~1500'
        WHEN ms2611.income==5 THEN '1500~'
        ELSE NULL
    END as income,

    CASE 
        WHEN ms2611.sex==1 THEN '男性'
        WHEN ms2611.sex==2 THEN '女性'
        ELSE 'その他'
    END as sex,
    if(ms2611.age!=999, ms2611.age, NULL) as age,
    CASE 
        WHEN ms2611.relationship==0 THEN '世帯主'
        WHEN ms2611.relationship==1 THEN '配偶者'
        WHEN ms2611.relationship==2 THEN '子'
        WHEN ms2611.relationship==3 THEN '子の配偶者'
        WHEN ms2611.relationship==4 THEN '父母'
        WHEN ms2611.relationship==5 THEN '配偶者の父母'
        WHEN ms2611.relationship==6 THEN '孫'
        WHEN ms2611.relationship==7 THEN '祖父母'
        WHEN ms2611.relationship==8 THEN '兄弟姉妹'
        WHEN ms2611.relationship==9 THEN '他の親族'
        ELSE NULL
    END as relationship,
    CASE 
        WHEN ms2611.employment==1 THEN '自営業主・家族従業者'
        WHEN ms2611.employment==2 THEN '正規の職員・従業員'
        WHEN ms2611.employment==3 THEN '派遣社員・契約社員'
        WHEN ms2611.employment==4 THEN 'パート・アルバイト'
        WHEN ms2611.employment==5 THEN '会社等の役員'
        WHEN ms2611.employment in(6,91) THEN 'その他就業者'
        WHEN ms2611.employment==7 THEN '園児・生徒・学生'
        WHEN ms2611.employment==8 THEN '専業主婦・主夫'
        WHEN ms2611.employment==9 THEN '無職'
        ELSE NULL
    END as employment,
    CASE 
        WHEN ms2611.job==1 THEN '第一次産業'
        WHEN ms2611.job==2 THEN '第二次産業'
        WHEN ms2611.job==3 THEN '第三次産業'
        ELSE NULL
    END as job,
    CASE 
        WHEN ms2611.licence==1 THEN '持っている'
        WHEN ms2611.licence==2 THEN '持っていない'
        WHEN ms2611.licence==3 THEN '返納した'
        ELSE NULL
    END as licence,
    CASE 
        WHEN ms2611.ownership_car==1 THEN '自分専用車を利用'
        WHEN ms2611.ownership_car==2 THEN '家族共用車を利用'
        WHEN ms2611.ownership_car==3 THEN '保有なし'
        ELSE NULL
    END as ownership_car,
    CASE 
        WHEN ms2611.disability==1 THEN '困難ではない'
        WHEN ms2611.disability==2 THEN '困難でも一人で外出可'
        WHEN ms2611.disability==3 THEN '外出時に一部で介助'
        WHEN ms2611.disability==4 THEN '外出時に必ず介助'
        WHEN ms2611.disability==5 THEN '外出不可能'
        ELSE NULL
    END as disability,
    ms2711.office_accuracy as office_accuracy,
    ms2711.office_zcode as office_zcode,
    ms2711.office_block as office_block,
    ms2711.office_number as office_number,
    ms2711.office_lat as office_lat,
    ms2711.office_lon as office_lon,
    ms2711.office_level as office_level,
    ms2711.office_jcode as office_jcode,
    CASE
        WHEN ms2611.is_officehour==1 THEN TRUE
        WHEN ms2611.is_officehour==2 THEN FALSE
        ELSE NULL
    END as is_officehour,
    CASE
        WHEN ms2611.opening_ampm==1 THEN 'AM'
        WHEN ms2611.opening_ampm==2 THEN 'PM'
        ELSE NULL
    END as opening_ampm,
    if(ms2611.opening_hour!=99, ms2611.opening_hour, NULL) as opening_hour,
    if(ms2611.opening_minute!=99, ms2611.opening_minute, NULL) as opening_minute,
    CASE
        WHEN ms2611.opening_ampm==1 AND ms2611.opening_hour!=99 AND ms2611.opening_minute!=99
        THEN MAKE_TIME(ms2611.opening_hour, ms2611.opening_minute, 0)
        WHEN ms2611.opening_ampm==2 AND ms2611.opening_hour!=99 AND ms2611.opening_minute!=99
        THEN MAKE_TIME(ms2611.opening_hour+12, ms2611.opening_minute, 0)
        ELSE NULL
    END as opening_time,
    CASE
        WHEN ms2611.is_remotework==1 THEN TRUE
        WHEN ms2611.is_remotework==2 THEN FALSE
        ELSE NULL
    END as is_remotework,
    CASE
        WHEN ms2611.is_trip==1 THEN TRUE
        WHEN ms2611.is_trip==2 THEN FALSE
        ELSE NULL
    END as is_trip,
    ms2611.trip_total as trip_total,
    ms2611.trip_number as trip_number,
    CASE
        WHEN ms2611.origin_type==1 THEN '自宅'
        WHEN ms2611.origin_type==2 THEN '勤務先・通学先・通園先'
        WHEN ms2611.origin_type==3 THEN 'その他'
        ELSE NULL
    END as origin_type,
    ms2711.origin_accuracy as origin_accuracy,
    ms2711.origin_zcode as origin_zcode,
    ms2711.origin_block as origin_block,
    ms2711.origin_number as origin_number,
    ms2711.origin_lat as origin_lat,
    ms2711.origin_lon as origin_lon,
    ms2711.origin_level as origin_level,
    ms2711.origin_jcode as origin_jcode,
    CASE
        WHEN ms2611.origin_facility==1 THEN '01住宅・寮'
        WHEN ms2611.origin_facility==2 THEN '02学校・保育・文化施設'
        WHEN ms2611.origin_facility==3 THEN '03医療施設'
        WHEN ms2611.origin_facility==4 THEN '04高齢福祉施設'
        WHEN ms2611.origin_facility==5 THEN '05公園・自然地・スポーツ施設'
        WHEN ms2611.origin_facility==6 THEN '06その他の生活系施設'
        WHEN ms2611.origin_facility==7 THEN '07大規模小売店'
        WHEN ms2611.origin_facility==8 THEN '08小規模小売店'
        WHEN ms2611.origin_facility==9 THEN '09宿泊施設・ホテル'
        WHEN ms2611.origin_facility==10 THEN '10飲食施設'
        WHEN ms2611.origin_facility==11 THEN '11アミューズメント施設'
        WHEN ms2611.origin_facility==12 THEN '12その他の商業系施設'
        WHEN ms2611.origin_facility==13 THEN '13事務所・会社・銀行'
        WHEN ms2611.origin_facility==14 THEN '14官公庁施設'
        WHEN ms2611.origin_facility==15 THEN '15その他の業務系・工業系施設'
        ELSE NULL
    END as origin_facility,
    CASE
        WHEN ms2611.origin_ampm==1 THEN 'AM'
        WHEN ms2611.origin_ampm==2 THEN 'PM'
        ELSE NULL
    END as origin_ampm,
    if(ms2611.origin_hour!=99, ms2611.origin_hour, NULL) as origin_hour,
    if(ms2611.origin_minute!=99, ms2611.origin_minute, NULL) as origin_minute,
    CASE
        WHEN ms2611.origin_ampm==1 AND ms2611.origin_hour!=99 AND ms2611.origin_minute!=99
        THEN MAKE_TIME(ms2611.origin_hour, ms2611.origin_minute, 0)
        WHEN ms2611.origin_ampm==2 AND ms2611.origin_hour!=99 AND ms2611.origin_minute!=99
        THEN MAKE_TIME(ms2611.origin_hour+12, ms2611.origin_minute, 0)
        ELSE NULL
    END as origin_time,
    CASE
        WHEN ms2611.desination_type==1 THEN '自宅'
        WHEN ms2611.desination_type==2 THEN '勤務先・通学先・通園先'
        WHEN ms2611.desination_type==3 THEN 'その他'
        ELSE NULL
    END as desination_type,
    ms2711.destination_accuracy as destination_accuracy,
    ms2711.destination_zcode as destination_zcode,
    ms2711.destination_block as destination_block,
    ms2711.destination_number as destination_number,
    ms2711.destination_lat as destination_lat,
    ms2711.destination_lon as destination_lon,
    ms2711.destination_level as destination_level,
    ms2711.destination_jcode as destination_jcode,
    CASE
        WHEN ms2611.destination_facility==1 THEN '01住宅・寮'
        WHEN ms2611.destination_facility==2 THEN '02学校・保育・文化施設'
        WHEN ms2611.destination_facility==3 THEN '03医療施設'
        WHEN ms2611.destination_facility==4 THEN '04高齢福祉施設'
        WHEN ms2611.destination_facility==5 THEN '05公園・自然地・スポーツ施設'
        WHEN ms2611.destination_facility==6 THEN '06その他の生活系施設'
        WHEN ms2611.destination_facility==7 THEN '07大規模小売店'
        WHEN ms2611.destination_facility==8 THEN '08小規模小売店'
        WHEN ms2611.destination_facility==9 THEN '09宿泊施設・ホテル'
        WHEN ms2611.destination_facility==10 THEN '10飲食施設'
        WHEN ms2611.destination_facility==11 THEN '11アミューズメント施設'
        WHEN ms2611.destination_facility==12 THEN '12その他の商業系施設'
        WHEN ms2611.destination_facility==13 THEN '13事務所・会社・銀行'
        WHEN ms2611.destination_facility==14 THEN '14官公庁施設'
        WHEN ms2611.destination_facility==15 THEN '15その他の業務系・工業系施設'
        ELSE NULL
    END as destination_facility,
    CASE
        WHEN ms2611.destination_ampm==1 THEN 'AM'
        WHEN ms2611.destination_ampm==2 THEN 'PM'
        ELSE NULL
    END as destination_ampm,
    if(ms2611.destination_hour!=99, ms2611.destination_hour, NULL) as destination_hour,
    if(ms2611.destination_minute!=99, ms2611.destination_minute, NULL) as destination_minute,
    CASE
        WHEN ms2611.destination_ampm==1 AND ms2611.destination_hour!=99 AND ms2611.destination_minute!=99
        THEN MAKE_TIME(ms2611.destination_hour, ms2611.destination_minute, 0)
        WHEN ms2611.destination_ampm==2 AND ms2611.destination_hour!=99 AND ms2611.destination_minute!=99
        THEN MAKE_TIME(ms2611.destination_hour+12, ms2611.destination_minute, 0)
        ELSE NULL
    END as destination_time,
    if(ms2611.consumption!=9999999,ms2611.consumption,NULL) as consumption,
    CASE
        WHEN ms2611.purpose==1 THEN '01出勤・帰社'
        WHEN ms2611.purpose==2 THEN '02登校・帰校'
        WHEN ms2611.purpose==3 THEN '03日用品の買物'
        WHEN ms2611.purpose==4 THEN '04日用品以外の買物'
        WHEN ms2611.purpose==5 THEN '05食事・社交'
        WHEN ms2611.purpose==6 THEN '06文化活動'
        WHEN ms2611.purpose==7 THEN '07通院・リハビリ'
        WHEN ms2611.purpose==8 THEN '08デイサービス'
        WHEN ms2611.purpose==9 THEN '09他者の用事のつきそい'
        WHEN ms2611.purpose==10 THEN '10他者の送り迎え'
        WHEN ms2611.purpose==11 THEN '11塾・習い事・学習'
        WHEN ms2611.purpose==12 THEN '12散歩・ジョギング・運動'
        WHEN ms2611.purpose==13 THEN '13観光・行楽・レジャー'
        WHEN ms2611.purpose==14 THEN '14地域活動・ボランティア'
        WHEN ms2611.purpose==15 THEN '15その他の私用'
        WHEN ms2611.purpose==16 THEN '16打合せ・会議・商談'
        WHEN ms2611.purpose==17 THEN '17販売・配達・仕入・購入先'
        WHEN ms2611.purpose==18 THEN '18その他の業務'
        WHEN ms2611.purpose==19 THEN '19帰宅'
        WHEN ms2611.purpose==20 THEN '20私用'
        ELSE NULL
    END as purpose,
    if(ms2611.accompany!=99,ms2611.accompany,NULL) as accompany,
    CASE
        WHEN ms2611.is_accompany_child==1 THEN TRUE
        WHEN ms2611.is_accompany_child==2 THEN FALSE
        ELSE NULL
    END as is_accompany_child,
    CASE
        WHEN ms2611.is_accompany_elder==1 THEN TRUE
        WHEN ms2611.is_accompany_elder==2 THEN FALSE
        ELSE NULL
    END as is_accompany_elder,
    CASE
        WHEN ms2611.means_1==1 THEN '01徒歩'
        WHEN ms2611.means_1==2 THEN '02自転車'
        WHEN ms2611.means_1==3 THEN '03レンタサイクル'
        WHEN ms2611.means_1==4 THEN '04バイク'
        WHEN ms2611.means_1==5 THEN '05鉄道'
        WHEN ms2611.means_1==6 THEN '06路面電車'
        WHEN ms2611.means_1==7 THEN '07バス'
        WHEN ms2611.means_1==8 THEN '08高速バス'
        WHEN ms2611.means_1==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_1==10 THEN '10自家用車'
        WHEN ms2611.means_1==11 THEN '11貨物車'
        WHEN ms2611.means_1==12 THEN '12レンタカー'
        WHEN ms2611.means_1==13 THEN '13タクシー'
        WHEN ms2611.means_1==14 THEN '14その他'
        ELSE NULL
    END as means_1,
    CASE
        WHEN ms2611.means_2==1 THEN '01徒歩'
        WHEN ms2611.means_2==2 THEN '02自転車'
        WHEN ms2611.means_2==3 THEN '03レンタサイクル'
        WHEN ms2611.means_2==4 THEN '04バイク'
        WHEN ms2611.means_2==5 THEN '05鉄道'
        WHEN ms2611.means_2==6 THEN '06路面電車'
        WHEN ms2611.means_2==7 THEN '07バス'
        WHEN ms2611.means_2==8 THEN '08高速バス'
        WHEN ms2611.means_2==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_2==10 THEN '10自家用車'
        WHEN ms2611.means_2==11 THEN '11貨物車'
        WHEN ms2611.means_2==12 THEN '12レンタカー'
        WHEN ms2611.means_2==13 THEN '13タクシー'
        WHEN ms2611.means_2==14 THEN '14その他'
        ELSE NULL
    END as means_2,
    CASE
        WHEN ms2611.means_3==1 THEN '01徒歩'
        WHEN ms2611.means_3==2 THEN '02自転車'
        WHEN ms2611.means_3==3 THEN '03レンタサイクル'
        WHEN ms2611.means_3==4 THEN '04バイク'
        WHEN ms2611.means_3==5 THEN '05鉄道'
        WHEN ms2611.means_3==6 THEN '06路面電車'
        WHEN ms2611.means_3==7 THEN '07バス'
        WHEN ms2611.means_3==8 THEN '08高速バス'
        WHEN ms2611.means_3==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_3==10 THEN '10自家用車'
        WHEN ms2611.means_3==11 THEN '11貨物車'
        WHEN ms2611.means_3==12 THEN '12レンタカー'
        WHEN ms2611.means_3==13 THEN '13タクシー'
        WHEN ms2611.means_3==14 THEN '14その他'
        ELSE NULL
    END as means_3,
    CASE
        WHEN ms2611.means_4==1 THEN '01徒歩'
        WHEN ms2611.means_4==2 THEN '02自転車'
        WHEN ms2611.means_4==3 THEN '03レンタサイクル'
        WHEN ms2611.means_4==4 THEN '04バイク'
        WHEN ms2611.means_4==5 THEN '05鉄道'
        WHEN ms2611.means_4==6 THEN '06路面電車'
        WHEN ms2611.means_4==7 THEN '07バス'
        WHEN ms2611.means_4==8 THEN '08高速バス'
        WHEN ms2611.means_4==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_4==10 THEN '10自家用車'
        WHEN ms2611.means_4==11 THEN '11貨物車'
        WHEN ms2611.means_4==12 THEN '12レンタカー'
        WHEN ms2611.means_4==13 THEN '13タクシー'
        WHEN ms2611.means_4==14 THEN '14その他'
        ELSE NULL
    END as means_4,
    CASE
        WHEN ms2611.means_5==1 THEN '01徒歩'
        WHEN ms2611.means_5==2 THEN '02自転車'
        WHEN ms2611.means_5==3 THEN '03レンタサイクル'
        WHEN ms2611.means_5==4 THEN '04バイク'
        WHEN ms2611.means_5==5 THEN '05鉄道'
        WHEN ms2611.means_5==6 THEN '06路面電車'
        WHEN ms2611.means_5==7 THEN '07バス'
        WHEN ms2611.means_5==8 THEN '08高速バス'
        WHEN ms2611.means_5==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_5==10 THEN '10自家用車'
        WHEN ms2611.means_5==11 THEN '11貨物車'
        WHEN ms2611.means_5==12 THEN '12レンタカー'
        WHEN ms2611.means_5==13 THEN '13タクシー'
        WHEN ms2611.means_5==14 THEN '14その他'
        ELSE NULL
    END as means_5,
    CASE
        WHEN ms2611.means_6==1 THEN '01徒歩'
        WHEN ms2611.means_6==2 THEN '02自転車'
        WHEN ms2611.means_6==3 THEN '03レンタサイクル'
        WHEN ms2611.means_6==4 THEN '04バイク'
        WHEN ms2611.means_6==5 THEN '05鉄道'
        WHEN ms2611.means_6==6 THEN '06路面電車'
        WHEN ms2611.means_6==7 THEN '07バス'
        WHEN ms2611.means_6==8 THEN '08高速バス'
        WHEN ms2611.means_6==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_6==10 THEN '10自家用車'
        WHEN ms2611.means_6==11 THEN '11貨物車'
        WHEN ms2611.means_6==12 THEN '12レンタカー'
        WHEN ms2611.means_6==13 THEN '13タクシー'
        WHEN ms2611.means_6==14 THEN '14その他'
        ELSE NULL
    END as means_6,
    CASE
        WHEN ms2611.means_7==1 THEN '01徒歩'
        WHEN ms2611.means_7==2 THEN '02自転車'
        WHEN ms2611.means_7==3 THEN '03レンタサイクル'
        WHEN ms2611.means_7==4 THEN '04バイク'
        WHEN ms2611.means_7==5 THEN '05鉄道'
        WHEN ms2611.means_7==6 THEN '06路面電車'
        WHEN ms2611.means_7==7 THEN '07バス'
        WHEN ms2611.means_7==8 THEN '08高速バス'
        WHEN ms2611.means_7==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_7==10 THEN '10自家用車'
        WHEN ms2611.means_7==11 THEN '11貨物車'
        WHEN ms2611.means_7==12 THEN '12レンタカー'
        WHEN ms2611.means_7==13 THEN '13タクシー'
        WHEN ms2611.means_7==14 THEN '14その他'
        ELSE NULL
    END as means_7,
    CASE
        WHEN ms2611.means_8==1 THEN '01徒歩'
        WHEN ms2611.means_8==2 THEN '02自転車'
        WHEN ms2611.means_8==3 THEN '03レンタサイクル'
        WHEN ms2611.means_8==4 THEN '04バイク'
        WHEN ms2611.means_8==5 THEN '05鉄道'
        WHEN ms2611.means_8==6 THEN '06路面電車'
        WHEN ms2611.means_8==7 THEN '07バス'
        WHEN ms2611.means_8==8 THEN '08高速バス'
        WHEN ms2611.means_8==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_8==10 THEN '10自家用車'
        WHEN ms2611.means_8==11 THEN '11貨物車'
        WHEN ms2611.means_8==12 THEN '12レンタカー'
        WHEN ms2611.means_8==13 THEN '13タクシー'
        WHEN ms2611.means_8==14 THEN '14その他'
        ELSE NULL
    END as means_8,
    if(ms2611.embarked_station!=9999,ms2611.embarked_station,NULL) as embarked_station_code,
    station1.station_name as embarked_station_name,
    if(ms2611.disembarked_station!=9999,ms2611.disembarked_station,NULL) as disembarked_station_code,
    station2.station_name as disembarked_station_name,
    CASE
        WHEN ms2611.parking_bike_1==1 THEN '道路上・歩道上の駐輪場所'
        WHEN ms2611.parking_bike_1==2 THEN '月極の駐輪場(道路外)'
        WHEN ms2611.parking_bike_1==3 THEN '時間貸しの駐輪場(道路外)'
        WHEN ms2611.parking_bike_1==4 THEN '目的地の施設の駐輪場(自宅を含む)'
        WHEN ms2611.parking_bike_1==5 THEN '駐輪利用なし'
        ELSE NULL
    END as parking_bike_1,
    CASE
        WHEN ms2611.parking_bike_2==1 THEN '道路上・歩道上の駐輪場所'
        WHEN ms2611.parking_bike_2==2 THEN '月極の駐輪場(道路外)'
        WHEN ms2611.parking_bike_2==3 THEN '時間貸しの駐輪場(道路外)'
        WHEN ms2611.parking_bike_2==4 THEN '目的地の施設の駐輪場(自宅を含む)'
        WHEN ms2611.parking_bike_2==5 THEN '駐輪利用なし'
        ELSE NULL
    END as parking_bike_2,
    CASE
        WHEN ms2611.is_driving==1 THEN TRUE
        WHEN ms2611.is_driving==2 THEN FALSE
        ELSE NULL
    END as is_driving,
    CASE
        WHEN ms2611.is_highway==1 THEN TRUE
        WHEN ms2611.is_highway==2 THEN FALSE
        ELSE NULL
    END as is_highway,
    CASE
        WHEN ms2611.parking_car==1 THEN 'パーキングメーター'
        WHEN ms2611.parking_car==2 THEN '月極の駐車場(道路外)'
        WHEN ms2611.parking_car==3 THEN '時間貸しの駐車場(道路外)'
        WHEN ms2611.parking_car==4 THEN '目的地の施設駐車場(自宅を含む)'
        WHEN ms2611.parking_car==5 THEN '駅前広場内の駐車場所'
        WHEN ms2611.parking_car==6 THEN '駐車利用なし'
        ELSE NULL
    END as parking_car,
    ms2611.weights as weights,
    CASE
        WHEN format('{:s}',ms2611.household_type)[1]=='1' THEN '単身世帯'
        WHEN format('{:s}',ms2611.household_type)[1]=='2' THEN '夫婦のみ世帯'
        WHEN format('{:s}',ms2611.household_type)[1]=='3' THEN '2世代世帯'
        WHEN format('{:s}',ms2611.household_type)[1]=='4' THEN '3世代以上世帯'
        WHEN format('{:s}',ms2611.household_type)[1]=='5' THEN 'その他の世帯'
        ELSE NULL
    END as household_type,
    CASE
        WHEN format('{:s}',ms2611.household_type)[2]=='1' THEN '0~6歳'
        WHEN format('{:s}',ms2611.household_type)[2]=='2' THEN '7~9歳'
        WHEN format('{:s}',ms2611.household_type)[2]=='3' THEN '10~12歳'
        WHEN format('{:s}',ms2611.household_type)[2]=='4' THEN '13~15歳'
        WHEN format('{:s}',ms2611.household_type)[2]=='5' THEN '16~18歳'
        WHEN format('{:s}',ms2611.household_type)[2]=='6' THEN '19~22歳'
        WHEN format('{:s}',ms2611.household_type)[2]=='7' THEN '23~30歳'
        WHEN format('{:s}',ms2611.household_type)[2]=='8' THEN '31~64歳'
        WHEN format('{:s}',ms2611.household_type)[2]=='9' THEN '65歳~'
        ELSE NULL
    END as household_youngest,
    CASE
        WHEN format('{:s}',ms2611.household_type)[3]=='0' THEN 0
        WHEN format('{:s}',ms2611.household_type)[3]=='1' THEN 1
        WHEN format('{:s}',ms2611.household_type)[3]=='2' THEN 2
        WHEN format('{:s}',ms2611.household_type)[3]=='3' THEN 3
        WHEN format('{:s}',ms2611.household_type)[3]=='4' THEN 4
        WHEN format('{:s}',ms2611.household_type)[3]=='5' THEN 5
        WHEN format('{:s}',ms2611.household_type)[3]=='6' THEN 6
        WHEN format('{:s}',ms2611.household_type)[3]=='7' THEN 7
        WHEN format('{:s}',ms2611.household_type)[3]=='8' THEN 8
        WHEN format('{:s}',ms2611.household_type)[3]=='9' THEN 9
        ELSE NULL
    END as household_need_support,
    CASE
        WHEN format('{:s}',ms2611.household_type)[4]=='0' THEN 0
        WHEN format('{:s}',ms2611.household_type)[4]=='1' THEN 1
        WHEN format('{:s}',ms2611.household_type)[4]=='2' THEN 2
        WHEN format('{:s}',ms2611.household_type)[4]=='3' THEN 3
        WHEN format('{:s}',ms2611.household_type)[4]=='4' THEN 4
        WHEN format('{:s}',ms2611.household_type)[4]=='5' THEN 5
        WHEN format('{:s}',ms2611.household_type)[4]=='6' THEN 6
        WHEN format('{:s}',ms2611.household_type)[4]=='7' THEN 7
        WHEN format('{:s}',ms2611.household_type)[4]=='8' THEN 8
        WHEN format('{:s}',ms2611.household_type)[4]=='9' THEN 9
        ELSE NULL
    END as household_elder,
    household.member_male as member_male,
    household.member_female as member_female,
    household.member_under_15th as member_under_15th,
    household.member_working_age as member_working_age,
    household.member_over_65th as member_over_65th,
    household.member_over_75th as member_over_75th,
    household.member_worker as member_worker,
    household.member_student as member_student,
    household.member_other as member_other,
    household.member_regular_worker as member_regular_worker,
    household.member_irregular_worker as member_irregular_worker,
    household.member_primary_industry as member_primary_industry,
    household.member_secondary_industry as member_secondary_industry,
    household.member_tertiary_industry as member_tertiary_industry,
    household.member_driver as member_driver,
    household.member_need_suppurt as member_need_suppurt,
    household.member_bedridden as member_bedridden,
    ms2611.personal_number as personal_number,
    CASE
        WHEN ms2611.purpose_origin==1 THEN '01出勤・帰社'
        WHEN ms2611.purpose_origin==2 THEN '02登校・帰校'
        WHEN ms2611.purpose_origin==3 THEN '03日用品の買物'
        WHEN ms2611.purpose_origin==4 THEN '04日用品以外の買物'
        WHEN ms2611.purpose_origin==5 THEN '05食事・社交'
        WHEN ms2611.purpose_origin==6 THEN '06文化活動'
        WHEN ms2611.purpose_origin==7 THEN '07通院・リハビリ'
        WHEN ms2611.purpose_origin==8 THEN '08デイサービス'
        WHEN ms2611.purpose_origin==9 THEN '09他者の用事のつきそい'
        WHEN ms2611.purpose_origin==10 THEN '10他者の送り迎え'
        WHEN ms2611.purpose_origin==11 THEN '11塾・習い事・学習'
        WHEN ms2611.purpose_origin==12 THEN '12散歩・ジョギング・運動'
        WHEN ms2611.purpose_origin==13 THEN '13観光・行楽・レジャー'
        WHEN ms2611.purpose_origin==14 THEN '14地域活動・ボランティア'
        WHEN ms2611.purpose_origin==15 THEN '15その他の私用'
        WHEN ms2611.purpose_origin==16 THEN '16打合せ・会議・商談'
        WHEN ms2611.purpose_origin==17 THEN '17販売・配達・仕入・購入先'
        WHEN ms2611.purpose_origin==18 THEN '18その他の業務'
        WHEN ms2611.purpose_origin==19 THEN '19帰宅'
        WHEN ms2611.purpose_origin==20 THEN '20私用'
        ELSE NULL
    END as purpose_origin,
    CASE
        WHEN ms2611.purpose_destination==1 THEN '01出勤・帰社'
        WHEN ms2611.purpose_destination==2 THEN '02登校・帰校'
        WHEN ms2611.purpose_destination==3 THEN '03日用品の買物'
        WHEN ms2611.purpose_destination==4 THEN '04日用品以外の買物'
        WHEN ms2611.purpose_destination==5 THEN '05食事・社交'
        WHEN ms2611.purpose_destination==6 THEN '06文化活動'
        WHEN ms2611.purpose_destination==7 THEN '07通院・リハビリ'
        WHEN ms2611.purpose_destination==8 THEN '08デイサービス'
        WHEN ms2611.purpose_destination==9 THEN '09他者の用事のつきそい'
        WHEN ms2611.purpose_destination==10 THEN '10他者の送り迎え'
        WHEN ms2611.purpose_destination==11 THEN '11塾・習い事・学習'
        WHEN ms2611.purpose_destination==12 THEN '12散歩・ジョギング・運動'
        WHEN ms2611.purpose_destination==13 THEN '13観光・行楽・レジャー'
        WHEN ms2611.purpose_destination==14 THEN '14地域活動・ボランティア'
        WHEN ms2611.purpose_destination==15 THEN '15その他の私用'
        WHEN ms2611.purpose_destination==16 THEN '16打合せ・会議・商談'
        WHEN ms2611.purpose_destination==17 THEN '17販売・配達・仕入・購入先'
        WHEN ms2611.purpose_destination==18 THEN '18その他の業務'
        WHEN ms2611.purpose_destination==19 THEN '19帰宅'
        WHEN ms2611.purpose_destination==20 THEN '20私用'
        ELSE NULL
    END as purpose_destination,
    CASE
        WHEN ms2611.purpose_1==1 THEN '自宅-自宅'
        WHEN ms2611.purpose_1==2 THEN '自宅-勤務'
        WHEN ms2611.purpose_1==3 THEN '自宅-業務'
        WHEN ms2611.purpose_1==4 THEN '自宅-通学'
        WHEN ms2611.purpose_1==5 THEN '自宅-買物'
        WHEN ms2611.purpose_1==6 THEN '自宅-私事'
        WHEN ms2611.purpose_1==7 THEN '勤務-自宅'
        WHEN ms2611.purpose_1==8 THEN '業務-自宅'
        WHEN ms2611.purpose_1==9 THEN '通学-自宅'
        WHEN ms2611.purpose_1==10 THEN '買物-自宅'
        WHEN ms2611.purpose_1==11 THEN '私事-自宅'
        WHEN ms2611.purpose_1==12 THEN '勤務・業務-勤務'
        WHEN ms2611.purpose_1==13 THEN '勤務・業務-業務'
        WHEN ms2611.purpose_1==14 THEN '私事-自宅'
        WHEN ms2611.purpose_1==15 THEN '私事-業務'
        WHEN ms2611.purpose_1==16 THEN '通学'
        WHEN ms2611.purpose_1==17 THEN '買物'
        WHEN ms2611.purpose_1==18 THEN '私事'
        ELSE NULL
    END as purpose_1,
    CASE
        WHEN ms2611.purpose_2==1 THEN '通勤'
        WHEN ms2611.purpose_2==2 THEN '通学'
        WHEN ms2611.purpose_2==3 THEN '業務'
        WHEN ms2611.purpose_2==4 THEN '自宅発私事'
        WHEN ms2611.purpose_2==5 THEN '帰宅'
        WHEN ms2611.purpose_2==6 THEN '業務'
        WHEN ms2611.purpose_2==7 THEN 'その他発私事'
        ELSE NULL
    END as purpose_2,
    CASE
        WHEN ms2611.purpose_3==1 THEN '通勤'
        WHEN ms2611.purpose_3==2 THEN '通学'
        WHEN ms2611.purpose_3==3 THEN '業務'
        WHEN ms2611.purpose_3==4 THEN '帰宅'
        WHEN ms2611.purpose_3==5 THEN '私事'
        ELSE NULL
    END as purpose_3,
    CASE
        WHEN ms2611.means_representative_0==1 THEN '01徒歩'
        WHEN ms2611.means_representative_0==2 THEN '02自転車'
        WHEN ms2611.means_representative_0==3 THEN '03レンタサイクル'
        WHEN ms2611.means_representative_0==4 THEN '04バイク'
        WHEN ms2611.means_representative_0==5 THEN '05鉄道'
        WHEN ms2611.means_representative_0==6 THEN '06路面電車'
        WHEN ms2611.means_representative_0==7 THEN '07バス'
        WHEN ms2611.means_representative_0==8 THEN '08高速バス'
        WHEN ms2611.means_representative_0==9 THEN '09自家用・貸切バス'
        WHEN ms2611.means_representative_0==10 THEN '10自家用車'
        WHEN ms2611.means_representative_0==11 THEN '11貨物車'
        WHEN ms2611.means_representative_0==12 THEN '12レンタカー'
        WHEN ms2611.means_representative_0==13 THEN '13タクシー'
        WHEN ms2611.means_representative_0==14 THEN '14その他'
        ELSE NULL
    END as means_representative_0,
    CASE
        WHEN ms2611.means_representative_1==1 THEN '鉄道'
        WHEN ms2611.means_representative_1==2 THEN '路面電車'
        WHEN ms2611.means_representative_1==3 THEN 'バス'
        WHEN ms2611.means_representative_1==4 THEN '高速バス'
        WHEN ms2611.means_representative_1==5 THEN '自家用車'
        WHEN ms2611.means_representative_1==6 THEN '貨物車'
        WHEN ms2611.means_representative_1==7 THEN 'レンタカー'
        WHEN ms2611.means_representative_1==8 THEN '自家用・貸切バス'
        WHEN ms2611.means_representative_1==9 THEN 'タクシー'
        WHEN ms2611.means_representative_1==10 THEN 'バイク'
        WHEN ms2611.means_representative_1==11 THEN 'レンタサイクル'
        WHEN ms2611.means_representative_1==12 THEN '自転車'
        WHEN ms2611.means_representative_1==13 THEN '徒歩'
        WHEN ms2611.means_representative_1==14 THEN 'その他'
        ELSE NULL
    END as means_representative_1,
    CASE
        WHEN ms2611.means_representative_2==1 THEN '鉄道'
        WHEN ms2611.means_representative_2==2 THEN 'バス'
        WHEN ms2611.means_representative_2==3 THEN '自動車'
        WHEN ms2611.means_representative_2==4 THEN 'バイク'
        WHEN ms2611.means_representative_2==5 THEN '自転車'
        WHEN ms2611.means_representative_2==6 THEN '徒歩'
        WHEN ms2611.means_representative_2==7 THEN 'その他'
        ELSE NULL
    END as means_representative_2,
    CASE
        WHEN ms2611.means_representative_3==1 THEN '鉄道'
        WHEN ms2611.means_representative_3==2 THEN 'バス'
        WHEN ms2611.means_representative_3==3 THEN '自動車'
        WHEN ms2611.means_representative_3==4 THEN 'バイク・自転車・徒歩'
        WHEN ms2611.means_representative_3==5 THEN 'その他'
        ELSE NULL
    END as means_representative_3,
    if(ms2611.travel_minutes!=9999,ms2611.travel_minutes,NULL) as travel_minutes,
    if(ms2611.stay_mitutes!=9999,ms2611.stay_mitutes,NULL) as stay_mitutes,
    ms2611.embarked_type as embarked_type,
    if(ms2611.embarked_code!=9999,ms2611.embarked_code,NULL) as embarked_code,
    station3.station_name as embarked_main_station,
    ms2611.embarked_zcode as embarked_zcode,
    CASE
        WHEN ms2611.embarked_access==1 THEN '01徒歩'
        WHEN ms2611.embarked_access==2 THEN '02自転車'
        WHEN ms2611.embarked_access==3 THEN '03レンタサイクル'
        WHEN ms2611.embarked_access==4 THEN '04バイク'
        WHEN ms2611.embarked_access==7 THEN '07バス'
        WHEN ms2611.embarked_access==8 THEN '08高速バス'
        WHEN ms2611.embarked_access==9 THEN '09自家用・貸切バス'
        WHEN ms2611.embarked_access==10 THEN '10自家用車'
        WHEN ms2611.embarked_access==11 THEN '11貨物車'
        WHEN ms2611.embarked_access==12 THEN '12レンタカー'
        WHEN ms2611.embarked_access==13 THEN '13タクシー'
        WHEN ms2611.embarked_access==14 THEN '14その他'
        ELSE NULL
    END as embarked_access,
    ms2611.disembarked_type as disembarked_type,
    if(ms2611.disembarked_code!=9999,ms2611.disembarked_code,NULL) as disembarked_code,
    station4.station_name as disembarked_main_station,
    ms2611.disembarked_zcode as disembarked_zcode,
    CASE
        WHEN ms2611.disembarked_egress==1 THEN '01徒歩'
        WHEN ms2611.disembarked_egress==2 THEN '02自転車'
        WHEN ms2611.disembarked_egress==3 THEN '03レンタサイクル'
        WHEN ms2611.disembarked_egress==4 THEN '04バイク'
        WHEN ms2611.disembarked_egress==7 THEN '07バス'
        WHEN ms2611.disembarked_egress==8 THEN '08高速バス'
        WHEN ms2611.disembarked_egress==9 THEN '09自家用・貸切バス'
        WHEN ms2611.disembarked_egress==10 THEN '10自家用車'
        WHEN ms2611.disembarked_egress==11 THEN '11貨物車'
        WHEN ms2611.disembarked_egress==12 THEN '12レンタカー'
        WHEN ms2611.disembarked_egress==13 THEN '13タクシー'
        WHEN ms2611.disembarked_egress==14 THEN '14その他'
        ELSE NULL
    END as disembarked_egress,
FROM {{ ref("stg_ms2611") }} as ms2611
LEFT JOIN {{ ref("stg_ms2711") }} as ms2711
ON ms2611.id = ms2711.id
LEFT JOIN {{ ref("int_household") }} as household
ON ms2611.id_area = household.id_area
AND ms2611.id_lot = household.id_lot
AND ms2611.id_household = household.id_household
LEFT JOIN {{ ref("stg_station") }} as station1
ON ms2611.embarked_station == station1.station_code
LEFT JOIN {{ ref("stg_station") }} as station2
ON ms2611.disembarked_station == station2.station_code
LEFT JOIN {{ ref("stg_station") }} as station3
ON ms2611.embarked_code == station3.station_code
LEFT JOIN {{ ref("stg_station") }} as station4
ON ms2611.disembarked_code == station4.station_code