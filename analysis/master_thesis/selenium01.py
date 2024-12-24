#解析前の準備
import time
from selenium import webdriver
from selenium.webdriver.chrome import service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import os
from selenium.webdriver.support.ui import WebDriverWait
from selenium import webdriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

#csvファイルの読み込み
import pandas as pd
import numpy as np
# csv_data = pd.read_csv("/Users/nagampere/Library/CloudStorage/OneDrive-横浜国立大学/交通と都市研究室/全体ゼミ・研究進捗/20220909研究報告/通勤LOS算定_BLモデル2.csv", encoding="utf_8")
# url = csv_data.loc[:,"google mapsURL"]

#navitimeにアクセスする準備
CHROMEDRIVER = '/Users/nagampere/File/horkew/analysis/chromedriver_mac64/chromedriver'
chrome_service = service.Service(executable_path=CHROMEDRIVER)
driver = webdriver.Chrome(service = chrome_service)

#データの取得
for i in range(330,len(csv_data)): 
    driver.get(url[i])
    time.sleep(10)
    try:
        wait = WebDriverWait(driver, 10)
        wait.until(EC.alert_is_present())
        alert = driver.switch_to.alert
        print(alert.text + ' in ' + str(i))
        alert.accept()
    except TimeoutException:
        element00 = driver.find_element(By.CLASS_NAME, "w6VYqd") 
        if ("乗換案内を計算できませんでした" in element00.text):
            lines = element00.text.splitlines()
            print(lines[3] + " in " + str(i))
        else:
            element01 = driver.find_element(By.ID, "section-directions-trip-0")
            text01 = element01.text
            #経路状況をトレースしたstrデータを記録
            lines = text01.splitlines()
            if len(lines) >= 6:
                csv_data.loc[i,"所要時間(分)"] = lines[0]
                csv_data.loc[i,"発着時刻"] = lines[1]
                csv_data.loc[i,"利用路線"] = lines[2]
                csv_data.loc[i,"出発駅"] = lines[3]
                csv_data.loc[i,"歩行時間 費用"] = lines[4]
                #経路情報からLOSデータとしてintに変換
                #所要時間(分)
                trans_time_str =lines[0]
                if ("分" in trans_time_str):
                    if ("1 時間" in trans_time_str):
                        trans_time = int(trans_time_str.replace('1 時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                        trans_time = trans_time + 60
                    elif ("2 時間" in trans_time_str):
                        trans_time = int(trans_time_str.replace('2 時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                        trans_time = trans_time + 120
                    elif ("3 時間" in trans_time_str):
                        trans_time = int(trans_time_str.replace('3 時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                        trans_time = trans_time + 180                   
                    elif ("4 時間" in trans_time_str):
                        trans_time = int(trans_time_str.replace('4 時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                        trans_time = trans_time + 240
                    else:
                        trans_time = int(trans_time_str.replace('時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                else:
                    trans_time = int(trans_time_str.replace(' 時間','').replace('(','').replace(')','').replace(' ',''))
                    trans_time = trans_time * 60
                csv_data.loc[i,"所要時間B1(分)"] = trans_time
                #総費用(円)、歩行時間(分)
                trans_fare_walktime = lines[4]
                trans_fare_walktime = lines[4].split('円')
                trans_fare_str = trans_fare_walktime[0]
                trans_fare = int(trans_fare_str.replace('円', '').replace(',','').replace(' ',''))
                csv_data.loc[i,"総費用B1(円)"] = trans_fare
                trans_walktime_str =trans_fare_walktime[1]
                if ("1 時間" in trans_walktime_str):
                    trans_walktime = int(trans_walktime_str.replace('1 時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                    trans_walktime = trans_walktime + 60
                elif ("2 時間" in trans_walktime_str):
                    trans_walktime = int(trans_walktime_str.replace('2 時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                    trans_walktime = trans_walktime + 120
                elif ("3 時間" in trans_walktime_str):
                    trans_walktime = int(trans_walktime_str.replace('3 時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                    trans_walktime = trans_walktime + 180
                elif ("4 時間" in trans_walktime_str):
                    trans_walktime = int(trans_walktime_str.replace('4 時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                    trans_walktime = trans_walktime + 240
                else:
                    trans_walktime = int(trans_walktime_str.replace('時間','').replace('(','').replace(')','').replace('分','').replace(' ',''))
                csv_data.loc[i,"歩行時間B1(円)"] = trans_walktime
                print("Hit the trip in " + str(i))
            else: #経路検索結果が徒歩の場合
                csv_data.loc[i,"所要時間(分)"] = lines[0]
                csv_data.loc[i,"発着時刻"] = lines[1]
                csv_data.loc[i,"利用路線"] = '徒歩' + lines[2]
                csv_data.loc[i,"選択肢B1.公共交通.選択可能性"] = 0
                print("Hit the trip in " + str(i) + " by walk")
    except Exception as e:
        print(str(e) + ' Occured in '+ str(i))
    
    if (i % 10 == 9):
            csv_data.to_csv('/Users/nagampere/Library/CloudStorage/OneDrive-横浜国立大学/交通と都市研究室/全体ゼミ・研究進捗/20220909研究報告/通勤LOS算定_BLモデル04.csv', encoding="UTF-8")
    else:
        pass

#最後の仕上げ
csv_data.to_csv('/Users/nagampere/Library/CloudStorage/OneDrive-横浜国立大学/交通と都市研究室/全体ゼミ・研究進捗/20220909研究報告/通勤LOS算定_BLモデル04.csv', encoding="UTF-8")
print('All Done!!')