import requests
import json

response = requests.get("https://www.distance24.org/route.json?stops=Hamburg|Berlin")
url = 'https://www.distance24.org/route.json?stops='

import pandas as pd

df = pd.read_excel('../roaddistance.xlsx')

df = df.drop('Road Distance of  Major  Cities', axis=1)
df.columns = df.iloc[0]
df = df.drop(df.index[0])

f = open('../src/Heuristic.pl', 'w')

for i in range(len(df)):
    start_city = df[df.columns[0]].iloc[i]
    start_city_s = start_city.lower()
    for j in df.columns[1:]:
        end_city_s = j.lower()
        url_end = f'{start_city}|{j}'
        print(url_end)
        response = requests.get(url + url_end)
        if response.status_code != 200:
            continue
        dic = response.json()
        distance = dic['distance']
        if distance == 0:
            continue
        print(f'connect_air({start_city_s}, {end_city_s}, {distance}).')
        f.write(f'connect_air({start_city_s}, {end_city_s}, {distance}).\n')
        f.write(f'connect_air({end_city_s}, {start_city_s}, {distance}).\n')

f.close()
