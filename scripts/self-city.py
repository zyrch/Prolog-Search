import requests
import json

response = requests.get("https://www.distance24.org/route.json?stops=Hamburg|Berlin")
url = 'https://www.distance24.org/route.json?stops='

import pandas as pd

df = pd.read_excel('../roaddistance.xlsx')

df = df.drop('Road Distance of  Major  Cities', axis=1)
df.columns = df.iloc[0]
df = df.drop(df.index[0])

f = open('../src/heuristic.pl', 'a')

dic = {}
for i in df.columns[1:]:
    start_city = i.lower()
    dic[i] = 1

for i in range(len(df)):
    start_city = df[df.columns[0]].iloc[i]
    start_city_s = start_city.lower()
    dic[start_city_s] = 1;

for key in dic:
    f.write(f'connect_air({key}, {key}, 0).\n')
    
f.close()
